import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/core/contrato/schema.graphql.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_01_poliza_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_02_fotos_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_03_relato_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_04_enviando_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_05_resultado_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_routes.dart';

import 'soporte/capturas.dart';

/// HU-M05 (KAN-278) en dispositivo: el recorrido completo del reporte de
/// siniestro con el fake del BFF (contrato v0.35). La cámara y el GPS se fijan
/// para que corra igual en los emuladores del CI y en Test Lab; la prueba con
/// el backend real y la cámara del emulador está en
/// docs/evidencias/2026-11-05-hu-m05-punta-a-punta.md.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FakeReporteSiniestroRemoteDataSource bff;
  late ProviderContainer contenedor;

  Future<void> abrir(WidgetTester tester) async {
    // En el emulador enterText abre el teclado real, que encoge la pantalla de
    // forma asíncrona: a veces justo antes del toque, y «Enviar reporte» queda
    // fuera de vista. Con el teclado de prueba el recorrido no depende de eso.
    tester.testTextInput.register();
    addTearDown(tester.testTextInput.unregister);
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    contenedor = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
        subidaFotoSiniestroProvider.overrideWithValue(
          FakeSubidaArchivoService(),
        ),
        ubicacionReporteProvider.overrideWithValue(FakeUbicacionService()),
        camaraReporteHabilitadaProvider.overrideWithValue(false),
        relojReporteProvider.overrideWithValue(() => DateTime(2026, 11, 4, 15)),
      ],
    );
    addTearDown(contenedor.dispose);
    final router = GoRouter(
      initialLocation: ReporteRoutes.poliza,
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('INICIO')),
        GoRoute(
          path: ReporteRoutes.poliza,
          builder: (_, _) => const M0501PolizaPage(),
        ),
        GoRoute(
          path: ReporteRoutes.fotos,
          builder: (_, _) => const M0502FotosPage(),
        ),
        GoRoute(
          path: ReporteRoutes.relato,
          builder: (_, _) => const M0503RelatoPage(),
        ),
        GoRoute(
          path: ReporteRoutes.enviando,
          builder: (_, _) => const M0504EnviandoPage(),
        ),
        GoRoute(
          path: ReporteRoutes.resultado,
          builder: (_, _) => const M0505ResultadoPage(),
        ),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: contenedor,
        child: MaterialApp.router(
          theme: SolTheme.light(),
          locale: AppLocales.es,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> completarReporte(
    WidgetTester tester, {
    String poliza = 'Póliza SOL-2026-000456',
    String? tipoAuto = 'Choque con daños que se pueden reparar',
  }) async {
    await tester.tap(find.text(poliza));
    contenedor
        .read(reporteProvider.notifier)
        .fijarFecha(DateTime(2026, 11, 4, 13));
    await tester.pumpAndSettle();
    // KAN-290: en una póliza de auto se elige qué le pasó al vehículo.
    if (tipoAuto != null) {
      await tester.ensureVisible(find.text(tipoAuto));
      await tester.pumpAndSettle();
      await tester.tap(find.text(tipoAuto));
      await tester.pumpAndSettle();
    }
    await capturar(
      tester,
      tipoAuto == null
          ? 'M05-01 · póliza y fecha'
          : 'M05-01 · póliza de auto y tipo de siniestro',
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tomar foto'));
    await tester.pumpAndSettle();
    expect(find.text('1 de 3 fotos'), findsOneWidget);
    await capturar(tester, 'M05-02 · fotos');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    final campos = find.byType(TextField);
    await tester.enterText(
      campos.at(0),
      'Me chocaron por detrás en un semáforo.',
    );
    await tester.enterText(campos.at(1), 'Cra 15 con Calle 93');
    await tester.enterText(campos.at(2), 'Bogotá');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await capturar(tester, 'M05-03 · relato');
    await tester.ensureVisible(find.text('Enviar reporte'));
    // ensureVisible solo mueve el scroll: sin este pump el tap usa la posición
    // de antes y en el emulador cae fuera del botón (o fuera de la pantalla).
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enviar reporte'));
    await tester.pumpAndSettle();
  }

  testWidgets('HU-M05: reporta el siniestro y muestra el radicado', (
    tester,
  ) async {
    await abrir(tester);
    await completarReporte(tester);

    expect(find.text('Recibimos tu reporte'), findsOneWidget);
    expect(find.textContaining('SIN-2026-1001'), findsOneWidget);
    await capturar(tester, 'M05-05 · radicado');
    expect(bff.reportes.single.fotos.single.latitud, 4.6767);
  });

  testWidgets('HU-W08: reporta un choque sobre la póliza de auto con su tipo', (
    tester,
  ) async {
    await abrir(tester);
    await completarReporte(
      tester,
      poliza: 'Póliza SOL-2026-000456',
      tipoAuto: 'Choque con daños que se pueden reparar',
    );

    expect(find.text('Recibimos tu reporte'), findsOneWidget);
    expect(
      bff.reportes.single.tipoSiniestroAuto,
      Enum$TipoSiniestroAuto.CHOQUE_PARCIAL,
    );
    expect(bff.reportes.single.polizaId, 'pol-demo-02');
  });

  testWidgets('HU-M05: sin red reintenta sin duplicar el caso', (tester) async {
    await abrir(tester);
    bff.errorAlReportar = const ErrorRed();
    await completarReporte(tester);

    expect(find.text('No pudimos enviar tu reporte'), findsOneWidget);
    await capturar(tester, 'M05-05 · sin red');
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Recibimos tu reporte'), findsOneWidget);
    expect(bff.subidas, hasLength(1));
    expect(bff.reportes, hasLength(1));
  });
}
