import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// Relación de contraste WCAG 2.x entre dos colores opacos.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  final scheme = SolTheme.colorScheme;
  const sol = SolventaColors.light;

  // Pares de texto sobre fondo usados por la librería. Todos son texto
  // normal (< 18 sp), así que el mínimo AA es 4.5:1.
  final pairs = <String, (Color, Color)>{
    'onSurface / surface': (scheme.onSurface, scheme.surface),
    'onSurface / surfaceContainer': (scheme.onSurface, scheme.surfaceContainer),
    'onSurfaceVariant / surface': (scheme.onSurfaceVariant, scheme.surface),
    'onSurfaceVariant / surfaceContainer': (
      scheme.onSurfaceVariant,
      scheme.surfaceContainer,
    ),
    // El chip «3 disponibles» de M06-01 usa #6E6E6E sobre #EEEDF3 (4.3:1,
    // no cumple AA); la librería usa onSurface.
    'onSurface / secondaryContainer': (
      scheme.onSurface,
      scheme.secondaryContainer,
    ),
    'onPrimary / primary': (scheme.onPrimary, scheme.primary),
    'onSecondaryContainer / secondaryContainer': (
      scheme.onSecondaryContainer,
      scheme.secondaryContainer,
    ),
    'onPrimaryContainer / primaryContainer': (
      scheme.onPrimaryContainer,
      scheme.primaryContainer,
    ),
    'primary / navIndicator': (scheme.primary, sol.navIndicator),
    'primary / surface': (scheme.primary, scheme.surface),
    'secondary / surface': (scheme.secondary, scheme.surface),
    'secondary / surfaceContainer': (scheme.secondary, scheme.surfaceContainer),
    'onError / error': (scheme.onError, scheme.error),
    'error / errorContainer': (scheme.error, scheme.errorContainer),
    'error / surface': (scheme.error, scheme.surface),
    'success / successContainer': (sol.success, sol.successContainer),
    'success / surface': (sol.success, scheme.surface),
    'warning / warningContainer': (sol.warning, sol.warningContainer),
    'warning / surface': (sol.warning, scheme.surface),
    'warning / surfaceContainer': (sol.warning, scheme.surfaceContainer),
    'white / cameraViewport': (Colors.white, sol.cameraViewport),
  };

  group('Contraste AA (≥ 4.5:1) de los pares del tema', () {
    for (final entry in pairs.entries) {
      test(entry.key, () {
        final (fg, bg) = entry.value;
        final ratio = contrastRatio(fg, bg);
        expect(
          ratio,
          greaterThanOrEqualTo(4.5),
          reason: '${entry.key} = ${ratio.toStringAsFixed(2)}:1',
        );
      });
    }
  });

  test('Los componentes no textuales (íconos de estado) llegan a 3:1', () {
    expect(contrastRatio(scheme.primary, sol.navIndicator), greaterThan(3));
    expect(contrastRatio(sol.success, sol.successContainer), greaterThan(3));
    expect(contrastRatio(scheme.primary, scheme.outline), greaterThan(3));
  });

  test('El deshabilitado queda fuera de AA por norma (WCAG 1.4.3)', () {
    // Se documenta el valor para que el diseñador lo vea en el reporte.
    final ratio = contrastRatio(sol.disabledContent, sol.disabledContainer);
    expect(ratio, greaterThan(3));
  });

  test('El tema usa los overrides exactos del Figma', () {
    final theme = SolTheme.light();
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, const Color(0xFF1E4680));
    expect(theme.colorScheme.secondary, const Color(0xFF2B5AA3));
    expect(theme.colorScheme.secondaryContainer, const Color(0xFFEEEDF3));
    expect(theme.colorScheme.primaryContainer, const Color(0xFFEBF1FA));
    expect(theme.colorScheme.surface, const Color(0xFFFFFFFF));
    expect(theme.colorScheme.surfaceContainer, const Color(0xFFF5F5F5));
    expect(theme.colorScheme.outline, const Color(0xFFD9D9D9));
    expect(theme.colorScheme.onSurface, const Color(0xFF333333));
    expect(theme.colorScheme.onSurfaceVariant, const Color(0xFF6E6E6E));
    expect(theme.colorScheme.error, const Color(0xFF994D4D));
    expect(theme.colorScheme.errorContainer, const Color(0xFFFDECEC));
    expect(theme.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    final ext = theme.extension<SolventaColors>()!;
    expect(ext.success, const Color(0xFF2E7C56));
    expect(ext.warningContainer, const Color(0xFFFDF1E4));
    expect(ext.navIndicator, const Color(0xFFD7E2FF));
  });

  test('La escala tipográfica usa Inter con los tamaños y pesos del Figma', () {
    final t = SolTheme.light().textTheme;
    expect(t.headlineSmall!.fontFamily, 'Inter');
    expect(t.headlineSmall!.fontSize, 24);
    expect(t.headlineSmall!.fontWeight, FontWeight.w600);
    expect(t.titleLarge!.fontSize, 20);
    expect(t.titleLarge!.fontWeight, FontWeight.w700);
    expect(t.titleMedium!.fontSize, 16);
    expect(t.titleMedium!.fontWeight, FontWeight.w600);
    expect(t.bodyMedium!.fontSize, 14);
    expect(t.bodyMedium!.fontWeight, FontWeight.w400);
    expect(t.labelSmall!.fontSize, 11);
    expect(t.labelSmall!.fontWeight, FontWeight.w600);
    expect(SolTypography.note.fontWeight, FontWeight.w400);
  });

  test('SolventaColors interpola y copia', () {
    const a = SolventaColors.light;
    final b = a.copyWith(success: Colors.black);
    expect(b.success, Colors.black);
    expect(a.lerp(b, 0).success, a.success);
    expect(a.lerp(null, 0.5), a);
  });
}
