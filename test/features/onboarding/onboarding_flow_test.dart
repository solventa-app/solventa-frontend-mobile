import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/biometria_service.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_consentimiento_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_verificacion_repository.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

import '../../helpers/sol_test_app.dart';

void main() {
  late FakeVerificacionRepository verificacion;

  Future<void> abrir(WidgetTester tester, {bool biometria = true}) async {
    verificacion = FakeVerificacionRepository(latencia: Duration.zero);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          consentimientoRemoteDataSourceProvider.overrideWithValue(
            const FakeConsentimientoRemoteDataSource(latencia: Duration.zero),
          ),
          fakeVerificacionProvider.overrideWithValue(verificacion),
          biometriaServiceProvider.overrideWithValue(
            FakeBiometriaService(activada: biometria),
          ),
        ],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completar registro'));
    await tester.pumpAndSettle();
  }

  Future<void> hastaPruebaDeVida(WidgetTester tester) async {
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SolConsentCheckbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capturar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Capturar'));
    await tester.pumpAndSettle();
    expect(find.text('Prueba de vida'), findsOneWidget);
  }

  testWidgets('M01-01 muestra los 3 pasos y un solo botón primario', (
    tester,
  ) async {
    await abrir(tester);
    expect(find.text('Bienvenida a Solventa'), findsOneWidget);
    expect(find.text('Prueba de vida (selfie)'), findsOneWidget);
    expect(find.text('Empezar'), findsOneWidget);
  });

  testWidgets(
    'M01-02: Continuar está deshabilitado hasta marcar el consentimiento',
    (tester) async {
      await abrir(tester);
      await tester.tap(find.text('Empezar'));
      await tester.pumpAndSettle();

      SolButton boton() => tester.widget<SolButton>(find.byType(SolButton));
      expect(boton().onPressed, isNull);
      expect(
        tester
            .widget<SolConsentCheckbox>(find.byType(SolConsentCheckbox))
            .value,
        isFalse,
      );

      await tester.tap(find.byType(SolConsentCheckbox));
      await tester.pumpAndSettle();
      expect(boton().onPressed, isNotNull);
    },
  );

  testWidgets('flujo completo: verificada → activar biometría → Home', (
    tester,
  ) async {
    await abrir(tester);
    await hastaPruebaDeVida(tester);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(
      find.text('¡Identidad verificada! Bienvenido a Solventa.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Ir a mi cuenta'));
    await tester.pumpAndSettle();
    expect(find.text('Necesitamos activar tu huella o rostro'), findsOneWidget);
    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Hola, María'), findsOneWidget);
  });

  testWidgets('M01-08 no deja seguir sin biometría activada', (tester) async {
    await abrir(tester, biometria: false);
    await hastaPruebaDeVida(tester);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ir a mi cuenta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Aún no detectamos huella o rostro en tu teléfono.'),
      findsOneWidget,
    );
    expect(find.text('Hola, María'), findsNothing);
  });

  testWidgets('desenlace «en revisión» llega a M01-07b', (tester) async {
    await abrir(tester);
    await hastaPruebaDeVida(tester);
    await tester.tap(find.textContaining('queda en revisión'));
    await tester.pumpAndSettle();
    expect(
      find.text('Estamos revisando tu identidad, te avisamos.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'desenlace rechazado llega a M01-07c y Reintentar vuelve a capturar',
    (tester) async {
      await abrir(tester);
      await hastaPruebaDeVida(tester);
      await tester.tap(find.textContaining('es rechazado'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('No pudimos verificar tu documento'),
        findsOneWidget,
      );
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('Captura del documento'), findsOneWidget);
    },
  );

  testWidgets('la píldora de idioma cambia la app a inglés', (tester) async {
    await abrir(tester);
    await tester.tap(find.byType(SolLocaleChip));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Solventa'), findsOneWidget);
    expect(find.text('EN · COP'), findsOneWidget);
  });

  testWidgets('accesibilidad de M01-01 y M01-02', (tester) async {
    await abrir(tester);
    await expectA11yGuidelines(tester, contrast: false);
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();
    await expectA11yGuidelines(tester, contrast: false);
  });
}
