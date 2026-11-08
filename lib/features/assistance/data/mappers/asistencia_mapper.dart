import '../../../../core/errors/falla.dart';
import '../../../../core/errors/resultado.dart';
import '../../domain/entities/asistencia.dart';
import '../../domain/entities/prestador.dart';

TipoPrestador _tipo(Object? valor) => switch (valor) {
  'MEDICO' => TipoPrestador.medico,
  'MECANICO' => TipoPrestador.mecanico,
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
    },
    'descripcion': opcional(s.descripcion),
    'direccion': opcional(s.direccion),
    'latitud': s.ubicacion!.latitud,
    'longitud': s.ubicacion!.longitud,
  };
}

/// [SolicitudAsistencia] sin ubicación → `SolicitudAsistenciaDireccionInput`
/// (contrato v0.41, CA-M06-02). La dirección es obligatoria.
Map<String, Object?> entradaSolicitudConDireccion(SolicitudAsistencia s) {
  final descripcion = s.descripcion.trim();
  return {
    'idSolicitud': s.idSolicitud,
    'prestadorId': s.prestador.id,
    'tipoAsistencia': switch (s.tipo) {
      TipoPrestador.medico => 'MEDICO',
      TipoPrestador.mecanico => 'MECANICO',
    },
    'direccion': s.direccion.trim(),
    'descripcion': descripcion.isEmpty ? null : descripcion,
  };
}
