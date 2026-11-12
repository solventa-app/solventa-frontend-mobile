import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/ruta_externa_service.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/prestador_mapper.dart';
import 'package:solventa_mobile/features/assistance/data/repositories/asistencia_repository_impl.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';

Map<String, Object?> _mapa(String id, {String tipo = 'MEDICO', bool? activo}) =>
    {
      'id': id,
      'nombre': 'Prestador $id',
      'tipo': tipo,
      'ciudad': 'Bogotá',
      'latitud': 4.68,
      'longitud': -74.05,
      'activo': ?activo,
    };

CatalogoPrestadores _valor(Resultado<CatalogoPrestadores> r) =>
    (r as Exito<CatalogoPrestadores>).valor;

void main() {
  group('mapper', () {
    test('descarta tipos desconocidos e inactivos sin romper el catálogo', () {
      final c = catalogoDesdeMapa({
        'version': 'v1',
        'prestadores': [
          _mapa('a', tipo: 'BOMBEROS'),
          _mapa('b', activo: false),
          _mapa('c', tipo: 'MECANICO'),
          _mapa('d'),
        ],
      });
      expect(c.version, 'v1');
      expect(c.prestadores.map((p) => p.id), ['c', 'd']);
    });

    test('v0.49: grúa y el detalle del prestador', () {
      final p = prestadorDesdeMapa({
        ..._mapa('g', tipo: 'GRUA'),
        'aliado': true,
        'especialidad': 'Grúa liviana',
        'direccion': 'Cl. 100 # 19-61',
        'horario': 'Abierto 24 h',
        'fotoUrl': 'https://example.test/g.webp',
      })!;
      expect(p.tipo, TipoPrestador.grua);
      expect(p.aliado, isTrue);
      expect(p.especialidad, 'Grúa liviana');
      expect(p.direccion, 'Cl. 100 # 19-61');
      expect(p.horario, 'Abierto 24 h');
      expect(p.fotoUrl, 'https://example.test/g.webp');
    });

    test('una copia anterior a la v0.49 parsea con valores por defecto', () {
      final p = prestadorDesdeMapa(_mapa('a'))!;
      expect(p.aliado, isFalse);
      expect(p.especialidad, isEmpty);
      expect(p.horario, isNull);
      expect(p.fotoUrl, isNull);
      expect(
        copiaSinDetalle({
          'prestadores': [_mapa('a')],
        }),
        isTrue,
      );
      expect(
        copiaSinDetalle({
          'prestadores': [
            {..._mapa('a'), 'aliado': false},
          ],
        }),
        isFalse,
      );
    });

    test('acepta enteros donde el contrato manda números', () {
      final p = prestadorDesdeMapa({..._mapa('a'), 'latitud': 4});
      expect(p!.ubicacion.latitud, 4.0);
    });
  });

  group('AsistenciaRepositoryImpl (catálogo maestro)', () {
    late FakeAsistenciaRemoteDataSource bff;
    late MemoriaCatalogoLocalDataSource local;
    var ahora = DateTime.utc(2026, 11, 4, 12);

    AsistenciaRepositoryImpl repo() =>
        AsistenciaRepositoryImpl(bff, local, reloj: () => ahora);

    setUp(() {
      bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero);
      local = MemoriaCatalogoLocalDataSource();
      ahora = DateTime.utc(2026, 11, 4, 12);
    });

    test('sin copia: lo descarga una vez y lo guarda', () async {
      final c = _valor(await repo().catalogoPrestadores());
      expect(c.version, AsistenciaFixtures.version);
      expect(c.prestadores, hasLength(AsistenciaFixtures.prestadores.length));
      expect(local.copia?.version, AsistenciaFixtures.version);
      expect(bff.consultas, 1);
    });

    test('con copia vigente no vuelve a preguntar al backend', () async {
      await repo().catalogoPrestadores();
      ahora = ahora.add(const Duration(days: 6));
      await repo().catalogoPrestadores();
      expect(bff.consultas, 1);
    });

    test(
      'al vencer revisa la versión y, si es la misma, conserva la copia',
      () async {
        await repo().catalogoPrestadores();
        ahora = ahora.add(const Duration(days: 8));
        final c = _valor(await repo().catalogoPrestadores());
        expect(bff.consultas, 2);
        expect(c.prestadores, isNotEmpty);
        expect(local.copia!.revisadoEn, ahora);
      },
    );

    test(
      'una copia vigente anterior a la v0.49 se vuelve a pedir aunque no venza',
      () async {
        local.copia = CopiaCatalogo(
          catalogo: {
            'version': '2026-11-04.1',
            'prestadores': [_mapa('viejo')],
          },
          revisadoEn: ahora,
        );
        final c = _valor(await repo().catalogoPrestadores());
        expect(bff.consultas, 1);
        expect(c.version, AsistenciaFixtures.version);
        expect(c.prestadores.where((p) => p.aliado), isNotEmpty);
      },
    );

    test('vencida y sin red: sigue con la copia que tiene', () async {
      await repo().catalogoPrestadores();
      ahora = ahora.add(const Duration(days: 30));
      bff.error = const ErrorRed();
      final c = _valor(await repo().catalogoPrestadores());
      expect(c.prestadores, isNotEmpty);
    });

    test('sin copia y sin red: SinConexion, no una excepción', () async {
      bff.error = const ErrorRed();
      final r = await repo().catalogoPrestadores();
      expect((r as Fracaso<CatalogoPrestadores>).falla, isA<SinConexion>());
    });
  });

  test(
    'la ruta usa primero geo: (app de mapas por defecto) y luego la web',
    () {
      final uris = urisRuta(
        const Coordenada(4.7, -74.1),
        nombre: 'Clínica Norte',
      );
      expect(uris.first.scheme, 'geo');
      expect(uris.first.toString(), contains('4.7,-74.1'));
      expect(uris.first.toString(), contains('Cl%C3%ADnica%20Norte'));
      expect(uris.last.host, 'www.google.com');
      expect(uris.last.queryParameters['destination'], '4.7,-74.1');
    },
  );
}
