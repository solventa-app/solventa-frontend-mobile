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
import 'package:solventa_mobile/features/claims/presentation/pages/m05_07_detalle_siniestro_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';

/// M05-07: el detalle de un caso, con la resolución que ve el cliente.
void main() {
  late FakeReporteSiniestroRemoteDataSource bff;

  Future<void> abrir(
    WidgetTester tester,
    String ruta, {
    DateTime Function()? ahora,
  }) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: ruta,
      routes: [
        GoRoute(
          path: '/siniestros',
          builder: (_, _) => const M0506MisSiniestrosPage(),
        ),
        GoRoute(
          path: '/siniestros/:id',
          builder: (_, state) => M0507DetalleSiniestroPage(
            id: state.pathParameters['id']!,
            ahora: ahora ?? DateTime.now,
            cadaCuanto: const Duration(seconds: 30),
          ),
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

  testWidgets('tocar un caso de la lista abre su detalle', (tester) async {
    await abrir(tester, '/siniestros');
    await tester.tap(find.text('SIN-2026-0942'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle del siniestro'), findsOneWidget);
    expect(find.text('SIN-2026-0942'), findsOneWidget);
  });

  testWidgets('un caso aprobado muestra el monto y el plazo de pago', (
    tester,
  ) async {
    await abrir(tester, '/siniestros/demo-3');
    expect(find.text('Aprobado'), findsOneWidget);
    expect(find.text('Resolución'), findsOneWidget);
    expect(find.textContaining('Indemnización aprobada: \$'), findsOneWidget);
    expect(find.textContaining('4.500.000'), findsOneWidget);
    expect(find.text('Plazo de pago: 5 días hábiles'), findsOneWidget);
  });

  testWidgets('un caso rechazado muestra el motivo y cómo pedir revisión', (
    tester,
  ) async {
    await abrir(tester, '/siniestros/demo-4');
    expect(find.text('Rechazado'), findsOneWidget);
    expect(find.text('Motivo: la evidencia no fue suficiente'), findsOneWidget);
    expect(
      find.text('Cómo pedir una revisión: Escribe a soporte con tu radicado.'),
      findsOneWidget,
    );
  });

  testWidgets('un caso en revisión no trae bloque de resolución', (
    tester,
  ) async {
    await abrir(tester, '/siniestros/demo-2');
    expect(find.text('En revisión'), findsOneWidget);
    expect(find.text('Resolución'), findsNothing);
    expect(find.text('Un perito está evaluando tu caso.'), findsOneWidget);
  });

  testWidgets('un id que no es del cliente dice que no lo encuentra', (
    tester,
  ) async {
    await abrir(tester, '/siniestros/ajeno');
    expect(find.text('No encontramos este siniestro.'), findsOneWidget);
  });

  group('plazo de revisión', () {
    // El caso reportado vence el 2026-11-06 a las 22:00 UTC (fake).
    Future<String> reportado() async {
      bff.sinHistorial = true;
      await bff.reportar(_entradaMinima());
      // El id del caso es el `idReporte` que mandó la app.
      return 'rep-detalle-1';
    }

    testWidgets('cuenta lo que queda: días, horas y minutos', (tester) async {
      final id = await reportado();
      await abrir(
        tester,
        '/siniestros/$id',
        ahora: () => DateTime.utc(2026, 11, 5, 17, 40),
      );
      expect(find.text('Tiempo restante: 1 d 4 h 20 min'), findsOneWidget);
    });

    testWidgets('el tiempo baja con el reloj', (tester) async {
      final id = await reportado();
      var ahora = DateTime.utc(2026, 11, 6, 20);
      await abrir(tester, '/siniestros/$id', ahora: () => ahora);
      expect(find.text('Tiempo restante: 2 h 0 min'), findsOneWidget);

      ahora = DateTime.utc(2026, 11, 6, 20, 30);
      await tester.pump(const Duration(seconds: 30));
      expect(find.text('Tiempo restante: 1 h 30 min'), findsOneWidget);
    });

    testWidgets('en cero avisa que está procesando y deja de contar', (
      tester,
    ) async {
      final id = await reportado();
      await abrir(
        tester,
        '/siniestros/$id',
        ahora: () => DateTime.utc(2026, 11, 6, 22, 0, 1),
      );
      expect(find.textContaining('Tiempo restante'), findsNothing);
      expect(
        find.textContaining('El plazo de revisión venció'),
        findsOneWidget,
      );
    });

    testWidgets('un caso ya resuelto no cuenta tiempo', (tester) async {
      await abrir(tester, '/siniestros/demo-3');
      expect(find.textContaining('Tiempo restante'), findsNothing);
    });
  });
}

Input$ReporteSiniestroInput _entradaMinima() => Input$ReporteSiniestroInput(
  idReporte: 'rep-detalle-1',
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
