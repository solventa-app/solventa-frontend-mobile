import 'prestador.dart';

/// Estado de una asistencia en sitio (contrato v0.40).
enum EstadoAsistencia { confirmada, noConfirmada, cancelada }

/// Lo que el cliente pide en M06-02. [idSolicitud] lo genera la app: es el id
/// de la asistencia y su clave de idempotencia (reenviar no crea otra).
final class SolicitudAsistencia {
  const SolicitudAsistencia({
    required this.idSolicitud,
    required this.prestador,
    required this.tipo,
    required this.ubicacion,
    this.descripcion = '',
    this.direccion = '',
  });

  final String idSolicitud;
  final Prestador prestador;
  final TipoPrestador tipo;

  /// Adónde debe llegar el prestador (GPS del teléfono). `null` si el cliente
  /// no dio la ubicación y escribió la dirección a mano (CA-M06-02).
  final Coordenada? ubicacion;
  final String descripcion;
  final String direccion;
}

/// Respuesta del backend a solicitar o cancelar.
final class Asistencia {
  const Asistencia({
    required this.id,
    required this.estado,
    required this.prestador,
    required this.tipo,
    required this.solicitadaEn,
    this.minutosEstimados,
    this.canceladaEn,
  });

  final String id;
  final EstadoAsistencia estado;
  final Prestador prestador;
  final TipoPrestador tipo;
  final DateTime solicitadaEn;

  /// Solo en [EstadoAsistencia.confirmada].
  final int? minutosEstimados;
  final DateTime? canceladaEn;
}

/// Códigos de `ErrorAsistencia` (llegan como `FallaNegocio.motivo`).
abstract final class CodigosAsistencia {
  static const prestadorNoDisponible = 'PRESTADOR_NO_DISPONIBLE';
  static const tipoNoAtendido = 'TIPO_NO_ATENDIDO';
  static const datosInvalidos = 'DATOS_INVALIDOS';
  static const noEncontrada = 'NO_ENCONTRADA';
}

/// Límites del formulario M06-02 (los mismos que valida CLAIMS).
abstract final class ReglasSolicitud {
  static const maxDescripcion = 500;
  static const maxDireccion = 200;
}
