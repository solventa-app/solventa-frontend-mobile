import 'dart:typed_data';

/// Estado del recorrido de onboarding en el backend (contrato v0.20, HU-M01).
enum EstadoOnboarding {
  iniciado,
  enVerificacion,
  verificada,
  rechazada,
  enRevision,
}

/// Las cuatro piezas que pide el proveedor de identidad.
enum PasoOnboarding { anverso, reverso, rostro, video }

/// Un recorrido de onboarding. `motivo` es el código del contrato (p. ej.
/// `ROSTRO_NO_COINCIDE`), nunca un dato del documento.
final class Onboarding {
  const Onboarding({
    required this.id,
    required this.estado,
    required this.intento,
    required this.intentosRestantes,
    this.motivo,
  });

  final String id;
  final EstadoOnboarding estado;
  final String? motivo;
  final int intento;
  final int intentosRestantes;

  /// `true` mientras el resultado no está listo.
  bool get pendiente =>
      estado == EstadoOnboarding.iniciado ||
      estado == EstadoOnboarding.enVerificacion;
}

/// Una captura lista para subir. Vive solo en memoria: nunca se guarda.
final class Captura {
  const Captura(this.bytes, this.tipoContenido);

  final Uint8List bytes;
  final String tipoContenido;
}
