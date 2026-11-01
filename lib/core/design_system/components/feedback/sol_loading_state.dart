import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_spacing.dart';

/// Carga: indicador circular + texto de lo que está pasando (M01-06).
///
/// Se anuncia a TalkBack (liveRegion). Con «quitar animaciones» el
/// indicador queda quieto.
class SolLoadingState extends StatelessWidget {
  const SolLoadingState({
    super.key,
    required this.message,
    this.center = false,
  });

  /// Qué está pasando, p. ej. «Validando con el proveedor KYC/AML...».
  final String message;

  /// Centrado (por defecto alineado al inicio, como en M01-06).
  final bool center;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduce = SolMotion.reduced(context);
    return Semantics(
      liveRegion: true,
      label: message,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 48,
            child: Center(
              child: SizedBox.square(
                dimension: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  value: reduce ? 0.25 : null,
                  color: colors.primary,
                  backgroundColor: colors.outline,
                ),
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          Text(
            message,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: context.solText.body.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
