import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'soporte/capturas.dart';

/// Configuración común de integration_test/ (flutter test la carga sola antes
/// de cada archivo).
///
/// Con `--dart-define=CAPTURAS=true`, toda prueba que falla deja una captura
/// de cómo quedó la pantalla en el reporte HTML de Emuladores. Cuando una
/// prueba falla, flutter_test no desmonta el árbol de widgets, así que en el
/// tearDown la pantalla sigue tal como estaba en el momento del fallo.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (capturasActivas) {
    var fallo = false;
    final reportarOriginal = reportTestException;
    reportTestException = (detalles, descripcion) {
      fallo = true;
      reportarOriginal(detalles, descripcion);
    };
    setUp(() => fallo = false);
    tearDown(() async {
      if (fallo) await capturarPantalla('Pantalla al fallar');
    });
  }
  await testMain();
}
