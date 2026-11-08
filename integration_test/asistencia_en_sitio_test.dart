import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/ruta_externa_service.dart';
import 'package:solventa_mobile/features/assistance/presentation/asistencia_routes.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_01_prestadores_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_02_solicitud_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_03_enviando_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_04_resultado_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_06_cancelada_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/solicitud_notifier.dart';

/// HU-M06 (KAN-36) en dispositivo: del mapa de prestadores (M06-01) a la
/// asistencia confirmada y cancelada (M06-06), con el fake del BFF (contrato
/// v0.40, que simula como CLAIMS: el primer envío no se confirma). El GPS se
/// fija en Bogotá para que corra igual en los emuladores del CI y en Test Lab.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HU-M06: solicitar, reintentar, confirmar y cancelar', (
    tester,
  ) async {
    final bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero);
    final contenedor = ProviderContainer(
      overrides: [
        asistenciaRemoteDataSourceProvider.overrideWithValue(bff),
        catalogoLocalDataSourceProvider.overrideWithValue(
          MemoriaCatalogoLocalDataSource(),
        ),
        ubicacionServiceProvider.overrideWithValue(FakeUbicacionService()),
        rutaExternaServiceProvider.overrideWithValue(FakeRutaExternaService()),
        plantillaTeselasProvider.overrideWithValue(''),
        duracionMinimaEnvioProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(contenedor.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: M0601PrestadoresPage(
              onSolicitar: (cercano, origen) {
                contenedor
                    .read(solicitudProvider.notifier)
                    .iniciar(cercano, origen);
                context.push(AsistenciaRoutes.solicitud);
              },
            ),
          ),
        ),
        GoRoute(
          path: AsistenciaRoutes.solicitud,
          builder: (_, _) => const M0602SolicitudPage(),
        ),
        GoRoute(
          path: AsistenciaRoutes.enviando,
          builder: (_, _) => const M0603EnviandoPage(),
        ),
        GoRoute(
          path: AsistenciaRoutes.resultado,
          builder: (context, _) => M0604ResultadoPage(
            onIrAlMapa: () => context.go('/'),
            onIrAlInicio: () => context.go('/'),
          ),
        ),
        GoRoute(
          path: AsistenciaRoutes.cancelada,
          builder: (context, _) => M0606CanceladaPage(
            onIrAlMapa: () => context.go('/'),
            onIrAlInicio: () => context.go('/'),
          ),
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

    // M06-01 → M06-02 con el prestador más cercano.
    await tester.tap(find.text('Solicitar').first);
    await tester.pumpAndSettle();
    expect(find.text('Clínica Norte'), findsOneWidget);

    await tester.tap(find.byType(SolTextField).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Médica').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), 'Dolor en el pecho');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Enviar solicitud'));
    await tester.tap(find.text('Enviar solicitud'));
    await tester.pumpAndSettle();

    // M06-04b → M06-03b → M06-04a.
    expect(find.textContaining('No pudimos confirmar'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Solicitud confirmada'), findsOneWidget);
    expect(bff.asistencias, hasLength(1));

    // M06-05 → M06-06.
    await tester.tap(find.text('Cancelar asistencia'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí, cancelar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tu solicitud fue cancelada'), findsOneWidget);
    expect(bff.asistencias.values.single['estado'], 'CANCELADA');
  });
}
