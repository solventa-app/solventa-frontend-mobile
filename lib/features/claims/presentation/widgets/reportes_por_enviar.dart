import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/red/estado_red_notifier.dart';
import '../../data/cola_reportes.dart';
import '../../domain/entities/reporte_guardado.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../pages/m05_01_poliza_page.dart' show nombreTipoAuto;
import '../providers.dart';
import '../reporte_routes.dart';

/// «hace 2 h», «hace 3 días»: cuánto pasó entre [desde] y [ahora].
String haceCuanto(AppLocalizations l10n, DateTime desde, DateTime ahora) {
  final paso = ahora.difference(desde);
  if (paso.inMinutes < 1) return l10n.tiempoHaceMomento;
  if (paso.inHours < 1) return l10n.tiempoHaceMin(paso.inMinutes);
  if (paso.inDays < 1) return l10n.tiempoHaceHoras(paso.inHours);
  return l10n.tiempoHaceDias(paso.inDays);
}

/// Cómo se nombra un reporte guardado: el vehículo y lo que pasó, o la póliza.
String tituloDeReporte(AppLocalizations l10n, ReporteGuardado r) {
  final poliza = r.poliza;
  if (poliza == null) return l10n.m0506BorradorTitulo;
  final partes = [
    poliza.vehiculo ?? l10n.m0501PolizaNumero(poliza.numero),
    if (r.tipoAuto case final tipo?) nombreTipoAuto(l10n, tipo),
  ];
  return partes.join(' · ');
}

/// Insignia del estado de un reporte guardado: ícono y texto, nunca solo color.
/// [progreso] es el de la cola (para «Enviando · foto 2 de 3») y [esperaWifi]
/// dice si, con la red de ahora, este reporte está esperando Wi-Fi.
(SolStatus, String) estadoLocalDe(
  AppLocalizations l10n,
  ReporteGuardado r, {
  ProgresoCola? progreso,
  bool esperaWifi = false,
}) => switch (r.estado) {
  EstadoLocal.borrador => (SolStatus.neutral, l10n.m0506SinTerminar),
  EstadoLocal.pendiente when esperaWifi => (
    SolStatus.warning,
    l10n.m0506EsperandoWifi,
  ),
  EstadoLocal.pendiente => (SolStatus.warning, l10n.m0506PendienteEnvio),
  EstadoLocal.enviando => (
    SolStatus.info,
    progreso != null && progreso.enviando == r.id && !progreso.radicando
        ? l10n.m0506EnviandoFoto(
            progreso.foto.clamp(1, progreso.fotos),
            progreso.fotos,
          )
        : l10n.m0506Enviando,
  ),
  EstadoLocal.enviado => (SolStatus.success, l10n.redReporteEnviado),
  EstadoLocal.conError => (SolStatus.error, l10n.m0506ConError),
  EstadoLocal.necesitaAtencion => (SolStatus.error, l10n.m0506NecesitaAtencion),
};

/// Por qué no se envió, en palabras para el cliente: el mensaje de la
/// aseguradora tal cual, o la traducción del código.
String motivoDeError(AppLocalizations l10n, ReporteGuardado r) {
  final motivo = r.ultimoError ?? '';
  if (motivo == motivoFotoNoConfirmada) return l10n.m0505FotoNoConfirmada;
  if (r.estado == EstadoLocal.conError && motivo.contains(' ')) return motivo;
  return l10n.m0507bErrorTecnico;
}

/// Pide confirmación y borra el reporte [id] del teléfono, con sus fotos.
Future<bool> descartarReporte(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  final l10n = context.l10n;
  final confirmar = await SolConfirmDialog.show(
    context,
    title: l10n.m0506DescartarTitulo,
    message: l10n.m0506DescartarMensaje,
    confirmLabel: l10n.m0506DescartarConfirmar,
    cancelLabel: l10n.m0506DescartarCancelar,
  );
  if (!confirmar) return false;
  await ref.read(almacenReportesProvider).borrar(id);
  return true;
}

/// M05-06 · «Por enviar»: los reportes de la cuenta que siguen en el teléfono.
class SeccionPorEnviar extends ConsumerWidget {
  const SeccionPorEnviar({
    super.key,
    required this.reportes,
    required this.ahora,
  });

  final List<ReporteGuardado> reportes;
  final DateTime ahora;

