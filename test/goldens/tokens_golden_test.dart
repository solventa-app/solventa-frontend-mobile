@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import 'golden_helpers.dart';

/// Paleta y escala tipográfica del tema (guía SG-01, 2019:331).
void main() {
  solGoldenMatrix('theme_palette_typography', () {
    return Builder(
      builder: (context) {
        final c = context.colors;
        final s = context.solColors;
        final t = context.solText;
        final swatches = <String, (Color, Color)>{
          'primary #1E4680': (c.primary, c.onPrimary),
          'secondary #2B5AA3': (c.secondary, c.onSecondary),
          'secondaryContainer #EEEDF3': (
            c.secondaryContainer,
            c.onSecondaryContainer,
          ),
          'primaryContainer #EBF1FA': (
            c.primaryContainer,
            c.onPrimaryContainer,
          ),
          'Indicador activo #D7E2FF': (s.navIndicator, c.primary),
          'surface #FFFFFF': (c.surface, c.onSurfaceVariant),
          'surfaceContainer #F5F5F5': (c.surfaceContainer, c.onSurfaceVariant),
          'outline #D9D9D9': (c.outline, c.onSurface),
          'onSurface #333333': (c.onSurface, c.surface),
          'onSurfaceVariant #6E6E6E': (c.onSurfaceVariant, c.surface),
          'success #2E7C56 / #E8F6F1': (s.successContainer, s.success),
          'warning #8D651E / #FDF1E4': (s.warningContainer, s.warning),
          'error #994D4D / #FDECEC': (c.errorContainer, c.error),
        };
        return GoldenSheet(
          cases: {
            'Paleta · roles Material 3': Column(
              children: [
                for (final e in swatches.entries)
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: e.value.$1,
                      borderRadius: SolRadius.fieldAll,
                      border: Border.all(color: c.outline),
                    ),
                    child: Text(
                      e.key,
                      style: t.labelStrong.copyWith(color: e.value.$2),
                    ),
                  ),
              ],
            ),
            'headlineSmall · 24/600': Text('Hola, María', style: t.headline),
            'Wordmark · 20/700': Text(
              'Solventa',
              style: t.wordmark.copyWith(color: c.secondary),
            ),
            'titleMedium · 16/600': Text(
              'Autorización de datos',
              style: t.title,
            ),
            'bodyMedium · 14/400': Text(
              'Clínica Norte está en camino, llegada estimada en 6 minutos.',
              style: t.body,
            ),
            'labelSmall · 11/600': Text('ES · COP', style: t.labelStrong),
            'labelSmall · 11/400': Text(
              '(se resuelve en Ajustes del teléfono)',
              style: t.note,
            ),
            'Formato es-CO': Text(
              '${SolFormat.currency(450000)} · '
              '${SolFormat.dateTime(DateTime(2026, 9, 12, 11, 2))} · '
              '${SolFormat.maskedAccount('99994821')}',
              style: t.body,
            ),
          },
        );
      },
    );
  });
}
