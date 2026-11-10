import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/log/sol_log.dart';
import '../../domain/entities/verificacion_identidad.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-07a · Identidad verificada (2001:570), M01-07b · En revisión
/// (2001:605) y M01-07c · No pudimos verificarte (2001:640).
///
/// Una falla técnica (sin conexión, servicio caído) se muestra como 07c con
/// su propio texto, el código de soporte de Sentry (con opción de copiar) y
/// «Reintentar» repite la verificación.
class M0107ResultadoPage extends ConsumerWidget {
  const M0107ResultadoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final estado = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    void inicio() => context.go('/');

    final falla = estado.falla;
    if (falla != null) {
      final codigo = SolLog.obtenerCodigoSoporte();
      return SolResultScreen(
        title: l10n.verificacionTitulo,
        status: SolStatus.error,
        message: '${l10n.falla(falla)}\n\n${l10n.soporteCodigoTexto(codigo)}',
        actionLabel: l10n.reintentar,
        onAction: () => context.go(OnboardingRoutes.verificando),
        onBack: inicio,
        secondaryAction: SolButton.tonal(
          label: '${l10n.soporteCopiarCodigo} ($codigo)',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: codigo));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.soporteCodigoCopiado)),
              );
            }
          },
        ),
      );
    }
    return switch (estado.verificacion) {
      EstadoVerificacion.enRevision => SolResultScreen(
        title: l10n.verificacionTitulo,
        status: SolStatus.warning,
        message: l10n.m0107bMensaje,
        actionLabel: l10n.m0107bAccion,
        onAction: inicio,
        onBack: inicio,
      ),
      EstadoVerificacion.rechazada when estado.intentosRestantes > 0 =>
        SolResultScreen(
          title: l10n.verificacionTitulo,
          status: SolStatus.error,
          message: _mensajeRechazo(l10n, estado.onboarding?.motivo),
          actionLabel: l10n.reintentar,
          onAction: () async {
            final soloRostro = estado.rechazoSoloRostro;
            if (await notifier.reintentarCaptura() && context.mounted) {
              context.go(
                soloRostro
                    ? OnboardingRoutes.pruebaVida
                    : OnboardingRoutes.frente,
              );
            }
          },
          onBack: inicio,
        ),
      EstadoVerificacion.rechazada => SolResultScreen(
        title: l10n.verificacionTitulo,
        status: SolStatus.error,
        message: l10n.m0107cSinIntentos,
        actionLabel: l10n.irAlInicio,
        onAction: inicio,
        onBack: inicio,
      ),
      _ => SolResultScreen(
        title: l10n.verificacionTitulo,
        status: SolStatus.success,
        message: l10n.m0107aMensaje,
        actionLabel: l10n.m0107aAccion,
        onAction: () => context.go(OnboardingRoutes.biometria),
        onBack: inicio,
        // La biometría es opcional: se puede ir al inicio sin activarla.
        secondaryAction: SolButton.text(
          label: l10n.irAlInicio,
          onPressed: inicio,
        ),
      ),
    };
  }
}

/// Texto del motivo de rechazo del contrato; ILEGIBLE y los desconocidos
/// usan el mensaje general.
String _mensajeRechazo(AppLocalizations l10n, String? motivo) =>
    switch (motivo) {
      'ROSTRO_NO_COINCIDE' => l10n.m0107cRostro,
      'SUPLANTACION' => l10n.m0107cSuplantacion,
      'MENOR_DE_EDAD' => l10n.m0107cMenor,
      'DOCUMENTO_YA_REGISTRADO' => l10n.m0107cDocumentoRegistrado,
      _ => l10n.m0107cMensaje,
    };
