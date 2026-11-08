import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/core/contrato/schema.graphql.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_06_mis_siniestros_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';

/// M05-06: el cliente ve sus reportes y el estado que les dio la mesa.
void main() {
  late FakeReporteSiniestroRemoteDataSource bff;

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/siniestros',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('INICIO')),
        GoRoute(
          path: '/siniestros',
          builder: (_, _) => const M0506MisSiniestrosPage(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
        ],
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

  setUp(() {
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
  });

  testWidgets('muestra cada caso con su radicado y su estado', (tester) async {
    await abrir(tester);
    expect(find.text('SIN-2026-0987'), findsOneWidget);
    expect(find.text('En revisión'), findsOneWidget);
    expect(find.text('Aprobado'), findsOneWidget);
    expect(find.text('Rechazado'), findsOneWidget);
    expect(
      find.text('Te enviamos el motivo y cómo presentar un recurso.'),
      findsOneWidget,
    );
    expect(find.byType(SolStatusBadge), findsNWidgets(3));
  });

  testWidgets('sin reportes lo dice en lugar de quedar vacía', (tester) async {
    bff.sinHistorial = true;
    await abrir(tester);
    expect(find.text('Aún no has reportado siniestros.'), findsOneWidget);
  });

  testWidgets('el caso recién reportado aparece primero y PENDIENTE', (
    tester,
  ) async {
    bff.sinHistorial = true;
    // Un reporte por el fake, como el que hace M05-04.
    await bff.reportar(_entradaMinima());
    await abrir(tester);
    expect(find.text('SIN-2026-1001'), findsOneWidget);
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.textContaining('Lo revisaremos a más tardar'), findsOneWidget);
  });
}

Input$ReporteSiniestroInput _entradaMinima() => Input$ReporteSiniestroInput(
  idReporte: 'id-nuevo',
  polizaId: 'pol-demo-01',
  ocurridoEn: DateTime.utc(2026, 11, 4, 13),
  descripcion: 'Me chocaron por detrás en un semáforo.',
  ubicacion: Input$UbicacionReporteInput(
    descripcion: 'Cra 15 con Calle 93',
    ciudad: 'Bogotá',
    latitud: 4.6767,
    longitud: -74.0483,
  ),
  fotos: [
    Input$FotoReporteInput(
      archivoId: 'a1',
      tomadaEn: DateTime.utc(2026, 11, 4),
    ),
  ],
);
