import 'package:shared_preferences/shared_preferences.dart';

/// Si la app ya mostró el diálogo de ubicación alguna vez (HU-M06, 2.0).
/// Android no distingue «nunca se pidió» de «se negó una vez», y la pantalla
/// de explicación solo va la primera vez. No es un dato personal.
abstract interface class PermisoPedidoStore {
  Future<bool> leer();
  Future<void> marcar();
}

final class PrefsPermisoPedidoStore implements PermisoPedidoStore {
  const PrefsPermisoPedidoStore();

  static const _clave = 'solventa.asistencia.permisoUbicacionPedido';

  @override
  Future<bool> leer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_clave) ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> marcar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_clave, true);
    } catch (_) {
      // Sin plugin: se vuelve a explicar la próxima vez; no es grave.
    }
  }
}

final class MemoriaPermisoPedidoStore implements PermisoPedidoStore {
  MemoriaPermisoPedidoStore({this.pedido = false});

  bool pedido;

  @override
  Future<bool> leer() async => pedido;

  @override
  Future<void> marcar() async => pedido = true;
}
