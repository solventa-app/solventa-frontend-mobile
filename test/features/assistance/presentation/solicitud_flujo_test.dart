import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/ruta_externa_service.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/prestador_mapper.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/asistencia_routes.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_02_solicitud_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_03_enviando_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_04_resultado_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_06_cancelada_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/solicitud_notifier.dart';

/// HU-M06 desde «Solicitar» (M06-02 a M06-06) con el fake del BFF, que se
/// comporta como CLAIMS con `primero_falla`: el primer envío no se confirma y
/// el reintento sí.
void main() {
  late FakeAsistenciaRemoteDataSource bff;
  late FakeRutaExternaService rutas;
  late ProviderContainer contenedor;
  late String? destino;

  final clinica = prestadorDesdeMapa(AsistenciaFixtures.prestadores.first)!;
  const origen = Coordenada(4.6760, -74.0480);

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    void ir(BuildContext context, String a) {
      destino = a;
      context.go('/');
    }

    final router = GoRouter(
      initialLocation: AsistenciaRoutes.solicitud,
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('INICIO')),
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
            onIrAlMapa: () => ir(context, 'mapa'),
            onIrAlInicio: () => ir(context, 'inicio'),
          ),
        ),
        GoRoute(
          path: AsistenciaRoutes.cancelada,
          builder: (context, _) => M0606CanceladaPage(
            onIrAlMapa: () => ir(context, 'mapa'),
            onIrAlInicio: () => ir(context, 'inicio'),
          ),
        ),
      ],
    );
    contenedor = ProviderContainer(
      overrides: [
        asistenciaRemoteDataSourceProvider.overrideWithValue(bff),
        catalogoLocalDataSourceProvider.overrideWithValue(
          MemoriaCatalogoLocalDataSource(),
        ),
        rutaExternaServiceProvider.overrideWithValue(rutas),
        duracionMinimaEnvioProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(contenedor.dispose);
    contenedor
        .read(solicitudProvider.notifier)
        .iniciar(
          PrestadorCercano(
            prestador: clinica,
            distanciaKm: 1.2,
            minutosEstimados: 6,
          ),
          origen,
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

  Future<void> elegirTipo(WidgetTester tester, String tipo) async {
    await tester.tap(find.byType(SolTextField).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(tipo).last);
    await tester.pumpAndSettle();
  }

  Future<void> enviar(WidgetTester tester) async {
    await tester.tap(find.text('Enviar solicitud'));
    await tester.pumpAndSettle();
  }

  setUp(() {
    bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero);
    rutas = FakeRutaExternaService();
    destino = null;
  });

  testWidgets('M06-02 muestra el prestador, la ubicación y el tiempo', (
    tester,
  ) async {
    await abrir(tester);
    expect(find.text('Prestador asignado'), findsOneWidget);
    expect(find.text('Clínica Norte'), findsOneWidget);
    expect(find.text('Elige una opción'), findsOneWidget);
    expect(find.textContaining('4.6760, -74.0480'), findsOneWidget);
    expect(find.textContaining('Tiempo estimado de llegada'), findsOneWidget);
  });

  testWidgets(
    'CA-M06-02: sin ubicación la dirección es obligatoria y no hay tiempo estimado',
    (tester) async {
      await abrir(tester);
      contenedor.read(solicitudProvider.notifier).iniciarConDireccion(clinica);
      await tester.pumpAndSettle();
      expect(find.textContaining('Tiempo estimado de llegada'), findsNothing);
      expect(find.textContaining('Ubicación detectada'), findsNothing);

      await elegirTipo(tester, 'Médica');
      await enviar(tester);
      expect(
        find.text('Escribe la dirección a la que debe llegar el prestador.'),
        findsOneWidget,
      );
      expect(bff.solicitudes, isEmpty);

      bff.confirmarSiempre = true;
      await tester.enterText(find.byType(TextField).last, 'Cra 45 # 22-18');
      await tester.pumpAndSettle();
      await enviar(tester);

      final entrada = bff.solicitudes.single;
      expect(entrada['direccion'], 'Cra 45 # 22-18');
      expect(entrada.containsKey('latitud'), isFalse);
      expect(
        find.textContaining('en camino a la dirección que indicaste'),
        findsOneWidget,
      );
      expect(find.textContaining('minutos'), findsNothing);
    },
  );

  testWidgets(
    'sin tipo de asistencia no envía y el error queda bajo el campo',
    (tester) async {
      await abrir(tester);
      await enviar(tester);
      expect(find.text('Elige el tipo de asistencia.'), findsOneWidget);
      expect(bff.solicitudes, isEmpty);
    },
  );

  testWidgets('un tipo que el prestador no atiende no se envía', (
    tester,
  ) async {
    await abrir(tester);
    await elegirTipo(tester, 'Mecánica');
    await enviar(tester);
    expect(
      find.text(
        'Clínica Norte no atiende este tipo de asistencia. '
        'Elige otro prestador en el mapa.',
      ),
      findsOneWidget,
    );
    expect(bff.solicitudes, isEmpty);
  });

  testWidgets(
    'no confirmada → reintentar con el mismo id → confirmada → cancelar',
    (tester) async {
      await abrir(tester);
      await elegirTipo(tester, 'Médica');
      await tester.enterText(find.byType(TextField).at(1), 'Dolor en el pecho');
      await tester.enterText(find.byType(TextField).at(2), 'Cra 45 # 22-18');
      await enviar(tester);

      // M06-04b: la causa y las dos salidas.
      expect(
        find.textContaining('No pudimos confirmar tu solicitud'),
        findsOneWidget,
      );
      expect(find.textContaining('no respondió a tiempo'), findsOneWidget);
      expect(find.text('Elegir otro prestador'), findsOneWidget);
      final primera = bff.solicitudes.single;
      expect(primera['descripcion'], 'Dolor en el pecho');
      expect(primera['direccion'], 'Cra 45 # 22-18');
      expect(primera['tipoAsistencia'], 'MEDICO');
      expect(primera['latitud'], 4.6760);

      // M06-03b → M06-04a: reenvía lo ya escrito, sin volver al formulario.
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(bff.solicitudes, hasLength(2));
      expect(bff.solicitudes.last, primera);
      expect(find.textContaining('Solicitud confirmada'), findsOneWidget);
      expect(
        find.textContaining('Llegada estimada en 6 minutos'),
        findsOneWidget,
      );

      await tester.tap(find.text('Ver en el mapa'));
      await tester.pump();
      expect(rutas.abiertas.single, clinica.ubicacion);

      // M06-05: «No, mantener» no cancela.
      await tester.tap(find.text('Cancelar asistencia'));
      await tester.pumpAndSettle();
      expect(find.text('¿Seguro que quieres cancelar?'), findsOneWidget);
      await tester.tap(find.text('No, mantener solicitud'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Solicitud confirmada'), findsOneWidget);

      await tester.tap(find.text('Cancelar asistencia'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sí, cancelar'));
      await tester.pumpAndSettle();

      // M06-06: confirmación explícita y volver a pedir.
      expect(find.textContaining('Tu solicitud fue cancelada'), findsOneWidget);
      expect(bff.asistencias[primera['idSolicitud']]!['estado'], 'CANCELADA');
      await tester.tap(find.text('Solicitar de nuevo'));
      await tester.pumpAndSettle();
      expect(find.text('INICIO'), findsOneWidget);
      expect(destino, 'mapa');
    },
  );

  testWidgets('prestador dado de baja: sin reintentar, solo elegir otro', (
    tester,
  ) async {
    bff.rechazo = 'PRESTADOR_NO_DISPONIBLE';
    await abrir(tester);
    await elegirTipo(tester, 'Médica');
    await enviar(tester);
    expect(find.textContaining('ya no está disponible'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
    await tester.tap(find.text('Elegir otro prestador'));
    await tester.pumpAndSettle();
    expect(destino, 'mapa');
  });

  testWidgets('sin conexión: mensaje sin datos técnicos y reintento', (
    tester,
  ) async {
    bff.error = const ErrorRed();
    await abrir(tester);
    await elegirTipo(tester, 'Médica');
    await enviar(tester);
    expect(find.textContaining('No tienes conexión'), findsOneWidget);
    bff
      ..error = null
      ..confirmarSiempre = true;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Solicitud confirmada'), findsOneWidget);
    // El reintento usa el mismo idSolicitud que el envío que falló.
    expect(bff.solicitudes.map((s) => s['idSolicitud']).toSet(), hasLength(1));
  });
}
