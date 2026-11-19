import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';
import 'package:solventa_mobile/features/assistance/data/graphql/catalogo_prestadores.graphql.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/prestador_mapper.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';

/// La semilla que carga el backend (`docs/hu-m06/prestadores-semilla.json`) y
/// el fixture del fake de la app son el mismo catálogo maestro.
void main() {
  test('el fixture de la app es copia exacta de la semilla del backend', () {
    final semilla = jsonDecode(
      File('docs/hu-m06/prestadores-semilla.json').readAsStringSync(),
    ) as Map<String, Object?>;
    expect(AsistenciaFixtures.version, semilla['version']);
    // La semilla está en el formato de la base (`foto_url`, v0.53
    // `codigo_especialidad` y `horario_atencion`); el BFF lo expone en
    // camelCase, que es lo que guarda el fixture.
    // `horarioAtencion` lleva además su `__typename`, como lo responde el BFF.
    Map<String, Object?> comoBff(Map<String, Object?> m) => {
      for (final MapEntry(:key, :value) in m.entries)
        _camel(key): value is Map<String, Object?>
            ? {...comoBff(value), '__typename': 'HorarioAtencion'}
            : value,
    };
    final prestadores = [
      for (final p in semilla['prestadores']! as List<Object?>)
        comoBff(p! as Map<String, Object?>),
    ];
    expect(jsonEncode(AsistenciaFixtures.prestadores), jsonEncode(prestadores));
  });

  test('v0.53: cada uno con código de especialidad y horario como datos', () {
    final catalogo = catalogoDesdeMapa(AsistenciaFixtures.catalogo);
    expect(
      catalogo.prestadores.map((p) => p.codigoEspecialidad).toSet(),
      EspecialidadPrestador.values.toSet(),
    );
    final horarios = catalogo.prestadores.map((p) => p.horarioAtencion);
    expect(horarios, contains(isNull));
    expect(horarios.whereType<HorarioAtencion>().map((h) => h.abierto24h), {
      true,
      false,
    });
  });

  test('ids únicos, tipos válidos y coordenadas dentro de Colombia', () {
    final ids = <String>{};
    for (final p in AsistenciaFixtures.prestadores) {
      expect(ids.add(p['id']! as String), isTrue, reason: 'id repetido');
      expect(['MEDICO', 'MECANICO', 'GRUA'], contains(p['tipo']));
      // v0.49: el detalle viene en cada uno (horario y foto pueden ser null).
      expect(p['aliado'], isA<bool>());
      expect(p['especialidad'], isA<String>());
      expect(p['direccion'], isA<String>());
      expect(p['latitud']! as double, inInclusiveRange(-4.3, 13.5));
      expect(p['longitud']! as double, inInclusiveRange(-82, -66.8));
    }
  });

  test('la semilla parsea con el tipo del contrato (v0.49) y su JSON sirve al mapper', () {
    final respuesta = {
      '__typename': 'Query',
      'catalogoPrestadores': {
        '__typename': 'CatalogoPrestadores',
        ...AsistenciaFixtures.catalogo,
        'prestadores': [
          for (final p in AsistenciaFixtures.prestadores)
            {'__typename': 'Prestador', ...p},
        ],
      },
    };
    final json = Query$CatalogoPrestadores.fromJson(respuesta)
        .catalogoPrestadores
        .toJson();
    final catalogo = catalogoDesdeMapa(json);
    expect(catalogo.version, AsistenciaFixtures.version);
    expect(
      catalogo.prestadores,
      hasLength(AsistenciaFixtures.prestadores.length),
    );
    expect(catalogo.prestadores.map((p) => p.tipo).toSet(), {
      TipoPrestador.medico,
      TipoPrestador.mecanico,
      TipoPrestador.grua,
    });
    expect(catalogo.prestadores.map((p) => p.aliado).toSet(), {true, false});
  });
}

/// `foto_url` → `fotoUrl`, `abierto_24h` → `abierto24h`.
String _camel(String clave) => clave.replaceAllMapped(
  RegExp(r'_([a-z0-9])'),
  (m) => m.group(1)!.toUpperCase(),
);
