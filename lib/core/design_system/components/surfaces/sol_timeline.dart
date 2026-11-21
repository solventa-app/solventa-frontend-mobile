import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_spacing.dart';
import '../feedback/sol_status.dart';

/// En qué punto va un paso de la [SolTimeline].
enum SolTimelineState { done, current, upcoming }

/// Un paso de la línea de tiempo.
@immutable
class SolTimelineStep {
  const SolTimelineStep({
    required this.title,
    required this.state,
    this.subtitle,
    this.status,
  });

  final String title;
  final String? subtitle;
  final SolTimelineState state;

  /// Color del paso actual o terminado (éxito, error…). `null` = primario.
  final SolStatus? status;
}

/// Línea de tiempo vertical (HU-M05, M05-07): un punto por paso unido por una
/// línea. Terminado = punto lleno con chulo; actual = punto con anillo y título
/// en negrita; por venir = punto vacío y texto atenuado. El estado no depende
/// solo del color: cambia el punto y el peso del texto, y TalkBack lee cada
/// paso con su [stateLabels] («completado», «actual», «pendiente»).
class SolTimeline extends StatelessWidget {
  const SolTimeline({
    super.key,
    required this.steps,
    required this.stateLabels,
  });

  final List<SolTimelineStep> steps;

  /// Lo que lee TalkBack después del título, por estado.
  final Map<SolTimelineState, String> stateLabels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, paso) in steps.indexed)
          _Paso(
            paso: paso,
            ultimo: i == steps.length - 1,
            siguienteHecho:
                i < steps.length - 1 &&
                steps[i + 1].state != SolTimelineState.upcoming,
            etiquetaEstado: stateLabels[paso.state] ?? '',
          ),
      ],
    );
  }
}

class _Paso extends StatelessWidget {
  const _Paso({
    required this.paso,
    required this.ultimo,
    required this.siguienteHecho,
    required this.etiquetaEstado,
  });

  final SolTimelineStep paso;
  final bool ultimo;
  final bool siguienteHecho;
  final String etiquetaEstado;

  static const double _punto = 20;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = paso.status == null
        ? colors.primary
        : SolStatusStyle.of(context, paso.status!).foreground;
    final porVenir = paso.state == SolTimelineState.upcoming;
    final titulo = context.solText.body.copyWith(
      fontWeight: paso.state == SolTimelineState.current
          ? FontWeight.w700
          : FontWeight.w500,
      color: porVenir ? colors.onSurfaceVariant : colors.onSurface,
    );
    final punto = switch (paso.state) {
      SolTimelineState.done => Container(
        width: _punto,
        height: _punto,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(SolIcons.check, size: 14, color: colors.onPrimary),
      ),
      SolTimelineState.current => Container(
        width: _punto,
        height: _punto,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.18),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
      SolTimelineState.upcoming => Container(
        width: _punto,
        height: _punto,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.outlineVariant, width: 2),
        ),
      ),
    };
    return MergeSemantics(
      child: Semantics(
        label: etiquetaEstado,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _punto,
                child: Column(
                  children: [
                    punto,
                    if (!ultimo)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(
                            vertical: SolSpacing.xxs,
                          ),
                          color: siguienteHecho ? color : colors.outlineVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: SolSpacing.md),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: ultimo ? 0 : SolSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(paso.title, style: titulo),
                      if (paso.subtitle case final sub?)
                        Text(
                          sub,
                          style: context.solText.body.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
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
