import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/asistencia.dart';
import '../mis_asistencias_notifier.dart';
import '../providers.dart';
import '../widgets/tarjeta_asistencia.dart';

/// «Mis asistencias» (HU-M06, 4.1 a 4.5): pestaña de la barra inferior.
///
/// Dos acordeones: «En camino» abierto (cuenta regresiva, y las no
/// confirmadas con «Reintentar») y «Ya llegaron» cerrado. Si uno queda vacío
/// se oculta; si los dos, el estado vacío. Recarga al hacerse visible y al
/// volver a primer plano; el reloj de 1 s corre solo mientras está visible.
/// Con la pestaña abierta, la llegada se avisa con «X llegó · Ver».
class MisAsistenciasPage extends ConsumerStatefulWidget {
  const MisAsistenciasPage({
    super.key,
    required this.visible,
    required this.onVerDetalle,
    required this.onSolicitar,
  });

  /// La pestaña está a la vista (la barra la mantiene viva en un
  /// `IndexedStack`).
  final bool visible;
  final ValueChanged<String> onVerDetalle;

  /// Estado vacío y «Cancelar y pedir otra»: a la pestaña Asistencia.
  final VoidCallback onSolicitar;

  @override
  ConsumerState<MisAsistenciasPage> createState() => _MisAsistenciasPageState();
}

class _MisAsistenciasPageState extends ConsumerState<MisAsistenciasPage> {
  late final AppLifecycleListener _ciclo;
  final Set<String> _reintentando = {};

  MisAsistenciasNotifier get _notifier =>
      ref.read(misAsistenciasProvider.notifier);

  @override
  void initState() {
    super.initState();
    _ciclo = AppLifecycleListener(
      onResume: () {
        if (!widget.visible) return;
        unawaited(_notifier.cargar());
        _notifier.activar();
      },
      onPause: () => _notifier.pausar(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.visible) _entrar();
    });
  }

  @override
  void didUpdateWidget(MisAsistenciasPage old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) _entrar();
    if (!widget.visible && old.visible) _notifier.pausar();
  }

  void _entrar() {
    unawaited(_notifier.cargar());
    _notifier.activar();
  }

  @override
  void dispose() {
    _ciclo.dispose();
    super.dispose();
  }

  Future<void> _reintentar(Asistencia a) async {
    if (!_reintentando.add(a.id)) return;
    setState(() {});
    await _notifier.reintentar(a);
    if (mounted) setState(() => _reintentando.remove(a.id));
  }

  /// 4.4b: confirmación de M06-05 y, si se canceló, al mapa.
  Future<void> _cancelarYPedirOtra(Asistencia a) async {
    final l10n = context.l10n;
    final ok = await SolConfirmDialog.show(
      context,
      title: l10n.m0605Titulo,
      message: l10n.m0605Mensaje(a.prestador.nombre),
      confirmLabel: l10n.m0605Confirmar,
      cancelLabel: l10n.m0605Mantener,
    );
    if (!ok || !mounted) return;
    if (await _notifier.cancelar(a) && mounted) widget.onSolicitar();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = ref.watch(misAsistenciasProvider);

    // 4.5: con la app abierta, en vez de la notificación del sistema.
    ref.listen(misAsistenciasProvider.select((s) => s.recienLlegadas), (
      _,
      nuevas,
    ) {
      if (nuevas.isEmpty || !widget.visible) return;
      _notifier.olvidarRecienLlegadas();
      final a = nuevas.last;
      final aviso = l10n.asistenciaLlegoSnack(a.prestador.nombre);
      SemanticsService.sendAnnouncement(
        View.of(context),
        aviso,
        Directionality.of(context),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(aviso),
          action: SnackBarAction(
            label: l10n.asistenciaVer,
            onPressed: () => widget.onVerDetalle(a.id),
          ),
        ),
      );
    });

    if (s.cargando && s.asistencias.isEmpty) {
      return SolLoadingState(
        message: l10n.misAsistenciasCargando,
        center: true,
      );
    }
    final enCamino = s.enCamino;
    final yaLlegaron = s.yaLlegaron;

    Widget tarjeta(Asistencia a) => tarjetaAsistencia(
      context,
      a,
      s,
      onTap: () => widget.onVerDetalle(a.id),
      onRetry: _reintentando.contains(a.id) ? null : () => _reintentar(a),
      notice: s.alejadas.contains(a.id)
          ? AvisoTeAlejaste(
              asistencia: a,
              onCancelar: () => _cancelarYPedirOtra(a),
            )
          : null,
    );

    return RefreshIndicator(
      onRefresh: _notifier.cargar,
      child: ListView(
        padding: const EdgeInsets.all(SolSpacing.screen),
        children: [
          SolAdaptiveBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.misAsistenciasTitulo,
                    style: context.solText.headline.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: SolSpacing.lg),
                if (s.falla != null && s.asistencias.isEmpty) ...[
                  SolInlineNote(text: l10n.misAsistenciasError),
                  const SizedBox(height: SolSpacing.sm),
                  SolButton.tonal(
                    label: l10n.asistenciaReintentar,
                    onPressed: () => unawaited(_notifier.cargar()),
                  ),
                ] else if (enCamino.isEmpty && yaLlegaron.isEmpty) ...[
                  SolInlineNote(text: l10n.misAsistenciasVacio, center: true),
                  const SizedBox(height: SolSpacing.lg),
                  SolButton.primary(
                    label: l10n.misAsistenciasSolicitar,
                    onPressed: widget.onSolicitar,
                  ),
                ] else ...[
                  if (enCamino.isNotEmpty)
                    SolAccordion(
                      key: const ValueKey('en-camino'),
                      title: l10n.misAsistenciasEnCamino('${enCamino.length}'),
                      children: [
                        for (final (i, a) in enCamino.indexed) ...[
                          if (i > 0) const SolDivider(),
                          tarjeta(a),
                        ],
                      ],
                    ),
                  if (enCamino.isNotEmpty && yaLlegaron.isNotEmpty)
                    const SizedBox(height: SolSpacing.md),
                  if (yaLlegaron.isNotEmpty)
                    SolAccordion(
                      key: const ValueKey('ya-llegaron'),
                      title: l10n.misAsistenciasYaLlegaron(
                        '${yaLlegaron.length}',
                      ),
                      initiallyExpanded: false,
                      children: [
                        for (final (i, a) in yaLlegaron.indexed) ...[
                          if (i > 0) const SolDivider(),
                          tarjeta(a),
                        ],
                      ],
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// «Te alejaste del lugar donde pediste la asistencia…» con «Cancelar y pedir
/// otra» (4.4b). La hora de llegada no se recalcula.
class AvisoTeAlejaste extends StatelessWidget {
  const AvisoTeAlejaste({
    super.key,
    required this.asistencia,
    required this.onCancelar,
  });

  final Asistencia asistencia;
  final VoidCallback onCancelar;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destino =
        asistencia.ubicacion?.direccion ?? l10n.asistenciaLugarPedido;
    return SolStatusBanner(
      status: SolStatus.warning,
      title: l10n.asistenciaTeAlejaste(destino),
      action: SolButton.outlined(
        label: l10n.asistenciaCancelarYPedirOtra,
        onPressed: onCancelar,
      ),
    );
  }
}
