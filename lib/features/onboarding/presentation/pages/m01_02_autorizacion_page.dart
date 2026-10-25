import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-02 · Autorización de datos (2001:236) y M01-02b · consentimiento
/// marcado (2018:493). «Continuar» deshabilitado hasta marcar (nunca marcado
/// por defecto) y CTA al final del contenido.
class M0102AutorizacionPage extends ConsumerWidget {
  const M0102AutorizacionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final estado = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final falla = estado.falla;

    Future<void> continuar() async {
      final ok = await notifier.registrarConsentimiento();
      if (ok && context.mounted) context.push(OnboardingRoutes.frente);
    }

    return SolFlowScaffold(
      title: l10n.m0102Titulo,
      anchorActions: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.m0102Legal,
            style: context.solText.body.copyWith(
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: SolSpacing.xxxl),
          Transform.translate(
            offset: const Offset(-4, 0),
            child: SolConsentCheckbox(
              value: estado.consentimientoMarcado,
              onChanged: estado.registrandoConsentimiento
                  ? null
                  : notifier.marcarConsentimiento,
              label: l10n.m0102Consentimiento,
            ),
          ),
          if (falla != null) ...[
            const SizedBox(height: SolSpacing.lg),
            SolStatusBanner(status: SolStatus.error, title: l10n.falla(falla)),
          ],
        ],
      ),
      actions: [
        SolButton.primary(
          label: l10n.continuar,
          loading: estado.registrandoConsentimiento,
          onPressed: estado.consentimientoMarcado ? continuar : null,
        ),
      ],
    );
  }
}
