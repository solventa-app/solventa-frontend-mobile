import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/navegacion/volver.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import 'm05_01_poliza_page.dart' show nombreTipoAuto;

/// M05-07 · Detalle de un siniestro del cliente (contrato v0.54, `miSiniestro`).
/// Sin frame en Figma: sistema de diseño.
///
/// De arriba abajo: resumen (radicado, estado, qué pasó y el plazo), carrusel
/// con las fotos que envió (se abren a pantalla completa con zoom), la línea de
/// tiempo, la póliza, lo que reportó (plegable) y, si ya se resolvió, el monto
/// o el motivo del rechazo con cómo pedir una revisión.
///
/// Mientras el caso está `PENDIENTE` cuenta el tiempo que queda (cada medio
/// minuto). Al llegar a cero, si el sistema lo aprueba solo
/// (`apruebaAlVencer`), la pantalla vuelve a consultar hasta ver el cambio; si
/// el operador debe valorar el daño (auto parcial o RC) lo dice y no consulta
/// en bucle.
class M0507DetalleSiniestroPage extends ConsumerStatefulWidget {
  const M0507DetalleSiniestroPage({
    required this.id,
    this.ahora = DateTime.now,
    this.cadaCuanto = const Duration(seconds: 30),
    super.key,
    this.onHome,
  });

  /// Casita al inicio en la barra superior (en lugar del avatar).
  final VoidCallback? onHome;

  final String id;

  /// El reloj; las pruebas lo fijan.
  final DateTime Function() ahora;

  /// Cada cuánto se redibuja el tiempo restante y, vencido el plazo, se
  /// vuelve a consultar el caso.
  final Duration cadaCuanto;

  @override
  ConsumerState<M0507DetalleSiniestroPage> createState() =>
      _M0507DetalleSiniestroPageState();
}

