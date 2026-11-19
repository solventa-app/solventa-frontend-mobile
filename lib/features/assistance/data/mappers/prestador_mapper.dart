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
    codigoEspecialidad: especialidadDesdeCodigo(m['codigoEspecialidad']),
    horarioAtencion: horarioDesdeMapa(m['horarioAtencion']),
  );
}

/// v0.53: un código que la app no conoce queda `null` (se muestra el tipo).
EspecialidadPrestador? especialidadDesdeCodigo(Object? codigo) =>
    switch (codigo) {
      'URGENCIAS' => EspecialidadPrestador.urgencias,
      'MEDICINA_GENERAL' => EspecialidadPrestador.medicinaGeneral,
      'MECANICA_GENERAL' => EspecialidadPrestador.mecanicaGeneral,
      'LLANTAS_Y_FRENOS' => EspecialidadPrestador.llantasYFrenos,
      'GRUA_LIVIANA' => EspecialidadPrestador.gruaLiviana,
      'GRUA_Y_CARRO_TALLER' => EspecialidadPrestador.gruaYCarroTaller,
      _ => null,
    };

DiaSemana? _dia(Object? codigo) => switch (codigo) {
  'LUNES' => DiaSemana.lunes,
  'MARTES' => DiaSemana.martes,
  'MIERCOLES' => DiaSemana.miercoles,
  'JUEVES' => DiaSemana.jueves,
  'VIERNES' => DiaSemana.viernes,
  'SABADO' => DiaSemana.sabado,
  'DOMINGO' => DiaSemana.domingo,
  _ => null,
};

final _hora = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

/// v0.53: `horarioAtencion` → [HorarioAtencion]. Uno incompleto o mal formado
/// queda `null` (no se muestra horario) en vez de mostrar algo a medias.
HorarioAtencion? horarioDesdeMapa(Object? m) {
  if (m is! Map<String, Object?>) return null;
  final abierto24h = m['abierto24h'];
  if (abierto24h == true) return const HorarioAtencion(abierto24h: true);
  if (abierto24h != false) return null;
  final desde = _dia(m['diaDesde']);
  final hasta = _dia(m['diaHasta']);
  final abre = m['abre'];
  final cierra = m['cierra'];
  if (desde == null ||
      hasta == null ||
      abre is! String ||
      cierra is! String ||
      !_hora.hasMatch(abre) ||
      !_hora.hasMatch(cierra)) {
    return null;
  }
  return HorarioAtencion(
    abierto24h: false,
    diaDesde: desde,
    diaHasta: hasta,
    abre: abre,
    cierra: cierra,
  );
}

/// La copia local es anterior al contrato v0.49 (sin `aliado`) o a la v0.53
/// (sin `codigoEspecialidad`): se vuelve a pedir el catálogo aunque no hayan
/// pasado los 7 días.
bool copiaSinDetalle(Map<String, Object?> catalogo) {
  final lista = catalogo['prestadores'];
  if (lista is! List<Object?> || lista.isEmpty) return false;
  final primero = lista.first;
  return primero is Map<String, Object?> &&
      (!primero.containsKey('aliado') ||
          !primero.containsKey('codigoEspecialidad'));
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

/// Decodifica una polilínea de precisión 1e6 (`polyline6` de Mapbox).
List<Coordenada> decodificarPolyline6(String texto) {
  final puntos = <Coordenada>[];
  var i = 0;
  var lat = 0;
  var lon = 0;
  int siguiente() {
    var resultado = 0;
    var desplazamiento = 0;
    int b;
    do {
      b = texto.codeUnitAt(i++) - 63;
      resultado |= (b & 0x1F) << desplazamiento;
      desplazamiento += 5;
    } while (b >= 0x20);
    return (resultado & 1) != 0 ? ~(resultado >> 1) : resultado >> 1;
  }

  while (i < texto.length) {
    lat += siguiente();
    lon += siguiente();
    puntos.add(Coordenada(lat / 1e6, lon / 1e6));
  }
  return puntos;
}

/// Codifica en `polyline6` (para el fake, como el modo simulado del ACL).
String codificarPolyline6(List<Coordenada> puntos) {
  final b = StringBuffer();
  var previo = (0, 0);
  void escribir(int valor) {
    var v = valor < 0 ? ~(valor << 1) : valor << 1;
    while (v >= 0x20) {
      b.writeCharCode((0x20 | (v & 0x1F)) + 63);
      v >>= 5;
    }
    b.writeCharCode(v + 63);
  }

  for (final p in puntos) {
    final actual = ((p.latitud * 1e6).round(), (p.longitud * 1e6).round());
    escribir(actual.$1 - previo.$1);
    escribir(actual.$2 - previo.$2);
    previo = actual;
  }
  return b.toString();
}

/// `data.rutasPrestadores[i]` → [RutaPrestador].
RutaPrestador rutaDesdeMapa(Map<String, Object?> m) => RutaPrestador(
  prestadorId: m['prestadorId']! as String,
  distanciaMetros: (m['distanciaMetros']! as num).toInt(),
  duracionSegundos: (m['duracionSegundos']! as num).toInt(),
  puntos: switch (m['geometria']) {
    final String g when g.isNotEmpty => decodificarPolyline6(g),
    _ => const [],
  },
  estimado: m['estimado'] == true,
);
