import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../domain/entities/prestador.dart';

/// Mapa de M06-01 con `flutter_map` (decisión D-M06): pin del cliente al
/// centro y un pin por prestador con su tiempo estimado.
///
/// Con [plantillaTeselas] vacía no descarga teselas (pruebas y goldens). Si
/// las teselas fallan varias veces seguidas llama a [onFallo] y la página
/// muestra solo la lista (CA-M06-04).
class MapaPrestadores extends StatefulWidget {
  const MapaPrestadores({
    super.key,
    required this.origen,
    required this.prestadores,
    required this.plantillaTeselas,
    required this.atribucion,
    required this.etiquetaCliente,
    required this.etiquetaRuta,
    required this.onAbrirRuta,
    required this.onFallo,
  });

  final Coordenada origen;
  final List<PrestadorCercano> prestadores;
  final String plantillaTeselas;

  /// «© OpenStreetMap», obligatoria por la política de uso de OSM.
  final String atribucion;
  final String etiquetaCliente;

  /// Lectura de TalkBack del pin: «Cómo llegar a Clínica Norte, 6 min».
  final String Function(PrestadorCercano) etiquetaRuta;
  final ValueChanged<PrestadorCercano> onAbrirRuta;
  final VoidCallback onFallo;

  static const _fallosAntesDeOcultar = 4;

  @override
  State<MapaPrestadores> createState() => _MapaPrestadoresState();
}

class _MapaPrestadoresState extends State<MapaPrestadores> {
  int _fallos = 0;

  LatLng _ll(Coordenada c) => LatLng(c.latitud, c.longitud);

  void _alFallarTesela(TileImage _, Object _, StackTrace? _) {
    _fallos++;
    if (_fallos == MapaPrestadores._fallosAntesDeOcultar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onFallo();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sol = context.solColors;
    final puntos = [
      _ll(widget.origen),
      for (final p in widget.prestadores) _ll(p.prestador.ubicacion),
    ];

    return ColoredBox(
      color: sol.successContainer,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _ll(widget.origen),
          initialZoom: 14,
          initialCameraFit: puntos.length > 1
              ? CameraFit.coordinates(
                  coordinates: puntos,
                  padding: const EdgeInsets.fromLTRB(56, 48, 56, 72),
                  maxZoom: 16,
                )
              : null,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          backgroundColor: sol.successContainer,
        ),
        children: [
          if (widget.plantillaTeselas.isNotEmpty)
            TileLayer(
              urlTemplate: widget.plantillaTeselas,
              userAgentPackageName: 'com.solventa.solventa_mobile',
              errorTileCallback: _alFallarTesela,
            ),
          MarkerLayer(
            markers: [
              for (final p in widget.prestadores)
                Marker(
                  point: _ll(p.prestador.ubicacion),
                  width: 64,
                  height: 64,
                  child: _PinPrestador(
                    prestador: p,
                    etiqueta: widget.etiquetaRuta(p),
                    onTap: () => widget.onAbrirRuta(p),
                  ),
                ),
              Marker(
                point: _ll(widget.origen),
                width: SolSizes.minTouchTarget,
                height: SolSizes.minTouchTarget,
                child: _PinCliente(etiqueta: widget.etiquetaCliente),
              ),
            ],
          ),
          if (widget.plantillaTeselas.isNotEmpty)
            // Atribución que exige la política de uso de OSM.
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: ColoredBox(
                color: context.colors.surface.withValues(alpha: 0.8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SolSpacing.xs,
                    vertical: SolSpacing.xxs,
                  ),
                  child: Text(
                    widget.atribucion,
                    style: context.solText.note.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PinCliente extends StatelessWidget {
  const _PinCliente({required this.etiqueta});

  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: etiqueta,
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.error,
            shape: BoxShape.circle,
            border: Border.all(color: colors.surface, width: 2),
            boxShadow: [
              BoxShadow(
                color: colors.error.withValues(alpha: 0.25),
                blurRadius: 0,
                spreadRadius: 12,
              ),
            ],
          ),
          child: Icon(
            SolIcons.location,
            size: 20,
            fill: 1,
            color: colors.onError,
          ),
        ),
      ),
    );
  }
}

/// Pin de prestador: círculo con el ícono del tipo y píldora con el tiempo.
/// Al tocarlo abre la ruta en la app de mapas del teléfono.
class _PinPrestador extends StatelessWidget {
  const _PinPrestador({
    required this.prestador,
    required this.etiqueta,
    required this.onTap,
  });

  final PrestadorCercano prestador;
  final String etiqueta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final (Color fg, IconData icon) = switch (prestador.prestador.tipo) {
      TipoPrestador.medico => (sol.success, SolIcons.medical),
      TipoPrestador.mecanico => (colors.primary, SolIcons.mechanic),
    };
    return Semantics(
      button: true,
      label: etiqueta,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: sol.softShadow, blurRadius: 4)],
              ),
              child: Icon(icon, size: 18, fill: 1, color: fg),
            ),
            const SizedBox(height: SolSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SolSpacing.sm,
                vertical: SolSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: SolRadius.fullAll,
                boxShadow: [BoxShadow(color: sol.softShadow, blurRadius: 4)],
              ),
              child: Text(
                SolFormat.minutes(prestador.minutosEstimados),
                style: context.solText.labelStrong.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
