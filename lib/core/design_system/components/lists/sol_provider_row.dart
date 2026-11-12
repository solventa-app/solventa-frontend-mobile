import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Tipo de prestador (Figma 2018:103). `grua` desde HU-M06 v0.49.
enum SolProviderType {
  medico('Médico'),
  mecanico('Mecánico'),
  grua('Grúa');

  const SolProviderType(this.label);

  final String label;
}

/// Fila de la lista de prestadores (M06-01): ícono por tipo, nombre,
/// «tipo · distancia · tiempo» y botón tonal «Solicitar».
///
/// HU-M06 (M3): **el ícono dice el tipo y el color dice si es aliado**.
/// Aliado: ícono `primary` sobre `primaryContainer`, `verified` junto al nombre
/// y [partnerLabel] en la semántica. No aliado: `onSurfaceVariant` sobre
/// `surfaceContainer`. Cambia el Figma, donde el color iba por tipo.
class SolProviderRow extends StatelessWidget {
  const SolProviderRow({
    super.key,
    required this.name,
    required this.type,
    required this.distance,
    required this.onRequest,
    this.eta,
    this.requestLabel = 'Solicitar',
    this.typeLabel,
    this.isPartner = false,
    this.partnerLabel = 'Aliado Solventa',
  });

  /// Aliado Solventa: cambia el color del ícono y muestra `verified` (M3).
  final bool isPartner;

  /// Texto de la insignia para TalkBack, ya traducido.
  final String partnerLabel;

  final String name;
  final SolProviderType type;

  /// Especialidad ya traducida (catálogo de la app). Por defecto, [type.label].
  final String? typeLabel;

  /// Texto ya formateado, p. ej. `1.2 km` o `SolFormat.distanceKm(1.2)`.
  final String distance;

  /// Texto ya formateado, p. ej. `6 min`. Sin ubicación del cliente no hay.
  final String? eta;
  final VoidCallback? onRequest;
  final String requestLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final (IconData icon, double iconSize) = switch (type) {
      SolProviderType.medico => (SolIcons.medical, 22.0), // 2018:80
      SolProviderType.mecanico => (SolIcons.mechanic, 20.0),
      SolProviderType.grua => (SolIcons.towTruck, 22.0),
    };
    final (Color iconBg, Color iconFg) = solProviderColors(context, isPartner);
    final meta = [typeLabel ?? type.label, distance, ?eta].join(' · ');

    final iconBadge = ExcludeSemantics(
      child: Container(
        width: SolSizes.providerIcon,
        height: SolSizes.providerIcon,
        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
        child: Icon(
          icon,
          size: iconSize,
          opticalSize: iconSize,
          fill: 1,
          color: iconFg,
        ),
      ),
    );
    final texts = MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: name),
                if (isPartner) ...[
                  const TextSpan(text: ' '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Semantics(
                      label: partnerLabel,
                      child: Icon(
                        SolIcons.verifiedProvider,
                        size: 16,
                        fill: 1,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
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

/// Colores del círculo del prestador (M3): aliado o no. Los usan la fila, el
/// pin del mapa y el detalle, para que digan lo mismo.
(Color background, Color foreground) solProviderColors(
  BuildContext context,
  bool isPartner,
) {
  final colors = context.colors;
  return isPartner
      ? (colors.primaryContainer, colors.primary)
      : (colors.surfaceContainer, colors.onSurfaceVariant);
}
