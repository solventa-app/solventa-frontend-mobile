package com.solventa.solventa_mobile

import android.content.Context
import android.hardware.biometrics.BiometricManager
import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import android.security.keystore.UserNotAuthenticatedException
import android.util.Base64
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.InvalidAlgorithmParameterException
import java.security.KeyFactory
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.PublicKey
import java.security.UnrecoverableKeyException
import java.security.spec.MGF1ParameterSpec
import java.security.spec.X509EncodedKeySpec
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.OAEPParameterSpec
import javax.crypto.spec.PSource

/**
 * Llavero de la sesión (HU-M02, decisión D3; docs/arquitectura.md §8).
 *
 * Un par RSA-2048 en el Android Keystore por ambiente (el alias lo arma Dart con el prefijo de `API_ENV`):
 * - la llave **pública** cifra el refresh token sin pedir nada, así la app guarda el refresh rotado en
 *   segundo plano;
 * - la llave **privada** solo descifra durante [VENTANA_SEGUNDOS] después de que el usuario se autentica
 *   con biometría fuerte o con el PIN/patrón del teléfono (lo impone el hardware, no este código).
 *
 * Si el usuario quita el bloqueo de pantalla, Android invalida la llave: `descifrar` responde
 * [ERROR_LLAVE_INVALIDADA] y Dart vuelve a pedir correo y clave.
 *
 * Llave testigo (deuda D4): con la ventana de [VENTANA_SEGUNDOS] Android no invalida la llave principal
 * al registrar una huella o un rostro nuevo. Por eso, si el teléfono tiene biometría fuerte registrada,
 * junto a ella se guarda una llave AES que exige autenticación en cada uso y se invalida con cada
 * biometría nueva. Nunca se usa para cifrar nada: `descifrar` solo comprueba que siga viva (`init`
 * no pide la huella) y, si Android la invalidó, trata la sesión como invalidada. Sin biometría
 * fuerte (solo PIN) no hay testigo y todo sigue igual. Ni el texto claro ni el cifrado se
 * registran nunca; los errores salen solo con su código.
 */
class LlaveroSesion(messenger: BinaryMessenger, private val contexto: Context) : MethodChannel.MethodCallHandler {
    init {
        MethodChannel(messenger, CANAL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val alias = call.argument<String>("alias")
        if (alias.isNullOrBlank()) {
            result.error(ERROR_ARGUMENTO, null, null)
            return
        }
        try {
            when (call.method) {
                "existe" -> result.success(almacen().containsAlias(alias))
                "crear" -> {
                    crear(alias)
                    result.success(null)
                }
                "cifrar" -> {
                    val texto = call.argument<String>("texto")
                    if (texto == null) result.error(ERROR_ARGUMENTO, null, null)
                    else {
                        // Cada guardado arma el testigo si aún no existe (p. ej. si la huella se
                        // registró después de crear la sesión).
                        asegurarTestigo(alias)
                        result.success(cifrar(alias, texto))
                    }
                }
                "descifrar" -> {
                    val cifrado = call.argument<String>("cifrado")
                    if (cifrado == null) result.error(ERROR_ARGUMENTO, null, null)
                    else {
                        verificarTestigo(alias)
                        result.success(descifrar(alias, cifrado))
                    }
                }
                "borrar" -> {
                    borrar(alias)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        } catch (e: UserNotAuthenticatedException) {
            result.error(ERROR_REQUIERE_AUTENTICACION, null, null)
        } catch (e: KeyPermanentlyInvalidatedException) {
            borrar(alias)
            result.error(ERROR_LLAVE_INVALIDADA, null, null)
        } catch (e: InvalidAlgorithmParameterException) {
            // Crear una llave que exige autenticación sin bloqueo de pantalla seguro.
            result.error(ERROR_SIN_BLOQUEO, null, null)
        } catch (e: Exception) {
            result.error(ERROR_INTERNO, e.javaClass.simpleName, null)
        }
    }

    private fun almacen(): KeyStore = KeyStore.getInstance(PROVEEDOR).apply { load(null) }

    private fun crear(alias: String) {
        val especificacion = KeyGenParameterSpec.Builder(
            alias,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
        )
            .setKeySize(2048)
            .setDigests(KeyProperties.DIGEST_SHA256)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_RSA_OAEP)
            .setUserAuthenticationRequired(true)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            especificacion.setUserAuthenticationParameters(
                VENTANA_SEGUNDOS,
                KeyProperties.AUTH_BIOMETRIC_STRONG or KeyProperties.AUTH_DEVICE_CREDENTIAL,
            )
        } else {
            @Suppress("DEPRECATION")
            especificacion.setUserAuthenticationValidityDurationSeconds(VENTANA_SEGUNDOS)
        }
        KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_RSA, PROVEEDOR).apply {
            initialize(especificacion.build())
            generateKeyPair()
        }
    }

    /** Cifra con una copia en software de la pública: el Keystore no pide autenticación para esto. */
    private fun cifrar(alias: String, texto: String): String {
        val certificado = almacen().getCertificate(alias) ?: throw KeyPermanentlyInvalidatedException()
        val publica: PublicKey = KeyFactory.getInstance(KeyProperties.KEY_ALGORITHM_RSA)
            .generatePublic(X509EncodedKeySpec(certificado.publicKey.encoded))
        val cifrador = Cipher.getInstance(TRANSFORMACION).apply {
            init(Cipher.ENCRYPT_MODE, publica, OAEP)
        }
        return Base64.encodeToString(cifrador.doFinal(texto.toByteArray(Charsets.UTF_8)), Base64.NO_WRAP)
    }

