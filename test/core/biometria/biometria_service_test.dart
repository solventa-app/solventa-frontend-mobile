import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';

/// `LocalAuthentication` falso: devuelve lo que se le programe.
final class _Auth implements LocalAuthentication {
  bool soportado = true;
  List<BiometricType> inscritas = [BiometricType.strong];
  Object? errorAlConsultar;
  Object resultado = true;
  bool? ultimoBiometricOnly;
  String? ultimoMotivo;

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
    final r = resultado;
    if (r is bool) return r;
    throw r;
  }

  @override
  Future<bool> stopAuthentication() async => true;
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
  late LocalAuthBiometriaService servicio;

  setUp(() {
    auth = _Auth();
    ajustes = _Ajustes();
    servicio = LocalAuthBiometriaService(auth: auth, ajustes: ajustes);
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

  group('autenticar', () {
    Future<ResultadoBiometria> autenticar({bool pin = false}) => servicio
        .autenticar(motivo: 'Motivo', permitirCredencialDispositivo: pin);

    test('éxito', () async {
      expect(await autenticar(), isA<Autenticado>());
      expect(auth.ultimoMotivo, 'Motivo');
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
