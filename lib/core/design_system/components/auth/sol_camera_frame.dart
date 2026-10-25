import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Forma de la guía de encuadre.
enum SolCameraFrameShape {
  /// Documento (cédula) en horizontal, M01-03.
  document,

  /// Rostro para prueba de vida (óvalo).
  face,
}

/// Visor de captura (M01-03): fondo oscuro de 12 dp, etiqueta superior,
/// marco punteado con esquinas y la instrucción abajo.
///
/// [preview] es la vista de la cámara; sin ella se ve el visor vacío.
class SolCameraFrame extends StatelessWidget {
  const SolCameraFrame({
    super.key,
    required this.instruction,
    this.shape = SolCameraFrameShape.document,
    this.label,
    this.labelIcon,
    this.preview,
    this.height = 420,
  });

  /// Texto inferior, p. ej. «Ubica el FRENTE del documento dentro del marco».
  final String instruction;
  final SolCameraFrameShape shape;

  /// Etiqueta superior, p. ej. «Cédula de ciudadanía» (se muestra en
  /// mayúsculas).
  final String? label;
  final IconData? labelIcon;
  final Widget? preview;
  final double height;

  @override
  Widget build(BuildContext context) {
    final sol = context.solColors;
    final isDoc = shape == SolCameraFrameShape.document;
    return Semantics(
      container: true,
      label: [?label, 'Visor de cámara', instruction].join('. '),
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height, maxWidth: 328),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: SolRadius.cardAll,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 4),
                blurRadius: 6,
                spreadRadius: -1,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: SolRadius.cardAll,
            child: ColoredBox(
              color: sol.cameraViewport,
              child: Stack(
                children: [
                  if (preview != null) Positioned.fill(child: preview!),
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x0DFFFFFF),
                            Color(0x00FFFFFF),
                            Color(0x99000000),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(SolSpacing.lg),
                    child: SizedBox(
                      height: height - SolSpacing.lg * 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (label != null)
                            _LabelPill(label: label!, icon: labelIcon)
                          else
                            const SizedBox.shrink(),
                          Flexible(
                            child: isDoc
                                ? const _DocumentGuide()
                                : const _FaceGuide(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: SolSpacing.xs,
                            ),
                            child: Text(
                              instruction,
                              textAlign: TextAlign.center,
                              style: context.solText.body.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelPill extends StatelessWidget {
  const _LabelPill({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    const fg = Color(0xCCFFFFFF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: const BoxDecoration(
        color: Color(0x66000000),
        borderRadius: SolRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: SolSpacing.xs),
          ],
          Flexible(
            child: Text(
              label.toUpperCase(),
              style: context.solText.note.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.275,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Marco de documento 296 × 190 con esquinas y silueta guía.
class _DocumentGuide extends StatelessWidget {
  const _DocumentGuide();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 296 / 190,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 296),
        child: CustomPaint(
          painter: const _DashedFramePainter(oval: false),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    SolIcons.portrait,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: SolSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bar(0.9, 8, 0.3),
                      const SizedBox(height: 6),
                      _bar(0.6, 6, 0.2),
                      const SizedBox(height: 6),
                      _bar(0.8, 6, 0.2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bar(double widthFactor, double height, double alpha) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: alpha),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/// Óvalo para el rostro (prueba de vida).
class _FaceGuide extends StatelessWidget {
  const _FaceGuide();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SolSpacing.md),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: const AspectRatio(
          aspectRatio: 3 / 4,
          child: CustomPaint(painter: _DashedFramePainter(oval: true)),
        ),
      ),
    );
  }
}

/// Borde punteado blanco de 2 dp, oscurece el exterior y dibuja esquinas.
class _DashedFramePainter extends CustomPainter {
  const _DashedFramePainter({required this.oval});

  final bool oval;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final shape = oval
        ? (Path()..addOval(rect))
        : (Path()..addRRect(
            RRect.fromRectAndRadius(
              rect,
              const Radius.circular(SolRadius.card),
            ),
          ));

    // Velo exterior (25 % negro) para resaltar la zona de encuadre.
    final outside = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(400))
      ..addPath(shape, Offset.zero);
    canvas.drawPath(outside, Paint()..color = const Color(0x40000000));
    canvas.drawPath(shape, Paint()..color = const Color(0x0DFFFFFF));

    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final metric in shape.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final end = math.min(d + 6, metric.length);
        canvas.drawPath(metric.extractPath(d, end), stroke);
        d += 10;
      }
    }

    if (!oval) {
      // Esquinas de 10 dp, a 14 dp del borde.
      const inset = 14.0;
      const len = 10.0;
      final c = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      final l = inset, t = inset;
      final r = size.width - inset, b = size.height - inset;
      canvas
        ..drawPath(
          Path()
            ..moveTo(l, t + len)
            ..lineTo(l, t)
            ..lineTo(l + len, t),
          c,
        )
        ..drawPath(
          Path()
            ..moveTo(r - len, t)
            ..lineTo(r, t)
            ..lineTo(r, t + len),
          c,
        )
        ..drawPath(
          Path()
            ..moveTo(l, b - len)
            ..lineTo(l, b)
            ..lineTo(l + len, b),
          c,
        )
        ..drawPath(
          Path()
            ..moveTo(r - len, b)
            ..lineTo(r, b)
            ..lineTo(r, b - len),
          c,
        );
    }
  }

  @override
  bool shouldRepaint(_DashedFramePainter old) => old.oval != oval;
}
