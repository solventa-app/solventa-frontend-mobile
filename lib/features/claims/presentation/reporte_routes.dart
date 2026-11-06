/// Rutas de HU-M05 (reporte de siniestro). Sin frames en Figma: los ids siguen
/// la numeración del plano (M05-01 a M05-05).
abstract final class ReporteRoutes {
  static const poliza = '/siniestro';
  static const fotos = '/siniestro/fotos';
  static const relato = '/siniestro/relato';
  static const enviando = '/siniestro/enviando';
  static const resultado = '/siniestro/resultado';
  static const misSiniestros = '/siniestros';
}