class _M0507DetalleSiniestroPageState
    extends ConsumerState<M0507DetalleSiniestroPage> {
  Timer? _reloj;

  /// Fotos cuya URL firmada ya se pidió de nuevo: una sola vez cada una, para
  /// no consultar en bucle si el archivo de verdad no está.
  final Set<String> _renovadas = {};

  @override
  void initState() {
    super.initState();
    _reloj = Timer.periodic(widget.cadaCuanto, (_) {
      if (!mounted) return;
      final caso = _caso();
      // Vencido, sin resolver y con aprobación automática: CLAIMS ya debió
      // aprobarlo; se consulta de nuevo sin esperar a que el cliente tire.
      if (caso != null &&
          caso.estado == 'PENDIENTE' &&
          caso.apruebaAlVencer &&
          !widget.ahora().isBefore(caso.venceDictamenEn)) {
        ref.invalidate(miSiniestroProvider(widget.id));
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }

  DetalleSiniestro? _caso() =>
      switch (ref.read(miSiniestroProvider(widget.id)).value) {
        Exito(:final valor) => valor,
        _ => null,
      };

  void _renovarFoto(String fotoId) {
    if (!_renovadas.add(fotoId)) return;
    ref.invalidate(miSiniestroProvider(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final detalle = ref.watch(miSiniestroProvider(widget.id));

    // `value` conserva lo último que llegó mientras se vuelve a consultar: la
    // pantalla no salta al esqueleto en cada vuelta.
    final cuerpo = switch (detalle.value) {
      Exito(valor: final caso?) => _Detalle(
        caso: caso,
        ahora: widget.ahora(),
        onFotoNoDisponible: _renovarFoto,
      ),
      Exito(valor: null) => SolInlineNote(
        text: l10n.m0507NoEncontrado,
        center: true,
      ),
      Fracaso(:final falla) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SolInlineNote(text: l10n.falla(falla)),
          SolButton.text(
            label: l10n.m05Reintentar,
            onPressed: () => ref.invalidate(miSiniestroProvider(widget.id)),
          ),
        ],
      ),
      null => SolSkeletonGroup(
        message: l10n.m0506Cargando,
        child: const _EsqueletoDetalle(),
      ),
    };

    return SolFlowScaffold(
      title: l10n.m0507Titulo,
      onBack: context.volverOInicio,
      onHomeTap: widget.onHome,
      body: RefreshIndicator(
        onRefresh: () {
          _renovadas.clear();
          return ref.refresh(miSiniestroProvider(widget.id).future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: SolSpacing.xxl),
          children: [cuerpo],
        ),
      ),
    );
  }
}

/// Estado del caso → color e insignia (el texto lo dice; no solo el color).
(SolStatus, String) estadoDelCaso(AppLocalizations l10n, String estado) =>
    switch (estado) {
      'EN_REVISION' => (SolStatus.warning, l10n.m0506EnRevision),
      'APROBADO' => (SolStatus.success, l10n.m0506Aprobado),
      'RECHAZADO' => (SolStatus.error, l10n.m0506Rechazado),
      _ => (SolStatus.info, l10n.m0506Pendiente),
    };

/// «1 d 4 h 20 min» hasta [vence]; `null` si ya venció.
String? tiempoRestante(DateTime vence, DateTime ahora) {
  final falta = vence.difference(ahora);
  if (falta <= Duration.zero) return null;
  final dias = falta.inDays;
  final horas = falta.inHours % 24;
  final minutos = falta.inMinutes % 60;
  return [
    if (dias > 0) '$dias d',
    if (dias > 0 || horas > 0) '$horas h',
    '$minutos min',
  ].join(' ');
}

class _Detalle extends StatelessWidget {
  const _Detalle({
    required this.caso,
    required this.ahora,
    required this.onFotoNoDisponible,
  });

  final DetalleSiniestro caso;
  final DateTime ahora;
  final ValueChanged<String> onFotoNoDisponible;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolucion = caso.resolucion;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Resumen(caso: caso, ahora: ahora),
        if (caso.fotos.isNotEmpty) ...[
          const SizedBox(height: SolSpacing.lg),
          _Titulo(l10n.m0507Fotos),
          _Fotos(caso: caso, onNoDisponible: onFotoNoDisponible),
        ],
        const SizedBox(height: SolSpacing.lg),
        _Titulo(l10n.m0507Seguimiento),
        SolCard.outlined(child: _Seguimiento(caso: caso)),
        if (resolucion != null && resolucion.tipo != 'DERIVACION') ...[
          const SizedBox(height: SolSpacing.lg),
          _Resolucion(resolucion: resolucion),
        ],
        const SizedBox(height: SolSpacing.lg),
        _Poliza(poliza: caso.poliza),
        const SizedBox(height: SolSpacing.sm),
        _LoQueReportaste(caso: caso),
      ],
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: SolSpacing.sm),
    child: Semantics(
      header: true,
      child: Text(texto, style: context.solText.title),
    ),
  );
}

class _Resumen extends StatelessWidget {
  const _Resumen({required this.caso, required this.ahora});

  final DetalleSiniestro caso;
  final DateTime ahora;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (status, estado) = estadoDelCaso(l10n, caso.estado);
    final tipo = caso.tipoAuto;
    final pendiente = caso.estado == 'PENDIENTE';
    final restante = tiempoRestante(caso.venceDictamenEn, ahora);
    final suave = context.solText.body.copyWith(color: colors.onSurfaceVariant);

