import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/asistencia.dart';
import '../mis_asistencias_notifier.dart';
import '../providers.dart';
import '../widgets/detalle_prestador.dart';
import '../widgets/tarjeta_asistencia.dart';
import 'mis_asistencias_page.dart';

/// Detalle de la asistencia (HU-M06, 4.4): «Tu asistencia».
///
/// Banner, prestador, estado («En camino · llega en 4 min», «Llegó · 9:26
/// a. m.» o «No pudimos confirmar»), qué pidió y cuándo, la dirección del
/// prestador con «Cómo llegar» y la acción según el estado: Cancelar (en
/// camino), Reintentar (no confirmada) o ninguna (ya llegó). Se abre desde
/// la pestaña o al tocar la notificación de llegada; atrás vuelve a «Mis
/// asistencias» en los dos casos.
class AsistenciaDetallePage extends ConsumerStatefulWidget {
  const AsistenciaDetallePage({
    super.key,
    required this.id,
    required this.onBack,
    required this.onPedirOtra,
  });

  final String id;
  final VoidCallback onBack;

  /// «Cancelar y pedir otra» (4.4b): al mapa.
  final VoidCallback onPedirOtra;

  @override
  ConsumerState<AsistenciaDetallePage> createState() =>
      _AsistenciaDetallePageState();
}

class _AsistenciaDetallePageState extends ConsumerState<AsistenciaDetallePage> {
  Resultado<Asistencia>? _r;
  bool _ocupado = false;

  @override
  void initState() {
    super.initState();
    unawaited(_cargar());
  }

  Future<void> _cargar() async {
    final r = await ref
        .read(asistenciaRepositoryProvider)
        .asistencia(widget.id);
    if (mounted) setState(() => _r = r);
  }

  Future<void> _accion(Future<void> Function() hacer) async {
    if (_ocupado) return;
    setState(() => _ocupado = true);
    await hacer();
    await _cargar();
    if (mounted) setState(() => _ocupado = false);
  }

  Future<bool> _confirmarCancelar(Asistencia a) {
    final l10n = context.l10n;
    return SolConfirmDialog.show(
      context,
      title: l10n.m0605Titulo,
      message: l10n.m0605Mensaje(a.prestador.nombre),
      confirmLabel: l10n.m0605Confirmar,
      cancelLabel: l10n.m0605Mantener,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mis = ref.watch(misAsistenciasProvider);
    final notifier = ref.read(misAsistenciasProvider.notifier);
    final colors = context.colors;

    Widget cuerpo;
    final List<Widget> acciones;
    switch (_r) {
      case null:
        cuerpo = SolLoadingState(
          message: l10n.misAsistenciasCargando,
          center: true,
        );
        acciones = const [];
      case Fracaso(:final falla):
        cuerpo = SolInlineNote(
          text: falla is FallaNegocio
              ? l10n.asistenciaNoEncontrada
              : l10n.falla(falla),
        );
        acciones = const [];
      case Exito(valor: final a):
        // El estado con el reloj de la pestaña: «Llegó» sin esperar al backend.
        final s = mis.copyWith(ahora: ref.read(relojProvider)());
        final llego = s.llego(a);
        final enCamino =
            !llego &&
            a.estado == EstadoAsistencia.confirmada &&
            a.llegadaEstimada != null;
        final noConfirmada = a.estado == EstadoAsistencia.noConfirmada;
        final estado = llego
            ? l10n.asistenciaLlego(
                SolFormat.time((a.llegadaEstimada ?? a.solicitadaEn).toLocal()),
              )
            : enCamino
            ? l10n.asistenciaEnCaminoLlega(
                '${(a.llegadaEstimada!.difference(s.ahora).inSeconds / 60).ceil().clamp(1, 999)}',
              )
            : noConfirmada
            ? l10n.asistenciaNoConfirmada
            : l10n.m0606Titulo;
        final tipo = nombreTipoAsistencia(l10n, a.tipo);
        final (fondo, frente) = solProviderColors(context, a.prestador.aliado);
        cuerpo = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SolPhotoBanner(
              photoUrl: a.prestador.fotoUrl,
              placeholderIcon: iconoTipoPrestador(a.prestador.tipo),
            ),
            const SizedBox(height: SolSpacing.md),
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SolCard.outlined(
                    child: Row(
                      children: [
                        ExcludeSemantics(
                          child: Container(
                            width: SolSizes.providerIcon,
                            height: SolSizes.providerIcon,
                            decoration: BoxDecoration(
                              color: fondo,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              iconoTipoPrestador(a.prestador.tipo),
                              size: 22,
                              fill: 1,
                              color: frente,
                            ),
                          ),
                        ),
                        const SizedBox(width: SolSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.prestador.nombre,
                                style: context.solText.title.copyWith(
                                  color: colors.onSurface,
                                ),
                              ),
                              if (a.prestador.aliado)
                                Text(
                                  l10n.m0601Aliado,
                                  style: context.solText.labelStrong.copyWith(
                                    color: colors.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SolSpacing.md),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SolStatusBadge(
                      status: llego
                          ? SolStatus.success
                          : enCamino
                          ? SolStatus.info
                          : SolStatus.warning,
                      label: estado,
                    ),
                  ),
                  const SizedBox(height: SolSpacing.sm),
                  Text(
                    l10n.asistenciaPedida(
                      tipo,
                      SolFormat.time(a.solicitadaEn.toLocal()),
                    ),
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  if ((a.descripcion ?? '').isNotEmpty) ...[
                    const SizedBox(height: SolSpacing.xs),
                    Text(
                      '«${a.descripcion}»',
                      style: context.solText.body.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (enCamino && mis.alejadas.contains(a.id)) ...[
              const SizedBox(height: SolSpacing.md),
              AvisoTeAlejaste(
                asistencia: a,
                onCancelar: () => unawaited(
                  _accion(() async {
                    if (!await _confirmarCancelar(a)) return;
                    if (await notifier.cancelar(a) && mounted) {
                      widget.onPedirOtra();
                    }
                  }),
                ),
              ),
            ],
            if (a.prestador.direccion.isNotEmpty) ...[
              const SizedBox(height: SolSpacing.md),
              SolInlineNote(
                icon: SolIcons.location,
                text: a.prestador.direccion,
              ),
            ],
            const SizedBox(height: SolSpacing.md),
            SolButton.tonal(
              label: l10n.m0601ComoLlegarBoton,
              onPressed: () => unawaited(
                ref
                    .read(rutaExternaServiceProvider)
                    .abrirRuta(
                      a.prestador.ubicacion,
                      nombre: a.prestador.nombre,
                    ),
              ),
            ),
          ],
        );
        acciones = [
          if (enCamino)
            SolButton.destructive(
              label: l10n.m0604aCancelar,
              onPressed: _ocupado
                  ? null
                  : () => unawaited(
                      _accion(() async {
                        if (await _confirmarCancelar(a)) {
                          await notifier.cancelar(a);
                        }
                      }),
                    ),
            )
          else if (noConfirmada)
            SolButton.primary(
              label: l10n.asistenciaReintentar,
              onPressed: _ocupado
                  ? null
                  : () => unawaited(_accion(() => notifier.reintentar(a))),
            ),
        ];
    }

    return SolFlowScaffold(
      title: l10n.asistenciaDetalleTitulo,
      onBack: widget.onBack,
      anchorActions: false,
      body: cuerpo,
      actions: acciones,
    );
  }
}
