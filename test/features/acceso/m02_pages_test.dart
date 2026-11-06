import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/biometria/biometria_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';
import 'package:solventa_mobile/features/acceso/presentation/pages/m02_01_desbloqueo_page.dart';
import 'package:solventa_mobile/features/acceso/presentation/pages/m02_03_acceso_concedido_page.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/onboarding.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';

import 'acceso_test_utils.dart';

/// HU-M02: M02-01, M02-01a y M02-03 en sus estados (§3.6 del plan).
void main() {
  late FakeBiometriaService biometria;
  late StoreProgramable store;
  late FakeSesionRemota remota;
  late GestorSesion gestor;
  late OnboardingEspia onboarding;

  setUp(() async {
    biometria = FakeBiometriaService();
    store = StoreProgramable();
    remota = FakeSesionRemota();
    gestor = GestorSesion(store: store, remota: remota);
    await store.guardarRefresh('refresh-0', DateTime.utc(2099));
  });

  Future<ProviderContainer> montar(
    WidgetTester tester,
    Widget page, {
    double textScale = 1,
    double ancho = 390,
    bool reducirAnimaciones = false,
  }) async {
    tester.view.physicalSize = Size(ancho, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        biometriaServiceProvider.overrideWithValue(biometria),
        gestorSesionProvider.overrideWithValue(gestor),
        onboardingProvider.overrideWith(() => onboarding = OnboardingEspia()),
        duracionAccesoConcedidoProvider.overrideWithValue(
          const Duration(milliseconds: 300),
        ),
      ],
    );
    addTearDown(container.dispose);
    // Arranca la fase de acceso antes de montar (lee el refresh guardado).
    container.read(accesoProvider);
    await tester.pump();
    expect(container.read(accesoProvider).fase, FaseAcceso.bloqueada);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: SolTheme.light(),
          locale: AppLocales.es,
          supportedLocales: SolLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...SolLocalizations.delegates,
          ],
          builder: (context, app) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
              disableAnimations: reducirAnimaciones,
            ),
            child: app!,
          ),
          home: page,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  group('M02-01', () {
    testWidgets('al entrar abre el diálogo y, si reconoce, concede', (
      tester,
    ) async {
      final c = await montar(tester, const M0201DesbloqueoPage());

      expect(biometria.autenticaciones, [false]);
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
    });

    testWidgets('muestra la tarjeta de Figma sin abrir el diálogo', (
      tester,
    ) async {
      await montar(tester, const M0201DesbloqueoPage(autoIniciar: false));

      expect(find.text('Solventa'), findsOneWidget);
      expect(find.text('Desbloquea tu cuenta'), findsOneWidget);
      expect(find.text('Huella o rostro'), findsOneWidget);
      expect(find.text('Usar PIN del teléfono'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Desbloquear con huella o rostro'),
        findsOne,
      );
      expect(find.byType(SolLocaleChip), findsOneWidget);
      expect(biometria.autenticaciones, isEmpty);
    });

    testWidgets('el sensor abre el diálogo de biometría', (tester) async {
      biometria.resultados.add(const Cancelado());
      await montar(tester, const M0201DesbloqueoPage(autoIniciar: false));

      await tester.tap(
        find.bySemanticsLabel('Desbloquear con huella o rostro'),
      );
      await tester.pumpAndSettle();

      expect(biometria.autenticaciones, [false]);
      expect(find.byType(SolStatusBanner), findsNothing);
    });

    testWidgets('«Usar PIN del teléfono» abre el diálogo con PIN (D2)', (
      tester,
    ) async {
      final c = await montar(
        tester,
        const M0201DesbloqueoPage(autoIniciar: false),
      );

      await tester.tap(find.text('Usar PIN del teléfono'));
      await tester.pumpAndSettle();

      expect(biometria.autenticaciones, [true]);
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
    });

    testWidgets('bloqueo temporal: aviso', (tester) async {
      biometria.resultados.add(const BloqueoTemporal());
      await montar(tester, const M0201DesbloqueoPage());

      expect(find.textContaining('demasiados intentos'), findsOneWidget);
      expect(find.text('Usar PIN del teléfono'), findsOneWidget);
    });

    testWidgets('sin red: aviso con Reintentar, sin pedir huella de nuevo', (
      tester,
    ) async {
      remota.errorRed = const ErrorRed();
      final c = await montar(tester, const M0201DesbloqueoPage());

      expect(find.textContaining('No hay conexión'), findsOneWidget);
      remota.errorRed = null;
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
      expect(biometria.autenticaciones, [false]);
    });

    testWidgets('sin bloqueo de pantalla: Ajustes y correo, sensor inactivo', (
      tester,
    ) async {
      biometria.estadoActual = EstadoBiometria.sinBloqueoPantalla;
      final c = await montar(tester, const M0201DesbloqueoPage());

      expect(find.textContaining('no tiene bloqueo de pantalla'), findsOne);
      await tester.tap(find.text('Ir a ajustes'));
      await tester.pumpAndSettle();
      expect(biometria.aperturasAjustes, 1);

      await tester.tap(find.text('Ingresar con correo y clave'));
      await tester.pumpAndSettle();
      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(onboarding.cierres, 1);
    });

    testWidgets('al volver de Ajustes se quita el aviso', (tester) async {
      biometria.estadoActual = EstadoBiometria.sinBloqueoPantalla;
      await montar(tester, const M0201DesbloqueoPage());

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(find.byType(SolStatusBanner), findsNothing);
    });

    testWidgets('texto al 200 % en 360 dp sin desbordes', (tester) async {
      biometria.resultados.add(const BloqueoTemporal());
      await montar(
        tester,
        const M0201DesbloqueoPage(),
        textScale: 2,
        ancho: 360,
      );

      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.text('Usar PIN del teléfono'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Usar PIN del teléfono'), findsOneWidget);
    });
  });

  group('M02-01a', () {
    testWidgets('no reconocida: título, Reintentar y PIN del teléfono', (
      tester,
    ) async {
      biometria.resultados.add(const NoReconocido());
      final c = await montar(tester, const M0201DesbloqueoPage());

      expect(find.text('No te reconocimos'), findsOneWidget);
      expect(find.textContaining('No pudimos verificar'), findsOneWidget);

      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(biometria.autenticaciones, [false, false]);
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
    });

    testWidgets('Usar PIN del teléfono desde M02-01a', (tester) async {
      biometria.resultados.add(const NoReconocido());
      await montar(tester, const M0201DesbloqueoPage());

      await tester.tap(find.text('Usar PIN del teléfono'));
      await tester.pumpAndSettle();

      expect(biometria.autenticaciones, [false, true]);
    });

    testWidgets('el disparador de demo lleva a M02-01a', (tester) async {
      await montar(tester, const M0201DesbloqueoPage(autoIniciar: false));

      await tester.tap(find.textContaining('Simular que no reconoce'));
      await tester.pumpAndSettle();

      expect(find.text('No te reconocimos'), findsOneWidget);
    });
  });

  group('M02-03', () {
    Future<ProviderContainer> concedida(
      WidgetTester tester, {
      bool reducirAnimaciones = false,
      bool autoAvanzar = true,
    }) async {
      final c = await montar(
        tester,
        const M0201DesbloqueoPage(),
        reducirAnimaciones: reducirAnimaciones,
      );
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            theme: SolTheme.light(),
            locale: AppLocales.es,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ...SolLocalizations.delegates,
            ],
            builder: (context, app) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(disableAnimations: reducirAnimaciones),
              child: app!,
            ),
            home: M0203AccesoConcedidoPage(autoAvanzar: autoAvanzar),
          ),
        ),
      );
      return c;
    }

    testWidgets('saluda y avanza sola al terminar la barra', (tester) async {
      final c = await concedida(tester);
      await tester.pump();

      expect(find.text('Acceso concedido'), findsOneWidget);
      expect(find.text('Hola de nuevo.'), findsOneWidget);
      expect(find.bySemanticsLabel('Entrando a tu cuenta'), findsOneWidget);
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);

      await tester.pump(const Duration(milliseconds: 300));
      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
    });

    testWidgets('con el nombre del perfil lo usa en el saludo', (tester) async {
      await concedida(tester, autoAvanzar: false);
      onboarding.state = onboarding.state.copyWith(
        perfil: const PerfilUsuario(
          id: 'u-1',
          usuario: 'maria@ejemplo.co',
          nombre: 'María',
          rol: 'CLIENTE',
          estado: 'ACTIVO',
          documentoEnmascarado: '••••••4050',
          creadoEn: '2026-10-28T15:00:00Z',
          idioma: 'ES',
          moneda: 'COP',
        ),
      );
      await tester.pump();

      expect(find.text('Hola de nuevo, María.'), findsOneWidget);
    });

    testWidgets('con «quitar animaciones» la barra aparece llena', (
      tester,
    ) async {
      await concedida(tester, reducirAnimaciones: true);
      await tester.pump();

      final barra = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(barra.value, 1);
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('el atrás del sistema no sale de M02-03', (tester) async {
      await concedida(tester, autoAvanzar: false);
      await tester.pump();

      expect(
        find.byWidgetPredicate((w) => w is PopScope && !w.canPop),
        findsOneWidget,
      );
    });
  });
}
