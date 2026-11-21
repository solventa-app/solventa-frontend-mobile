import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_sizes.dart';

/// Botón flotante circular del mapa (HU-M06, M8 botón GPS y M14 cambio de
/// estilo): 40 dp visibles dentro de un área táctil de 48 dp, blanco con
/// sombra suave e ícono `primary`. Con [seleccionado] (el mapa sigue al
/// cliente tras el botón GPS) se invierte: fondo `primary` e ícono
/// `onPrimary`, y TalkBack lo anuncia como seleccionado. `Material` anima el
/// cambio de color.
class SolMapFab extends StatelessWidget {
  const SolMapFab({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.seleccionado = false,
  });

  final IconData icon;

  /// Lo que lee TalkBack; dice lo que hace («Ver satélite»), no el ícono.
  final String semanticLabel;
  final VoidCallback? onPressed;

  /// Resaltado: la acción del botón está activa (p. ej. centrado en el
  /// cliente). Vuelve a `false` cuando el usuario mueve el mapa.
  final bool seleccionado;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: seleccionado,
      label: semanticLabel,
      excludeSemantics: true,
      onTap: onPressed,
      child: SizedBox.square(
        dimension: SolSizes.minTouchTarget,
        child: Center(
          child: Material(
            color: seleccionado ? colors.primary : colors.surface,
            shape: const CircleBorder(),
            elevation: 2,
            shadowColor: context.solColors.softShadow,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: SizedBox.square(
                dimension: size,
                child: Icon(
                  icon,
                  size: 20,
                  color: seleccionado ? colors.onPrimary : colors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
