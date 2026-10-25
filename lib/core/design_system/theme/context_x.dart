import 'package:flutter/material.dart';

import '../tokens/sol_typography.dart';
import 'sol_colors_extension.dart';

/// Atajos de tema para las features.
extension SolContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Colores propios de Solventa (success, warning, …).
  SolventaColors get solColors =>
      Theme.of(this).extension<SolventaColors>() ?? SolventaColors.light;

  /// Estilos de texto con nombre de Solventa.
  SolTextStyles get solText => SolTextStyles(Theme.of(this).textTheme);
}

/// Estilos con nombre semántico, derivados del [TextTheme] activo.
class SolTextStyles {
  const SolTextStyles(this._t);

  final TextTheme _t;

  TextStyle get headline => _t.headlineSmall!;
  TextStyle get wordmark => _t.titleLarge!;
  TextStyle get title => _t.titleMedium!;
  TextStyle get titleSmall => _t.titleSmall!;
  TextStyle get body => _t.bodyMedium!;
  TextStyle get button => _t.labelLarge!;
  TextStyle get linkSmall => _t.labelMedium!;
  TextStyle get labelStrong => _t.labelSmall!;

  /// 11/400 · notas y anotaciones.
  TextStyle get note =>
      _t.labelSmall!.copyWith(fontWeight: SolTypography.note.fontWeight);
}
