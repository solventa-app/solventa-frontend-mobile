import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';

import '../../../helpers/bff_de_prueba.dart';

/// El datasource real contra un BFF simulado: las respuestas pasan por los
/// tipos generados, así que una que rompa el contrato falla aquí.
void main() {
  late BffDePrueba bff;
  late GqlAsistenciaRemoteDataSource remoto;

  const entradaConUbicacion = {
    'idSolicitud': 'sol-1',
    'prestadorId': 'p-1',
    'tipoAsistencia': 'MEDICO',
    'latitud': 4.68,
    'longitud': -74.05,
  };

  Map<String, Object?> asistencia(String estado) =>
      AsistenciaFixtures.asistencia(
        id: 'sol-1',
        estado: estado,
        minutosEstimados: 6,
      );

  setUp(() {
    bff = BffDePrueba();
    remoto = GqlAsistenciaRemoteDataSource(bff.cliente);
  });

  test(
    'catalogoPrestadores manda la versión local y devuelve el catálogo',
    () async {
      bff.responder({
        '__typename': 'Query',
        'catalogoPrestadores': {
          ...AsistenciaFixtures.catalogo,
          '__typename': 'CatalogoPrestadores',
          'prestadores': [
            for (final p in AsistenciaFixtures.prestadores)
              {'__typename': 'Prestador', ...p},
          ],
        },
      });

      final r = await remoto.catalogoPrestadores(
        versionLocal: AsistenciaFixtures.version,
      );

      expect(r['version'], AsistenciaFixtures.version);
      expect(r['prestadores'], isNotEmpty);
      expect(bff.variables['versionLocal'], AsistenciaFixtures.version);
    },
  );

  test('solicitarAsistencia devuelve la asistencia confirmada', () async {
    bff.responder({
      '__typename': 'Mutation',
      'solicitarAsistencia': asistencia('CONFIRMADA'),
    });

    final r = await remoto.solicitarAsistencia(entradaConUbicacion);

    expect(r['estado'], 'CONFIRMADA');
    expect(r['minutosEstimados'], 6);
    expect(
      (bff.variables['entrada'] as Map<String, dynamic>)['idSolicitud'],
      'sol-1',
    );
  });

  test('solicitarAsistencia devuelve el ErrorAsistencia tipado', () async {
    bff.responder({
      '__typename': 'Mutation',
      'solicitarAsistencia': AsistenciaFixtures.errorAsistencia(
        'NO_ENCONTRADA',
      ),
    });

    final r = await remoto.solicitarAsistencia(entradaConUbicacion);

    expect(r['codigo'], 'NO_ENCONTRADA');
  });

  test(
    'autocompletarDireccion pide Colombia y devuelve las sugerencias',
    () async {
      bff.responder({
        '__typename': 'Query',
        'autocompletarDireccion': [
          {
            '__typename': 'SugerenciaDireccion',
            'placeId': 'ChIJ1',
            'descripcion': 'Carrera 45 # 22-18, Bogotá',
          },
        ],
      });

      final r = await remoto.autocompletarDireccion('Cra 45');

      expect(r.single['placeId'], 'ChIJ1');
      expect(bff.variables, {'texto': 'Cra 45', 'pais': 'CO'});
    },
  );

  test('ubicarDireccion (v0.50) pasa por el tipo generado', () async {
    bff.responder({
      '__typename': 'Query',
      'ubicarDireccion': {
        '__typename': 'UbicacionDireccion',
        'encontrada': false,
        'latitud': null,
        'longitud': null,
        'direccion': null,
        'codigo': 'DIRECCION_NO_ENCONTRADA',
      },
    });

    final r = await remoto.ubicarDireccion(texto: 'calle noexiste');

    expect(r['codigo'], 'DIRECCION_NO_ENCONTRADA');
    expect(bff.variables['texto'], 'calle noexiste');
  });

  test('cancelarAsistencia manda el id y devuelve la cancelada', () async {
    bff.responder({
      '__typename': 'Mutation',
      'cancelarAsistencia': AsistenciaFixtures.asistencia(
        id: 'sol-1',
        estado: 'CANCELADA',
        canceladaEn: '2026-11-07T15:05:00+00:00',
      ),
    });

    final r = await remoto.cancelarAsistencia('sol-1');

    expect(r['estado'], 'CANCELADA');
    expect(bff.variables['id'], 'sol-1');
  });
}
