/// Rutas de HU-M06 sobre la pestaña Asistencia (M06-01 vive en el shell).
abstract final class AsistenciaRoutes {
  static const solicitud = '/asistencia/solicitud';
  static const enviando = '/asistencia/enviando';
  static const resultado = '/asistencia/resultado';
  static const cancelada = '/asistencia/cancelada';

  /// Detalle de una asistencia de «Mis asistencias» (4.4), también al tocar
  /// la notificación de llegada (4.5).
  static const detalle = '/asistencias';
  static String detalleCon(String id) => '$detalle/$id';
}
