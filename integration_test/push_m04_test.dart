import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/app/router.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';
import 'package:solventa_mobile/features/assistance/data/notificaciones_asistencia.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';
import 'package:solventa_mobile/features/parametric/data/datasources/cobertura_remote_datasource.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_02_celebracion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_03_detalle_indemnizacion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_04_cobertura_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/parametric_routes.dart';
import 'package:solventa_mobile/features/parametric/presentation/providers.dart';

import 'soporte/capturas.dart';

/// HU-M04 Fase 6 (KAN-259) en dispositivo: tocar el push abre la pantalla que
/// trae en `ruta`, con la app montada entera (router real, guard de sesión y
/// desbloqueo). El push de FCM no se puede disparar en un emulador sin
/// Firebase, así que se hace lo mismo que hace `PushService` al tocarlo
/// (`enrutadorActivo.go(ruta)`) y, con la app abierta, lo que hace el aviso
/// local (`FakeNotificacionesAsistencia.tocar(ruta)`).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const id = 'IND-2026-0912';
  final ruta = ParametricRoutes.celebracionCon(id);

  late MemoriaSesionStore store;
  late FakeBiometriaService biometria;
  late FakeNotificacionesAsistencia avisos;

  setUp(() {
    store = MemoriaSesionStore();
    biometria = FakeBiometriaService();
    avisos = FakeNotificacionesAsistencia();
  });

  /// Arranque en frío: un `ProviderScope` nuevo; solo sobrevive [store].
  Future<void> abrirApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          sesionStoreProvider.overrideWithValue(store),
          biometriaServiceProvider.overrideWithValue(biometria),
          sesionRemotaProvider.overrideWithValue(FakeSesionRemota()),
          fakeOnboardingProvider.overrideWithValue(
            FakeOnboardingRemoteDataSource(latencia: Duration.zero),
          ),
          coberturaRemoteDataSourceProvider.overrideWithValue(
            FakeCoberturaRemoteDataSource(latencia: Duration.zero),
          ),
          notificacionesAsistenciaProvider.overrideWithValue(avisos),
          duracionAccesoConcedidoProvider.overrideWithValue(
            const Duration(milliseconds: 300),
          ),
        ],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> iniciarSesion(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'maria@ejemplo.co');
    await tester.enterText(find.byType(TextField).at(1), 'Clave-segura-1');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
  }

  /// Bombea hasta ver [buscado]: M02-03 pasa al destino con un `Timer` real.
  Future<void> esperar(WidgetTester tester, Finder buscado) async {
    for (var i = 0; i < 50 && buscado.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  /// Lo que hace `PushService._irA` al tocar el push de FCM.
  Future<void> tocarPush(WidgetTester tester) async {
    enrutadorActivo!.go(ruta);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'con sesión: el push abre M04-02 y «Ver detalle» lleva a M04-03',
    (tester) async {
      await abrirApp(tester);
      await iniciarSesion(tester);
      expect(find.byType(SolAppShell), findsOneWidget);

      await tocarPush(tester);
      expect(find.byType(M0402CelebracionPage), findsOneWidget);
      await capturar(tester, 'M04-02 · desde el push');

      await tester.tap(find.text('Ver detalle'));
      await tester.pumpAndSettle();
      expect(find.byType(M0403DetalleIndemnizacionPage), findsOneWidget);
    },
  );

  testWidgets('desde el push: «Ver mi cobertura» lleva a M04-04', (
    tester,
  ) async {
    await abrirApp(tester);
    await iniciarSesion(tester);

    await tocarPush(tester);
    await tester.tap(find.text('Ver mi cobertura'));
    await tester.pumpAndSettle();
    expect(find.byType(M0404CoberturaPage), findsOneWidget);
  });

  testWidgets('app abierta: el aviso en primer plano abre M04-02', (
    tester,
  ) async {
    await abrirApp(tester);
    await iniciarSesion(tester);

    avisos.tocar(ruta);
    await tester.pumpAndSettle();
    expect(find.byType(M0402CelebracionPage), findsOneWidget);
  });

  testWidgets('sin sesión: el push pide el login y luego sigue a M04-02', (
    tester,
  ) async {
    await abrirApp(tester);

    await tocarPush(tester);
    expect(find.byType(M0402CelebracionPage), findsNothing);
    expect(find.text('Ingresar'), findsOneWidget);

    await iniciarSesion(tester);
    await esperar(tester, find.byType(M0402CelebracionPage));
    expect(find.byType(M0402CelebracionPage), findsOneWidget);
  });

  testWidgets(
    'sesión bloqueada: el push espera al desbloqueo y sigue a M04-02',
    (tester) async {
      await store.guardarRefresh(
        'refresh-guardado',
        DateTime.now().add(const Duration(days: 8)),
      );
      biometria.resultados.add(const NoReconocido());
      await abrirApp(tester);
      expect(find.text('No te reconocimos'), findsOneWidget);

      await tocarPush(tester);
      expect(find.byType(M0402CelebracionPage), findsNothing);

      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      await esperar(tester, find.byType(M0402CelebracionPage));
      expect(find.byType(M0402CelebracionPage), findsOneWidget);
    },
  );

  testWidgets('Mi cobertura (M04-04) se abre desde el inicio', (tester) async {
    await abrirApp(tester);
    await iniciarSesion(tester);

    final entrada = find.text('Mi cobertura');
    await tester.scrollUntilVisible(
      entrada,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(entrada);
    await tester.pumpAndSettle();
    expect(find.byType(M0404CoberturaPage), findsOneWidget);
  });
}
