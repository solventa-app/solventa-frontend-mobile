import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/resultado.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../domain/cercania.dart';
import '../domain/entities/asistencia.dart';
import '../domain/entities/prestador.dart';
import 'prestadores_state.dart';
import 'providers.dart';

/// M06-01: ubica al cliente y ordena el catálogo por cercanía.
///
/// **Ubicación (2.0, plan de pendientes):** al entrar a la pestaña se revisa
/// primero el GPS y luego el permiso, sin pedir nada. La primera vez se
/// explica por qué ([PrestadoresExplicacion]); si lo negó o el GPS está
/// apagado, [PrestadoresSinUbicacion]. En los dos casos el cliente puede
/// escribir su dirección: ya ubicada, el mapa funciona igual que con GPS.
///
/// **M12:** solo la primera carga bloquea; una recarga deja el mapa como está
/// y, si llega tarde, se descarta (número de generación). Con la misma
/// ubicación (menos de 500 m) no recalcula.
final class PrestadoresNotifier extends Notifier<PrestadoresState> {
  int _generacion = 0;

  @override
  PrestadoresState build() => const PrestadoresCargando();

  /// Al entrar (y al volver de Ajustes): revisa sin pedir el permiso.
  Future<void> cargar() async {
    final generacion = ++_generacion;
    final anterior = state;
    final servicio = ref.read(ubicacionServiceProvider);
    final estado = await servicio.estado();
    if (!ref.mounted || generacion != _generacion) return;

    // Con la dirección escrita en pantalla no se le quita el mapa: si al
    // volver de Ajustes ya hay permiso, solo aparece «Usar mi ubicación».
    if (anterior is PrestadoresListos && anterior.direccionEscrita != null) {
      if (estado == EstadoUbicacion.concedido && !anterior.permisoDisponible) {
        state = anterior.conPermisoDisponible();
      }
      return;
    }
    switch (estado) {
      case EstadoUbicacion.gpsApagado:
        state = const PrestadoresSinUbicacion(
          permisoPermanente: false,
          gpsApagado: true,
        );
      case EstadoUbicacion.negadoSiempre:
        state = const PrestadoresSinUbicacion(
          permisoPermanente: true,
          gpsApagado: false,
        );
      case EstadoUbicacion.sinPermiso:
        final pedido = await ref.read(permisoPedidoProvider).leer();
        if (!ref.mounted || generacion != _generacion) return;
        state = pedido
            ? const PrestadoresSinUbicacion(
                permisoPermanente: false,
                gpsApagado: false,
              )
            : const PrestadoresExplicacion();
      case EstadoUbicacion.concedido:
        await _conGps(generacion, anterior);
    }
  }

  /// «Permitir ubicación» (explicación o permiso negado una vez): ahora sí
  /// aparece el diálogo del sistema.
  Future<void> permitir() async {
    unawaited(ref.read(permisoPedidoProvider).marcar());
    await _conGps(++_generacion, state);
  }

  /// «Usar mi ubicación actual» desde el aviso de la dirección escrita.
  Future<void> usarUbicacionActual() => _conGps(++_generacion, null);

  Future<void> _conGps(int generacion, PrestadoresState? anterior) async {
    if (anterior is! PrestadoresListos) state = const PrestadoresCargando();
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
      case UbicacionNoDisponible():
        state = const PrestadoresSinUbicacion(
          permisoPermanente: false,
          gpsApagado: true,
        );
      case UbicacionObtenida(:final coordenada):
        if (anterior is PrestadoresListos &&
            anterior.direccionEscrita == null &&
            !Cercania.seMovio(anterior.origen, coordenada)) {
          return;
        }
        await _listos(generacion, catalogo, coordenada, null, anterior);
    }
  }

  /// La dirección que escribió el cliente, ya ubicada (2.0): el mapa funciona
  /// igual que con GPS, con el aviso «Usando: …».
  Future<void> usarDireccion(DireccionEncontrada direccion) async {
    final generacion = ++_generacion;
    final anterior = state;
    if (anterior is! PrestadoresListos) state = const PrestadoresCargando();
    final catalogo = ref
        .read(asistenciaRepositoryProvider)
        .catalogoPrestadores();
    await _listos(
      generacion,
      catalogo,
      direccion.coordenada,
      direccion.direccion,
      anterior,
    );
  }

  Future<void> _listos(
    int generacion,
    Future<Resultado<CatalogoPrestadores>> catalogo,
    Coordenada origen,
    String? direccionEscrita,
    PrestadoresState? anterior,
  ) async {
    final r = await catalogo;
    if (!ref.mounted || generacion != _generacion) return;
    state = switch (r) {
      Exito(:final valor) => () {
        final mapa = Cercania.destacadosYOtros(origen, valor.prestadores);
        return PrestadoresListos(
          origen: origen,
          destacados: mapa.destacados,
          otros: mapa.otros,
          direccionEscrita: direccionEscrita,
        );
      }(),
      Fracaso(:final falla) =>
        anterior is PrestadoresListos ? anterior : PrestadoresFallidos(falla),
    };
    final listos = state;
    if (listos is PrestadoresListos && listos.destacados.isNotEmpty) {
      unawaited(_cargarRutas(generacion, listos));
    }
  }

  /// M15: las rutas llegan después del mapa (no lo bloquean). Hasta 10
  /// prestadores, los destacados primero (solo ellos traen la línea). Una
  /// respuesta vieja se descarta.
  Future<void> _cargarRutas(int generacion, PrestadoresListos listos) async {
    final ids = [
      ...listos.destacados,
      ...listos.otros,
    ].take(10).map((c) => c.prestador.id).toList();
    final r = await ref
        .read(asistenciaRepositoryProvider)
        .rutas(listos.origen, ids);
    if (!ref.mounted || generacion != _generacion) return;
    final actual = state;
    if (actual is! PrestadoresListos || actual.origen != listos.origen) return;
    state = actual.conRutas(switch (r) {
      Exito(:final valor) => valor,
      Fracaso() => const [],
    });
  }

  /// «Abrir Ajustes» (negado para siempre) o «Activar ubicación» (GPS
  /// apagado); al volver, la página llama otra vez a [cargar].
  Future<void> abrirAjustes() async {
    final s = state;
    if (s is! PrestadoresSinUbicacion) return;
    await ref
        .read(ubicacionServiceProvider)
        .abrirAjustes(deUbicacion: s.gpsApagado);
  }
}
