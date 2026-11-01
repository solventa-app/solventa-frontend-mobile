import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/captura_service.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';
import 'package:solventa_mobile/features/onboarding/presentation/widgets/onboarding_widgets.dart';

import '../../helpers/sol_test_app.dart';

void main() {
  group('CamaraCapturaService sin cámara', () {
    test('en dev/prod no inventa capturas: devuelve null', () async {
      final s = CamaraCapturaService();
      expect(await s.documento(), isNull);
      expect(await s.rostro(), isNull);
      expect(await s.video(), isNull);
    });

    test('en mock usa el respaldo para probar el recorrido', () async {
      final s = CamaraCapturaService(permitirRespaldo: true);
      expect((await s.documento())?.tipoContenido, 'image/jpeg');
      expect((await s.video())?.tipoContenido, 'video/mp4');
    });
  });

  group('respaldoCapturaPermitidoProvider', () {
    for (final (env, esperado) in [
      ('mock', true),
      ('local', false),
      ('dev', false),
      ('prod', false),
    ]) {
      test('API_ENV=$env → $esperado', () {
        final c = ProviderContainer(
          overrides: [apiEnvProvider.overrideWithValue(env)],
        );
        addTearDown(c.dispose);
        expect(c.read(respaldoCapturaPermitidoProvider), esperado);
      });
    }
  });

  test('limpiarCacheCapturas borra fotos y videos y deja lo demás', () async {
    final dir = await Directory.systemTemp.createTemp('sol');
    addTearDown(() => dir.delete(recursive: true));
    final foto = File('${dir.path}/CAP123.jpg')..writeAsBytesSync([1]);
    final video = File('${dir.path}/REC456.mp4')..writeAsBytesSync([2]);
    final otro = File('${dir.path}/prefs.json')..writeAsStringSync('{}');
    await limpiarCacheCapturas(directorio: () async => dir);
    expect(foto.existsSync(), isFalse);
    expect(video.existsSync(), isFalse);
    expect(otro.existsSync(), isTrue);
  });

  test('limpiarCacheCapturas no falla sin directorio de caché', () async {
    await limpiarCacheCapturas(directorio: () async => throw Exception('x'));
  });

  test('borrarTemporal elimina el archivo de la caché', () async {
    final dir = await Directory.systemTemp.createTemp('sol');
    final f = File('${dir.path}/foto.jpg')..writeAsBytesSync([1, 2, 3]);
    await borrarTemporal(f.path);
    expect(f.existsSync(), isFalse);
    await borrarTemporal(f.path); // no falla si ya no existe
  });

  group('SolLiveCameraFrame', () {
    Future<void> montar(WidgetTester tester, EstadoCamara estado) async {
      await pumpSol(
        tester,
        ProviderScope(
          overrides: [estadoCamaraForzadoProvider.overrideWithValue(estado)],
          child: Builder(
            builder: (context) => Localizations.override(
              context: context,
              locale: AppLocales.es,
              delegates: const [AppLocalizations.delegate],
              child: const SolLiveCameraFrame(
                instruction: 'Encuadra tu documento',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('permiso negado: explica y ofrece Permitir cámara', (
      tester,
    ) async {
      await montar(tester, EstadoCamara.sinPermiso);
      expect(find.text('Necesitamos acceso a tu cámara'), findsOneWidget);
      expect(find.text('Permitir cámara'), findsOneWidget);
      expect(find.text('Abrir ajustes'), findsNothing);
    });

    testWidgets('permiso bloqueado: ofrece Abrir ajustes', (tester) async {
      await montar(tester, EstadoCamara.sinPermisoPermanente);
      expect(find.textContaining('Bloqueaste el acceso'), findsOneWidget);
      expect(find.text('Abrir ajustes'), findsOneWidget);
    });

    Future<void> montarPanel(WidgetTester tester, Widget panel) async {
      await pumpSol(
        tester,
        Builder(
          builder: (context) => Localizations.override(
            context: context,
            locale: AppLocales.es,
            delegates: const [AppLocalizations.delegate],
            child: SizedBox(height: 320, child: panel),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('«Permitir cámara» vuelve a pedir el permiso', (tester) async {
      var pedidos = 0;
      await montarPanel(
        tester,
        SolPermisoCamaraPanel(bloqueado: false, onAccion: () => pedidos++),
      );
      await tester.tap(find.text('Permitir cámara'));
      expect(pedidos, 1);
    });

    testWidgets('«Abrir ajustes» abre los ajustes del sistema', (tester) async {
      var abiertos = 0;
      await montarPanel(
        tester,
        SolPermisoCamaraPanel(bloqueado: true, onAccion: () => abiertos++),
      );
      await tester.tap(find.text('Abrir ajustes'));
      expect(abiertos, 1);
    });

    testWidgets('sin cámara: avisa sin botón', (tester) async {
      await montar(tester, EstadoCamara.sinCamara);
      expect(find.textContaining('No encontramos una cámara'), findsOneWidget);
      expect(find.byType(SolButton), findsNothing);
    });
  });
}
