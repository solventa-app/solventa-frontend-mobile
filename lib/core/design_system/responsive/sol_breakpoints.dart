import 'package:flutter/widgets.dart';

import '../tokens/sol_sizes.dart';

/// Clases de ventana que usa la app.
enum SolWindowSize {
  /// Teléfonos (360–599 dp). Base de diseño: 390 dp.
  compact,

  /// Plegables abiertos y tablets (≥ 600 dp): contenido centrado a 600 dp.
  expanded,
}

/// Puntos de corte responsive (base 390 dp, válido desde 360 dp).
abstract final class SolBreakpoints {
  static SolWindowSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= SolSizes.expandedBreakpoint
        ? SolWindowSize.expanded
        : SolWindowSize.compact;
  }
}

extension SolResponsiveX on BuildContext {
  SolWindowSize get windowSize => SolBreakpoints.of(this);
  bool get isExpandedWindow => windowSize == SolWindowSize.expanded;
}
