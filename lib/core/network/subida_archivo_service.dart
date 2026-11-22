import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'network_exceptions.dart';

/// PUT directo a la URL firmada del almacenamiento: las imágenes nunca pasan
/// por el BFF. Usa un `Dio` propio, sin `baseUrl` ni el JWT de la sesión.
abstract interface class SubidaArchivoService {
  /// Lanza [ErrorCliente] si la subida no terminó en 2xx. [alAvanzar] recibe
  /// los bytes enviados hasta el momento, para mostrar el progreso.
  Future<void> subir({
    required String url,
    required String metodo,
    required Map<String, String> encabezados,
    required Uint8List bytes,
    void Function(int enviados)? alAvanzar,
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
    void Function(int enviados)? alAvanzar,
  }) async {
    final Response<Object?> r;
    try {
      r = await _dio.request<Object?>(
        url,
        data: Stream.fromIterable([bytes]),
        onSendProgress: alAvanzar == null
            ? null
            : (enviados, _) => alAvanzar(enviados),
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
  FakeSubidaArchivoService({this.latencia = Duration.zero});

  /// Lo que tarda cada subida; con `API_ENV=mock` deja ver la barra avanzar.
  final Duration latencia;
  final subidas = <String>[];

  /// Para pruebas: mientras esté puesto, la subida falla con este error.
  Object? error;

  @override
  Future<void> subir({
    required String url,
    required String metodo,
    required Map<String, String> encabezados,
    required Uint8List bytes,
    void Function(int enviados)? alAvanzar,
  }) async {
    final falla = error;
    if (falla != null) throw falla;
    if (latencia > Duration.zero) {
      alAvanzar?.call(bytes.length ~/ 2);
      await Future<void>.delayed(latencia);
    }
    alAvanzar?.call(bytes.length);
    subidas.add(url);
  }
}
