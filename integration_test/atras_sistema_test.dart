import 'dart:async';

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
import 'package:solventa_mobile/features/assistance/presentation/asistencia_routes.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_routes.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_routes.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';
import 'package:solventa_mobile/features/parametric/data/datasources/cobertura_remote_datasource.dart';
import 'package:solventa_mobile/features/parametric/presentation/parametric_routes.dart';
import 'package:solventa_mobile/features/parametric/presentation/providers.dart';

/// El atrás de Android (botón o gesto) en toda la app: nunca falla ni cierra
/// la app desde una pantalla interna, aunque se haya abierto directo.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> asentar(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> abrirApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sesionStoreProvider.overrideWithValue(MemoriaSesionStore()),
          biometriaServiceProvider.overrideWithValue(FakeBiometriaService()),
          sesionRemotaProvider.overrideWithValue(FakeSesionRemota()),
          fakeOnboardingProvider.overrideWithValue(
            FakeOnboardingRemoteDataSource(latencia: Duration.zero),
          ),
          coberturaRemoteDataSourceProvider.overrideWithValue(
            FakeCoberturaRemoteDataSource(latencia: Duration.zero),
          ),
          notificacionesAsistenciaProvider.overrideWithValue(
            FakeNotificacionesAsistencia(),
          ),
          duracionAccesoConcedidoProvider.overrideWithValue(
            const Duration(milliseconds: 300),
          ),
        ],
        child: const SolventaApp(),
      ),
    );
    await asentar(tester);
  }

  String donde() =>
      enrutadorActivo!.routerDelegate.currentConfiguration.uri.toString();

  /// Abre [r] directo (sin pantalla anterior, como desde una notificación) y
  /// simula el atrás de Android: la app lo atiende y queda en el inicio.
  Future<void> atrasLlevaAlInicio(WidgetTester tester, String r) async {
    enrutadorActivo!.go(r);
    await asentar(tester);
    expect(donde(), r, reason: 'no abrió $r');

    final atendido = await tester.binding.handlePopRoute();
    await asentar(tester);

    expect(tester.takeException(), isNull, reason: 'atrás falló en $r');
    expect(atendido, isTrue, reason: 'el atrás cerraría la app en $r');
    expect(donde(), '/', reason: 'atrás desde $r');
  }

  testWidgets('sin sesión: atrás en recuperar clave abierta directo', (
    tester,
  ) async {
    await abrirApp(tester);
    await atrasLlevaAlInicio(tester, OnboardingRoutes.recuperarClave);
  });

  testWidgets('con sesión: atrás en cada pantalla interna abierta directo', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.enterText(find.byType(TextField).at(0), 'maria@ejemplo.co');
    await tester.enterText(find.byType(TextField).at(1), 'Clave-segura-1');
    await tester.tap(find.text('Ingresar'));
    await asentar(tester);

    for (final r in [
      ParametricRoutes.celebracionCon('IND-2026-0912'),
      ParametricRoutes.detalleCon('IND-2026-0912'),
      ParametricRoutes.cobertura,
      ReporteRoutes.poliza,
      ReporteRoutes.fotos,
      ReporteRoutes.relato,
      ReporteRoutes.misSiniestros,
      '/siniestros/SIN-1',
      '${AsistenciaRoutes.detalle}/ASI-1',
    ]) {
      await atrasLlevaAlInicio(tester, r);
    }
  });

  testWidgets('con sesión: entrando desde el inicio, atrás vuelve al inicio', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.enterText(find.byType(TextField).at(0), 'maria@ejemplo.co');
    await tester.enterText(find.byType(TextField).at(1), 'Clave-segura-1');
    await tester.tap(find.text('Ingresar'));
    await asentar(tester);

    for (final r in [
      OnboardingRoutes.perfil,
      ParametricRoutes.cobertura,
      ReporteRoutes.poliza,
      ReporteRoutes.misSiniestros,
      AsistenciaRoutes.solicitud,
    ]) {
      unawaited(enrutadorActivo!.push<void>(r));
      await asentar(tester);
      expect(find.byType(SolAppShell), findsNothing, reason: 'no abrió $r');

      final atendido = await tester.binding.handlePopRoute();
      await asentar(tester);

      expect(tester.takeException(), isNull, reason: 'atrás falló en $r');
      expect(atendido, isTrue, reason: 'el atrás cerraría la app en $r');
      expect(find.byType(SolAppShell), findsOneWidget, reason: r);
    }
  });
}
