import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/network/graphql_client.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/features/onboarding/data/graphql/onboarding.graphql.dart';

/// HU-M02 (F5): ante un JWT vencido el cliente renueva una vez y repite.
void main() {
  late Dio dio;
  late List<Response<Object?>> respuestas;
  late List<String?> autorizaciones;

  Response<Object?> respuesta(int status, Object? cuerpo) => Response<Object?>(
    requestOptions: RequestOptions(path: GraphqlClient.ruta),
    statusCode: status,
    data: cuerpo,
  );

  final sinSesion = {
    'errors': [
      {'message': 'Tu sesión no es válida o venció. Inicia sesión de nuevo.'},
    ],
  };
  final ok = {
    'data': {'ok': true},
  };

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://bff.test'));
    respuestas = [];
    autorizaciones = [];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          autorizaciones.add(o.headers['Authorization'] as String?);
          h.resolve(respuestas.removeAt(0));
        },
      ),
    );
  });

  Future<Map<String, dynamic>> ejecutar(GraphqlClient c) =>
      c.ejecutar(documentNodeQueryYo);

  test(
    'JWT vencido (mensaje del BFF): renueva y repite con el nuevo',
    () async {
      var token = 'viejo';
      var renovaciones = 0;
      respuestas = [respuesta(200, sinSesion), respuesta(200, ok)];
      final c = GraphqlClient(
        dio,
        leerToken: () async => token,
        renovarSesion: () async {
          renovaciones++;
          token = 'nuevo';
          return true;
        },
      );

      expect(await ejecutar(c), {'ok': true});
      expect(renovaciones, 1);
      expect(autorizaciones, ['Bearer viejo', 'Bearer nuevo']);
    },
  );

  test('HTTP 401: también renueva y repite', () async {
    respuestas = [respuesta(401, null), respuesta(200, ok)];
    final c = GraphqlClient(
      dio,
      leerToken: () async => 'jwt',
      renovarSesion: () async => true,
    );

    expect(await ejecutar(c), {'ok': true});
  });

  test('si la renovación falla, lanza el error original sin repetir', () async {
    respuestas = [respuesta(401, null)];
    final c = GraphqlClient(
      dio,
      leerToken: () async => 'jwt',
      renovarSesion: () async => false,
    );

    await expectLater(ejecutar(c), throwsA(isA<ErrorHttp>()));
    expect(autorizaciones, hasLength(1));
  });

  test('repite una sola vez aunque el segundo intento también falle', () async {
    var renovaciones = 0;
    respuestas = [respuesta(401, null), respuesta(401, null)];
    final c = GraphqlClient(
      dio,
      leerToken: () async => 'jwt',
      renovarSesion: () async {
        renovaciones++;
        return true;
      },
    );

    await expectLater(ejecutar(c), throwsA(isA<ErrorHttp>()));
    expect(renovaciones, 1);
    expect(autorizaciones, hasLength(2));
  });

  test('otros errores no disparan la renovación', () async {
    var renovaciones = 0;
    respuestas = [respuesta(503, null)];
    final c = GraphqlClient(
      dio,
      renovarSesion: () async {
        renovaciones++;
        return true;
      },
    );

    await expectLater(ejecutar(c), throwsA(isA<ErrorHttp>()));
    expect(renovaciones, 0);
  });

  test('sin renovador (cliente de la sesión) lanza de inmediato', () async {
    respuestas = [respuesta(200, sinSesion)];

    await expectLater(
      ejecutar(GraphqlClient(dio)),
      throwsA(isA<ErrorGraphql>()),
    );
  });

  test('esErrorSinSesion reconoce el 401 y los mensajes del BFF', () {
    expect(esErrorSinSesion(const ErrorHttp(401)), isTrue);
    expect(
      esErrorSinSesion(const ErrorGraphql(['Debes iniciar sesión.'])),
      isTrue,
    );
    expect(esErrorSinSesion(const ErrorHttp(403)), isFalse);
    expect(esErrorSinSesion(const ErrorRed()), isFalse);
    expect(esErrorSinSesion(const ErrorGraphql(['Otro error'])), isFalse);
  });
}
