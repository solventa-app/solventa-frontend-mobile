import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';

/// M05-06 · Mis siniestros: los casos que reportó el cliente y su estado en la
/// mesa de siniestros (HU-W04). Sin frame en Figma: sistema de diseño.
class M0506MisSiniestrosPage extends ConsumerWidget {
  const M0506MisSiniestrosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final casos = ref.watch(misSiniestrosProvider);

    final cuerpo = switch (casos) {
      AsyncData(value: Exito(:final valor)) when valor.isEmpty => SolInlineNote(
        text: l10n.m0506Vacio,
        center: true,
      ),
      AsyncData(value: Exito(:final valor)) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in valor) ...[
            _FilaSiniestro(caso: c),
            const SizedBox(height: SolSpacing.sm),
          ],
        ],
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
        child: const _EsqueletoSiniestros(),
      ),
    };

    return SolFlowScaffold(
      title: l10n.m0506Titulo,
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
}

class _FilaSiniestro extends StatelessWidget {
  const _FilaSiniestro({required this.caso});

  final SiniestroReportado caso;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (
      SolStatus status,
      String estado,
      String detalle,
    ) = switch (caso.estado) {
      'EN_REVISION' => (
        SolStatus.warning,
        l10n.m0506EnRevision,
        l10n.m0506EnRevisionDetalle,
      ),
      'APROBADO' => (
        SolStatus.success,
        l10n.m0506Aprobado,
        l10n.m0506AprobadoDetalle,
      ),
      'RECHAZADO' => (
        SolStatus.error,
        l10n.m0506Rechazado,
        l10n.m0506RechazadoDetalle,
      ),
      _ => (
        SolStatus.info,
        l10n.m0506Pendiente,
        l10n.m0506PendienteDetalle(
          SolFormat.date(caso.venceDictamenEn.toLocal()),
        ),
      ),
    };
    return MergeSemantics(
      child: SolCard.outlined(
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
            const SizedBox(height: SolSpacing.xs),
            Text(
              l10n.m0506Reportado(
                SolFormat.date(caso.notificadoEn.toLocal()),
                caso.fotos,
              ),
              style: context.solText.body.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SolSpacing.xs),
            Text(detalle, style: context.solText.body),
          ],
        ),
      ),
    );
  }
}

/// Mientras llegan los reportes: tres tarjetas con la forma de [_FilaSiniestro] (radicado e insignia arriba, dos líneas
/// de texto abajo), para que la lista no salte cuando aparece.
class _EsqueletoSiniestros extends StatelessWidget {
  const _EsqueletoSiniestros();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < 3; i++) ...[
          const SolCard.outlined(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: SolSkeleton(widthFactor: 0.45, height: 20)),
                    SolSkeleton(
                      width: 88,
                      height: 24,
                      radius: SolRadius.fullAll,
                    ),
                  ],
                ),
                SizedBox(height: SolSpacing.sm),
                SolSkeleton(widthFactor: 0.8, height: 14),
                SizedBox(height: SolSpacing.xs),
                SolSkeleton(widthFactor: 0.6, height: 14),
              ],
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
        ],
      ],
    );
  }
}
