import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_typography.dart';
import '../lists/sol_provider_row.dart';

/// Pin de un prestador en el mapa (HU-M06, M1, M3 y M4).
///
/// Combina **tipo × aliado × destacado × seleccionado**:
/// - el ícono dice el tipo y el color dice si es aliado (los mismos de
///   [SolProviderRow], vía [solProviderColors]);
/// - los 3 destacados miden 44 dp y llevan la etiqueta de tiempo («6 min»);
///   los demás, 32 dp y sin etiqueta;
/// - el seleccionado crece un paso (8 dp) y lleva un anillo de 3 dp `primary`.
///
/// Se pinta con un [CustomPainter] para usar el mismo dibujo como widget (mapa
/// falso, galería y goldens) y como imagen PNG para las anotaciones de Mapbox
/// ([SolMapPin.toPng]), que no admiten widgets.
@immutable
class SolMapPinStyle {
  const SolMapPinStyle({
    required this.type,
    required this.isPartner,
    this.featured = false,
    this.selected = false,
    this.label,
  });

  final SolProviderType type;
  final bool isPartner;
  final bool featured;
  final bool selected;

  /// Texto bajo el pin (solo destacados), p. ej. `6 min`.
  final String? label;

  static const double featuredSize = 44;
  static const double regularSize = 32;
  static const double selectedStep = 8;
  static const double ring = 3;
  static const double border = 2;
  static const double labelGap = 4;
  static const double labelHeight = 20;

  double get diameter =>
      (featured ? featuredSize : regularSize) + (selected ? selectedStep : 0);

  /// Tamaño lógico del dibujo completo (pin, anillo y etiqueta).
  Size sizeFor(double labelWidth) {
    final circle = diameter + ring * 2;
    final hasLabel = featured && label != null;
    return Size(
      hasLabel ? (labelWidth > circle ? labelWidth : circle) : circle,
      circle + (hasLabel ? labelGap + labelHeight : 0),
    );
  }

  IconData get icon => switch (type) {
    SolProviderType.medico => SolIcons.medical,
    SolProviderType.mecanico => SolIcons.mechanic,
    SolProviderType.grua => SolIcons.towTruck,
  };

  @override
  bool operator ==(Object other) =>
      other is SolMapPinStyle &&
      other.type == type &&
      other.isPartner == isPartner &&
      other.featured == featured &&
      other.selected == selected &&
      other.label == label;

  @override
  int get hashCode => Object.hash(type, isPartner, featured, selected, label);
}

/// Colores resueltos del tema para pintar fuera del árbol de widgets.
@immutable
class SolMapPinColors {
  const SolMapPinColors({
    required this.partnerBackground,
    required this.partnerForeground,
    required this.regularBackground,
    required this.regularForeground,
    required this.ring,
    required this.border,
    required this.shadow,
    required this.labelBackground,
    required this.labelForeground,
  });

  factory SolMapPinColors.of(BuildContext context) {
    final colors = context.colors;
    final (pBg, pFg) = solProviderColors(context, true);
    final (rBg, rFg) = solProviderColors(context, false);
    return SolMapPinColors(
      partnerBackground: pBg,
      partnerForeground: pFg,
      regularBackground: rBg,
      regularForeground: rFg,
      ring: colors.primary,
      border: colors.surface,
      shadow: context.solColors.softShadow,
      labelBackground: colors.surface,
      labelForeground: colors.onSurface,
    );
  }

  final Color partnerBackground;
  final Color partnerForeground;
  final Color regularBackground;
  final Color regularForeground;
  final Color ring;
  final Color border;
  final Color shadow;
  final Color labelBackground;
  final Color labelForeground;
}

class _SolMapPinPainter extends CustomPainter {
  _SolMapPinPainter(this.style, this.colors);

  final SolMapPinStyle style;
  final SolMapPinColors colors;

