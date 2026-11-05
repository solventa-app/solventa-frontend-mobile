import '../../../../core/contrato/schema.graphql.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../graphql/reporte_siniestro.graphql.dart';

/// Pólizas emitidas de `propuestas`; las propuestas sin póliza se descartan.
List<PolizaReportable> polizasDesdeGql(Query$PolizasParaReporte q) => [
  for (final p in q.propuestas.propuestas)
    if (p.poliza case final poliza?)
      PolizaReportable(
        id: poliza.id,
        numero: poliza.numero,
        vigenciaDesde: poliza.vigenciaDesde,
        vigenciaHasta: poliza.vigenciaHasta,
      ),
];

SiniestroReportado siniestroDesdeGql(
  Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado s,
) => SiniestroReportado(
  id: s.id,
  radicado: s.radicado,
  estado: s.estado.name,
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
