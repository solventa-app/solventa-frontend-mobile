import '../fixtures/asistencia_fixtures.dart';

/// Operaciones de asistencia en sitio del BFF.
///
/// Devuelve `data.catalogoPrestadores` tal como llega; el mapper lo traduce a
/// entidades. Cuando el contrato tenga la operación (KAN-263), la
/// implementación real usa el tipo generado.
abstract interface class AsistenciaRemoteDataSource {
  /// Con [versionLocal] igual a la vigente el backend responde `vigente: true`
  /// sin la lista (respuesta mínima, docs/hu-m06-backend.md).
  Future<Map<String, Object?>> catalogoPrestadores({String? versionLocal});
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
