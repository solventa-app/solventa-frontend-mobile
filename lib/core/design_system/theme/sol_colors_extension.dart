import 'package:flutter/material.dart';

import '../tokens/sol_colors.dart';

/// Roles de color que M3 no trae (success, warning y apoyos de marca).
@immutable
class SolventaColors extends ThemeExtension<SolventaColors> {
  const SolventaColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.navIndicator,
    required this.localeChipBorder,
    required this.disabledContainer,
    required this.disabledContent,
    required this.cameraViewport,
    required this.sheetHandle,
    required this.softShadow,
  });

  /// Valores del Figma SG-01.
  static const SolventaColors light = SolventaColors(
    success: SolColors.success,
    onSuccess: Colors.white,
    successContainer: SolColors.successContainer,
    warning: SolColors.warning,
    onWarning: Colors.white,
    warningContainer: SolColors.warningContainer,
    navIndicator: SolColors.indicator,
    localeChipBorder: SolColors.indicator,
    disabledContainer: SolColors.disabledContainer,
    disabledContent: SolColors.disabledContent,
    cameraViewport: SolColors.cameraViewport,
    sheetHandle: SolColors.sheetHandle,
    softShadow: SolColors.softShadow,
  );

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color navIndicator;
  final Color localeChipBorder;
  final Color disabledContainer;
  final Color disabledContent;
  final Color cameraViewport;
  final Color sheetHandle;
  final Color softShadow;

  @override
  SolventaColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? navIndicator,
    Color? localeChipBorder,
    Color? disabledContainer,
    Color? disabledContent,
    Color? cameraViewport,
    Color? sheetHandle,
    Color? softShadow,
  }) {
    return SolventaColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      navIndicator: navIndicator ?? this.navIndicator,
      localeChipBorder: localeChipBorder ?? this.localeChipBorder,
      disabledContainer: disabledContainer ?? this.disabledContainer,
      disabledContent: disabledContent ?? this.disabledContent,
      cameraViewport: cameraViewport ?? this.cameraViewport,
      sheetHandle: sheetHandle ?? this.sheetHandle,
      softShadow: softShadow ?? this.softShadow,
    );
  }

  @override
  SolventaColors lerp(ThemeExtension<SolventaColors>? other, double t) {
    if (other is! SolventaColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SolventaColors(
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      successContainer: l(successContainer, other.successContainer),
      warning: l(warning, other.warning),
      onWarning: l(onWarning, other.onWarning),
      warningContainer: l(warningContainer, other.warningContainer),
      navIndicator: l(navIndicator, other.navIndicator),
      localeChipBorder: l(localeChipBorder, other.localeChipBorder),
      disabledContainer: l(disabledContainer, other.disabledContainer),
      disabledContent: l(disabledContent, other.disabledContent),
      cameraViewport: l(cameraViewport, other.cameraViewport),
      sheetHandle: l(sheetHandle, other.sheetHandle),
      softShadow: l(softShadow, other.softShadow),
    );
  }
}
