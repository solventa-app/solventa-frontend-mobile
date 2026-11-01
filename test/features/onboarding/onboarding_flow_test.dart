import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/biometria_service.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

import '../../helpers/sol_test_app.dart';

void main() {
  late FakeOnboardingRemoteDataSource bff;

  /// M01-05b: correo y clave (cumple la regla de T17), luego el código real
  /// de M01-05c (el fake espera 123456), y sigue al inicio.
  Future<void> crearCuenta(
    WidgetTester tester, {
    String correo = 'maria@ejemplo.co',
    bool conCodigo = true,
  }) async {
    expect(find.text('Crea tu cuenta'), findsOneWidget);
    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), correo);
    await tester.enterText(campos.at(1), 'Clave-segura-1');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();
    if (!conCodigo) return;
    expect(find.text('Verifica tu correo'), findsOneWidget);
    for (final d in ['1', '2', '3', '4', '5', '6']) {
      await tester.tap(find.text(d));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

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
    if (find.text('Crea tu cuenta').evaluate().isNotEmpty) {
      await crearCuenta(tester);
    }
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
    bff.resultado = OnboardingFixtures.onboarding(estado: 'EN_REVISION');
    await tester.tap(find.text('Continuar'));
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
      bff.resultado = OnboardingFixtures.onboarding(
        estado: 'RECHAZADA',
        motivo: 'DOCUMENTO_ILEGIBLE',
        intento: 1,
        intentosRestantes: 2,
      );
      await tester.tap(find.text('Continuar'));
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

  testWidgets('M01-05b: un correo ya registrado se marca en el campo', (
    tester,
  ) async {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    bff.respuestaEnviarCodigo = {
      '__typename': 'Mutation',
      'enviarCodigoOnboarding': OnboardingFixtures.error(
        'CORREO_YA_REGISTRADO',
      ),
    };
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fakeOnboardingProvider.overrideWithValue(bff),
          esperasVerificacionProvider.overrideWithValue(const [
            Duration.zero,
            Duration.zero,
            Duration.zero,
          ]),
        ],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
    await crearCuenta(tester, conCodigo: false);
    expect(
      find.text('Ya hay una cuenta con este correo. Inicia sesión.'),
      findsOneWidget,
    );
    expect(find.text('Crea tu cuenta'), findsOneWidget);
  });

  testWidgets('M01-05b: crear cuenta e iniciar sesión no comparten campos', (
    tester,
  ) async {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [fakeOnboardingProvider.overrideWithValue(bff)],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
    await crearCuenta(tester);
    final contenedor = ProviderScope.containerOf(
      tester.element(find.byType(SolventaApp)),
    );
    await contenedor.read(onboardingProvider.notifier).cerrarSesion();
    await tester.pumpAndSettle();
    // Tras cerrar sesión la entrada abre en «Inicia sesión».
    expect(find.text('¿No tienes cuenta? Crear cuenta'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'a@b.co');
    await tester.enterText(find.byType(TextField).at(1), 'x');
    // Con una clave corta, iniciar sesión no aplica el largo de la creación.
    await tester.tap(find.text('¿No tienes cuenta? Crear cuenta'));
    await tester.pumpAndSettle();
    final campos = find.byType(TextField);
    expect(tester.widget<TextField>(campos.at(0)).controller!.text, isEmpty);
    expect(tester.widget<TextField>(campos.at(1)).controller!.text, isEmpty);
    expect(tester.widget<TextField>(campos.at(1)).obscureText, isTrue);
    await tester.tap(find.byTooltip('Mostrar clave').first);
    await tester.pump();
    expect(tester.widget<TextField>(campos.at(1)).obscureText, isFalse);
  });

  testWidgets('M01-05c: verifica código OTP de 6 dígitos enviado al correo', (
    tester,
  ) async {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fakeOnboardingProvider.overrideWithValue(bff),
          esperasVerificacionProvider.overrideWithValue(const [
            Duration.zero,
            Duration.zero,
            Duration.zero,
          ]),
        ],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
    await crearCuenta(tester, conCodigo: false);
    expect(find.text('Verifica tu correo'), findsOneWidget);
    // El reenvío espera 60 s: arranca bloqueado y sin atajos de demostración.
    expect(find.text('Reenviar en 1:00'), findsOneWidget);
    expect(find.textContaining('Simular'), findsNothing);
    await tester.pump(const Duration(seconds: 61));
    expect(find.text('Enviar otro código'), findsOneWidget);
    for (final d in ['1', '2', '3', '4', '5', '6']) {
      await tester.tap(find.text(d));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('Completar registro'), findsOneWidget);
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
    expect(find.textContaining('Ya no quedan intentos'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets(
    'la píldora de idioma cambia la app a inglés y abre el selector de moneda',
    (tester) async {
      await abrir(tester);
      await tester.tap(find.byType(SolLocaleChip));
      await tester.pumpAndSettle();
      expect(find.text('EN · COP'), findsWidgets);
      expect(find.text('Language & currency'), findsOneWidget);
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Solventa'), findsOneWidget);
      expect(find.text('EN · USD'), findsOneWidget);
    },
  );

  testWidgets('accesibilidad de M01-01 y M01-02', (tester) async {
    await abrir(tester);
    await expectA11yGuidelines(tester, contrast: false);
    await tester.tap(find.text('Empezar'));
    await tester.pumpAndSettle();
    await expectA11yGuidelines(tester, contrast: false);
  });
}
