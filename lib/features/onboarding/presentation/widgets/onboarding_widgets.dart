import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';

/// Paso numerado de M01-01 (2005:732): tarjeta con borde, número en círculo.
class PasoOnboarding extends StatelessWidget {
  const PasoOnboarding({
    super.key,
    required this.numero,
    required this.texto,
    required this.semanticLabel,
  });

  final int numero;
  final String texto;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: SolCard.outlined(
        padding: const EdgeInsets.all(17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.outline),
                ),
                child: MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.3,
                  child: Text(
                    '$numero',
                    style: context.solText.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.secondary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: SolSpacing.xs),
                child: Text(
                  texto,
                  style: context.solText.body.copyWith(color: colors.onSurface),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicador «Paso 2 de 2: Reverso» con segmentos de progreso (2001:405).
class IndicadorPasoDocumento extends StatelessWidget {
  const IndicadorPasoDocumento({
    super.key,
    required this.paso,
    required this.total,
    required this.texto,
  });

  final int paso;
  final int total;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    return Semantics(
      label: texto,
      excludeSemantics: true,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: 1,
              child: Text(
                '$paso',
                style: context.solText.labelStrong.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: SolSpacing.xs),
          Expanded(
            child: Text(
              texto,
              style: context.solText.body.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
            ),
          ),
          for (var i = 1; i <= total; i++) ...[
            if (i > 1) const SizedBox(width: 6),
            Container(
              width: 32,
              height: 6,
              decoration: BoxDecoration(
                // Pasos hechos en verde, el actual en azul (2001:412-413).
                color: i < paso ? sol.success : colors.primary,
                borderRadius: SolRadius.fullAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
