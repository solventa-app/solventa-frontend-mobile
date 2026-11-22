import '../../../../core/contrato/schema.graphql.dart';
import '../../../../core/network/graphql_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../fixtures/reporte_siniestro_fixtures.dart';
import '../graphql/reporte_siniestro.graphql.dart';

/// Operaciones de HU-M05 en el BFF (contrato v0.35), con sus tipos generados.
abstract interface class ReporteSiniestroRemoteDataSource {
  Future<Query$PolizasParaReporte> polizas();

  Future<
    Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro
  >
  solicitarSubida(String idReporte, String tipoContenido, int tamanoBytes);

  Future<Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo> confirmar(
    String archivoId,
  );

  Future<Mutation$ReportarSiniestro$reportarSiniestro> reportar(
    Input$ReporteSiniestroInput entrada,
  );

  Future<Query$MisSiniestros> misSiniestros();

  /// v0.54: el detalle de un caso; `miSiniestro` null si no es del cliente.
  Future<Query$MiSiniestro> miSiniestro(String id);
}

final class GqlReporteSiniestroRemoteDataSource
    implements ReporteSiniestroRemoteDataSource {
  const GqlReporteSiniestroRemoteDataSource(this._cliente);

  final GraphqlClient _cliente;

  @override
  Future<Query$PolizasParaReporte> polizas() async =>
      Query$PolizasParaReporte.fromJson(
        await _cliente.ejecutar(documentNodeQueryPolizasParaReporte),
      );

  @override
  Future<
    Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro
  >
  solicitarSubida(
    String idReporte,
    String tipoContenido,
    int tamanoBytes,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationSolicitarSubidaEvidenciaSiniestro,
      variables: Variables$Mutation$SolicitarSubidaEvidenciaSiniestro(
        idReporte: idReporte,
        tipoContenido: tipoContenido,
        tamanoBytes: tamanoBytes,
      ).toJson(),
    );
    return Mutation$SolicitarSubidaEvidenciaSiniestro.fromJson(data)
        .solicitarSubidaEvidenciaSiniestro;
  }

  @override
  Future<Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo> confirmar(
    String archivoId,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationConfirmarSubidaEvidencia,
      variables: Variables$Mutation$ConfirmarSubidaEvidencia(id: archivoId)
          .toJson(),
    );
    return Mutation$ConfirmarSubidaEvidencia.fromJson(data)
        .confirmarSubidaArchivo;
  }

  @override
  Future<Mutation$ReportarSiniestro$reportarSiniestro> reportar(
    Input$ReporteSiniestroInput entrada,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationReportarSiniestro,
      variables: Variables$Mutation$ReportarSiniestro(entrada: entrada)
          .toJson(),
    );
    return Mutation$ReportarSiniestro.fromJson(data).reportarSiniestro;
  }

  @override
  Future<Query$MisSiniestros> misSiniestros() async =>
      Query$MisSiniestros.fromJson(
        await _cliente.ejecutar(documentNodeQueryMisSiniestros),
      );

  @override
  Future<Query$MiSiniestro> miSiniestro(String id) async =>
      Query$MiSiniestro.fromJson(
        await _cliente.ejecutar(
          documentNodeQueryMiSiniestro,
          variables: Variables$Query$MiSiniestro(id: id).toJson(),
        ),
      );
}

