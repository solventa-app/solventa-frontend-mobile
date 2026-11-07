import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:solventa_mobile/core/network/graphql_client.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';

void main() {
  test('iniciarSesion manda el rol CLIENTE de la app', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://bff.test'));
    final adaptador = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    final respuesta = {'data': OnboardingFixtures.iniciarSesion};
    adaptador.onPost(
      GraphqlClient.ruta,
      (server) => server.reply(200, respuesta),
    );
    Object? capturado;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          capturado = o.data;
          h.next(o);
        },
      ),
    );
    final remoto = GqlOnboardingRemoteDataSource(GraphqlClient(dio));

    await remoto.iniciarSesion('maria@ejemplo.co', 'Clave-segura-1');

    final cuerpo = capturado! as Map<String, dynamic>;
    final variables = cuerpo['variables'] as Map<String, dynamic>;
    final entrada = variables['entrada'] as Map<String, dynamic>;
    expect(entrada['rol'], 'CLIENTE');
    expect(entrada['usuario'], 'maria@ejemplo.co');
  });
}
