import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lo que cuentan las peticiones reales sobre la red, sin esperar a la
/// próxima prueba: si una falla por conexión, la app lo sabe al instante.
///
/// Es un buzón: el interceptor de Dio deja la señal y el notificador de red
/// la recoge si está vivo. Así el cliente HTTP no depende del notificador.
final class SenalesRed {
  /// Una petición no encontró red (sin ruta, DNS, socket cerrado).
  void Function()? alFallarConexion;

  /// Una petición agotó el tiempo de espera.
  void Function()? alAgotarTiempo;

  /// El servidor contestó (cualquier código HTTP): hay salida a internet.
  void Function()? alResponder;

  void falloDeConexion() => alFallarConexion?.call();
  void tiempoAgotado() => alAgotarTiempo?.call();
  void respuesta() => alResponder?.call();
}

final senalesRedProvider = Provider<SenalesRed>((ref) => SenalesRed());

/// Traduce cada petición del cliente HTTP en una señal de red. No toca la
/// petición ni la respuesta, y no registra nada.
final class InterceptorSenalesRed extends Interceptor {
  InterceptorSenalesRed(this._senales);

  final SenalesRed _senales;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _senales.respuesta();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        _senales.falloDeConexion();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _senales.tiempoAgotado();
      case DioExceptionType.badResponse:
        _senales.respuesta();
      case DioExceptionType.badCertificate:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        break;
    }
    handler.next(err);
  }
}
