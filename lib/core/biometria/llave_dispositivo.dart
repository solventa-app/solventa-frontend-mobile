import 'package:biometric_signature/biometric_signature.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../log/sol_log.dart';

/// Resultado de firmar un reto con la llave del teléfono.
sealed class ResultadoFirma {
  const ResultadoFirma();
}

/// La firma (ECDSA SHA-256, DER en base64) hecha tras la biometría.
final class Firmado extends ResultadoFirma {
  const Firmado(this.firma);
  final String firma;
}

/// La persona cerró el diálogo o no la reconoció: no se toca nada.
final class FirmaCancelada extends ResultadoFirma {
  const FirmaCancelada();
}

/// La llave ya no existe o quedó invalidada (cambió el registro de huellas o
/// rostros): hay que borrar el dispositivo y volver a pedir correo y clave.
final class LlaveInvalida extends ResultadoFirma {
  const LlaveInvalida();
}

/// Llave EC P-256 del teléfono para entrar sin escribir la clave (KAN-26).
///
/// La privada vive en el Keystore/StrongBox, solo se usa tras la biometría y
/// **nunca sale** del teléfono. AUTH guarda solo la pública (contrato v0.44).
/// Sobrevive al cierre de sesión; se borra al cambiar la clave, al invalidarse
/// o al desactivar el acceso.
abstract interface class LlaveDispositivoService {
  /// Crea la llave (pide la biometría) y devuelve la pública en base64 (SPKI),
  /// o `null` si no se pudo (sin biometría fuerte, cancelado).
  Future<String?> crear({required String motivo});

  /// Firma [reto] tras la biometría.
  Future<ResultadoFirma> firmar(String reto, {required String motivo});

  /// Borra la llave del Keystore.
  Future<void> borrar();
}

/// Implementación real con `biometric_signature` (Keystore en Android).
final class BiometricSignatureLlave implements LlaveDispositivoService {
  BiometricSignatureLlave({
    required String ambiente,
    BiometricSignature? plugin,
  }) : _alias = '$ambiente.solventa.dispositivo',
       _plugin = plugin ?? BiometricSignature();

  final String _alias;
  final BiometricSignature _plugin;

  @override
  Future<String?> crear({required String motivo}) async {
    try {
      final r = await _plugin.createKeys(
        keyAlias: _alias,
        promptMessage: motivo,
        config: CreateKeysConfig(
          signatureType: SignatureType.ecdsa,
          enforceBiometric: true,
          // Si se agrega o quita una huella o rostro, la llave deja de servir.
          setInvalidatedByBiometricEnrollment: true,
          // Como el resto de la app (D1): sin huella ni rostro sirve el PIN del teléfono.
          useDeviceCredentials: true,
          failIfExists: false,
        ),
      );
      if (r.code != BiometricError.success || r.publicKey == null) {
        SolLog.info('No se creó la llave del dispositivo (${r.code})');
        return null;
      }
      return r.publicKey;
    } on Exception catch (e) {
      SolLog.warning(
        'Falla al crear la llave del dispositivo (${e.runtimeType})',
      );
      return null;
    }
  }

  @override
  Future<ResultadoFirma> firmar(String reto, {required String motivo}) async {
    try {
      final r = await _plugin.createSignature(
        payload: reto,
        keyAlias: _alias,
        promptMessage: motivo,
        config: CreateSignatureConfig(allowDeviceCredentials: true),
      );
      if (r.code == BiometricError.success && r.signature != null) {
        return Firmado(r.signature!);
      }
      return switch (r.code) {
        BiometricError.keyNotFound ||
        BiometricError.keyInvalidated => const LlaveInvalida(),
        _ => const FirmaCancelada(),
      };
    } on Exception catch (e) {
      SolLog.warning('Falla al firmar con el dispositivo (${e.runtimeType})');
      return const FirmaCancelada();
    }
  }

  @override
  Future<void> borrar() async {
    try {
      await _plugin.deleteKeys(keyAlias: _alias);
    } on Exception catch (e) {
      SolLog.warning('No se pudo borrar la llave (${e.runtimeType})');
    }
  }
}

/// Doble para pruebas y `API_ENV=mock`: sin Keystore, firma lo que se le pida.
final class FakeLlaveDispositivo implements LlaveDispositivoService {
  FakeLlaveDispositivo({this.puedeCrear = true, this.resultadoFirma});

  bool puedeCrear;

  /// `null`: firma bien. Para probar cancelación o llave invalidada.
  ResultadoFirma? resultadoFirma;

  bool existe = false;
  final firmados = <String>[];

  @override
  Future<String?> crear({required String motivo}) async {
    if (!puedeCrear) return null;
    existe = true;
    return 'llave-publica-demo';
  }

  @override
  Future<ResultadoFirma> firmar(String reto, {required String motivo}) async {
    if (!existe) return const LlaveInvalida();
    firmados.add(reto);
    return resultadoFirma ?? Firmado('firma:$reto');
  }

  @override
  Future<void> borrar() async => existe = false;
}

/// Id del dispositivo que AUTH nos dio al registrar la llave. No es dato
/// personal (opaco), pero igual va al almacenamiento seguro del teléfono.
abstract interface class DispositivoStore {
  Future<String?> leer();
  Future<void> guardar(String dispositivoId);
  Future<void> borrar();
}

final class SecureDispositivoStore implements DispositivoStore {
  SecureDispositivoStore({
    required String ambiente,
    FlutterSecureStorage? almacen,
  }) : _clave = '$ambiente.solventa.dispositivo.id',
       _almacen = almacen ?? const FlutterSecureStorage();

  final String _clave;
  final FlutterSecureStorage _almacen;

  @override
  Future<String?> leer() => _almacen.read(key: _clave);

  @override
  Future<void> guardar(String dispositivoId) =>
      _almacen.write(key: _clave, value: dispositivoId);

  @override
  Future<void> borrar() => _almacen.delete(key: _clave);
}

final class MemoriaDispositivoStore implements DispositivoStore {
  String? _id;

  @override
  Future<String?> leer() async => _id;

  @override
  Future<void> guardar(String dispositivoId) async => _id = dispositivoId;

  @override
  Future<void> borrar() async => _id = null;
}
