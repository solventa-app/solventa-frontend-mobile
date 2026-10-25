import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';
import '../widgets/onboarding_widgets.dart';

/// M01-04 · Captura de documento, reverso (2001:402).
class M0104DocumentoReversoPage extends ConsumerWidget {
  const M0104DocumentoReversoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifier = ref.read(onboardingProvider.notifier);
    final sol = context.solColors;
    return SolFlowScaffold(
      title: l10n.m0103Titulo,
      anchorActions: false,
      padding: const EdgeInsets.fromLTRB(
        SolSpacing.screen,
        SolSpacing.lg,
        SolSpacing.screen,
        SolSpacing.xxl,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IndicadorPasoDocumento(paso: 2, total: 2, texto: l10n.m0104Paso),
          const SizedBox(height: SolSpacing.sm),
          SolCameraFrame(
            shape: SolCameraFrameShape.documentBack,
            label: l10n.m0103Tipo,
            labelIcon: SolIcons.idCard,
            guideLabel: l10n.m0104LadoPosterior,
            instruction: l10n.m0104Instruccion,
          ),
          const SizedBox(height: SolSpacing.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surface,
              boxShadow: [
                BoxShadow(
                  color: sol.softShadow,
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(SolSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: sol.warningContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      SolIcons.lighting,
                      size: 20,
                      opticalSize: 20,
                      color: sol.warning,
                    ),
                  ),
                  const SizedBox(width: SolSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.m0104Consejo,
                      style: context.solText.body.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
          Center(
            child: SolStatusBadge(
              status: SolStatus.success,
              label: l10n.m0104Calidad,
            ),
          ),
        ],
      ),
      actions: [
        SolButtonPair(
          secondary: SolButton.outlined(
            label: l10n.repetir,
            icon: SolIcons.retry,
            onPressed: notifier.repetirReverso,
          ),
          primary: SolButton.primary(
            label: l10n.capturar,
            icon: SolIcons.camera,
            onPressed: () {
              notifier.capturarReverso();
              context.push(OnboardingRoutes.pruebaVida);
            },
          ),
        ),
      ],
    );
  }
}
