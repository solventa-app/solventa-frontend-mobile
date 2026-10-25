import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_sizes.dart';

/// Avatar circular de perfil («Mi perfil», 32 dp, fondo primario).
///
/// Con [onTap] el área táctil crece a 48 × 48 dp sin cambiar el dibujo.
class SolAvatar extends StatelessWidget {
  const SolAvatar({
    super.key,
    this.initials,
    this.size = SolSizes.avatar,
    this.onTap,
    this.semanticLabel = 'Mi perfil',
  });

  /// Iniciales opcionales; sin ellas se dibuja el ícono de persona.
  final String? initials;
  final double size;
  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Widget glyph = initials == null
        ? Icon(SolIcons.profile, size: size * 0.56, color: colors.onPrimary)
        : MediaQuery.withNoTextScaling(
            child: Text(
              initials!,
              style: context.solText.labelStrong.copyWith(
                color: colors.onPrimary,
                fontSize: size * 0.4,
              ),
            ),
          );
    final circle = SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(child: glyph),
      ),
    );
    if (onTap == null) {
      return Semantics(
        label: semanticLabel,
        image: true,
        excludeSemantics: true,
        child: circle,
      );
    }
    final target = size < SolSizes.minTouchTarget
        ? SolSizes.minTouchTarget
        : size;
    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: target / 2,
        child: SizedBox.square(
          dimension: target,
          child: Center(child: circle),
        ),
      ),
    );
  }
}
