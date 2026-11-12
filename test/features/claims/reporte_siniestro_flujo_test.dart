import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_01_poliza_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_02_fotos_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_03_relato_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_04_enviando_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_05_resultado_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_routes.dart';

/// HU-M05 de punta a punta con el fake del BFF: póliza y fecha, fotos con GPS,
/// relato, envío y radicado.
void main() {
  late FakeReporteSiniestroRemoteDataSource bff;
  late FakeUbicacionService gps;
  late ProviderContainer contenedor;

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
    contenedor = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
        subidaFotoSiniestroProvider.overrideWithValue(
          FakeSubidaArchivoService(),
        ),
        ubicacionReporteProvider.overrideWithValue(gps),
        relojReporteProvider.overrideWithValue(() => DateTime(2026, 11, 4, 15)),
      ],
    );
    addTearDown(contenedor.dispose);
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
  });

  Future<void> hastaElRelato(WidgetTester tester) async {
    // M05-01: póliza y fecha (la fecha se fija por el notifier: el selector
    // nativo de fecha no es parte de lo que se prueba).
    expect(find.text('Póliza SOL-2026-000456'), findsOneWidget);
    await tester.tap(find.text('Póliza SOL-2026-000456'));
    contenedor
        .read(reporteProvider.notifier)
        .fijarFecha(DateTime(2026, 11, 4, 13));
    await tester.pumpAndSettle();
    // En la póliza de auto se elige qué le pasó al vehículo.
    await tester.tap(find.text('Choque con daños que se pueden reparar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // M05-02: la ubicación queda lista y se toman dos fotos.
    expect(
      find.text('Ubicación lista: tus fotos quedan geoetiquetadas.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Tomar foto'));
    await tester.pump();
    await tester.tap(find.text('Tomar foto'));
    await tester.pumpAndSettle();
    expect(find.text('2 de 3 fotos'), findsOneWidget);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    // M05-03: relato, lugar y ciudad.
    final campos = find.byType(TextField);
    await tester.enterText(
      campos.at(0),
      'Me chocaron por detrás en un semáforo.',
    );
    await tester.enterText(campos.at(1), 'Cra 15 con Calle 93');
    await tester.enterText(campos.at(2), 'Bogotá');
    await tester.pumpAndSettle();
  }

  testWidgets('CA-M05-01: reporta y muestra el radicado y el plazo', (
    tester,
  ) async {
    await abrir(tester);
    await hastaElRelato(tester);
    await tester.tap(find.text('Enviar reporte'));
    await tester.pumpAndSettle();

    expect(find.text('Recibimos tu reporte'), findsOneWidget);
    expect(find.textContaining('SIN-2026-1001'), findsOneWidget);
    final entrada = bff.reportes.single;
    expect(entrada.fotos, hasLength(2));
    expect(entrada.fotos.first.latitud, 4.6767); // CA-M05-02: geoetiquetada
    expect(entrada.ubicacion.ciudad, 'Bogotá');

    await tester.tap(find.text('Volver al inicio'));
    await tester.pumpAndSettle();
    expect(find.text('INICIO'), findsOneWidget);
  });

  testWidgets('el relato corto no se envía y muestra la ayuda como error', (
    tester,
  ) async {
    await abrir(tester);
    await hastaElRelato(tester);
    await tester.enterText(find.byType(TextField).at(0), 'corto');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enviar reporte'));
    await tester.pumpAndSettle();
    expect(bff.reportes, isEmpty);
    expect(find.text('Enviar reporte'), findsOneWidget);
  });

  testWidgets('CA-M05-04: sin red ofrece reintentar y no duplica el caso', (
    tester,
  ) async {
    bff.errorAlReportar = const ErrorRed();
    await abrir(tester);
    await hastaElRelato(tester);
    await tester.tap(find.text('Enviar reporte'));
    await tester.pumpAndSettle();

    expect(find.text('No pudimos enviar tu reporte'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('Recibimos tu reporte'), findsOneWidget);
    expect(bff.subidas, hasLength(2)); // no volvió a subir las fotos
    expect(bff.reportes, hasLength(1));
  });

  testWidgets('la regla de CLAIMS se muestra tal cual y lleva a revisar', (
    tester,
  ) async {
    bff.rechazar = true;
    await abrir(tester);
    await hastaElRelato(tester);
    await tester.tap(find.text('Enviar reporte'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'La fecha del siniestro está fuera de la vigencia de la póliza.',
      ),
      findsOneWidget,
    );
    expect(find.text('Revisar el reporte'), findsOneWidget);
  });

  testWidgets(
    'sin permiso de ubicación no deja continuar y ofrece permitirlo',
    (tester) async {
      gps.resultado = const UbicacionSinPermiso(permanente: false);
      await abrir(tester);
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
      await tester.pumpAndSettle();

      expect(find.text('Permitir ubicación'), findsOneWidget);
      final continuar = tester.widget<SolButton>(
        find.widgetWithText(SolButton, 'Continuar'),
      );
      expect(continuar.onPressed, isNull);
    },
  );

  bool continuarActivo(WidgetTester tester) =>
      tester
          .widget<SolButton>(find.widgetWithText(SolButton, 'Continuar'))
          .onPressed !=
      null;

  testWidgets(
    'M05-01 con los selectores reales: sin hora no se fija la fecha',
    (tester) async {
      await abrir(tester);
      expect(find.text('Primero elige la póliza afectada.'), findsOneWidget);
      await tester.tap(find.text('Póliza SOL-2026-000456'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choque con daños que se pueden reparar'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Tu póliza cubre desde el'), findsOneWidget);

      // Antes, cancelar la hora dejaba la medianoche y podía caer fuera de
      // la vigencia sin que el cliente supiera por qué.
      await tester.tap(find.text('Elige el día y la hora'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('Elige el día y la hora'), findsOneWidget);
      expect(continuarActivo(tester), isFalse);

      await tester.tap(find.text('Elige el día y la hora'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ACEPTAR'));
      await tester.pumpAndSettle();
      expect(
        contenedor.read(reporteProvider).ocurridoEn,
        DateTime(2026, 11, 4, 15),
      );
      expect(continuarActivo(tester), isTrue);
    },
  );

  testWidgets('una fecha antes de la vigencia dice desde cuándo cubre', (
    tester,
  ) async {
    await abrir(tester);
    await tester.tap(find.text('Póliza SOL-2026-000456'));
    contenedor
        .read(reporteProvider.notifier)
        .fijarFecha(DateTime(2026, 1, 15, 9));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Tu póliza empezó a cubrirte el'),
      findsOneWidget,
    );
    expect(continuarActivo(tester), isFalse);
  });

  // KAN-290: en una póliza de auto el reporte pide qué le pasó al vehículo.
  testWidgets('en una póliza de auto pide qué pasó antes de continuar', (
    tester,
  ) async {
    await abrir(tester);
    expect(find.text('¿Qué le pasó al vehículo?'), findsNothing);
    expect(find.textContaining('Auto MAZDA ABC•••'), findsOneWidget);

    await tester.tap(find.text('Póliza SOL-2026-000456'));
    contenedor
        .read(reporteProvider.notifier)
        .fijarFecha(DateTime(2026, 11, 4, 13));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué le pasó al vehículo?'), findsOneWidget);
    expect(
      find.text('Elige qué le pasó al vehículo para continuar.'),
      findsOneWidget,
    );
    final continuar = find.widgetWithText(SolButton, 'Continuar');
    expect(tester.widget<SolButton>(continuar).onPressed, isNull);

    await tester.tap(find.text('Choque con daños que se pueden reparar'));
    await tester.pumpAndSettle();
    expect(
      contenedor.read(reporteProvider).tipoAuto,
      TipoSiniestroAuto.choqueParcial,
    );
    expect(tester.widget<SolButton>(continuar).onPressed, isNotNull);
  });

  testWidgets('solo ofrece las pólizas de auto: la de vida no sale', (
    tester,
  ) async {
    await abrir(tester);

    expect(find.text('Póliza SOL-2026-000456'), findsOneWidget);
    expect(find.textContaining('Auto MAZDA ABC•••'), findsOneWidget);
    expect(find.text('Póliza SOL-2026-000123'), findsNothing);
  });

  group('fechaDelSiniestro', () {
    final desde = DateTime(2026, 11, 7, 15, 32, 45);
    final recien = PolizaReportable(
      id: 'p',
      numero: 'PRUEBA-2026-1',
      vigenciaDesde: desde,
      vigenciaHasta: DateTime(2031, 11, 7),
    );
    final hoy = DateTime(2026, 11, 7);
    final ahora = DateTime(2026, 11, 7, 15, 33, 10);

    test('póliza emitida en el mismo minuto: toma el inicio de vigencia', () {
      expect(
        fechaDelSiniestro(
          hoy,
          const TimeOfDay(hour: 15, minute: 32),
          ahora: ahora,
          poliza: recien,
        ),
        desde,
      );
    });

    test('nunca en el futuro', () {
      expect(
        fechaDelSiniestro(
          hoy,
          const TimeOfDay(hour: 18, minute: 0),
          ahora: ahora,
          poliza: recien,
        ),
        ahora,
      );
    });

    test('una hora claramente anterior se respeta (y la pantalla avisa)', () {
      expect(
        fechaDelSiniestro(
          hoy,
          const TimeOfDay(hour: 10, minute: 0),
          ahora: ahora,
          poliza: recien,
        ),
        DateTime(2026, 11, 7, 10),
      );
    });
  });
}
