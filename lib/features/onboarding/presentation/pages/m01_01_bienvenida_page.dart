import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_routes.dart';
import '../widgets/onboarding_widgets.dart';

/// M01-01 · Bienvenida (2005:702). Pantalla de entrada: barra «Inicio», sin flecha.
class M0101BienvenidaPage extends StatelessWidget {
  const M0101BienvenidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pasos = [l10n.m0101Paso1, l10n.m0101Paso2, l10n.m0101Paso3];
    return SolEntryScaffold(
      backgroundColor: context.colors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.m0101Titulo,
              style: context.solText.headline.copyWith(
                color: context.colors.onSurface,
                letterSpacing: -0.6,
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.md),
          Text(
            l10n.m0101Intro,
            style: context.solText.body.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SolSpacing.xxl),
          for (var i = 0; i < pasos.length; i++) ...[
            if (i > 0) const SizedBox(height: SolSpacing.md),
            PasoOnboarding(
              numero: i + 1,
              texto: pasos[i],
              semanticLabel: l10n.m0101PasoSemantica(i + 1, pasos[i]),
            ),
          ],
        ],
      ),
      anchorActions: false,
      actions: [
        SolButton.primary(
          label: l10n.m0101Empezar,
          onPressed: () => context.push(OnboardingRoutes.autorizacion),
        ),
      ],
    );
  }
}
