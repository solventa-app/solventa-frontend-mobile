import '../log/sol_log.dart';
import '../network/network_exceptions.dart';
import 'falla.dart';
import 'resultado.dart';

/// Mensajes con los que el BFF señala permisos mientras no envíe
/// `extensions.codigo` (los de sesión viven en `network_exceptions.dart`).
const _mensajesSinPermiso = {'No tienes permiso para esta operación.'};

/// Ejecuta [operacion] y convierte cualquier error en una [Falla].
///
/// La usan todos los repositorios: así ninguna excepción de red, de GraphQL
/// o de parseo (`fromJson` del contrato) llega a la presentación.
Future<Resultado<T>> guardarFallas<T>(Future<T> Function() operacion) async {
  try {
    return Exito(await operacion());
  } on ErrorCliente catch (e, st) {
    final falla = fallaDesdeErrorCliente(e);
    if (falla is Inesperada) {
      SolLog.severe(
        'Falla inesperada de cliente (${e.runtimeType})',
        error: e.runtimeType.toString(),
        stackTrace: st,
        codigo: _codigoDe(e),
      );
    } else {
      SolLog.info(
        'Falla esperada de red/sesión (${falla.runtimeType})',
        codigo: _codigoDe(e),
      );
    }
    return Fracaso(falla);
  } catch (e, st) {
    // TypeError o FormatException del fromJson: la respuesta no cumple el contrato.
    SolLog.severe(
      'Falla inesperada al procesar respuesta (${e.runtimeType})',
      error: e.runtimeType.toString(),
      stackTrace: st,
    );
    return Fracaso(Inesperada(e));
  }
}

/// Dato para el log: el código del BFF o, en un fallo de red, su tipo exacto
/// (`connectionError`, `connectionTimeout`...). Nunca un dato personal.
String? _codigoDe(ErrorCliente e) => switch (e) {
  ErrorGraphql(:final codigo) => codigo,
  ErrorRed(:final tipo) => tipo,
  _ => null,
};

/// Tabla de docs/integracion-backend.md §4.
Falla fallaDesdeErrorCliente(ErrorCliente e) => switch (e) {
  ErrorRed() => const SinConexion(),
  ErrorTiempoRespuesta() => const ServicioNoDisponible(),
  ErrorHttp(status: 502 || 503 || 504) => const ServicioNoDisponible(),
  ErrorHttp(status: 401) => const SesionVencida(),
  ErrorHttp(status: 403) => const SinPermiso(),
  ErrorHttp() => Inesperada(e),
  ErrorGraphql(codigo: 'SIN_SESION' || 'TOKEN_INVALIDO') =>
    const SesionVencida(),
  ErrorGraphql(codigo: 'SIN_PERMISO') => const SinPermiso(),
  ErrorGraphql(:final mensajes) when mensajes.any(mensajesSinSesion.contains) =>
    const SesionVencida(),
  ErrorGraphql(:final mensajes)
      when mensajes.any(_mensajesSinPermiso.contains) =>
    const SinPermiso(),
  ErrorGraphql() => Inesperada(e),
};
