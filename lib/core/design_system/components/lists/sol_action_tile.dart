import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_spacing.dart';
import '../surfaces/sol_card.dart';

/// Tarjeta-acción con ícono, título 14/600 y chevron (G-03 «Solicitar
/// asistencia en sitio»).
class SolActionTile extends StatelessWidget {
  const SolActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SolCard(
      onTap: onTap,
      semanticLabel: title,
      child: ExcludeSemantics(
        child: Row(
          children: [
            Icon(icon, size: SolSpacing.xxl, color: colors.primary),
            const SizedBox(width: SolSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: context.solText.titleSmall.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
            const SizedBox(width: SolSpacing.sm),
            Icon(
              SolIcons.chevronRight,
              size: 20,
              opticalSize: 20,
              color: colors.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
