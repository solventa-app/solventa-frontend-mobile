import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// Normaliza el espacio duro para comparar con el texto del Figma.
String plain(String s) => s.replaceAll(SolFormat.nbsp, ' ');

void main() {
  group('SolFormat.currency', () {
    test('formatea montos como en el Figma', () {
      expect(plain(SolFormat.currency(450000)), r'$ 450.000');
      expect(plain(SolFormat.currency(1250000)), r'$ 1.250.000');
      expect(plain(SolFormat.currency(0)), r'$ 0');
      expect(plain(SolFormat.currency(999.6)), r'$ 1.000');
      expect(plain(SolFormat.currency(-450000)), r'-$ 450.000');
    });

    test('usa espacio duro entre símbolo y cifra', () {
      expect(SolFormat.currency(450000), '\$ 450.000');
    });
  });

  group('SolFormat.dateTime', () {
    test('formato del Figma', () {
      final d = DateTime(2026, 9, 12, 11, 2);
      expect(plain(SolFormat.dateTime(d)), '12 sep 2026, 11:02 a. m.');
    });

    test('tarde, mediodía y medianoche', () {
      expect(plain(SolFormat.time(DateTime(2026, 1, 1, 15, 30))), '3:30 p. m.');
      expect(plain(SolFormat.time(DateTime(2026, 1, 1, 12, 0))), '12:00 p. m.');
      expect(plain(SolFormat.time(DateTime(2026, 1, 1, 0, 5))), '12:05 a. m.');
    });

    test('meses abreviados es-CO', () {
      const expected = [
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
      for (var m = 1; m <= 12; m++) {
        expect(
          SolFormat.date(DateTime(2026, m, 1)),
          '1 ${expected[m - 1]} 2026',
        );
      }
    });
  });

  group('SolFormat.maskedAccount', () {
    test('deja visibles los últimos 4 dígitos', () {
      expect(SolFormat.maskedAccount('1234 5678 4821'), '****4821');
      expect(SolFormat.maskedAccount('004821'), '****4821');
    });

    test('no enmascara cuentas cortas', () {
      expect(SolFormat.maskedAccount('4821'), '4821');
    });

    test('admite otro carácter de máscara', () {
      expect(SolFormat.maskedAccount('99994821', maskChar: '•'), '••••4821');
    });
  });

  test('distancia y minutos', () {
    expect(SolFormat.distanceKm(1.2), '1,2 km');
    expect(SolFormat.minutes(6), '6 min');
    expect(SolFormat.number(1250), '1.250');
  });

  test('locales soportados incluyen es-CO', () {
    expect(SolLocalizations.supportedLocales.first, SolFormat.locale);
    SolLocalizations.init();
  });
}
