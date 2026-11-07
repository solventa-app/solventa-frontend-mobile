import 'dart:math' as math;

import 'entities/prestador.dart';

/// Reglas de cercanía de M06-01 (CA-M06-01). Dart puro: el catálogo es un dato
/// maestro que ya está en el teléfono, así que los 3 más cercanos se calculan
/// aquí, sin una llamada al backend por cada apertura del mapa.
abstract final class Cercania {
  static const double _radioTierraKm = 6371;

  /// Velocidad urbana promedio para estimar el tiempo de llegada.
  static const double velocidadKmH = 20;

  /// Minutos fijos de alistamiento del prestador antes de salir.
  static const int alistamientoMin = 2;

  /// Más lejos que esto no se ofrece (el prestador no llegaría a tiempo).
  static const double radioMaxKm = 50;

  /// Distancia en línea recta (fórmula de Haversine), en km.
  static double distanciaKm(Coordenada a, Coordenada b) {
    double rad(double g) => g * math.pi / 180;
    final dLat = rad(b.latitud - a.latitud);
    final dLon = rad(b.longitud - a.longitud);
    final h =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(a.latitud)) *
            math.cos(rad(b.latitud)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * _radioTierraKm * math.asin(math.sqrt(h));
  }

  /// Tiempo estimado de llegada en minutos (redondeado hacia arriba).
  static int minutosEstimados(double km) =>
      (km / velocidadKmH * 60).ceil() + alistamientoMin;

  /// Los [cantidad] prestadores más cercanos a [origen] dentro de
  /// [radioMaxKm], del más cercano al más lejano. Vacío si no hay ninguno.
  static List<PrestadorCercano> masCercanos(
    Coordenada origen,
    List<Prestador> catalogo, {
    int cantidad = 3,
  }) {
    final cercanos =
        [for (final p in catalogo) (p, distanciaKm(origen, p.ubicacion))]
            .where((e) => e.$2 <= radioMaxKm)
            .toList()
          ..sort((a, b) => a.$2.compareTo(b.$2));
    return [
      for (final (p, km) in cercanos.take(cantidad))
        PrestadorCercano(
          prestador: p,
          distanciaKm: km,
          minutosEstimados: minutosEstimados(km),
        ),
    ];
  }
}
