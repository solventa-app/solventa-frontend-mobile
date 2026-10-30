import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-06 · Verificando identidad (2001:540). Pantalla transitoria con el
/// atrás bloqueado: consulta el resultado a los 3, 8 y 20 s y navega sola. Si
/// no llegó, para (no sondea sin fin) y ofrece «Actualizar» e «Ir al inicio»:
/// la verificación sigue en el backend.
class M0106VerificandoPage extends ConsumerStatefulWidget {
  const M0106VerificandoPage({super.key});

  @override
  ConsumerState<M0106VerificandoPage> createState() =>
      _M0106VerificandoPageState();
}

class _M0106VerificandoPageState extends ConsumerState<M0106VerificandoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(onboardingProvider.notifier).verificar());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingProvider, (antes, ahora) {
      final listo = ahora.verificacion != null || ahora.falla != null;
      final antesListo = antes?.verificacion != null || antes?.falla != null;
      if (listo && !antesListo) context.go(OnboardingRoutes.resultado);
    });
    final l10n = context.l10n;
    final agotadas = ref.watch(
      onboardingProvider.select((e) => e.consultasAgotadas),
    );
    return SolTransitionalScreen(
      title: l10n.verificacionTitulo,
      message: agotadas ? l10n.m0106Demora : l10n.m0106Validando,
      footer: agotadas
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SolButton.primary(
                  label: l10n.actualizar,
                  onPressed: ref.read(onboardingProvider.notifier).actualizar,
                ),
                const SizedBox(height: SolSpacing.sm),
                SolButton.outlined(
                  label: l10n.irAlInicio,
                  onPressed: () => context.go('/'),
                ),
              ],
            )
          : null,
    );
  }
}
