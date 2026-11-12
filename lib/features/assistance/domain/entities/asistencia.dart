import 'prestador.dart';

/// Estado de una asistencia en sitio (contrato v0.40; `llego` desde la v0.52:
/// una confirmada cuya llegada ya pasó, derivado en el backend al leer).
enum EstadoAsistencia { confirmada, noConfirmada, cancelada, llego }

/// De dónde salió la ubicación del cliente (contrato v0.50, B4).
enum OrigenUbicacion { gps, direccion }

/// Lo que el cliente pide en M06-02. [idSolicitud] lo genera la app: es el id
/// de la asistencia y su clave de idempotencia (reenviar no crea otra).
final class SolicitudAsistencia {
  const SolicitudAsistencia({
    required this.idSolicitud,
    required this.prestador,
    required this.tipo,
    required this.ubicacion,
    this.origen = OrigenUbicacion.gps,
    this.descripcion = '',
    this.direccion = '',
  });

  final String idSolicitud;
  final Prestador prestador;
  final TipoPrestador tipo;

  /// Adónde debe llegar el prestador: el GPS del teléfono o la dirección que
  /// escribió el cliente, ya convertida en coordenadas (`ubicarDireccion`).
  final Coordenada ubicacion;
  final OrigenUbicacion origen;
  final String descripcion;

  /// Solo con [OrigenUbicacion.direccion]: la dirección ubicada.
  final String direccion;
}

/// Una sugerencia de `autocompletarDireccion` (Google Places por el ACL).
final class SugerenciaDireccion {
  const SugerenciaDireccion({required this.placeId, required this.descripcion});

  final String placeId;
  final String descripcion;
}

/// Resultado de `ubicarDireccion` (contrato v0.50). El backend no manda
/// textos: la app pone el mensaje en el idioma del usuario.
sealed class DireccionUbicada {
  const DireccionUbicada();
}

final class DireccionEncontrada extends DireccionUbicada {
  const DireccionEncontrada({
    required this.coordenada,
    required this.direccion,
  });

  final Coordenada coordenada;
  final String direccion;
}

/// Ni Places ni Geocoding la encontraron.
final class DireccionNoEncontrada extends DireccionUbicada {
  const DireccionNoEncontrada();
}

/// Google no respondió o el circuito del ACL está abierto: reintentar.
final class DireccionServicioCaido extends DireccionUbicada {
  const DireccionServicioCaido();
}

/// Adónde pidió el cliente la asistencia (v0.52, solo para él).
final class UbicacionSolicitud {
  const UbicacionSolicitud({
    required this.origen,
    this.coordenada,
    this.direccion,
  });

  final OrigenUbicacion origen;
  final Coordenada? coordenada;
  final String? direccion;
}

/// Respuesta del backend a solicitar o cancelar, y cada asistencia de «Mis
/// asistencias» (v0.52).
final class Asistencia {
  const Asistencia({
    required this.id,
    required this.estado,
    required this.prestador,
    required this.tipo,
    required this.solicitadaEn,
    this.minutosEstimados,
    this.canceladaEn,
    this.confirmadaEn,
    this.llegadaEstimada,
    this.descripcion,
    this.ubicacion,
  });

  final String id;
  final EstadoAsistencia estado;
  final Prestador prestador;
  final TipoPrestador tipo;
  final DateTime solicitadaEn;

  /// Solo en [EstadoAsistencia.confirmada].
  final int? minutosEstimados;
  final DateTime? canceladaEn;

  /// v0.52 (B5): para la cuenta regresiva y la notificación de llegada.
  final DateTime? confirmadaEn;
  final DateTime? llegadaEstimada;

  /// v0.52 (B6): lo que pidió y adónde; solo en «Mis asistencias» y su detalle.
  final String? descripcion;
  final UbicacionSolicitud? ubicacion;

  Asistencia conEstado(EstadoAsistencia nuevo) => Asistencia(
    id: id,
    estado: nuevo,
    prestador: prestador,
    tipo: tipo,
    solicitadaEn: solicitadaEn,
    minutosEstimados: minutosEstimados,
    canceladaEn: canceladaEn,
    confirmadaEn: confirmadaEn,
    llegadaEstimada: llegadaEstimada,
    descripcion: descripcion,
    ubicacion: ubicacion,
  );
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
