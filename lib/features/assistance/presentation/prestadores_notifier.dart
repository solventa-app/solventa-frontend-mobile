import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/resultado.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../domain/cercania.dart';
import 'prestadores_state.dart';
import 'providers.dart';

/// M06-01: obtiene la ubicación y pide los 3 prestadores más cercanos.
final class PrestadoresNotifier extends Notifier<PrestadoresState> {
  @override
  PrestadoresState build() => const PrestadoresCargando();

  Future<void> cargar() async {
    state = const PrestadoresCargando();
    // El catálogo (copia local casi siempre) se pide mientras se ubica al cliente.
    final catalogo = ref
        .read(asistenciaRepositoryProvider)
        .catalogoPrestadores();
    final ubicacion = await ref
        .read(ubicacionServiceProvider)
        .ubicacionActual();
    if (!ref.mounted) return;
    switch (ubicacion) {
      case UbicacionSinPermiso(:final permanente):
        state = PrestadoresSinUbicacion(
          permisoPermanente: permanente,
          gpsApagado: false,
        );
        return;
      case UbicacionNoDisponible():
        state = const PrestadoresSinUbicacion(
          permisoPermanente: false,
          gpsApagado: true,
        );
        return;
      case UbicacionObtenida(:final coordenada):
        final r = await catalogo;
        if (!ref.mounted) return;
        state = switch (r) {
          Exito(:final valor) => PrestadoresListos(
            origen: coordenada,
            cercanos: Cercania.masCercanos(coordenada, valor.prestadores),
          ),
          Fracaso(:final falla) => PrestadoresFallidos(falla),
        };
    }
  }

  /// «Abrir ajustes» desde el aviso sin ubicación; al volver se reintenta.
  Future<void> abrirAjustes() async {
    final s = state;
    if (s is! PrestadoresSinUbicacion) return;
    await ref
        .read(ubicacionServiceProvider)
        .abrirAjustes(deUbicacion: s.gpsApagado);
  }
}
