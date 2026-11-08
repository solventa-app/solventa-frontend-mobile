import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/prestador.dart';
import '../prestadores_state.dart';
import '../providers.dart';
import '../widgets/mapa_prestadores.dart';

/// M06-01 · Mapa de prestadores cercanos (Figma 2005:2, KAN-264).
///
/// Mapa arriba y hoja fija con los 3 prestadores abajo. Tocar un pin abre la
/// ruta en la app de mapas del teléfono; «Solicitar» lleva al formulario
/// (M06-02, KAN-265).
class M0601PrestadoresPage extends ConsumerStatefulWidget {
  const M0601PrestadoresPage({super.key, required this.onSolicitar});

  /// El prestador de la fila y la ubicación del cliente (adónde debe llegar).
  final void Function(PrestadorCercano cercano, Coordenada origen) onSolicitar;

  @override
  ConsumerState<M0601PrestadoresPage> createState() =>
      _M0601PrestadoresPageState();
}

class _M0601PrestadoresPageState extends ConsumerState<M0601PrestadoresPage> {
  late final AppLifecycleListener _ciclo;
  bool _mapaFallo = false;
  bool _volviendoDeAjustes = false;

  @override
  void initState() {
    super.initState();
    // Al volver de Ajustes (permiso o GPS) se reintenta solo.
    _ciclo = AppLifecycleListener(
      onResume: () {
        if (_volviendoDeAjustes) {
          _volviendoDeAjustes = false;
          unawaited(ref.read(prestadoresProvider.notifier).cargar());
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(ref.read(prestadoresProvider.notifier).cargar());
    });
  }

  @override
  void dispose() {
    _ciclo.dispose();
    super.dispose();
  }

  String _tipo(TipoPrestador t) => switch (t) {
    TipoPrestador.medico => context.l10n.m0601TipoMedico,
    TipoPrestador.mecanico => context.l10n.m0601TipoMecanico,
  };

  Future<void> _abrirRuta(PrestadorCercano c) async {
    final ok = await ref
        .read(rutaExternaServiceProvider)
        .abrirRuta(c.prestador.ubicacion, nombre: c.prestador.nombre);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.m0601RutaNoDisponible)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(prestadoresProvider);
    final notifier = ref.read(prestadoresProvider.notifier);

    return switch (estado) {
      PrestadoresCargando() => _Centro(
        child: SolLoadingState(message: l10n.m0601Buscando, center: true),
      ),
      PrestadoresFallidos(:final falla) => _Centro(
        child: _Aviso(
          texto: l10n.falla(falla),
          accion: falla.reintentable ? l10n.m0601Reintentar : null,
          onAccion: notifier.cargar,
        ),
      ),
      PrestadoresSinUbicacion(:final permisoPermanente, :final gpsApagado) =>
        _Centro(
          child: _Aviso(
            icono: SolIcons.location,
            texto: gpsApagado ? l10n.m0601GpsApagado : l10n.m0601SinPermiso,
            accion: permisoPermanente || gpsApagado
                ? l10n.m0601AbrirAjustes
                : l10n.m0601PermitirUbicacion,
            onAccion: permisoPermanente || gpsApagado
                ? () async {
                    _volviendoDeAjustes = true;
                    await notifier.abrirAjustes();
                  }
                : notifier.cargar,
          ),
        ),
      PrestadoresListos(:final origen, :final cercanos) => SolSheetLayout(
        maxSheetFactor: _mapaFallo ? 1 : 0.6,
        background: _mapaFallo
            ? const SizedBox.shrink()
            : MapaPrestadores(
                origen: origen,
                prestadores: cercanos,
                plantillaTeselas: ref.watch(plantillaTeselasProvider),
                atribucion: l10n.m0601Atribucion,
                etiquetaCliente: l10n.m0601TuUbicacion,
                etiquetaRuta: (c) => l10n.m0601ComoLlegar(
                  c.prestador.nombre,
                  SolFormat.minutes(c.minutosEstimados),
                ),
                onAbrirRuta: _abrirRuta,
                onFallo: () => setState(() => _mapaFallo = true),
              ),
        sheet: SolBottomSheetPanel(
          maxHeightFactor: _mapaFallo ? 1 : 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SolSectionHeader(
                title: l10n.m0601Titulo,
                count: cercanos.isEmpty
                    ? null
                    : l10n.m0601Disponibles(cercanos.length),
              ),
              if (cercanos.isEmpty)
                SolInlineNote(text: l10n.m0601SinPrestadores)
              else
                for (final (i, c) in cercanos.indexed) ...[
                  if (i > 0) const SolDivider(),
                  SolProviderRow(
                    name: c.prestador.nombre,
                    type: switch (c.prestador.tipo) {
                      TipoPrestador.medico => SolProviderType.medico,
                      TipoPrestador.mecanico => SolProviderType.mecanico,
                    },
                    typeLabel: _tipo(c.prestador.tipo),
                    distance: SolFormat.distanceKm(c.distanciaKm),
                    eta: SolFormat.minutes(c.minutosEstimados),
                    requestLabel: l10n.m0601Solicitar,
                    onRequest: () => widget.onSolicitar(c, origen),
                  ),
                ],
            ],
          ),
        ),
      ),
    };
  }
}

class _Centro extends StatelessWidget {
  const _Centro({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(SolSpacing.screen),
      child: child,
    ),
  );
}

class _Aviso extends StatelessWidget {
  const _Aviso({
    required this.texto,
    required this.accion,
    required this.onAccion,
    this.icono,
  });

  final String texto;
  final String? accion;
  final Future<void> Function() onAccion;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: SolInlineNote(icon: icono, text: texto, center: true),
        ),
        if (accion != null) ...[
          const SizedBox(height: SolSpacing.lg),
          SolButton.tonal(
            label: accion!,
            onPressed: () => unawaited(onAccion()),
          ),
        ],
      ],
    );
  }
}
