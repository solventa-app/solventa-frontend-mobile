import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/prestador_mapper.dart';
import 'package:solventa_mobile/features/assistance/data/notificaciones_asistencia.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/asistencia.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/mis_asistencias_notifier.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/asistencia_detalle_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/mis_asistencias_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/solicitud_notifier.dart';

/// HU-M06 fase 5 (plan de pendientes 4.1 a 4.6): «Mis asistencias», la
/// cuenta regresiva, la notificación de llegada, «Te alejaste» y el detalle.
void main() {
  late FakeAsistenciaRemoteDataSource bff;
  late FakeNotificacionesAsistencia avisos;
  late FakeUbicacionService gps;
  late DateTime ahora;
  late ProviderContainer c;

  final clinica = prestadorDesdeMapa(AsistenciaFixtures.prestadores.first)!;
  final cercano = PrestadorCercano(
    prestador: clinica,
    distanciaKm: 1.1,
    minutosEstimados: 6,
  );
  const lugar = Coordenada(4.6767, -74.0483);

  setUp(() {
    // El idioma de la notificación lee las preferencias; sin este doble, el
    // fallo del plugin dentro de `runAsync` se reporta como error del test
    // (intermitente bajo carga).
    SharedPreferences.setMockInitialValues({});
    ahora = DateTime.utc(2026, 11, 12, 14, 20);
    bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero)
      ..reloj = () => ahora;
    avisos = FakeNotificacionesAsistencia();
    gps = FakeUbicacionService(resultado: const UbicacionObtenida(lugar));
    c = ProviderContainer(
      overrides: [
        asistenciaRemoteDataSourceProvider.overrideWithValue(bff),
        catalogoLocalDataSourceProvider.overrideWithValue(
          MemoriaCatalogoLocalDataSource(),
        ),
        notificacionesAsistenciaProvider.overrideWithValue(avisos),
        ubicacionServiceProvider.overrideWithValue(gps),
        relojProvider.overrideWithValue(() => ahora),
        duracionMinimaEnvioProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(c.dispose);
  });

  /// Pide una asistencia y la confirma con el reintento (como CLAIMS con
  /// `primero_falla`). Devuelve su id.
  Future<String> confirmada() async {
    final n = c.read(solicitudProvider.notifier)..iniciar(cercano, lugar);
    await n.enviar();
    await n.enviar();
    return c.read(solicitudProvider).idSolicitud;
  }

  group('notifier', () {
    test(
      '4.5: al confirmarse se programa la llegada y el permiso se pide una vez',
      () async {
        final id = await confirmada();
        final (llegada, titulo, cuerpo) = avisos.programadas[id]!;
        expect(llegada, ahora.add(const Duration(minutes: 6)));
        expect(titulo, 'Tu asistencia llegó');
        expect(cuerpo, 'Clínica Norte ya debería estar en tu ubicación');
        await confirmada();
        expect(avisos.permisosPedidos, lessThanOrEqualTo(1));
      },
    );

    test(
      '4.1: en camino y ya llegaron según la hora; el backend manda',
      () async {
        final id = await confirmada();
        final n = c.read(misAsistenciasProvider.notifier);
        await n.cargar();
        var s = c.read(misAsistenciasProvider);
        expect(s.enCamino.map((a) => a.id), [id]);
        expect(s.yaLlegaron, isEmpty);

        ahora = ahora.add(const Duration(minutes: 7));
        await n.cargar();
        s = c.read(misAsistenciasProvider);
        expect(s.enCamino, isEmpty);
        expect(s.yaLlegaron.single.estado, EstadoAsistencia.llego);
        // Ya llegó: no queda notificación programada.
        expect(avisos.programadas, isEmpty);
      },
    );

    test(
      '4.1: las no confirmadas van en camino; reintentar las confirma',
      () async {
        final n0 = c.read(solicitudProvider.notifier)..iniciar(cercano, lugar);
        await n0.enviar();
        final id = c.read(solicitudProvider).idSolicitud;
        final n = c.read(misAsistenciasProvider.notifier);
        await n.cargar();
        final a = c.read(misAsistenciasProvider).enCamino.single;
        expect(a.estado, EstadoAsistencia.noConfirmada);

        final r = await n.reintentar(a);
        expect(
          (r as Exito<Asistencia>).valor.estado,
          EstadoAsistencia.confirmada,
        );
        expect(bff.solicitudes.last['idSolicitud'], id);
        expect(avisos.programadas, contains(id));
      },
    );

    test(
      '4.6: cancelar quita la notificación; si falla, se reprograma',
      () async {
        final id = await confirmada();
        final n = c.read(misAsistenciasProvider.notifier);
        await n.cargar();
        final a = c.read(misAsistenciasProvider).enCamino.single;

        bff.error = const ErrorRed();
        expect(await n.cancelar(a), isFalse);
        expect(avisos.canceladas, contains(id));
        expect(avisos.programadas, contains(id));

        bff.error = null;
        expect(await n.cancelar(a), isTrue);
        expect(avisos.programadas, isEmpty);
      },
    );

    test('4.4b: a 600 m avisa «Te alejaste»; a 400 m no', () async {
      final id = await confirmada();
      final n = c.read(misAsistenciasProvider.notifier);
      gps.resultado = const UbicacionObtenida(Coordenada(4.6803, -74.0483));
      await n.cargar();
      expect(c.read(misAsistenciasProvider).alejadas, isEmpty);
      gps.resultado = const UbicacionObtenida(Coordenada(4.6821, -74.0483));
      await n.cargar();
      expect(c.read(misAsistenciasProvider).alejadas, {id});
    });
  });

  test(
    'el id de la notificación es estable, positivo y distinto por asistencia',
    () {
      expect(idNotificacion('abc'), idNotificacion('abc'));
      expect(idNotificacion('abc'), isNot(idNotificacion('abd')));
      expect(
        idNotificacion('0b6f3a52-5d6e-4d8e-9c1a-2f4b7c9d1e00'),
        isPositive,
      );
    },
  );

  group('pantallas', () {
    late List<String> detalles;
    late int solicitudes;

    Future<void> abrir(WidgetTester tester, Widget pagina) async {
      tester.view.physicalSize = const Size(390, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            theme: SolTheme.light(),
            locale: AppLocales.es,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(body: pagina),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
    }

    Widget pestana() => MisAsistenciasPage(
      visible: true,
      onVerDetalle: detalles.add,
      onSolicitar: () => solicitudes++,
    );

    setUp(() {
      detalles = [];
      solicitudes = 0;
    });

    testWidgets('sin asistencias: estado vacío que lleva a Asistencia', (
      tester,
    ) async {
      await abrir(tester, pestana());
      expect(find.text('Aún no has pedido asistencia'), findsOneWidget);
      await tester.tap(find.text('Solicitar asistencia en sitio'));
      expect(solicitudes, 1);
      c.read(misAsistenciasProvider.notifier).pausar();
    });

    testWidgets(
      '4.2 y 4.3: cuenta regresiva y al llegar pasa a «Ya llegaron» con «Ver»',
      (tester) async {
        final id = await tester.runAsync(confirmada);
        await abrir(tester, pestana());
        expect(find.text('En camino (1)'), findsOneWidget);
        expect(find.text('Llega en 6 min'), findsOneWidget);
        expect(find.textContaining('Hora estimada'), findsOneWidget);

        ahora = ahora.add(const Duration(minutes: 5, seconds: 30));
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Llega en menos de 1 min'), findsOneWidget);

        ahora = ahora.add(const Duration(seconds: 40));
        await tester.pump(const Duration(seconds: 1));
        await tester.pump();
        expect(find.text('Ya llegaron (1)'), findsOneWidget);
        expect(find.text('Clínica Norte llegó'), findsOneWidget);
        expect(avisos.canceladas, contains(id));

        // El aviso entra con su animación antes de poder tocarlo.
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(find.text('Ver'));
        await tester.pump();
        expect(detalles, [id]);
        c.read(misAsistenciasProvider.notifier).pausar();
      },
    );

    testWidgets('4.4b: «Cancelar y pedir otra» cancela y va al mapa', (
      tester,
    ) async {
      await tester.runAsync(confirmada);
      gps.resultado = const UbicacionObtenida(Coordenada(4.6821, -74.0483));
      await abrir(tester, pestana());
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expect(find.textContaining('Te alejaste del lugar'), findsOneWidget);
      c.read(misAsistenciasProvider.notifier).pausar();
      await tester.tap(find.text('Cancelar y pedir otra'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sí, cancelar'));
      await tester.pumpAndSettle();
      expect(solicitudes, 1);
      expect(bff.asistencias.values.single['estado'], 'CANCELADA');
    });

    testWidgets('4.4: detalle en camino con «Cancelar asistencia»', (
      tester,
    ) async {
      final id = (await tester.runAsync(confirmada))!;
      await abrir(
        tester,
        AsistenciaDetallePage(id: id, onBack: () {}, onPedirOtra: () {}),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tu asistencia'), findsOneWidget);
      expect(find.text('En camino · llega en 6 min'), findsOneWidget);
      expect(find.text('Cancelar asistencia'), findsOneWidget);
      expect(find.text('Reintentar'), findsNothing);
    });

    testWidgets('4.4: detalle de una que ya llegó, sin acciones', (
      tester,
    ) async {
      final id = (await tester.runAsync(confirmada))!;
      ahora = ahora.add(const Duration(minutes: 10));
      await abrir(
        tester,
        AsistenciaDetallePage(id: id, onBack: () {}, onPedirOtra: () {}),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Llegó ·'), findsOneWidget);
      expect(find.text('Cancelar asistencia'), findsNothing);
      expect(find.text('Reintentar'), findsNothing);
    });

    testWidgets('4.4: una que no existe dice que no la encontramos', (
      tester,
    ) async {
      await abrir(
        tester,
        AsistenciaDetallePage(
          id: 'no-existe',
          onBack: () {},
          onPedirOtra: () {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No encontramos esa asistencia.'), findsOneWidget);
    });
  });
}
