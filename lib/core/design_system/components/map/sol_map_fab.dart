import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_sizes.dart';

/// Botón flotante circular del mapa (HU-M06, M8 «Volver a centrar» y M14
/// cambio de estilo): 40 dp visibles dentro de un área táctil de 48 dp,
/// blanco con sombra suave e ícono `primary`.
class SolMapFab extends StatelessWidget {
  const SolMapFab({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;

  /// Lo que lee TalkBack; dice lo que hace («Ver satélite»), no el ícono.
  final String semanticLabel;
  final VoidCallback? onPressed;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      onTap: onPressed,
      child: SizedBox.square(
        dimension: SolSizes.minTouchTarget,
        child: Center(
          child: Material(
            color: colors.surface,
            shape: const CircleBorder(),
            elevation: 2,
            shadowColor: context.solColors.softShadow,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: SizedBox.square(
                dimension: size,
                child: Icon(icon, size: 20, color: colors.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
