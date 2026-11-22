import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/almacen/base_local.dart';
import 'package:solventa_mobile/core/ubicacion/coordenada.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_drift.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/local/reporte_local_mapper.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/domain/repositories/almacen_reportes.dart';

final _t0 = DateTime.utc(2026, 11, 20, 15);
final _bytes = Uint8List.fromList(List.generate(64, (i) => i));

final _poliza = PolizaReportable(
  id: 'pol-1',
  numero: 'AUTO-0001',
  vigenciaDesde: DateTime.utc(2026),
  vigenciaHasta: DateTime.utc(2027),
  esAuto: true,
  vehiculo: 'MAZDA ABC•••',
);

ReporteGuardado _reporte(
  String id, {
  String cuenta = 'c1',
  EstadoLocal estado = EstadoLocal.borrador,
  DateTime? creadoEn,
}) => ReporteGuardado(
  id: id,
  cuentaId: cuenta,
  estado: estado,
  creadoEn: creadoEn ?? _t0,
  actualizadoEn: creadoEn ?? _t0,
);

/// Las dos implementaciones cumplen el mismo contrato.
void _contrato(String nombre, AlmacenReportes Function() crear) {
  group(nombre, () {
    late AlmacenReportes almacen;

    setUp(() {
      almacen = crear();
      addTearDown(almacen.cerrar);
    });

    test('guarda y lee un reporte con todos sus datos', () async {
      final completo = _reporte('r1').copyWith(
        estado: EstadoLocal.conError,
        poliza: () => _poliza,
        tipoAuto: () => TipoSiniestroAuto.choqueParcial,
        ocurridoEn: () => DateTime.utc(2026, 11, 19, 8, 30),
        descripcion: 'Me chocaron por detrás en un semáforo.',
        lugar: 'Calle 100 con 15',
        ciudad: 'Bogotá',
        ubicacion: () => const Coordenada(4.6861, -74.0483),
        direccionEscrita: () => 'Calle 100 # 15-20',
        guardadoEn: () => _t0,
        intentos: 3,
        proximoIntentoEn: () => _t0.add(const Duration(minutes: 5)),
        ultimoError: () => 'La póliza no estaba vigente',
        radicacionIncierta: true,
        datosPermitidos: true,
        avisoWifiDado: true,
        enviadoEn: () => _t0,
        resultado: () => SiniestroReportado(
          id: 'r1',
          radicado: 'SIN-2026-000123',
          estado: 'PENDIENTE',
          notificadoEn: _t0,
          venceDictamenEn: _t0.add(const Duration(days: 3)),
          fotos: 2,
          tipoAuto: TipoSiniestroAuto.choqueParcial,
        ),
      );

      await almacen.guardar(completo);
      final leido = (await almacen.leer('r1'))!;

      expect(leido.cuentaId, 'c1');
      expect(leido.estado, EstadoLocal.conError);
      expect(leido.poliza!.numero, 'AUTO-0001');
      expect(leido.poliza!.vehiculo, 'MAZDA ABC•••');
      expect(leido.poliza!.esAuto, isTrue);
      expect(leido.tipoAuto, TipoSiniestroAuto.choqueParcial);
      expect(leido.ocurridoEn, DateTime.utc(2026, 11, 19, 8, 30));
      expect(leido.descripcion, 'Me chocaron por detrás en un semáforo.');
      expect(leido.lugar, 'Calle 100 con 15');
      expect(leido.ciudad, 'Bogotá');
      expect(leido.ubicacion, const Coordenada(4.6861, -74.0483));
      expect(leido.direccionEscrita, 'Calle 100 # 15-20');
      expect(leido.guardadoEn, _t0);
      expect(leido.intentos, 3);
      expect(leido.proximoIntentoEn, _t0.add(const Duration(minutes: 5)));
      expect(leido.ultimoError, 'La póliza no estaba vigente');
      expect(leido.radicacionIncierta, isTrue);
      expect(leido.datosPermitidos, isTrue);
      expect(leido.avisoWifiDado, isTrue);
      expect(leido.resultado!.radicado, 'SIN-2026-000123');
      expect(leido.enviadoEn, _t0);
      expect(leido.creadoEn, _t0);
    });

    test('leer uno que no existe da null', () async {
      expect(await almacen.leer('nada'), isNull);
    });

    test(
      'cada cuenta ve solo sus reportes, del más antiguo al más nuevo',
      () async {
        await almacen.guardar(
          _reporte('nuevo', creadoEn: _t0.add(const Duration(hours: 1))),
        );
        await almacen.guardar(_reporte('viejo'));
        await almacen.guardar(_reporte('ajeno', cuenta: 'c2'));

        expect((await almacen.deCuenta('c1')).map((r) => r.id), [
          'viejo',
          'nuevo',
        ]);
        expect((await almacen.deCuenta('c2')).single.id, 'ajeno');
        expect(await almacen.deCuenta('c3'), isEmpty);
      },
    );

    test(
      'las fotos se guardan con el reporte y sus bytes se leen aparte',
      () async {
        await almacen.guardar(_reporte('r1'));

        final a = await almacen.agregarFoto(
          'r1',
          bytes: _bytes,
          tipoContenido: 'image/jpeg',
          tomadaEn: _t0,
          ubicacion: const Coordenada(4.6, -74.1),
        );
        final b = await almacen.agregarFoto(
          'r1',
          bytes: Uint8List.fromList([9, 9]),
          tipoContenido: 'image/png',
          tomadaEn: _t0.add(const Duration(minutes: 1)),
        );

        final fotos = (await almacen.leer('r1'))!.fotos;
        expect(fotos.map((f) => f.id), [a.id, b.id]);
        expect(fotos.map((f) => f.orden), [0, 1]);
        expect(fotos.first.tamano, 64);
        expect(fotos.first.tipoContenido, 'image/jpeg');
        expect(fotos.first.tomadaEn, _t0);
        expect(fotos.first.ubicacion, const Coordenada(4.6, -74.1));
        expect(fotos.first.subida, isFalse);
        expect(fotos.last.ubicacion, isNull);
        expect(await almacen.bytesDeFoto(a.id), _bytes);
        expect((await almacen.leer('r1'))!.bytesFotos, 66);
        expect((await almacen.deCuenta('c1')).single.fotos, hasLength(2));
      },
    );

    test('guardar los datos del reporte no borra sus fotos', () async {
      await almacen.guardar(_reporte('r1'));
      await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
      );

      await almacen.guardar(_reporte('r1').copyWith(lugar: 'Calle 1'));

      final leido = (await almacen.leer('r1'))!;
      expect(leido.lugar, 'Calle 1');
      expect(leido.fotos, hasLength(1));
    });

    test('quitar una foto borra también sus bytes', () async {
      await almacen.guardar(_reporte('r1'));
      final a = await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
      );

      await almacen.quitarFoto(a.id);

      expect((await almacen.leer('r1'))!.fotos, isEmpty);
      expect(await almacen.bytesDeFoto(a.id), isNull);
    });

    test('la foto subida recuerda su archivo; editar lo olvida', () async {
      await almacen.guardar(_reporte('r1'));
      final a = await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
      );

      await almacen.marcarFotoSubida(a.id, 'arch-1');
      var leido = (await almacen.leer('r1'))!;
      expect(leido.fotos.single.archivoId, 'arch-1');
      expect(leido.fotosSubidas, 1);

      await almacen.olvidarSubidas('r1');
      leido = (await almacen.leer('r1'))!;
      expect(leido.fotos.single.subida, isFalse);
    });

    test('la dirección escrita ubica solo las fotos sin GPS', () async {
      await almacen.guardar(_reporte('r1'));
      await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
        ubicacion: const Coordenada(1, 1),
      );
      await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
      );

      await almacen.ubicarFotosSinGps('r1', const Coordenada(4, -74));
      // Cambiar la dirección mueve las que venían de la dirección anterior.
      await almacen.ubicarFotosSinGps('r1', const Coordenada(5, -75));

      final fotos = (await almacen.leer('r1'))!.fotos;
      expect(fotos[0].ubicacion, const Coordenada(1, 1));
      expect(fotos[0].deDireccion, isFalse);
      expect(fotos[1].ubicacion, const Coordenada(5, -75));
      expect(fotos[1].deDireccion, isTrue);
    });

    test('enviado: se borran los bytes y queda el registro', () async {
      await almacen.guardar(_reporte('r1'));
      final a = await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
      );

      await almacen.borrarBytesDeFotos('r1');

      expect(await almacen.bytesDeFoto(a.id), isNull);
      expect((await almacen.leer('r1'))!.fotos, hasLength(1));
    });

    test('actualizar lee, cambia y guarda; si no existe da null', () async {
      await almacen.guardar(_reporte('r1'));
      await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
      );

      final nuevo = await almacen.actualizar(
        'r1',
        (r) =>
            r.copyWith(estado: EstadoLocal.pendiente, intentos: r.intentos + 1),
      );

      expect(nuevo!.estado, EstadoLocal.pendiente);
      expect(nuevo.intentos, 1);
      expect((await almacen.leer('r1'))!.estado, EstadoLocal.pendiente);
      expect((await almacen.leer('r1'))!.fotos, hasLength(1));
      expect(await almacen.actualizar('nada', (r) => r), isNull);
    });

    test('borrar un reporte se lleva sus fotos', () async {
      await almacen.guardar(_reporte('r1'));
      final a = await almacen.agregarFoto(
        'r1',
        bytes: _bytes,
        tipoContenido: 'image/jpeg',
        tomadaEn: _t0,
      );

      await almacen.borrar('r1');

      expect(await almacen.leer('r1'), isNull);
      expect(await almacen.bytesDeFoto(a.id), isNull);
    });

    test('borrar lo de una cuenta no toca lo de otra', () async {
      await almacen.guardar(_reporte('r1'));
      await almacen.guardar(_reporte('r2', cuenta: 'c2'));

      await almacen.borrarDeCuenta('c1');

      expect(await almacen.deCuenta('c1'), isEmpty);
      expect(await almacen.deCuenta('c2'), hasLength(1));
    });

    test('avisa cada cambio', () async {
      var avisos = 0;
      final sub = almacen.cambios.listen((_) => avisos++);
      addTearDown(sub.cancel);

      await almacen.guardar(_reporte('r1'));
      await almacen.actualizar('r1', (r) => r.copyWith(lugar: 'x'));
      await almacen.borrar('r1');
      await Future<void>.delayed(Duration.zero);

      expect(avisos, 3);
    });
  });
}

