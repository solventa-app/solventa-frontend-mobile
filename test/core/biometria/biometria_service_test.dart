import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';

/// `LocalAuthentication` falso: devuelve lo que se le programe.
final class _Auth implements LocalAuthentication {
  bool soportado = true;
  List<BiometricType> inscritas = [BiometricType.strong];
  Object? errorAlConsultar;
  Object resultado = true;
  bool? ultimoBiometricOnly;
  String? ultimoMotivo;
  Iterable<Object> ultimosMensajes = const [];

  @override
  Future<bool> isDeviceSupported() async {
    final e = errorAlConsultar;
    if (e != null) throw e;
    return soportado;
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async => inscritas;

  @override
  Future<bool> get canCheckBiometrics async => inscritas.isNotEmpty;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<Object> authMessages = const <Object>[],
    bool biometricOnly = false,
    bool sensitiveTransaction = true,
    bool persistAcrossBackgrounding = false,
  }) async {
    ultimoBiometricOnly = biometricOnly;
    ultimoMotivo = localizedReason;
    ultimosMensajes = authMessages;
    final r = resultado;
    if (r is bool) return r;
    throw r;
  }

  @override
  Future<bool> stopAuthentication() async => true;
}

/// Consulta nativa programable (lo que `local_auth` no dice en Android).
final class _Nativa implements BiometriaNativa {
  InfoBiometriaNativa info = const InfoBiometriaNativa(
    huellaRegistrada: true,
    hardwareRostro: false,
    sdk: 34,
  );
  Object? error;
  int consultas = 0;

  @override
  Future<InfoBiometriaNativa> consultar() async {
    consultas++;
    final e = error;
    if (e != null) throw e;
    return info;
  }
}

final class _Ajustes implements AjustesSeguridad {
  int aperturas = 0;

  @override
  Future<void> abrir() async => aperturas++;
}

