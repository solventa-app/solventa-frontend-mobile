package com.solventa.solventa_mobile

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
import java.security.spec.MGF1ParameterSpec
import java.security.spec.X509EncodedKeySpec
import javax.crypto.Cipher
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
 * [ERROR_LLAVE_INVALIDADA] y Dart vuelve a pedir correo y clave. Ni el texto claro ni el cifrado se
 * registran nunca; los errores salen solo con su código.
 */
class LlaveroSesion(messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
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
                    else result.success(cifrar(alias, texto))
                }
                "descifrar" -> {
                    val cifrado = call.argument<String>("cifrado")
                    if (cifrado == null) result.error(ERROR_ARGUMENTO, null, null)
                    else result.success(descifrar(alias, cifrado))
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
        } catch (_: Exception) {
            // Sin llave que borrar: nada que hacer.
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
