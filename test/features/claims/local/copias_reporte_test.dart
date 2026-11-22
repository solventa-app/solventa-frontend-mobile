import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/local/copias_reporte.dart';
import 'package:solventa_mobile/features/claims/data/local/limpieza_reportes.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_siniestro.dart';
import 'package:solventa_mobile/features/claims/domain/repositories/reporte_siniestro_repository.dart';

final _ahora = DateTime.utc(2026, 11, 20, 15);

final _poliza = PolizaReportable(
  id: 'pol-1',
  numero: 'AUTO-0001',
  vigenciaDesde: DateTime.utc(2026),
  vigenciaHasta: DateTime.utc(2027),
  esAuto: true,
);

final _caso = SiniestroReportado(
  id: 's1',
  radicado: 'SIN-2026-0001',
  estado: 'PENDIENTE',
  notificadoEn: _ahora,
  venceDictamenEn: _ahora,
  fotos: 2,
);

final class _Repo implements ReporteSiniestroRepository {
  Falla? falla;
  int consultas = 0;

  Resultado<T> _responder<T>(T valor) {
    consultas++;
    final f = falla;
    return f == null ? Exito(valor) : Fracaso(f);
  }

  @override
  Future<Resultado<List<PolizaReportable>>> polizas() async =>
      _responder([_poliza]);

  @override
  Future<Resultado<List<SiniestroReportado>>> misSiniestros() async =>
      _responder([_caso]);

  @override
  Future<Resultado<DetalleSiniestro?>> miSiniestro(String id) =>
      throw UnimplementedError();

  @override
  Future<Resultado<SiniestroReportado>> reportar(ReporteSiniestro reporte) =>
      throw UnimplementedError();
}

