import 'package:dio/dio.dart';
import 'package:gql/ast.dart';
import 'package:gql/language.dart' show printNode;

import 'network_exceptions.dart';

/// Lee el JWT de la sesión activa (o `null` sin sesión).
typedef LectorToken = Future<String?> Function();

/// Cliente GraphQL mínimo contra el canal móvil del BFF (`POST /graphql/app`).
///
/// Igual que `apps/web/src/graphql/cliente.ts` de la web: sin librería GraphQL,
/// un solo método y errores tipados. Recibe los `DocumentNode` que genera
/// `graphql_codegen` y devuelve el `data` crudo para que el datasource lo
/// parsee con el `fromJson` generado.
class GraphqlClient {
  GraphqlClient(this._dio, {this.leerToken});

  /// Ruta del canal móvil en el BFF y en el gateway.
  static const ruta = '/graphql/app';

  final Dio _dio;

  /// De dónde sale el JWT para `Authorization: Bearer`.
  final LectorToken? leerToken;

  /// Ejecuta [documento] y devuelve `data`. Lanza [ErrorCliente].
  ///
  /// No reintenta: las mutaciones pueden no ser idempotentes y el reintento
  /// lo decide el usuario con «Reintentar».
  Future<Map<String, dynamic>> ejecutar(
    DocumentNode documento, {
    Map<String, dynamic> variables = const {},
  }) async {
    final token = await leerToken?.call();
    final Response<Object?> respuesta;
    try {
      respuesta = await _dio.post<Object?>(
        ruta,
        data: <String, Object?>{
          'query': printNode(documento),
          'variables': variables,
        },
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
          // Los códigos se interpretan aquí, no como excepción de dio.
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (e) {
      throw switch (e.type) {
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => const ErrorTiempoRespuesta(),
        _ => const ErrorRed(),
      };
    }

    final status = respuesta.statusCode ?? 0;
    if (status < 200 || status >= 300) throw ErrorHttp(status);

    final cuerpo = respuesta.data;
    if (cuerpo is! Map<String, dynamic>) {
      throw const ErrorGraphql(['Respuesta sin JSON']);
    }
    final errores = cuerpo['errors'];
    if (errores is List && errores.isNotEmpty) {
      throw _errorGraphql(errores);
    }
    final data = cuerpo['data'];
    if (data is! Map<String, dynamic>) {
      throw const ErrorGraphql(['Respuesta GraphQL sin datos']);
    }
    return data;
  }

  static ErrorGraphql _errorGraphql(List<dynamic> errores) {
    final mensajes = <String>[];
    String? codigo;
    for (final e in errores) {
      if (e is! Map<String, dynamic>) continue;
      final mensaje = e['message'];
      if (mensaje is String) mensajes.add(mensaje);
      final extensiones = e['extensions'];
      if (codigo == null && extensiones is Map<String, dynamic>) {
        final c = extensiones['codigo'];
        if (c is String) codigo = c;
      }
    }
    return ErrorGraphql(mensajes, codigo: codigo);
  }
}
