import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Encabezado de sección 16/600 con contador opcional («3 disponibles»).
class SolSectionHeader extends StatelessWidget {
  const SolSectionHeader({super.key, required this.title, this.count});

  final String title;

  /// Texto de la píldora a la derecha, p. ej. «3 disponibles».
  final String? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: SolSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: context.solText.title.copyWith(color: colors.onSurface),
              ),
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: SolSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SolSpacing.sm,
                vertical: SolSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: SolRadius.fullAll,
              ),
              // onSurface en vez del #6E6E6E del Figma para cumplir AA.
              child: Text(
                count!,
                style: context.solText.note.copyWith(color: colors.onSurface),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
