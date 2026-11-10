import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Qué ofrece el teléfono, sin pedir nada al usuario (`estado()`).
enum EstadoBiometria {
  /// Huella o rostro registrados (y por lo tanto bloqueo de pantalla).
  biometriaRegistrada,

  /// Bloqueo con PIN, patrón o contraseña, sin huella ni rostro. Con la
  /// decisión D1 se puede entrar con el PIN del teléfono.
  soloCredencial,

  /// Sin bloqueo de pantalla: no hay cómo proteger la sesión.
  sinBloqueoPantalla,

  /// No se pudo consultar (error del sistema).
  noDisponible,
}

/// Qué método biométrico tiene configurado el teléfono, para mostrar el ícono y el texto que corresponden en M02-01
/// («Ingresa con tu huella», «con tu rostro»).
enum TipoBiometria {
  huella,
  rostro,

  /// Hay biometría pero el sistema no dice cuál (clase fuerte o débil): se habla de «huella o rostro».
  generica,

  /// Sin biometría registrada: se entra con el bloqueo de pantalla del teléfono.
  ninguna,
}

/// Resultado de pedir la huella, el rostro o el PIN del teléfono (HU-M02 §3.6).
sealed class ResultadoBiometria {
  const ResultadoBiometria();
}

/// El sistema confirmó a la persona. Abre la ventana de 10 s del llavero.
final class Autenticado extends ResultadoBiometria {
  const Autenticado();
}

/// El sensor no reconoció la huella o el rostro → M02-01a.
final class NoReconocido extends ResultadoBiometria {
  const NoReconocido();
}

/// La persona cerró el diálogo: se queda donde estaba, sin error.
final class Cancelado extends ResultadoBiometria {
  const Cancelado();
}

/// Demasiados intentos: el sensor se bloqueó por unos segundos.
final class BloqueoTemporal extends ResultadoBiometria {
  const BloqueoTemporal();
}

/// El sensor quedó bloqueado hasta usar el PIN del teléfono.
final class BloqueoPermanente extends ResultadoBiometria {
  const BloqueoPermanente();
}

/// Hay bloqueo de pantalla pero no huella ni rostro (D1: PIN del teléfono).
final class SinBiometriaRegistrada extends ResultadoBiometria {
  const SinBiometriaRegistrada();
}

/// El teléfono no tiene bloqueo de pantalla.
final class SinBloqueoPantalla extends ResultadoBiometria {
  const SinBloqueoPantalla();
}

/// Sin hardware o error del sistema.
final class NoDisponible extends ResultadoBiometria {
  const NoDisponible();
}

/// Biometría del teléfono, compartida por M01-08 y M02 (decisión D3: el
/// diálogo es el de `local_auth`; la llave del refresh la abre el sistema).
abstract interface class BiometriaService {
  /// Qué tiene configurado el teléfono, sin abrir ningún diálogo.
  Future<EstadoBiometria> estado();

  /// Qué método biométrico tiene el teléfono, sin abrir ningún diálogo.
  Future<TipoBiometria> tipo();

  /// Abre el diálogo del sistema. Con [permitirCredencialDispositivo] el
  /// diálogo ofrece también el PIN, patrón o contraseña del teléfono (D2).
  /// [motivo] es el texto del catálogo de idiomas que muestra el diálogo.
  Future<ResultadoBiometria> autenticar({
    required String motivo,
    required bool permitirCredencialDispositivo,
  });

  /// Abre los ajustes del teléfono para registrar huella o bloqueo.
  Future<void> abrirAjustesSeguridad();
}

/// Códigos de `local_auth` 3.x → [ResultadoBiometria].
ResultadoBiometria resultadoDesdeCodigo(LocalAuthExceptionCode codigo) =>
    switch (codigo) {
      LocalAuthExceptionCode.userCanceled ||
      LocalAuthExceptionCode.systemCanceled ||
      LocalAuthExceptionCode.timeout ||
      LocalAuthExceptionCode.userRequestedFallback ||
      LocalAuthExceptionCode.authInProgress => const Cancelado(),
      LocalAuthExceptionCode.temporaryLockout => const BloqueoTemporal(),
      LocalAuthExceptionCode.biometricLockout => const BloqueoPermanente(),
      LocalAuthExceptionCode.noBiometricsEnrolled =>
        const SinBiometriaRegistrada(),
      LocalAuthExceptionCode.noCredentialsSet => const SinBloqueoPantalla(),
      LocalAuthExceptionCode.noBiometricHardware ||
      LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable ||
      LocalAuthExceptionCode.uiUnavailable ||
      LocalAuthExceptionCode.deviceError ||
      LocalAuthExceptionCode.unknownError => const NoDisponible(),
    };

