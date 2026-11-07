package com.solventa.solventa_mobile

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.hardware.biometrics.BiometricManager
import android.os.Build
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * «Ir a ajustes» de M01-08 y de los avisos de M02 (HU-M02, F4). Sin librería nueva:
 * - Android 11+ (API 30): pantalla para registrar huella o rostro, aceptando también el PIN del teléfono;
 * - Android 8 a 10: ajustes de seguridad (bloqueo de pantalla y huella);
 * - si el fabricante no tiene esa pantalla, los ajustes generales.
 */
class AjustesSeguridad(
    private val actividad: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {
    init {
        MethodChannel(messenger, CANAL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "abrir") {
            result.notImplemented()
            return
        }
        val intentos = buildList {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                add(
                    Intent(Settings.ACTION_BIOMETRIC_ENROLL).putExtra(
                        Settings.EXTRA_BIOMETRIC_AUTHENTICATORS_ALLOWED,
                        BiometricManager.Authenticators.BIOMETRIC_STRONG or
                            BiometricManager.Authenticators.DEVICE_CREDENTIAL,
                    ),
                )
            }
            add(Intent(Settings.ACTION_SECURITY_SETTINGS))
            add(Intent(Settings.ACTION_SETTINGS))
        }
        for (intent in intentos) {
            try {
                actividad.startActivity(intent)
                result.success(null)
                return
            } catch (_: ActivityNotFoundException) {
                // Siguiente opción.
            } catch (_: SecurityException) {
                // Siguiente opción.
            }
        }
        result.error("SIN_AJUSTES", null, null)
    }

    companion object {
        const val CANAL = "com.solventa/ajustes_seguridad"
    }
}
