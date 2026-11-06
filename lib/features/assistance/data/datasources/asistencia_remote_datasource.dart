import '../../../../core/network/graphql_client.dart';
import '../fixtures/asistencia_fixtures.dart';
import '../graphql/catalogo_prestadores.graphql.dart';

/// Operaciones de asistencia en sitio del BFF (contrato v0.36).
///
/// Devuelve `data.catalogoPrestadores` como mapa (la forma del contrato): así
/// se guarda tal cual en la copia local del teléfono y el mapper lo traduce a
/// entidades.
abstract interface class AsistenciaRemoteDataSource {
  /// Con [versionLocal] igual a la vigente el backend responde `vigente: true`
  /// sin la lista (respuesta mínima, docs/hu-m06-backend.md).
  Future<Map<String, Object?>> catalogoPrestadores({String? versionLocal});
}

/// El BFF real: parsea con el tipo generado (falla si no cumple el contrato) y
/// devuelve su JSON.
final class GqlAsistenciaRemoteDataSource
    implements AsistenciaRemoteDataSource {
  const GqlAsistenciaRemoteDataSource(this._cliente);

  final GraphqlClient _cliente;

  @override
  Future<Map<String, Object?>> catalogoPrestadores({
    String? versionLocal,
  }) async {
    final data = await _cliente.ejecutar(
      documentNodeQueryCatalogoPrestadores,
      variables: Variables$Query$CatalogoPrestadores(versionLocal: versionLocal)
          .toJson(),
    );
    return Query$CatalogoPrestadores.fromJson(data).catalogoPrestadores
        .toJson();
  }
}

/// Fake con la misma semilla que carga el backend.
final class FakeAsistenciaRemoteDataSource
    implements AsistenciaRemoteDataSource {
  FakeAsistenciaRemoteDataSource({
    this.latencia = const Duration(milliseconds: 400),
  });

  final Duration latencia;

  /// Para pruebas: cuántas veces se consultó.
  int consultas = 0;

  /// Para pruebas: la siguiente consulta lanza este error.
  Object? error;

  @override
  Future<Map<String, Object?>> catalogoPrestadores({
    String? versionLocal,
  }) async {
    consultas++;
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    final e = error;
    if (e != null) throw e;
    return versionLocal == AsistenciaFixtures.version
        ? AsistenciaFixtures.catalogoVigente
        : AsistenciaFixtures.catalogo;
  }
}
