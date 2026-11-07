import 'package:geolocator/geolocator.dart';

import 'coordenada.dart';

/// Resultado de pedir la ubicación actual del teléfono.
///
/// La ubicación es un dato personal: nunca se escribe en logs, breadcrumbs ni
/// reportes de error, y no se guarda en disco.
sealed class ResultadoUbicacion {
  const ResultadoUbicacion();
}

final class UbicacionObtenida extends ResultadoUbicacion {
  const UbicacionObtenida(this.coordenada);
  final Coordenada coordenada;
}

/// El usuario negó el permiso. Con [permanente] solo queda abrir Ajustes.
final class UbicacionSinPermiso extends ResultadoUbicacion {
  const UbicacionSinPermiso({required this.permanente});
  final bool permanente;
}

/// El GPS del teléfono está apagado o no respondió a tiempo.
final class UbicacionNoDisponible extends ResultadoUbicacion {
  const UbicacionNoDisponible();
}

abstract interface class UbicacionService {
  /// Pide el permiso si hace falta y devuelve la posición actual.
  Future<ResultadoUbicacion> ubicacionActual();

  /// Abre los ajustes de la app (permiso negado para siempre) o los de
  /// ubicación del sistema (GPS apagado).
  Future<void> abrirAjustes({required bool deUbicacion});
}

final class GeolocatorUbicacionService implements UbicacionService {
  const GeolocatorUbicacionService();

  @override
  Future<ResultadoUbicacion> ubicacionActual() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const UbicacionNoDisponible();
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      switch (permiso) {
        case LocationPermission.deniedForever:
          return const UbicacionSinPermiso(permanente: true);
        case LocationPermission.denied:
        case LocationPermission.unableToDetermine:
          return const UbicacionSinPermiso(permanente: false);
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          break;
      }
      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return UbicacionObtenida(
        Coordenada(posicion.latitude, posicion.longitude),
      );
    } on Exception {
      // Timeout o servicio caído: se intenta la última posición conocida.
      final ultima = await _ultimaConocida();
      return ultima == null
          ? const UbicacionNoDisponible()
          : UbicacionObtenida(ultima);
    }
  }

  Future<Coordenada?> _ultimaConocida() async {
    try {
      final p = await Geolocator.getLastKnownPosition();
      return p == null ? null : Coordenada(p.latitude, p.longitude);
    } on Exception {
      return null;
    }
  }

  @override
  Future<void> abrirAjustes({required bool deUbicacion}) async {
    if (deUbicacion) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
  }
}

/// Ubicación fija (Bogotá, Parque de la 93) para `API_ENV=mock` y pruebas.
final class FakeUbicacionService implements UbicacionService {
  FakeUbicacionService({
    this.resultado = const UbicacionObtenida(Coordenada(4.6767, -74.0483)),
  });

  ResultadoUbicacion resultado;

  @override
  Future<ResultadoUbicacion> ubicacionActual() async => resultado;

  @override
  Future<void> abrirAjustes({required bool deUbicacion}) async {}
}
