import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// Aviso de error de un paso del onboarding.
///
/// Si el recorrido venció (su token dura 30 min: `TOKEN_INVALIDO`) o falló de
/// una forma que reintentar no arregla («Algo salió mal» al final, un estado
/// inválido o un rechazo sin reintento), agrega «Empezar de nuevo» para no
/// dejar al usuario bloqueado (T16, pedido de felipe 2026-11-21): descarta el
/// recorrido y las capturas y vuelve a la bienvenida. La cuenta y su sesión no
/// se tocan.
class FallaBanner extends ConsumerWidget {
  const FallaBanner({super.key, required this.falla});

  final Falla falla;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vencido = switch (falla) {
      FallaNegocio(registroVencido: true) => true,
      FallaNegocio(reintentable: false) => true,
      _ => false,
    };
    final generica = l10n.falla(falla) == l10n.fallaGenerica;
    return SolStatusBanner(
      status: SolStatus.error,
      title: generica ? l10n.fallaGenericaOnboarding : l10n.falla(falla),
      action: vencido || generica
          ? SolLinkButton(
              label: l10n.fallaEmpezarDeNuevo,
              inline: true,
              onPressed: () {
                ref.read(onboardingProvider.notifier).reiniciarRecorrido();
                context.go(OnboardingRoutes.bienvenida);
              },
            )
          : null,
    );
  }
}
