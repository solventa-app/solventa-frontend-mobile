import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';
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
import 'package:solventa_mobile/features/claims/presentation/pages/m05_06_mis_siniestros_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_07_detalle_siniestro_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_07b_reporte_pendiente_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_routes.dart';
import 'package:solventa_mobile/features/claims/presentation/vigia_reportes.dart';

import 'soporte/capturas.dart';

/// HU-M05, reporte sin conexión (KAN-35) en dispositivo: el reporte se llena
/// sin señal, queda guardado en el teléfono y se envía solo cuando la red
/// vuelve, una sola vez. La red, la cámara, el GPS y el BFF se fijan para que
/// corra igual en los emuladores del CI y en Test Lab; lo que solo se puede
/// probar con el teléfono (modo avión, servicio en primer plano, huella sin
/// red) está en docs/hu-m05/pruebas-sin-conexion.md.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FakeReporteSiniestroRemoteDataSource bff;
  late AlmacenReportesMemoria almacen;
  late ConectividadFalsa conectividad;
  late FakeNotificacionesReporte avisos;
  late MemoriaPreferenciasEnvioStore preferencias;
  late ProviderContainer contenedor;

  DateTime ahora() => DateTime(2026, 11, 4, 15);

  Future<void> abrir(WidgetTester tester, {TipoRed red = TipoRed.wifi}) async {
    // Con el teclado de prueba el recorrido no depende de cuánto tarde el
    // teclado real en encoger la pantalla (ver reporte_siniestro_test.dart).
    tester.testTextInput.register();
    addTearDown(tester.testTextInput.unregister);
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    almacen = AlmacenReportesMemoria();
    conectividad = ConectividadFalsa(red);
    avisos = FakeNotificacionesReporte();
    preferencias = MemoriaPreferenciasEnvioStore();
    contenedor = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        almacenReportesProvider.overrideWithValue(almacen),
        conectividadProvider.overrideWithValue(conectividad),
        sondaRedProvider.overrideWithValue(SondaFalsa()),
        reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
        subidaFotoSiniestroProvider.overrideWithValue(
          FakeSubidaArchivoService(),
        ),
        ubicacionReporteProvider.overrideWithValue(FakeUbicacionService()),
        camaraReporteHabilitadaProvider.overrideWithValue(false),
        relojReporteProvider.overrideWithValue(ahora),
        sesionParaEnviarProvider.overrideWithValue(() => true),
        notificacionesReporteProvider.overrideWithValue(avisos),
        preferenciasEnvioStoreProvider.overrideWithValue(preferencias),
      ],
    );
    addTearDown(contenedor.dispose);
    // La cuenta dueña de lo guardado: con ella el envío va por la cola.
    contenedor.read(cuentaActualProvider.notifier).fijar('c1');
    // Como en la app: el vigía despierta la cola cuando vuelve la red.
    contenedor.listen(vigiaReportesProvider, (_, _) {});
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
          builder: (_, estado) =>
              M0504EnviandoPage(yaEnCurso: estado.extra == true),
        ),
        GoRoute(
          path: ReporteRoutes.resultado,
          builder: (_, _) => const M0505ResultadoPage(),
        ),
        GoRoute(
          path: ReporteRoutes.misSiniestros,
          builder: (_, _) => M0506MisSiniestrosPage(ahora: ahora),
        ),
        GoRoute(
          path: ReporteRoutes.pendiente,
          builder: (_, estado) =>
              M0507bReportePendientePage(id: estado.pathParameters['id']!),
        ),
        GoRoute(
          path: ReporteRoutes.detalle,
          builder: (_, estado) =>
              M0507DetalleSiniestroPage(id: estado.pathParameters['id']!),
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

  /// Desmonta y cierra todo dentro de la prueba: la franja «Reporte enviado»
  /// y los reintentos de la cola usan temporizadores.
  Future<void> terminar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    contenedor.dispose();
    await tester.pump();
  }

  Future<void> tocar(WidgetTester tester, Finder donde) async {
    await tester.ensureVisible(donde);
    // ensureVisible solo mueve el scroll: sin este pump el toque usa la
    // posición de antes y en el emulador cae fuera del botón.
    await tester.pumpAndSettle();
    await tester.tap(donde);
    await tester.pumpAndSettle();
  }

  /// Llena la póliza, una foto y el relato; queda en M05-03 listo para enviar.
  Future<void> hastaElRelato(WidgetTester tester) async {
    await tester.tap(find.text('Póliza SOL-2026-000456'));
    contenedor
        .read(reporteProvider.notifier)
        .fijarFecha(DateTime(2026, 11, 4, 13));
    await tester.pumpAndSettle();
    await tocar(tester, find.text('Choque con daños que se pueden reparar'));
    await tocar(tester, find.text('Continuar'));

    await tester.tap(find.text('Tomar foto'));
    await tester.pumpAndSettle();
    expect(find.text('1 de 3 fotos'), findsOneWidget);
    await tocar(tester, find.text('Continuar'));

    final campos = find.byType(TextField);
    await tester.enterText(
      campos.at(0),
      'Me chocaron por detrás en un semáforo.',
    );
    await tester.enterText(campos.at(1), 'Cra 15 con Calle 93');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tocar(tester, campos.at(2));
    await tester.scrollUntilVisible(
      find.text('Bogotá'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bogotá'));
    await tester.pumpAndSettle();
  }

  Future<void> seVaLaRed(WidgetTester tester) async {
    bff.sinRed = true;
    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();
  }

  Future<void> vuelveLaRed(WidgetTester tester, TipoRed tipo) async {
    bff.sinRed = false;
    conectividad.cambiar(tipo);
    await tester.pumpAndSettle();
  }

  Future<ReporteGuardado> elGuardado() async =>
      (await almacen.deCuenta('c1')).single;

  testWidgets('HU-M05 sin conexión: guarda el reporte y lo envía solo al '
      'volver la señal', (tester) async {
    await abrir(tester);
    await hastaElRelato(tester);

    // Se cae la señal antes de enviar: el botón cambia y lo dice.
    await seVaLaRed(tester);
    expect(find.text('Enviar reporte'), findsNothing);
    await tester.ensureVisible(find.text('Guardar y enviar después'));
    await tester.pumpAndSettle();
    await capturar(tester, 'M05-03 · sin conexión');
    await tocar(tester, find.text('Guardar y enviar después'));

    expect(find.text('Reporte guardado'), findsOneWidget);
    expect(find.textContaining('Todavía no tiene radicado'), findsOneWidget);
    await capturar(tester, 'M05-05 · reporte guardado');
    expect(bff.reportes, isEmpty);
    final guardado = await elGuardado();
    expect(guardado.estado, EstadoLocal.pendiente);
    expect(guardado.fotos, hasLength(1));

    // «Mis siniestros» lo muestra arriba, en «Por enviar».
    await tocar(tester, find.text('Ver mis siniestros'));
    expect(find.text('Por enviar'), findsOneWidget);
    expect(find.text('Pendiente de envío'), findsOneWidget);
    await capturar(tester, 'M05-06 · por enviar, sin conexión');

    await tocar(tester, find.text('Pendiente de envío'));
    expect(find.text('Reporte por enviar'), findsOneWidget);
    expect(find.text('Esperando conexión'), findsWidgets);
    await capturar(tester, 'M05-07b · esperando conexión');

    // Vuelve la señal: sale solo, una sola vez y con el mismo idReporte.
    await vuelveLaRed(tester, TipoRed.wifi);

    expect(bff.reportes, hasLength(1));
    expect(bff.reportes.single.idReporte, guardado.id);
    expect(bff.reportes.single.fotos.single.latitud, 4.6767);
    final enviado = await elGuardado();
    expect(enviado.estado, EstadoLocal.enviado);
    expect(enviado.resultado, isNotNull);
    await capturar(tester, 'M05-07b · enviado al volver la señal');

    // Otra vuelta de la red no lo manda dos veces.
    await seVaLaRed(tester);
    await vuelveLaRed(tester, TipoRed.wifi);
    expect(bff.reportes, hasLength(1));
    await terminar(tester);
  });

  testWidgets('HU-M05 con datos móviles: pregunta antes de gastar el plan y '
      'espera el Wi-Fi', (tester) async {
    await abrir(tester, red: TipoRed.movil);
    await hastaElRelato(tester);

    await tocar(tester, find.text('Enviar reporte'));
    expect(find.text('Estás usando datos móviles'), findsOneWidget);
    await capturar(tester, 'M05-03 · hoja de datos móviles');

    await tester.tap(find.text('Esperar Wi-Fi'));
    await tester.pumpAndSettle();

    expect(find.text('Reporte guardado'), findsOneWidget);
    expect(
      find.textContaining('lo enviaremos cuando te conectes a Wi-Fi'),
      findsOneWidget,
    );
    await capturar(tester, 'M05-05 · guardado, esperando Wi-Fi');
    expect(bff.reportes, isEmpty);
    expect((await elGuardado()).esperaWifi, isTrue);
    // La elección quedó recordada: en Mi perfil aparece «solo con Wi-Fi».
    expect(contenedor.read(preferenciasEnvioProvider).soloWifi, isTrue);

    await vuelveLaRed(tester, TipoRed.wifi);

    expect(bff.reportes, hasLength(1));
    expect((await elGuardado()).estado, EstadoLocal.enviado);
    await terminar(tester);
  });
}
