import 'dart:convert';

import 'package:flutter/services.dart';

/// Fallas del llavero de la sesión. Nunca llevan el refresh ni el cifrado.
sealed class ErrorLlavero implements Exception {
  const ErrorLlavero();
}

/// La llave privada exige una autenticación reciente (huella fuerte o PIN del
/// teléfono, hace menos de 10 s) y no la hubo.
final class RequiereAutenticacion extends ErrorLlavero {
  const RequiereAutenticacion();
}

/// Android invalidó la llave (se quitó el bloqueo de pantalla) o ya no existe:
/// el refresh guardado no se puede recuperar y hay que iniciar sesión.
final class LlaveInvalidada extends ErrorLlavero {
  const LlaveInvalidada();
}

/// El teléfono no tiene bloqueo de pantalla: no se puede crear una llave que
/// exija autenticación, y el refresh no se persiste.
final class SinBloqueoPantalla extends ErrorLlavero {
  const SinBloqueoPantalla();
}

/// Cualquier otro error del Keystore. [codigo] es el del canal nativo.
final class FallaLlavero extends ErrorLlavero {
  const FallaLlavero(this.codigo);
  final String codigo;

  @override
  String toString() => 'FallaLlavero($codigo)';
}

/// Par RSA del Android Keystore que protege el refresh token (HU-M02, D3).
///
/// La llave pública cifra sin pedir nada; la privada solo descifra durante
/// 10 s después de que el usuario se autentica. Ver
/// `android/.../LlaveroSesion.kt` y docs/arquitectura.md §8.
abstract interface class LlaveroSesion {
  Future<bool> existe();

  /// Lanza [SinBloqueoPantalla] si el teléfono no tiene bloqueo.
  Future<void> crear();

  /// Cifra con la llave pública. No exige autenticación.
  Future<String> cifrar(String texto);

  /// Descifra con la llave privada. Lanza [RequiereAutenticacion] o
  /// [LlaveInvalidada].
  Future<String> descifrar(String cifrado);

  Future<void> borrar();
}

/// Implementación real sobre el canal `com.solventa/llavero_sesion`.
final class LlaveroSesionNativo implements LlaveroSesion {
  LlaveroSesionNativo({required this.alias, MethodChannel? canal})
    : _canal = canal ?? const MethodChannel(nombreCanal);

  static const nombreCanal = 'com.solventa/llavero_sesion';

  /// Alias de la llave en el Keystore, con el prefijo del ambiente.
  final String alias;
  final MethodChannel _canal;

  Future<T?> _invocar<T>(
    String metodo, [
    Map<String, Object?> extra = const {},
  ]) async {
    try {
      return await _canal.invokeMethod<T>(metodo, {'alias': alias, ...extra});
    } on PlatformException catch (e) {
      throw errorLlaveroDesdeCodigo(e.code);
    } on MissingPluginException {
      throw const FallaLlavero('SIN_CANAL');
    }
  }

  @override
  Future<bool> existe() async => await _invocar<bool>('existe') ?? false;

  @override
  Future<void> crear() => _invocar<void>('crear');

  @override
  Future<String> cifrar(String texto) async {
    final cifrado = await _invocar<String>('cifrar', {'texto': texto});
    if (cifrado == null) throw const FallaLlavero('SIN_RESULTADO');
    return cifrado;
  }

  @override
  Future<String> descifrar(String cifrado) async {
    final texto = await _invocar<String>('descifrar', {'cifrado': cifrado});
    if (texto == null) throw const FallaLlavero('SIN_RESULTADO');
    return texto;
  }

  @override
  Future<void> borrar() => _invocar<void>('borrar');
}

/// Códigos de `LlaveroSesion.kt` → [ErrorLlavero].
ErrorLlavero errorLlaveroDesdeCodigo(String codigo) => switch (codigo) {
  'REQUIERE_AUTENTICACION' => const RequiereAutenticacion(),
  'LLAVE_INVALIDADA' => const LlaveInvalidada(),
  'SIN_BLOQUEO_PANTALLA' => const SinBloqueoPantalla(),
  _ => FallaLlavero(codigo),
};

/// Para `API_ENV=mock` y pruebas: «cifra» en base64 y simula la ventana de
/// autenticación con [autenticado].
final class LlaveroSesionMemoria implements LlaveroSesion {
  LlaveroSesionMemoria({
    this.exigeAutenticacion = false,
    this.conBloqueoPantalla = true,
  });

  /// Si es `true`, [descifrar] lanza [RequiereAutenticacion] hasta que se
  /// llame [autenticar].
  bool exigeAutenticacion;

  /// Si es `false`, [crear] lanza [SinBloqueoPantalla].
  bool conBloqueoPantalla;

  bool _existe = false;
  bool _ventanaAbierta = false;

  /// Simula una autenticación exitosa: abre la ventana de la llave privada.
  void autenticar() => _ventanaAbierta = true;

  /// Simula que Android invalidó la llave.
  void invalidar() => _existe = false;

  @override
  Future<bool> existe() async => _existe;

  @override
  Future<void> crear() async {
    if (!conBloqueoPantalla) throw const SinBloqueoPantalla();
    _existe = true;
  }

  @override
  Future<String> cifrar(String texto) async {
    if (!_existe) throw const LlaveInvalidada();
    return base64.encode(utf8.encode(texto));
  }

  @override
  Future<String> descifrar(String cifrado) async {
    if (!_existe) throw const LlaveInvalidada();
    if (exigeAutenticacion && !_ventanaAbierta) {
      throw const RequiereAutenticacion();
    }
    _ventanaAbierta = false;
    return utf8.decode(base64.decode(cifrado));
  }

  @override
  Future<void> borrar() async {
    _existe = false;
    _ventanaAbierta = false;
  }
}
