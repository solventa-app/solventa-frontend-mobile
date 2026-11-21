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

ResolucionSiniestro _resolucion({
  required String tipo,
  required DateTime resueltaEn,
  String? motivo,
  String? viaRecurso,
  String? valor,
  String? plazoDispersion,
}) => ResolucionSiniestro(
  tipo: tipo,
  resueltaEn: resueltaEn,
  motivo: motivo,
  viaRecurso: viaRecurso,
  indemnizacion: valor == null ? null : num.tryParse(valor),
  plazoDispersion: plazoDispersion,
);

TipoSiniestroAuto? _tipoAuto(Enum$TipoSiniestroAuto? tipo) => switch (tipo) {
  null || Enum$TipoSiniestroAuto.$unknown => null,
  final t =>
    TipoSiniestroAuto.values.where((v) => v.codigo == t.toJson()).firstOrNull,
};

/// v0.54: el detalle de `miSiniestro`; `null` si no es del cliente.
DetalleSiniestro? detalleDesdeGql(Query$MiSiniestro q) {
  final s = q.miSiniestro;
  if (s == null) return null;
  final vehiculo = s.poliza.vehiculo;
  return DetalleSiniestro(
    id: s.id,
    radicado: s.radicado,
    estado: s.estado.name,
    ocurridoEn: s.ocurridoEn,
    notificadoEn: s.notificadoEn,
    venceDictamenEn: s.venceDictamenEn,
    descripcion: s.descripcion,
    lugar: s.ubicacion.descripcion,
    ciudad: s.ubicacion.ciudad,
    poliza: PolizaDelCaso(
      numero: s.poliza.numero,
      esAuto: s.poliza.producto == Enum$Producto.AUTO,
      vehiculo: vehiculo == null
          ? null
          : '${vehiculo.marca} ${vehiculo.linea} · ${vehiculo.placaEnmascarada}',
    ),
    fotos: [
      for (final f in s.fotos)
        FotoDelCaso(id: f.id, url: f.url, registradaEn: f.registradaEn),
    ],
    historial: [
      for (final h in s.historial) HitoDelCaso(estado: h.estado.name, en: h.en),
    ],
    apruebaAlVencer: s.apruebaAlVencer,
    tipoAuto: _tipoAuto(s.tipoSiniestroAuto),
    resolucion: switch (s.resolucion) {
      final r? => _resolucion(
        tipo: r.tipo.name,
        resueltaEn: r.resueltaEn,
        motivo: r.motivo?.name,
        viaRecurso: r.viaRecurso,
        valor: r.indemnizacion?.valor,
        plazoDispersion: r.plazoDispersion,
      ),
      null => null,
    },
  );
}

SiniestroReportado siniestroDesdeGql(Fragment$SiniestroReportadoCampos s) =>
    SiniestroReportado(
      id: s.id,
      radicado: s.radicado,
      estado: s.estado.name,
      notificadoEn: s.notificadoEn,
      venceDictamenEn: s.venceDictamenEn,
      fotos: s.fotos,
      ocurridoEn: s.ocurridoEn,
      polizaId: s.polizaId,
      tipoAuto: _tipoAuto(s.tipoSiniestroAuto),
      resolucion: switch (s.resolucion) {
        final r? => ResolucionSiniestro(
          tipo: r.tipo.name,
          resueltaEn: r.resueltaEn,
          motivo: r.motivo?.name,
          viaRecurso: r.viaRecurso,
          indemnizacion: switch (r.indemnizacion) {
            final m? => num.tryParse(m.valor),
            null => null,
          },
          plazoDispersion: r.plazoDispersion,
        ),
        null => null,
      },
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
