import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import '../../domain/entities/onboarding.dart';

/// De dónde salen las cuatro piezas del onboarding. Las capturas viven solo en
/// memoria hasta que se suben: nunca se guardan en el dispositivo por la app.
abstract interface class CapturaService {
  /// `null` si la persona cerró la cámara sin tomar la foto.
  Future<Captura?> documento();
  Future<Captura?> rostro();
  Future<Captura?> video();
}

/// Cámara del sistema con `image_picker`. Las fotos salen en JPEG (el
/// almacenamiento solo admite JPEG para el rostro) y el video, en MP4, de 10 s
/// como máximo. El video guiado con detección de rostro queda para después.
final class CamaraCapturaService implements CapturaService {
  CamaraCapturaService([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<Captura?> _foto(CameraDevice camara) async {
    final archivo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: camara,
      maxWidth: 2000,
      imageQuality: 85,
    );
    if (archivo == null) return null;
    return Captura(await archivo.readAsBytes(), 'image/jpeg');
  }

  @override
  Future<Captura?> documento() => _foto(CameraDevice.rear);

  @override
  Future<Captura?> rostro() => _foto(CameraDevice.front);

  @override
  Future<Captura?> video() async {
    final archivo = await _picker.pickVideo(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxDuration: const Duration(seconds: 10),
    );
    if (archivo == null) return null;
    return Captura(await archivo.readAsBytes(), 'video/mp4');
  }
}

/// Para `API_ENV=mock`, pruebas y emulador sin cámara: piezas de relleno.
final class FakeCapturaService implements CapturaService {
  const FakeCapturaService();

  // Cabecera y cierre de un JPEG; el stub de KYC no mira el contenido.
  static final _jpeg = Uint8List.fromList([
    0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01, //
    0xFF, 0xD9,
  ]);
  // Inicio de un MP4 (caja `ftyp`).
  static final _mp4 = Uint8List.fromList([
    0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32, //
  ]);

  @override
  Future<Captura?> documento() async => Captura(_jpeg, 'image/jpeg');

  @override
  Future<Captura?> rostro() async => Captura(_jpeg, 'image/jpeg');

  @override
  Future<Captura?> video() async => Captura(_mp4, 'video/mp4');
}