/// HU-M02 (F4, §3.6): estados del teléfono y mapeo de `local_auth` 3.x.
void main() {
  late _Auth auth;
  late _Ajustes ajustes;
  late _Nativa nativa;
  late LocalAuthBiometriaService servicio;

  setUp(() {
    auth = _Auth();
    ajustes = _Ajustes();
    nativa = _Nativa();
    servicio = LocalAuthBiometriaService(
      auth: auth,
      ajustes: ajustes,
      nativa: nativa,
    );
  });

  group('estado', () {
    test('con huella registrada', () async {
      expect(await servicio.estado(), EstadoBiometria.biometriaRegistrada);
    });

    test('solo PIN del teléfono (D1)', () async {
      auth.inscritas = [];
      expect(await servicio.estado(), EstadoBiometria.soloCredencial);
    });

    test('sin bloqueo de pantalla', () async {
      auth
        ..soportado = false
        ..inscritas = [];
      expect(await servicio.estado(), EstadoBiometria.sinBloqueoPantalla);
    });

    test('error del sistema', () async {
      auth.errorAlConsultar = PlatformException(code: 'x');
      expect(await servicio.estado(), EstadoBiometria.noDisponible);
    });
  });

  group('tipo', () {
    InfoBiometriaNativa info({
      bool huella = false,
      bool rostro = false,
      int sdk = 34,
    }) => InfoBiometriaNativa(
      huellaRegistrada: huella,
      hardwareRostro: rostro,
      sdk: sdk,
    );

    test('huella confirmada por el sistema y sin sensor de rostro', () async {
      nativa.info = info(huella: true);
      expect(await servicio.tipo(), TipoBiometria.huella);
    });

    test('biometría y ninguna huella, desde Android 10: rostro', () async {
      nativa.info = info(sdk: 29);
      expect(await servicio.tipo(), TipoBiometria.rostro);
    });

    test('sin biometría registrada: el bloqueo del teléfono', () async {
      auth.inscritas = [];
      expect(await servicio.tipo(), TipoBiometria.ninguna);
      expect(nativa.consultas, 0, reason: 'no hace falta preguntar al sistema');
    });

    test('huella y sensor de rostro a la vez: no se sabe cuál', () async {
      nativa.info = info(huella: true, rostro: true);
      expect(await servicio.tipo(), TipoBiometria.generica);
    });

    test(
      'Android 8 o 9 con biometría y sin huellas: no se sabe cuál',
      () async {
        nativa.info = info(sdk: 28);
        expect(await servicio.tipo(), TipoBiometria.generica);
      },
    );

    test('si la consulta nativa falla no se adivina', () async {
      nativa.error = PlatformException(code: 'BIOMETRIA_NO_DISPONIBLE');
      expect(await servicio.tipo(), TipoBiometria.generica);
    });

    test('si local_auth falla no se adivina', () async {
      auth.errorAlConsultar = PlatformException(code: 'x');
      auth.inscritas = [BiometricType.strong];
      // `getAvailableBiometrics` no lanza en el doble: se fuerza con la consulta nativa.
      nativa.error = StateError('sin respuesta');
      expect(await servicio.tipo(), TipoBiometria.generica);
    });

    test('si el plugin sí dice huella o rostro, se respeta', () async {
      auth.inscritas = [BiometricType.fingerprint];
      expect(await servicio.tipo(), TipoBiometria.huella);
      auth.inscritas = [BiometricType.face];
      expect(await servicio.tipo(), TipoBiometria.rostro);
      auth.inscritas = [BiometricType.fingerprint, BiometricType.face];
      expect(await servicio.tipo(), TipoBiometria.generica);
      expect(nativa.consultas, 0);
    });

    test('tipoSegunSistema cubre las cuatro combinaciones', () {
      expect(tipoSegunSistema(info(huella: true)), TipoBiometria.huella);
      expect(
        tipoSegunSistema(info(huella: true, rostro: true)),
        TipoBiometria.generica,
      );
      expect(tipoSegunSistema(info(sdk: 29)), TipoBiometria.rostro);
      expect(tipoSegunSistema(info(sdk: 28)), TipoBiometria.generica);
    });

    test('cada método tiene su clave de catálogo', () {
      expect(TipoBiometria.huella.clave, 'huella');
      expect(TipoBiometria.rostro.clave, 'rostro');
      expect(TipoBiometria.ninguna.clave, 'bloqueo');
      expect(TipoBiometria.generica.clave, 'seguridad');
    });

    test('el canal nativo entrega los tres datos', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const canal = MethodChannel(BiometriaNativaCanal.nombreCanal);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, (llamada) async {
            expect(llamada.method, 'consultar');
            return <String, Object?>{
              'huellaRegistrada': true,
              'hardwareRostro': true,
              'sdk': 35,
            };
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(canal, null),
      );

      final datos = await const BiometriaNativaCanal().consultar();

      expect(datos.huellaRegistrada, isTrue);
      expect(datos.hardwareRostro, isTrue);
      expect(datos.sdk, 35);
    });
  });

  group('autenticar', () {
    Future<ResultadoBiometria> autenticar({bool pin = false}) => servicio
        .autenticar(motivo: 'Motivo', permitirCredencialDispositivo: pin);

    test('éxito', () async {
      expect(await autenticar(), isA<Autenticado>());
      expect(auth.ultimoMotivo, 'Motivo');
    });

    test('título, subtítulo y cancelar salen del catálogo de la app', () async {
      await servicio.autenticar(
        motivo: 'Motivo',
        permitirCredencialDispositivo: false,
        titulo: 'Desbloquea Solventa',
        subtitulo: 'Confirma que eres tú',
        cancelar: 'Cancelar',
      );

      final mensajes = auth.ultimosMensajes.whereType<AndroidAuthMessages>();
      expect(mensajes, hasLength(1));
      expect(mensajes.single.signInTitle, 'Desbloquea Solventa');
      expect(mensajes.single.signInHint, 'Confirma que eres tú');
      expect(mensajes.single.cancelButton, 'Cancelar');
    });

    test('sin textos propios no cambia los del sistema', () async {
      await autenticar();
      expect(auth.ultimosMensajes, isEmpty);
    });

    test('false del sistema es «no reconocido»', () async {
      auth.resultado = false;
      expect(await autenticar(), isA<NoReconocido>());
    });

    test('solo biometría o también el PIN del teléfono (D2)', () async {
      await autenticar();
      expect(auth.ultimoBiometricOnly, isTrue);
      await autenticar(pin: true);
      expect(auth.ultimoBiometricOnly, isFalse);
    });

    test('cada código de local_auth tiene su resultado', () async {
      final esperados = <LocalAuthExceptionCode, Type>{
        LocalAuthExceptionCode.userCanceled: Cancelado,
        LocalAuthExceptionCode.systemCanceled: Cancelado,
        LocalAuthExceptionCode.timeout: Cancelado,
        LocalAuthExceptionCode.userRequestedFallback: Cancelado,
        LocalAuthExceptionCode.authInProgress: Cancelado,
        LocalAuthExceptionCode.temporaryLockout: BloqueoTemporal,
        LocalAuthExceptionCode.biometricLockout: BloqueoPermanente,
        LocalAuthExceptionCode.noBiometricsEnrolled: SinBiometriaRegistrada,
        LocalAuthExceptionCode.noCredentialsSet: SinBloqueoPantalla,
        LocalAuthExceptionCode.noBiometricHardware: NoDisponible,
        LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
            NoDisponible,
        LocalAuthExceptionCode.uiUnavailable: NoDisponible,
        LocalAuthExceptionCode.deviceError: NoDisponible,
        LocalAuthExceptionCode.unknownError: NoDisponible,
      };
      expect(esperados.keys, containsAll(LocalAuthExceptionCode.values));
      for (final MapEntry(key: codigo, value: tipo) in esperados.entries) {
        auth.resultado = LocalAuthException(code: codigo);
        expect((await autenticar()).runtimeType, tipo, reason: codigo.name);
      }
    });

    test('una PlatformException suelta es «no disponible»', () async {
      auth.resultado = PlatformException(code: 'x');
      expect(await autenticar(), isA<NoDisponible>());
    });
  });

  test('abrir ajustes usa el canal nativo', () async {
    await servicio.abrirAjustesSeguridad();
    expect(ajustes.aperturas, 1);
  });

  test('el canal de ajustes no rompe si falta la actividad', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const canal = MethodChannel(AjustesSeguridadNativo.nombreCanal);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          canal,
          (_) async => throw PlatformException(code: 'SIN_AJUSTES'),
        );
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(canal, null),
    );

    await const AjustesSeguridadNativo().abrir();
  });
}
