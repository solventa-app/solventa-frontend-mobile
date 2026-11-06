import '../../../../core/contrato/schema.graphql.dart';
import '../../../../core/network/graphql_client.dart';
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

  final List<String> _mios = [];

  Future<void> _esperar() async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
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
    final id = 'arch-${subidas.length + 1}';
    subidas.add(id);
    return Mutation$SolicitarSubidaEvidenciaSiniestro.fromJson(
      ReporteSiniestroFixtures.subida(id),
    ).solicitarSubidaEvidenciaSiniestro;
  }

  @override
  Future<Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo> confirmar(
    String archivoId,
  ) async => Mutation$ConfirmarSubidaEvidencia.fromJson(
    ReporteSiniestroFixtures.confirmada(archivoId),
  ).confirmarSubidaArchivo;

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

  @override
  Future<Query$MisSiniestros> misSiniestros() async {
    await _esperar();
    return Query$MisSiniestros.fromJson(
      ReporteSiniestroFixtures.misSiniestros(
        nuevos: _mios,
        conDemo: !sinHistorial,
      ),
    );
  }
}
