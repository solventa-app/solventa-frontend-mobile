import '../../../../core/network/graphql_client.dart';
import '../../domain/cercania.dart';
import '../../domain/entities/prestador.dart';
import '../fixtures/asistencia_fixtures.dart';
import '../graphql/catalogo_prestadores.graphql.dart';
import '../graphql/rutas_prestadores.graphql.dart';
import '../graphql/solicitud_asistencia.graphql.dart';
import '../graphql/ubicar_direccion.graphql.dart';
import '../mappers/prestador_mapper.dart';

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

  /// `data.autocompletarDireccion` en Colombia (contrato v0.32, usado por
  /// HU-M06 desde la v0.50): `[{placeId, descripcion}]`.
  Future<List<Map<String, Object?>>> autocompletarDireccion(String texto);

  /// `data.ubicarDireccion` (contrato v0.50, B9).
  Future<Map<String, Object?>> ubicarDireccion({
    String? placeId,
    String? texto,
  });

  /// `data.rutasPrestadores` (contrato v0.51, B8): los destacados primero.
  Future<List<Map<String, Object?>>> rutasPrestadores(
    Coordenada origen,
    List<String> prestadorIds,
  );
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
  Future<List<Map<String, Object?>>> autocompletarDireccion(
    String texto,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeQueryAutocompletarDireccion,
      variables: Variables$Query$AutocompletarDireccion(
        texto: texto,
        pais: 'CO',
      ).toJson(),
    );
    return [
      for (final s in Query$AutocompletarDireccion.fromJson(
        data,
      ).autocompletarDireccion)
        s.toJson(),
    ];
  }

  @override
  Future<List<Map<String, Object?>>> rutasPrestadores(
    Coordenada origen,
    List<String> prestadorIds,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeQueryRutasPrestadores,
      variables: Variables$Query$RutasPrestadores(
        latitud: origen.latitud,
        longitud: origen.longitud,
        prestadorIds: prestadorIds,
      ).toJson(),
    );
    return [
      for (final r in Query$RutasPrestadores.fromJson(data).rutasPrestadores)
        r.toJson(),
    ];
  }

  @override
  Future<Map<String, Object?>> ubicarDireccion({
    String? placeId,
    String? texto,
  }) async {
    final data = await _cliente.ejecutar(
      documentNodeQueryUbicarDireccion,
      variables: Variables$Query$UbicarDireccion(
        placeId: placeId,
        texto: texto,
      ).toJson(),
    );
    return Query$UbicarDireccion.fromJson(data).ubicarDireccion.toJson();
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

  /// Como `stubs/prestadores` con `primero_falla` (v0.49): el primer envío
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

  /// Para pruebas: `ubicarDireccion` responde como si Google no contestara.
  bool lugaresCaidos = false;

  /// Para pruebas: `rutasPrestadores` vuelve vacía (proveedor caído).
  bool rutasCaidas = false;

  /// Como el modo simulado del ACL: línea recta y las reglas de la app;
  /// geometría solo para los 3 primeros.
  @override
  Future<List<Map<String, Object?>>> rutasPrestadores(
    Coordenada origen,
    List<String> prestadorIds,
  ) async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    final e = error;
    if (e != null) throw e;
    if (rutasCaidas) return const [];
    final rutas = <Map<String, Object?>>[];
    for (final (i, id) in prestadorIds.indexed) {
      final p = AsistenciaFixtures.prestadores
          .where((p) => p['id'] == id)
          .firstOrNull;
      if (p == null) continue;
      final destino = Coordenada(
        (p['latitud']! as num).toDouble(),
        (p['longitud']! as num).toDouble(),
      );
      final km = Cercania.distanciaKm(destino, origen);
      rutas.add({
        'prestadorId': id,
        'distanciaMetros': (km * 1000).round(),
        'duracionSegundos': Cercania.minutosEstimados(km) * 60,
        'geometria': i < 3 ? codificarPolyline6([destino, origen]) : null,
        'estimado': true,
      });
    }
    return rutas;
  }

  /// Como el stub del ACL: sugiere lo escrito con tres ciudades (boceto 5).
  @override
  Future<List<Map<String, Object?>>> autocompletarDireccion(
    String texto,
  ) async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    final e = error;
    if (e != null) throw e;
    return [
      for (final ciudad in const [
        'Bogotá, Cundinamarca',
        'Medellín, Antioquia',
        'Cali, Valle del Cauca',
      ])
        {'placeId': 'stub:CO:$texto|$ciudad', 'descripcion': '$texto, $ciudad'},
    ];
  }

  /// Como el stub del ACL: cerca del Parque de la 93; «noexiste» no se
  /// encuentra.
  @override
  Future<Map<String, Object?>> ubicarDireccion({
    String? placeId,
    String? texto,
  }) async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    final e = error;
    if (e != null) throw e;
    if (lugaresCaidos) {
      return {'encontrada': false, 'codigo': 'SERVICIO_NO_DISPONIBLE'};
    }
    final valor = placeId == null
        ? (texto ?? '')
        : placeId.split(':').skip(2).join(':').split('|').first;
    if (valor.trim().length < 3 || valor.contains('noexiste')) {
      return {'encontrada': false, 'codigo': 'DIRECCION_NO_ENCONTRADA'};
    }
    return {
      'encontrada': true,
      'latitud': 4.6729,
      'longitud': -74.0512,
      'direccion': valor.trim(),
      'codigo': null,
    };
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
