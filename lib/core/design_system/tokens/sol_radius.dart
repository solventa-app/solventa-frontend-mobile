import 'package:flutter/painting.dart';

/// Radios de forma (Figma SG-01 · Formas).
abstract final class SolRadius {
  /// Botones y píldoras: forma completa.
  static const double full = 999;

  /// Tarjetas y hoja inferior.
  static const double card = 12;

  /// Campos y teclas del PIN.
  static const double field = 8;

  /// Casilla de verificación.
  static const double checkbox = 4;

  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius fieldAll = BorderRadius.all(Radius.circular(field));
}
