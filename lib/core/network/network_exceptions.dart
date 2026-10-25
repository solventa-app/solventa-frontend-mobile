/// Excepciones del cliente GraphQL. Solo las ve la capa `data`; el
/// repositorio las convierte en `Falla` con `guardarFallas`.
sealed class ErrorCliente implements Exception {
  const ErrorCliente();
}

/// Sin red, DNS o timeout de conexión.
final class ErrorRed extends ErrorCliente {
  const ErrorRed();
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
