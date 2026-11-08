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
