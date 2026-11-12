import '../../../../core/contrato/schema.graphql.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../graphql/reporte_siniestro.graphql.dart';

/// Pólizas de **auto** emitidas de `propuestas`. Reportar un siniestro es de la póliza del vehículo: la de vida del
/// crédito hipotecario no se ofrece. Las propuestas sin póliza se descartan.
List<PolizaReportable> polizasDesdeGql(Query$PolizasParaReporte q) => [
  for (final p in q.propuestas.propuestas)
    if (p.poliza case final poliza? when poliza.producto == Enum$Producto.AUTO)
      PolizaReportable(
        id: poliza.id,
        numero: poliza.numero,
        vigenciaDesde: poliza.vigenciaDesde,
        vigenciaHasta: poliza.vigenciaHasta,
        esAuto: poliza.producto == Enum$Producto.AUTO,
        vehiculo: switch (poliza.vehiculo) {
          final v? => '${v.marca} ${v.placaEnmascarada}',
          null => null,
        },
      ),
];

SiniestroReportado siniestroDesdeGql(Fragment$SiniestroReportadoCampos s) =>
    SiniestroReportado(
      id: s.id,
      radicado: s.radicado,
      estado: s.estado.name,
      notificadoEn: s.notificadoEn,
      venceDictamenEn: s.venceDictamenEn,
      fotos: s.fotos,
    );

/// La entrada del contrato. [archivos] son los ids ya subidos, en el mismo
/// orden que `reporte.fotos`.
Input$ReporteSiniestroInput entradaReporte(
  ReporteSiniestro reporte,
  List<String> archivos,
) => Input$ReporteSiniestroInput(
  idReporte: reporte.idReporte,
  polizaId: reporte.poliza.id,
  tipoSiniestroAuto: switch (reporte.tipoAuto) {
    final tipo? => Enum$TipoSiniestroAuto.fromJson(tipo.codigo),
    null => null,
  },
  ocurridoEn: reporte.ocurridoEn.toUtc(),
  descripcion: reporte.descripcion.trim(),
  ubicacion: Input$UbicacionReporteInput(
    descripcion: reporte.lugar.trim(),
    ciudad: reporte.ciudad.trim(),
    latitud: reporte.ubicacion.latitud,
    longitud: reporte.ubicacion.longitud,
  ),
  fotos: [
    for (final (i, foto) in reporte.fotos.indexed)
      Input$FotoReporteInput(
        archivoId: archivos[i],
        tomadaEn: foto.tomadaEn.toUtc(),
        latitud: foto.ubicacion?.latitud,
        longitud: foto.ubicacion?.longitud,
      ),
  ],
);
