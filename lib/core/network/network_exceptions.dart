/// Excepciones del cliente GraphQL. Solo las ve la capa `data`; el
/// repositorio las convierte en `Falla` con `guardarFallas`.
sealed class ErrorCliente implements Exception {
  const ErrorCliente();
}

/// Sin red, DNS o timeout de conexión.
final class ErrorRed extends ErrorCliente {
  const ErrorRed({this.tipo});

  /// Tipo exacto del fallo de red (`DioExceptionType.name`: `connectionError`,
  /// `connectionTimeout`, `badCertificate`, `cancel`, `unknown`). Solo para
  /// logs: no lleva URL ni datos personales.
  final String? tipo;
}

/// Timeout esperando la respuesta.
final class ErrorTiempoRespuesta extends ErrorCliente {
  const ErrorTiempoRespuesta();
}

/// Respuesta HTTP distinta de 2xx.
final class ErrorHttp extends ErrorCliente {
  const ErrorHttp(this.status);
  final int status;
}

/// El cuerpo trae `errors` o no trae `data`.
final class ErrorGraphql extends ErrorCliente {
  const ErrorGraphql(this.mensajes, {this.codigo});

  /// Mensajes públicos del BFF (`ErrorPublico`). No se muestran al usuario.
  final List<String> mensajes;

  /// `extensions.codigo`, cuando el BFF lo envíe (pendiente en el backend).
  final String? codigo;

  @override
  String toString() => 'ErrorGraphql($codigo, $mensajes)';
}

/// Mensajes con los que el BFF señala sesión vencida o ausente mientras no
/// envíe `extensions.codigo` (solventa-backend:
/// services/bff/app/autenticacion_usuarios.py). Único lugar de la app que
/// depende de un texto del servidor.
const mensajesSinSesion = {
  'Debes iniciar sesión.',
  'Tu sesión no es válida o venció. Inicia sesión de nuevo.',
};

/// `true` si [e] dice que el JWT venció o falta (HTTP 401 o los mensajes de
/// [mensajesSinSesion]): el cliente intenta renovar la sesión.
bool esErrorSinSesion(ErrorCliente e) => switch (e) {
  ErrorHttp(status: 401) => true,
  ErrorGraphql(:final mensajes) => mensajes.any(mensajesSinSesion.contains),
  _ => false,
};
