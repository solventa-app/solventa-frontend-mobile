import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/network_providers.dart';
import '../../domain/entities/verificacion_identidad.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';
import '../widgets/onboarding_widgets.dart';

/// M01-05 · Prueba de vida (2001:502). «Continuar» toma la selfie y el video,
/// espera las cuatro subidas y envía la verificación; luego va a M01-05b (o
/// directo a M01-06 si la cuenta ya fue creada al inicio). Si una subida falla
/// por red, permite «Reintentar envío» sin obligar a tomar las fotos de nuevo.
/// Envuelta en [SentryMask] para no grabar el rostro del usuario.
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
        final actual = ref.read(onboardingProvider);
        if (actual.cuentaCreada) {
          if (actual.verificacion != null) {
            context.go(OnboardingRoutes.resultado);
          } else {
            context.go(OnboardingRoutes.verificando);
          }
        } else {
          context.go(OnboardingRoutes.cuenta);
        }
      }
    }

    final marco = SolLiveCameraFrame(
      shape: SolCameraFrameShape.face,
      instruction: l10n.m0105Instruccion,
      frontal: true,
    );

    return SentryMask(
      SolFlowScaffold(
        title: l10n.m0105Titulo,
        anchorActions: false,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(OnboardingRoutes.reverso);
          }
        },
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
            label: falla != null && estado.capturasListasParaReintentar
                ? l10n.camaraReintentarEnvio
                : l10n.continuar,
            loading: estado.ocupado,
            onPressed: ir,
          ),
          if (ref.watch(usarFakesProvider)) ...[
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
        ],
      ),
    );
  }
}
