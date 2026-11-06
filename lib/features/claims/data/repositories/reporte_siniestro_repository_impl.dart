import '../../../../core/errors/falla.dart';
import '../../../../core/errors/guardar_fallas.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/network/subida_archivo_service.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../../domain/repositories/reporte_siniestro_repository.dart';
import '../datasources/reporte_siniestro_remote_datasource.dart';
import '../graphql/reporte_siniestro.graphql.dart';
import '../mappers/reporte_siniestro_mapper.dart';

final class ReporteSiniestroRepositoryImpl
    implements ReporteSiniestroRepository {
  ReporteSiniestroRepositoryImpl(this._remote, this._subida);

  final ReporteSiniestroRemoteDataSource _remote;
  final SubidaArchivoService _subida;

  /// Fotos ya subidas por reporte: un reintento no las vuelve a subir. Solo en
  /// memoria (ids opacos del almacenamiento, sin datos personales).
  final Map<String, Map<int, String>> _subidas = {};

  @override
  Future<Resultado<List<PolizaReportable>>> polizas() =>
      guardarFallas(() async => polizasDesdeGql(await _remote.polizas()));

  @override
  Future<Resultado<SiniestroReportado>> reportar(
    ReporteSiniestro reporte,
  ) async {
    // Las fallas técnicas (red, 503, contrato) las convierte `guardarFallas`;
    // un rechazo de negocio vuelve como valor para no perder su mensaje.
    final paso = await guardarFallas<Resultado<SiniestroReportado>>(() async {
      final fotos = await _subirFotos(reporte);
      if (fotos case Fracaso(:final falla)) return Fracaso(falla);
      final archivos = (fotos as Exito<List<String>>).valor;
      final r = await _remote.reportar(entradaReporte(reporte, archivos));
      return switch (r) {
        Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado() =>
          Exito(siniestroDesdeGql(r)),
        Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro(
          :final mensaje,
        ) =>
          Fracaso(FallaNegocio(mensaje)),
        _ => throw const FormatException('reportarSiniestro desconocido'),
      };
    });
    return switch (paso) {
      Exito(:final valor) => valor,
      Fracaso(:final falla) => Fracaso(falla),
    };
  }

  @override
  Future<Resultado<List<SiniestroReportado>>> misSiniestros() => guardarFallas(
    () async => (await _remote.misSiniestros()).misSiniestros
        .map(siniestroDesdeGql)
        .toList(),
  );

  Future<Resultado<List<String>>> _subirFotos(ReporteSiniestro reporte) async {
    final hechas = _subidas.putIfAbsent(reporte.idReporte, () => {});
    final ids = <String>[];
    for (final (i, foto) in reporte.fotos.indexed) {
      final ya = hechas[i];
      if (ya != null) {
        ids.add(ya);
        continue;
      }
      final subida = await _remote.solicitarSubida(
        reporte.idReporte,
        foto.tipoContenido,
        foto.bytes.length,
      );
      if (subida
          is! Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo) {
        final codigo =
            subida
                is Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo
            ? subida.codigo
            : motivoFotoNoConfirmada;
        return Fracaso(FallaNegocio(codigo));
      }
      await _subida.subir(
        url: subida.url,
        metodo: subida.metodo,
        encabezados: {for (final e in subida.encabezados) e.nombre: e.valor},
        bytes: foto.bytes,
      );
      final confirmada = await _remote.confirmar(subida.archivo.id);
      if (confirmada
          is! Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo) {
        return const Fracaso(FallaNegocio(motivoFotoNoConfirmada));
      }
      hechas[i] = subida.archivo.id;
      ids.add(subida.archivo.id);
    }
    return Exito(ids);
  }
}
