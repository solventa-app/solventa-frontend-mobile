import 'package:flutter/widgets.dart';
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
      expect(SolFormat.maskedAccount('1234 5678 4821'), '••••4821');
      expect(SolFormat.maskedAccount('004821'), '••••4821');
    });

    test('no enmascara cuentas cortas', () {
      expect(SolFormat.maskedAccount('4821'), '4821');
    });

    test('admite otro carácter de máscara', () {
      expect(SolFormat.maskedAccount('99994821', maskChar: '*'), '****4821');
    });

    test('etiqueta semántica legible', () {
      expect(
        SolFormat.maskedAccountSemantics('1234 5678 4821'),
        'cuenta terminada en 4821',
      );
    });
  });

  group('HU-M04', () {
    test('monthYear: mes abreviado y año', () {
      expect(SolFormat.monthYear(DateTime(2026, 7, 3)), 'jul 2026');
      expect(SolFormat.monthYear(DateTime(2026, 12)), 'dic 2026');
      expect(SolFormat.monthName(DateTime(2026, 10)), 'octubre');
    });

    test('maskedAccountFull: 16 dígitos con solo los últimos 4 visibles', () {
      expect(
        SolFormat.maskedAccountFull('4532 0151 1283 4821'),
        '••••\u00A0••••\u00A0••••\u00A04821',
      );
      expect(
        SolFormat.maskedAccountFull('0012004821'),
        '••\u00A0••••\u00A04821',
      );
      // Con 4 dígitos o menos no hay qué ocultar: igual que maskedAccount.
      expect(SolFormat.maskedAccountFull('4821'), '4821');
      expect(
        SolFormat.maskedAccountSemantics('4532015112834821'),
        'cuenta terminada en 4821',
      );
    });
  });

  test('distancia y minutos', () {
    // Espacio duro (U+00A0) entre cifra y unidad.
    expect(SolFormat.distanceKm(1.2), '1,2\u00A0km');
    expect(SolFormat.minutes(6), '6\u00A0min');
    expect(SolFormat.number(1250), '1.250');
  });

  test('locales soportados incluyen es-CO', () {
    expect(SolLocalizations.supportedLocales.first, SolFormat.locale);
    SolLocalizations.init();
  });

  group('Formatos según el idioma activo (arquitectura §7)', () {
    const es = Locale('es', 'CO');
    const en = Locale('en');
    final d = DateTime(2026, 9, 12, 11, 2);

    test('montos en COP: \$ en español, código en inglés', () {
      expect(plain(SolFormat.currencyIn(450000, 'COP', es)), r'$ 450.000');
      expect(plain(SolFormat.currencyIn(450000, 'COP', en)), 'COP 450,000');
      expect(plain(SolFormat.currencyIn('-450000', 'COP', es)), r'-$ 450.000');
    });

    test('otras monedas con su código y sus decimales', () {
      expect(plain(SolFormat.currencyIn('109.76', 'USD', es)), 'USD 109,76');
      expect(plain(SolFormat.currencyIn('109.76', 'USD', en)), 'USD 109.76');
      expect(plain(SolFormat.currencyIn('1234.5', 'EUR', es)), 'EUR 1.234,50');
      expect(plain(SolFormat.currencyIn('100000', 'CLP', en)), 'CLP 100,000');
    });

    test('el monto nunca se parte en dos líneas', () {
      expect(SolFormat.currencyIn('1', 'USD', en), contains(SolFormat.nbsp));
    });

    test('fechas en inglés', () {
      expect(SolFormat.dateFor(d, en), 'Sep 12, 2026');
      expect(plain(SolFormat.dateTimeFor(d, en)), 'Sep 12, 2026, 11:02 AM');
      expect(SolFormat.monthYearFor(d, en), 'Sep 2026');
      expect(SolFormat.monthNameFor(d, en), 'September');
    });

    test('en español se mantiene el formato del Figma', () {
      expect(SolFormat.dateFor(d, es), SolFormat.date(d));
      expect(SolFormat.dateTimeFor(d, es), SolFormat.dateTime(d));
      expect(SolFormat.monthNameFor(d, es), 'septiembre');
    });
  });
}
