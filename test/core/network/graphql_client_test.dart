import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:solventa_mobile/core/network/graphql_client.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/features/onboarding/data/graphql/registrar_consentimiento.graphql.dart';

void main() {
  late Dio dio;
  late DioAdapter adaptador;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://bff.test'));
    adaptador = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
  });

  GraphqlClient cliente({String? token}) =>
      GraphqlClient(dio, leerToken: () async => token);

  Future<Map<String, dynamic>> ejecutar(GraphqlClient c) =>
      c.ejecutar(documentNodeMutationRegistrarConsentimiento);

  test('devuelve data y envía el JWT al canal /graphql/app', () async {
    Map<String, dynamic>? cabeceras;
    adaptador.onPost(GraphqlClient.ruta, (server) {
      return server.reply(200, {
        'data': {'ok': true},
      });
    });
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          cabeceras = o.headers;
          h.next(o);
        },
      ),
    );

    final data = await ejecutar(cliente(token: 'jwt'));

    expect(data, {'ok': true});
    expect(cabeceras?['Authorization'], 'Bearer jwt');
  });

  test('sin sesión no envía Authorization', () async {
    Map<String, dynamic>? cabeceras;
    adaptador.onPost(
      GraphqlClient.ruta,
      (server) => server.reply(200, {'data': <String, dynamic>{}}),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          cabeceras = o.headers;
          h.next(o);
        },
      ),
    );

    await ejecutar(cliente());

    expect(cabeceras?.containsKey('Authorization'), isFalse);
  });

  test('errors en un HTTP 200 lanza ErrorGraphql con mensajes y código', () {
    adaptador.onPost(
      GraphqlClient.ruta,
      (server) => server.reply(200, {
        'data': null,
        'errors': [
          {
            'message': 'Debes iniciar sesión.',
            'extensions': {'codigo': 'SIN_SESION'},
          },
        ],
      }),
    );

    expect(
      ejecutar(cliente()),
      throwsA(
        isA<ErrorGraphql>()
            .having((e) => e.mensajes, 'mensajes', ['Debes iniciar sesión.'])
            .having((e) => e.codigo, 'codigo', 'SIN_SESION'),
      ),
    );
  });

  test('respuesta sin data lanza ErrorGraphql', () {
    adaptador.onPost(
      GraphqlClient.ruta,
      (server) => server.reply(200, <String, dynamic>{}),
    );
    expect(ejecutar(cliente()), throwsA(isA<ErrorGraphql>()));
  });

  for (final status in [401, 500, 503]) {
    test('HTTP $status lanza ErrorHttp($status)', () {
      adaptador.onPost(
        GraphqlClient.ruta,
        (server) => server.reply(status, {'detail': 'x'}),
      );
      expect(
        ejecutar(cliente()),
        throwsA(isA<ErrorHttp>().having((e) => e.status, 'status', status)),
      );
    });
  }

  test('sin conexión lanza ErrorRed', () {
    adaptador.onPost(
      GraphqlClient.ruta,
      (server) => server.throws(
        0,
        DioException.connectionError(
          requestOptions: RequestOptions(path: GraphqlClient.ruta),
          reason: 'sin red',
        ),
      ),
    );
    expect(ejecutar(cliente()), throwsA(isA<ErrorRed>()));
  });

  test('timeout de respuesta lanza ErrorTiempoRespuesta', () {
    adaptador.onPost(
      GraphqlClient.ruta,
      (server) => server.throws(
        0,
        DioException.receiveTimeout(
          timeout: const Duration(seconds: 15),
          requestOptions: RequestOptions(path: GraphqlClient.ruta),
        ),
      ),
    );
    expect(ejecutar(cliente()), throwsA(isA<ErrorTiempoRespuesta>()));
  });
}
