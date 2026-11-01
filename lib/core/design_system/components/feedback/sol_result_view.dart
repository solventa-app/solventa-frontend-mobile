import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_spacing.dart';
import '../surfaces/sol_card.dart';
import 'sol_status.dart';

/// Resultado: ícono de estado + mensaje (+ acción opcional) en una tarjeta
/// (M01-07a/b/c). Se anuncia a TalkBack al aparecer.
class SolResultView extends StatelessWidget {
  const SolResultView({
    super.key,
    required this.status,
    required this.message,
    this.action,
  });

  /// success (verificada), warning (en revisión) o error (no pudimos).
  final SolStatus status;
  final String message;

  /// Acción opcional dentro de la tarjeta (normalmente va anclada abajo).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = SolStatusStyle.of(context, status);
    final colors = context.colors;
    final isError = status == SolStatus.error;
    // M01-07a/b: círculo de 80 dp y ícono relleno; M01-07c: 72 dp con borde.
    final circle = isError ? 72.0 : 80.0;
    final icon = switch (status) {
      SolStatus.success => SolIcons.success,
      SolStatus.warning => SolIcons.inReview,
      SolStatus.error => SolIcons.failure,
      SolStatus.info => SolIcons.info,
    };
    return Semantics(
      container: true,
      liveRegion: true,
      label: '${s.semanticPrefix}. $message',
      excludeSemantics: action == null,
      child: SolCard(
        padding: const EdgeInsets.all(SolSpacing.xxl),
        child: Column(
          children: [
            Container(
              width: circle,
              height: circle,
              decoration: BoxDecoration(
                color: s.container,
                shape: BoxShape.circle,
                border: isError
                    ? Border.all(color: s.foreground, width: 2)
                    : null,
              ),
              child: Icon(
                icon,
                size: isError ? 40 : 48,
                fill: isError ? 0 : 1,
                color: s.foreground,
              ),
            ),
            SizedBox(height: isError ? SolSpacing.lg : SolSpacing.xxl),
            ExcludeSemantics(
              excluding: action != null,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: context.solText.title.copyWith(
                  color: colors.onSurface,
                  height: 22 / 16,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: SolSpacing.xxl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
