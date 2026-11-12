import '../../domain/entities/prestador.dart';

/// `catalogoPrestadores.prestadores[i]` → [Prestador]. Un `tipo` desconocido o
/// un prestador inactivo se descartan (`null`) sin romper el catálogo.
Prestador? prestadorDesdeMapa(Map<String, Object?> m) {
  if (m['activo'] == false) return null;
  final tipo = switch (m['tipo']) {
    'MEDICO' => TipoPrestador.medico,
    'MECANICO' => TipoPrestador.mecanico,
    'GRUA' => TipoPrestador.grua,
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
    // v0.49: una copia guardada antes de esa versión no los trae.
    aliado: m['aliado'] == true,
    especialidad: (m['especialidad'] as String?) ?? '',
    direccion: (m['direccion'] as String?) ?? '',
    horario: m['horario'] as String?,
    fotoUrl: m['fotoUrl'] as String?,
  );
}

/// La copia local es anterior al contrato v0.49 (sin `aliado`): se vuelve a
/// pedir el catálogo aunque no hayan pasado los 7 días.
bool copiaSinDetalle(Map<String, Object?> catalogo) {
  final lista = catalogo['prestadores'];
  if (lista is! List<Object?> || lista.isEmpty) return false;
  final primero = lista.first;
  return primero is Map<String, Object?> && !primero.containsKey('aliado');
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
