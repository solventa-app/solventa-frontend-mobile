import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Capturas de pantalla para el reporte HTML de Emuladores
/// (tool/reporte-emuladores.py).
///
/// `flutter test` en un dispositivo no deja sacar archivos del emulador, así
/// que cada captura sale como PNG en base64 por la salida de la prueba, en
/// líneas `@@captura|…` que el reporter JSON guarda junto a la prueba. Solo se
/// activan con `--dart-define=CAPTURAS=true` (lo pasa emuladores.yml); en
/// local y en Test Lab no hacen nada.
const bool capturasActivas = bool.fromEnvironment('CAPTURAS');

const _prefijo = '@@captura';
const _largoLinea = 4000;
var _consecutivo = 0;

/// Captura la pantalla tal como está ahora, con un nombre para el reporte
/// (p. ej. `'M05-03 · relato lleno'`).
Future<void> capturar(WidgetTester tester, String paso) async {
  if (!capturasActivas) return;
  await tester.pump();
  await tester.runAsync(() => capturarPantalla(paso));
}

/// Igual que [capturar], sin [WidgetTester]: la usa flutter_test_config.dart
/// para dejar la pantalla de una prueba que falló.
Future<void> capturarPantalla(String paso) async {
  if (!capturasActivas) return;
  try {
    final vista = RendererBinding.instance.renderViews.first;
    final capa = vista.debugLayer;
    if (capa is! OffsetLayer) return;
    final dpr = vista.flutterView.devicePixelRatio;
    // Ancho lógico x1.5: se lee bien y cada captura queda en ~100 KB.
    final escala = math.min(1.0, 1.5 / dpr);
    final imagen = await capa.toImage(vista.paintBounds, pixelRatio: escala);
    final png = await imagen.toByteData(format: ui.ImageByteFormat.png);
    imagen.dispose();
    if (png == null) return;
    final datos = base64Encode(png.buffer.asUint8List());
    final id = ++_consecutivo;
    final nombre = paso.replaceAll('|', '/').replaceAll('\n', ' ');
    final partes = (datos.length / _largoLinea).ceil();
    for (var i = 0; i < partes; i++) {
      final trozo = datos.substring(
        i * _largoLinea,
        math.min(datos.length, (i + 1) * _largoLinea),
      );
      // print y no debugPrint: debugPrint recorta y espacia las líneas largas.
      // ignore: avoid_print
      print('$_prefijo|$id|${i + 1}|$partes|$nombre|$trozo');
    }
  } on Object catch (e) {
    // La captura es evidencia, no parte de la prueba: si falla, solo se avisa.
    // ignore: avoid_print
    print('$_prefijo-error|$paso|$e');
  }
}
