import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/notificaciones_reporte.dart';
import 'package:solventa_mobile/features/claims/data/preferencias_envio.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_05b_cuenta_page.dart';
import 'package:solventa_mobile/features/profile/presentation/perfil_sin_conexion.dart';

import '../features/acceso/acceso_test_utils.dart';

/// HU-M05 (plan 4.5), con la app entera: sin red y con la sesión guardada,
/// la huella entra al modo sin conexión; el router solo deja lo que vive en
/// el teléfono, y al volver la red la sesión se renueva sola.
void main() {
  late FakeBiometriaService biometria;
  late StoreProgramable store;
  late FakeSesionRemota remota;
  late GestorSesion gestor;
  late AlmacenLocalMemoria local;
  late ConectividadFalsa conectividad;
  late ProviderContainer contenedor;

  Future<void> abrir(
    WidgetTester tester, {
    bool conCuenta = true,
    TipoRed red = TipoRed.ninguna,
    bool conSesionGuardada = true,
  }) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    biometria = FakeBiometriaService();
    store = StoreProgramable();
    remota = FakeSesionRemota(errorRed: const ErrorRed());
    gestor = GestorSesion(store: store, remota: remota);
    local = AlmacenLocalMemoria();
    conectividad = ConectividadFalsa(red);
    if (conSesionGuardada) {
      await store.guardarRefresh('refresh-0', DateTime.utc(2099));
    }
    if (conCuenta) {
      await local.guardarCuenta(
        CuentaLocal(
          id: 'c1',
          nombre: 'Laura',
          verificada: true,
          ultimaConexion: DateTime.utc(2026, 11, 20, 8),
        ),
      );
    }
    contenedor = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        biometriaServiceProvider.overrideWithValue(biometria),
        gestorSesionProvider.overrideWithValue(gestor),
        onboardingProvider.overrideWith(OnboardingEspia.new),
        duracionAccesoConcedidoProvider.overrideWithValue(
          const Duration(milliseconds: 300),
        ),
        almacenLocalProvider.overrideWithValue(local),
        almacenReportesProvider.overrideWithValue(AlmacenReportesMemoria()),
        conectividadProvider.overrideWithValue(conectividad),
        sondaRedProvider.overrideWithValue(SondaFalsa()),
        notificacionesReporteProvider.overrideWithValue(
          FakeNotificacionesReporte(),
        ),
        preferenciasEnvioStoreProvider.overrideWithValue(
          MemoriaPreferenciasEnvioStore(),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: contenedor,
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Desmonta dentro de la prueba: la franja de conexión y el vigía de
  /// reportes usan temporizadores.
  Future<void> terminar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    contenedor.dispose();
    await tester.pump();
  }

  testWidgets('la huella sin red abre el inicio en modo sin conexión', (
    tester,
  ) async {
    await abrir(tester);

    expect(contenedor.read(accesoProvider).fase, FaseAcceso.sinConexion);
    expect(biometria.autenticaciones, [true]);
    expect(find.text('Hola, Laura'), findsOneWidget);
    expect(find.text('Necesita conexión'), findsNWidgets(2));
    expect(find.text('Reportar un siniestro'), findsOneWidget);
    expect(
      find.text(
        'Puedes reportar un siniestro. Se envía cuando vuelva la señal.',
      ),
      findsOneWidget,
    );
    await terminar(tester);
  });

  testWidgets('«Mis siniestros» y Mi perfil abren sin conexión', (
    tester,
  ) async {
    await abrir(tester);

    await tester.tap(find.text('Mis siniestros'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsNothing);
    expect(find.text('Mis siniestros'), findsWidgets);

    GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/perfil');
    await tester.pumpAndSettle();
    expect(find.byType(PerfilSinConexion), findsOneWidget);
    expect(find.text('Laura'), findsOneWidget);
    expect(find.text('Correo y documento'), findsOneWidget);
    await terminar(tester);
  });

  testWidgets('una pantalla que necesita al servidor vuelve al inicio', (
    tester,
  ) async {
    await abrir(tester);

    GoRouter.of(tester.element(find.byType(HomePage))).go('/m04-04');
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Hola, Laura'), findsOneWidget);
    await terminar(tester);
  });

  testWidgets('las pestañas de asistencia dicen «Necesita conexión»', (
    tester,
  ) async {
    await abrir(tester);

    await tester.tap(find.text('Asistencia'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsNothing);
    expect(find.text('Necesita conexión'), findsOneWidget);
    await terminar(tester);
  });

  testWidgets('al volver la red la sesión se renueva y el inicio se activa', (
    tester,
  ) async {
    await abrir(tester);

    remota.errorRed = null;
    conectividad.cambiar(TipoRed.wifi);
    await tester.pumpAndSettle();

    expect(contenedor.read(accesoProvider).fase, FaseAcceso.normal);
    expect(gestor.abierta, isTrue);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Necesita conexión'), findsNothing);
    expect(biometria.autenticaciones, [true]);
    await terminar(tester);
  });

  testWidgets('cerrar sesión sin conexión vuelve a «Inicia sesión»', (
    tester,
  ) async {
    await abrir(tester);

    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('¿Quieres cerrar sesión?'), findsOneWidget);
    await tester.tap(find.text('Sí, cerrar sesión'));
    await tester.pumpAndSettle();

    expect(contenedor.read(accesoProvider).fase, FaseAcceso.normal);
    expect(contenedor.read(cuentaActualProvider), isNull);
    expect(await local.cuentaActiva(), isNull);
    expect(await store.hayRefresh(), isFalse);
    expect(find.byType(M0105bCuentaPage), findsOneWidget);
    await terminar(tester);
  });

  testWidgets('sin cuenta guardada se queda en el desbloqueo con el aviso', (
    tester,
  ) async {
    await abrir(tester, conCuenta: false);

    expect(contenedor.read(accesoProvider).fase, FaseAcceso.bloqueada);
    expect(find.textContaining('No hay conexión'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
    await terminar(tester);
  });

  testWidgets('sin sesión guardada, «Inicia sesión» explica qué hace falta', (
    tester,
  ) async {
    await abrir(tester, conCuenta: false, conSesionGuardada: false);

    expect(find.byType(M0105bCuentaPage), findsOneWidget);
    expect(
      find.text(
        'Para entrar sin internet necesitas haber iniciado sesión antes en '
        'este teléfono con el bloqueo de pantalla activo.',
      ),
      findsOneWidget,
    );
    await terminar(tester);
  });
}
