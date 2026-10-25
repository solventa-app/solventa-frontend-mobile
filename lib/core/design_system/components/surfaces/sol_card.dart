import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Estilo de la tarjeta.
enum SolCardStyle {
  /// Sombra suave 0 1 1 rgba(0,0,0,.05), sin borde (G-03, M01-07, M06-02).
  /// Estilo por defecto.
  elevated,

  /// Variante con borde de 1 dp `outline` (guía SG-01).
  outlined,
}

/// Superficie blanca de 12 dp, elevada por defecto. Con [onTap] es un
/// objetivo táctil ≥ 48 dp.
class SolCard extends StatelessWidget {
  const SolCard({
    super.key,
    required this.child,
    this.style = SolCardStyle.elevated,
    this.padding = const EdgeInsets.all(SolSpacing.lg),
    this.onTap,
    this.semanticLabel,
  });

  /// Variante delineada (borde de 1 dp, sin sombra).
  const SolCard.outlined({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(SolSpacing.lg),
    this.onTap,
    this.semanticLabel,
  }) : style = SolCardStyle.outlined;

  final Widget child;
  final SolCardStyle style;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final outlined = style == SolCardStyle.outlined;
    final decoration = BoxDecoration(
      color: colors.surface,
      borderRadius: SolRadius.cardAll,
      border: outlined ? Border.all(color: colors.outline) : null,
      boxShadow: outlined
          ? null
          : [
              BoxShadow(
                color: context.solColors.softShadow,
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
    );
    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: SolRadius.cardAll,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SolSizes.minTouchTarget,
            ),
            child: content,
          ),
        ),
      );
    }
    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel,
      child: DecoratedBox(decoration: decoration, child: content),
    );
  }
}
