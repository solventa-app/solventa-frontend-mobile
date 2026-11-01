import 'package:flutter/material.dart';

import '../../tokens/sol_spacing.dart';

/// Par de acciones lado a lado («Repetir» / «Capturar» en M01-03).
///
/// Con texto grande (`scale(16) >= 24`, ~150 %) se apilan en columna, con la
/// primaria primero y 8 dp entre ambas, para no partir palabras.
class SolButtonPair extends StatelessWidget {
  const SolButtonPair({
    super.key,
    required this.primary,
    required this.secondary,
  });

  /// Acción principal: a la derecha en fila, arriba al apilar.
  final Widget primary;

  /// Acción secundaria: a la izquierda en fila, abajo al apilar.
  final Widget secondary;

  @override
  Widget build(BuildContext context) {
    final stacked = MediaQuery.textScalerOf(context).scale(16) >= 24;
    if (stacked) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          primary,
          const SizedBox(height: SolSpacing.sm),
          secondary,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: secondary),
        const SizedBox(width: SolSpacing.lg),
        Expanded(child: primary),
      ],
    );
  }
}
