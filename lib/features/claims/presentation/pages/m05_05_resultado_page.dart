import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/red/presentation/banner_conexion.dart';
import '../../data/cola_reportes.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_notifier.dart';
import '../reporte_routes.dart';

/// M05-05 · Desenlace: radicado y plazo, o el motivo con un siguiente paso.
/// Sin conexión (o esperando Wi-Fi) el desenlace es «Reporte guardado»: está
/// completo en el teléfono, sin radicado todavía, y la app lo envía sola.
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
        banner: const BannerConexion(),
        title: l10n.m0505Exito,
        status: SolStatus.success,
        message: l10n.m0505ExitoMensaje(
          siniestro.radicado,
          SolFormat.dateFor(
            siniestro.venceDictamenEn.toLocal(),
            Localizations.localeOf(context),
          ),
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
        banner: const BannerConexion(),
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
      EnvioGuardado(:final guardadoEn, :final espera) => () {
        final hora = SolFormat.timeFor(
          guardadoEn.toLocal(),
          Localizations.localeOf(context),
        );
        void misSiniestros() => despues(() {
          context.go('/');
          context.push(ReporteRoutes.misSiniestros);
        });
        final esperaWifi = espera == EsperaCola.wifi;
        return SolResultScreen(
          banner: const BannerConexion(),
          title: l10n.m0505Guardado,
          status: SolStatus.warning,
          message: switch (espera) {
            EsperaCola.sinRed => l10n.m0505GuardadoSinRed(hora),
            EsperaCola.wifi => l10n.m0505GuardadoWifi(hora),
            EsperaCola.sinSesion => l10n.m0505GuardadoSesion(hora),
            EsperaCola.ninguna => l10n.m0505GuardadoReintento(hora),
          },
          details: [
            l10n.m0505GuardadoDetalle(
              ref.watch(reporteProvider.select((s) => s.fotos.length)),
            ),
            l10n.m0505GuardadoAviso,
          ],
          // Esperando Wi-Fi siempre se puede enviar ya, solo este reporte.
          actionLabel: esperaWifi
              ? l10n.m05EnviarConDatos
              : l10n.m0505VerMisSiniestros,
          onAction: esperaWifi
              ? () => despues(() {
                  unawaited(
                    ref.read(reporteProvider.notifier).enviar(conDatos: true),
                  );
                  context.pushReplacement(ReporteRoutes.enviando, extra: true);
                })
              : misSiniestros,
          secondaryAction: SolButton.text(
            label: esperaWifi
                ? l10n.m0505VerMisSiniestros
                : l10n.m0505VolverInicio,
            onPressed: esperaWifi ? misSiniestros : inicio,
          ),
          showBack: false,
        );
      }(),
      _ => const SizedBox.shrink(),
    };
  }
}
