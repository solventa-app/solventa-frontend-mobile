import 'package:flutter/painting.dart';

/// Escala tipográfica M3 en Inter (Figma SG-01). Tamaños en sp.
abstract final class SolTypography {
  static const String fontFamily = 'Inter';

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    leadingDistribution: TextLeadingDistribution.even,
    letterSpacing: 0,
  );

  /// 24/600 · saludo y título de contenido.
  static final TextStyle headlineSmall = _base.copyWith(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
  );

  /// 20/700 · wordmark «Solventa» en la barra de nivel superior.
  static final TextStyle wordmark = _base.copyWith(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w700,
  );

  /// 16/600 · título de barra superior y botones.
  static final TextStyle titleMedium = _base.copyWith(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  /// 14/600 · títulos de fila y tarjeta (G-03).
  static final TextStyle titleSmall = _base.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );

  /// 16/400 · cuerpo grande.
  static final TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  /// 14/400 · cuerpo y metadatos.
  static final TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  /// 12/400 · texto pequeño.
  static final TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  /// 16/600 · etiqueta de botón.
  static final TextStyle labelLarge = _base.copyWith(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  /// 12/500 · enlaces pequeños («Olvidé mi PIN o patrón»).
  static final TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  /// 11/600 · píldoras y barra inferior.
  static final TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w600,
  );

  /// 11/400 · notas y anotaciones.
  static final TextStyle note = _base.copyWith(
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w400,
  );
}
