import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/ubicacion/coordenada.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/reporte_notifier.dart';

final _ahora = DateTime.utc(2026, 11, 20, 15);
final _poliza = PolizaReportable(
  id: 'pol-1',
  numero: 'AUTO-0001',
  vigenciaDesde: DateTime.utc(2026),
  vigenciaHasta: DateTime.utc(2027),
  esAuto: true,
  vehiculo: 'MAZDA ABC•••',
);

Uint8List _foto(int semilla) => Uint8List.fromList([0xFF, 0xD8, semilla, 0xD9]);

/// HU-M05 (sin conexión): desde la primera foto, cada paso del reporte queda
/// escrito en el teléfono como borrador.
void main() {
  late AlmacenReportesMemoria almacen;
  late FakeReporteSiniestroRemoteDataSource bff;
  late ProviderContainer contenedor;

  ProviderContainer crear({String? cuenta = 'c1'}) {
    almacen = AlmacenReportesMemoria();
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    final c = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        cuentaReporteProvider.overrideWithValue(cuenta),
        almacenReportesProvider.overrideWithValue(almacen),
        reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
        relojReporteProvider.overrideWithValue(() => _ahora),
        sesionParaEnviarProvider.overrideWithValue(() => true),
      ],
    );
    addTearDown(c.dispose);
    return contenedor = c;
  }

  ReporteNotifier notifier() => contenedor.read(reporteProvider.notifier);
  ReporteState estado() => contenedor.read(reporteProvider);
  Future<ReporteGuardado?> guardado() => almacen.leer(estado().idReporte);

  /// Llena todo lo que pide el envío.
  Future<void> completar() async {
    notifier()
      ..elegirPoliza(_poliza)
      ..elegirTipoAuto(TipoSiniestroAuto.choqueParcial)
      ..fijarFecha(DateTime.utc(2026, 11, 19, 8));
    await notifier().prepararUbicacion();
    notifier()
      ..agregarFoto(_foto(1))
      ..fijarRelato(
        descripcion: 'Me chocaron por detrás en un semáforo.',
        lugar: 'Calle 100 con 15',
        ciudad: 'Bogotá',
      );
    await notifier().guardado;
  }

  test('antes de la primera foto no se guarda nada', () async {
    crear();
    notifier()
      ..elegirPoliza(_poliza)
      ..fijarFecha(_ahora);
    await notifier().guardado;

    expect(await almacen.deCuenta('c1'), isEmpty);
  });

  test('con la primera foto queda el borrador con todo lo elegido', () async {
    crear();
    notifier()
      ..elegirPoliza(_poliza)
      ..elegirTipoAuto(TipoSiniestroAuto.hurtoParcial)
      ..fijarFecha(DateTime.utc(2026, 11, 19, 8));
    await notifier().prepararUbicacion();

    notifier().agregarFoto(_foto(1));
    await notifier().guardado;

    final r = (await guardado())!;
    expect(r.estado, EstadoLocal.borrador);
    expect(r.cuentaId, 'c1');
    expect(r.poliza!.numero, 'AUTO-0001');
    expect(r.tipoAuto, TipoSiniestroAuto.hurtoParcial);
    expect(r.ocurridoEn, DateTime.utc(2026, 11, 19, 8));
    expect(r.ubicacion, isNotNull);
    expect(r.creadoEn, _ahora);
    expect(r.fotos, hasLength(1));
    expect(r.fotos.single.ubicacion, r.ubicacion);
    expect(await almacen.bytesDeFoto(r.fotos.single.id), _foto(1));
  });

  test('cada cambio posterior se escribe', () async {
    crear();
    notifier()
      ..elegirPoliza(_poliza)
      ..agregarFoto(_foto(1))
      ..agregarFoto(_foto(2))
      ..elegirTipoAuto(TipoSiniestroAuto.hurtoTotal);
    await notifier().guardado;

    final r = (await guardado())!;
    expect(r.fotos, hasLength(2));
    expect(r.tipoAuto, TipoSiniestroAuto.hurtoTotal);
  });

  test('quitar una foto la borra del teléfono', () async {
    crear();
    notifier()
      ..agregarFoto(_foto(1))
      ..agregarFoto(_foto(2))
      // Se quita antes de que termine de guardarse: igual queda borrada.
      ..quitarFoto(0);
    await notifier().guardado;

    final r = (await guardado())!;
    expect(r.fotos, hasLength(1));
    expect(await almacen.bytesDeFoto(r.fotos.single.id), _foto(2));
  });

  testWidgets('el relato se escribe al dejar de teclear, no en cada letra', (
    tester,
  ) async {
    crear();
    notifier().agregarFoto(_foto(1));
    await tester.pump();
    var escrituras = 0;
    final sub = almacen.cambios.listen((_) => escrituras++);
    addTearDown(sub.cancel);

    for (final texto in ['M', 'Me', 'Me ch', 'Me chocaron']) {
      notifier().fijarRelato(descripcion: texto);
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect((await guardado())!.descripcion, '');

    await tester.pump(ReporteNotifier.pausaRelato);
    await tester.pump();
    expect((await guardado())!.descripcion, 'Me chocaron');
    expect(escrituras, 1);
  });

  test('pedir que termine de guardar escribe el relato pendiente', () async {
    crear();
    notifier()
      ..agregarFoto(_foto(1))
      ..fijarRelato(lugar: 'Calle 100');

    await notifier().guardado;

    expect((await guardado())!.lugar, 'Calle 100');
  });

  test(
    'la dirección escrita queda en el reporte y en las fotos sin GPS',
    () async {
      crear();
      notifier().agregarFoto(_foto(1));
      await notifier().guardado;

      notifier().usarDireccion(const Coordenada(4.7, -74.05), 'Calle 100 # 15');
      await notifier().guardado;

      final r = (await guardado())!;
      expect(r.direccionEscrita, 'Calle 100 # 15');
      expect(r.ubicacion, const Coordenada(4.7, -74.05));
      expect(r.lugar, 'Calle 100 # 15');
      expect(r.fotos.single.deDireccion, isTrue);
      expect(r.fotos.single.ubicacion, const Coordenada(4.7, -74.05));
    },
  );

  test('sin cuenta no se guarda nada en el teléfono', () async {
    crear(cuenta: null);
    notifier()
      ..elegirPoliza(_poliza)
      ..agregarFoto(_foto(1))
      ..fijarRelato(lugar: 'Calle 1');
    await notifier().guardado;

    expect(await almacen.leer(estado().idReporte), isNull);
    expect(estado().fotos, hasLength(1));
  });

  test('empezar otro reporte deja el anterior como borrador', () async {
    crear();
    notifier().agregarFoto(_foto(1));
    await notifier().guardado;
    final primero = estado().idReporte;

    notifier().reiniciar();
    notifier().agregarFoto(_foto(2));
    await notifier().guardado;

    expect(estado().idReporte, isNot(primero));
    expect((await almacen.deCuenta('c1')).map((r) => r.id), [
      primero,
      estado().idReporte,
    ]);
  });

  group('continuar un reporte guardado', () {
    test('recupera los datos y las fotos', () async {
      crear();
      await completar();
      final id = estado().idReporte;
      notifier().reiniciar();

      expect(await notifier().continuar(id), isTrue);

      final s = estado();
      expect(s.idReporte, id);
      expect(s.poliza!.id, 'pol-1');
      expect(s.tipoAuto, TipoSiniestroAuto.choqueParcial);
      expect(s.ocurridoEn!.toUtc(), DateTime.utc(2026, 11, 19, 8));
      expect(s.descripcion, 'Me chocaron por detrás en un semáforo.');
      expect(s.lugar, 'Calle 100 con 15');
      expect(s.ciudad, 'Bogotá');
      expect(s.ubicacion, isNotNull);
      expect(s.fotos.single.bytes, _foto(1));
      expect(s.listoParaEnviar, isTrue);
    });

    test('lo que se cambie después sigue escribiéndose en el mismo', () async {
      crear();
      await completar();
      final id = estado().idReporte;
      notifier().reiniciar();
      await notifier().continuar(id);

      notifier()
        ..quitarFoto(0)
        ..agregarFoto(_foto(9));
      await notifier().guardado;

      final r = (await almacen.leer(id))!;
      expect(await almacen.deCuenta('c1'), hasLength(1));
      expect(await almacen.bytesDeFoto(r.fotos.single.id), _foto(9));
    });

    test('uno por enviar vuelve a borrador mientras se edita', () async {
      crear();
      await completar();
      final id = estado().idReporte;
      await almacen.actualizar(
        id,
        (r) => r.copyWith(estado: EstadoLocal.pendiente),
      );
      notifier().reiniciar();

      expect(await notifier().continuar(id), isTrue);

      expect((await almacen.leer(id))!.estado, EstadoLocal.borrador);
    });

    test(
      'no retoma el de otra cuenta, uno enviándose ni uno que no existe',
      () async {
        crear();
        await completar();
        final id = estado().idReporte;
        notifier().reiniciar();
        final nuevo = estado().idReporte;

        await almacen.actualizar(
          id,
          (r) => r.copyWith(estado: EstadoLocal.enviando),
        );
        expect(await notifier().continuar(id), isFalse);
        expect(await notifier().continuar('no-existe'), isFalse);

        await almacen.guardar(
          ReporteGuardado(
            id: 'ajeno',
            cuentaId: 'c2',
            estado: EstadoLocal.borrador,
            creadoEn: _ahora,
            actualizadoEn: _ahora,
          ),
        );
        expect(await notifier().continuar('ajeno'), isFalse);
        expect(estado().idReporte, nuevo);
      },
    );
  });

  test('descartar lo borra del teléfono y empieza de cero', () async {
    crear();
    await completar();
    final id = estado().idReporte;

    await notifier().descartar();

    expect(await almacen.leer(id), isNull);
    expect(estado().idReporte, isNot(id));
    expect(estado().fotos, isEmpty);
  });

  group('si el teléfono no puede guardar', () {
    test('el reporte sigue en pantalla y se avisa', () async {
      crear();
      almacen.fallaAlEscribir = StateError('base dañada');

      notifier().agregarFoto(_foto(1));
      await notifier().guardado;

      expect(estado().fotos, hasLength(1));
      expect(estado().avisoGuardado, AvisoGuardado.noGuardado);
    });

    test('sin espacio lo dice con su propio aviso', () async {
      crear();
      almacen.fallaAlEscribir = StateError('database or disk is full');

      notifier().agregarFoto(_foto(1));
      await notifier().guardado;

      expect(estado().avisoGuardado, AvisoGuardado.sinEspacio);
    });

    test('cuando vuelve a poder, el aviso se quita', () async {
      crear();
      almacen.fallaAlEscribir = StateError('base dañada');
      notifier().agregarFoto(_foto(1));
      await notifier().guardado;
      expect(estado().avisoGuardado, isNotNull);

      almacen.fallaAlEscribir = null;
      notifier().elegirPoliza(_poliza);
      await notifier().guardado;

      expect(estado().avisoGuardado, isNull);
      // Lo que no alcanzó a quedar se guarda completo: datos y foto.
      final guardado = await almacen.leer(estado().idReporte);
      expect(guardado?.poliza?.id, _poliza.id);
      expect(guardado?.fotos, hasLength(1));
    });
  });

  group('al enviar', () {
    test('con radicado, queda como enviado y sus fotos se borran', () async {
      crear();
      await completar();
      final id = estado().idReporte;

      await notifier().enviar();
      await notifier().guardado;

      expect(estado().envio, isA<Enviado>());
      final guardado = await almacen.leer(id);
      expect(guardado?.estado, EstadoLocal.enviado);
      expect(guardado?.resultado?.radicado, isNotEmpty);
      expect(await almacen.bytesDeFoto(guardado!.fotos.first.id), isNull);
    });

    test('si se cae la red, queda guardado para enviarse después', () async {
      crear();
      await completar();
      final id = estado().idReporte;
      bff.errorAlReportar = const ErrorRed(tipo: 'connectionError');

      await notifier().enviar();
      await notifier().guardado;

      expect(estado().envio, isA<EnvioGuardado>());
      final guardado = await almacen.leer(id);
      expect(guardado?.estado, EstadoLocal.pendiente);
      expect(guardado?.fotos, hasLength(1));
    });

    test('si la aseguradora lo rechaza, queda con error y su motivo', () async {
      crear();
      await completar();
      final id = estado().idReporte;
      bff.rechazar = true;

      await notifier().enviar();
      await notifier().guardado;

      expect(estado().envio, isA<EnvioFallido>());
      final guardado = await almacen.leer(id);
      expect(guardado?.estado, EstadoLocal.conError);
      expect(guardado?.ultimoError, isNotEmpty);
    });
  });
}
