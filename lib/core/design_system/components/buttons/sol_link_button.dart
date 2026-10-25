import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Tamaños del enlace.
enum SolLinkSize {
  /// 16/600, igual que el Botón «Texto» («Usar PIN en su lugar»).
  regular,

  /// 12/500 («Olvidé mi PIN o patrón» en M02-02).
  small,
}

/// Enlace de acción alterna («Abrir Ajustes», «Usar PIN en su lugar»).
///
/// Área táctil mínima de 48 dp. [note] añade una línea aclaratoria debajo.
class SolLinkButton extends StatelessWidget {
  const SolLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = SolLinkSize.regular,
    this.note,
    this.inline = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final SolLinkSize size;
  final String? note;

  /// Sin padding lateral y alineado al inicio, para que el texto del enlace
  /// quede a ras del contenido (p. ej. dentro de un banner). Mantiene 48 dp
  /// de alto táctil.
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = onPressed == null
        ? context.solColors.disabledContent
        : colors.secondary;
    final align = inline ? TextAlign.start : TextAlign.center;
    final labelStyle =
        (size == SolLinkSize.regular
                ? context.solText.button
                : context.solText.linkSmall)
            .copyWith(color: color);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: note == null ? label : '$label. $note',
      onTap: onPressed,
      excludeSemantics: true,
      child: InkWell(
        onTap: onPressed,
        customBorder: inline ? null : const StadiumBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: SolSizes.minTouchTarget,
            minWidth: SolSizes.minTouchTarget,
          ),
          child: Padding(
            padding: inline
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: SolSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: inline
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(label, textAlign: align, style: labelStyle),
                if (note != null)
                  Text(
                    note!,
                    textAlign: align,
                    style: labelStyle.copyWith(fontWeight: FontWeight.w400),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
