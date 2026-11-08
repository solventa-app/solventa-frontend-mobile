package com.solventa.solventa_mobile

import android.app.Activity
import android.app.KeyguardManager
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
 * - Android 11+ (API 30) sin bloqueo de pantalla: pantalla para crear el bloqueo (PIN, patrón o clave);
 * - Android 11+ con bloqueo y sin huella o rostro: pantalla para registrarlos;
 * - si ya tiene las dos cosas, o en Android 8 a 10: ajustes de seguridad;
 * - si el fabricante no tiene esa pantalla, los ajustes generales.
 *
 * `ACTION_BIOMETRIC_ENROLL` se cierra solo, sin abrir nada, cuando lo que pide ya está
 * cumplido (p. ej. con PIN y `DEVICE_CREDENTIAL`): por eso solo se usa si falta algo.
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
            inscripcion()?.let(::add)
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

    /** La pantalla de inscripción que falta, o `null` si no falta nada (o Android < 11). */
    private fun inscripcion(): Intent? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) return null
        val conBloqueo = actividad.getSystemService(KeyguardManager::class.java)?.isDeviceSecure ?: false
        val autenticadores = if (!conBloqueo) {
            BiometricManager.Authenticators.BIOMETRIC_STRONG or
                BiometricManager.Authenticators.DEVICE_CREDENTIAL
        } else {
            val biometria = actividad.getSystemService(BiometricManager::class.java)
                ?.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG)
            if (biometria != BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED) return null
            BiometricManager.Authenticators.BIOMETRIC_STRONG
        }
        return Intent(Settings.ACTION_BIOMETRIC_ENROLL)
            .putExtra(Settings.EXTRA_BIOMETRIC_AUTHENTICATORS_ALLOWED, autenticadores)
    }

    companion object {
        const val CANAL = "com.solventa/ajustes_seguridad"
    }
}
