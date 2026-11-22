import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/navegacion/volver.dart';
import '../../../claims/domain/entities/reporte_siniestro.dart';
import '../../domain/entities/asistencia.dart';
import '../../domain/entities/prestador.dart';
import '../asistencia_routes.dart';
import '../providers.dart';

/// M06-02 · Formulario de solicitud (Figma 2005:140, KAN-148).
///
/// Banner «Atención inmediata» (S2), prestador elegido en M06-01, tipo de
/// asistencia prellenado con el del prestador (S3, se puede cambiar), qué pasó
/// (opcional) y adónde llegará: la ubicación detectada o la dirección que el
/// cliente escribió antes del mapa (S1: aquí ya no se escribe). v0.55
/// (KAN-36): la póliza de **auto** que cubre la asistencia; las hipotecarias no
/// se ofrecen, si tiene una sola viene elegida y sin ninguna vigente no se
/// puede enviar.
/// «Enviar solicitud» pasa a M06-03.
class M0602SolicitudPage extends ConsumerStatefulWidget {
  const M0602SolicitudPage({super.key, this.onHome});

  /// Casita al inicio en la barra superior (en lugar del avatar).
  final VoidCallback? onHome;

  @override
  ConsumerState<M0602SolicitudPage> createState() => _M0602SolicitudPageState();
}

