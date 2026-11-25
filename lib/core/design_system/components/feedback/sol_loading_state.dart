import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_spacing.dart';

/// Carga: indicador circular + texto de lo que está pasando (M01-06).
///
/// Se anuncia a TalkBack (liveRegion). El indicador es siempre indeterminado:
/// con «quitar animaciones» no se congela en un arco fijo, porque un círculo
/// quieto parece una carga colgada (T12).
///
/// Para la carga de una pantalla completa se usa [SolLoadingState.page]: queda
/// en el centro, a lo alto y a lo ancho, del espacio que le den. Dentro de un
/// SolFlowScaffold o un SolScreenFrame (cuerpo con scroll, alto sin límite) la
/// pantalla además debe pedir `centerBody: true` para centrarlo a lo alto.
class SolLoadingState extends StatelessWidget {
  const SolLoadingState({super.key, required this.message, this.center = false})
    : expand = false;

  /// Carga de pantalla completa: centrada en el espacio disponible.
  const SolLoadingState.page({super.key, required this.message})
    : center = true,
      expand = true;

  /// Qué está pasando, p. ej. «Validando con el proveedor KYC/AML...».
  final String message;

  /// Centrado (por defecto alineado al inicio, como en M01-06).
  final bool center;

  /// Ocupa el espacio disponible y se pone en su centro ([SolLoadingState.page]).
  /// Con un alto sin límite (dentro de un scroll) solo se centra a lo ancho.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final estado = Semantics(
      liveRegion: true,
      label: message,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 48,
            child: Center(
              child: SizedBox.square(
                dimension: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: colors.primary,
                  backgroundColor: colors.outline,
                ),
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          Text(
            message,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: context.solText.body.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
    return expand ? Center(child: estado) : estado;
  }
}
