/// Rutas de HU-M04 (cobertura e indemnización paramétrica).
///
/// `m04-02` también llega por el push `indemnizacion-liquidada` (contrato
/// `evento.parametrico.recibido`, ruta `/m04-02/{id}` del backend): el
/// guardia de sesión en `router.dart` la deja pendiente si no hay sesión y la
/// reanuda después del login (M04-D2 no aplica a la llegada por push).
abstract final class ParametricRoutes {
  static const celebracion = '/m04-02';
  static const detalle = '/m04-03';
  static const cobertura = '/m04-04';

  static String celebracionCon(String id) => '$celebracion/$id';
  static String detalleCon(String id) => '$detalle/$id';
}