class _M0602SolicitudPageState extends ConsumerState<M0602SolicitudPage> {
  late final TextEditingController _descripcion;
  final _claveTipo = GlobalKey();
  final _clavePoliza = GlobalKey();
  bool _intentoEnviar = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(solicitudProvider);
    _descripcion = TextEditingController(text: s.descripcion);
    // Con una sola póliza de auto vigente, viene elegida.
    ref.listenManual(polizasAsistenciaProvider, (_, polizas) {
      final vigentes = _vigentes(polizas.value);
      if (vigentes.length == 1 &&
          ref.read(solicitudProvider).polizaId == null) {
        ref.read(solicitudProvider.notifier).fijarPoliza(vigentes.single.id);
      }
    }, fireImmediately: true);
  }

  /// Las pólizas de auto que cubren hoy (solo las de auto llegan aquí).
  static List<PolizaReportable> _vigentes(
    Resultado<List<PolizaReportable>>? r,
  ) => switch (r) {
    Exito(:final valor) => [
      for (final p in valor)
        if (p.esAuto && p.cubre(DateTime.now())) p,
    ],
    _ => const [],
  };

  static String _nombrePoliza(AppLocalizations l10n, PolizaReportable p) =>
      p.vehiculo ?? l10n.m0602PolizaNumero(p.numero);

  Future<void> _elegirPoliza(List<PolizaReportable> vigentes) async {
    if (vigentes.isEmpty) return;
    final l10n = context.l10n;
    final elegida = await SolBottomSheet.show<String>(
      context,
      builder: (hoja) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SolSectionHeader(title: l10n.m0602Poliza),
          for (final p in vigentes)
            ListTile(
              minTileHeight: 56,
              leading: const Icon(SolIcons.car),
              title: Text(_nombrePoliza(l10n, p)),
              subtitle: p.vehiculo == null
                  ? null
                  : Text(l10n.m0602PolizaNumero(p.numero)),
              selected: ref.read(solicitudProvider).polizaId == p.id,
              onTap: () => Navigator.pop(hoja, p.id),
            ),
        ],
      ),
    );
    if (elegida != null) {
      ref.read(solicitudProvider.notifier).fijarPoliza(elegida);
    }
  }

  @override
  void dispose() {
    _descripcion.dispose();
    super.dispose();
  }

  String _nombreTipo(TipoPrestador t) => switch (t) {
    TipoPrestador.medico => context.l10n.m0602TipoMedica,
    TipoPrestador.mecanico => context.l10n.m0602TipoMecanica,
    TipoPrestador.grua => context.l10n.m0602TipoGrua,
  };

  Future<void> _elegirTipo() async {
    final elegido = await SolBottomSheet.show<TipoPrestador>(
      context,
      builder: (hoja) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SolSectionHeader(title: context.l10n.m0602Tipo),
          for (final t in TipoPrestador.values)
            ListTile(
              minTileHeight: 56,
              title: Text(_nombreTipo(t)),
              selected: ref.read(solicitudProvider).tipo == t,
              onTap: () => Navigator.pop(hoja, t),
            ),
        ],
      ),
    );
    if (elegido != null) {
      ref.read(solicitudProvider.notifier).fijarTipo(elegido);
    }
  }

  void _enviar() {
    setState(() => _intentoEnviar = true);
    final s = ref.read(solicitudProvider);
    if (!s.listoParaEnviar) {
      // CA M06-02: el error queda bajo el selector y se lleva la vista allí.
      final destino = s.polizaId == null
          ? _clavePoliza.currentContext
          : s.tipo == null || s.tipoNoAtendido
          ? _claveTipo.currentContext
          : null;
      if (destino != null) Scrollable.ensureVisible(destino);
      return;
    }
    context.push(AsistenciaRoutes.enviando);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(solicitudProvider);
    final notifier = ref.read(solicitudProvider.notifier);
    final cercano = estado.cercano;
    final prestador = estado.prestador;
    if (prestador == null) return const SizedBox.shrink();

    final errorTipo = !_intentoEnviar
        ? null
        : estado.tipo == null
        ? l10n.m0602TipoRequerido
        : estado.tipoNoAtendido
        ? l10n.m0602TipoNoAtendido(prestador.nombre)
        : null;
    final descripcionLarga =
        estado.descripcion.trim().length > ReglasSolicitud.maxDescripcion;
    final polizas = ref.watch(polizasAsistenciaProvider);
    final vigentes = _vigentes(polizas.value);
    final cargandoPolizas = polizas.value == null;
    final fallaPolizas = switch (polizas.value) {
      Fracaso(:final falla) => falla,
      _ => null,
    };
    final sinPoliza =
        !cargandoPolizas && fallaPolizas == null && vigentes.isEmpty;
    final polizaElegida = vigentes
        .where((p) => p.id == estado.polizaId)
        .firstOrNull;
    final errorPoliza = _intentoEnviar && estado.polizaId == null && !sinPoliza
        ? l10n.m0602PolizaRequerida
        : null;

    return SolFlowScaffold(
      title: l10n.m0602Titulo,
      onBack: context.volverOInicio,
      onHomeTap: salirAlInicioConfirmando(context, widget.onHome),
      anchorActions: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SolPhotoBanner(
            photoUrl: prestador.fotoUrl,
            placeholderIcon: switch (prestador.tipo) {
              TipoPrestador.medico => SolIcons.medical,
              TipoPrestador.mecanico => SolIcons.mechanic,
              TipoPrestador.grua => SolIcons.towTruck,
            },
            title: l10n.m0602AtencionInmediata,
            subtitle: l10n.m0602AtencionInmediataTexto,
            height: 96,
            strongVeil: true,
          ),
          const SizedBox(height: SolSpacing.lg),
          _TarjetaPrestador(
            rotulo: l10n.m0602PrestadorAsignado,
            prestador: prestador,
          ),
          const SizedBox(height: SolSpacing.lg),
          KeyedSubtree(
            key: _clavePoliza,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (sinPoliza) ...[
                  SolStatusBanner(
                    status: SolStatus.warning,
                    title: l10n.m0602SinPoliza,
                  ),
                  const SizedBox(height: SolSpacing.sm),
                ],
                Semantics(
                  liveRegion: errorPoliza != null,
                  child: SolTextField.select(
                    label: l10n.m0602Poliza,
                    value: cargandoPolizas
                        ? l10n.m0602PolizaCargando
                        : polizaElegida != null
                        ? _nombrePoliza(l10n, polizaElegida)
                        : l10n.m0602PolizaElegir,
                    errorText: errorPoliza,
                    onTap: () => _elegirPoliza(vigentes),
                  ),
                ),
                if (fallaPolizas != null) ...[
                  SolInlineNote(text: l10n.falla(fallaPolizas)),
                  SolButton.text(
                    label: l10n.reintentar,
                    onPressed: () => ref.invalidate(polizasAsistenciaProvider),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          KeyedSubtree(
            key: _claveTipo,
            child: Semantics(
              liveRegion: errorTipo != null,
              child: SolTextField.select(
                label: l10n.m0602Tipo,
                value: estado.tipo == null
                    ? l10n.m0602TipoElegir
                    : _nombreTipo(estado.tipo!),
                errorText: errorTipo,
                onTap: _elegirTipo,
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          SolTextField(
            label: l10n.m0602Descripcion,
            hint: l10n.m0602DescripcionHint,
            controller: _descripcion,
            minLines: 4,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            errorText: descripcionLarga
                ? l10n.m0602TextoLargo(ReglasSolicitud.maxDescripcion)
                : null,
            onChanged: (v) => notifier.fijarTextos(descripcion: v),
          ),
          const SizedBox(height: SolSpacing.md),
          SolInlineNote(
            icon: SolIcons.location,
            text: switch ((estado.direccionEscrita, estado.origen)) {
              (final String d, _) => l10n.m0602UbicacionEscrita(d),
              (_, final u?) => l10n.m0602UbicacionDetectada(
                '${u.latitud.toStringAsFixed(4)}, '
                '${u.longitud.toStringAsFixed(4)}',
              ),
              _ => '',
            },
          ),
          if (cercano != null) ...[
            const SizedBox(height: SolSpacing.sm),
            SolInlineNote(
              icon: SolIcons.schedule,
              text: l10n.m0602TiempoLlegada(
                SolFormat.minutes(cercano.minutosEstimados),
              ),
            ),
          ],
        ],
      ),
      actions: [
        // 4.5: antes del diálogo de notificaciones (Android 13+), para qué es.
        SolInlineNote(
          icon: SolIcons.notifications,
          text: l10n.asistenciaNotifNota,
        ),
        const SizedBox(height: SolSpacing.sm),
        SolButton.primary(label: l10n.m0602Enviar, onPressed: _enviar),
      ],
    );
  }
}

class _TarjetaPrestador extends StatelessWidget {
  const _TarjetaPrestador({required this.rotulo, required this.prestador});

  final String rotulo;
  final Prestador prestador;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
      child: SolCard.outlined(
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(switch (prestador.tipo) {
                TipoPrestador.medico => SolIcons.medical,
                TipoPrestador.mecanico => SolIcons.mechanic,
                TipoPrestador.grua => SolIcons.towTruck,
              }, color: colors.primary),
            ),
            const SizedBox(width: SolSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rotulo,
                    style: context.solText.note.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    prestador.nombre,
                    style: context.solText.title.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            ExcludeSemantics(
              child: Icon(
                SolIcons.verifiedProvider,
                color: context.solColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
