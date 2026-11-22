import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/ubicacion/coordenada.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/notificaciones_reporte.dart';
import 'package:solventa_mobile/features/claims/data/preferencias_envio.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_routes.dart';
import 'package:solventa_mobile/features/claims/presentation/vigia_reportes.dart';

final _ahora = DateTime(2026, 11, 20, 10);
final _poliza = PolizaReportable(
  id: 'pol-1',
  numero: 'AUTO-0001',
  vigenciaDesde: DateTime.utc(2026),
  vigenciaHasta: DateTime.utc(2027),
  esAuto: true,
  vehiculo: 'MAZDA ABC•••',
);

/// Sube de inmediato, salvo que haya una [puerta]: entonces espera a que se
/// abra, para mirar qué pasa a mitad de un envío.
final class _SubidaConPuerta implements SubidaArchivoService {
  Completer<void>? puerta;
  final empezo = Completer<void>();

  @override
  Future<void> subir({
    required String url,
    required String metodo,
    required Map<String, String> encabezados,
    required Uint8List bytes,
    void Function(int enviados)? alAvanzar,
  }) async {
    if (!empezo.isCompleted) empezo.complete();
    await puerta?.future;
    alAvanzar?.call(bytes.length);
  }
}

/// HU-M05 (sin conexión, plan 4.4): quién despierta la cola y qué se avisa.
void main() {
  group('horario de los recordatorios', () {
    test('de día se recuerda a los 30 min, 3 h y 24 h', () {
      final desde = DateTime(2026, 11, 20, 10);

      expect(horasDeRecordatorio(desde, desde), [
        DateTime(2026, 11, 20, 10, 30),
        DateTime(2026, 11, 20, 13),
        DateTime(2026, 11, 21, 10),
      ]);
    });

    test('lo que cae entre las 10 p. m. y las 7 a. m. pasa a las 7 a. m.', () {
      expect(
        fueraDeSilencio(DateTime(2026, 11, 20, 22, 15)),
        DateTime(2026, 11, 21, 7),
      );
      expect(
        fueraDeSilencio(DateTime(2026, 11, 21, 3)),
        DateTime(2026, 11, 21, 7),
      );
      expect(
        fueraDeSilencio(DateTime(2026, 11, 21, 7)),
        DateTime(2026, 11, 21, 7),
      );
    });

    test('de noche, dos recordatorios que caen a la misma hora son uno', () {
      final desde = DateTime(2026, 11, 20, 21, 45);

      // 22:15 y 00:45 pasan a las 7:00; el de 24 h queda a las 21:45.
      expect(horasDeRecordatorio(desde, desde), [
        DateTime(2026, 11, 21, 7),
        DateTime(2026, 11, 21, 21, 45),
      ]);
    });

    test('los que ya pasaron no se programan', () {
      final desde = DateTime(2026, 11, 20, 10);

      expect(horasDeRecordatorio(desde, DateTime(2026, 11, 20, 14)), [
        DateTime(2026, 11, 21, 10),
      ]);
    });
  });

  group('vigía', () {
    late AlmacenReportesMemoria almacen;
    late FakeReporteSiniestroRemoteDataSource bff;
    late ConectividadFalsa conectividad;
    late FakeNotificacionesReporte avisos;
    late ProviderContainer contenedor;
    late VigiaReportes vigia;
    late _SubidaConPuerta subida;
    var sesion = true;

    Future<void> asentar() async {
      for (var i = 0; i < 12; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> crear({TipoRed red = TipoRed.wifi}) async {
      almacen = AlmacenReportesMemoria();
      bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
      conectividad = ConectividadFalsa(red);
      avisos = FakeNotificacionesReporte();
      subida = _SubidaConPuerta();
      sesion = true;
      contenedor = ProviderContainer(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          almacenReportesProvider.overrideWithValue(almacen),
          conectividadProvider.overrideWithValue(conectividad),
          reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
          relojReporteProvider.overrideWithValue(() => _ahora),
          sesionParaEnviarProvider.overrideWithValue(() => sesion),
          notificacionesReporteProvider.overrideWithValue(avisos),
          subidaFotoSiniestroProvider.overrideWithValue(subida),
          preferenciasEnvioStoreProvider.overrideWithValue(
            MemoriaPreferenciasEnvioStore(),
          ),
        ],
      );
      addTearDown(contenedor.dispose);
      contenedor.read(cuentaActualProvider.notifier).fijar('c1');
      // La red se conoce antes de que el vigía empiece a mirar la cola.
      contenedor.listen(estadoRedProvider, (_, _) {});
      await asentar();
      contenedor.listen(vigiaReportesProvider, (_, _) {});
      vigia = contenedor.read(vigiaReportesProvider);
      await asentar();
    }

    Future<void> pendiente(String id, {String cuentaId = 'c1'}) async {
      await almacen.guardar(
        ReporteGuardado(
          id: id,
          cuentaId: cuentaId,
          estado: EstadoLocal.pendiente,
          creadoEn: _ahora.toUtc(),
          actualizadoEn: _ahora.toUtc(),
          guardadoEn: _ahora.toUtc(),
          poliza: _poliza,
          tipoAuto: TipoSiniestroAuto.choqueParcial,
          ocurridoEn: _ahora.toUtc(),
          descripcion: 'Me chocaron por detrás en un semáforo.',
          lugar: 'Calle 100 con 15',
          ciudad: 'Bogotá',
          ubicacion: const Coordenada(4.68, -74.05),
        ),
      );
      await almacen.agregarFoto(
        id,
        bytes: Uint8List.fromList(List.filled(100, 1)),
        tipoContenido: 'image/jpeg',
        tomadaEn: _ahora.toUtc(),
        ubicacion: const Coordenada(4.68, -74.05),
      );
    }

    Future<EstadoLocal?> estadoDe(String id) async =>
        (await almacen.leer(id))?.estado;

    test(
      'con la app al frente no notifica: el envío se ve en la franja',
      () async {
        await crear();
        await pendiente('r1');

        await vigia.despertar();
        await asentar();

        expect(await estadoDe('r1'), EstadoLocal.enviado);
        expect(avisos.avisos, isEmpty);
        expect(avisos.progresoVisible, isNull);
        final franja = contenedor.read(avisoEnvioProvider);
        expect(franja?.enviados, 1);
        expect(franja?.radicado, startsWith('SIN-'));
      },
    );

    test('en segundo plano avisa el radicado y abre el caso', () async {
      await crear();
      await pendiente('r1');
      vigia.alOcultarse();

      await vigia.despertar();
      await asentar();

      expect(avisos.avisos, hasLength(1));
      final (titulo, cuerpo, ruta, suena) = avisos.avisos.single;
      expect(titulo, 'Tu reporte fue enviado');
      expect(cuerpo, contains('SIN-'));
      expect(ruta, startsWith('/siniestros/'));
      expect(suena, isTrue);
    });

    test('en segundo plano, un rechazo lleva a «Mis siniestros»', () async {
      await crear();
      await pendiente('r1');
      bff.rechazar = true;
      vigia.alOcultarse();

      await vigia.despertar();
      await asentar();

      expect(await estadoDe('r1'), EstadoLocal.conError);
      final (titulo, _, ruta, _) = avisos.avisos.single;
      expect(titulo, 'No pudimos enviar tu reporte');
      expect(ruta, ReporteRoutes.misSiniestros);
    });

    test('varios enviados en una corrida son un solo aviso', () async {
      await crear();
      await pendiente('r1');
      await pendiente('r2');
      vigia.alOcultarse();

      await vigia.despertar();
      await asentar();

      expect(avisos.avisos, hasLength(1));
      expect(avisos.avisos.single.$3, ReporteRoutes.misSiniestros);
    });

    test(
      'sin red programa los recordatorios y los quita al enviarse',
      () async {
        await crear(red: TipoRed.ninguna);
        await pendiente('r1');
        await asentar();

        expect(await estadoDe('r1'), EstadoLocal.pendiente);
        expect(avisos.recordatorios, hasLength(3));
        expect(
          avisos.recordatorios.first.titulo,
          'Tienes un reporte por enviar',
        );
        expect(
          avisos.recordatorios.first.cuando,
          DateTime(2026, 11, 20, 10, 30),
        );

        // Vuelve la red: la cola se despierta sola.
        conectividad.cambiar(TipoRed.wifi);
        await asentar();
        await asentar();

        expect(await estadoDe('r1'), EstadoLocal.enviado);
        expect(avisos.recordatorios, isEmpty);
      },
    );

    test('con dos pendientes el recordatorio es uno solo, agrupado', () async {
      await crear(red: TipoRed.ninguna);
      await pendiente('r1');
      await pendiente('r2');
      await asentar();

      expect(avisos.recordatorios, hasLength(3));
      expect(avisos.recordatorios.first.titulo, 'Tienes 2 reportes por enviar');
    });

    test('sin sesión avisa una vez y deja de recordar', () async {
      await crear();
      sesion = false;
      await pendiente('r1');
      vigia.alOcultarse();

      await vigia.despertar();
      await asentar();

      expect(await estadoDe('r1'), EstadoLocal.pendiente);
      expect(
        avisos.avisos.map((a) => a.$1),
        contains('Inicia sesión para enviar tu reporte'),
      );
    });

    test(
      'al cerrar sesión se cancelan todos los avisos de la cuenta',
      () async {
        await crear(red: TipoRed.ninguna);
        await pendiente('r1');
        await asentar();
        expect(avisos.recordatorios, isNotEmpty);

        contenedor.read(cuentaActualProvider.notifier).fijar(null);
        await asentar();

        expect(avisos.cancelaciones, 1);
        expect(avisos.recordatorios, isEmpty);
        // El reporte sigue guardado, a nombre de su cuenta.
        expect(await estadoDe('r1'), EstadoLocal.pendiente);
      },
    );

    group('servicio en primer plano (fase 3b)', () {
      test('corre mientras la cola envía y se detiene al terminar', () async {
        await crear();
        await pendiente('r1');
        subida.puerta = Completer<void>();

        final corrida = vigia.despertar();
        await subida.empezo.future;
        await asentar();

        // A mitad del envío: el servicio está andando con el avance.
        expect(avisos.servicioActivo, isNotNull);
        expect(avisos.servicioActivo!.$1, startsWith('Enviando tu reporte'));
        expect(avisos.arranquesServicio, 1);

        subida.puerta!.complete();
        await corrida;
        await asentar();

        expect(await estadoDe('r1'), EstadoLocal.enviado);
        expect(avisos.servicioActivo, isNull);
        expect(avisos.arranquesServicio, 1);
        expect(avisos.detencionesServicio, 1);
        expect(avisos.progresoVisible, isNull);
      });

      test('si el cliente sale de la app, el envío termina y avisa', () async {
        await crear();
        await pendiente('r1');
        subida.puerta = Completer<void>();

        final corrida = vigia.despertar();
        await subida.empezo.future;
        await asentar();
        vigia.alOcultarse();
        await asentar();

        // La notificación del servicio ya muestra el avance: no hay otra.
        expect(avisos.servicioActivo, isNotNull);
        expect(avisos.progresoVisible, isNull);

        subida.puerta!.complete();
        await corrida;
        await asentar();

        expect(avisos.servicioActivo, isNull);
        expect(avisos.avisos.single.$1, 'Tu reporte fue enviado');
      });

      test('si Android no deja arrancarlo, en segundo plano queda la '
          'notificación de progreso', () async {
        await crear();
        avisos.servicioPermitido = false;
        await pendiente('r1');
        vigia.alOcultarse();
        subida.puerta = Completer<void>();

        final corrida = vigia.despertar();
        await subida.empezo.future;
        await asentar();

        expect(avisos.servicioActivo, isNull);
        expect(avisos.progresoVisible, isNotNull);

        subida.puerta!.complete();
        await corrida;
        await asentar();

        expect(await estadoDe('r1'), EstadoLocal.enviado);
        expect(avisos.progresoVisible, isNull);
        expect(avisos.detencionesServicio, 0);
      });

      test('si se cae la red a mitad, el servicio se detiene y queda dicho '
          'hasta dónde iba', () async {
        await crear();
        await pendiente('r1');
        subida.puerta = Completer<void>();

        final corrida = vigia.despertar();
        await subida.empezo.future;
        await asentar();
        vigia.alOcultarse();
        expect(avisos.servicioActivo, isNotNull);

        // Se cae la red: la subida en curso falla.
        conectividad.cambiar(TipoRed.ninguna);
        await asentar();
        subida.puerta!.completeError(const ErrorRed(tipo: 'connectionError'));
        await corrida;
        await asentar();

        expect(await estadoDe('r1'), EstadoLocal.pendiente);
        expect(avisos.servicioActivo, isNull);
        expect(avisos.detencionesServicio, 1);
        expect(avisos.progresoVisible?.$1, startsWith('Envío en pausa'));
      });

      test(
        'al cerrar sesión con un envío en curso, el servicio se detiene',
        () async {
          await crear();
          await pendiente('r1');
          subida.puerta = Completer<void>();

          final corrida = vigia.despertar();
          await subida.empezo.future;
          await asentar();
          expect(avisos.servicioActivo, isNotNull);

          contenedor.read(cuentaActualProvider.notifier).fijar(null);
          await asentar();

          expect(avisos.servicioActivo, isNull);
          subida.puerta!.complete();
          await corrida;
        },
      );
    });

    test('al volver al frente quita la notificación de progreso', () async {
      await crear();
      avisos.progresoVisible = ('Enviando', 'Foto 1 de 2', 40);

      vigia.alVolverAlFrente();
      await asentar();

      expect(avisos.progresoVisible, isNull);
    });
  });
}
