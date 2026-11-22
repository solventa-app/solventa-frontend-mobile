import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Llave de la base local cifrada: 32 bytes al azar, creados en el primer uso
/// y guardados en `flutter_secure_storage` (Keystore) con el prefijo del
/// ambiente, igual que la sesión. Nunca sale de ahí ni se registra.
abstract interface class LlaveAlmacen {
  /// La llave en hexadecimal (64 caracteres). `null` si no existe.
  Future<String?> leer();

  /// Crea una llave nueva y reemplaza la anterior.
  Future<String> crear();
}

final class LlaveAlmacenSegura implements LlaveAlmacen {
  LlaveAlmacenSegura({
    required String ambiente,
    FlutterSecureStorage? almacen,
    Random? azar,
  }) : _almacen = almacen ?? const FlutterSecureStorage(),
       _azar = azar ?? Random.secure(),
       _clave = '$ambiente.solventa.offline.llave';

  final FlutterSecureStorage _almacen;
  final Random _azar;
  final String _clave;

  @override
  Future<String?> leer() async {
    final valor = await _almacen.read(key: _clave);
    return valor != null && esValida(valor) ? valor : null;
  }

  @override
  Future<String> crear() async {
    final llave = generar(_azar);
    await _almacen.write(key: _clave, value: llave);
    return llave;
  }

  static final _formato = RegExp(r'^[0-9a-f]{64}$');

  static bool esValida(String llave) => _formato.hasMatch(llave);

  static String generar(Random azar) => [
    for (var i = 0; i < 32; i++)
      azar.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}

/// Para pruebas: la llave vive en memoria.
final class LlaveAlmacenMemoria implements LlaveAlmacen {
  LlaveAlmacenMemoria([this._llave]);

  String? _llave;

  @override
  Future<String?> leer() async => _llave;

  @override
  Future<String> crear() async =>
      _llave = LlaveAlmacenSegura.generar(Random(7));
}
