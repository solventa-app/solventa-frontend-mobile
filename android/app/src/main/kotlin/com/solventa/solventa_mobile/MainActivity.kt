package com.solventa.solventa_mobile

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val mensajero = flutterEngine.dartExecutor.binaryMessenger
        // HU-M02: refresh cifrado con una llave del Keystore atada a la autenticación del usuario.
        LlaveroSesion(mensajero, applicationContext)
        // HU-M02: «Ir a ajustes» abre el registro de huella o los ajustes de seguridad.
        AjustesSeguridad(this, mensajero)
        // M02-01 y M01-08: qué método biométrico tiene el teléfono (`local_auth` solo dice débil o fuerte).
        BiometriaNativa(applicationContext, mensajero)
    }
}
