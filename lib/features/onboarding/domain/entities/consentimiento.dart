/// Estado del consentimiento de tratamiento de datos (Habeas Data).
enum EstadoConsentimiento { vigente, vencido, revocado }

/// Consentimiento otorgado por el titular (M01-02).
final class Consentimiento {
  const Consentimiento({
    required this.id,
    required this.finalidad,
    required this.versionTexto,
    required this.otorgadoEn,
    required this.venceEn,
    required this.estado,
  });

  final String id;
  final String finalidad;
  final String versionTexto;
  final DateTime otorgadoEn;
  final DateTime venceEn;
  final EstadoConsentimiento estado;

  bool get vigente => estado == EstadoConsentimiento.vigente;

  @override
  bool operator ==(Object other) =>
      other is Consentimiento &&
      other.id == id &&
      other.finalidad == finalidad &&
      other.versionTexto == versionTexto &&
      other.otorgadoEn == otorgadoEn &&
      other.venceEn == venceEn &&
      other.estado == estado;

  @override
  int get hashCode =>
      Object.hash(id, finalidad, versionTexto, otorgadoEn, venceEn, estado);
}

/// Lo que la pantalla M01-02 pide registrar.
final class SolicitudConsentimiento {
  const SolicitudConsentimiento({
    required this.finalidad,
    required this.versionTexto,
    this.documentoIdentidad,
  });

  final String finalidad;
  final String versionTexto;

  /// Titular. El BFF lo convierte en un identificador opaco; nunca se guarda en la app.
  final String? documentoIdentidad;
}