  static TextPainter labelPainter(SolMapPinStyle style, Color color) =>
      TextPainter(
        text: TextSpan(
          text: style.label,
          style: SolTypography.labelSmall.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    final d = style.diameter;
    final centerX = size.width / 2;
    final center = Offset(centerX, SolMapPinStyle.ring + d / 2);
    final radius = d / 2;
    final bg = style.isPartner
        ? colors.partnerBackground
        : colors.regularBackground;
    final fg = style.isPartner
        ? colors.partnerForeground
        : colors.regularForeground;

    canvas.drawCircle(
      center.translate(0, 1),
      radius + SolMapPinStyle.border,
      Paint()
        ..color = colors.shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    if (style.selected) {
      canvas.drawCircle(
        center,
        radius + SolMapPinStyle.ring,
        Paint()..color = colors.ring,
      );
    }
    canvas
      ..drawCircle(center, radius, Paint()..color = colors.border)
      ..drawCircle(center, radius - SolMapPinStyle.border, Paint()..color = bg);

    final icon = style.icon;
    final iconSize = d * 0.5;
    final glyph = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: iconSize,
          color: fg,
          height: 1,
          fontVariations: const [FontVariation('FILL', 1)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    glyph.paint(canvas, center - Offset(glyph.width / 2, glyph.height / 2));

    if (style.featured && style.label != null) {
      final text = labelPainter(style, colors.labelForeground);
      final top = SolMapPinStyle.ring * 2 + d + SolMapPinStyle.labelGap;
      final width = text.width + 12;
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, top + SolMapPinStyle.labelHeight / 2),
          width: width,
          height: SolMapPinStyle.labelHeight,
        ),
        const Radius.circular(SolMapPinStyle.labelHeight / 2),
      );
      canvas
        ..drawRRect(
          rect.shift(const Offset(0, 1)),
          Paint()
            ..color = colors.shadow
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        )
        ..drawRRect(rect, Paint()..color = colors.labelBackground);
      text.paint(
        canvas,
        Offset(
          centerX - text.width / 2,
          top + (SolMapPinStyle.labelHeight - text.height) / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_SolMapPinPainter old) =>
      old.style != style || old.colors != colors;
}

class SolMapPin extends StatelessWidget {
  const SolMapPin({super.key, required this.style});

  final SolMapPinStyle style;

  /// Ancho de la etiqueta con su relleno, para reservar el lienzo.
  static double labelWidth(SolMapPinStyle style) =>
      style.featured && style.label != null
      ? _SolMapPinPainter.labelPainter(style, Colors.black).width + 12
      : 0;

  /// Dibujo en PNG para una anotación de Mapbox, a la densidad de la
  /// pantalla. Mapbox lee la densidad del bitmap, así que el pin queda del
  /// mismo tamaño lógico que el widget (verificar en un teléfono, ajuste A9).
  static Future<Uint8List> toPng(
    SolMapPinStyle style,
    SolMapPinColors colors, {
    required double pixelRatio,
  }) async {
    final size = style.sizeFor(labelWidth(style));
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    _SolMapPinPainter(style, colors).paint(canvas, size);
    final image = await recorder.endRecording().toImage(
      (size.width * pixelRatio).ceil(),
      (size.height * pixelRatio).ceil(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return bytes!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final size = style.sizeFor(labelWidth(style));
    return CustomPaint(
      size: size,
      painter: _SolMapPinPainter(style, SolMapPinColors.of(context)),
    );
  }
}

/// Pin del cliente (M10): punto con halo. El color está por confirmar con
/// diseño; el token más cercano al Figma es `error`.
class SolMapUserPin extends StatelessWidget {
  const SolMapUserPin({super.key, this.label});

  /// Etiqueta opcional bajo el punto (p. ej. «Dirección escrita»).
  final String? label;

  static const double halo = 40;
  static const double dot = 16;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pin = SizedBox.square(
      dimension: halo,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(dimension: halo),
          ),
          Container(
            width: dot,
            height: dot,
            decoration: BoxDecoration(
              color: colors.error,
              shape: BoxShape.circle,
              border: Border.all(color: colors.surface, width: 3),
              boxShadow: [
                BoxShadow(color: context.solColors.softShadow, blurRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
    if (label == null) return pin;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        pin,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: context.solColors.softShadow, blurRadius: 4),
            ],
          ),
          child: Text(
            label!,
            style: context.solText.labelStrong.copyWith(
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
