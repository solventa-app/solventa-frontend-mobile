import '../../domain/entities/prestador.dart';

/// `catalogoPrestadores.prestadores[i]` → [Prestador]. Un `tipo` desconocido o
/// un prestador inactivo se descartan (`null`) sin romper el catálogo.
Prestador? prestadorDesdeMapa(Map<String, Object?> m) {
  if (m['activo'] == false) return null;
  final tipo = switch (m['tipo']) {
    'MEDICO' => TipoPrestador.medico,
    'MECANICO' => TipoPrestador.mecanico,
    _ => null,
  };
  if (tipo == null) return null;
  return Prestador(
    id: m['id']! as String,
    nombre: m['nombre']! as String,
    tipo: tipo,
    ciudad: (m['ciudad'] as String?) ?? '',
    ubicacion: Coordenada(
      (m['latitud']! as num).toDouble(),
      (m['longitud']! as num).toDouble(),
    ),
  );
}

/// `data.catalogoPrestadores` → [CatalogoPrestadores].
CatalogoPrestadores catalogoDesdeMapa(Map<String, Object?> m) {
  final lista = (m['prestadores']! as List<Object?>)
      .cast<Map<String, Object?>>();
  return CatalogoPrestadores(
    version: m['version']! as String,
    prestadores: lista.map(prestadorDesdeMapa).whereType<Prestador>().toList(),
  );
}
