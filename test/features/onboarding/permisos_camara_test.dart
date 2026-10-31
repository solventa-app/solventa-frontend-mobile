import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
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

    testWidgets('sin cámara: avisa sin botón', (tester) async {
      await montar(tester, EstadoCamara.sinCamara);
      expect(find.textContaining('No encontramos una cámara'), findsOneWidget);
      expect(find.byType(SolButton), findsNothing);
    });
  });
}
