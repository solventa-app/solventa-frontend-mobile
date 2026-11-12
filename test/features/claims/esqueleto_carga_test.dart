import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_01_poliza_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_06_mis_siniestros_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';

/// Mientras llegan las pólizas (M05-01) y los reportes (M05-06) se ve un skeleton con la forma de las tarjetas, no un
/// círculo girando; cuando llegan los datos, el skeleton desaparece.
void main() {
  Future<void> abrir(WidgetTester tester, Widget pagina) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/pagina',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('INICIO')),
        GoRoute(path: '/pagina', builder: (_, _) => pagina),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          reporteSiniestroRemoteDataSourceProvider.overrideWithValue(
            FakeReporteSiniestroRemoteDataSource(
              latencia: const Duration(seconds: 1),
            ),
          ),
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
    // Sin `pumpAndSettle`: el skeleton late sin parar mientras carga.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> hastaQueLleguen(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  group('M05-06 · mis siniestros', () {
    testWidgets('carga con un skeleton de tres tarjetas, sin spinner', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      await abrir(tester, const M0506MisSiniestrosPage());

      expect(find.byType(SolSkeleton), findsWidgets);
      expect(find.byType(SolCard), findsNWidgets(3));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SolLoadingState), findsNothing);
      expect(find.bySemanticsLabel('Buscando tus reportes…'), findsOneWidget);

      await hastaQueLleguen(tester);

      expect(find.byType(SolSkeleton), findsNothing);
      expect(find.text('SIN-2026-0987'), findsOneWidget);
      semantica.dispose();
    });
  });

  group('M05-01 · elegir póliza', () {
    testWidgets('carga con un skeleton de tres tarjetas, sin spinner', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      await abrir(tester, const M0501PolizaPage());

      expect(find.byType(SolSkeleton), findsWidgets);
      expect(find.byType(SolCard), findsNWidgets(3));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SolLoadingState), findsNothing);
      expect(find.bySemanticsLabel('Buscando tus pólizas…'), findsOneWidget);

      await hastaQueLleguen(tester);

      expect(find.byType(SolSkeleton), findsNothing);
      expect(find.text('Póliza SOL-2026-000123'), findsOneWidget);
      semantica.dispose();
    });
  });
}
