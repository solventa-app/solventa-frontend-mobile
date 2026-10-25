import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formatos es-CO de Solventa (Figma SG-01 · Formato es-CO).
///
/// - Montos: `$ 450.000` (sin decimales, punto de miles).
/// - Fechas: `12 sep 2026, 11:02 a. m.`
/// - Cuentas: `****4821`
///
/// Entre el símbolo y la cifra, y en «a. m.», se usa un espacio duro
/// (U+00A0) para que el monto nunca se parta en dos líneas.
abstract final class SolFormat {
  static const Locale locale = Locale('es', 'CO');
  static const String localeName = 'es_CO';

  /// Espacio duro.
  static const String nbsp = ' ';

  static final NumberFormat _integer = NumberFormat('#,##0', localeName);
  static final NumberFormat _decimal1 = NumberFormat('#,##0.0', localeName);

  static const List<String> _months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  /// `$ 450.000`. Redondea al peso; negativos como `-$ 450.000`.
  static String currency(num amount) {
    final value = _integer.format(amount.abs().round());
    final sign = amount < 0 ? '-' : '';
    return '$sign\$$nbsp$value';
  }

  /// Número con separador de miles es-CO: `1.250`.
  static String number(num value) => _integer.format(value);

  /// `12 sep 2026`.
  static String date(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// `11:02 a. m.` (reloj de 12 horas).
  static String time(DateTime d) {
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minutes = d.minute.toString().padLeft(2, '0');
    final period = d.hour < 12 ? 'a.${nbsp}m.' : 'p.${nbsp}m.';
    return '$hour12:$minutes $period';
  }

  /// `12 sep 2026, 11:02 a. m.`
  static String dateTime(DateTime d) => '${date(d)}, ${time(d)}';

  /// `****4821`: deja visibles los últimos [visible] dígitos.
  static String maskedAccount(
    String account, {
    int visible = 4,
    String maskChar = '*',
  }) {
    final digits = account.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= visible) return digits;
    return '${maskChar * 4}${digits.substring(digits.length - visible)}';
  }

  /// `1,2 km` (coma decimal es-CO).
  static String distanceKm(double km) => '${_decimal1.format(km)} km';

  /// `6 min`.
  static String minutes(int minutes) => '$minutes min';
}