    return SolCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: SolSpacing.sm,
            runSpacing: SolSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(caso.radicado, style: context.solText.headline),
              SolStatusBadge(status: status, label: estado),
            ],
          ),
          if (tipo != null) ...[
            const SizedBox(height: SolSpacing.xs),
            Text(nombreTipoAuto(l10n, tipo), style: context.solText.body),
          ],
          const SizedBox(height: SolSpacing.xs),
          Text(
            l10n.m0506Reportado(
              SolFormat.date(caso.notificadoEn.toLocal()),
              caso.fotos.length,
            ),
            style: suave,
          ),
          if (pendiente) ...[
            const SizedBox(height: SolSpacing.md),
            if (restante != null)
              _Plazo(
                icono: SolIcons.schedule,
                status: SolStatus.info,
                texto: l10n.m0507Restante(restante),
                detalle: l10n.m0506PendienteDetalle(
                  SolFormat.date(caso.venceDictamenEn.toLocal()),
                ),
              )
            else
              _Plazo(
                icono: SolIcons.schedule,
                status: SolStatus.warning,
                texto: caso.apruebaAlVencer
                    ? l10n.m0507PlazoVencido
                    : l10n.m0507ValorandoDano,
              ),
          ],
          if (caso.estado == 'EN_REVISION') ...[
            const SizedBox(height: SolSpacing.xs),
            Text(l10n.m0506EnRevisionDetalle, style: context.solText.body),
          ],
        ],
      ),
    );
  }
}

class _Plazo extends StatelessWidget {
  const _Plazo({
    required this.icono,
    required this.status,
    required this.texto,
    this.detalle,
  });

  final IconData icono;
  final SolStatus status;
  final String texto;
  final String? detalle;

  @override
  Widget build(BuildContext context) {
    final estilo = SolStatusStyle.of(context, status);
    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: estilo.container,
          borderRadius: SolRadius.cardAll,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SolSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, size: 20, color: estilo.foreground),
              const SizedBox(width: SolSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texto,
                      style: context.solText.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (detalle case final d?)
                      Text(d, style: context.solText.body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fotos extends StatelessWidget {
  const _Fotos({required this.caso, required this.onNoDisponible});

  final DetalleSiniestro caso;
  final ValueChanged<String> onNoDisponible;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = caso.fotos.length;
    final fotos = [
      for (final (i, f) in caso.fotos.indexed)
        SolPhoto(url: f.url, semanticLabel: l10n.m0507Foto(i + 1, total)),
    ];
    final prefijo = 'siniestro-${caso.id}';
    return SolPhotoCarousel(
      photos: fotos,
      heroTagPrefix: prefijo,
      unavailableLabel: l10n.m0507FotoNoDisponible,
      // La URL firmada vence en minutos: si una foto no carga se pide el
      // detalle de nuevo (una vez por foto).
      onUnavailable: () {
        for (final f in caso.fotos) {
          if (f.url.isNotEmpty) onNoDisponible(f.id);
        }
      },
      onOpen: (i) => unawaited(
        SolPhotoViewer.open(
          context,
          photos: fotos,
          initialIndex: i,
          heroTagPrefix: prefijo,
          closeLabel: l10n.m0507CerrarFoto,
          unavailableLabel: l10n.m0507FotoNoDisponible,
        ),
      ),
    );
  }
}

class _Seguimiento extends StatelessWidget {
  const _Seguimiento({required this.caso});

  final DetalleSiniestro caso;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hitos = caso.historial;
    final resuelto = caso.estado == 'APROBADO' || caso.estado == 'RECHAZADO';
    final pasos = [
      for (final (i, h) in hitos.indexed)
        SolTimelineStep(
          title: switch (h.estado) {
            'EN_REVISION' => l10n.m0507HitoRevision,
            'APROBADO' => l10n.m0507HitoAprobado,
            'RECHAZADO' => l10n.m0507HitoRechazado,
            _ => l10n.m0507HitoReportado,
          },
          subtitle: SolFormat.date(h.en.toLocal()),
          // El último hito es el paso actual mientras el caso no se resuelve.
          state: i == hitos.length - 1 && !resuelto
              ? SolTimelineState.current
              : SolTimelineState.done,
          status: switch (h.estado) {
            'APROBADO' => SolStatus.success,
            'RECHAZADO' => SolStatus.error,
            _ => null,
          },
        ),
      if (!resuelto)
        SolTimelineStep(
          title: l10n.m0507HitoResolucion,
          subtitle: caso.estado == 'PENDIENTE'
              ? l10n.m0507HitoResolucionPlazo(
                  SolFormat.date(caso.venceDictamenEn.toLocal()),
                )
              : null,
          state: SolTimelineState.upcoming,
        ),
    ];
    return SolTimeline(
      steps: pasos,
      stateLabels: {
        SolTimelineState.done: l10n.m0507EstadoCompletado,
        SolTimelineState.current: l10n.m0507EstadoActual,
        SolTimelineState.upcoming: l10n.m0507EstadoPendiente,
      },
    );
  }
}

class _Resolucion extends StatelessWidget {
  const _Resolucion({required this.resolucion});