void main() {
  late _Repo repo;
  late AlmacenLocalMemoria local;
  String? cuenta;
  var conectado = true;
  var reloj = _ahora;

  CopiasReporte copias() => CopiasReporte(
    repositorio: repo,
    local: local,
    cuenta: () => cuenta,
    conectado: () => conectado,
    reloj: () => reloj,
  );

  setUp(() {
    repo = _Repo();
    local = AlmacenLocalMemoria();
    cuenta = 'c1';
    conectado = true;
    reloj = _ahora;
  });

  ConCopia<T> exito<T>(Resultado<ConCopia<T>> r) =>
      (r as Exito<ConCopia<T>>).valor;

  group('copias de pólizas y siniestros', () {
    test('con conexión llega lo del servidor y se guarda la copia', () async {
      final r = exito(await copias().polizas());

      expect(r.esCopia, isFalse);
      expect(r.valor.single.numero, 'AUTO-0001');
      expect(
        await local.leerCopia('c1', CopiasReporte.clavePolizas),
        isNotNull,
      );
    });

    test('si la petición falla por red, sale la copia con su hora', () async {
      await copias().polizas();
      repo.falla = const SinConexion();
      reloj = _ahora.add(const Duration(hours: 2));

      final r = exito(await copias().polizas());

      expect(r.esCopia, isTrue);
      expect(r.guardadaEn, _ahora);
      expect(r.valor.single.id, 'pol-1');
    });

    test('con el servidor caído también sirve la copia', () async {
      await copias().misSiniestros();
      repo.falla = const ServicioNoDisponible();

      final r = exito(await copias().misSiniestros());

      expect(r.esCopia, isTrue);
      expect(r.valor.single.radicado, 'SIN-2026-0001');
    });

    test('sin conexión no espera a la red: va directo a la copia', () async {
      await copias().polizas();
      final antes = repo.consultas;
      conectado = false;

      final r = exito(await copias().polizas());

      expect(r.esCopia, isTrue);
      expect(repo.consultas, antes);
    });

    test('sin conexión y sin copia, lo intenta y devuelve la falla', () async {
      conectado = false;
      repo.falla = const SinConexion();

      final r = await copias().polizas();

      expect((r as Fracaso).falla, isA<SinConexion>());
      expect(repo.consultas, 1);
    });

    test('una sesión vencida no se tapa con la copia', () async {
      await copias().polizas();
      repo.falla = const SesionVencida();

      final r = await copias().polizas();

      expect((r as Fracaso).falla, isA<SesionVencida>());
    });

    test('cada respuesta nueva reemplaza la copia', () async {
      await copias().misSiniestros();
      reloj = _ahora.add(const Duration(days: 1));
      await copias().misSiniestros();
      repo.falla = const SinConexion();

      final r = exito(await copias().misSiniestros());

      expect(r.guardadaEn, _ahora.add(const Duration(days: 1)));
    });

    test('la copia es de cada cuenta', () async {
      await copias().polizas();
      cuenta = 'c2';
      repo.falla = const SinConexion();

      expect(await copias().polizas(), isA<Fracaso<Object?>>());
    });

    test('sin cuenta no se guarda copia', () async {
      cuenta = null;

      final r = exito(await copias().polizas());

      expect(r.esCopia, isFalse);
      expect(await local.leerCopia('c1', CopiasReporte.clavePolizas), isNull);
    });

    test('una copia dañada se ignora', () async {
      await local.guardarCopia('c1', CopiasReporte.clavePolizas, '{{', _ahora);
      repo.falla = const SinConexion();

      expect(await copias().polizas(), isA<Fracaso<Object?>>());
    });
  });

  group('limpieza del almacén', () {
    late AlmacenReportesMemoria almacen;

    setUp(() {
      almacen = AlmacenReportesMemoria();
      addTearDown(almacen.cerrar);
    });

    Future<void> guardar(
      String id, {
      required EstadoLocal estado,
      required Duration hace,
      String cuentaId = 'c1',
    }) => almacen.guardar(
      ReporteGuardado(
        id: id,
        cuentaId: cuentaId,
        estado: estado,
        creadoEn: _ahora.subtract(hace),
        actualizadoEn: _ahora.subtract(hace),
        enviadoEn: estado == EstadoLocal.enviado ? _ahora.subtract(hace) : null,
      ),
    );

    Future<void> limpiar() => limpiarReportes(
      almacen: almacen,
      local: local,
      cuentaId: 'c1',
      ahora: _ahora,
    );

    test(
      'borra los borradores de más de 7 días y los enviados de más de un día',
      () async {
        await guardar(
          'borrador-viejo',
          estado: EstadoLocal.borrador,
          hace: const Duration(days: 8),
        );
        await guardar(
          'borrador-nuevo',
          estado: EstadoLocal.borrador,
          hace: const Duration(days: 6),
        );
        await guardar(
          'enviado-viejo',
          estado: EstadoLocal.enviado,
          hace: const Duration(hours: 25),
        );
        await guardar(
          'enviado-nuevo',
          estado: EstadoLocal.enviado,
          hace: const Duration(hours: 2),
        );

        await limpiar();

        expect((await almacen.deCuenta('c1')).map((r) => r.id), [
          'borrador-nuevo',
          'enviado-nuevo',
        ]);
      },
    );

    test(
      'nunca borra un reporte completo sin enviar, por viejo que sea',
      () async {
        for (final estado in [
          EstadoLocal.pendiente,
          EstadoLocal.conError,
          EstadoLocal.necesitaAtencion,
        ]) {
          await guardar(
            estado.codigo,
            estado: estado,
            hace: const Duration(days: 90),
          );
        }

        await limpiar();

        expect(await almacen.deCuenta('c1'), hasLength(3));
      },
    );

    test('lo de una cuenta que no vuelve en 30 días se borra', () async {
      await local.guardarCuenta(
        CuentaLocal(
          id: 'vieja',
          nombre: 'Luis',
          verificada: true,
          ultimaConexion: _ahora.subtract(const Duration(days: 31)),
        ),
      );
      await local.guardarCuenta(
        CuentaLocal(
          id: 'reciente',
          nombre: 'Eva',
          verificada: true,
          ultimaConexion: _ahora.subtract(const Duration(days: 5)),
        ),
      );
      await local.guardarCuenta(
        CuentaLocal(
          id: 'c1',
          nombre: 'Ana',
          verificada: true,
          ultimaConexion: _ahora,
        ),
      );
      await guardar(
        'r-vieja',
        estado: EstadoLocal.pendiente,
        hace: const Duration(days: 40),
        cuentaId: 'vieja',
      );
      await guardar(
        'r-reciente',
        estado: EstadoLocal.pendiente,
        hace: const Duration(days: 6),
        cuentaId: 'reciente',
      );

      await limpiar();

      expect(await almacen.deCuenta('vieja'), isEmpty);
      expect(await almacen.deCuenta('reciente'), hasLength(1));
    });
  });
}
