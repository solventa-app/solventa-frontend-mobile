package com.solventa.solventa_mobile

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.fingerprint.FingerprintManager
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Lo que `local_auth` no dice en Android (M02-01 y M01-08 muestran «huella», «rostro» o «el bloqueo»).
 *
 * El plugin solo informa si hay biometría débil o fuerte, nunca cuál. Esta consulta aporta los tres datos con los que
 * Dart decide el método (`tipoSegunSistema` en `biometria_service.dart`):
 * - `huellaRegistrada`: el sistema confirma que hay al menos una huella registrada;
 * - `hardwareRostro`: el teléfono declara sensor de rostro o de iris, así que un rostro podría estar registrado
 *   aunque haya huella (y entonces no se puede saber cuál usará la persona);
 * - `sdk`: el nivel de API. Desde Android 10 (29) la biometría registrada sin huellas es de rostro, por descarte.
 *
 * No abre ningún diálogo ni pide permisos nuevos (`USE_FINGERPRINT` ya está en el manifiesto). Si el sistema se niega a
 * responder, devuelve un error y Dart habla de «la seguridad de tu teléfono», sin adivinar.
 */
class BiometriaNativa(
    private val contexto: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {
    init {
        MethodChannel(messenger, CANAL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "consultar") {
            result.notImplemented()
            return
        }
        try {
            result.success(
                mapOf(
                    "huellaRegistrada" to huellaRegistrada(),
                    "hardwareRostro" to hardwareRostro(),
                    "sdk" to Build.VERSION.SDK_INT,
                ),
            )
        } catch (e: SecurityException) {
            result.error(ERROR_NO_DISPONIBLE, null, null)
        }
    }

    @Suppress("DEPRECATION") // FingerprintManager sigue respondiendo en todas las versiones; es la única consulta directa.
    private fun huellaRegistrada(): Boolean {
        if (!contexto.packageManager.hasSystemFeature(PackageManager.FEATURE_FINGERPRINT)) return false
        return contexto.getSystemService(FingerprintManager::class.java)?.hasEnrolledFingerprints() ?: false
    }

    private fun hardwareRostro(): Boolean {
        val paquetes = contexto.packageManager
        return paquetes.hasSystemFeature(FEATURE_ROSTRO) || paquetes.hasSystemFeature(FEATURE_IRIS)
    }

    companion object {
        const val CANAL = "com.solventa/biometria"
        const val ERROR_NO_DISPONIBLE = "BIOMETRIA_NO_DISPONIBLE"

        // Cadenas de `PackageManager.FEATURE_FACE` y `FEATURE_IRIS` (API 29): en versiones anteriores simplemente no existen.
        private const val FEATURE_ROSTRO = "android.hardware.biometrics.face"
        private const val FEATURE_IRIS = "android.hardware.biometrics.iris"
    }
}
