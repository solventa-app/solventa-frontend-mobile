import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/moneda/monto_en_moneda.dart';
import '../../../../core/navegacion/volver.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_routes.dart';
import 'm05_01_poliza_page.dart' show nombreTipoAuto;
import 'm05_07_detalle_siniestro_page.dart' show estadoDelCaso, tiempoRestante;

/// Grupos del filtro de M05-06.
enum FiltroSiniestros { todos, enCurso, resueltos }

/// M05-06 · Mis siniestros: los casos que reportó el cliente y su estado en la
/// mesa de siniestros (HU-W04). Sin frame en Figma: sistema de diseño.
///
/// Filtro Todos / En curso / Resueltos, y en cada tarjeta el vehículo, qué
/// pasó, el estado y lo que importa de ese estado (tiempo que queda, monto
/// aprobado o motivo). Tocar una tarjeta abre el detalle (M05-07).
class M0506MisSiniestrosPage extends ConsumerStatefulWidget {
  const M0506MisSiniestrosPage({
    super.key,
    this.onHome,
    this.ahora = DateTime.now,
  });

  /// Casita al inicio en la barra superior (en lugar del avatar).
  final VoidCallback? onHome;

  /// El reloj; las pruebas lo fijan.
  final DateTime Function() ahora;

  @override
  ConsumerState<M0506MisSiniestrosPage> createState() =>
      _M0506MisSiniestrosPageState();
}

class _M0506MisSiniestrosPageState
    extends ConsumerState<M0506MisSiniestrosPage> {
  FiltroSiniestros _filtro = FiltroSiniestros.todos;

  static bool _enGrupo(SiniestroReportado c, FiltroSiniestros f) => switch (f) {
    FiltroSiniestros.todos => true,
    FiltroSiniestros.enCurso =>
      c.estado == 'PENDIENTE' || c.estado == 'EN_REVISION',
    FiltroSiniestros.resueltos =>
      c.estado == 'APROBADO' || c.estado == 'RECHAZADO',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final casos = ref.watch(misSiniestrosProvider);
    // El vehículo de cada póliza (la misma consulta del reporte). Si falla, la
    // tarjeta sale sin vehículo: no es motivo para esconder la lista.
    final vehiculos = switch (ref.watch(polizasReportablesProvider).value) {
      Exito(:final valor) => {for (final p in valor) p.id: ?p.vehiculo},
      _ => const <String, String>{},
    };

    final cuerpo = switch (casos) {
      AsyncData(value: Exito(:final valor)) when valor.isEmpty => SolInlineNote(
        text: l10n.m0506Vacio,
        center: true,
      ),
      AsyncData(value: Exito(:final valor)) => _Lista(
        casos: valor.where((c) => _enGrupo(c, _filtro)).toList(),
        filtro: _filtro,
        onFiltro: (f) => setState(() => _filtro = f),
        vehiculos: vehiculos,
        ahora: widget.ahora(),
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
      onBack: context.volverOInicio,
      onHomeTap: widget.onHome,
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

class _Lista extends StatelessWidget {
  const _Lista({
    required this.casos,
    required this.filtro,
    required this.onFiltro,
    required this.vehiculos,
    required this.ahora,
  });

  final List<SiniestroReportado> casos;
  final FiltroSiniestros filtro;
  final ValueChanged<FiltroSiniestros> onFiltro;
  final Map<String, String> vehiculos;
  final DateTime ahora;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolChoiceChips<FiltroSiniestros>(
          semanticLabel: l10n.m0506Titulo,
          selected: filtro,
          onSelected: onFiltro,
          choices: [
            SolChoice(
              value: FiltroSiniestros.todos,
              label: l10n.m0506FiltroTodos,
            ),
            SolChoice(
              value: FiltroSiniestros.enCurso,
              label: l10n.m0506FiltroEnCurso,
            ),
            SolChoice(
              value: FiltroSiniestros.resueltos,
              label: l10n.m0506FiltroResueltos,
            ),
          ],
        ),
        const SizedBox(height: SolSpacing.md),
        if (casos.isEmpty)
          SolInlineNote(text: l10n.m0506VacioFiltro, center: true)
        else
          for (final c in casos) ...[
            _FilaSiniestro(
              caso: c,
              vehiculo: c.polizaId == null ? null : vehiculos[c.polizaId],
              ahora: ahora,
            ),
            const SizedBox(height: SolSpacing.sm),
          ],
        if (casos.any((c) => c.resolucion?.indemnizacion != null))
          const NotaMontosDeReferencia(
            padding: EdgeInsets.only(top: SolSpacing.xs),
          ),
      ],
    );
  }
}

class _FilaSiniestro extends ConsumerWidget {
  const _FilaSiniestro({
    required this.caso,
    required this.vehiculo,
    required this.ahora,
  });

  final SiniestroReportado caso;
  final String? vehiculo;
  final DateTime ahora;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (status, estado) = estadoDelCaso(l10n, caso.estado);
    final estilo = SolStatusStyle.of(context, status);
    final tipo = caso.tipoAuto;
    final monto = caso.resolucion?.indemnizacion;

    // Lo que importa del estado, en una línea.
    final (IconData icono, String detalle) = switch (caso.estado) {
      'EN_REVISION' => (SolIcons.schedule, l10n.m0506EnRevisionDetalle),
      'APROBADO' when monto != null => (
        SolIcons.payments,
        l10n.m0506Monto(ref.monto(context, monto)),
      ),
      'APROBADO' => (SolIcons.payments, l10n.m0506AprobadoDetalle),
      'RECHAZADO' => (SolIcons.info, l10n.m0506RechazadoDetalle),
      _ => switch (tiempoRestante(caso.venceDictamenEn, ahora)) {
        final r? => (SolIcons.schedule, l10n.m0506Quedan(r)),
        null when !caso.apruebaAlVencer => (
          SolIcons.schedule,
          l10n.m0506PorValorar,
        ),
        null => (
          SolIcons.schedule,
          l10n.m0506PendienteDetalle(
            SolFormat.dateFor(
              caso.venceDictamenEn.toLocal(),
              Localizations.localeOf(context),
            ),
          ),
        ),
      },
    };

    final suave = context.solText.body.copyWith(color: colors.onSurfaceVariant);
    return MergeSemantics(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: SolRadius.cardAll,
          onTap: () => context.push(ReporteRoutes.detalleDe(caso.id)),
          child: SolCard.outlined(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Franja del color del estado: se ve de un vistazo en la lista
                  // (el texto de la insignia lo dice también).
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
                        // Con texto grande la insignia baja de línea.
                        Wrap(
                          spacing: SolSpacing.sm,
                          runSpacing: SolSpacing.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(caso.radicado, style: context.solText.title),
                            SolStatusBadge(status: status, label: estado),
                          ],
                        ),
                        if (vehiculo != null || tipo != null) ...[
                          const SizedBox(height: SolSpacing.xxs),
                          Text(
                            [
                              ?vehiculo,
                              if (tipo != null) nombreTipoAuto(l10n, tipo),
                            ].join(' · '),
                            style: context.solText.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: SolSpacing.xxs),
                        Text(
                          l10n.m0506Reportado(
                            SolFormat.dateFor(
                              caso.notificadoEn.toLocal(),
                              Localizations.localeOf(context),
                            ),
                            caso.fotos,
                          ),
                          style: suave,
                        ),
                        const SizedBox(height: SolSpacing.xs),
                        Row(
                          children: [
                            Icon(icono, size: 16, color: estilo.foreground),
                            const SizedBox(width: SolSpacing.xs),
                            Expanded(
                              child: Text(
                                detalle,
                                style: context.solText.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
