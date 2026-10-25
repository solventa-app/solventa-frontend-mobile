import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_spacing.dart';

/// Línea atenuada con ícono pequeño y texto 11/400 (G-03 «Billetera y
/// estado de póliza — próximamente», consejos de captura en M01-03).
class SolInlineNote extends StatelessWidget {
  const SolInlineNote({
    super.key,
    required this.text,
    this.icon,
    this.center = false,
    this.color,
    this.iconColor,
  });

  final String text;
  final IconData? icon;
  final bool center;

  /// Por defecto onSurfaceVariant.
  final Color? color;

  /// Color del ícono si debe diferir del texto (M01-03).
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.colors.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SolSpacing.sm),
      child: Row(
        mainAxisAlignment: center
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            ExcludeSemantics(
              child: Icon(
                icon,
                size: 16,
                opticalSize: 20,
                color: iconColor ?? c,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: context.solText.note.copyWith(color: c),
            ),
          ),
        ],
      ),
    );
  }
}
