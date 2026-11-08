import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formatos es-CO de Solventa (Figma SG-01 · Formato es-CO).
///
/// - Montos: `$ 450.000` (sin decimales, punto de miles).
/// - Fechas: `12 sep 2026, 11:02 a. m.`
/// - Cuentas: `••••4821`
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

  /// `jul 2026` (mes abreviado y año).
  static String monthYear(DateTime d) => '${_months[d.month - 1]} ${d.year}';

  /// `octubre` (nombre completo del mes, en minúscula).
  static String monthName(DateTime d) => _monthNames[d.month - 1];

  static const List<String> _monthNames = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  /// `••••4821`: deja visibles los últimos [visible] dígitos.
  ///
  /// Para lectores de pantalla usa [maskedAccountSemantics].
  static String maskedAccount(
    String account, {
    int visible = 4,
    String maskChar = '\u2022',
  }) {
    final digits = account.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= visible) return digits;
    return '${maskChar * 4}${digits.substring(digits.length - visible)}';
  }

  /// `•••• •••• •••• 4821`: cuenta o tarjeta completa con todos los dígitos
  /// ocultos salvo los últimos [visible], en grupos de 4 separados por
  /// espacio duro (no se parte en dos líneas). Con menos de [visible] + 1
  /// dígitos devuelve lo mismo que [maskedAccount].
  ///
  /// Para lectores de pantalla usa [maskedAccountSemantics].
  static String maskedAccountFull(String account, {int visible = 4}) {
    final digits = account.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= visible) return maskedAccount(account);
    final masked =
        '\u2022' * (digits.length - visible) +
        digits.substring(digits.length - visible);
    final groups = <String>[];
    for (var end = masked.length; end > 0; end -= 4) {
      groups.insert(0, masked.substring(end - 4 < 0 ? 0 : end - 4, end));
    }
    return groups.join(nbsp);
  }

  /// Etiqueta semántica de una cuenta enmascarada: «cuenta terminada en 4821».
  static String maskedAccountSemantics(String account, {int visible = 4}) {
    final digits = account.replaceAll(RegExp(r'\D'), '');
    final tail = digits.length <= visible
        ? digits
        : digits.substring(digits.length - visible);
    return 'cuenta terminada en $tail';
  }

  /// `1,2 km` (coma decimal es-CO, espacio duro antes de la unidad).
  static String distanceKm(double km) => '${_decimal1.format(km)}${nbsp}km';

  /// `6 min` (espacio duro antes de la unidad).
  static String minutes(int minutes) => '$minutes${nbsp}min';
}
