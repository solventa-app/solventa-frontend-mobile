import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/ubicacion/coordenada.dart';
import 'package:solventa_mobile/features/claims/data/cola_reportes.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';

final _poliza = PolizaReportable(
  id: 'pol-1',
  numero: 'AUTO-0001',
  vigenciaDesde: DateTime.utc(2026),
  vigenciaHasta: DateTime.utc(2027),
  esAuto: true,
  vehiculo: 'MAZDA ABC•••',
);

/// Deja hacer algo justo después de cada subida (p. ej. cortar la red).
final class _SubidaEspia implements SubidaArchivoService {
  final _real = FakeSubidaArchivoService();
  void Function(int cuantas)? despuesDeSubir;

  List<String> get subidas => _real.subidas;

  @override
  Future<void> subir({
    required String url,
    required String metodo,
    required Map<String, String> encabezados,
    required Uint8List bytes,
    void Function(int enviados)? alAvanzar,
  }) async {
    await _real.subir(
      url: url,
      metodo: metodo,
      encabezados: encabezados,
      bytes: bytes,
      alAvanzar: alAvanzar,
    );
    despuesDeSubir?.call(subidas.length);
  }
}

/// HU-M05 (sin conexión, plan 4.4 y 6): la cola de envío.
void main() {
  late AlmacenReportesMemoria almacen;
  late FakeReporteSiniestroRemoteDataSource bff;
  late _SubidaEspia subida;
  late ColaReportes cola;
  late DateTime ahora;
  late List<EventoCola> eventos;
  String? cuenta;
  var conectado = true;
  var datosMoviles = false;
  var soloWifi = false;
  var sesion = true;
  var porRenovar = false;

  setUp(() {
    almacen = AlmacenReportesMemoria();
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    subida = _SubidaEspia();
    ahora = DateTime.utc(2026, 11, 20, 15);
    cuenta = 'c1';
    conectado = true;
    datosMoviles = false;
    soloWifi = false;
    sesion = true;
    porRenovar = false;
    cola = ColaReportes(
      almacen: almacen,
      remoto: bff,
      subida: subida,
      cuenta: () => cuenta,
      conectado: () => conectado,
      porDatosMoviles: () => datosMoviles,
      soloWifi: () => soloWifi,
      sesionAbierta: () => sesion,
      sesionPorRenovar: () => porRenovar,
      reloj: () => ahora,
    );
    eventos = [];
    final escucha = cola.eventos.listen(eventos.add);
    addTearDown(() async {
      await escucha.cancel();
      cola.cerrar();
      almacen.cerrar();
    });
  });

  Future<void> pendiente(
    String id, {
    int fotos = 2,
    Duration hace = Duration.zero,
    EstadoLocal estado = EstadoLocal.pendiente,
    String cuentaId = 'c1',
  }) async {
    final cuando = ahora.subtract(hace);
    await almacen.guardar(
      ReporteGuardado(
        id: id,
        cuentaId: cuentaId,
        estado: estado,
        creadoEn: cuando,
        actualizadoEn: cuando,
        guardadoEn: cuando,
        poliza: _poliza,
        tipoAuto: TipoSiniestroAuto.choqueParcial,
        ocurridoEn: cuando,
        descripcion: 'Me chocaron por detrás en un semáforo.',
        lugar: 'Calle 100 con 15',
        ciudad: 'Bogotá',
        ubicacion: const Coordenada(4.68, -74.05),
      ),
    );
    for (var i = 0; i < fotos; i++) {
      await almacen.agregarFoto(
        id,
        bytes: Uint8List.fromList(List.filled(100, i)),
        tipoContenido: 'image/jpeg',
        tomadaEn: cuando,
        ubicacion: const Coordenada(4.68, -74.05),
      );
    }
  }

  Future<ReporteGuardado> leer(String id) async => (await almacen.leer(id))!;

  group('envío', () {
    test('sube las fotos, radica y deja el reporte enviado', () async {
      await pendiente('r1');

      await cola.despertar();

      final r = await leer('r1');
      expect(r.estado, EstadoLocal.enviado);
      expect(r.resultado?.radicado, 'SIN-2026-1001');
      expect(r.enviadoEn, ahora);
      expect(r.fotos.every((f) => f.subida), isTrue);
      expect(subida.subidas, hasLength(2));
      expect(bff.reportes.single.idReporte, 'r1');
      expect(bff.reportes.single.fotos, hasLength(2));
      // Las fotos ya no hacen falta en el teléfono.
      expect(await almacen.bytesDeFoto(r.fotos.first.id), isNull);
      expect(eventos.whereType<ReporteEnviado>(), hasLength(1));
      final fin = eventos.whereType<CorridaTerminada>().single;
      expect((fin.enviados, fin.porCorregir), (1, 0));
      expect(fin.ultimoEnviado?.id, 'r1');
    });

    test('del más antiguo al más nuevo, uno a la vez', () async {
      await pendiente('nuevo');
      await pendiente('viejo', hace: const Duration(hours: 2));

      await cola.despertar();

      expect([for (final r in bff.reportes) r.idReporte], ['viejo', 'nuevo']);
      final fin = eventos.whereType<CorridaTerminada>().single;
      expect(fin.enviados, 2);
    });

    test('no envía borradores ni lo de otra cuenta', () async {
      await pendiente('borrador', estado: EstadoLocal.borrador);
      await pendiente('ajeno', cuentaId: 'c2');

      await cola.despertar();

      expect(bff.reportes, isEmpty);
      expect((await leer('borrador')).estado, EstadoLocal.borrador);
      expect((await leer('ajeno')).estado, EstadoLocal.pendiente);
    });

    test('dos disparos a la vez no envían dos veces', () async {
      await pendiente('r1');

      await Future.wait([cola.despertar(), cola.despertar()]);

      expect(bff.reportes, hasLength(1));
      expect(subida.subidas, hasLength(2));
    });

    test(
      'el progreso avanza por bytes y reserva el final para radicar',
      () async {
        await pendiente('r1');
        final vistos = <ProgresoCola>[];
        final escucha = cola.cambios.listen(vistos.add);
        addTearDown(escucha.cancel);

        await cola.despertar();
        await Future<void>.delayed(Duration.zero);

        final enCurso = vistos.where((p) => p.activa).toList();
        expect(enCurso.first.porcentaje, 0);
        expect(enCurso.map((p) => p.foto), containsAll([1, 2]));
        expect(enCurso.every((p) => p.fotos == 2 && p.total == 1), isTrue);
        final fracciones = [for (final p in enCurso) p.fraccion];
        expect(fracciones, [...fracciones]..sort());
        final radicando = enCurso.lastWhere((p) => p.radicando);
        expect(radicando.porcentaje, 95);
        expect(vistos.last.activa, isFalse);
      },
    );
  });

  group('fallas de red', () {
    test('sin conexión no intenta nada y espera', () async {
      await pendiente('r1');
      conectado = false;

      await cola.despertar();

      expect(subida.subidas, isEmpty);
      expect((await leer('r1')).estado, EstadoLocal.pendiente);
      expect(cola.progreso.espera, EsperaCola.sinRed);
    });

    test('se cae a mitad: guarda lo subido y al volver sube solo lo que '
        'faltaba', () async {
      await pendiente('r1', fotos: 3);
      // La primera foto sube; al pedir la URL de la segunda se cae la red.
      subida.despuesDeSubir = (cuantas) {
        if (cuantas == 1) {
          bff.errorAlSolicitar = const ErrorRed(tipo: 'connectionError');
        }
      };

      await cola.despertar();

      var r = await leer('r1');
      expect(r.estado, EstadoLocal.pendiente);
      expect(r.fotosSubidas, 1);
      expect(r.proximoIntentoEn, ahora.add(const Duration(seconds: 10)));
      expect(r.radicacionIncierta, isFalse);
      expect(cola.progreso.espera, EsperaCola.sinRed);
      expect(bff.reportes, isEmpty);

      // Vuelve la red: no espera los 10 s y no repite la primera foto.
      await cola.despertar(reiniciarEsperas: true);

      r = await leer('r1');
      expect(r.estado, EstadoLocal.enviado);
      expect(subida.subidas, hasLength(3));
      expect(bff.reportes.single.fotos, hasLength(3));
    });

    test('las esperas crecen: 10 s, 1 min, 5 min y 15 min', () async {
      await pendiente('r1', fotos: 1);
      final esperas = <Duration>[];
      for (var i = 0; i < 5; i++) {
        bff.errorAlSolicitar = const ErrorRed(tipo: 'connectionError');
        await cola.despertar(reiniciarEsperas: true);
        esperas.add((await leer('r1')).proximoIntentoEn!.difference(ahora));
      }

      expect(esperas, const [
        Duration(seconds: 10),
        Duration(minutes: 1),
        Duration(minutes: 5),
        Duration(minutes: 15),
        Duration(minutes: 15),
      ]);
    });

    test('antes de su hora no reintenta; después sí', () async {
      await pendiente('r1', fotos: 1);
      bff.errorAlSolicitar = const ErrorRed(tipo: 'connectionError');
      await cola.despertar();

      await cola.despertar();
      expect((await leer('r1')).estado, EstadoLocal.pendiente);
      expect(bff.reportes, isEmpty);

      ahora = ahora.add(const Duration(seconds: 11));
      await cola.despertar();
      expect((await leer('r1')).estado, EstadoLocal.enviado);
    });

    test('la respuesta de radicar se pierde: no se puede editar y el '
        'reintento usa el mismo idReporte', () async {
      await pendiente('r1', fotos: 1);
      bff.errorAlReportar = const ErrorTiempoRespuesta();

      await cola.despertar();

      var r = await leer('r1');
      expect(r.estado, EstadoLocal.pendiente);
      expect(r.radicacionIncierta, isTrue);
      expect(r.editable, isFalse);

      await cola.despertar(reiniciarEsperas: true);

      r = await leer('r1');
      expect(r.estado, EstadoLocal.enviado);
      expect(r.radicacionIncierta, isFalse);
      expect(bff.reportes.single.idReporte, 'r1');
      expect(subida.subidas, hasLength(1));
    });

    test('la subida terminó pero no se confirma: solo esa foto se sube '
        'otra vez', () async {
      await pendiente('r1');
      bff.confirmacionesFallidas = 1;

      await cola.despertar();

      var r = await leer('r1');
      expect(r.estado, EstadoLocal.pendiente);
      expect(r.intentos, 1);
      expect(r.fotosSubidas, 0);

      await cola.enviarAhora('r1');

      r = await leer('r1');
      expect(r.estado, EstadoLocal.enviado);
      expect(subida.subidas, hasLength(3));
    });
  });

  group('rechazos y fallas que no se arreglan solas', () {
    test('la aseguradora lo rechaza: con error, con su motivo, sin '
        'reintento', () async {
      await pendiente('r1');
      bff.rechazar = true;

      await cola.despertar();

      final r = await leer('r1');
      expect(r.estado, EstadoLocal.conError);
      expect(r.ultimoError, contains('vigencia de la póliza'));
      expect(r.proximoIntentoEn, isNull);
      expect(r.editable, isTrue);
      // Las fotos siguen en el teléfono para corregir y reenviar.
      expect(await almacen.bytesDeFoto(r.fotos.first.id), isNotNull);
      expect(eventos.whereType<ReporteRechazado>(), hasLength(1));
      expect(eventos.whereType<CorridaTerminada>().single.porCorregir, 1);

      bff.rechazar = false;
      await cola.despertar(reiniciarEsperas: true);
      expect((await leer('r1')).estado, EstadoLocal.conError);
    });

    test('tras 8 fallas técnicas queda en «Necesita atención» y «Enviar '
        'ahora» lo reactiva', () async {
      await pendiente('r1', fotos: 1);
      for (var i = 0; i < ColaReportes.maxIntentos; i++) {
        bff.errorAlReportar = const ErrorHttp(500);
        await cola.despertar(reiniciarEsperas: true);
      }

      var r = await leer('r1');
      expect(r.estado, EstadoLocal.necesitaAtencion);
      expect(r.intentos, ColaReportes.maxIntentos);
      expect(r.ultimoError, errorTecnicoDeEnvio);
      expect(eventos.whereType<ReporteNecesitaAtencion>(), hasLength(1));

      // Ya no se reintenta solo.
      await cola.despertar(reiniciarEsperas: true);
      expect((await leer('r1')).estado, EstadoLocal.necesitaAtencion);

      await cola.enviarAhora('r1');
      r = await leer('r1');
      expect(r.estado, EstadoLocal.enviado);
      expect(subida.subidas, hasLength(1));
    });

    test('una falla de un reporte no detiene a los demás', () async {
      await pendiente('malo', hace: const Duration(hours: 1));
      await pendiente('bueno');
      bff.errorAlReportar = const ErrorHttp(500);

      await cola.despertar();

      expect((await leer('malo')).estado, EstadoLocal.pendiente);
      expect((await leer('bueno')).estado, EstadoLocal.enviado);
    });
  });

  group('sesión', () {
    test('sin sesión la cola espera y avisa una sola vez', () async {
      await pendiente('r1');
      sesion = false;

      await cola.despertar();
      await cola.despertar();

      expect(subida.subidas, isEmpty);
      expect(cola.progreso.espera, EsperaCola.sinSesion);
      expect(eventos.whereType<SesionRequerida>(), hasLength(1));

      sesion = true;
      await cola.despertar();
      expect((await leer('r1')).estado, EstadoLocal.enviado);
    });

    test('en modo sin conexión (la sesión se renueva sola) espera sin pedir '
        'que inicie sesión', () async {
      await pendiente('r1');
      sesion = false;
      porRenovar = true;

      await cola.despertar();

      expect(subida.subidas, isEmpty);
      expect(cola.progreso.espera, EsperaCola.sinSesion);
      expect(eventos.whereType<SesionRequerida>(), isEmpty);

      // La app renovó la sesión al volver la red.
      sesion = true;
      porRenovar = false;
      await cola.despertar();
      expect((await leer('r1')).estado, EstadoLocal.enviado);
    });

    test('la sesión vence a mitad: se detiene sin perder lo subido', () async {
      await pendiente('r1', fotos: 1);
      bff.errorAlReportar = const ErrorHttp(401);

      await cola.despertar();

      final r = await leer('r1');
      expect(r.estado, EstadoLocal.pendiente);
      expect(r.fotosSubidas, 1);
      expect(r.intentos, 0);
      expect(cola.progreso.espera, EsperaCola.sinSesion);
      expect(eventos.whereType<SesionRequerida>(), hasLength(1));
    });

    test('sin cuenta no hace nada', () async {
      await pendiente('r1');
      cuenta = null;

      await cola.despertar();

      expect(subida.subidas, isEmpty);
    });
  });

  group('datos móviles', () {
    test('con «solo Wi-Fi» y datos móviles espera y avisa una vez', () async {
      await pendiente('r1');
      datosMoviles = true;
      soloWifi = true;

      await cola.despertar();
      await cola.despertar();

      final r = await leer('r1');
      expect(r.estado, EstadoLocal.pendiente);
      expect(r.avisoWifiDado, isTrue);
      expect(cola.progreso.espera, EsperaCola.wifi);
      expect(eventos.whereType<ReporteEsperaWifi>(), hasLength(1));

      // Llega el Wi-Fi.
      datosMoviles = false;
      await cola.despertar(reiniciarEsperas: true);
      expect((await leer('r1')).estado, EstadoLocal.enviado);
    });

    test('«Enviar ahora con datos» vale para ese reporte, sin cambiar la '
        'preferencia', () async {
      await pendiente('r1', hace: const Duration(hours: 1));
      await pendiente('r2');
      datosMoviles = true;
      soloWifi = true;

      await cola.enviarAhora('r1', conDatos: true);

      expect((await leer('r1')).estado, EstadoLocal.enviado);
      expect((await leer('r2')).estado, EstadoLocal.pendiente);
    });

    test('el cliente pidió esperar Wi-Fi solo para este reporte', () async {
      await pendiente('r1');
      await almacen.actualizar('r1', (a) => a.copyWith(esperaWifi: true));
      datosMoviles = true;

      await cola.despertar();
      expect((await leer('r1')).estado, EstadoLocal.pendiente);

      datosMoviles = false;
      await cola.despertar();
      expect((await leer('r1')).estado, EstadoLocal.enviado);
    });

    test('sin la preferencia, por datos móviles se envía', () async {
      await pendiente('r1');
      datosMoviles = true;

      await cola.despertar();

      expect((await leer('r1')).estado, EstadoLocal.enviado);
    });
  });

  group('la app se cerró a mitad de un envío', () {
    test('lo que quedó «Enviando» vuelve a la cola y sigue desde la foto '
        'que faltaba', () async {
      await pendiente('r1', estado: EstadoLocal.enviando);
      final fotos = (await leer('r1')).fotos;
      await almacen.marcarFotoSubida(fotos.first.id, 'arch-previa');

      await cola.recuperar();
      expect((await leer('r1')).estado, EstadoLocal.pendiente);

      await cola.despertar();

      final r = await leer('r1');
      expect(r.estado, EstadoLocal.enviado);
      expect(subida.subidas, hasLength(1));
      expect(bff.reportes.single.fotos.first.archivoId, 'arch-previa');
    });
  });

  group('enviarYEsperar', () {
    test('termina con el reporte enviado', () async {
      await pendiente('r1');

      final r = await cola.enviarYEsperar('r1');

      expect(r?.estado, EstadoLocal.enviado);
    });

    test('sin red termina enseguida, con el reporte aún pendiente', () async {
      await pendiente('r1');
      conectado = false;

      final r = await cola.enviarYEsperar('r1');

      expect(r?.estado, EstadoLocal.pendiente);
    });

    test('no espera a los que van detrás en la cola', () async {
      await pendiente('r1', hace: const Duration(hours: 1));
      await pendiente('r2');
      ReporteGuardado? segundoAlTerminarElPrimero;

      final r = await cola.enviarYEsperar('r1');
      segundoAlTerminarElPrimero = await almacen.leer('r2');
      await cola.despertar();

      expect(r?.estado, EstadoLocal.enviado);
      expect(segundoAlTerminarElPrimero?.estado, isNot(EstadoLocal.enviado));
      expect((await leer('r2')).estado, EstadoLocal.enviado);
    });

    test('el reporte se edita mientras espera turno: no se envía', () async {
      await pendiente('r1');
      conectado = false;
      await cola.despertar();
      await almacen.actualizar(
        'r1',
        (a) => a.copyWith(estado: EstadoLocal.borrador),
      );
      conectado = true;

      await cola.despertar(reiniciarEsperas: true);

      expect(bff.reportes, isEmpty);
      expect((await leer('r1')).estado, EstadoLocal.borrador);
    });
  });
}
