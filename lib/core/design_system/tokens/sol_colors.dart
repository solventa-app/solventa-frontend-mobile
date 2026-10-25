import 'package:flutter/painting.dart';

/// Paleta base de Solventa (Figma SG-01 · Guía de estilos).
///
/// Las features no usan estos valores directamente: leen los roles del tema
/// (`Theme.of(context).colorScheme` y `context.solColors`).
abstract final class SolColors {
  // Marca e interacción.
  static const Color seed = Color(0xFF1E4680);
  static const Color primary = Color(0xFF1E4680);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF2B5AA3);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFEEEDF3);
  static const Color onSecondaryContainer = Color(0xFF1E4680);
  static const Color primaryContainer = Color(0xFFEBF1FA);
  static const Color onPrimaryContainer = Color(0xFF1E4680);

  /// Píldora del destino activo y borde de la píldora de idioma.
  static const Color indicator = Color(0xFFD7E2FF);

  // Superficie y texto.
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF5F5F5);
  static const Color outline = Color(0xFFD9D9D9);
  static const Color onSurface = Color(0xFF333333);
  static const Color onSurfaceVariant = Color(0xFF6E6E6E);

  // Estados (siempre acompañados de ícono o texto).
  static const Color success = Color(0xFF2E7C56);
  static const Color successContainer = Color(0xFFE8F6F1);
  static const Color warning = Color(0xFF8D651E);
  static const Color warningContainer = Color(0xFFFDF1E4);
  static const Color error = Color(0xFF994D4D);
  static const Color errorContainer = Color(0xFFFDECEC);
  static const Color onError = Color(0xFFFFFFFF);

  // Deshabilitado (botón M01-02 / M02-02).
  static const Color disabledContainer = Color(0xFFD9D9D9);
  static const Color disabledContent = Color(0xFF6E6E6E);

  // Visor de cámara (M01-03) y tirador de la hoja inferior (M06-01).
  static const Color cameraViewport = Color(0xFF1F1F1F);
  static const Color sheetHandle = Color(0x99C3C6D1);

  /// Sombra suave de tarjetas elevadas (0 1 1 rgba(0,0,0,.05)).
  static const Color softShadow = Color(0x0D000000);
}
