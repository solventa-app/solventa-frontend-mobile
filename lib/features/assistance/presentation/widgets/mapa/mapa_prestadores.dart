import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/prestador.dart';
import '../../providers.dart';
import 'mapa_datos.dart';
import 'mapa_falso.dart';
import 'mapa_mapbox.dart';

export 'mapa_datos.dart';

/// Mapa de M06-01. `mapa_mapbox.dart` y `mapa_falso.dart` son los únicos
/// archivos que conocen cómo se dibuja: cambiar de proveedor no toca la
/// página (plan de HU-M06, anexo A).
class MapaPrestadores extends ConsumerWidget {
  const MapaPrestadores({
    super.key,
    required this.datos,
    required this.orden,
    required this.onTapPrestador,
    required this.onTapVacio,
    required this.onGesto,
    required this.onFallo,
    required this.onSateliteFallo,
  });

  final DatosMapa datos;
  final OrdenCamara? orden;
  final ValueChanged<PrestadorCercano> onTapPrestador;
  final VoidCallback onTapVacio;
  final VoidCallback onGesto;

  /// El mapa no pudo cargar: la página muestra solo la lista (CA-M06-04).
  final VoidCallback onFallo;

  /// El satélite no cargó (p. ej. Mapbox rechaza sus teselas): la página vuelve
  /// a calles y el mapa sigue, en vez de esconderlo.
  final VoidCallback onSateliteFallo;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(motorMapaProvider)) {
        MotorMapa.mapbox => MapaMapbox(
          datos: datos,
          orden: orden,
          onTapPrestador: onTapPrestador,
          onTapVacio: onTapVacio,
          onGesto: onGesto,
          onFallo: onFallo,
          onSateliteFallo: onSateliteFallo,
        ),
        MotorMapa.falso => MapaFalso(
          datos: datos,
          onTapPrestador: onTapPrestador,
          onTapVacio: onTapVacio,
          onGesto: onGesto,
        ),
        MotorMapa.ninguno => const SizedBox.shrink(),
      };
}
