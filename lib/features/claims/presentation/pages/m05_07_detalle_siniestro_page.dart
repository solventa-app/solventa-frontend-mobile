import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';

/// M05-07 · Detalle de un siniestro del cliente: estado, fechas, plazo de
/// revisión y, si ya se resolvió, el monto de la indemnización o el motivo del
/// rechazo con cómo pedir que lo revisen. Sin frame en Figma: sistema de
/// diseño. Sale de la misma lista de M05-06 (`misSiniestros`), sin consulta
/// nueva.
class M0507DetalleSiniestroPage extends ConsumerWidget {
  const M0507DetalleSiniestroPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final casos = ref.watch(misSiniestrosProvider);

    final cuerpo = switch (casos) {
      AsyncData(value: Exito(:final valor)) => _cuerpo(
        context,
        valor.where((c) => c.id == id).firstOrNull,
      ),
      AsyncData(value: Fracaso(:final falla)) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SolInlineNote(text: l10n.falla(falla)),
          SolButton.text(
            label: l10n.m05Reintentar,
            onPressed: () => ref.invalidate(misSiniestrosProvider),
          ),
        ],
      ),
      _ => SolSkeletonGroup(
        message: l10n.m0506Cargando,
        child: const SolCard.outlined(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SolSkeleton(widthFactor: 0.5, height: 20),
              SizedBox(height: SolSpacing.sm),
              SolSkeleton(widthFactor: 0.8, height: 14),
              SizedBox(height: SolSpacing.xs),
              SolSkeleton(widthFactor: 0.6, height: 14),
            ],
          ),
        ),
      ),
    };

    return SolFlowScaffold(
      title: l10n.m0507Titulo,
      onBack: () => context.pop(),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(misSiniestrosProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [cuerpo],
        ),
      ),
    );
  }

  Widget _cuerpo(BuildContext context, SiniestroReportado? caso) {
    final l10n = context.l10n;
    if (caso == null) {
      return SolInlineNote(text: l10n.m0507NoEncontrado, center: true);
    }
    final colors = context.colors;
    final (SolStatus status, String estado) = switch (caso.estado) {
      'EN_REVISION' => (SolStatus.warning, l10n.m0506EnRevision),
      'APROBADO' => (SolStatus.success, l10n.m0506Aprobado),
      'RECHAZADO' => (SolStatus.error, l10n.m0506Rechazado),
      _ => (SolStatus.info, l10n.m0506Pendiente),
    };
    final ocurrido = caso.ocurridoEn;
    final resolucion = caso.resolucion;

    Widget linea(String texto) => Padding(
      padding: const EdgeInsets.only(top: SolSpacing.xs),
      child: Text(
        texto,
        style: context.solText.body.copyWith(color: colors.onSurfaceVariant),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolCard.outlined(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(caso.radicado, style: context.solText.title),
                  ),
                  SolStatusBadge(status: status, label: estado),
                ],
              ),
              if (ocurrido != null)
                linea(l10n.m0507Ocurrio(SolFormat.date(ocurrido.toLocal()))),
              linea(
                l10n.m0506Reportado(
                  SolFormat.date(caso.notificadoEn.toLocal()),
                  caso.fotos,
                ),
              ),
              if (caso.estado == 'PENDIENTE')
                linea(
                  l10n.m0506PendienteDetalle(
                    SolFormat.date(caso.venceDictamenEn.toLocal()),
                  ),
                ),
              if (caso.estado == 'EN_REVISION')
                linea(l10n.m0506EnRevisionDetalle),
            ],
          ),
        ),
        if (resolucion != null && resolucion.tipo != 'DERIVACION') ...[
          const SizedBox(height: SolSpacing.sm),
          SolCard.outlined(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.m0507Resolucion, style: context.solText.title),
                linea(
                  l10n.m0507ResueltoEl(
                    SolFormat.date(resolucion.resueltaEn.toLocal()),
                  ),
                ),
                if (resolucion.tipo == 'APROBACION') ...[
                  if (resolucion.indemnizacion case final monto?)
                    linea(l10n.m0507Indemnizacion(SolFormat.currency(monto))),
                  if (resolucion.plazoDispersion case final plazo?)
                    linea(l10n.m0507PlazoPago(plazo)),
                ],
                if (resolucion.tipo == 'RECHAZO') ...[
                  if (resolucion.motivo case final motivo?)
                    linea(l10n.m0507Motivo(_textoMotivo(l10n, motivo))),
                  if (resolucion.viaRecurso case final via?)
                    linea(l10n.m0507ViaRecurso(via)),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _textoMotivo(AppLocalizations l10n, String motivo) => switch (motivo) {
    'EVIDENCIA_INSUFICIENTE' => l10n.m0507MotivoEvidencia,
    'FUERA_DE_COBERTURA' => l10n.m0507MotivoCobertura,
    'POLIZA_NO_VIGENTE' => l10n.m0507MotivoPoliza,
    'INCONSISTENCIA_EN_RELATO' => l10n.m0507MotivoRelato,
    _ => l10n.m0507MotivoOtro,
  };
}
