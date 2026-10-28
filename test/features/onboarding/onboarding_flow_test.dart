import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/biometria_service.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

import '../../helpers/sol_test_app.dart';

void main() {
  late FakeOnboardingRemoteDataSource bff;

  Future<void> abrir(WidgetTester tester, {bool biometria = true}) async {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fakeOnboardingProvider.overrideWithValue(bff),
          esperasVerificacionProvider.overrideWithValue(const [
            Duration.zero,
            Duration.zero,
            Duration.zero,
          ]),
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

  /// M01-05b: correo y clave, y sigue a M01-06.
  Future<void> crearCuenta(
    WidgetTester tester, {
    String correo = 'maria@ejemplo.co',
  }) async {
    expect(find.text('Crea tu cuenta'), findsOneWidget);
    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), correo);
    await tester.enterText(campos.at(1), 'clave-segura-1');
    await tester.enterText(campos.at(2), 'clave-segura-1');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();
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
    await crearCuenta(tester);
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
    await crearCuenta(tester);
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
    await crearCuenta(tester);
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
      await crearCuenta(tester);
      expect(
        find.textContaining('No pudimos verificar tu documento'),
        findsOneWidget,
      );
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('Captura del documento'), findsOneWidget);
    },
  );

  testWidgets('M01-05b: un correo ya registrado se marca en el campo', (
    tester,
  ) async {
    await abrir(tester);
    await hastaPruebaDeVida(tester);
    bff.cuenta = OnboardingFixtures.correoRegistrado;
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await crearCuenta(tester);
    expect(
      find.text('Ya hay una cuenta con este correo. Usa otro.'),
      findsOneWidget,
    );
    expect(find.text('Crea tu cuenta'), findsOneWidget);
  });

  testWidgets('M01-07c sin intentos manda a soporte, no a capturar', (
    tester,
  ) async {
    await abrir(tester);
    await hastaPruebaDeVida(tester);
    bff.resultado = OnboardingFixtures.onboarding(
      estado: 'RECHAZADA',
      motivo: 'ROSTRO_NO_COINCIDE',
      intento: 3,
      intentosRestantes: 0,
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await crearCuenta(tester);
    expect(find.textContaining('Ya no quedan intentos'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

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
