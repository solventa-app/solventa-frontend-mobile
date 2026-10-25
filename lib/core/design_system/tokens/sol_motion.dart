import 'package:flutter/widgets.dart';

/// Duraciones y curvas. Respeta «reducir animaciones» del sistema.
abstract final class SolMotion {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Curve standard = Curves.easeInOutCubicEmphasized;

  /// Devuelve [Duration.zero] si el sistema pide reducir animaciones.
  static Duration of(BuildContext context, Duration duration) {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return reduce ? Duration.zero : duration;
  }

  /// `true` si el usuario activó «quitar animaciones».
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}
