import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../providers.dart';

/// Paso numerado de M01-01 (2005:732): tarjeta con borde, número en círculo.
class PasoOnboarding extends StatelessWidget {
  const PasoOnboarding({
    super.key,
    required this.numero,
    required this.texto,
    required this.semanticLabel,
  });

  final int numero;
  final String texto;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: SolCard.outlined(
        padding: const EdgeInsets.all(17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.outline),
                ),
                child: MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.3,
                  child: Text(
                    '$numero',
                    style: context.solText.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.secondary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: SolSpacing.xs),
                child: Text(
                  texto,
                  style: context.solText.body.copyWith(color: colors.onSurface),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicador «Paso 2 de 2: Reverso» con segmentos de progreso (2001:405).
class IndicadorPasoDocumento extends StatelessWidget {
  const IndicadorPasoDocumento({
    super.key,
    required this.paso,
    required this.total,
    required this.texto,
  });

  final int paso;
  final int total;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    return Semantics(
      label: texto,
      excludeSemantics: true,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: 1,
              child: Text(
                '$paso',
                style: context.solText.labelStrong.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: SolSpacing.xs),
          Expanded(
            child: Text(
              texto,
              style: context.solText.body.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
            ),
          ),
          for (var i = 1; i <= total; i++) ...[
            if (i > 1) const SizedBox(width: 6),
            Container(
              width: 32,
              height: 6,
              decoration: BoxDecoration(
                // Pasos hechos en verde, el actual en azul (2001:412-413).
                color: i < paso ? sol.success : colors.primary,
                borderRadius: SolRadius.fullAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Visor de cámara en vivo dentro de [SolCameraFrame].
///
/// Cuando corre con hardware real (`usarFakesProvider == false`), abre la
/// cámara trasera o frontal en resolución media (~720p) y dibuja el
/// [CameraPreview] detrás del marco punteado centrado. Si el emulador no tiene
/// cámara o corre en pruebas/goldens, muestra la guía del sistema de diseño.
class SolLiveCameraFrame extends ConsumerStatefulWidget {
  const SolLiveCameraFrame({
    super.key,
    this.shape = SolCameraFrameShape.document,
    required this.instruction,
    this.label,
    this.labelIcon,
    this.guideLabel,
    this.frontal = false,
  });

  final SolCameraFrameShape shape;
  final String instruction;
  final String? label;
  final IconData? labelIcon;
  final String? guideLabel;
  final bool frontal;

  @override
  ConsumerState<SolLiveCameraFrame> createState() => _SolLiveCameraFrameState();
}

class _SolLiveCameraFrameState extends ConsumerState<SolLiveCameraFrame>
    with WidgetsBindingObserver {
  CameraController? _controller;
  EstadoCamara _estado = EstadoCamara.iniciando;
  bool _iniciando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_iniciarCamaraSiAplica());
  }

  /// Android exige soltar la cámara al ir al fondo; al volver (también desde
  /// los ajustes del sistema tras conceder el permiso) se reabre.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_liberar());
    } else if (state == AppLifecycleState.resumed && _controller == null) {
      unawaited(_iniciarCamaraSiAplica());
    }
  }

  void _fijar(EstadoCamara estado) {
    if (mounted) setState(() => _estado = estado);
  }

  Future<void> _iniciarCamaraSiAplica() async {
    if (!mounted || _iniciando) return;
    final forzado = ref.read(estadoCamaraForzadoProvider);
    if (forzado != null) return _fijar(forzado);
    if (!ref.read(camaraEnVivoHabilitadaProvider)) return;
    _iniciando = true;
    try {
      final camaras = await availableCameras();
      if (!mounted) return;
      if (camaras.isEmpty) return _fijar(EstadoCamara.sinCamara);
      final direccion = widget.frontal
          ? CameraLensDirection.front
          : CameraLensDirection.back;
      final elegida = camaras.firstWhere(
        (c) => c.lensDirection == direccion,
        orElse: () => camaras.first,
      );
      final ctrl = CameraController(
        elegida,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await ctrl.initialize();
      if (!mounted) {
        await ctrl.dispose();
        return;
      }
      _controller = ctrl;
      ref.read(capturaServiceProvider).vincularControladorEnVivo(ctrl);
      _fijar(EstadoCamara.lista);
    } on CameraException catch (e) {
      _fijar(switch (e.code) {
        'CameraAccessDeniedWithoutPrompt' ||
        'CameraAccessRestricted' => EstadoCamara.sinPermisoPermanente,
        'CameraAccessDenied' => EstadoCamara.sinPermiso,
        _ => EstadoCamara.sinCamara,
      });
    } catch (_) {
      _fijar(EstadoCamara.sinCamara);
    } finally {
      _iniciando = false;
    }
  }

  Future<void> _liberar() async {
    final ctrl = _controller;
    if (ctrl == null) return;
    _controller = null;
    try {
      ref.read(capturaServiceProvider).vincularControladorEnVivo(null);
    } catch (_) {}
    if (mounted) setState(() => _estado = EstadoCamara.iniciando);
    await ctrl.dispose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final ctrl = _controller;
    if (ctrl != null) {
      try {
        ref.read(capturaServiceProvider).vincularControladorEnVivo(null);
      } catch (_) {}
      unawaited(ctrl.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller;
    final Widget? preview = switch (_estado) {
      EstadoCamara.lista when ctrl != null && ctrl.value.isInitialized =>
        ClipRect(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: ctrl.value.previewSize?.height ?? 328,
              height: ctrl.value.previewSize?.width ?? 280,
              child: CameraPreview(ctrl),
            ),
          ),
        ),
      EstadoCamara.sinPermiso => SolPermisoCamaraPanel(
        bloqueado: false,
        onAccion: () => unawaited(_iniciarCamaraSiAplica()),
      ),
      EstadoCamara.sinPermisoPermanente => SolPermisoCamaraPanel(
        bloqueado: true,
        onAccion: () => unawaited(openAppSettings()),
      ),
      EstadoCamara.sinCamara => const SolPermisoCamaraPanel.sinCamara(),
      _ => null,
    };
    return SolCameraFrame(
      shape: widget.shape,
      label: widget.label,
      labelIcon: widget.labelIcon,
      guideLabel: widget.guideLabel,
      instruction: widget.instruction,
      preview: preview,
    );
  }
}

/// Aviso dentro del marco cuando no hay permiso de cámara o no hay cámara.
class SolPermisoCamaraPanel extends StatelessWidget {
  const SolPermisoCamaraPanel({
    super.key,
    required this.bloqueado,
    required this.onAccion,
  }) : sinCamara = false;

  const SolPermisoCamaraPanel.sinCamara({super.key})
    : bloqueado = false,
      onAccion = null,
      sinCamara = true;

  final bool bloqueado;
  final bool sinCamara;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final texto = sinCamara
        ? l10n.camaraNoDisponible
        : bloqueado
        ? l10n.camaraPermisoBloqueado
        : l10n.camaraPermisoTexto;
    return ColoredBox(
      color: colors.surface,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SolSpacing.lg),
          child: Semantics(
            liveRegion: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  sinCamara
                      ? Icons.no_photography_outlined
                      : Icons.photo_camera_outlined,
                  size: 40,
                  color: colors.primary,
                  semanticLabel: l10n.camaraPermisoTitulo,
                ),
                const SizedBox(height: SolSpacing.sm),
                if (!sinCamara)
                  Text(
                    l10n.camaraPermisoTitulo,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                const SizedBox(height: SolSpacing.xs),
                Text(
                  texto,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (onAccion != null) ...[
                  const SizedBox(height: SolSpacing.md),
                  SolButton.tonal(
                    label: bloqueado
                        ? l10n.camaraAbrirAjustes
                        : l10n.camaraPermitir,
                    onPressed: onAccion,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
