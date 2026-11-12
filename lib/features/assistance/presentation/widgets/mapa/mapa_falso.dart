import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/design_system/solventa_ui.dart';
import '../../../domain/entities/prestador.dart';
import 'mapa_datos.dart';

/// Mapa dibujado en Flutter para `API_ENV=mock`, las pruebas y los goldens.
///
/// No pide teselas ni token: una cuadrícula de calles (o tonos de satélite) y
/// los pines proyectados en línea recta, con el mismo [SolMapPin] que Mapbox.
/// Responde igual que el mapa real: tocar un pin, tocar el vacío y arrastrar.
/// No mueve la cámara (siempre muestra todos): las órdenes de cámara solo
/// importan en Mapbox.
class MapaFalso extends StatelessWidget {
  const MapaFalso({
    super.key,
    required this.datos,
    required this.onTapPrestador,
    required this.onTapVacio,
    required this.onGesto,
  });

  final DatosMapa datos;
  final ValueChanged<PrestadorCercano> onTapPrestador;
  final VoidCallback onTapVacio;
  final VoidCallback onGesto;

  @override
  Widget build(BuildContext context) {
    final satelite = datos.estilo == EstiloMapa.satelite;
    return LayoutBuilder(
      builder: (context, box) {
        final area = Rect.fromLTRB(
          48,
          96,
          box.maxWidth - 48,
          math.max(140, box.maxHeight - datos.paddingInferior - 48),
        );
        final puntos = [
          datos.origen,
          ...datos.todos.map((c) => c.prestador.ubicacion),
        ];
        final proyectar = _Proyeccion(puntos, area);
        final pines =
            [
              // Primero los pequeños: los destacados y el elegido quedan encima.
              for (final c in datos.otros) (c, false),
              for (final c in datos.destacados) (c, true),
            ]..sort((a, b) {
              int peso((PrestadorCercano, bool) e) =>
                  (e.$1.prestador.id == datos.seleccionadoId ? 2 : 0) +
                  (e.$2 ? 1 : 0);
              return peso(a).compareTo(peso(b));
            });
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTapVacio,
          onPanStart: (_) => onGesto(),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _Calles(
                    fondo: satelite
                        ? const Color(0xFF3F5A3A)
                        : context.colors.surfaceContainer,
                    calle: satelite
                        ? const Color(0xFF8A8F7A)
                        : context.colors.surface,
                  ),
                ),
              ),
              _posicionado(
                proyectar(datos.origen),
                Semantics(
                  label: datos.etiquetaUsuario,
                  child: SolMapUserPin(label: datos.etiquetaPinUsuario),
                ),
                SolMapUserPin.halo,
                SolMapUserPin.halo,
              ),
              for (final (c, destacado) in pines)
                _pin(context, c, destacado, proyectar(c.prestador.ubicacion)),
            ],
          ),
        );
      },
    );
  }

  Widget _pin(
    BuildContext context,
    PrestadorCercano c,
    bool destacado,
    Offset punto,
  ) {
    final p = c.prestador;
    final style = SolMapPinStyle(
      type: switch (p.tipo) {
        TipoPrestador.medico => SolProviderType.medico,
        TipoPrestador.mecanico => SolProviderType.mecanico,
        TipoPrestador.grua => SolProviderType.grua,
      },
      isPartner: p.aliado,
      featured: destacado,
      selected: p.id == datos.seleccionadoId,
      label: destacado ? datos.etiquetaTiempo(c) : null,
    );
    final size = style.sizeFor(SolMapPin.labelWidth(style));
    final circulo = style.diameter + SolMapPinStyle.ring * 2;
    return Positioned(
      key: ValueKey('pin-${p.id}'),
      left: punto.dx - size.width / 2,
      top: punto.dy - circulo / 2,
      child: Semantics(
        button: true,
        selected: style.selected,
        label: datos.semanticaPin(c),
        excludeSemantics: true,
        onTap: () => onTapPrestador(c),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTapPrestador(c),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: SolSizes.minTouchTarget,
              minHeight: SolSizes.minTouchTarget,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              widthFactor: 1,
              heightFactor: 1,
              child: SolMapPin(style: style),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _posicionado(
    Offset p,
    Widget hijo,
    double ancho,
    double alto,
  ) => Positioned(left: p.dx - ancho / 2, top: p.dy - alto / 2, child: hijo);
}

/// Proyección equirrectangular que mete todos los puntos en [area].
final class _Proyeccion {
  _Proyeccion(List<Coordenada> puntos, this.area)
    : _minLat = puntos.map((c) => c.latitud).reduce(math.min),
      _maxLat = puntos.map((c) => c.latitud).reduce(math.max),
      _minLon = puntos.map((c) => c.longitud).reduce(math.min),
      _maxLon = puntos.map((c) => c.longitud).reduce(math.max);

  final Rect area;
  final double _minLat;
  final double _maxLat;
  final double _minLon;
  final double _maxLon;

  Offset call(Coordenada c) {
    final dLon = math.max(_maxLon - _minLon, 1e-4);
    final dLat = math.max(_maxLat - _minLat, 1e-4);
    final escala = math.min(area.width / dLon, area.height / dLat);
    final ancho = dLon * escala;
    final alto = dLat * escala;
    final x0 = area.left + (area.width - ancho) / 2;
    final y0 = area.top + (area.height - alto) / 2;
    return Offset(
      x0 + (c.longitud - _minLon) * escala,
      y0 + (_maxLat - c.latitud) * escala,
    );
  }
}

class _Calles extends CustomPainter {
  const _Calles({required this.fondo, required this.calle});

  final Color fondo;
  final Color calle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = fondo);
    final linea = Paint()
      ..color = calle
      ..strokeWidth = 10;
    for (var x = 40.0; x < size.width; x += 120) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linea);
    }
    for (var y = 60.0; y < size.height; y += 140) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linea);
    }
  }

  @override
  bool shouldRepaint(_Calles old) => old.fondo != fondo || old.calle != calle;
}
