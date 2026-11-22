import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_spacing.dart';
import '../feedback/sol_status.dart';
import '../surfaces/sol_card.dart';

/// Tarjeta-acción con ícono, título 14/600 y chevron (G-03 «Solicitar
/// asistencia en sitio»).
///
/// Con [badge] muestra una insignia ámbar antes del chevron («1 por enviar»).
/// Con [disabledReason] queda deshabilitada y dice por qué bajo el título
/// («Necesita conexión»): no se puede tocar y los lectores lo anuncian.
class SolActionTile extends StatelessWidget {
  const SolActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.badge,
    this.disabledReason,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  /// Texto corto de algo que espera al usuario en esa sección.
  final String? badge;

  /// Por qué no se puede usar ahora. `null`: habilitada.
  final String? disabledReason;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final razon = disabledReason;
    final habilitada = razon == null;
    final tinta = habilitada ? colors.onSurface : colors.onSurfaceVariant;
    final fila = Row(
      children: [
        Icon(
          icon,
          size: SolSpacing.xxl,
          color: habilitada ? colors.primary : colors.onSurfaceVariant,
        ),
        const SizedBox(width: SolSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.solText.titleSmall.copyWith(color: tinta),
              ),
              if (razon != null) ...[
                const SizedBox(height: SolSpacing.xxs),
                Text(
                  razon,
                  style: context.solText.note.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (badge case final texto? when habilitada) ...[
          const SizedBox(width: SolSpacing.sm),
          SolStatusBadge(status: SolStatus.warning, label: texto),
        ],
        const SizedBox(width: SolSpacing.sm),
        Icon(
          habilitada ? SolIcons.chevronRight : SolIcons.offline,
          size: 20,
          opticalSize: 20,
          color: tinta,
        ),
      ],
    );
    if (!habilitada) {
      return Semantics(
        container: true,
        enabled: false,
        label: '$title. $razon',
        child: SolCard(
          child: ExcludeSemantics(child: Opacity(opacity: 0.72, child: fila)),
        ),
      );
    }
    return SolCard(
      onTap: onTap,
      semanticLabel: badge == null ? title : '$title. $badge',
      child: ExcludeSemantics(child: fila),
    );
  }
}