void main() {
  _contrato('AlmacenReportesMemoria', AlmacenReportesMemoria.new);

  BaseLocal? base;
  _contrato('AlmacenReportesDrift', () {
    final nueva = BaseLocal.enMemoria();
    base = nueva;
    addTearDown(nueva.close);
    return AlmacenReportesDrift(nueva);
  });

  test('en la base, los bytes no viajan con la lista de reportes', () async {
    final nueva = BaseLocal.enMemoria();
    addTearDown(nueva.close);
    final almacen = AlmacenReportesDrift(nueva);
    addTearDown(almacen.cerrar);
    await almacen.guardar(_reporte('r1'));
    await almacen.agregarFoto(
      'r1',
      bytes: _bytes,
      tipoContenido: 'image/jpeg',
      tomadaEn: _t0,
    );

    final filas = await nueva
        .customSelect('SELECT length(bytes) AS n FROM fotos_reporte')
        .get();
    expect(filas.single.read<int>('n'), 64);
    expect(base, isNotNull);
  });

  group('reglas del reporte guardado', () {
    final foto = FotoGuardada(
      id: 1,
      orden: 0,
      tamano: 10,
      tipoContenido: 'image/jpeg',
      tomadaEn: _t0,
    );
    final listo = _reporte('r1').copyWith(
      poliza: () => _poliza,
      tipoAuto: () => TipoSiniestroAuto.hurtoTotal,
      ocurridoEn: () => _t0,
      descripcion: 'Me robaron el carro frente a la casa.',
      lugar: 'Carrera 7',
      ciudad: 'Bogotá',
      ubicacion: () => const Coordenada(4, -74),
      fotos: [foto],
    );

    test('completo exige lo mismo que el backend', () {
      expect(listo.completo, isTrue);
      expect(listo.copyWith(fotos: const []).completo, isFalse);
      expect(listo.copyWith(tipoAuto: () => null).completo, isFalse);
      expect(listo.copyWith(ubicacion: () => null).completo, isFalse);
      expect(listo.copyWith(descripcion: 'corto').completo, isFalse);
      expect(listo.copyWith(ciudad: ' ').completo, isFalse);
    });

    test('no se edita mientras se envía ni con la radicación en duda', () {
      expect(listo.editable, isTrue);
      expect(listo.copyWith(estado: EstadoLocal.pendiente).editable, isTrue);
      expect(listo.copyWith(estado: EstadoLocal.conError).editable, isTrue);
      expect(listo.copyWith(estado: EstadoLocal.enviando).editable, isFalse);
      expect(listo.copyWith(estado: EstadoLocal.enviado).editable, isFalse);
      expect(listo.copyWith(radicacionIncierta: true).editable, isFalse);
    });

    test('en cola: pendiente o enviando', () {
      expect(listo.enCola, isFalse);
      expect(listo.copyWith(estado: EstadoLocal.pendiente).enCola, isTrue);
      expect(listo.copyWith(estado: EstadoLocal.enviando).enCola, isTrue);
      expect(listo.copyWith(estado: EstadoLocal.enviado).porEnviar, isFalse);
    });

    test('un estado desconocido se lee como borrador', () {
      expect(EstadoLocal.deCodigo('OTRO'), EstadoLocal.borrador);
      expect(EstadoLocal.deCodigo('CON_ERROR'), EstadoLocal.conError);
    });
  });

  group('copias en JSON', () {
    test('las pólizas van y vuelven', () {
      final vuelta = polizasDesdeJson(polizasAJson([_poliza])).single;

      expect(vuelta.id, 'pol-1');
      expect(vuelta.vigenciaHasta, DateTime.utc(2027));
      expect(vuelta.cubre(DateTime.utc(2026, 6)), isTrue);
    });

    test('los siniestros van y vuelven con su resolución', () {
      final caso = SiniestroReportado(
        id: 's1',
        radicado: 'SIN-1',
        estado: 'APROBADO',
        notificadoEn: _t0,
        venceDictamenEn: _t0,
        fotos: 3,
        ocurridoEn: _t0,
        polizaId: 'pol-1',
        resolucion: ResolucionSiniestro(
          tipo: 'APROBACION',
          resueltaEn: _t0,
          indemnizacion: 1500000,
          plazoDispersion: '3 días hábiles',
        ),
      );

      final vuelta = siniestrosDesdeJson(siniestrosAJson([caso])).single;

      expect(vuelta.radicado, 'SIN-1');
      expect(vuelta.fotos, 3);
      expect(vuelta.resolucion!.indemnizacion, 1500000);
      expect(vuelta.resolucion!.plazoDispersion, '3 días hábiles');
    });

    test('una copia dañada no rompe: se ignora lo ilegible', () {
      expect(polizasDesdeJson('{"no":"lista"}'), isEmpty);
      expect(polizasDesdeJson('[{"id":1}, null]'), isEmpty);
      expect(siniestrosDesdeJson('[{"id":"s1"}]'), isEmpty);
    });
  });

  group('cuenta y copias', () {
    void contratoLocal(String nombre, AlmacenLocal Function() crear) {
      group(nombre, () {
        late AlmacenLocal local;
        setUp(() => local = crear());

        CuentaLocal cuenta(String id, {DateTime? en}) => CuentaLocal(
          id: id,
          nombre: 'Ana',
          verificada: true,
          ultimaConexion: en ?? _t0,
        );

        test('la última cuenta guardada es la activa', () async {
          expect(await local.cuentaActiva(), isNull);

          await local.guardarCuenta(cuenta('c1'));
          await local.guardarCuenta(cuenta('c2'));

          final activa = (await local.cuentaActiva())!;
          expect(activa.id, 'c2');
          expect(activa.nombre, 'Ana');
          expect(activa.verificada, isTrue);
          expect(activa.ultimaConexion, _t0);
        });

        test(
          'cerrar sesión deja sin cuenta activa y borra las copias',
          () async {
            await local.guardarCuenta(cuenta('c1'));
            await local.guardarCopia('c1', 'polizas', '[]', _t0);

            await local.cerrarCuenta();

            expect(await local.cuentaActiva(), isNull);
            expect(await local.leerCopia('c1', 'polizas'), isNull);
          },
        );

        test('las copias son por cuenta y por clave, con su hora', () async {
          await local.guardarCopia('c1', 'polizas', '[1]', _t0);
          await local.guardarCopia('c1', 'polizas', '[2]', _t0);
          await local.guardarCopia('c2', 'polizas', '[3]', _t0);

          final copia = (await local.leerCopia('c1', 'polizas'))!;
          expect(copia.json, '[2]');
          expect(copia.guardadaEn, _t0);
          expect((await local.leerCopia('c2', 'polizas'))!.json, '[3]');
          expect(await local.leerCopia('c1', 'siniestros'), isNull);
        });

        test(
          'las cuentas que no vuelven en 30 días se pueden olvidar',
          () async {
            await local.guardarCuenta(cuenta('vieja'));
            await local.guardarCuenta(
              cuenta('actual', en: _t0.add(const Duration(days: 40))),
            );
            final limite = _t0.add(const Duration(days: 10));

            expect(await local.cuentasSinEntrarDesde(limite), ['vieja']);

            await local.olvidarCuenta('vieja');
            expect(await local.cuentasSinEntrarDesde(limite), isEmpty);
          },
        );
      });
    }

    contratoLocal('AlmacenLocalMemoria', AlmacenLocalMemoria.new);
    contratoLocal('AlmacenLocalDrift', () {
      final nueva = BaseLocal.enMemoria();
      addTearDown(nueva.close);
      return AlmacenLocalDrift(nueva);
    });
  });
}