/// Fake con las respuestas de `ReporteSiniestroFixtures` (`API_ENV=mock` y
/// pruebas). Como CLAIMS, reportar dos veces el mismo id devuelve el mismo caso.
final class FakeReporteSiniestroRemoteDataSource
    implements ReporteSiniestroRemoteDataSource {
  FakeReporteSiniestroRemoteDataSource({
    this.latencia = const Duration(milliseconds: 600),
  });

  final Duration latencia;
  final List<String> subidas = [];
  final List<Input$ReporteSiniestroInput> reportes = [];

  /// Para pruebas: el siguiente `reportar` lanza este error (red, 503…).
  Object? errorAlReportar;

  /// Para pruebas: el siguiente `reportar` responde con la regla rechazada.
  bool rechazar = false;

  /// Para pruebas: `misSiniestros` sin los casos de demostración.
  bool sinHistorial = false;

  /// Sin red: toda operación falla como en un teléfono sin señal (pruebas y
  /// la conexión simulada de `API_ENV=mock`).
  bool sinRed = false;

  final List<String> _mios = [];

  Future<void> _esperar() async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    if (sinRed) throw const ErrorRed(tipo: 'connectionError');
  }

  @override
  Future<Query$PolizasParaReporte> polizas() async {
    await _esperar();
    return Query$PolizasParaReporte.fromJson(ReporteSiniestroFixtures.polizas);
  }

  @override
  Future<
    Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro
  >
  solicitarSubida(
    String idReporte,
    String tipoContenido,
    int tamanoBytes,
  ) async {
    if (sinRed) throw const ErrorRed(tipo: 'connectionError');
    final id = 'arch-${subidas.length + 1}';
    subidas.add(id);
    return Mutation$SolicitarSubidaEvidenciaSiniestro.fromJson(
      ReporteSiniestroFixtures.subida(id),
    ).solicitarSubidaEvidenciaSiniestro;
  }

  @override
  Future<Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo> confirmar(
    String archivoId,
  ) async {
    if (sinRed) throw const ErrorRed(tipo: 'connectionError');
    return Mutation$ConfirmarSubidaEvidencia.fromJson(
      ReporteSiniestroFixtures.confirmada(archivoId),
    ).confirmarSubidaArchivo;
  }

  @override
  Future<Mutation$ReportarSiniestro$reportarSiniestro> reportar(
    Input$ReporteSiniestroInput entrada,
  ) async {
    await _esperar();
    final error = errorAlReportar;
    if (error != null) {
      errorAlReportar = null;
      throw error;
    }
    if (rechazar) {
      return Mutation$ReportarSiniestro.fromJson(
        ReporteSiniestroFixtures.rechazado,
      ).reportarSiniestro;
    }
    reportes.add(entrada);
    _mios.insert(0, entrada.idReporte);
    return Mutation$ReportarSiniestro.fromJson(
      ReporteSiniestroFixtures.reportado(
        entrada.idReporte,
        entrada.fotos.length,
      ),
    ).reportarSiniestro;
  }

  /// Los casos del fake; los reportados aquí llevan el tipo que mandó la app.
  List<Map<String, Object?>> _listado() {
    final tipos = {
      for (final r in reportes) r.idReporte: r.tipoSiniestroAuto?.toJson(),
    };
    return [
      for (final c
          in ReporteSiniestroFixtures.misSiniestros(
                nuevos: _mios,
                conDemo: !sinHistorial,
              )['misSiniestros']!
              as List<Object?>)
        if (c case final Map<String, Object?> caso)
          tipos.containsKey(caso['id'])
              ? {...caso, 'tipoSiniestroAuto': tipos[caso['id']]}
              : caso,
    ];
  }

  @override
  Future<Query$MisSiniestros> misSiniestros() async {
    await _esperar();
    return Query$MisSiniestros.fromJson({
      '__typename': 'Query',
      'misSiniestros': _listado(),
    });
  }

  /// Para pruebas: cuántas veces se pidió cada detalle.
  final Map<String, int> detallesPedidos = {};

  /// Para pruebas: el estado con el que llega el siguiente detalle de un caso
  /// (p. ej. `APROBADO` tras vencer el plazo).
  final Map<String, String> estadoForzado = {};

  /// Para pruebas: el siguiente detalle lanza este error.
  Object? errorAlDetallar;

  @override
  Future<Query$MiSiniestro> miSiniestro(String id) async {
    await _esperar();
    detallesPedidos[id] = (detallesPedidos[id] ?? 0) + 1;
    final error = errorAlDetallar;
    if (error != null) {
      errorAlDetallar = null;
      throw error;
    }
    final caso = _listado().where((c) => c['id'] == id).firstOrNull;
    return Query$MiSiniestro.fromJson(
      ReporteSiniestroFixtures.detalle(caso, estado: estadoForzado[id]),
    );
  }
}
