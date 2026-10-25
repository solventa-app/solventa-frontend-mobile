import '../network/network_exceptions.dart';
import 'falla.dart';
import 'resultado.dart';

/// Mensajes con los que el BFF señala sesión y permisos mientras no envíe
/// `extensions.codigo` (solventa-backend: services/bff/app/autenticacion_usuarios.py).
/// Es el único lugar de la app que depende de un texto del servidor.
const _mensajesSinSesion = {
  'Debes iniciar sesión.',
  'Tu sesión no es válida o venció. Inicia sesión de nuevo.',
};
const _mensajesSinPermiso = {'No tienes permiso para esta operación.'};

/// Ejecuta [operacion] y convierte cualquier error en una [Falla].
///
/// La usan todos los repositorios: así ninguna excepción de red, de GraphQL
/// o de parseo (`fromJson` del contrato) llega a la presentación.
Future<Resultado<T>> guardarFallas<T>(Future<T> Function() operacion) async {
  try {
    return Exito(await operacion());
  } on ErrorCliente catch (e) {
    return Fracaso(fallaDesdeErrorCliente(e));
  } catch (e) {
    // TypeError o FormatException del fromJson: la respuesta no cumple el contrato.
    return Fracaso(Inesperada(e));
  }
}

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
  ErrorGraphql(:final mensajes)
      when mensajes.any(_mensajesSinSesion.contains) =>
    const SesionVencida(),
  ErrorGraphql(:final mensajes)
      when mensajes.any(_mensajesSinPermiso.contains) =>
    const SinPermiso(),
  ErrorGraphql() => Inesperada(e),
};
