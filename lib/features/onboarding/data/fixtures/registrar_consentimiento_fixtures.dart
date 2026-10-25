/// Respuestas de ejemplo de `registrarConsentimiento`, con la forma exacta del
/// BFF (el `data` de la respuesta GraphQL, con `__typename`).
///
/// Las usan el fake (API_ENV=mock) y las pruebas. `test/contract/` comprueba
/// que cada una parsea con el tipo generado del contrato: si el contrato cambia
/// y la fixture ya no cumple, `flutter test` falla.
abstract final class RegistrarConsentimientoFixtures {
  static const vigente = <String, dynamic>{
    '__typename': 'Mutation',
    'registrarConsentimiento': {
      '__typename': 'Consentimiento',
      'id': 'consentimiento-demo-1',
      'finalidad': 'verificacion-identidad',
      'versionTexto': 'v1',
      'otorgadoEn': '2026-10-25T15:00:00Z',
      'venceEn': '2026-11-24T15:00:00Z',
      'estado': 'VIGENTE',
    },
  };

  /// Todas, por nombre, para la prueba de contrato.
  static const todas = <String, Map<String, dynamic>>{'vigente': vigente};
}
