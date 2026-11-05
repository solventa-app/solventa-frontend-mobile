import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';

/// La semilla que carga el backend (`docs/hu-m06/prestadores-semilla.json`) y
/// el fixture del fake de la app son el mismo catálogo maestro.
void main() {
  test('el fixture de la app es copia exacta de la semilla del backend', () {
    final semilla = jsonDecode(
      File('docs/hu-m06/prestadores-semilla.json').readAsStringSync(),
    ) as Map<String, Object?>;
    expect(AsistenciaFixtures.version, semilla['version']);
    expect(
      jsonEncode(AsistenciaFixtures.prestadores),
      jsonEncode(semilla['prestadores']),
    );
  });

  test('ids únicos, tipos válidos y coordenadas dentro de Colombia', () {
    final ids = <String>{};
    for (final p in AsistenciaFixtures.prestadores) {
      expect(ids.add(p['id']! as String), isTrue, reason: 'id repetido');
      expect(['MEDICO', 'MECANICO'], contains(p['tipo']));
      expect(p['latitud']! as double, inInclusiveRange(-4.3, 13.5));
      expect(p['longitud']! as double, inInclusiveRange(-82, -66.8));
    }
  });
}