    private fun descifrar(alias: String, cifrado: String): String {
        val privada = almacen().getKey(alias, null) as? PrivateKey
            ?: throw KeyPermanentlyInvalidatedException()
        val cifrador = Cipher.getInstance(TRANSFORMACION).apply {
            init(Cipher.DECRYPT_MODE, privada, OAEP)
        }
        return String(cifrador.doFinal(Base64.decode(cifrado, Base64.NO_WRAP)), Charsets.UTF_8)
    }

    private fun borrar(alias: String) {
        try {
            val almacen = almacen()
            if (almacen.containsAlias(alias)) almacen.deleteEntry(alias)
            if (almacen.containsAlias(aliasTestigo(alias))) almacen.deleteEntry(aliasTestigo(alias))
        } catch (_: Exception) {
            // Sin llave que borrar: nada que hacer.
        }
    }

    private fun aliasTestigo(alias: String) = "$alias.testigo"

    /** `true` si el teléfono tiene huella o rostro fuertes registrados (el testigo solo se puede crear así). */
    private fun hayBiometriaFuerte(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return false
        val gestor = contexto.getSystemService(BiometricManager::class.java) ?: return false
        return gestor.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG) ==
            BiometricManager.BIOMETRIC_SUCCESS
    }

    /**
     * Crea el testigo si falta y el teléfono tiene biometría fuerte. Es de mejor esfuerzo: si Android
     * no deja crearlo (p. ej. justo se quitó la huella), la sesión sigue protegida solo por la llave
     * principal.
     */
    private fun asegurarTestigo(alias: String) {
        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return
            if (almacen().containsAlias(aliasTestigo(alias)) || !hayBiometriaFuerte()) return
            val especificacion = KeyGenParameterSpec.Builder(
                aliasTestigo(alias),
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
            )
                .setKeySize(256)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setUserAuthenticationRequired(true)
                .setInvalidatedByBiometricEnrollment(true)
                // Autenticación en cada uso (duración 0): la única forma en que Android invalida la llave
                // al registrar una biometría nueva.
                .setUserAuthenticationParameters(0, KeyProperties.AUTH_BIOMETRIC_STRONG)
            KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, PROVEEDOR).apply {
                init(especificacion.build())
                generateKey()
            }
        } catch (_: Exception) {
            // Sin testigo: sigue la protección de la llave principal.
        }
    }

    /**
     * Si hay testigo, `init` falla con [KeyPermanentlyInvalidatedException] cuando Android lo invalidó
     * por una biometría nueva; el `catch` de [onMethodCall] borra todo y Dart pide correo y clave.
     * `init` no pide la huella (la autenticación se exige al cifrar, que aquí no se hace).
     */
    private fun verificarTestigo(alias: String) {
        val almacen = almacen()
        if (!almacen.containsAlias(aliasTestigo(alias))) return
        try {
            val testigo = almacen.getKey(aliasTestigo(alias), null) as? SecretKey
                ?: throw KeyPermanentlyInvalidatedException()
            Cipher.getInstance("AES/GCM/NoPadding").init(Cipher.ENCRYPT_MODE, testigo)
        } catch (e: KeyPermanentlyInvalidatedException) {
            testigoInvalidado(alias)
        } catch (_: UnrecoverableKeyException) {
            testigoInvalidado(alias)
        } catch (_: UserNotAuthenticatedException) {
            // Pide autenticación, pero la llave está viva: no es una invalidación.
        }
    }

    /**
     * Android también invalida el testigo cuando se borran todas las huellas y rostros. Eso no agrega a
     * nadie: si ya no queda biometría fuerte, el teléfono pasó a solo PIN (que desbloquea, D1) y se sigue
     * sin testigo. Si queda biometría, hubo una nueva: se invalida la sesión.
     */
    private fun testigoInvalidado(alias: String) {
        if (hayBiometriaFuerte()) throw KeyPermanentlyInvalidatedException()
        try {
            almacen().deleteEntry(aliasTestigo(alias))
        } catch (_: Exception) {
            // Ya no estaba: nada que hacer.
        }
    }

    companion object {
        const val CANAL = "com.solventa/llavero_sesion"
        const val VENTANA_SEGUNDOS = 10

        const val ERROR_ARGUMENTO = "ARGUMENTO_INVALIDO"
        const val ERROR_REQUIERE_AUTENTICACION = "REQUIERE_AUTENTICACION"
        const val ERROR_LLAVE_INVALIDADA = "LLAVE_INVALIDADA"
        const val ERROR_SIN_BLOQUEO = "SIN_BLOQUEO_PANTALLA"
        const val ERROR_INTERNO = "INTERNO"

        private const val PROVEEDOR = "AndroidKeyStore"
        private const val TRANSFORMACION = "RSA/ECB/OAEPPadding"

        // MGF1 con SHA-1: el Keystore de Android no admite otro digest para MGF1 en todas las versiones.
        private val OAEP = OAEPParameterSpec(
            "SHA-256",
            "MGF1",
            MGF1ParameterSpec.SHA1,
            PSource.PSpecified.DEFAULT,
        )
    }
}
