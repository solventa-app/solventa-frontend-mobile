import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_routes.dart';

/// M05-01 · Póliza y fecha del siniestro (KAN-277). Sin frame en Figma: se
/// arma con el sistema de diseño (decisión del 2026-11-04).
class M0501PolizaPage extends ConsumerWidget {
  const M0501PolizaPage({super.key});

  Future<void> _elegirFecha(
    BuildContext context,
    WidgetRef ref,
    PolizaReportable? poliza,
    DateTime? actual,
  ) async {
    final ahora = ref.read(relojReporteProvider)();
    final inicio =
        poliza?.vigenciaDesde ?? ahora.subtract(const Duration(days: 365));
    final dia = await showDatePicker(
      context: context,
      initialDate: actual ?? ahora,
      firstDate: inicio.isAfter(ahora) ? ahora : inicio,
      lastDate: ahora,
    );
    if (dia == null || !context.mounted) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(actual ?? ahora),
    );
    if (!context.mounted) return;
    var fecha = DateTime(
      dia.year,
      dia.month,
      dia.day,
      hora?.hour ?? 0,
      hora?.minute ?? 0,
    );
    if (fecha.isAfter(ahora)) fecha = ahora;
    ref.read(reporteProvider.notifier).fijarFecha(fecha);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final estado = ref.watch(reporteProvider);
    final polizas = ref.watch(polizasReportablesProvider);
    final notifier = ref.read(reporteProvider.notifier);
    final fecha = estado.ocurridoEn;
    final fueraDeVigencia =
        estado.poliza != null && fecha != null && !estado.poliza!.cubre(fecha);

    final lista = switch (polizas) {
      AsyncData(value: Exito(:final valor)) when valor.isEmpty => SolInlineNote(
        text: l10n.m0501SinPolizas,
      ),
      AsyncData(value: Exito(:final valor)) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in valor) ...[
            _FilaPoliza(
              poliza: p,
              elegida: estado.poliza?.id == p.id,
              titulo: l10n.m0501PolizaNumero(p.numero),
              vigencia: l10n.m0501Vigencia(SolFormat.date(p.vigenciaHasta)),
              onTap: () => notifier.elegirPoliza(p),
            ),
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
            onPressed: () => ref.invalidate(polizasReportablesProvider),
          ),
        ],
      ),
      _ => SolLoadingState(message: l10n.m0501Cargando),
    };

    return SolFlowScaffold(
      title: l10n.m05Titulo,
      onBack: () => context.pop(),
      anchorActions: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SolSectionHeader(title: l10n.m0501Poliza),
          lista,
          const SizedBox(height: SolSpacing.lg),
          SolTextField.select(
            label: l10n.m0501Fecha,
            value: fecha == null ? '' : SolFormat.dateTime(fecha),
            errorText: fueraDeVigencia ? l10n.m0501FechaFuera : null,
            onTap: () => _elegirFecha(context, ref, estado.poliza, fecha),
          ),
        ],
      ),
      actions: [
        SolButton.primary(
          label: l10n.m05Continuar,
          onPressed: estado.poliza != null && fecha != null && !fueraDeVigencia
              ? () => context.push(ReporteRoutes.fotos)
              : null,
        ),
      ],
    );
  }
}

class _FilaPoliza extends StatelessWidget {
  const _FilaPoliza({
    required this.poliza,
    required this.elegida,
    required this.titulo,
    required this.vigencia,
    required this.onTap,
  });

  final PolizaReportable poliza;
  final bool elegida;
  final String titulo;
  final String vigencia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: elegida,
      inMutuallyExclusiveGroup: true,
      child: SolCard.outlined(
        onTap: onTap,
        semanticLabel: '$titulo. $vigencia',
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: context.solText.title),
                  Text(
                    vigencia,
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              elegida ? SolIcons.success : SolIcons.check,
              fill: elegida ? 1 : 0,
              color: elegida ? colors.primary : colors.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}
