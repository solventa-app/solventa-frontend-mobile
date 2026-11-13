import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';
import '../feedback/sol_status.dart';
import 'sol_provider_row.dart';

/// Estado que muestra la tarjeta de «Mis asistencias» (HU-M06, 4.2).
sealed class SolAssistanceCardState {
  const SolAssistanceCardState();
}

/// En camino: cuenta regresiva grande, hora estimada y barra de progreso.
final class SolAssistanceOnTheWay extends SolAssistanceCardState {
  const SolAssistanceOnTheWay({
    required this.countdown,
    required this.estimatedTime,
    required this.progress,
  });

  /// «Llega en 4 min».
  final String countdown;

  /// «Hora estimada 9:26 a. m.».
  final String estimatedTime;

  /// 0 a 1, de la confirmación a la llegada.
  final double progress;
}

/// No confirmada: aviso y «Reintentar».
final class SolAssistanceUnconfirmed extends SolAssistanceCardState {
  const SolAssistanceUnconfirmed({
    required this.warning,
    required this.retryLabel,
    required this.onRetry,
  });

  final String warning;
  final String retryLabel;
  final VoidCallback? onRetry;
}

/// Ya llegó: insignia de éxito, sin cuenta regresiva.
final class SolAssistanceArrived extends SolAssistanceCardState {
  const SolAssistanceArrived(this.label);

  /// «Llegó · 9:26 a. m.».
  final String label;
}

/// Tarjeta de «Mis asistencias» (HU-M06, 4.2): círculo del tipo con el color
/// de aliado (M3), nombre, «Médica · pedida 9:20 a. m.» y el estado. Toda la
/// tarjeta abre el detalle. TalkBack la lee entera una vez con
/// [semanticLabel] y no anuncia cada segundo.
class SolAssistanceCard extends StatelessWidget {
  const SolAssistanceCard({
    super.key,
    required this.name,
    required this.icon,
    required this.isPartner,
    required this.subtitle,
    required this.state,
    required this.semanticLabel,
    this.onTap,
    this.notice,
  });

  final String name;
  final IconData icon;
  final bool isPartner;
  final String subtitle;
  final SolAssistanceCardState state;
  final String semanticLabel;
  final VoidCallback? onTap;

  /// Aviso opcional dentro de la tarjeta (p. ej. «Te alejaste», 4.4b).
  final Widget? notice;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (fondo, frente) = solProviderColors(context, isPartner);
    final contenido = switch (state) {
      SolAssistanceOnTheWay(
        :final countdown,
        :final estimatedTime,
        :final progress,
      ) =>
        <Widget>[
          const SizedBox(height: SolSpacing.xs),
          Text(
            countdown,
            style: context.solText.headline.copyWith(color: colors.primary),
          ),
          Text(
            estimatedTime,
            style: context.solText.body.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SolSpacing.xs),
          ClipRRect(
            borderRadius: SolRadius.fullAll,
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 4,
              backgroundColor: colors.surfaceContainer,
            ),
          ),
        ],
      SolAssistanceUnconfirmed(
        :final warning,
        :final retryLabel,
        :final onRetry,
      ) =>
        <Widget>[
          const SizedBox(height: SolSpacing.xs),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SolStatusBadge(status: SolStatus.warning, label: warning),
          ),
          const SizedBox(height: SolSpacing.xs),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.tonal(
              onPressed: onRetry,
              child: Text(retryLabel),
            ),
          ),
        ],
      SolAssistanceArrived(:final label) => <Widget>[
        const SizedBox(height: SolSpacing.xs),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SolStatusBadge(status: SolStatus.success, label: label),
        ),
      ],
    };

    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SolSizes.minTouchTarget),
          child: Padding(
            padding: const EdgeInsets.all(SolSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: SolSizes.providerIcon,
                    height: SolSizes.providerIcon,
                    decoration: BoxDecoration(
                      color: fondo,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 22, fill: 1, color: frente),
                  ),
                ),
                const SizedBox(width: SolSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ExcludeSemantics(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: name),
                              if (isPartner) ...[
                                const TextSpan(text: ' '),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    SolIcons.verifiedProvider,
                                    size: 16,
                                    fill: 1,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          style: context.solText.title.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      ExcludeSemantics(
                        child: Text(
                          subtitle,
                          style: context.solText.body.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      // El estado no se lee aparte: va en [semanticLabel].
                      ExcludeSemantics(
                        excluding: state is! SolAssistanceUnconfirmed,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: contenido,
                        ),
                      ),
                      if (notice != null) ...[
                        const SizedBox(height: SolSpacing.sm),
                        notice!,
                      ],
                    ],
                  ),
                ),
                if (onTap != null)
                  ExcludeSemantics(
                    child: Icon(
                      SolIcons.chevronRight,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
