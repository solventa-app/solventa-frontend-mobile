import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../../core/design_system/solventa_ui.dart';
import '../../../../../core/log/sol_log.dart';
import '../../../domain/entities/prestador.dart';
import 'mapa_datos.dart';

/// Mapa de M06-01 con `mapbox_maps_flutter` (HU-M06, M0).
///
/// - Pines como anotaciones con imágenes de [SolMapPin] (M1, M3, M4).
/// - Sin rotación ni inclinación; sin brújula ni barra de escala. El logo y la
///   atribución de Mapbox **no se quitan** (lo exigen sus términos).
/// - Cámara: encuadre inicial con zoom máximo 16 y límites de zoom 11 a 18 y
///   de la zona (M7); enfoque con un solo `easeTo` de 400 ms, sin animación
///   si el sistema pide quitarlas (M6).
/// - Estilos calles y satélite (M14): al cambiar se conservan cámara, pines y
///   selección.
///
/// La vista nativa no se pinta en `flutter test`: las pruebas usan
/// `MapaFalso`. Verificar en un teléfono (ajuste A9).
class MapaMapbox extends StatefulWidget {
  const MapaMapbox({
    super.key,
    required this.datos,
    required this.orden,
    required this.onTapPrestador,
    required this.onTapVacio,
    required this.onGesto,
    required this.onFallo,
  });

  final DatosMapa datos;
  final OrdenCamara? orden;
  final ValueChanged<PrestadorCercano> onTapPrestador;
  final VoidCallback onTapVacio;
  final VoidCallback onGesto;
  final VoidCallback onFallo;

  static String estiloUri(EstiloMapa e) => switch (e) {
    EstiloMapa.calles => MapboxStyles.MAPBOX_STREETS,
    EstiloMapa.satelite => MapboxStyles.SATELLITE_STREETS,
  };

  @override
  State<MapaMapbox> createState() => _MapaMapboxState();
}

class _MapaMapboxState extends State<MapaMapbox> {
  MapboxMap? _mapa;
  PointAnnotationManager? _pines;
  final _porAnotacion = <String, PrestadorCercano>{};
  final _imagenes = <Object, Uint8List>{};
  final _suscripciones = <StreamSubscription<Object?>>[];
  Cancelable? _toques;
  DateTime _ultimoToquePin = DateTime(0);
  int _pintado = 0;
  int? _ordenAplicada;

  @override
  void didUpdateWidget(MapaMapbox old) {
    super.didUpdateWidget(old);
    final mapa = _mapa;
    if (mapa == null) return;
    if (old.datos.estilo != widget.datos.estilo) {
      unawaited(mapa.loadStyleURI(MapaMapbox.estiloUri(widget.datos.estilo)));
    }
    if (old.datos.seleccionadoId != widget.datos.seleccionadoId ||
        !identical(old.datos.destacados, widget.datos.destacados) ||
        !identical(old.datos.otros, widget.datos.otros)) {
      unawaited(_pintarPines());
    }
    if (widget.orden?.generacion != _ordenAplicada) {
      unawaited(_aplicarOrden());
    }
  }

  @override
  void dispose() {
    _toques?.cancel();
    for (final s in _suscripciones) {
      unawaited(s.cancel());
    }
    super.dispose();
  }

  Future<void> _creado(MapboxMap mapa) async {
    _mapa = mapa;
    try {
      await mapa.gestures.updateSettings(
        GesturesSettings(rotateEnabled: false, pitchEnabled: false),
      );
      await mapa.compass.updateSettings(CompassSettings(enabled: false));
      await mapa.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
      _pines = await mapa.annotations.createPointAnnotationManager();
      await _pines!.setIconAllowOverlap(true);
      _toques = _pines!.tapEvents(
        onTap: (a) {
          final c = _porAnotacion[a.id];
          if (c == null) return;
          _ultimoToquePin = DateTime.now();
          widget.onTapPrestador(c);
        },
      );
      mapa.addInteraction(
        TapInteraction.onMap((_) {
          // El toque en un pin también llega aquí: se ignora si fue un pin.
          if (DateTime.now().difference(_ultimoToquePin) >
              const Duration(milliseconds: 350)) {
            widget.onTapVacio();
          }
        }),
      );
      void gesto(MapContentGestureContext c) {
        if (c.gestureState == GestureState.started) widget.onGesto();
      }

      _suscripciones
        ..add(mapa.gestures.pan.gestureEvents.listen(gesto))
        ..add(mapa.gestures.zoom.gestureEvents.listen(gesto));
      await _limites();
      await _pintarPines();
      await _aplicarOrden();
    } catch (e) {
      // Sin datos del cliente: solo el tipo de error.
      SolLog.warning('Mapbox no inició', codigo: e.runtimeType.toString());
      if (mounted) widget.onFallo();
    }
  }

  Point _punto(Coordenada c) =>
      Point(coordinates: Position(c.longitud, c.latitud));