/// Abre los ajustes de seguridad por el canal nativo
/// `com.solventa/ajustes_seguridad` (`AjustesSeguridad.kt`).
abstract interface class AjustesSeguridad {
  Future<void> abrir();
}

final class AjustesSeguridadNativo implements AjustesSeguridad {
  const AjustesSeguridadNativo([
    this._canal = const MethodChannel(nombreCanal),
  ]);

  static const nombreCanal = 'com.solventa/ajustes_seguridad';
  final MethodChannel _canal;

  @override
  Future<void> abrir() async {
    try {
      await _canal.invokeMethod<void>('abrir');
    } on PlatformException {
      // Sin actividad de ajustes: nada más que hacer.
    } on MissingPluginException {
      // Pruebas o plataforma sin el canal.
    }
  }
}

/// Implementación real con `local_auth`.
final class LocalAuthBiometriaService implements BiometriaService {
  LocalAuthBiometriaService({
    LocalAuthentication? auth,
    this._ajustes = const AjustesSeguridadNativo(),
  }) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;
  final AjustesSeguridad _ajustes;

  @override
  Future<EstadoBiometria> estado() async {
    try {
      // `isDeviceSupported` es `true` con biometría o con bloqueo de pantalla.
      if (!await _auth.isDeviceSupported()) {
        return EstadoBiometria.sinBloqueoPantalla;
      }
      final inscritas = await _auth.getAvailableBiometrics();
      return inscritas.isEmpty
          ? EstadoBiometria.soloCredencial
          : EstadoBiometria.biometriaRegistrada;
    } on Object {
      return EstadoBiometria.noDisponible;
    }
  }

  @override
  Future<TipoBiometria> tipo() async {
    try {
      final inscritas = await _auth.getAvailableBiometrics();
      if (inscritas.contains(BiometricType.face)) return TipoBiometria.rostro;
      if (inscritas.contains(BiometricType.fingerprint)) {
        return TipoBiometria.huella;
      }
      return inscritas.isEmpty ? TipoBiometria.ninguna : TipoBiometria.generica;
    } on Object {
      return TipoBiometria.ninguna;
    }
  }

  @override
  Future<ResultadoBiometria> autenticar({
    required String motivo,
    required bool permitirCredencialDispositivo,
  }) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: motivo,
        biometricOnly: !permitirCredencialDispositivo,
        persistAcrossBackgrounding: true,
      );
      return ok ? const Autenticado() : const NoReconocido();
    } on LocalAuthException catch (e) {
      return resultadoDesdeCodigo(e.code);
    } on PlatformException {
      return const NoDisponible();
    }
  }

  @override
  Future<void> abrirAjustesSeguridad() => _ajustes.abrir();
}

/// Fake configurable para pruebas, goldens y `API_ENV=mock`.
final class FakeBiometriaService implements BiometriaService {
  FakeBiometriaService({
    this.estadoActual = EstadoBiometria.biometriaRegistrada,
    this.tipoActual = TipoBiometria.huella,
    List<ResultadoBiometria>? resultados,
  }) : resultados = resultados ?? [];

  /// Lo que responde [estado].
  EstadoBiometria estadoActual;

  /// Lo que responde [tipo].
  TipoBiometria tipoActual;

  /// Respuestas de [autenticar] en orden; vacía → [Autenticado].
  final List<ResultadoBiometria> resultados;

  /// Cada llamada a [autenticar] con su `permitirCredencialDispositivo`.
  final autenticaciones = <bool>[];
  int aperturasAjustes = 0;

  @override
  Future<EstadoBiometria> estado() async => estadoActual;

  @override
  Future<TipoBiometria> tipo() async => tipoActual;

  @override
  Future<ResultadoBiometria> autenticar({
    required String motivo,
    required bool permitirCredencialDispositivo,
  }) async {
    autenticaciones.add(permitirCredencialDispositivo);
    return resultados.isEmpty ? const Autenticado() : resultados.removeAt(0);
  }

  @override
  Future<void> abrirAjustesSeguridad() async => aperturasAjustes++;
}
