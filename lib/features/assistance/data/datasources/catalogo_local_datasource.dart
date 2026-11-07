import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Copia del catálogo maestro de prestadores en el teléfono.
///
/// No es un dato personal (nombres y coordenadas de prestadores), así que va
/// en `SharedPreferences` y no en el almacenamiento cifrado.
final class CopiaCatalogo {
  const CopiaCatalogo({required this.catalogo, required this.revisadoEn});

  /// `data.catalogoPrestadores` tal como llegó (con `version` y la lista).
  final Map<String, Object?> catalogo;

  /// Última vez que el backend confirmó que esta copia es la vigente.
  final DateTime revisadoEn;

  String get version => catalogo['version']! as String;
}

abstract interface class CatalogoLocalDataSource {
  Future<CopiaCatalogo?> leer();
  Future<void> guardar(CopiaCatalogo copia);
}

final class PrefsCatalogoLocalDataSource implements CatalogoLocalDataSource {
  const PrefsCatalogoLocalDataSource();

  static const _clave = 'solventa.asistencia.catalogo';

  @override
  Future<CopiaCatalogo?> leer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final texto = prefs.getString(_clave);
      if (texto == null) return null;
      final json = jsonDecode(texto) as Map<String, Object?>;
      return CopiaCatalogo(
        catalogo: json['catalogo']! as Map<String, Object?>,
        revisadoEn: DateTime.parse(json['revisadoEn']! as String),
      );
    } catch (_) {
      // Copia dañada o sin plugin: se trata como si no hubiera copia.
      return null;
    }
  }

  @override
  Future<void> guardar(CopiaCatalogo copia) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _clave,
        jsonEncode({
          'catalogo': copia.catalogo,
          'revisadoEn': copia.revisadoEn.toUtc().toIso8601String(),
        }),
      );
    } catch (_) {
      // Sin plugin (pruebas): la app sigue con lo que tiene en memoria.
    }
  }
}

final class MemoriaCatalogoLocalDataSource implements CatalogoLocalDataSource {
  MemoriaCatalogoLocalDataSource([this.copia]);

  CopiaCatalogo? copia;

  @override
  Future<CopiaCatalogo?> leer() async => copia;

  @override
  Future<void> guardar(CopiaCatalogo c) async => copia = c;
}