  /// Zoom 11 a 18 y la cámara no sale de la zona de los prestadores (M7).
  Future<void> _limites() async {
    final puntos = [
      widget.datos.origen,
      ...widget.datos.todos.map((c) => c.prestador.ubicacion),
    ];
    const margen = 0.08;
    final sur = puntos.map((c) => c.latitud).reduce(math.min) - margen;
    final norte = puntos.map((c) => c.latitud).reduce(math.max) + margen;
    final oeste = puntos.map((c) => c.longitud).reduce(math.min) - margen;
    final este = puntos.map((c) => c.longitud).reduce(math.max) + margen;
    await _mapa?.setBounds(
      CameraBoundsOptions(
        minZoom: 11,
        maxZoom: 18,
        bounds: CoordinateBounds(
          southwest: _punto(Coordenada(sur, oeste)),
          northeast: _punto(Coordenada(norte, este)),
          infiniteBounds: false,
        ),
      ),
    );
  }

  Future<Uint8List> _imagen(
    Object clave,
    Future<Uint8List> Function() crear,
  ) async => _imagenes[clave] ??= await crear();

  Future<void> _pintarPines() async {
    final pines = _pines;
    if (pines == null || !mounted) return;
    final turno = ++_pintado;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final colores = SolMapPinColors.of(context);
    final usuario = _colorUsuario(context);
    final datos = widget.datos;
    final opciones = <PointAnnotationOptions>[];
    final orden = <PrestadorCercano?>[];

    opciones.add(
      PointAnnotationOptions(
        geometry: _punto(datos.origen),
        image: await _imagen((
          'usuario',
          ratio,
        ), () => _pinUsuario(usuario, ratio)),
        symbolSortKey: 0,
      ),
    );
    orden.add(null);
    for (final (lista, destacado) in [
      (datos.otros, false),
      (datos.destacados, true),
    ]) {
      for (final c in lista) {
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
        final alto = style.sizeFor(SolMapPin.labelWidth(style)).height;
        final circulo = style.diameter + SolMapPinStyle.ring * 2;
        opciones.add(
          PointAnnotationOptions(
            geometry: _punto(p.ubicacion),
            image: await _imagen((
              style,
              ratio,
            ), () => SolMapPin.toPng(style, colores, pixelRatio: ratio)),
            // El centro del círculo sobre la coordenada (la etiqueta cuelga).
            iconOffset: [0, (alto - circulo) / 2],
            symbolSortKey:
                (style.selected ? 3 : 0) + (destacado ? 2 : 1).toDouble(),
          ),
        );
        orden.add(c);
      }
    }
    if (turno != _pintado || !mounted) return; // llegó otro pintado
    await pines.deleteAll();
    final creadas = await pines.createMulti(opciones);
    _porAnotacion.clear();
    for (final (i, a) in creadas.indexed) {
      final c = orden[i];
      if (a != null && c != null) _porAnotacion[a.id] = c;
    }
  }

  Future<void> _aplicarOrden() async {
    final mapa = _mapa;
    final orden = widget.orden;
    if (mapa == null || orden == null || orden.generacion == _ordenAplicada) {
      return;
    }
    _ordenAplicada = orden.generacion;
    final rapido = SolMotion.reduced(context);
    final relleno = MbxEdgeInsets(
      top: 96,
      left: 48,
      bottom: widget.datos.paddingInferior + 32,
      right: 48,
    );
    final CameraOptions destino;
    switch (orden) {
      case EncuadrarInicio():
        destino = await mapa.cameraForCoordinatesPadding(
          [
            _punto(widget.datos.origen),
            ...widget.datos.destacados.map(
              (c) => _punto(c.prestador.ubicacion),
            ),
          ],
          CameraOptions(),
          relleno,
          16,
          null,
        );
      case EnfocarPrestador(:final destino):
        final actual = await mapa.getCameraState();
        return _mover(
          mapa,
          CameraOptions(
            center: _punto(destino),
            zoom: math.max(actual.zoom, 15),
            padding: relleno,
          ),
          rapido,
        );
    }
    await _mover(mapa, destino, rapido);
  }

  Future<void> _mover(MapboxMap mapa, CameraOptions c, bool rapido) async {
    await mapa.cancelCameraAnimation();
    if (rapido) {
      await mapa.setCamera(c);
    } else {
      await mapa.easeTo(c, MapAnimationOptions(duration: 400));
    }
  }

  static Color _colorUsuario(BuildContext context) => context.colors.error;

  /// Punto del cliente con halo (M10), en PNG para la anotación.
  static Future<Uint8List> _pinUsuario(Color color, double ratio) async {
    const lado = SolMapUserPin.halo;
    final grabadora = ui.PictureRecorder();
    final lienzo = Canvas(grabadora)..scale(ratio);
    const centro = Offset(lado / 2, lado / 2);
    lienzo
      ..drawCircle(
        centro,
        lado / 2,
        Paint()..color = color.withValues(alpha: 0.18),
      )
      ..drawCircle(
        centro,
        SolMapUserPin.dot / 2 + 3,
        Paint()..color = Colors.white,
      )
      ..drawCircle(centro, SolMapUserPin.dot / 2, Paint()..color = color);
    final imagen = await grabadora.endRecording().toImage(
      (lado * ratio).ceil(),
      (lado * ratio).ceil(),
    );
    final bytes = await imagen.toByteData(format: ui.ImageByteFormat.png);
    imagen.dispose();
    return bytes!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) => MapWidget(
    key: const ValueKey('mapbox-m06-01'),
    styleUri: MapaMapbox.estiloUri(widget.datos.estilo),
    onMapCreated: (m) => unawaited(_creado(m)),
    onMapLoadErrorListener: (_) {
      SolLog.warning('Mapbox no cargó el estilo');
      if (mounted) widget.onFallo();
    },
  );
}
