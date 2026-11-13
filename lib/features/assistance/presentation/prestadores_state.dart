import '../../../core/errors/falla.dart';
import '../domain/entities/prestador.dart';

/// Estado de M06-01.
sealed class PrestadoresState {
  const PrestadoresState();
}

final class PrestadoresCargando extends PrestadoresState {
  const PrestadoresCargando();
}

/// Mapa y lista listos. Sin destacados = fuera de cobertura (M11).
final class PrestadoresListos extends PrestadoresState {
  const PrestadoresListos({
    required this.origen,
    required this.destacados,
    this.otros = const [],
    this.direccionEscrita,
    this.permisoDisponible = false,
    this.rutas = const {},
    this.rutasAproximadas = false,
  });

  /// Rutas por prestador (M15). Llegan después del mapa, sin bloquearlo.
  final Map<String, RutaPrestador> rutas;

  /// El backend no devolvió rutas (falla o circuito abierto): sin líneas y los
  /// tiempos de Haversine van marcados como aproximados (M15).
  final bool rutasAproximadas;

  /// GPS del teléfono o la dirección escrita ya ubicada (2.0).
  final Coordenada origen;

  /// Con la dirección escrita: el aviso «Usando: …» y el pin «Dirección
  /// escrita». `null` = GPS.
  final String? direccionEscrita;

  /// Con la dirección escrita, el permiso se dio al volver de Ajustes:
  /// aparece «Usar mi ubicación actual».
  final bool permisoDisponible;

  /// Los 3 más cercanos (pines grandes y lista inicial).
  final List<PrestadorCercano> destacados;

  /// El resto dentro del radio, por distancia (M1, M9).
  final List<PrestadorCercano> otros;

  /// Compatibilidad: los de la lista inicial.
  List<PrestadorCercano> get cercanos => destacados;

  PrestadoresListos conPermisoDisponible() => PrestadoresListos(
    origen: origen,
    destacados: destacados,
    otros: otros,
    direccionEscrita: direccionEscrita,
    permisoDisponible: true,
    rutas: rutas,
    rutasAproximadas: rutasAproximadas,
  );

  PrestadoresListos conRutas(List<RutaPrestador> lista) => PrestadoresListos(
    origen: origen,
    destacados: destacados,
    otros: otros,
    direccionEscrita: direccionEscrita,
    permisoDisponible: permisoDisponible,
    rutas: {for (final r in lista) r.prestadorId: r},
    rutasAproximadas: lista.isEmpty,
  );
}

/// La primera vez, antes del diálogo del sistema: por qué pedimos la
/// ubicación, con «Permitir ubicación» y «Escribir mi dirección» (2.0).
final class PrestadoresExplicacion extends PrestadoresState {
  const PrestadoresExplicacion();
}

/// Permiso negado (una vez o para siempre) o GPS apagado (2.0). Siempre hay
/// dos salidas: arreglarlo o escribir la dirección (CA-M06-02).
final class PrestadoresSinUbicacion extends PrestadoresState {
  const PrestadoresSinUbicacion({
    required this.permisoPermanente,
    required this.gpsApagado,
  });

  final bool permisoPermanente;
  final bool gpsApagado;
}

final class PrestadoresFallidos extends PrestadoresState {
  const PrestadoresFallidos(this.falla);
  final Falla falla;
}
