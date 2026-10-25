import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/registrar_consentimiento_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/data/graphql/registrar_consentimiento.graphql.dart';
import 'package:solventa_mobile/features/onboarding/data/mappers/consentimiento_mapper.dart';

/// Prueba de contrato: toda fixture (las que usan los fakes) parsea con el tipo
/// generado de su operación y pasa por su mapper. Si el backend cambia el
/// contrato y se sincroniza, una fixture desactualizada rompe aquí, no en el
/// teléfono. Cada operación nueva agrega su grupo.
void main() {
  group('registrarConsentimiento', () {
    RegistrarConsentimientoFixtures.todas.forEach((nombre, json) {
      test(nombre, () {
        final gql = Mutation$RegistrarConsentimiento.fromJson(json);
        expect(
          () => consentimientoDesdeGql(gql.registrarConsentimiento),
          returnsNormally,
        );
        // La fixture no tiene campos que la operación no pida.
        expect(_claves(gql.toJson()), _claves(json));
      });
    });
  });
}

/// Estructura de claves de un JSON (sin valores), para comparar la forma.
Object? _claves(Object? json) => switch (json) {
  Map<String, dynamic>() => {
    for (final e in json.entries) e.key: _claves(e.value),
  },
  List<dynamic>() => json.map(_claves).toList(),
  _ => null,
};
