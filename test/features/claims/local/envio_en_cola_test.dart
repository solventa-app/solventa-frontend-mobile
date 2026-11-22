import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/notificaciones_reporte.dart';
import 'package:solventa_mobile/features/claims/data/preferencias_envio.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_01_poliza_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_02_fotos_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_03_relato_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_04_enviando_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_05_resultado_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_07b_reporte_pendiente_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_routes.dart';
import 'package:solventa_mobile/features/claims/presentation/vigia_reportes.dart';

/// HU-M05 (sin conexión, plan 4.4 y 4.5): con cuenta, el reporte se envía por
/// la cola. Sin red o esperando Wi-Fi queda guardado y sale solo después.
void main() {
  late FakeReporteSiniestroRemoteDataSource bff;
  late FakeUbicacionService gps;
  late AlmacenReportesMemoria almacen;
  late ConectividadFalsa conectividad;
  late FakeNotificacionesReporte avisos;
  late MemoriaPreferenciasEnvioStore preferencias;
  late ProviderContainer contenedor;

  Future<void> abrir(
    WidgetTester tester, {
    TipoRed red = TipoRed.wifi,
    String inicio = ReporteRoutes.poliza,
  }) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    conectividad = ConectividadFalsa(red);
    final router = GoRouter(
      initialLocation: inicio,
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
          builder: (_, estado) =>
              M0504EnviandoPage(yaEnCurso: estado.extra == true),
        ),
        GoRoute(
          path: ReporteRoutes.resultado,
          builder: (_, _) => const M0505ResultadoPage(),
        ),
        GoRoute(
          path: ReporteRoutes.misSiniestros,
          builder: (_, _) => const Text('MIS SINIESTROS'),
        ),
        GoRoute(
          path: ReporteRoutes.pendiente,
          builder: (_, estado) =>
              M0507bReportePendientePage(id: estado.pathParameters['id']!),
        ),
      ],
    );
    contenedor = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        almacenReportesProvider.overrideWithValue(almacen),
        conectividadProvider.overrideWithValue(conectividad),
        reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
        subidaFotoSiniestroProvider.overrideWithValue(
          FakeSubidaArchivoService(),
        ),
        ubicacionReporteProvider.overrideWithValue(gps),
        relojReporteProvider.overrideWithValue(() => DateTime(2026, 11, 4, 15)),
        sesionParaEnviarProvider.overrideWithValue(() => true),
        notificacionesReporteProvider.overrideWithValue(avisos),
        preferenciasEnvioStoreProvider.overrideWithValue(preferencias),
      ],
    );
    addTearDown(contenedor.dispose);
    contenedor.read(cuentaActualProvider.notifier).fijar('c1');
    // Como en la app: el vigía despierta la cola cuando vuelve la red.
    contenedor.listen(vigiaReportesProvider, (_, _) {});
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

  setUp(() {
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    gps = FakeUbicacionService();
    almacen = AlmacenReportesMemoria();
    avisos = FakeNotificacionesReporte();
    preferencias = MemoriaPreferenciasEnvioStore();
  });

  Future<void> hastaElRelato(WidgetTester tester) async {
    await tester.tap(find.text('Póliza SOL-2026-000456'));
    contenedor
        .read(reporteProvider.notifier)
        .fijarFecha(DateTime(2026, 11, 4, 13));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choque con daños que se pueden reparar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tomar foto'));
    await tester.pump();
    await tester.tap(find.text('Tomar foto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    final campos = find.byType(TextField);
    await tester.enterText(
      campos.at(0),
      'Me chocaron por detrás en un semáforo.',
    );
    await tester.enterText(campos.at(1), 'Cra 15 con Calle 93');
    await tester.ensureVisible(campos.at(2));
    await tester.tap(campos.at(2));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Bogotá'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Bogotá'));
    await tester.pumpAndSettle();
  }

  Future<void> sinRed(WidgetTester tester) async {
    bff.sinRed = true;
    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();
  }

  Future<void> vuelveLaRed(WidgetTester tester, TipoRed tipo) async {
    bff.sinRed = false;
    conectividad.cambiar(tipo);
    await tester.pumpAndSettle();
  }

  /// Desmonta y cierra todo dentro de la prueba: la franja «Reporte enviado»
  /// y los reintentos de la cola usan temporizadores.
  Future<void> terminar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    contenedor.dispose();
    await tester.pump();
  }

  Future<ReporteGuardado> elGuardado() async =>
      (await almacen.deCuenta('c1')).single;

  testWidgets('con conexión envía por la cola y muestra el radicado', (
    tester,
  ) async {
    await abrir(tester);
    await hastaElRelato(tester);

    await tester.tap(find.text('Enviar reporte'));
    await tester.pumpAndSettle();

    expect(find.textContaining('SIN-'), findsWidgets);
    expect(bff.reportes, hasLength(1));
    expect((await elGuardado()).estado, EstadoLocal.enviado);
    // Con la app al frente no hay notificación: el resultado está en pantalla.
    expect(avisos.avisos, isEmpty);
    // El permiso de notificaciones se pide una sola vez, al primer envío.
    expect(avisos.permisosPedidos, 1);
    await terminar(tester);
  });

  testWidgets('sin conexión el botón guarda y el reporte queda en cola', (
    tester,
  ) async {
    await abrir(tester);
    await hastaElRelato(tester);
    await sinRed(tester);

    expect(find.text('Enviar reporte'), findsNothing);
    expect(
      find.text(
        'No hay conexión. Guardaremos tu reporte y lo enviaremos cuando '
        'vuelva la señal.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Guardar y enviar después'));
    await tester.pumpAndSettle();

    expect(find.text('Reporte guardado'), findsOneWidget);
    expect(find.textContaining('Todavía no tiene radicado'), findsOneWidget);
    expect(
      find.text('Si desinstalas la app o borras sus datos, se pierde.'),
      findsOneWidget,
    );
    expect(bff.reportes, isEmpty);
    final guardado = await elGuardado();
    expect(guardado.estado, EstadoLocal.pendiente);
    expect(guardado.fotos, hasLength(2));
  });

  testWidgets('lo guardado sin conexión se envía solo al volver la red', (
    tester,
  ) async {
    await abrir(tester);
    await hastaElRelato(tester);
    await sinRed(tester);
    await tester.tap(find.text('Guardar y enviar después'));
    await tester.pumpAndSettle();
    expect(bff.reportes, isEmpty);

    await vuelveLaRed(tester, TipoRed.wifi);

    expect(bff.reportes, hasLength(1));
    expect((await elGuardado()).estado, EstadoLocal.enviado);
    await terminar(tester);
  });

  group('con datos móviles', () {
    testWidgets('la primera vez pregunta; «Esperar Wi-Fi» lo deja guardado', (
      tester,
    ) async {
      await abrir(tester, red: TipoRed.movil);
      await hastaElRelato(tester);

      await tester.tap(find.text('Enviar reporte'));
      await tester.pumpAndSettle();
      expect(find.text('Estás usando datos móviles'), findsOneWidget);
      expect(find.textContaining('Enviar 2 fotos gasta cerca de'), findsOne);

      await tester.tap(find.text('Esperar Wi-Fi'));
      await tester.pumpAndSettle();

      expect(find.text('Reporte guardado'), findsOneWidget);
      expect(
        find.textContaining('Lo enviaremos cuando te conectes a Wi-Fi'),
        findsOneWidget,
      );
      expect(bff.reportes, isEmpty);
      expect((await elGuardado()).esperaWifi, isTrue);
      // «Recordar mi elección» viene marcado: queda «solo con Wi-Fi».
      final recordadas = contenedor.read(preferenciasEnvioProvider);
      expect(recordadas.preguntado, isTrue);
      expect(recordadas.soloWifi, isTrue);

      // Desde «Reporte guardado» puede cambiar de idea.
      await tester.tap(find.text('Enviar ahora con datos'));
      await tester.pumpAndSettle();

      expect(bff.reportes, hasLength(1));
      expect((await elGuardado()).estado, EstadoLocal.enviado);
      await terminar(tester);
    });

    testWidgets('«Enviar ahora con datos» sin recordar: la preferencia no '
        'cambia', (tester) async {
      await abrir(tester, red: TipoRed.movil);
      await hastaElRelato(tester);

      await tester.tap(find.text('Enviar reporte'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Recordar mi elección. Puedes cambiarla en Mi perfil.'),
      );
      await tester.pump();
      await tester.tap(find.text('Enviar ahora con datos'));
      await tester.pumpAndSettle();

      expect(bff.reportes, hasLength(1));
      final guardadas = contenedor.read(preferenciasEnvioProvider);
      expect(guardadas.preguntado, isFalse);
      expect(guardadas.soloWifi, isFalse);
      await terminar(tester);
    });

    testWidgets('con «solo Wi-Fi» encendido no pregunta: espera Wi-Fi y sale '
        'al conectarse', (tester) async {
      await preferencias.guardar(
        const PreferenciasEnvio(soloWifi: true, preguntado: true),
      );
      await abrir(tester, red: TipoRed.movil);
      await hastaElRelato(tester);

      await tester.tap(find.text('Enviar reporte'));
      await tester.pumpAndSettle();

      expect(find.text('Estás usando datos móviles'), findsNothing);
      expect(find.text('Reporte guardado'), findsOneWidget);
      expect(bff.reportes, isEmpty);

      await vuelveLaRed(tester, TipoRed.wifi);

      expect(bff.reportes, hasLength(1));
      await terminar(tester);
    });
  });

  group('M05-07b · detalle del reporte por enviar', () {
    testWidgets('pendiente sin red: dice que espera y que nada se perdió', (
      tester,
    ) async {
      await abrir(tester);
      await hastaElRelato(tester);
      await sinRed(tester);
      await tester.tap(find.text('Guardar y enviar después'));
      await tester.pumpAndSettle();
      final id = (await elGuardado()).id;

      contenedor.read(reporteProvider.notifier).reiniciar();
      final contexto = tester.element(find.text('Reporte guardado'));
      GoRouter.of(contexto).go(ReporteRoutes.pendienteDe(id));
      await tester.pumpAndSettle();

      expect(find.text('Reporte por enviar'), findsOneWidget);
      expect(find.text('Esperando conexión'), findsWidgets);
      expect(
        find.text('Se envía solo cuando vuelva la señal.'),
        findsOneWidget,
      );
      expect(find.text('Editar reporte'), findsOneWidget);
      await terminar(tester);
    });

    testWidgets('rechazado: muestra el motivo de la aseguradora y deja '
        'corregir', (tester) async {
      await abrir(tester);
      await hastaElRelato(tester);
      bff.rechazar = true;
      await tester.tap(find.text('Enviar reporte'));
      await tester.pumpAndSettle();
      final guardado = await elGuardado();
      expect(guardado.estado, EstadoLocal.conError);

      final contexto = tester.element(find.byType(Scaffold).first);
      GoRouter.of(contexto).go(ReporteRoutes.pendienteDe(guardado.id));
      await tester.pumpAndSettle();

      expect(find.text('La aseguradora no lo aceptó'), findsWidgets);
      expect(find.text(guardado.ultimoError!), findsWidgets);
      expect(
        find.text('Tus fotos y tu relato siguen guardados. No se perdió nada.'),
        findsOneWidget,
      );
      expect(find.text('Corregir y enviar'), findsOneWidget);
      await terminar(tester);
    });

    testWidgets('un reporte que ya no está guardado lo dice', (tester) async {
      await abrir(tester, inicio: ReporteRoutes.pendienteDe('no-existe'));

      expect(
        find.text(
          'Este reporte ya no está guardado en el teléfono. Si se envió, lo '
          'encuentras en Mis siniestros.',
        ),
        findsOneWidget,
      );
    });
  });
}
