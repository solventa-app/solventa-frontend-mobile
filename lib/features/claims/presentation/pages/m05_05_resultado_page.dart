import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_notifier.dart';
import '../reporte_routes.dart';

/// M05-05 · Desenlace: radicado y plazo, o el motivo con un siguiente paso.
class M0505ResultadoPage extends ConsumerWidget {
  const M0505ResultadoPage({super.key});

  /// El mensaje de CLAIMS ya viene para el cliente; los códigos del
  /// almacenamiento y las fallas técnicas se traducen aquí.
  static String _mensaje(AppLocalizations l10n, Falla falla) => switch (falla) {
    FallaNegocio(motivo: motivoFotoNoConfirmada) => l10n.m0505FotoNoConfirmada,
    FallaNegocio(:final motivo) when motivo.contains(' ') => motivo,
    _ => l10n.falla(falla),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final envio = ref.watch(reporteProvider.select((s) => s.envio));
    // Navega en el cuadro siguiente, con el gesto ya terminado: si se cambia
    // de ruta dentro del toque, la barra inferior del inicio recibe ese mismo
    // toque (con el botón sobre «Cerrar sesión» abría el cierre de sesión).
    void despues(VoidCallback ir) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) ir();
      });
      WidgetsBinding.instance.scheduleFrame();
    }

    void inicio() => despues(() => context.go('/'));

    return switch (envio) {
      Enviado(:final siniestro) => SolResultScreen(
        title: l10n.m0505Exito,
        status: SolStatus.success,
        message: l10n.m0505ExitoMensaje(
          siniestro.radicado,
          SolFormat.date(siniestro.venceDictamenEn.toLocal()),
        ),
        actionLabel: l10n.m0505VolverInicio,
        onAction: inicio,
        secondaryAction: SolButton.text(
          label: l10n.m0505VerMisSiniestros,
          onPressed: () => despues(() {
            context.go('/');
            context.push(ReporteRoutes.misSiniestros);
          }),
        ),
        showBack: false,
      ),
      EnvioFallido(:final falla) => SolResultScreen(
        title: l10n.m0505Error,
        status: SolStatus.error,
        message: _mensaje(l10n, falla),
        // Técnica (red, 503): reintenta con el mismo idReporte. De negocio:
        // vuelve al inicio del reporte a corregir.
        actionLabel: falla.reintentable
            ? l10n.m05Reintentar
            : l10n.m0505Revisar,
        onAction: falla.reintentable
            ? () =>
                  despues(() => context.pushReplacement(ReporteRoutes.enviando))
            : () => despues(() => context.go(ReporteRoutes.poliza)),
        secondaryAction: SolButton.text(
          label: l10n.m0505VolverInicio,
          onPressed: inicio,
        ),
        showBack: false,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
