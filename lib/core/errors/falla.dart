/// Fallas que la capa `data` entrega a la presentación (docs/integracion-backend.md §4).
///
/// La UI traduce cada una a un texto del catálogo de idiomas: nunca muestra un
/// código HTTP, un mensaje del servidor ni un stack trace.
sealed class Falla {
  const Falla();

  /// `true` si tiene sentido ofrecer «Reintentar».
  bool get reintentable;
}

/// Sin red, DNS o timeout de conexión.
final class SinConexion extends Falla {
  const SinConexion();

  @override
  bool get reintentable => true;
}

/// 502, 503 o 504 del API Gateway, o timeout de respuesta.
final class ServicioNoDisponible extends Falla {
  const ServicioNoDisponible();

  @override
  bool get reintentable => true;
}

/// Token inválido, vencido o ausente: hay que volver a iniciar sesión.
final class SesionVencida extends Falla {
  const SesionVencida();

  @override
  bool get reintentable => false;
}

/// El rol del usuario no tiene acceso a la operación.
final class SinPermiso extends Falla {
  const SinPermiso();

  @override
  bool get reintentable => false;
}

/// Respuesta de negocio del contrato (uniones `Error*`, p. ej. `ErrorOferta.motivo`).
final class FallaNegocio extends Falla {
  const FallaNegocio(this.motivo, {this.reintentable = false});

  /// Valor del enum de motivo del contrato, tal cual (p. ej. `CONSENTIMIENTO_NO_VIGENTE`).
  final String motivo;

  @override
  final bool reintentable;
}

/// Cualquier otra cosa: 4xx/5xx restante, `errors` inesperado o JSON que no
/// cumple el contrato. Se reporta; el usuario ve un mensaje genérico.
final class Inesperada extends Falla {
  const Inesperada([this.causa]);

  /// Solo para logs y Sentry (sin datos personales). Nunca se muestra.
  final Object? causa;

  @override
  bool get reintentable => true;
}
