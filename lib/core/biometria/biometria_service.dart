import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

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
/// («Ingresa con tu huella», «con tu rostro»). Se muestra solo cuando se sabe con certeza; si no, el escudo.
enum TipoBiometria {
  /// El sistema confirma que hay una huella registrada y no puede haber rostro.
  huella,

  /// Hay biometría registrada y no hay huellas (por descarte, desde Android 10).
  rostro,

  /// No se sabe el método: huella y rostro posibles a la vez, Android 8 o 9 con biometría sin huellas, o la consulta
  /// falló. Se habla de «la seguridad de tu teléfono» y se muestra el escudo.
  generica,

  /// Sin biometría registrada: se entra con el bloqueo de pantalla del teléfono (PIN, patrón o contraseña).
  ninguna,
}

extension TipoBiometriaTextos on TipoBiometria {
  /// Opción del `select` de los catálogos de idiomas (M01-08 y el botón de huella del login).
  String get clave => switch (this) {
    TipoBiometria.huella => 'huella',
    TipoBiometria.rostro => 'rostro',
    TipoBiometria.ninguna => 'bloqueo',
    TipoBiometria.generica => 'seguridad',
  };
}

/// Lo que el sistema dice del teléfono y `local_auth` no (ver `BiometriaNativa.kt`).
final class InfoBiometriaNativa {
  const InfoBiometriaNativa({
    required this.huellaRegistrada,
    required this.hardwareRostro,
    required this.sdk,
  });

  /// El sistema confirma al menos una huella registrada.
  final bool huellaRegistrada;

  /// El teléfono declara sensor de rostro o de iris: aunque haya huella, un rostro podría estar registrado.
  final bool hardwareRostro;

  /// Nivel de API de Android.
  final int sdk;
}

/// Qué método es, a partir de lo que el sistema confirma. Solo se llama con biometría registrada.
///
/// - Con huella y sin sensor de rostro, huella: el sistema la confirma y no hay otra opción.
/// - Con huella y sensor de rostro, no se sabe cuál usará la persona: escudo.
/// - Sin huellas, desde Android 10 (API 29) la biometría que hay es de rostro, por descarte. En Android 8 y 9 no se
///   puede descartar: escudo.
TipoBiometria tipoSegunSistema(InfoBiometriaNativa info) {
  if (info.huellaRegistrada) {
    return info.hardwareRostro ? TipoBiometria.generica : TipoBiometria.huella;
  }
  return info.sdk >= 29 ? TipoBiometria.rostro : TipoBiometria.generica;
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
  /// [titulo], [subtitulo] y [cancelar] (el botón de abajo cuando solo hay
  /// biometría) también salen del catálogo, para que el diálogo hable el
  /// idioma de la app y no el de Android por defecto. El botón que ofrece el
  /// PIN lo escribe Android en el idioma del teléfono.
  Future<ResultadoBiometria> autenticar({
    required String motivo,
    required bool permitirCredencialDispositivo,
    String? titulo,
    String? subtitulo,
    String? cancelar,
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

/// Consulta nativa de lo que `local_auth` no dice: huella confirmada, sensor de
/// rostro y nivel de API, por el canal `com.solventa/biometria`
/// (`BiometriaNativa.kt`).
abstract interface class BiometriaNativa {
  Future<InfoBiometriaNativa> consultar();
}

final class BiometriaNativaCanal implements BiometriaNativa {
  const BiometriaNativaCanal([this._canal = const MethodChannel(nombreCanal)]);

  static const nombreCanal = 'com.solventa/biometria';
  final MethodChannel _canal;

  /// Lanza si el canal no responde o el sistema se niega: quien llama habla de «la seguridad de tu teléfono».
  @override
  Future<InfoBiometriaNativa> consultar() async {
    final datos = await _canal.invokeMapMethod<String, Object?>('consultar');
    if (datos == null) {
      throw PlatformException(code: 'BIOMETRIA_NO_DISPONIBLE');
    }
    return InfoBiometriaNativa(
      huellaRegistrada: datos['huellaRegistrada'] == true,
      hardwareRostro: datos['hardwareRostro'] == true,
      sdk: datos['sdk'] is int ? datos['sdk']! as int : 0,
    );
  }
}

/// Implementación real con `local_auth`.
final class LocalAuthBiometriaService implements BiometriaService {
  LocalAuthBiometriaService({
    LocalAuthentication? auth,
    this._ajustes = const AjustesSeguridadNativo(),
    this._nativa = const BiometriaNativaCanal(),
  }) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;
  final AjustesSeguridad _ajustes;
  final BiometriaNativa _nativa;

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

  /// En Android `local_auth` solo informa biometría débil o fuerte, nunca cuál:
  /// el método sale de la consulta nativa (`tipoSegunSistema`). Si algún día el
  /// plugin dice `fingerprint` o `face`, se respeta (los dos a la vez: no se
  /// sabe cuál). Si la consulta falla no se adivina: «la seguridad de tu
  /// teléfono».
  @override
  Future<TipoBiometria> tipo() async {
    try {
      final inscritas = await _auth.getAvailableBiometrics();
      if (inscritas.isEmpty) return TipoBiometria.ninguna;
      final huella = inscritas.contains(BiometricType.fingerprint);
      final rostro = inscritas.contains(BiometricType.face);
      if (huella && rostro) return TipoBiometria.generica;
      if (huella) return TipoBiometria.huella;
      if (rostro) return TipoBiometria.rostro;
      return tipoSegunSistema(await _nativa.consultar());
    } on Object {
      return TipoBiometria.generica;
    }
  }

  @override
  Future<ResultadoBiometria> autenticar({
    required String motivo,
    required bool permitirCredencialDispositivo,
    String? titulo,
    String? subtitulo,
    String? cancelar,
  }) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: motivo,
        authMessages: [
          if (titulo != null || subtitulo != null || cancelar != null)
            AndroidAuthMessages(
              signInTitle: titulo,
              signInHint: subtitulo,
              cancelButton: cancelar,
            ),
        ],
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

  /// Lo último que se mostró en el diálogo (para probar que sale del catálogo).
  String? ultimoTitulo;
  String? ultimoSubtitulo;
  String? ultimoCancelar;

  @override
  Future<ResultadoBiometria> autenticar({
    required String motivo,
    required bool permitirCredencialDispositivo,
    String? titulo,
    String? subtitulo,
    String? cancelar,
  }) async {
    autenticaciones.add(permitirCredencialDispositivo);
    ultimoTitulo = titulo;
    ultimoSubtitulo = subtitulo;
    ultimoCancelar = cancelar;
    return resultados.isEmpty ? const Autenticado() : resultados.removeAt(0);
  }

  @override
  Future<void> abrirAjustesSeguridad() async => aperturasAjustes++;
}
