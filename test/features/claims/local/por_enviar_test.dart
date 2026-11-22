import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/almacen/base_local.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_01_poliza_page.dart';
import 'package:solventa_mobile/features/claims/presentation/pages/m05_06_mis_siniestros_page.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_routes.dart';

final _ahora = DateTime.utc(2026, 11, 20, 15);

final _poliza = PolizaReportable(
  id: 'pol-1',
  numero: 'AUTO-0001',
  vigenciaDesde: DateTime.utc(2026),
  vigenciaHasta: DateTime.utc(2027),
  esAuto: true,
  vehiculo: 'MAZDA ABC•••',
);

/// HU-M05 (sin conexión): los reportes guardados en el teléfono se ven en
/// «Mis siniestros» y se pueden continuar o descartar; sin conexión, las
/// listas muestran su última copia.
void main() {
  late AlmacenReportesMemoria almacen;
  late AlmacenLocalMemoria local;
  late FakeReporteSiniestroRemoteDataSource bff;
  late ConectividadFalsa conectividad;
  var apertura = AperturaBase.normal;

  setUp(() {
    almacen = AlmacenReportesMemoria();
    local = AlmacenLocalMemoria();
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    conectividad = ConectividadFalsa();
    apertura = AperturaBase.normal;
    addTearDown(conectividad.cerrar);
  });

  Future<void> borrador(
    String id, {
    Duration hace = Duration.zero,
    bool conPoliza = true,
    int fotos = 1,
    String cuenta = 'c1',
  }) async {
    await almacen.guardar(
      ReporteGuardado(
        id: id,
        cuentaId: cuenta,
        estado: EstadoLocal.borrador,
        creadoEn: _ahora.subtract(hace),
        actualizadoEn: _ahora.subtract(hace),
        poliza: conPoliza ? _poliza : null,
        tipoAuto: conPoliza ? TipoSiniestroAuto.choqueParcial : null,
      ),
    );
    for (var i = 0; i < fotos; i++) {
      await almacen.agregarFoto(
        id,
        bytes: Uint8List.fromList([1, 2, 3, i]),
        tipoContenido: 'image/jpeg',
        tomadaEn: _ahora,
      );
    }
  }

  Future<void> abrir(
    WidgetTester tester, {
    String ruta = ReporteRoutes.misSiniestros,
    Locale locale = AppLocales.es,
    double textScale = 1,
    Size size = const Size(390, 1400),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: ruta,
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('INICIO')),
        GoRoute(
          path: ReporteRoutes.poliza,
          builder: (_, _) => const M0501PolizaPage(),
        ),
        GoRoute(
          path: ReporteRoutes.fotos,
          builder: (_, _) => const Text('FOTOS'),
        ),
        GoRoute(
          path: ReporteRoutes.misSiniestros,
          builder: (_, _) => M0506MisSiniestrosPage(ahora: () => _ahora),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          cuentaReporteProvider.overrideWithValue('c1'),
          almacenReportesProvider.overrideWithValue(almacen),
          almacenLocalProvider.overrideWithValue(local),
          aperturaBaseProvider.overrideWith((_) => apertura),
          conectividadProvider.overrideWithValue(conectividad),
          reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
          relojReporteProvider.overrideWithValue(() => _ahora),
        ],
        child: MaterialApp.router(
          theme: SolTheme.light(),
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, app) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: app!,
          ),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('M05-06 con reportes en el teléfono', () {
    testWidgets('sin nada guardado, la pantalla queda como siempre', (
      tester,
    ) async {
      await abrir(tester);

      expect(find.text('Por enviar'), findsNothing);
      expect(find.text('Enviados'), findsNothing);
      expect(find.text('SIN-2026-0987'), findsOneWidget);
    });

    testWidgets('un borrador sale arriba, en «Por enviar», con su estado', (
      tester,
    ) async {
      await borrador('b1', fotos: 2);
      await abrir(tester);

      expect(find.text('Por enviar'), findsOneWidget);
      expect(
        find.text('MAZDA ABC••• · Choque con daños que se pueden reparar'),
        findsOneWidget,
      );
      expect(find.text('Sin terminar'), findsOneWidget);
      expect(find.textContaining('Última edición'), findsOneWidget);
      expect(find.text('Continuar reporte'), findsOneWidget);
      expect(find.text('Enviados'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Por enviar')).dy,
        lessThan(tester.getTopLeft(find.text('SIN-2026-0987')).dy),
      );
    });

    testWidgets('un borrador sin póliza se llama «Reporte sin terminar»', (
      tester,
    ) async {
      await borrador('b1', conPoliza: false, fotos: 0);
      await abrir(tester);

      expect(find.text('Reporte sin terminar'), findsOneWidget);
      expect(find.textContaining('sin fotos'), findsOneWidget);
    });

    testWidgets('solo se ven los de la cuenta que entró', (tester) async {
      await borrador('ajeno', cuenta: 'c2');
      await abrir(tester);

      expect(find.text('Por enviar'), findsNothing);
    });

    testWidgets('a los 5 días sin tocarlo avisa cuándo se borra', (
      tester,
    ) async {
      await borrador('b1', hace: const Duration(days: 5, hours: 2));
      await abrir(tester);

      expect(
        find.text('Se borrará en 1 día si no lo terminas.'),
        findsOneWidget,
      );
    });

    testWidgets('«Continuar reporte» abre el reporte con lo que tenía', (
      tester,
    ) async {
      await borrador('b1');
      await abrir(tester);

      await tester.tap(find.text('Continuar reporte'));
      await tester.pumpAndSettle();

      expect(find.byType(M0501PolizaPage), findsOneWidget);
      final contenedor = ProviderScope.containerOf(
        tester.element(find.byType(M0501PolizaPage)),
      );
      final estado = contenedor.read(reporteProvider);
      expect(estado.idReporte, 'b1');
      expect(estado.fotos, hasLength(1));
      expect(estado.tipoAuto, TipoSiniestroAuto.choqueParcial);
    });

    testWidgets('«Descartar reporte» pide confirmar y lo borra', (
      tester,
    ) async {
      await borrador('b1');
      await abrir(tester);

      await tester.tap(find.text('Descartar reporte'));
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar este reporte?'), findsOneWidget);

      await tester.tap(find.text('Conservar'));
      await tester.pumpAndSettle();
      expect(await almacen.leer('b1'), isNotNull);

      await tester.tap(find.text('Descartar reporte'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Descartar'));
      await tester.pumpAndSettle();

      expect(await almacen.leer('b1'), isNull);
      expect(find.text('Por enviar'), findsNothing);
    });

    testWidgets('si la base se reinició, lo dice una vez arriba', (
      tester,
    ) async {
      apertura = AperturaBase.reiniciada;
      await abrir(tester);

      expect(find.text('No pudimos leer lo guardado'), findsOneWidget);
    });

    testWidgets('en inglés y con el texto al 200 % no se desborda', (
      tester,
    ) async {
      await borrador('b1', hace: const Duration(days: 6));
      await abrir(
        tester,
        locale: AppLocales.en,
        textScale: 2,
        size: const Size(360, 2400),
      );

      expect(find.text('To send'), findsOneWidget);
      expect(find.text('Unfinished'), findsOneWidget);
      expect(find.text('Continue report'), findsOneWidget);
      expect(find.text('Discard report'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('sin conexión', () {
    testWidgets('«Mis siniestros» muestra la última copia y hace cuánto es', (
      tester,
    ) async {
      // Una carga con conexión deja la copia.
      await local.guardarCopia(
        'c1',
        'siniestros',
        '[{"id":"s1","radicado":"SIN-2026-0001","estado":"PENDIENTE",'
            '"notificadoEn":"2026-11-19T10:00:00Z",'
            '"venceDictamenEn":"2026-11-25T10:00:00Z","fotos":2}]',
        _ahora.subtract(const Duration(hours: 2)),
      );
      bff.sinRed = true;
      conectividad = ConectividadFalsa(TipoRed.ninguna);
      await abrir(tester);

      expect(find.text('SIN-2026-0001'), findsOneWidget);
      expect(find.text('Enviados'), findsOneWidget);
      expect(find.text('Actualizado hace 2 h'), findsOneWidget);
      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets('sin copia pide conectarse, sin mensaje de error', (
      tester,
    ) async {
      bff.sinRed = true;
      conectividad = ConectividadFalsa(TipoRed.ninguna);
      await abrir(tester);

      expect(
        find.text('Conéctate para ver tus siniestros enviados.'),
        findsOneWidget,
      );
      expect(find.text('Reintentar'), findsNothing);
    });

    testWidgets('M05-01 muestra las pólizas guardadas y lo aclara', (
      tester,
    ) async {
      await local.guardarCopia(
        'c1',
        'polizas',
        '[{"id":"pol-1","numero":"AUTO-0001",'
            '"vigenciaDesde":"2026-01-01T00:00:00Z",'
            '"vigenciaHasta":"2027-01-01T00:00:00Z","esAuto":true,'
            '"vehiculo":"MAZDA ABC•••"}]',
        _ahora.subtract(const Duration(days: 1)),
      );
      bff.sinRed = true;
      conectividad = ConectividadFalsa(TipoRed.ninguna);
      await abrir(tester, ruta: ReporteRoutes.poliza);

      expect(find.textContaining('AUTO-0001'), findsOneWidget);
      expect(
        find.textContaining('Pólizas guardadas en este teléfono el'),
        findsOneWidget,
      );
    });

    testWidgets('M05-01 sin pólizas guardadas pide conectarse una vez', (
      tester,
    ) async {
      bff.sinRed = true;
      conectividad = ConectividadFalsa(TipoRed.ninguna);
      await abrir(tester, ruta: ReporteRoutes.poliza);

      expect(
        find.text('Conéctate una vez para descargar tus pólizas.'),
        findsOneWidget,
      );
    });
  });

  group('M05-01 con reportes pendientes', () {
    testWidgets('avisa que ya hay uno por enviar y lleva a verlo', (
      tester,
    ) async {
      await borrador('b1');
      await abrir(tester, ruta: ReporteRoutes.poliza);

      expect(find.text('Ya tienes 1 reporte por enviar.'), findsOneWidget);

      await tester.tap(find.text('Ver mis reportes'));
      await tester.pumpAndSettle();
      expect(find.byType(M0506MisSiniestrosPage), findsOneWidget);
    });

    testWidgets('con 5 sin enviar no deja empezar otro', (tester) async {
      for (var i = 0; i < 5; i++) {
        await borrador('b$i');
      }
      await abrir(tester, ruta: ReporteRoutes.poliza);

      expect(
        find.textContaining('Tienes 5 reportes sin enviar'),
        findsOneWidget,
      );
      final continuar = tester.widget<SolButton>(
        find.widgetWithText(SolButton, 'Continuar'),
      );
      expect(continuar.onPressed, isNull);
    });
  });
}
