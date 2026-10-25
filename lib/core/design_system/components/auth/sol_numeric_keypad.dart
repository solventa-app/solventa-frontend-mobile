import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Teclado numérico del PIN (M02-02): 3 columnas, teclas de 48 dp con
/// radio de 8 dp sobre #EEEDF3 y tecla «Borrar dígito».
class SolNumericKeypad extends StatelessWidget {
  const SolNumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.enabled = true,
  });

  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Widget digit(int d) => _Key(
      semanticLabel: '$d',
      onTap: enabled ? () => onDigit(d) : null,
      child: Text(
        '$d',
        style: context.solText.wordmark.copyWith(
          fontWeight: FontWeight.w600,
          height: 1,
          color: context.colors.onSurface,
        ),
      ),
    );

    Widget row(List<Widget> keys) => Row(
      children: [
        for (var i = 0; i < keys.length; i++) ...[
          if (i > 0) const SizedBox(width: SolSpacing.md),
          Expanded(child: keys[i]),
        ],
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SolSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          row([digit(1), digit(2), digit(3)]),
          const SizedBox(height: SolSpacing.md),
          row([digit(4), digit(5), digit(6)]),
          const SizedBox(height: SolSpacing.md),
          row([digit(7), digit(8), digit(9)]),
          const SizedBox(height: SolSpacing.md),
          row([
            const SizedBox.shrink(),
            digit(0),
            _Key(
              semanticLabel: 'Borrar dígito',
              onTap: enabled ? onBackspace : null,
              child: Icon(
                SolIcons.backspace,
                size: SolSizes.icon,
                color: context.colors.onSurface,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final String semanticLabel;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: SolRadius.fieldAll,
          boxShadow: [
            BoxShadow(
              color: context.solColors.softShadow,
              offset: const Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: Material(
          color: context.colors.secondaryContainer,
          borderRadius: SolRadius.fieldAll,
          child: InkWell(
            borderRadius: SolRadius.fieldAll,
            onTap: onTap == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onTap!();
                  },
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: SolSizes.keypadKeyHeight,
              ),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
