import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
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

  Future<void> completarReporte(WidgetTester tester) async {
    await tester.tap(find.text('Póliza SOL-2026-000123'));
    contenedor
        .read(reporteProvider.notifier)
        .fijarFecha(DateTime(2026, 11, 4, 13));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tomar foto'));
    await tester.pumpAndSettle();
    expect(find.text('1 de 3 fotos'), findsOneWidget);
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
    expect(bff.reportes.single.fotos.single.latitud, 4.6767);
  });

  testWidgets('HU-M05: sin red reintenta sin duplicar el caso', (tester) async {
    await abrir(tester);
    bff.errorAlReportar = const ErrorRed();
    await completarReporte(tester);

    expect(find.text('No pudimos enviar tu reporte'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Recibimos tu reporte'), findsOneWidget);
    expect(bff.subidas, hasLength(1));
    expect(bff.reportes, hasLength(1));
  });
}
