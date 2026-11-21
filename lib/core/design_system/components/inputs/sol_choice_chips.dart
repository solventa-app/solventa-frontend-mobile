import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Una opción de [SolChoiceChips].
@immutable
class SolChoice<T> {
  const SolChoice({required this.value, required this.label});

  final T value;
  final String label;
}

/// Chips de selección única para filtrar una lista (HU-M05, M05-06): se
/// desplazan en horizontal si no caben, la elegida lleva fondo `primary` y un
/// chulo (no solo color), y TalkBack la anuncia como seleccionada. Área táctil
/// de 48 dp.
class SolChoiceChips<T> extends StatelessWidget {
  const SolChoiceChips({
    super.key,
    required this.choices,
    required this.selected,
    required this.onSelected,
    this.semanticLabel,
  });

  final List<SolChoice<T>> choices;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Lo que lee TalkBack del grupo («Filtrar siniestros»).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final c in choices)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: SolSpacing.sm),
                child: ChoiceChip(
                  label: Text(c.label),
                  selected: c.value == selected,
                  onSelected: (_) => onSelected(c.value),
                  showCheckmark: true,
                  checkmarkColor: colors.onPrimary,
                  selectedColor: colors.primary,
                  backgroundColor: colors.surface,
                  labelStyle: context.solText.body.copyWith(
                    color: c.value == selected
                        ? colors.onPrimary
                        : colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: c.value == selected
                        ? colors.primary
                        : colors.outlineVariant,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: SolRadius.fullAll,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  visualDensity: VisualDensity.standard,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
