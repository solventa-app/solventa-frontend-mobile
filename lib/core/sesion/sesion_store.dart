import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Dónde vive el JWT de la sesión. En el dispositivo, `flutter_secure_storage`
/// (Keychain en iOS, Keystore en Android); nunca `shared_preferences`, que
/// guarda en texto plano (EC022). Al cerrar sesión se borra.
abstract interface class SesionStore {
  Future<String?> leer();
  Future<void> guardar(String token);
  Future<void> borrar();
}

final class SecureSesionStore implements SesionStore {
  SecureSesionStore([FlutterSecureStorage? almacen])
    : _almacen = almacen ?? const FlutterSecureStorage();

  static const _clave = 'solventa.sesion.token';

  final FlutterSecureStorage _almacen;

  @override
  Future<String?> leer() => _almacen.read(key: _clave);

  @override
  Future<void> guardar(String token) =>
      _almacen.write(key: _clave, value: token);

  @override
  Future<void> borrar() => _almacen.delete(key: _clave);
}

/// Para pruebas y `API_ENV=mock`: solo en memoria.
final class MemoriaSesionStore implements SesionStore {
  String? _token;

  @override
  Future<String?> leer() async => _token;

  @override
  Future<void> guardar(String token) async => _token = token;

  @override
  Future<void> borrar() async => _token = null;
}
