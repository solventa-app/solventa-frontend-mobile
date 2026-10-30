import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-03 · Captura de documento, frente (2001:330).
///
/// «Capturar» abre la cámara del sistema (`CapturaService`); la foto se sube
/// en segundo plano apenas se toma y el visor queda como guía.
class M0103DocumentoFrentePage extends ConsumerWidget {
  const M0103DocumentoFrentePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifier = ref.read(onboardingProvider.notifier);
    final ocupado = ref.watch(onboardingProvider.select((e) => e.ocupado));
    return SolFlowScaffold(
      title: l10n.m0103Titulo,
      anchorActions: false,
      padding: const EdgeInsets.fromLTRB(31, SolSpacing.lg, 31, SolSpacing.xxl),
      body: Column(
        children: [
          SolCameraFrame(
            label: l10n.m0103Tipo,
            labelIcon: SolIcons.idCard,
            instruction: l10n.m0103Instruccion,
          ),
          const SizedBox(height: SolSpacing.sm),
          SolInlineNote(
            icon: SolIcons.lighting,
            text: l10n.m0103Consejo,
            center: true,
            iconColor: context.colors.primary,
          ),
        ],
      ),
      actions: [
        SolButtonPair(
          secondary: SolButton.outlined(
            label: l10n.repetir,
            icon: SolIcons.retry,
            onPressed: notifier.repetirFrente,
          ),
          primary: SolButton.primary(
            label: l10n.capturar,
            icon: SolIcons.camera,
            loading: ocupado,
            onPressed: () async {
              if (await notifier.capturarFrente() && context.mounted) {
                await context.push(OnboardingRoutes.reverso);
              }
            },
          ),
        ),
      ],
    );
  }
}
