import '../../../../core/errors/falla.dart';
import '../../../../core/errors/resultado.dart';
import '../../domain/entities/asistencia.dart';
import '../../domain/entities/prestador.dart';

TipoPrestador _tipo(Object? valor) => switch (valor) {
  'MEDICO' => TipoPrestador.medico,
  'MECANICO' => TipoPrestador.mecanico,
  'GRUA' => TipoPrestador.grua,
  _ => throw FormatException('tipo de prestador desconocido: $valor'),
};

/// `solicitarAsistencia` / `cancelarAsistencia` (union `ResultadoAsistencia`)
/// → [Asistencia] o una [FallaNegocio] con el `codigo` del contrato.
Resultado<Asistencia> asistenciaDesdeMapa(Map<String, Object?> m) {
  if (m['__typename'] == 'ErrorAsistencia') {
    return Fracaso(FallaNegocio(m['codigo']! as String));
  }
  final p = m['prestador']! as Map<String, Object?>;
  return Exito(
    Asistencia(
      id: m['id']! as String,
      estado: switch (m['estado']) {
        'CONFIRMADA' => EstadoAsistencia.confirmada,
        'NO_CONFIRMADA' => EstadoAsistencia.noConfirmada,
        'CANCELADA' => EstadoAsistencia.cancelada,
        final otro => throw FormatException('estado desconocido: $otro'),
      },
      tipo: _tipo(m['tipoAsistencia']),
      prestador: Prestador(
        id: p['id']! as String,
        nombre: p['nombre']! as String,
        tipo: _tipo(p['tipo']),
        ciudad: (p['ciudad'] as String?) ?? '',
        ubicacion: Coordenada(
          (p['latitud']! as num).toDouble(),
          (p['longitud']! as num).toDouble(),
        ),
        aliado: p['aliado'] == true,
        especialidad: (p['especialidad'] as String?) ?? '',
        direccion: (p['direccion'] as String?) ?? '',
        horario: p['horario'] as String?,
        fotoUrl: p['fotoUrl'] as String?,
      ),
      minutosEstimados: (m['minutosEstimados'] as num?)?.toInt(),
      solicitadaEn: DateTime.parse(m['solicitadaEn']! as String),
      canceladaEn: switch (m['canceladaEn']) {
        final String f => DateTime.parse(f),
        _ => null,
      },
    ),
  );
}

/// [SolicitudAsistencia] → `SolicitudAsistenciaInput`. Los textos vacíos
/// viajan como `null` (son opcionales).
Map<String, Object?> entradaSolicitud(SolicitudAsistencia s) {
  String? opcional(String t) => t.trim().isEmpty ? null : t.trim();
  return {
    'idSolicitud': s.idSolicitud,
    'prestadorId': s.prestador.id,
    'tipoAsistencia': switch (s.tipo) {
      TipoPrestador.medico => 'MEDICO',
      TipoPrestador.mecanico => 'MECANICO',
      TipoPrestador.grua => 'GRUA',
    },
    'descripcion': opcional(s.descripcion),
    'direccion': opcional(s.direccion),
    'latitud': s.ubicacion.latitud,
    'longitud': s.ubicacion.longitud,
    'origenUbicacion': switch (s.origen) {
      OrigenUbicacion.gps => 'GPS',
      OrigenUbicacion.direccion => 'DIRECCION',
    },
  };
}

/// `data.ubicarDireccion` → [DireccionUbicada]. Un código desconocido se
/// trata como servicio caído (se puede reintentar).
DireccionUbicada direccionDesdeMapa(Map<String, Object?> m) {
  if (m['encontrada'] == true) {
    return DireccionEncontrada(
      coordenada: Coordenada(
        (m['latitud']! as num).toDouble(),
        (m['longitud']! as num).toDouble(),
      ),
      direccion: (m['direccion'] as String?) ?? '',
    );
  }
  return m['codigo'] == 'DIRECCION_NO_ENCONTRADA'
      ? const DireccionNoEncontrada()
      : const DireccionServicioCaido();
}
