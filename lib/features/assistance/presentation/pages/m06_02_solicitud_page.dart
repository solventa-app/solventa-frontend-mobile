import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/asistencia.dart';
import '../../domain/entities/prestador.dart';
import '../asistencia_routes.dart';
import '../providers.dart';

/// M06-02 · Formulario de solicitud (Figma 2005:140, KAN-148).
///
/// Prestador elegido en M06-01, tipo de asistencia (obligatorio), qué pasó
/// (opcional) y la ubicación detectada con una dirección que el cliente puede
/// corregir. «Enviar solicitud» pasa a M06-03.
class M0602SolicitudPage extends ConsumerStatefulWidget {
  const M0602SolicitudPage({super.key});

  @override
  ConsumerState<M0602SolicitudPage> createState() => _M0602SolicitudPageState();
}

class _M0602SolicitudPageState extends ConsumerState<M0602SolicitudPage> {
  late final TextEditingController _descripcion;
  late final TextEditingController _direccion;
  final _claveTipo = GlobalKey();
  bool _intentoEnviar = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(solicitudProvider);
    _descripcion = TextEditingController(text: s.descripcion);
    _direccion = TextEditingController(text: s.direccion);
  }

  @override
  void dispose() {
    _descripcion.dispose();
    _direccion.dispose();
    super.dispose();
  }

  String _nombreTipo(TipoPrestador t) => switch (t) {
    TipoPrestador.medico => context.l10n.m0602TipoMedica,
    TipoPrestador.mecanico => context.l10n.m0602TipoMecanica,
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
      if (s.tipo == null || s.tipoNoAtendido) {
        final destino = _claveTipo.currentContext;
        if (destino != null) Scrollable.ensureVisible(destino);
      }
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
    if (cercano == null) return const SizedBox.shrink();
    final prestador = cercano.prestador;

    final errorTipo = !_intentoEnviar
        ? null
        : estado.tipo == null
        ? l10n.m0602TipoRequerido
        : estado.tipoNoAtendido
        ? l10n.m0602TipoNoAtendido(prestador.nombre)
        : null;
    final descripcionLarga =
        estado.descripcion.trim().length > ReglasSolicitud.maxDescripcion;
    final direccionLarga =
        estado.direccion.trim().length > ReglasSolicitud.maxDireccion;

    return SolFlowScaffold(
      title: l10n.m0602Titulo,
      onBack: () => context.pop(),
      anchorActions: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TarjetaPrestador(
            rotulo: l10n.m0602PrestadorAsignado,
            prestador: prestador,
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
          const SizedBox(height: SolSpacing.lg),
          SolTextField(
            label: l10n.m0602Direccion,
            hint: l10n.m0602DireccionHint,
            controller: _direccion,
            textInputAction: TextInputAction.done,
            errorText: direccionLarga
                ? l10n.m0602TextoLargo(ReglasSolicitud.maxDireccion)
                : null,
            onChanged: (v) => notifier.fijarTextos(direccion: v),
          ),
          if (estado.origen case final u?) ...[
            const SizedBox(height: SolSpacing.md),
            SolInlineNote(
              icon: SolIcons.location,
              text: l10n.m0602UbicacionDetectada(
                '${u.latitud.toStringAsFixed(4)}, '
                '${u.longitud.toStringAsFixed(4)}',
              ),
            ),
          ],
          const SizedBox(height: SolSpacing.sm),
          SolInlineNote(
            icon: SolIcons.schedule,
            text: l10n.m0602TiempoLlegada(
              SolFormat.minutes(cercano.minutosEstimados),
            ),
          ),
        ],
      ),
      actions: [SolButton.primary(label: l10n.m0602Enviar, onPressed: _enviar)],
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
              child: Icon(
                prestador.tipo == TipoPrestador.medico
                    ? SolIcons.medical
                    : SolIcons.mechanic,
                color: colors.primary,
              ),
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
