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
    final titulo = Semantics(
      header: true,
      child: Text(
        title,
        style: context.solText.title.copyWith(color: colors.onSurface),
      ),
    );
    final pildora = count == null
        ? null
        : Container(
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
          );
    // Con texto grande (≥ 150 %) la píldora baja de línea para que el título
    // no quede aplastado en una columna (HU-M06, hoja de M06-01 al 200 %).
    final apilar = MediaQuery.textScalerOf(context).scale(16) >= 24;
    return Padding(
      padding: const EdgeInsets.only(bottom: SolSpacing.sm),
      child: apilar && pildora != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titulo,
                const SizedBox(height: SolSpacing.xs),
                pildora,
              ],
            )
          : Row(
              children: [
                Expanded(child: titulo),
                if (pildora != null) ...[
                  const SizedBox(width: SolSpacing.sm),
                  pildora,
                ],
              ],
            ),
    );
  }
}
