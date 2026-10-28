import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/data/graphql/onboarding.graphql.dart';

/// Prueba de contrato: toda fixture (las que usan los fakes) parsea con el tipo
/// generado de su operación y pasa por su mapper. Si el backend cambia el
/// contrato y se sincroniza, una fixture desactualizada rompe aquí, no en el
/// teléfono. Cada operación nueva agrega su grupo.
void main() {
  // Cada fixture con el parser de su operación; los fakes las sirven tal cual.
  final casos =
      <
        String,
        (
          Map<String, dynamic>,
          Map<String, dynamic> Function(Map<String, dynamic>),
        )
      >{
        'iniciarOnboarding': (
          OnboardingFixtures.iniciar,
          (j) => Mutation$IniciarOnboarding.fromJson(j).toJson(),
        ),
        'registrarConsentimientoOnboarding': (
          OnboardingFixtures.consentimiento,
          (j) =>
              Mutation$RegistrarConsentimientoOnboarding.fromJson(j).toJson(),
        ),
        'solicitarSubidaOnboarding': (
          OnboardingFixtures.subida,
          (j) => Mutation$SolicitarSubidaOnboarding.fromJson(j).toJson(),
        ),
        'confirmarSubidaOnboarding': (
          OnboardingFixtures.confirmar,
          (j) => Mutation$ConfirmarSubidaOnboarding.fromJson(j).toJson(),
        ),
        'crearCuentaOnboarding': (
          OnboardingFixtures.cuenta,
          (j) => Mutation$CrearCuentaOnboarding.fromJson(j).toJson(),
        ),
        'crearCuentaOnboarding · correo registrado': (
          OnboardingFixtures.correoRegistrado,
          (j) => Mutation$CrearCuentaOnboarding.fromJson(j).toJson(),
        ),
        'enviarVerificacion': (
          OnboardingFixtures.enviar,
          (j) => Mutation$EnviarVerificacion.fromJson(j).toJson(),
        ),
        'reintentarOnboarding': (
          OnboardingFixtures.reintentar,
          (j) => Mutation$ReintentarOnboarding.fromJson(j).toJson(),
        ),
        'onboarding': (
          OnboardingFixtures.consultar(
            OnboardingFixtures.onboarding(
              estado: 'RECHAZADA',
              motivo: 'ILEGIBLE',
            ),
          ),
          (j) => Query$ConsultarOnboarding.fromJson(j).toJson(),
        ),
        'miVerificacion': (
          OnboardingFixtures.miVerificacion(
            OnboardingFixtures.onboarding(estado: 'VERIFICADA'),
          ),
          (j) => Query$MiVerificacion.fromJson(j).toJson(),
        ),
        'actualizarSesion': (
          OnboardingFixtures.sesionActualizada,
          (j) => Mutation$ActualizarSesion.fromJson(j).toJson(),
        ),
      };

  group('onboarding (v0.20)', () {
    casos.forEach((nombre, caso) {
      final (json, parsear) = caso;
      test(nombre, () {
        // La fixture no tiene campos que la operación no pida.
        expect(_claves(parsear(json)), _claves(json));
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
