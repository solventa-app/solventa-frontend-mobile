import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'llavero_sesion.dart';

/// No hay refresh guardado en el dispositivo.
final class SinRefreshGuardado implements Exception {
  const SinRefreshGuardado();
}

/// Dónde vive el refresh token entre aperturas de la app (HU-M02).
///
/// Solo el refresh se persiste, **cifrado** con la llave pública del
/// [LlaveroSesion] y guardado en `flutter_secure_storage` (Keystore), con el
/// prefijo del ambiente en la clave. El JWT de acceso vive solo en memoria
/// (`GestorSesion`). Nunca `shared_preferences` (EC022).
abstract interface class SesionStore {
  /// `true` si hay un refresh guardado (no dice si sigue vigente).
  Future<bool> hayRefresh();

  /// Vencimiento del refresh guardado, si se conoce.
  Future<DateTime?> refreshVenceEn();

  /// Cifra y guarda [refresh]. No exige autenticación. Lanza
  /// [SinBloqueoPantalla] si no se puede crear la llave.
  Future<void> guardarRefresh(String refresh, DateTime? venceEn);

  /// Descifra el refresh guardado. Lanza [SinRefreshGuardado],
  /// [RequiereAutenticacion] o [LlaveInvalidada].
  Future<String> leerRefresh();

  /// Borra el refresh y la llave.
  Future<void> borrar();
}

final class SecureSesionStore implements SesionStore {
  SecureSesionStore(
    this._llavero, {
    required String ambiente,
    FlutterSecureStorage? almacen,
  }) : _almacen = almacen ?? const FlutterSecureStorage(),
       _claveRefresh = '$ambiente.solventa.sesion.refresh',
       _claveVence = '$ambiente.solventa.sesion.refreshVenceEn';

  /// Clave de la versión anterior (solo el JWT, sin ambiente). Se borra.
  static const claveAnterior = 'solventa.sesion.token';

  final FlutterSecureStorage _almacen;
  final LlaveroSesion _llavero;
  final String _claveRefresh;
  final String _claveVence;
  bool _migrado = false;

  /// La versión anterior guardaba el JWT sin cifrar con la llave: se descarta
  /// una sola vez y el usuario inicia sesión de nuevo.
  Future<void> _migrar() async {
    if (_migrado) return;
    _migrado = true;
    await _almacen.delete(key: claveAnterior);
  }

  @override
  Future<bool> hayRefresh() async {
    await _migrar();
    return await _almacen.read(key: _claveRefresh) != null;
  }

  @override
  Future<DateTime?> refreshVenceEn() async {
    final texto = await _almacen.read(key: _claveVence);
    return texto == null ? null : DateTime.tryParse(texto);
  }

  @override
  Future<void> guardarRefresh(String refresh, DateTime? venceEn) async {
    await _migrar();
    if (!await _llavero.existe()) await _llavero.crear();
    final cifrado = await _llavero.cifrar(refresh);
    await _almacen.write(key: _claveRefresh, value: cifrado);
    if (venceEn == null) {
      await _almacen.delete(key: _claveVence);
    } else {
      await _almacen.write(
        key: _claveVence,
        value: venceEn.toUtc().toIso8601String(),
      );
    }
  }

  @override
  Future<String> leerRefresh() async {
    await _migrar();
    final cifrado = await _almacen.read(key: _claveRefresh);
    if (cifrado == null) throw const SinRefreshGuardado();
    return _llavero.descifrar(cifrado);
  }

  @override
  Future<void> borrar() async {
    await _almacen.delete(key: _claveRefresh);
    await _almacen.delete(key: _claveVence);
    await _almacen.delete(key: claveAnterior);
    await _llavero.borrar();
  }
}

/// Para pruebas y `API_ENV=mock`: solo en memoria, sin cifrar.
final class MemoriaSesionStore implements SesionStore {
  String? _refresh;
  DateTime? _vence;

  @override
  Future<bool> hayRefresh() async => _refresh != null;

  @override
  Future<DateTime?> refreshVenceEn() async => _vence;

  @override
  Future<void> guardarRefresh(String refresh, DateTime? venceEn) async {
    _refresh = refresh;
    _vence = venceEn;
  }

  @override
  Future<String> leerRefresh() async {
    final r = _refresh;
    if (r == null) throw const SinRefreshGuardado();
    return r;
  }

  @override
  Future<void> borrar() async {
    _refresh = null;
    _vence = null;
  }
}
