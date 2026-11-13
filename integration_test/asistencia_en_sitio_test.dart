import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/ruta_externa_service.dart';
import 'package:solventa_mobile/features/assistance/data/notificaciones_asistencia.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/asistencia_routes.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/asistencia_detalle_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_01_prestadores_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_02_solicitud_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_03_enviando_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_04_resultado_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_06_cancelada_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/mis_asistencias_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/solicitud_notifier.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/mapa/mapa_datos.dart';

import 'soporte/capturas.dart';

/// HU-M06 (KAN-36) en dispositivo: del mapa de prestadores (M06-01) a la
/// asistencia confirmada y cancelada (M06-06), con el fake del BFF (contrato
/// v0.40, que simula como CLAIMS: el primer envío no se confirma). El GPS se
/// fija en Bogotá para que corra igual en los emuladores del CI y en Test Lab.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Abre M06-01 con el fake del BFF y el GPS dado; devuelve el fake.
  Future<FakeAsistenciaRemoteDataSource> abrir(
    WidgetTester tester,
    FakeUbicacionService gps,
  ) async {
    final bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero);
    final contenedor = ProviderContainer(
      overrides: [
        asistenciaRemoteDataSourceProvider.overrideWithValue(bff),
        catalogoLocalDataSourceProvider.overrideWithValue(
          MemoriaCatalogoLocalDataSource(),
        ),
        ubicacionServiceProvider.overrideWithValue(gps),
        rutaExternaServiceProvider.overrideWithValue(FakeRutaExternaService()),
        motorMapaProvider.overrideWithValue(MotorMapa.falso),
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
              onSolicitar: (cercano, origen, direccionEscrita) {
                contenedor
                    .read(solicitudProvider.notifier)
                    .iniciar(
                      cercano,
                      origen,
                      direccionEscrita: direccionEscrita,
                    );
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
    return bff;
  }

  testWidgets('HU-M06: solicitar, reintentar, confirmar y cancelar', (
    tester,
  ) async {
    final bff = await abrir(tester, FakeUbicacionService());
    // M06-01 → M06-02 con el prestador más cercano.
    await tester.tap(find.text('Solicitar').first);
    await tester.pumpAndSettle();
    expect(find.text('Clínica Norte'), findsOneWidget);
    await capturar(tester, 'M06-02 · solicitud');

    await tester.tap(find.byType(SolTextField).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Médica').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), 'Dolor en el pecho');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Enviar solicitud'));
    // ensureVisible solo mueve el scroll: sin este pump el tap usa la posición
    // de antes y en el emulador cae fuera del botón (o fuera de la pantalla).
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enviar solicitud'));
    await tester.pumpAndSettle();

    // M06-04b → M06-03b → M06-04a.
    expect(find.textContaining('No pudimos confirmar'), findsOneWidget);
    await capturar(tester, 'M06-04b · sin confirmar');
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Solicitud confirmada'), findsOneWidget);
    await capturar(tester, 'M06-04a · confirmada');
    expect(bff.asistencias, hasLength(1));

    // M06-05 → M06-06.
    await tester.tap(find.text('Cancelar asistencia'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí, cancelar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tu solicitud fue cancelada'), findsOneWidget);
    await capturar(tester, 'M06-06 · cancelada');
    expect(bff.asistencias.values.single['estado'], 'CANCELADA');
  });

  testWidgets(
    'HU-M06 2.0: sin permiso, la dirección escrita y ubicada hasta la asistencia',
    (tester) async {
      final bff = await abrir(
        tester,
        FakeUbicacionService(
          resultado: const UbicacionSinPermiso(permanente: true),
        ),
      );
      expect(find.text('No tenemos tu ubicación'), findsOneWidget);
      await capturar(tester, 'M06-01 · sin permiso');

      await tester.tap(find.text('Escribir mi dirección'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Cra 45 # 22-18');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      await capturar(tester, 'M06-01 · escribir la dirección');
      await tester.tap(find.text('Cra 45 # 22-18, Bogotá, Cundinamarca'));
      await tester.pumpAndSettle();

      // El mapa funciona igual que con GPS, con el aviso de la dirección.
      expect(find.text('Usando: Cra 45 # 22-18'), findsOneWidget);
      await capturar(tester, 'M06-01 · con la dirección escrita');

      await tester.tap(find.text('Solicitar').first);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('(la dirección que escribiste)'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Enviar solicitud'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enviar solicitud'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Solicitud confirmada'), findsOneWidget);
      expect(bff.solicitudes.last['origenUbicacion'], 'DIRECCION');
      expect(bff.solicitudes.last['direccion'], 'Cra 45 # 22-18');
    },
  );

  testWidgets(
    'HU-M06 4.5: tocar la notificación de llegada abre el detalle y atrás va a Mis asistencias',
    (tester) async {
      final bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero);
      final avisos = FakeNotificacionesAsistencia();
      final contenedor = ProviderContainer(
        overrides: [
          asistenciaRemoteDataSourceProvider.overrideWithValue(bff),
          catalogoLocalDataSourceProvider.overrideWithValue(
            MemoriaCatalogoLocalDataSource(),
          ),
          notificacionesAsistenciaProvider.overrideWithValue(avisos),
          ubicacionServiceProvider.overrideWithValue(FakeUbicacionService()),
          rutaExternaServiceProvider.overrideWithValue(
            FakeRutaExternaService(),
          ),
          duracionMinimaEnvioProvider.overrideWithValue(Duration.zero),
        ],
      );
      addTearDown(contenedor.dispose);
      // Una asistencia confirmada (el reintento la confirma).
      final catalogo = await contenedor
          .read(asistenciaRepositoryProvider)
          .catalogoPrestadores();
      final clinica =
          (catalogo as Exito<CatalogoPrestadores>).valor.prestadores.first;
      final solicitud = contenedor.read(solicitudProvider.notifier)
        ..iniciar(
          PrestadorCercano(
            prestador: clinica,
            distanciaKm: 1.1,
            minutosEstimados: 6,
          ),
          const Coordenada(4.6767, -74.0483),
        );
      await solicitud.enviar();
      await solicitud.enviar();
      final id = contenedor.read(solicitudProvider).idSolicitud;
      expect(avisos.programadas, contains(id));

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: MisAsistenciasPage(
                visible: true,
                onVerDetalle: (i) =>
                    context.push(AsistenciaRoutes.detalleCon(i)),
                onSolicitar: () {},
              ),
            ),
          ),
          GoRoute(
            path: '${AsistenciaRoutes.detalle}/:id',
            builder: (context, state) => AsistenciaDetallePage(
              id: state.pathParameters['id']!,
              onBack: () => context.go('/'),
              onPedirOtra: () => context.go('/'),
            ),
          ),
        ],
      );
      await avisos.iniciar(
        alTocar: (i) => router.go(AsistenciaRoutes.detalleCon(i)),
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
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('En camino (1)'), findsOneWidget);
      await capturar(tester, 'Mis asistencias · en camino');

      // Lo que hace la app al tocar la notificación del sistema.
      avisos.tocar(id);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Tu asistencia'), findsOneWidget);
      await capturar(tester, 'Tu asistencia · desde la notificación');

      await tester.tap(find.byTooltip('Volver').first);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Mis asistencias'), findsOneWidget);
      contenedor.read(misAsistenciasProvider.notifier).pausar();
    },
  );
}
