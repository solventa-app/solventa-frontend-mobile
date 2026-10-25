import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Tipo de prestador (Figma 2018:103).
enum SolProviderType {
  medico('Médico'),
  mecanico('Mecánico');

  const SolProviderType(this.label);

  final String label;
}

/// Fila de la lista de prestadores (M06-01): ícono por tipo, nombre,
/// «tipo · distancia · tiempo» y botón tonal «Solicitar».
class SolProviderRow extends StatelessWidget {
  const SolProviderRow({
    super.key,
    required this.name,
    required this.type,
    required this.distance,
    required this.eta,
    required this.onRequest,
    this.requestLabel = 'Solicitar',
  });

  final String name;
  final SolProviderType type;

  /// Texto ya formateado, p. ej. `1.2 km` o `SolFormat.distanceKm(1.2)`.
  final String distance;

  /// Texto ya formateado, p. ej. `6 min`.
  final String eta;
  final VoidCallback? onRequest;
  final String requestLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final (Color iconBg, Color iconFg, IconData icon) = switch (type) {
      SolProviderType.medico => (
        sol.successContainer,
        sol.success,
        SolIcons.medical,
      ),
      SolProviderType.mecanico => (
        sol.navIndicator,
        colors.primary,
        SolIcons.mechanic,
      ),
    };
    final meta = '${type.label} · $distance · $eta';

    final iconBadge = ExcludeSemantics(
      child: Container(
        width: SolSizes.providerIcon,
        height: SolSizes.providerIcon,
        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
        child: Icon(icon, size: 20, fill: 1, color: iconFg),
      ),
    );
    final texts = MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: context.solText.title.copyWith(color: colors.onSurface),
          ),
          Text(
            meta,
            style: context.solText.body.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
    final button = Semantics(
      button: true,
      label: '$requestLabel $name',
      enabled: onRequest != null,
      onTap: onRequest,
      excludeSemantics: true,
      child: FilledButton(
        onPressed: onRequest,
        style: FilledButton.styleFrom(
          backgroundColor: colors.secondaryContainer,
          foregroundColor: colors.onSecondaryContainer,
          disabledBackgroundColor: sol.disabledContainer,
          disabledForegroundColor: sol.disabledContent,
          minimumSize: const Size(88, SolSizes.tonalSmallButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: SolSpacing.lg),
          shape: const RoundedRectangleBorder(borderRadius: SolRadius.fullAll),
          tapTargetSize: MaterialTapTargetSize.padded,
          textStyle: context.solText.button,
          elevation: 0,
        ),
        child: Text(requestLabel),
      ),
    );

    // Con texto grande (≥ 150 %) el botón baja a su propia línea para que
    // el nombre no se corte.
    final stacked = MediaQuery.textScalerOf(context).scale(16) >= 24;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        // 10 + 48 (área táctil) + 10 = 68 dp, igual al Figma (12 + 44 + 12).
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      iconBadge,
                      const SizedBox(width: SolSpacing.lg),
                      Expanded(child: texts),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.sm),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: button,
                  ),
                ],
              )
            : Row(
                children: [
                  iconBadge,
                  const SizedBox(width: SolSpacing.lg),
                  Expanded(child: texts),
                  const SizedBox(width: SolSpacing.sm),
                  button,
                ],
              ),
      ),
    );
  }
}
