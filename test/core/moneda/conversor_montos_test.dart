import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/moneda/conversor_montos.dart';

import '../../helpers/bff_de_prueba.dart';

/// Cuenta las llamadas para ver que el lote junta los montos de un cuadro.
final class _ConversorContado implements ConversorMontos {
  _ConversorContado(this._real);

  final ConversorMontos _real;
  final llamadas = <List<String>>[];
  bool fallar = false;

  @override
  Future<List<String>> convertir(List<String> valores, String moneda) {
    llamadas.add(valores);
    if (fallar) throw StateError('BFF caído');
    return _real.convertir(valores, moneda);
  }
}

void main() {
  group('FakeConversorMontos (tabla del ACL, decimales ISO)', () {
    test('COP a USD con 2 decimales y a CLP sin decimales', () async {
      final fake = FakeConversorMontos();
      expect(await fake.convertir(['61200', '4100'], 'USD'), ['14.93', '1.00']);
      expect(await fake.convertir(['435000'], 'CLP'), ['100000']);
    });

    test('moneda no soportada lanza', () {
      expect(
        () => FakeConversorMontos().convertir(['1'], 'JPY'),
        throwsStateError,
      );
    });
  });

  group('LoteConversion', () {
    test('junta los montos de un mismo cuadro en una sola llamada', () async {
      final conversor = _ConversorContado(FakeConversorMontos());
      final lote = LoteConversion(conversor);
      final r = await Future.wait([
        lote.convertir('450000', 'USD'),
        lote.convertir('8200', 'USD'),
        lote.convertir('450000', 'USD'),
      ]);
      expect(r, ['109.76', '2.00', '109.76']);
      expect(conversor.llamadas, [
        ['450000', '8200'],
      ]);
    });

    test(
      'recuerda lo convertido: volver a la moneda no llama de nuevo',
      () async {
        final conversor = _ConversorContado(FakeConversorMontos());
        final lote = LoteConversion(conversor);
        await lote.convertir('450000', 'EUR');
        await lote.convertir('450000', 'EUR');
        expect(conversor.llamadas, hasLength(1));
      },
    );

    test('COP no llama al BFF', () async {
      final conversor = _ConversorContado(FakeConversorMontos());
      expect(
        await LoteConversion(conversor).convertir('450000', 'COP'),
        '450000',
      );
      expect(conversor.llamadas, isEmpty);
    });

    test('un fallo devuelve null y no se recuerda', () async {
      final conversor = _ConversorContado(FakeConversorMontos())..fallar = true;
      final lote = LoteConversion(conversor);
      expect(await lote.convertir('450000', 'USD'), isNull);
      conversor.fallar = false;
      expect(await lote.convertir('450000', 'USD'), '109.76');
      expect(conversor.llamadas, hasLength(2));
    });

    test('parte en tramos de 50 (límite de convertirMontos)', () async {
      final conversor = _ConversorContado(FakeConversorMontos());
      final lote = LoteConversion(conversor);
      await Future.wait([
        for (var i = 1; i <= 120; i++) lote.convertir('$i', 'USD'),
      ]);
      expect(conversor.llamadas.map((l) => l.length), [50, 50, 20]);
    });
  });

  test(
    'GqlConversorMontos manda los montos en COP y lee los convertidos',
    () async {
      final bff = BffDePrueba()
        ..responder({
          'convertirMontos': [
            {'valor': '109.76', 'moneda': 'USD', '__typename': 'Monto'},
          ],
          '__typename': 'Query',
        });
      final r = await GqlConversorMontos(bff.cliente)
          .convertir(['450000'], 'USD');
      expect(r, ['109.76']);
      expect(bff.query, contains('convertirMontos'));
      expect(bff.variables, {
        'montos': [
          {'valor': '450000', 'moneda': 'COP'},
        ],
        'moneda': 'USD',
      });
    },
  );
}