  final ResolucionSiniestro resolucion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    Widget linea(String texto) => Padding(
      padding: const EdgeInsets.only(top: SolSpacing.xs),
      child: Text(
        texto,
        style: context.solText.body.copyWith(color: colors.onSurfaceVariant),
      ),
    );
    final aprobado = resolucion.tipo == 'APROBACION';
    return SolCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(l10n.m0507Resolucion, style: context.solText.title),
          ),
          linea(
            l10n.m0507ResueltoEl(
              SolFormat.date(resolucion.resueltaEn.toLocal()),
            ),
          ),
          if (aprobado) ...[
            if (resolucion.indemnizacion case final monto?)
              Padding(
                padding: const EdgeInsets.only(top: SolSpacing.sm),
                child: Text(
                  l10n.m0507Indemnizacion(SolFormat.currency(monto)),
                  style: context.solText.title.copyWith(
                    color: context.solColors.success,
                  ),
                ),
              ),
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

class _Poliza extends StatelessWidget {
  const _Poliza({required this.poliza});

  final PolizaDelCaso poliza;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return MergeSemantics(
      child: SolCard.outlined(
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(SolSpacing.sm),
                child: Icon(
                  poliza.esAuto ? SolIcons.car : SolIcons.shield,
                  size: 24,
                  color: colors.primary,
                ),
              ),
            ),
            const SizedBox(width: SolSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.m0507Poliza,
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  if (poliza.vehiculo case final v?)
                    Text(v, style: context.solText.title),
                  Text(
                    l10n.m0507PolizaNumero(poliza.numero),
                    style: context.solText.body,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoQueReportaste extends StatelessWidget {
  const _LoQueReportaste({required this.caso});

  final DetalleSiniestro caso;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    Widget dato(String etiqueta, String valor) => Padding(
      padding: const EdgeInsets.only(top: SolSpacing.sm),
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
    );
    return SolAccordion(
      title: l10n.m0507LoQueReportaste,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            SolSpacing.lg,
            0,
            SolSpacing.lg,
            SolSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.m0507Ocurrio(SolFormat.date(caso.ocurridoEn.toLocal())),
                style: context.solText.body,
              ),
              dato(l10n.m0507Lugar, '${caso.lugar}, ${caso.ciudad}'),
              dato(l10n.m0507Relato, caso.descripcion),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mientras llega el detalle: la forma del resumen, del carrusel y de la línea
/// de tiempo, para que la pantalla no salte cuando aparece.
class _EsqueletoDetalle extends StatelessWidget {
  const _EsqueletoDetalle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolCard.outlined(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: SolSkeleton(widthFactor: 0.5, height: 24)),
                  SolSkeleton(width: 88, height: 24, radius: SolRadius.fullAll),
                ],
              ),
              SizedBox(height: SolSpacing.sm),
              SolSkeleton(widthFactor: 0.8, height: 14),
              SizedBox(height: SolSpacing.xs),
              SolSkeleton(widthFactor: 0.6, height: 14),
            ],
          ),
        ),
        SizedBox(height: SolSpacing.lg),
        SolSkeleton(height: 200, radius: SolRadius.cardAll),
        SizedBox(height: SolSpacing.lg),
        SolSkeleton(height: 120, radius: SolRadius.cardAll),
      ],
    );
  }
}
