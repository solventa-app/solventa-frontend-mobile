/// Rutas de HU-M02 (ingreso con biometría). El nombre es el id del plano de
/// Figma. Sin M02-02 ni M02-02b: el PIN es el del teléfono (decisión D2).
abstract final class AccesoRoutes {
  /// M02-01 y su estado M02-01a (no reconocida).
  static const desbloqueo = '/acceso/desbloqueo';

  /// M02-03, transitoria: avanza sola al Home.
  static const concedido = '/acceso/concedido';
}
