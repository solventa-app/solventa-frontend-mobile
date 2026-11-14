import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';

void main() {
  const url = 'http://almacen.test/subida/abc';
  final bytes = Uint8List.fromList([1, 2, 3]);

  late Dio dio;
  late DioAdapter adaptador;
  late DioSubidaArchivoService servicio;

  setUp(() {
    dio = Dio();
    adaptador = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    servicio = DioSubidaArchivoService(dio);
  });

  Future<void> subir() => servicio.subir(
    url: url,
    metodo: 'PUT',
    encabezados: const {'Content-Type': 'image/jpeg'},
    bytes: bytes,
  );

  test('un 200 termina sin error', () async {
    adaptador.onRoute(
      url,
      (s) => s.reply(200, null),
      request: Request(method: RequestMethods.put),
    );

    await subir();
  });

  test('un estado fuera de 2xx lanza ErrorHttp con el código', () async {
    adaptador.onRoute(
      url,
      (s) => s.reply(403, null),
      request: Request(method: RequestMethods.put),
    );

    await expectLater(
      subir(),
      throwsA(isA<ErrorHttp>().having((e) => e.status, 'status', 403)),
    );
  });

  test('un corte de conexión lanza ErrorRed', () async {
    adaptador.onRoute(
      url,
      (s) => s.throws(
        500,
        DioException(
          requestOptions: RequestOptions(path: url),
          type: DioExceptionType.connectionError,
        ),
      ),
      request: Request(method: RequestMethods.put),
    );

    await expectLater(subir(), throwsA(isA<ErrorRed>()));
  });

  test('un tiempo agotado lanza ErrorTiempoRespuesta', () async {
    adaptador.onRoute(
      url,
      (s) => s.throws(
        500,
        DioException(
          requestOptions: RequestOptions(path: url),
          type: DioExceptionType.receiveTimeout,
        ),
      ),
      request: Request(method: RequestMethods.put),
    );

    await expectLater(subir(), throwsA(isA<ErrorTiempoRespuesta>()));
  });

  test('sin Dio propio construye uno con tiempos de espera', () {
    expect(DioSubidaArchivoService.new, returnsNormally);
  });
}
