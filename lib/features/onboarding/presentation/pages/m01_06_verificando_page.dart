import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-06 · Verificando identidad (2001:540). Pantalla transitoria: sin botón
/// y con el atrás bloqueado; navega sola según la respuesta.
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
      if (antes?.verificacion == null &&
          (ahora.verificacion != null || ahora.falla != null)) {
        context.go(OnboardingRoutes.resultado);
      }
    });
    final l10n = context.l10n;
    return SolTransitionalScreen(
      title: l10n.verificacionTitulo,
      message: l10n.m0106Validando,
    );
  }
}
