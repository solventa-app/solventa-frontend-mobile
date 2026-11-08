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
    final primero = inicio.isAfter(ahora) ? ahora : inicio;
    // Si cambió de póliza, la fecha anterior puede quedar antes de la nueva
    // vigencia: el selector exige initialDate dentro del rango.
    final inicial = actual == null || actual.isBefore(primero) ? ahora : actual;
    final dia = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: primero,
      lastDate: ahora,
    );
    if (dia == null || !context.mounted) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(actual ?? ahora),
    );
    // Sin hora no hay fecha: antes se tomaba la medianoche, que en una póliza
    // emitida ese mismo día cae fuera de la vigencia y bloqueaba «Continuar».
    if (hora == null || !context.mounted) return;
    ref
        .read(reporteProvider.notifier)
        .fijarFecha(fechaDelSiniestro(dia, hora, ahora: ahora, poliza: poliza));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final estado = ref.watch(reporteProvider);
    final polizas = ref.watch(polizasReportablesProvider);
    final notifier = ref.read(reporteProvider.notifier);
    final fecha = estado.ocurridoEn;
    final poliza = estado.poliza;
    final fueraDeVigencia =
        poliza != null && fecha != null && !poliza.cubre(fecha);
    final errorFecha = !fueraDeVigencia
        ? null
        : fecha.isBefore(poliza.vigenciaDesde)
        ? l10n.m0501FechaAntes(SolFormat.dateTime(poliza.vigenciaDesde))
        : l10n.m0501FechaFuera;

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
            value: fecha == null
                ? l10n.m0501FechaElegir
                : SolFormat.dateTime(fecha),
            // Dice qué falta en lugar de dejar «Continuar» apagado sin más.
            helperText: poliza == null
                ? l10n.m0501ElegirPoliza
                : l10n.m0501CubreDesde(
                    SolFormat.dateTime(poliza.vigenciaDesde),
                  ),
            errorText: errorFecha,
            onTap: () => _elegirFecha(context, ref, poliza, fecha),
          ),
        ],
      ),
      actions: [
        SolButton.primary(
          label: l10n.m05Continuar,
          onPressed: poliza != null && fecha != null && !fueraDeVigencia
              ? () => context.push(ReporteRoutes.fotos)
              : null,
        ),
      ],
    );
  }
}

/// Día y hora elegidos en los selectores, nunca en el futuro. El selector solo
/// da minutos: si cae en el mismo minuto en que empezó la vigencia (póliza
/// recién emitida) se toma ese instante, que es lo que CLAIMS acepta.
@visibleForTesting
DateTime fechaDelSiniestro(
  DateTime dia,
  TimeOfDay hora, {
  required DateTime ahora,
  PolizaReportable? poliza,
}) {
  var fecha = DateTime(dia.year, dia.month, dia.day, hora.hour, hora.minute);
  if (fecha.isAfter(ahora)) fecha = ahora;
  final desde = poliza?.vigenciaDesde;
  if (desde != null &&
      fecha.isBefore(desde) &&
      desde.difference(fecha) < const Duration(minutes: 1)) {
    fecha = desde.isAfter(ahora) ? ahora : desde;
  }
  return fecha;
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
