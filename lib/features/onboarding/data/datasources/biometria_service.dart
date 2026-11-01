import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Estado de la biometría del teléfono (M01-08).
abstract interface class BiometriaService {
  Future<bool> disponible();
  Future<void> abrirAjustes();
}

/// Implementación real con `local_auth`. Verifica si el dispositivo soporta y
/// tiene registrada huella o rostro, o autentica con el diálogo nativo.
final class LocalAuthBiometriaService implements BiometriaService {
  LocalAuthBiometriaService([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> disponible() async {
    try {
      final soportado = await _auth.isDeviceSupported();
      final puedeVerificar = await _auth.canCheckBiometrics;
      if (!soportado && !puedeVerificar) return false;
      final inscritas = await _auth.getAvailableBiometrics();
      if (inscritas.isEmpty && !soportado) return false;
      return await _auth.authenticate(
        localizedReason:
            'Confirma tu huella o rostro para proteger tu cuenta en Solventa',
      );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> abrirAjustes() async {
    try {
      await _auth.stopAuthentication();
    } catch (_) {}
  }
}

/// Fake: el teléfono tiene huella o rostro activado.
final class FakeBiometriaService implements BiometriaService {
  FakeBiometriaService({this.activada = true});

  bool activada;

  @override
  Future<bool> disponible() async => activada;

  @override
  Future<void> abrirAjustes() async {}
}
