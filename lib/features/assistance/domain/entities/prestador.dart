/// Punto geográfico en grados decimales (WGS84).
final class Coordenada {
  const Coordenada(this.latitud, this.longitud);

  final double latitud;
  final double longitud;

  @override
  bool operator ==(Object other) =>
      other is Coordenada &&
      other.latitud == latitud &&
      other.longitud == longitud;

  @override
  int get hashCode => Object.hash(latitud, longitud);
}

/// Especialidad del prestador (M06-01).
enum TipoPrestador { medico, mecanico }

/// Prestador del catálogo maestro (dato de referencia, cambia poco).
final class Prestador {
  const Prestador({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.ubicacion,
    required this.ciudad,
  });

  final String id;
  final String nombre;
  final TipoPrestador tipo;
  final Coordenada ubicacion;
  final String ciudad;

  @override
  bool operator ==(Object other) => other is Prestador && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Catálogo maestro de prestadores con su versión (la asigna el backend).
final class CatalogoPrestadores {
  const CatalogoPrestadores({required this.version, required this.prestadores});

  final String version;
  final List<Prestador> prestadores;
}

/// Un prestador del catálogo visto desde la ubicación del cliente.
final class PrestadorCercano {
  const PrestadorCercano({
    required this.prestador,
    required this.distanciaKm,
    required this.minutosEstimados,
  });

  final Prestador prestador;
  final double distanciaKm;
  final int minutosEstimados;
}
