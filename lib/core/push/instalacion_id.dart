import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Id estable de esta instalación de la app (KAN-259, D3): no es un dato
/// personal (es un identificador aleatorio sin relación con la persona), así
/// que `shared_preferences` es apropiado, igual que para el idioma y la
/// moneda (`lib/core/l10n/l10n.dart`). El backend liga el push a este id, no
/// al dispositivo de la llave de login sin clave de KAN-26 (son conceptos
/// independientes).
abstract interface class InstalacionIdStore {
  Future<String> obtener();
}

final class SharedPrefsInstalacionIdStore implements InstalacionIdStore {
  static const _clave = 'solventa.instalacion.id';

  @override
  Future<String> obtener() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existente = prefs.getString(_clave);
      if (existente != null && existente.isNotEmpty) return existente;
      final nuevo = _uuidV4();
      await prefs.setString(_clave, nuevo);
      return nuevo;
    } catch (_) {
      // Sin el plugin de SharedPreferences disponible: un id de una sola
      // sesión en vez de tumbar el registro del push.
      return _uuidV4();
    }
  }
}

/// Para pruebas: siempre el mismo id.
final class MemoriaInstalacionIdStore implements InstalacionIdStore {
  const MemoriaInstalacionIdStore([this.valor = 'instalacion-prueba']);

  final String valor;

  @override
  Future<String> obtener() async => valor;
}

/// UUID v4 sin agregar una dependencia nueva solo para esto.
String _uuidV4() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  String byte(int i) => bytes[i].toRadixString(16).padLeft(2, '0');
  final hex = List.generate(16, byte).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

final instalacionIdStoreProvider = Provider<InstalacionIdStore>(
  (ref) => SharedPrefsInstalacionIdStore(),
);
