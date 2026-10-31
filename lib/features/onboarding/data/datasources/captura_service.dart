import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';

import '../../domain/entities/onboarding.dart';

/// `true` cuando corre dentro de `flutter test` (unitarias, widgets o goldens).
bool get esEntornoDePruebas => Platform.environment.containsKey('FLUTTER_TEST');

/// Límites de peso del contrato de almacenamiento en el backend:
/// - ANVERSO / REVERSO: 5 MB
/// - ROSTRO (selfie JPEG): 2 MB
/// - VIDEO (MP4 de prueba de vida): 15 MB
abstract final class LimitesCaptura {
  static const int maxBytesDocumento = 5 * 1024 * 1024;
  static const int maxBytesRostro = 2 * 1024 * 1024;
  static const int maxBytesVideo = 15 * 1024 * 1024;
}

/// De dónde salen las cuatro piezas del onboarding. Las capturas viven solo en
/// memoria hasta que se suben: nunca se guardan en el dispositivo por la app.
abstract interface class CapturaService {
  /// `null` si la persona cerró la cámara sin tomar la foto.
  Future<Captura?> documento();
  Future<Captura?> rostro();
  Future<Captura?> video();

  /// Registra el controlador de cámara en vivo activo en la pantalla actual
  /// (`SolLiveCameraFrame`) para tomar la foto o el video directamente desde
  /// el visor embebido sin abrir ninguna aplicación externa.
  void vincularControladorEnVivo(CameraController? controller) {}
}

/// Captura desde el visor embebido (`package:camera` dentro de
/// `SolLiveCameraFrame` en `ResolutionPreset.medium` ~720p) sin abrir nunca la
/// aplicación de cámara externa del sistema.
///
/// [permitirRespaldo] solo es `true` con `API_ENV=mock`: sin cámara (emulador
/// sin webcam o permiso negado) usa `FakeCapturaService` para probar el
/// recorrido. En `local`, `dev` y `prod` devuelve `null` y la pantalla muestra
/// `CAMARA_NO_DISPONIBLE`: nunca se sube una captura vacía al proveedor KYC.
///
/// El plugin escribe la foto o el video en la caché de la app; se leen los
/// bytes y el archivo se borra en el acto (son datos biométricos, Ley 1581).
final class CamaraCapturaService implements CapturaService {
  CamaraCapturaService({this.permitirRespaldo = false});

  final bool permitirRespaldo;

  CameraController? _controladorEnVivo;

  @override
  void vincularControladorEnVivo(CameraController? controller) {
    _controladorEnVivo = controller;
  }

  Future<Captura?> _fotoDesdeControlador(int maxBytes) async {
    final ctrl = _controladorEnVivo;
    if (ctrl == null || !ctrl.value.isInitialized) return null;
    try {
      final archivo = await ctrl.takePicture();
      final bytes = await archivo.readAsBytes();
      await borrarTemporal(archivo.path);
      if (bytes.isEmpty || bytes.length > maxBytes) return null;
      return Captura(bytes, 'image/jpeg');
    } catch (_) {
      return null;
    }
  }

  Future<Captura?> _videoDesdeControlador() async {
    final ctrl = _controladorEnVivo;
    if (ctrl == null || !ctrl.value.isInitialized) return null;
    try {
      if (!ctrl.value.isRecordingVideo) {
        await ctrl.startVideoRecording();
        await Future<void>.delayed(const Duration(seconds: 2));
      }
      final archivo = await ctrl.stopVideoRecording();
      final bytes = await archivo.readAsBytes();
      await borrarTemporal(archivo.path);
      if (bytes.isEmpty || bytes.length > LimitesCaptura.maxBytesVideo) {
        return null;
      }
      return Captura(bytes, 'video/mp4');
    } catch (_) {
      return null;
    }
  }

  Future<Captura?> _oRespaldo(
    Captura? real,
    Future<Captura?> Function() respaldo,
  ) async => real ?? (permitirRespaldo ? await respaldo() : null);

  @override
  Future<Captura?> documento() async => _oRespaldo(
    await _fotoDesdeControlador(LimitesCaptura.maxBytesDocumento),
    const FakeCapturaService().documento,
  );

  @override
  Future<Captura?> rostro() async => _oRespaldo(
    await _fotoDesdeControlador(LimitesCaptura.maxBytesRostro),
    const FakeCapturaService().rostro,
  );

  @override
  Future<Captura?> video() async => _oRespaldo(
    await _videoDesdeControlador(),
    const FakeCapturaService().video,
  );
}

/// Borra el archivo temporal que deja el plugin de cámara. Mejor esfuerzo.
Future<void> borrarTemporal(String ruta) async {
  try {
    final archivo = File(ruta);
    if (archivo.existsSync()) await archivo.delete();
  } catch (_) {}
}

/// Para pruebas y como respaldo cuando el emulador no tiene cámara activa.
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
  void vincularControladorEnVivo(CameraController? controller) {}

  @override
  Future<Captura?> documento() async => Captura(_jpeg, 'image/jpeg');

  @override
  Future<Captura?> rostro() async => Captura(_jpeg, 'image/jpeg');

  @override
  Future<Captura?> video() async => Captura(_mp4, 'video/mp4');
}
