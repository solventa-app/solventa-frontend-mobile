import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/resultado.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../domain/cercania.dart';
import 'prestadores_state.dart';
import 'providers.dart';

/// M06-01: obtiene la ubicación y ordena el catálogo por cercanía.
///
/// M12: solo la **primera** carga bloquea (estado [PrestadoresCargando]); una
/// recarga deja el mapa como está y, si llega tarde, se descarta (número de
/// generación). Con la misma ubicación (menos de 500 m) no recalcula.
final class PrestadoresNotifier extends Notifier<PrestadoresState> {
  int _generacion = 0;

  @override
  PrestadoresState build() => const PrestadoresCargando();

  Future<void> cargar() async {
    final generacion = ++_generacion;
    final anterior = state;
    if (anterior is! PrestadoresListos) state = const PrestadoresCargando();
    // El catálogo (copia local casi siempre) se pide mientras se ubica al cliente.
    final catalogo = ref
        .read(asistenciaRepositoryProvider)
        .catalogoPrestadores();
    final ubicacion = await ref
        .read(ubicacionServiceProvider)
        .ubicacionActual();
    if (!ref.mounted || generacion != _generacion) return;
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
        if (anterior is PrestadoresListos &&
            !Cercania.seMovio(anterior.origen, coordenada)) {
          return;
        }
        final r = await catalogo;
        if (!ref.mounted || generacion != _generacion) return;
        state = switch (r) {
          Exito(:final valor) => () {
            final mapa = Cercania.destacadosYOtros(
              coordenada,
              valor.prestadores,
            );
            return PrestadoresListos(
              origen: coordenada,
              destacados: mapa.destacados,
              otros: mapa.otros,
            );
          }(),
          Fracaso(:final falla) =>
            anterior is PrestadoresListos
                ? anterior
                : PrestadoresFallidos(falla),
        };
    }
  }

  /// «Escribir mi dirección» desde el aviso sin ubicación (CA-M06-02): sin
  /// coordenadas no se puede ordenar por cercanía, así que va por ciudad.
  Future<void> escribirDireccion() async {
    ++_generacion;
    state = const PrestadoresCargando();
    final r = await ref
        .read(asistenciaRepositoryProvider)
        .catalogoPrestadores();
    if (!ref.mounted) return;
    state = switch (r) {
      Exito(:final valor) => PrestadoresSinOrden(
        [...valor.prestadores]..sort((a, b) {
          final ciudad = a.ciudad.compareTo(b.ciudad);
          return ciudad != 0 ? ciudad : a.nombre.compareTo(b.nombre);
        }),
      ),
      Fracaso(:final falla) => PrestadoresFallidos(falla),
    };
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