  /// Un borrador se retoma donde iba; lo demás abre su detalle.
  Future<void> _abrir(
    BuildContext context,
    WidgetRef ref,
    ReporteGuardado r,
  ) async {
    if (r.estado != EstadoLocal.borrador) {
      await context.push(ReporteRoutes.pendienteDe(r.id));
      return;
    }
    final retomado = await ref.read(reporteProvider.notifier).continuar(r.id);
    if (retomado && context.mounted) {
      await context.push(ReporteRoutes.poliza);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final progreso = ref.watch(progresoColaProvider).value;
    final porDatos = ref.watch(
      estadoRedProvider.select((red) => red.porDatosMoviles),
    );
    final soloWifi = ref.watch(
      preferenciasEnvioProvider.select((p) => p.soloWifi),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolSectionHeader(
          title: l10n.m0506PorEnviar,
          count: '${reportes.length}',
        ),
        for (final r in reportes) ...[
          FilaPorEnviar(
            reporte: r,
            ahora: ahora,
            progreso: progreso,
            esperaWifi: porDatos && r.esperaWifiCon(soloWifi: soloWifi),
            onTap: () => _abrir(context, ref, r),
            onDescartar: r.estado == EstadoLocal.borrador
                ? () => descartarReporte(context, ref, r.id)
                : null,
          ),
          const SizedBox(height: SolSpacing.sm),
        ],
        const SizedBox(height: SolSpacing.md),
      ],
    );
  }
}

/// Tarjeta de un reporte guardado en el teléfono.
class FilaPorEnviar extends StatelessWidget {
  const FilaPorEnviar({
    super.key,
    required this.reporte,
    required this.ahora,
    required this.onTap,
    this.onDescartar,
    this.progreso,
    this.esperaWifi = false,
  });

  final ReporteGuardado reporte;
  final DateTime ahora;

  /// En qué va la cola, para la fila del que se está enviando.
  final ProgresoCola? progreso;

  /// Con la red de ahora, este reporte espera Wi-Fi.
  final bool esperaWifi;
  final VoidCallback onTap;
  final VoidCallback? onDescartar;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final r = reporte;
    final (status, estado) = estadoLocalDe(
      l10n,
      r,
      progreso: progreso,
      esperaWifi: esperaWifi,
    );
    final borrador = r.estado == EstadoLocal.borrador;
    final enviando =
        r.estado == EstadoLocal.enviando && progreso?.enviando == r.id;
    // Lo que el cliente puede hacer desde la fila, si hay algo.
    final accion = switch (r.estado) {
      EstadoLocal.borrador => l10n.m0506Continuar,
      EstadoLocal.conError => l10n.m0507bCorregir,
      EstadoLocal.necesitaAtencion => l10n.m05EnviarAhora,
      _ => null,
    };
    final estilo = SolStatusStyle.of(context, status);
    final suave = context.solText.body.copyWith(color: colors.onSurfaceVariant);

    // Un borrador sin tocar se borra a los 7 días: se avisa desde el quinto.
    final sinTocar = ahora.difference(r.actualizadoEn);
    final porVencer =
        r.estado == EstadoLocal.borrador &&
        sinTocar >= LimitesLocales.avisoBorrador;
    final diasQuedan = (LimitesLocales.vidaBorrador - sinTocar).inDays.clamp(
      0,
      LimitesLocales.vidaBorrador.inDays,
    );

    return SolCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: SolRadius.cardAll,
                onTap: onTap,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: estilo.foreground,
                          borderRadius: SolRadius.fullAll,
                        ),
                      ),
                      const SizedBox(width: SolSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: SolSpacing.sm,
                              runSpacing: SolSpacing.xs,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  tituloDeReporte(l10n, r),
                                  style: context.solText.title,
                                ),
                                SolStatusBadge(status: status, label: estado),
                              ],
                            ),
                            const SizedBox(height: SolSpacing.xxs),
                            Text(
                              borrador
                                  ? l10n.m0506UltimaEdicion(
                                      SolFormat.dateTime(
                                        r.actualizadoEn.toLocal(),
                                      ),
                                      r.fotos.length,
                                    )
                                  : l10n.m0506GuardadoEl(
                                      SolFormat.dateTime(
                                        (r.guardadoEn ?? r.actualizadoEn)
                                            .toLocal(),
                                      ),
                                      r.fotos.length,
                                    ),
                              style: suave,
                            ),
                            if (r.estado == EstadoLocal.conError) ...[
                              const SizedBox(height: SolSpacing.xs),
                              Text(motivoDeError(l10n, r), style: suave),
                            ],
                            if (enviando) ...[
                              const SizedBox(height: SolSpacing.sm),
                              SolProgressBar(value: progreso!.fraccionReporte),
                            ],
                            if (porVencer) ...[
                              const SizedBox(height: SolSpacing.xs),
                              Text(
                                l10n.m0506BorradorSeBorra(diasQuedan),
                                style: context.solText.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.solColors.warning,
                                ),
                              ),
                            ],
                            if (accion != null) ...[
                              const SizedBox(height: SolSpacing.xs),
                              Text(
                                accion,
                                style: context.solText.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.secondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: SolSpacing.xs),
                      Center(
                        child: Icon(
                          SolIcons.chevronRight,
                          color: colors.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (onDescartar != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: SolSpacing.lg),
                child: SolLinkButton(
                  label: l10n.m0506Descartar,
                  size: SolLinkSize.small,
                  inline: true,
                  onPressed: onDescartar,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
