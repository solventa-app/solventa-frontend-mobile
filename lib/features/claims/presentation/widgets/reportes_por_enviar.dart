import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/reporte_guardado.dart';
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
(SolStatus, String) estadoLocalDe(AppLocalizations l10n, ReporteGuardado r) =>
    switch (r.estado) {
      EstadoLocal.borrador => (SolStatus.neutral, l10n.m0506SinTerminar),
      EstadoLocal.pendiente ||
      EstadoLocal.enviando ||
      EstadoLocal.enviado ||
      EstadoLocal.conError ||
      EstadoLocal.necesitaAtencion => (
        SolStatus.neutral,
        l10n.m0506SinTerminar,
      ),
    };

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

  Future<void> _continuar(
    BuildContext context,
    WidgetRef ref,
    ReporteGuardado r,
  ) async {
    final retomado = await ref.read(reporteProvider.notifier).continuar(r.id);
    if (retomado && context.mounted) {
      await context.push(ReporteRoutes.poliza);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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
            onTap: () => _continuar(context, ref, r),
            onDescartar: r.editable
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
  });

  final ReporteGuardado reporte;
  final DateTime ahora;
  final VoidCallback onTap;
  final VoidCallback? onDescartar;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final r = reporte;
    final (status, estado) = estadoLocalDe(l10n, r);
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
                              l10n.m0506UltimaEdicion(
                                SolFormat.dateTime(r.actualizadoEn.toLocal()),
                                r.fotos.length,
                              ),
                              style: suave,
                            ),
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
                            const SizedBox(height: SolSpacing.xs),
                            Text(
                              l10n.m0506Continuar,
                              style: context.solText.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.secondary,
                              ),
                            ),
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
