import '../../../../core/network/graphql_client.dart';
import '../fixtures/asistencia_fixtures.dart';
import '../graphql/catalogo_prestadores.graphql.dart';
import '../graphql/solicitud_asistencia.graphql.dart';

/// Operaciones de asistencia en sitio del BFF (contratos v0.36 y v0.40).
///
/// Devuelve `data.catalogoPrestadores` como mapa (la forma del contrato): así
/// se guarda tal cual en la copia local del teléfono y el mapper lo traduce a
/// entidades.
abstract interface class AsistenciaRemoteDataSource {
  /// Con [versionLocal] igual a la vigente el backend responde `vigente: true`
  /// sin la lista (respuesta mínima, docs/hu-m06-backend.md).
  Future<Map<String, Object?>> catalogoPrestadores({String? versionLocal});

  /// `data.solicitarAsistencia` (contrato v0.40), validado contra el tipo
  /// generado. [entrada] es un `SolicitudAsistenciaInput`.
  Future<Map<String, Object?>> solicitarAsistencia(
    Map<String, Object?> entrada,
  );

  /// `data.cancelarAsistencia` (contrato v0.40).
  Future<Map<String, Object?>> cancelarAsistencia(String id);
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

  @override
  Future<Map<String, Object?>> solicitarAsistencia(
    Map<String, Object?> entrada,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationSolicitarAsistencia,
      // Pasa por el tipo generado: una entrada que no cumple el contrato
      // falla aquí y no en el BFF.
      variables: Variables$Mutation$SolicitarAsistencia.fromJson({
        'entrada': entrada,
      }).toJson(),
    );
    return Mutation$SolicitarAsistencia.fromJson(data).solicitarAsistencia
        .toJson();
  }

  @override
  Future<Map<String, Object?>> cancelarAsistencia(String id) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationCancelarAsistencia,
      variables: Variables$Mutation$CancelarAsistencia(id: id).toJson(),
    );
    return Mutation$CancelarAsistencia.fromJson(data).cancelarAsistencia
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

  /// Como CLAIMS con `ASISTENCIA_SIMULACION=primero_falla`: el primer envío
  /// queda NO_CONFIRMADA y el reenvío con el mismo id se confirma.
  final Map<String, Map<String, Object?>> asistencias = {};

  /// Para pruebas: cada solicitud recibida.
  final List<Map<String, Object?>> solicitudes = [];

  /// Para pruebas: con `true` el primer intento ya se confirma.
  bool confirmarSiempre = false;

  /// Para pruebas: la siguiente solicitud responde este `ErrorAsistencia`.
  String? rechazo;

  @override
  Future<Map<String, Object?>> solicitarAsistencia(
    Map<String, Object?> entrada,
  ) async {
    solicitudes.add(entrada);
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    final e = error;
    if (e != null) throw e;
    final codigo = rechazo;
    if (codigo != null) return AsistenciaFixtures.errorAsistencia(codigo);
    final id = entrada['idSolicitud']! as String;
    final previa = asistencias[id];
    final prestador = AsistenciaFixtures.prestadores.firstWhere(
      (p) => p['id'] == entrada['prestadorId'],
      orElse: () => AsistenciaFixtures.prestadores.first,
    );
    final confirmar = confirmarSiempre || previa?['estado'] == 'NO_CONFIRMADA';
    final respuesta = previa != null && previa['estado'] != 'NO_CONFIRMADA'
        ? previa
        : AsistenciaFixtures.asistencia(
            id: id,
            estado: confirmar ? 'CONFIRMADA' : 'NO_CONFIRMADA',
            prestador: prestador,
            tipoAsistencia: entrada['tipoAsistencia']! as String,
            minutosEstimados: confirmar ? 6 : null,
            motivo: confirmar ? null : 'PRESTADOR_SIN_RESPUESTA',
          );
    asistencias[id] = respuesta;
    return respuesta;
  }

  @override
  Future<Map<String, Object?>> cancelarAsistencia(String id) async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    final e = error;
    if (e != null) throw e;
    final previa = asistencias[id];
    if (previa == null) {
      return AsistenciaFixtures.errorAsistencia('NO_ENCONTRADA');
    }
    final cancelada = {
      ...previa,
      'estado': 'CANCELADA',
      'canceladaEn': '2026-11-07T15:05:00+00:00',
    };
    asistencias[id] = cancelada;
    return cancelada;
  }
}
