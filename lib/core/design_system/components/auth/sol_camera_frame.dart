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

  /// Reverso del documento (código de barras, chip y zona MRZ), M01-04.
  documentBack,

  /// Rostro para prueba de vida: marco de 200 × 260 con bordes de 100 dp, M01-05.
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
    this.guideLabel,
    this.viewfinderLabel = 'Visor de cámara',
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

  /// Marca de agua del reverso («LADO POSTERIOR»). Solo para [SolCameraFrameShape.documentBack].
  final String? guideLabel;

  /// Nombre del visor para TalkBack (traducido por la feature).
  final String viewfinderLabel;

  @override
  Widget build(BuildContext context) {
    final sol = context.solColors;
    final back = shape == SolCameraFrameShape.documentBack;
    return Semantics(
      container: true,
      label: [?label, viewfinderLabel, instruction].join('. '),
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
                  if (back) const Positioned.fill(child: _GridOverlay()),
                  if (shape == SolCameraFrameShape.document)
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
                    // El texto superpuesto se limita a 1,3× para que la guía
                    // siga visible con texto grande.
                    child: SizedBox(
                      height: height - SolSpacing.lg * 2,
                      child: MediaQuery.withClampedTextScaling(
                        maxScaleFactor: 1.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (label != null)
                              _LabelPill(label: label!, icon: labelIcon)
                            else
                              const SizedBox.shrink(),
                            Flexible(
                              child: switch (shape) {
                                SolCameraFrameShape.document =>
                                  const _DocumentGuide(),
                                SolCameraFrameShape.documentBack =>
                                  _DocumentBackGuide(label: guideLabel),
                                SolCameraFrameShape.face => const _FaceGuide(),
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: SolSpacing.xs,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: shape == SolCameraFrameShape.face
                                      ? 240
                                      : double.infinity,
                                ),
                                child: Text(
                                  instruction,
                                  textAlign: TextAlign.center,
                                  style: context.solText.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
            Icon(icon, size: 16, opticalSize: 20, color: fg),
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 296),
      child: AspectRatio(
        aspectRatio: 296 / 190,
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
                    opticalSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: SolSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Anchos fijos del Figma (2001:370).
                      _bar(156, 8, 0.3),
                      const SizedBox(height: 6),
                      _bar(104, 6, 0.2),
                      const SizedBox(height: 6),
                      _bar(138.66, 6, 0.2),
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

  // Si el marco es más angosto, el ancho se recorta al disponible.
  Widget _bar(double width, double height, double alpha) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

/// Marco del rostro (2001:507): 200 × 260, bordes de 100 dp, ícono de rostro y
/// línea de escaneo.
class _FaceGuide extends StatelessWidget {
  const _FaceGuide();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: SolSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: AspectRatio(
          aspectRatio: 200 / 260,
          child: CustomPaint(
            painter: const _DashedFramePainter(oval: true),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(SolIcons.face, size: 40, color: Color(0x80FFFFFF)),
                Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x00FFFFFF),
                        Color(0x66FFFFFF),
                        Color(0x00FFFFFF),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cuadrícula 3 × 3 sutil del visor del reverso (2001:416).
class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _GridPainter());
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0x1AFFFFFF)
      ..strokeWidth = 1;
    for (var i = 1; i < 3; i++) {
      final x = size.width * i / 3, y = size.height * i / 3;
      canvas
        ..drawLine(Offset(x, 0), Offset(x, size.height), p)
        ..drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

/// Reverso de la cédula (2001:431): código de barras, chip, marca de agua y MRZ.
class _DocumentBackGuide extends StatelessWidget {
  const _DocumentBackGuide({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    // Zona de lectura mecánica: barras con texto monoespaciado de 6 dp.
    Widget mrz(String texto, double? w) => Container(
      width: w,
      height: 6,
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Color(0x80FFFFFF)),
      child: Text(
        texto,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 6,
          height: 1,
          letterSpacing: 0.6,
          color: Colors.white,
        ),
      ),
    );
    Widget bar(double? w, double h, double a) => Container(
      width: w,
      height: h,
      color: Colors.white.withValues(alpha: a),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 296),
      child: AspectRatio(
        aspectRatio: 296 / 190,
        child: CustomPaint(
          painter: const _DashedFramePainter(oval: false, corners: false),
          child: Padding(
            padding: const EdgeInsets.all(SolSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: SizedBox(
                        width: 112,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bar(112, 6, 0.7),
                            const SizedBox(height: 4),
                            bar(93.33, 4, 0.4),
                            const SizedBox(height: 4),
                            bar(112, 8, 0.6),
                            const SizedBox(height: 4),
                            bar(74.66, 4, 0.3),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0x1AFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        SolIcons.fingerprint,
                        size: 16,
                        opticalSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0x1AFFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          SolIcons.documentBack,
                          size: 18,
                          opticalSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      if (label != null) ...[
                        const SizedBox(height: SolSpacing.xs),
                        Text(
                          label!.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.solText.note.copyWith(
                            color: const Color(0x99FFFFFF),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.275,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Opacity(
                  opacity: 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mrz('I<COL0000000000<<<<<<<<<<<<<<<', null),
                      const SizedBox(height: 4),
                      mrz('9001018M3001015COL<<<<<<<<<<8', 211.19),
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
}

/// Borde punteado blanco de 2 dp, oscurece el exterior y dibuja esquinas.
class _DashedFramePainter extends CustomPainter {
  const _DashedFramePainter({required this.oval, this.corners = true});

  final bool oval;

  /// Esquinas guía (solo en el frente del documento).
  final bool corners;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final shape = oval
        ? (Path()..addRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(size.width / 2)),
          ))
        : (Path()..addRRect(
            RRect.fromRectAndRadius(
              rect,
              const Radius.circular(SolRadius.card),
            ),
          ));

    if (oval) {
      // Rostro (2001:507): solo el borde punteado.
    } else if (corners) {
      // Frente (2001:362): velo exterior del 25 % y relleno blanco del 5 %.
      final outside = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rect.inflate(400))
        ..addPath(shape, Offset.zero);
      canvas
        ..drawPath(outside, Paint()..color = const Color(0x40000000))
        ..drawPath(shape, Paint()..color = const Color(0x0DFFFFFF));
    } else {
      // Reverso (2001:431): relleno negro del 25 %.
      canvas.drawPath(shape, Paint()..color = const Color(0x40000000));
    }

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

    if (!oval && corners) {
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
  bool shouldRepaint(_DashedFramePainter old) =>
      old.oval != oval || old.corners != corners;
}
