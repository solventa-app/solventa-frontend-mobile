import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/solventa_app.dart';
import 'core/design_system/solventa_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SolLocalizations.init();
  // Edge-to-edge (Android 15): las barras del sistema son transparentes y
  // los layouts aplican SafeArea.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SolventaApp());
}
