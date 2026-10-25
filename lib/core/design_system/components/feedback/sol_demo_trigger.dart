import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Disparador de demo (Figma 2018:17).
///
/// Andamiaje de la demo, no producto: lleva a un desenlace alterno. Va en
/// color de anotación, nunca como botón, y solo existe en builds de debug.
class SolDemoTrigger extends StatelessWidget {
  const SolDemoTrigger({
    super.key,
    required this.label,
    required this.onTap,
    this.forceVisible = false,
  });

  final String label;
  final VoidCallback onTap;

  /// Solo para la galería y los tests; en release nunca se muestra.
  @visibleForTesting
  final bool forceVisible;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode && !forceVisible) return const SizedBox.shrink();
    final style = context.solText.note.copyWith(
      color: context.solColors.warning,
    );
    return Semantics(
      button: true,
      label: 'Demo: $label',
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SolSizes.minTouchTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: SolSpacing.xs),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: 1,
              child: Text('$label →', style: style),
            ),
          ),
        ),
      ),
    );
  }
}
