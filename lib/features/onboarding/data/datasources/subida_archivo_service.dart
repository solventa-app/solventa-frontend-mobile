import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/network/network_exceptions.dart';

/// PUT directo a la URL firmada del almacenamiento: las imágenes nunca pasan
/// por el BFF. Usa un `Dio` propio, sin `baseUrl` ni el JWT de la sesión.
abstract interface class SubidaArchivoService {
  /// Lanza [ErrorCliente] si la subida no terminó en 2xx.
  Future<void> subir({
    required String url,
    required String metodo,
    required Map<String, String> encabezados,
    required Uint8List bytes,
  });
}

final class DioSubidaArchivoService implements SubidaArchivoService {
  DioSubidaArchivoService([Dio? dio])
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 60),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

  final Dio _dio;

  @override
  Future<void> subir({
    required String url,
    required String metodo,
    required Map<String, String> encabezados,
    required Uint8List bytes,
  }) async {
    final Response<Object?> r;
    try {
      r = await _dio.request<Object?>(
        url,
        data: Stream.fromIterable([bytes]),
        options: Options(
          method: metodo,
          headers: {...encabezados, Headers.contentLengthHeader: bytes.length},
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (e) {
      throw switch (e.type) {
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout => const ErrorTiempoRespuesta(),
        _ => const ErrorRed(),
      };
    }
    final status = r.statusCode ?? 0;
    if (status < 200 || status >= 300) throw ErrorHttp(status);
  }
}

/// Para `API_ENV=mock` y pruebas: registra lo que se habría subido.
final class FakeSubidaArchivoService implements SubidaArchivoService {
  final subidas = <String>[];

  @override
  Future<void> subir({
    required String url,
    required String metodo,
    required Map<String, String> encabezados,
    required Uint8List bytes,
  }) async => subidas.add(url);
}
