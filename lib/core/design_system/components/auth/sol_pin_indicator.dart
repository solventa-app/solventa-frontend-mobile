import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Indicador de PIN (M02-02): puntos de 16 dp, gris vacío y primario lleno.
/// Anuncia cuántos dígitos se han ingresado.
class SolPinIndicator extends StatelessWidget {
  const SolPinIndicator({super.key, required this.filled, this.length = 4});

  final int filled;
  final int length;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = SolMotion.of(context, SolMotion.short);
    return Semantics(
      liveRegion: true,
      label: 'PIN: $filled de $length dígitos ingresados',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < length; i++) ...[
            if (i > 0) const SizedBox(width: SolSpacing.lg),
            AnimatedContainer(
              duration: duration,
              width: SolSizes.pinDot,
              height: SolSizes.pinDot,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled ? colors.primary : colors.outline,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
