import '../../../domain/entities/prestador.dart';

/// Estilo del mapa (M14): calles por defecto; se recuerda la elección.
enum EstiloMapa { calles, satelite }

/// Qué motor dibuja el mapa de M06-01.
enum MotorMapa {
  /// `mapbox_maps_flutter` con el token público (M0).
  mapbox,

  /// Mapa dibujado en Flutter, sin red: `API_ENV=mock`, pruebas y goldens
  /// (la vista nativa de Mapbox no se pinta en `flutter test`).
  falso,

  /// Sin token fuera de mock: solo la lista, como si el mapa fallara
  /// (CA-M06-04).
  ninguno,
}

/// Una orden de cámara para el mapa. La [generacion] la hace única: una
/// orden nueva reemplaza a la anterior aunque apunte al mismo lugar (M6).
sealed class OrdenCamara {
  const OrdenCamara(this.generacion);

  final int generacion;
}

/// Cliente y destacados a la vista, sin pasar de zoom 16 (M7).
final class EncuadrarInicio extends OrdenCamara {
  const EncuadrarInicio(super.generacion);
}

/// Un solo movimiento suave hacia el prestador (M6).
final class EnfocarPrestador extends OrdenCamara {
  const EnfocarPrestador(super.generacion, this.destino);

  final Coordenada destino;
}

/// Lo que el mapa necesita para dibujarse.
final class DatosMapa {
  const DatosMapa({
    required this.origen,
    required this.destacados,
    required this.otros,
    required this.seleccionadoId,
    required this.estilo,
    required this.paddingInferior,
    required this.etiquetaTiempo,
    required this.semanticaPin,
    required this.etiquetaUsuario,
  });

  final Coordenada origen;
  final List<PrestadorCercano> destacados;
  final List<PrestadorCercano> otros;
  final String? seleccionadoId;
  final EstiloMapa estilo;

  /// Alto que tapa la hoja, para encuadrar por encima de ella (M7).
  final double paddingInferior;

  /// «6 min» bajo los pines destacados.
  final String Function(PrestadorCercano c) etiquetaTiempo;

  /// Lo que lee TalkBack en el pin (mapa falso).
  final String Function(PrestadorCercano c) semanticaPin;
  final String etiquetaUsuario;

  Iterable<PrestadorCercano> get todos => [...destacados, ...otros];
}
