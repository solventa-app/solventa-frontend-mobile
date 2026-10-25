import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Estados de producto. Nunca se comunican solo con color: cada uno trae
/// su ícono y su texto.
enum SolStatus { success, warning, error, info }

/// Colores e íconos resueltos de un [SolStatus].
@immutable
class SolStatusStyle {
  const SolStatusStyle({
    required this.foreground,
    required this.container,
    required this.icon,
    required this.badgeIcon,
    required this.semanticPrefix,
  });

  factory SolStatusStyle.of(BuildContext context, SolStatus status) {
    final colors = context.colors;
    final sol = context.solColors;
    return switch (status) {
      SolStatus.success => SolStatusStyle(
        foreground: sol.success,
        container: sol.successContainer,
        icon: SolIcons.success,
        badgeIcon: SolIcons.check,
        semanticPrefix: 'Éxito',
      ),
      SolStatus.warning => SolStatusStyle(
        foreground: sol.warning,
        container: sol.warningContainer,
        icon: SolIcons.warning,
        badgeIcon: SolIcons.attention,
        semanticPrefix: 'Atención',
      ),
      SolStatus.error => SolStatusStyle(
        foreground: colors.error,
        container: colors.errorContainer,
        icon: SolIcons.error,
        badgeIcon: SolIcons.close,
        semanticPrefix: 'Error',
      ),
      SolStatus.info => SolStatusStyle(
        foreground: colors.primary,
        container: colors.primaryContainer,
        icon: SolIcons.info,
        badgeIcon: SolIcons.info,
        semanticPrefix: 'Información',
      ),
    };
  }

  final Color foreground;
  final Color container;
  final IconData icon;
  final IconData badgeIcon;
  final String semanticPrefix;
}

/// Píldora de estado: ícono + texto 11/600 sobre el contenedor del estado
/// («✓ Identidad verificada», «! En revisión», «✕ No pudimos verificarte»).
class SolStatusBadge extends StatelessWidget {
  const SolStatusBadge({super.key, required this.status, required this.label});

  final SolStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = SolStatusStyle.of(context, status);
    return Semantics(
      label: '${s.semanticPrefix}: $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SolSpacing.md,
          vertical: SolSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: s.container,
          borderRadius: SolRadius.fullAll,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(s.badgeIcon, size: 14, weight: 700, color: s.foreground),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: context.solText.labelStrong.copyWith(
                  color: s.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aviso en línea con ícono, título y mensaje opcional. Se anuncia a
/// TalkBack al aparecer (liveRegion).
class SolStatusBanner extends StatelessWidget {
  const SolStatusBanner({
    super.key,
    required this.status,
    required this.title,
    this.message,
    this.action,
  });

  final SolStatus status;
  final String title;
  final String? message;

  /// Acción opcional (p. ej. un [SolLinkButton]).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = SolStatusStyle.of(context, status);
    final colors = context.colors;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SolSpacing.lg),
        decoration: BoxDecoration(
          color: s.container,
          borderRadius: SolRadius.cardAll,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(s.icon, size: 20, fill: 1, color: s.foreground),
            ),
            const SizedBox(width: SolSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    semanticsLabel: '${s.semanticPrefix}: $title',
                    style: context.solText.titleSmall.copyWith(
                      color: s.foreground,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: SolSpacing.xxs),
                    Text(
                      message!,
                      style: context.solText.body.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                  if (action != null) ...[
                    const SizedBox(height: SolSpacing.xs),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
