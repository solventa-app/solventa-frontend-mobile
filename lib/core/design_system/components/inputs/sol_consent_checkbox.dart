import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Casilla de consentimiento (Habeas Data, M01-02): checkbox M3 de 20 dp
/// y texto legal; toda la fila es el área táctil (≥ 48 dp).
class SolConsentCheckbox extends StatelessWidget {
  const SolConsentCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onChanged != null;
    final duration = SolMotion.of(context, SolMotion.short);
    final box = AnimatedContainer(
      duration: duration,
      width: SolSizes.checkbox,
      height: SolSizes.checkbox,
      decoration: BoxDecoration(
        color: value ? colors.primary : colors.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(SolRadius.checkbox),
        ),
        border: value
            ? null
            : Border.all(color: colors.onSurfaceVariant, width: 2),
      ),
      child: value
          ? Icon(SolIcons.check, size: 16, weight: 700, color: colors.onPrimary)
          : null,
    );
    return Semantics(
      checked: value,
      enabled: enabled,
      label: label,
      onTap: enabled ? () => onChanged!(!value) : null,
      excludeSemantics: true,
      child: InkWell(
        onTap: enabled ? () => onChanged!(!value) : null,
        borderRadius: SolRadius.fieldAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SolSizes.minTouchTarget),
          child: Row(
            children: [
              // Figma: casilla a 9 dp del borde y texto a 50 dp.
              SizedBox(
                width: 42,
                height: SolSizes.minTouchTarget,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 9),
                    child: box,
                  ),
                ),
              ),
              const SizedBox(width: SolSpacing.sm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: SolSpacing.xs),
                  child: Text(
                    label,
                    style: context.solText.body.copyWith(
                      color: enabled
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
