import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    show MapboxOptions;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/router.dart';
import 'app/solventa_app.dart';
import 'core/config/app_config.dart';
import 'core/design_system/solventa_ui.dart';
import 'core/log/limpiar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SolLocalizations.init();
  // HU-M06 (M0): el token público de Mapbox, antes de crear cualquier mapa.
  if (AppConfig.mapboxAccessToken.isNotEmpty) {
    MapboxOptions.setAccessToken(AppConfig.mapboxAccessToken);
  }
  // Edge-to-edge (Android 15): las barras del sistema son transparentes y
  // los layouts aplican SafeArea.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  if (AppConfig.sentryDsn.isEmpty) {
    runApp(SentryWidget(child: const ProviderScope(child: SolventaApp())));
    return;
  }
  await SentryFlutter.init(
    (o) {
      o.dsn = AppConfig.sentryDsn; // vacío = no envía
      o.environment = AppConfig.flavor;
      o.sendDefaultPii = false;
      o.maxRequestBodySize = MaxRequestBodySize.never;
      o.attachScreenshot = true;
      // Capturas y video legibles para reproducir el error (pedido de felipe,
      // 2026-11-21). El texto y las imágenes siguen enmascarados (regla de datos
      // personales): la calidad mejora la forma de la pantalla, no expone datos.
      o.screenshotQuality = SentryScreenshotQuality.high;
      o.beforeCaptureScreenshot = (_, _, debounce) {
        if (debounce) return false;
        return !esRutaSinCaptura(rutaActualObservada);
      };
      o.tracesSampleRate = 0.1;
      o.tracePropagationTargets
        ..clear()
        ..addAll([if (AppConfig.apiBaseUrl.isNotEmpty) AppConfig.apiBaseUrl]);
      // Video de la sesión: siempre que hay un error y, fuera de producción, en
      // todas las sesiones para tener el recorrido completo en QA.
      o.replay.quality = SentryReplayQuality.high;
      o.replay.sessionSampleRate = AppConfig.isProd ? 0.1 : 1.0;
      o.replay.onErrorSampleRate = 1.0;
      o.privacy.maskAllText = true;
      o.privacy.maskAllImages = true;
      o.beforeSend = limpiar;
      o.beforeBreadcrumb = (b, _) => b?.category == 'ui.input' ? null : b;
    },
    appRunner: () =>
        runApp(SentryWidget(child: const ProviderScope(child: SolventaApp()))),
  );
}
