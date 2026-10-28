import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/verificacion_identidad.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-05 · Prueba de vida (2001:502). «Continuar» toma la selfie y el video,
/// espera las cuatro subidas y envía la verificación; luego va M01-05b. Los
/// disparadores de demo solo existen en debug y eligen el desenlace del fake.
class M0105PruebaVidaPage extends ConsumerWidget {
  const M0105PruebaVidaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifier = ref.read(onboardingProvider.notifier);
    final estado = ref.watch(onboardingProvider);
    final falla = estado.falla;
    Future<void> ir([EstadoVerificacion? escenario]) async {
      if (escenario != null) notifier.simular(escenario);
      if (await notifier.completarPruebaDeVida() && context.mounted) {
        context.go(OnboardingRoutes.cuenta);
      }
    }

    final marco = SolCameraFrame(
      shape: SolCameraFrameShape.face,
      instruction: l10n.m0105Instruccion,
    );

    return SolFlowScaffold(
      title: l10n.m0105Titulo,
      anchorActions: false,
      padding: const EdgeInsets.fromLTRB(
        SolSpacing.screen,
        0,
        SolSpacing.screen,
        SolSpacing.xxl,
      ),
      body: falla == null
          ? marco
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                marco,
                const SizedBox(height: SolSpacing.lg),
                SolStatusBanner(
                  status: SolStatus.error,
                  title: l10n.falla(falla),
                ),
              ],
            ),
      actions: [
        SolButton.primary(
          label: l10n.continuar,
          loading: estado.ocupado,
          onPressed: ir,
        ),
        SolDemoTrigger(
          label: l10n.m0105DemoRevision,
          center: true,
          onTap: () => ir(EstadoVerificacion.enRevision),
        ),
        SolDemoTrigger(
          label: l10n.m0105DemoRechazo,
          center: true,
          onTap: () => ir(EstadoVerificacion.rechazada),
        ),
      ],
    );
  }
}
