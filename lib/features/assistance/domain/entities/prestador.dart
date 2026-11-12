import '../../../../core/ubicacion/coordenada.dart';

export '../../../../core/ubicacion/coordenada.dart';

/// Tipo de prestador (M06-01). `grua` desde el contrato v0.49.
enum TipoPrestador { medico, mecanico, grua }

/// Prestador del catálogo maestro (dato de referencia, cambia poco).
final class Prestador {
  const Prestador({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.ubicacion,
    required this.ciudad,
    this.aliado = false,
    this.especialidad = '',
    this.direccion = '',
    this.horario,
    this.fotoUrl,
  });

  final String id;
  final String nombre;
  final TipoPrestador tipo;
  final Coordenada ubicacion;
  final String ciudad;

  /// Aliado Solventa (v0.49): el color del pin y de la fila lo dice (M3).
  final bool aliado;

  /// «Urgencias», «Grúa liviana». Vacía si el catálogo aún no la trae.
  final String especialidad;

  /// Dirección de la sede. Vacía si el catálogo aún no la trae.
  final String direccion;

  /// «Abierto 24 h»; `null` si no se publica.
  final String? horario;

  /// Foto de la sede; `null` = placeholder del tipo.
  final String? fotoUrl;

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

/// Ruta de un prestador hasta el cliente (contrato v0.51, M15).
final class RutaPrestador {
  const RutaPrestador({
    required this.prestadorId,
    required this.distanciaMetros,
    required this.duracionSegundos,
    required this.puntos,
    required this.estimado,
  });

  final String prestadorId;
  final int distanciaMetros;
  final int duracionSegundos;

  /// Del prestador al cliente; vacía si el backend no mandó la geometría
  /// (solo la trae para los 3 destacados).
  final List<Coordenada> puntos;

  /// `true` = simulada (línea recta), no con tráfico real.
  final bool estimado;

  int get minutos => (duracionSegundos / 60).ceil();
}

/// Color de la ruta tipo semáforo (M15): verde hasta 10 min, amarillo de 10 a
/// 20 y rojo más de 20. El tiempo va también escrito: no depende del color.
enum Semaforo { verde, amarillo, rojo }

Semaforo semaforoDe(int minutos) => minutos <= 10
    ? Semaforo.verde
    : minutos <= 20
    ? Semaforo.amarillo
    : Semaforo.rojo;
