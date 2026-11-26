import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/red/estado_red_notifier.dart';
import '../../data/cola_reportes.dart';
import '../../domain/entities/reporte_guardado.dart';
import '../providers.dart';
import '../reporte_routes.dart';
import '../widgets/banner_reporte.dart';
import '../widgets/reportes_por_enviar.dart';
import 'm05_01_poliza_page.dart' show nombreTipoAuto;

/// Los bytes de una foto guardada, para su miniatura. Salen de la base
/// cifrada y no se quedan en memoria al cerrar la pantalla.
final _fotoGuardadaProvider = FutureProvider.autoDispose
    .family<Uint8List?, int>(
      (ref, idFoto) => ref.watch(almacenReportesProvider).bytesDeFoto(idFoto),
    );

/// Si el teléfono deja notificar lo que pase con los reportes.
final _avisosPermitidosProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(notificacionesReporteProvider).permitidas(),
);

/// M05-07b · «Reporte por enviar» (HU-M05, sin conexión): un reporte que
/// sigue en el teléfono. Muestra en qué va el envío, sus fotos y sus datos, y
/// deja enviarlo ya, editarlo o descartarlo. Si la aseguradora lo rechazó,
/// dice por qué y lleva a corregirlo sin perder nada.
class M0507bReportePendientePage extends ConsumerWidget {
  const M0507bReportePendientePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final guardados = ref.watch(reportesGuardadosProvider);
    final reporte = guardados.value?.where((r) => r.id == id).firstOrNull;
    void atras() => context.canPop() ? context.pop() : context.go('/');

    if (reporte == null) {
      return SolFlowScaffold(
        banner: const BannerReporte(),
        title: l10n.m0507bTitulo,
        onBack: atras,
        centerBody: guardados.isLoading,
        body: guardados.isLoading
            ? SolLoadingState.page(message: l10n.m0506Cargando)
            : SolInlineNote(icon: SolIcons.info, text: l10n.m0507bYaNoEsta),
        actions: [
          if (!guardados.isLoading)
            SolButton.primary(
              label: l10n.m0505VerMisSiniestros,
              onPressed: () =>
                  context.pushReplacement(ReporteRoutes.misSiniestros),
            ),
        ],
      );
    }

    final red = ref.watch(estadoRedProvider);
    final soloWifi = ref.watch(
      preferenciasEnvioProvider.select((p) => p.soloWifi),
    );
    final progreso =
        ref.watch(progresoColaProvider).value ?? const ProgresoCola();
    final esperaWifi =
        red.porDatosMoviles && reporte.esperaWifiCon(soloWifi: soloWifi);
    final cola = ref.read(colaReportesProvider);

    Future<void> editar() async {
      final retomado = await ref
          .read(reporteProvider.notifier)
          .continuar(reporte.id);
      if (retomado && context.mounted) {
        context.pushReplacement(ReporteRoutes.poliza);
      }
    }

    Future<void> descartar() async {
      if (await descartarReporte(context, ref, reporte.id) && context.mounted) {
        atras();
      }
    }

    final caso = reporte.resultado;
    final acciones = switch (reporte.estado) {
      EstadoLocal.enviado => [
        if (caso != null)
          SolButton.primary(
            label: l10n.m0507bVerCaso,
            onPressed: () =>
                context.pushReplacement(ReporteRoutes.detalleDe(caso.id)),
          ),
      ],
      EstadoLocal.enviando => const <Widget>[],
      EstadoLocal.borrador => [
        SolButton.primary(
          label: l10n.m0506Continuar,
          icon: SolIcons.edit,
          onPressed: () => unawaited(editar()),
        ),
        SolButton.text(
          label: l10n.m0506Descartar,
          onPressed: () => unawaited(descartar()),
        ),
      ],
      EstadoLocal.conError => [
        SolButton.primary(
          label: l10n.m0507bCorregir,
          icon: SolIcons.edit,
          onPressed: () => unawaited(editar()),
        ),
        SolButton.text(
          label: l10n.m0506Descartar,
          onPressed: () => unawaited(descartar()),
        ),
      ],
      EstadoLocal.pendiente || EstadoLocal.necesitaAtencion => [
        if (esperaWifi)
          SolButton.primary(
            label: l10n.m05EnviarConDatos,
            onPressed: () =>
                unawaited(cola.enviarAhora(reporte.id, conDatos: true)),
          )
        else if (red.conectado)
          SolButton.primary(
            label: l10n.m05EnviarAhora,
            onPressed: () => unawaited(cola.enviarAhora(reporte.id)),
          ),
        if (reporte.editable)
          SolButton.outlined(
            label: l10n.m0507bEditar,
            icon: SolIcons.edit,
            onPressed: () => unawaited(editar()),
          ),
        if (reporte.editable)
          SolButton.text(
            label: l10n.m0506Descartar,
            onPressed: () => unawaited(descartar()),
          ),
      ],
    };

