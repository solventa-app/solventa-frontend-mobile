package com.solventa.solventa_mobile

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // HU-M02: refresh cifrado con una llave del Keystore atada a la autenticación del usuario.
        LlaveroSesion(flutterEngine.dartExecutor.binaryMessenger)
    }
}
