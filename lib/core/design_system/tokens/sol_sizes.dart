/// Medidas fijas en dp (Figma SG-01 · Estructura).
abstract final class SolSizes {
  /// Ancho de referencia del lienzo y mínimo soportado.
  static const double canvasWidth = 390;
  static const double minCanvasWidth = 360;

  /// Desde este ancho el contenido se centra con [maxContentWidth].
  static const double expandedBreakpoint = 600;
  static const double maxContentWidth = 600;

  static const double topBarHeight = 56;
  static const double bottomNavHeight = 80;
  static const double buttonHeight = 48;
  static const double minTouchTarget = 48;
  static const double divider = 1;

  static const double avatar = 32;
  static const double localeChipHeight = 32;
  static const double localeChipMinWidth = 96;
  static const double navIndicatorWidth = 64;
  static const double navIndicatorHeight = 32;
  static const double providerIcon = 40;
  static const double tonalSmallButtonHeight = 44;
  static const double checkbox = 20;
  static const double pinDot = 16;
  static const double keypadKeyHeight = 48;
  static const double icon = 24;
}