    return SolFlowScaffold(
      banner: const BannerReporte(conVer: false),
      title: l10n.m0507bTitulo,
      onBack: atras,
      anchorActions: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (reporte.estado == EstadoLocal.conError) ...[
            SolStatusBanner(
              status: SolStatus.error,
              title: l10n.avisoReporteRechazado,
              message: motivoDeError(l10n, reporte),
            ),
            const SizedBox(height: SolSpacing.md),
          ] else if (reporte.estado == EstadoLocal.necesitaAtencion) ...[
            SolStatusBanner(
              status: SolStatus.warning,
              title: l10n.avisoReporteRechazado,
              message: l10n.m0507bAtencion,
            ),
            const SizedBox(height: SolSpacing.md),
          ] else if (caso != null) ...[
            SolStatusBanner(
              status: SolStatus.success,
              title: l10n.redReporteEnviado,
              message: l10n.redRadicado(caso.radicado),
            ),
            const SizedBox(height: SolSpacing.md),
          ],
          SolCard.outlined(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.m0507bEstadoEnvio,
                    style: context.solText.title,
                  ),
                ),
                const SizedBox(height: SolSpacing.md),
                _Seguimiento(
                  reporte: reporte,
                  progreso: progreso,
                  conectado: red.conectado,
                  esperaWifi: esperaWifi,
                  sinSesion: !ref.watch(sesionParaEnviarProvider)(),
                ),
                if (reporte.estado == EstadoLocal.enviando &&
                    progreso.enviando == reporte.id) ...[
                  const SizedBox(height: SolSpacing.sm),
                  SolProgressBar(value: progreso.fraccionReporte),
                ],
              ],
            ),
          ),
          if (reporte.fotos.isNotEmpty &&
              reporte.estado != EstadoLocal.enviado) ...[
            const SizedBox(height: SolSpacing.md),
            _Fotos(fotos: reporte.fotos),
          ],
          const SizedBox(height: SolSpacing.md),
          _Datos(reporte: reporte),
          const SizedBox(height: SolSpacing.md),
          if (reporte.radicacionIncierta)
            SolInlineNote(icon: SolIcons.info, text: l10n.m0507bIncierto)
          else if (reporte.estado == EstadoLocal.enviando)
            SolInlineNote(icon: SolIcons.info, text: l10n.m0507bEnviandoNota)
          else if (reporte.estado == EstadoLocal.conError)
            SolInlineNote(icon: SolIcons.info, text: l10n.m0507bNadaSePerdio),
          if (reporte.enCola &&
              ref.watch(_avisosPermitidosProvider).value == false) ...[
            const SizedBox(height: SolSpacing.sm),
            SolInlineNote(icon: SolIcons.info, text: l10n.m0507bActivaAvisos),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SolLinkButton(
                label: l10n.m0502AbrirAjustes,
                size: SolLinkSize.small,
                onPressed: () => unawaited(
                  ref
                      .read(ubicacionReporteProvider)
                      .abrirAjustes(deUbicacion: false),
                ),
              ),
            ),
          ],
          if (acciones.isNotEmpty) const SizedBox(height: SolSpacing.xl),
          for (final (i, accion) in acciones.indexed) ...[
            if (i > 0) const SizedBox(height: SolSpacing.sm),
            accion,
          ],
        ],
      ),
    );
  }
}

/// Línea de tiempo del envío: guardado, en qué va y la llegada a la
/// aseguradora.
class _Seguimiento extends StatelessWidget {
  const _Seguimiento({
    required this.reporte,
    required this.progreso,
    required this.conectado,
    required this.esperaWifi,
    required this.sinSesion,
  });

  final ReporteGuardado reporte;
  final ProgresoCola progreso;
  final bool conectado;
  final bool esperaWifi;
  final bool sinSesion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final r = reporte;
    final locale = Localizations.localeOf(context);
    String cuando(DateTime t) =>
        '${SolFormat.date(t.toLocal())}, '
        '${SolFormat.timeFor(t.toLocal(), locale)}';
    final enviado = r.estado == EstadoLocal.enviado;

