import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';

/// Anillo de avance con el porcentaje al centro (HU-M05, M05-04): el envío de
/// un reporte, por bytes subidos. [value] va de 0 a 1 y [label] es el texto
/// del centro («58 %»). TalkBack lee [semanticLabel] cuando cambia.
class SolProgressRing extends StatelessWidget {
  const SolProgressRing({
    super.key,
    required this.value,
    required this.label,
    required this.semanticLabel,
    this.size = 144,
  });

  final double value;
  final String label;
  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      liveRegion: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: value.clamp(0, 1).toDouble(),
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  color: colors.primary,
                  backgroundColor: colors.surfaceContainerHighest,
                ),
              ),
              // El porcentaje no crece con la letra del sistema: vive dentro
              // del anillo. El mismo dato va en el texto de abajo.
              Text(
                label,
                textScaler: TextScaler.noScaling,
                style: context.solText.headline.copyWith(
                  fontSize: size / 4,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barra de avance delgada (el envío de un reporte en una fila de lista).
class SolProgressBar extends StatelessWidget {
  const SolProgressBar({super.key, required this.value});

  /// De 0 a 1.
  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: SolRadius.fieldAll,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1).toDouble(),
          minHeight: 6,
          color: colors.primary,
          backgroundColor: colors.surfaceContainerHighest,
        ),
      ),
    );
  }
}
