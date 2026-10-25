import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Píldora «ES · COP» de idioma y moneda (Figma 2018:3).
///
/// Siempre visible arriba a la derecha. 32 dp de alto visual y 48 dp de
/// área táctil.
class SolLocaleChip extends StatelessWidget {
  const SolLocaleChip({
    super.key,
    this.label = 'ES · COP',
    this.semanticLabel = 'Idioma español, moneda pesos colombianos',
    this.onTap,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final pill = Container(
      constraints: const BoxConstraints(
        minHeight: SolSizes.localeChipHeight,
        minWidth: SolSizes.localeChipMinWidth,
      ),
      padding: const EdgeInsets.symmetric(horizontal: SolSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: SolRadius.fullAll,
        border: Border.all(color: sol.localeChipBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            SolIcons.language,
            size: 18,
            opticalSize: 20,
            color: colors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            maxLines: 1,
            style: context.solText.labelStrong.copyWith(
              color: colors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      hint: onTap != null ? 'Cambiar idioma y moneda' : null,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: SolRadius.fullAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SolSizes.minTouchTarget),
          child: Center(widthFactor: 1, child: pill),
        ),
      ),
    );
  }
}
