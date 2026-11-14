import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:solventa_mobile/core/network/graphql_client.dart';

/// BFF de prueba para los datasources reales: responde [responder] a cualquier
/// operación y guarda la última petición para revisar qué mandó la app.
class BffDePrueba {
  BffDePrueba() {
    final dio = Dio(BaseOptions(baseUrl: 'http://bff.test'));
    _adaptador = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          cuerpo = o.data as Map<String, dynamic>;
          h.next(o);
        },
      ),
    );
    cliente = GraphqlClient(dio);
  }

  late final DioAdapter _adaptador;
  late final GraphqlClient cliente;
  Map<String, dynamic> cuerpo = const {};

  void responder(Map<String, Object?> data) => _adaptador.onPost(
    GraphqlClient.ruta,
    (server) => server.reply(200, {'data': data}),
  );

  Map<String, dynamic> get variables =>
      cuerpo['variables'] as Map<String, dynamic>;

  String get query => cuerpo['query'] as String;
}
