import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/contrato/schema.graphql.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/data/graphql/onboarding.graphql.dart';
import 'package:solventa_mobile/features/onboarding/data/mappers/onboarding_mapper.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/onboarding.dart';

void main() {
  test('mapea un rechazo con su motivo e intentos', () {
    final o = onboardingDesdeGql(
      Fragment$OnboardingCampos.fromJson(
        OnboardingFixtures.onboarding(
          estado: 'RECHAZADA',
          motivo: 'ROSTRO_NO_COINCIDE',
          intento: 2,
          intentosRestantes: 1,
        ),
      ),
    );

    expect(o.estado, EstadoOnboarding.rechazada);
    expect(o.motivo, 'ROSTRO_NO_COINCIDE');
    expect((o.intento, o.intentosRestantes), (2, 1));
  });

  test('un estado que la app no conoce cae en «en revisión»', () {
    expect(
      estadoOnboardingDesdeGql(Enum$EstadoOnboarding.$unknown),
      EstadoOnboarding.enRevision,
    );
  });

  test('cada paso tiene su valor del contrato', () {
    expect(PasoOnboarding.values.map(pasoAGql).toSet(), hasLength(4));
  });
}
