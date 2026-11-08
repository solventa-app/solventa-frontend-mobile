import '../../../core/errors/falla.dart';
import '../domain/entities/prestador.dart';

/// Estado de M06-01.
sealed class PrestadoresState {
  const PrestadoresState();
}

final class PrestadoresCargando extends PrestadoresState {
  const PrestadoresCargando();
}

/// Lista lista (puede venir vacía: «no hay prestadores disponibles»).
final class PrestadoresListos extends PrestadoresState {
  const PrestadoresListos({required this.origen, required this.cercanos});

  final Coordenada origen;
  final List<PrestadorCercano> cercanos;
}

/// Sin permiso o con el GPS apagado (CA-M06-02).
final class PrestadoresSinUbicacion extends PrestadoresState {
  const PrestadoresSinUbicacion({
    required this.permisoPermanente,
    required this.gpsApagado,
  });

  final bool permisoPermanente;
  final bool gpsApagado;
}

/// Sin ubicación, el cliente eligió escribir la dirección (CA-M06-02): el
/// catálogo sin ordenar por cercanía.
final class PrestadoresSinOrden extends PrestadoresState {
  const PrestadoresSinOrden(this.prestadores);

  final List<Prestador> prestadores;
}

final class PrestadoresFallidos extends PrestadoresState {
  const PrestadoresFallidos(this.falla);
  final Falla falla;
}