    final SolTimelineStep actual = switch (r.estado) {
      EstadoLocal.borrador => SolTimelineStep(
        title: l10n.m0506SinTerminar,
        subtitle: l10n.m0507bBorradorNota,
        state: SolTimelineState.current,
      ),
      EstadoLocal.pendiente when !conectado => SolTimelineStep(
        title: l10n.m0507bEsperandoConexion,
        subtitle: l10n.m0507bEsperandoConexionNota,
        state: SolTimelineState.current,
        status: SolStatus.warning,
      ),
      EstadoLocal.pendiente when sinSesion => SolTimelineStep(
        title: l10n.m0507bEsperandoSesion,
        subtitle: l10n.avisoReporteSesionCuerpo,
        state: SolTimelineState.current,
        status: SolStatus.warning,
      ),
      EstadoLocal.pendiente when esperaWifi => SolTimelineStep(
        title: l10n.m0506EsperandoWifi,
        subtitle: l10n.m0507bEsperandoWifiNota,
        state: SolTimelineState.current,
        status: SolStatus.warning,
      ),
      EstadoLocal.pendiente => SolTimelineStep(
        title: l10n.m0507bEnCola,
        subtitle: switch (r.proximoIntentoEn) {
          final t? => l10n.m0507bReintento(
            SolFormat.timeFor(t.toLocal(), locale),
          ),
          null => l10n.m0507bEnColaNota,
        },
        state: SolTimelineState.current,
      ),
      EstadoLocal.enviando => SolTimelineStep(
        title: l10n.m0506Enviando,
        subtitle: progreso.enviando == r.id
            ? progreso.radicando
                  ? l10n.avisoReporteRadicando
                  : '${l10n.avisoReporteFoto(progreso.foto.clamp(1, progreso.fotos), progreso.fotos)}'
                        ' · ${l10n.m0504Porcentaje(progreso.porcentajeReporte)}'
            : null,
        state: SolTimelineState.current,
      ),
      EstadoLocal.conError => SolTimelineStep(
        title: l10n.m0507bNoAceptado,
        subtitle: l10n.m0507bNoAceptadoNota,
        state: SolTimelineState.current,
        status: SolStatus.error,
      ),
      EstadoLocal.necesitaAtencion => SolTimelineStep(
        title: l10n.m0506NecesitaAtencion,
        subtitle: l10n.m0507bErrorTecnico,
        state: SolTimelineState.current,
        status: SolStatus.error,
      ),
      EstadoLocal.enviado => SolTimelineStep(
        title: l10n.m0507bRecibido,
        subtitle: switch (r.enviadoEn) {
          final t? => cuando(t),
          null => null,
        },
        state: SolTimelineState.done,
        status: SolStatus.success,
      ),
    };

    return SolTimeline(
      steps: [
        SolTimelineStep(
          title: l10n.m0507bGuardadoTelefono,
          subtitle: cuando(r.guardadoEn ?? r.creadoEn),
          state: SolTimelineState.done,
        ),
        actual,
        if (!enviado)
          SolTimelineStep(
            title: l10n.m0507bRecibido,
            subtitle: l10n.m0507bRecibidoNota,
            state: SolTimelineState.upcoming,
          ),
      ],
      stateLabels: {
        SolTimelineState.done: l10n.m0507EstadoCompletado,
        SolTimelineState.current: l10n.m0507EstadoActual,
        SolTimelineState.upcoming: l10n.m0507EstadoPendiente,
      },
    );
  }
}

class _Fotos extends ConsumerWidget {
  const _Fotos({required this.fotos});

  final List<FotoGuardada> fotos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    Widget hueco() => ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Icon(SolIcons.camera, color: colors.outline),
    );
    return Wrap(
      spacing: SolSpacing.sm,
      runSpacing: SolSpacing.sm,
      children: [
        for (final (i, foto) in fotos.indexed)
          Semantics(
            image: true,
            label: l10n.m0504Foto(i + 1),
            child: SizedBox.square(
              dimension: 96,
              child: ClipRRect(
                borderRadius: SolRadius.fieldAll,
                child: ExcludeSemantics(
                  child: switch (ref
                      .watch(_fotoGuardadaProvider(foto.id))
                      .value) {
                    final bytes? => Image.memory(
                      bytes,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (_, _, _) => hueco(),
                    ),
                    null => hueco(),
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Datos extends StatelessWidget {
  const _Datos({required this.reporte});

  final ReporteGuardado reporte;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final r = reporte;
    final poliza = r.poliza;
    final locale = Localizations.localeOf(context);
    final filas = <(String, String)>[
      if (poliza != null)
        (l10n.m0507bPoliza, [poliza.numero, ?poliza.vehiculo].join(' · ')),
      if (r.tipoAuto case final tipo?)
        (l10n.m0507bQuePaso, nombreTipoAuto(l10n, tipo)),
      if (r.ocurridoEn case final t?)
        (
          l10n.m0507bCuando,
          '${SolFormat.date(t.toLocal())}, '
              '${SolFormat.timeFor(t.toLocal(), locale)}',
        ),
      if (r.lugar.trim().isNotEmpty || r.ciudad.trim().isNotEmpty)
        (
          l10n.m0507bDonde,
          [
            r.lugar.trim(),
            r.ciudad.trim(),
          ].where((t) => t.isNotEmpty).join(', '),
        ),
      if (r.descripcion.trim().isNotEmpty)
        (l10n.m0507Relato, r.descripcion.trim()),
      (
        l10n.m0507bFotos,
        l10n.m0507bFotosSubidas(r.fotos.length, r.fotosSubidas),
      ),
    ];
    return SolCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, (etiqueta, valor)) in filas.indexed)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : SolSpacing.sm),
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      etiqueta,
                      style: context.solText.body.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    Text(valor, style: context.solText.body),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
