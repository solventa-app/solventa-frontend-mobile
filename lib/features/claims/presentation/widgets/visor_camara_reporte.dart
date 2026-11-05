import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';

/// JPEG mínimo para pruebas y para `mock` sin cámara (nunca llega al backend
/// real: en `mock` la subida es un fake).
final Uint8List fotoDePrueba = Uint8List.fromList(const [
  0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01, //
  0x01, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0xFF, 0xD9,
]);

/// Visor de la cámara trasera de M05-02 con su botón de captura.
///
/// Usa `package:camera` dentro de la app (nunca la app de cámara del sistema)
/// y borra el archivo temporal apenas lee los bytes: la foto vive solo en
/// memoria. Suelta la cámara al pasar la app al fondo y la reabre al volver.
class VisorCamaraReporte extends StatefulWidget {
  const VisorCamaraReporte({
    super.key,
    required this.habilitada,
    required this.permitirRespaldo,
    required this.puedeTomar,
    required this.onCapturada,
    required this.etiquetaTomar,
    required this.etiquetaVisor,
    required this.textoSinCamara,
  });

  /// `false` en `flutter test`: no abre la cámara y captura [fotoDePrueba].
  final bool habilitada;

  /// Solo `mock`: sin cámara (o sin permiso) captura [fotoDePrueba].
  final bool permitirRespaldo;
  final bool puedeTomar;
  final ValueChanged<Uint8List> onCapturada;
  final String etiquetaTomar;
  final String etiquetaVisor;
  final String textoSinCamara;

  @override
  State<VisorCamaraReporte> createState() => _VisorCamaraReporteState();
}

class _VisorCamaraReporteState extends State<VisorCamaraReporte>
    with WidgetsBindingObserver {
  CameraController? _ctrl;
  bool _sinCamara = false;
  bool _tomando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.habilitada) unawaited(_abrir());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_ctrl?.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    if (!widget.habilitada) return;
    if (estado == AppLifecycleState.inactive) {
      final c = _ctrl;
      _ctrl = null;
      unawaited(c?.dispose());
      if (mounted) setState(() {});
    } else if (estado == AppLifecycleState.resumed && _ctrl == null) {
      unawaited(_abrir());
    }
  }

  Future<void> _abrir() async {
    try {
      final camaras = await availableCameras();
      if (camaras.isEmpty) throw CameraException('SinCamara', null);
      final trasera = camaras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => camaras.first,
      );
      final c = CameraController(
        trasera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() {
        _ctrl = c;
        _sinCamara = false;
      });
    } on Object {
      if (mounted) setState(() => _sinCamara = true);
    }
  }

  Future<void> _tomar() async {
    if (_tomando) return;
    final c = _ctrl;
    if (c == null || !c.value.isInitialized) {
      if (!widget.habilitada || widget.permitirRespaldo) {
        widget.onCapturada(fotoDePrueba);
      }
      return;
    }
    setState(() => _tomando = true);
    try {
      final archivo = await c.takePicture();
      final bytes = await archivo.readAsBytes();
      try {
        await File(archivo.path).delete();
      } on Object {
        // La caché de la app se limpia sola; no debe frenar el reporte.
      }
      if (mounted) widget.onCapturada(bytes);
    } on Object {
      if (mounted) setState(() => _sinCamara = true);
    } finally {
      if (mounted) setState(() => _tomando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final c = _ctrl;
    final visor = c != null && c.value.isInitialized
        ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: c.value.previewSize?.height ?? 3,
              height: c.value.previewSize?.width ?? 4,
              child: CameraPreview(c),
            ),
          )
        : Center(
            child: _sinCamara && !widget.permitirRespaldo
                ? Padding(
                    padding: const EdgeInsets.all(SolSpacing.lg),
                    child: SolInlineNote(
                      icon: SolIcons.camera,
                      text: widget.textoSinCamara,
                      center: true,
                      color: colors.onInverseSurface,
                    ),
                  )
                : Icon(
                    SolIcons.camera,
                    size: 48,
                    color: colors.onInverseSurface,
                  ),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: widget.etiquetaVisor,
          image: true,
          child: ClipRRect(
            borderRadius: SolRadius.cardAll,
            child: ColoredBox(
              color: context.solColors.cameraViewport,
              child: AspectRatio(aspectRatio: 4 / 3, child: visor),
            ),
          ),
        ),
        const SizedBox(height: SolSpacing.md),
        SolButton.tonal(
          label: widget.etiquetaTomar,
          onPressed: widget.puedeTomar && !_tomando ? _tomar : null,
        ),
      ],
    );
  }
}
