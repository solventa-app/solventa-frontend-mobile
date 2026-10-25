import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/contrato/schema.graphql.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/registrar_consentimiento_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/data/graphql/registrar_consentimiento.graphql.dart';
import 'package:solventa_mobile/features/onboarding/data/mappers/consentimiento_mapper.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/consentimiento.dart';

void main() {
  test('mapea la respuesta del BFF a la entidad', () {
    final gql = Mutation$RegistrarConsentimiento.fromJson(
      RegistrarConsentimientoFixtures.vigente,
    ).registrarConsentimiento;

    expect(
      consentimientoDesdeGql(gql),
      Consentimiento(
        id: 'consentimiento-demo-1',
        finalidad: 'verificacion-identidad',
        versionTexto: 'v1',
        otorgadoEn: DateTime.utc(2026, 10, 25, 15),
        venceEn: DateTime.utc(2026, 11, 24, 15),
        estado: EstadoConsentimiento.vigente,
      ),
    );
  });

  test('cada estado del contrato tiene su equivalente', () {
    expect(
      estadoConsentimientoDesdeGql(Enum$EstadoConsentimiento.VIGENTE),
      EstadoConsentimiento.vigente,
    );
    expect(
      estadoConsentimientoDesdeGql(Enum$EstadoConsentimiento.VENCIDO),
      EstadoConsentimiento.vencido,
    );
    expect(
      estadoConsentimientoDesdeGql(Enum$EstadoConsentimiento.REVOCADO),
      EstadoConsentimiento.revocado,
    );
  });

  test('un estado nuevo del backend no tumba la app y no se asume vigente', () {
    final json = {
      ...RegistrarConsentimientoFixtures.vigente,
      'registrarConsentimiento': {
        ...RegistrarConsentimientoFixtures.vigente['registrarConsentimiento']
            as Map<String, dynamic>,
        'estado': 'SUSPENDIDO',
      },
    };
    final gql = Mutation$RegistrarConsentimiento.fromJson(json)
        .registrarConsentimiento;

    expect(consentimientoDesdeGql(gql).vigente, isFalse);
  });
}
