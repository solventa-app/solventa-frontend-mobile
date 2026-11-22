import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/red/presentation/banner_conexion.dart';
import '../../data/cola_reportes.dart';
import '../providers.dart';
import '../reporte_routes.dart';
import '../vigia_reportes.dart';

/// La franja de conexión con lo que pasa con los reportes (HU-M05, sin
/// conexión): sin red dice cuántos hay por enviar; al volver, que se están
/// enviando; y al terminar, el radicado. Con buena conexión y nada que contar
/// no ocupa espacio.
class BannerReporte extends ConsumerWidget {
  const BannerReporte({super.key, this.conVer = true});

  /// «Ver» lleva a «Mis siniestros». Se quita en esa misma pantalla.
  final bool conVer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enCola = ref
        .watch(reportesPorEnviarProvider)
        .where((r) => r.enCola)
        .length;
    final progreso =
        ref.watch(progresoColaProvider).value ?? const ProgresoCola();
    final aviso = ref.watch(avisoEnvioProvider);

    void ir(String ruta) {
      ref.read(avisoEnvioProvider.notifier).ocultar();
      context.push(ruta);
    }

    final verPorEnviar = conVer && enCola > 0;
    return BannerConexion(
      mensajeSinConexion: enCola > 0
          ? l10n.redReportesPorEnviar(enCola)
          : l10n.redSinConexionReporte,
      accionSinConexion: verPorEnviar ? l10n.redVer : null,
      alTocarSinConexion: verPorEnviar
          ? () => ir(ReporteRoutes.misSiniestros)
          : null,
      conConexion: (context, {required restablecida}) {
        if (progreso.activa) {
          return SolConnectionBanner(
            tone: SolConnectionTone.syncing,
            title: restablecida
                ? l10n.redRestablecidaTitulo
                : l10n.redEnviandoTitulo,
            message: l10n.redEnviandoReportes(
              progreso.total,
              progreso.porcentaje,
            ),
          );
        }
        if (aviso == null) return null;
        if (aviso.enviados > 0) {
          return SolConnectionBanner(
            tone: SolConnectionTone.done,
            title: aviso.enviados == 1
                ? l10n.redReporteEnviado
                : l10n.redReportesEnviados(aviso.enviados),
            message: switch (aviso.radicado) {
              final radicado? => l10n.redRadicado(radicado),
              null => null,
            },
            actionLabel: conVer ? l10n.redVer : null,
            onAction: conVer ? () => ir(aviso.ruta) : null,
          );
        }
        return SolConnectionBanner(
          tone: SolConnectionTone.slow,
          title: l10n.avisoReporteRechazado,
          message: l10n.avisoReporteRechazadoCuerpo,
          actionLabel: conVer ? l10n.redVer : null,
          onAction: conVer ? () => ir(aviso.ruta) : null,
        );
      },
    );
  }
}
