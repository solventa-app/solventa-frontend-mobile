import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/contrato/schema.graphql.dart';
import 'package:solventa_mobile/features/parametric/data/graphql/parametric.graphql.dart';
import 'package:solventa_mobile/features/parametric/data/mappers/cobertura_mapper.dart';
import 'package:solventa_mobile/features/parametric/domain/entities/cobertura.dart';

void main() {
  group('tipoEventoParametricoDesdeGql', () {
    test('mapea los 3 valores conocidos del contrato v0.48', () {
      expect(
        tipoEventoParametricoDesdeGql(Enum$TipoEventoParametrico.VUELO_RETRASO),
        TipoEventoParametrico.retrasoVuelo,
      );
      expect(
        tipoEventoParametricoDesdeGql(
          Enum$TipoEventoParametrico.VUELO_CANCELADO,
        ),
        TipoEventoParametrico.cancelacionVuelo,
      );
      // Las 3 variables de clima del backend colapsan en una sola.
      expect(
        tipoEventoParametricoDesdeGql(Enum$TipoEventoParametrico.CLIMA),
        TipoEventoParametrico.lluvia,
      );
    });

    test('un tipo que la app no conoce cae en lluvia (valor conservador)', () {
      expect(
        tipoEventoParametricoDesdeGql(Enum$TipoEventoParametrico.$unknown),
        TipoEventoParametrico.lluvia,
      );
    });
  });

  group('estadoPagoDesdeGql', () {
    test('EN_PROCESO y PAGADA', () {
      expect(
        estadoPagoDesdeGql(Enum$EstadoIndemnizacion.EN_PROCESO),
        EstadoPago.enProceso,
      );
      expect(
        estadoPagoDesdeGql(Enum$EstadoIndemnizacion.PAGADA),
        EstadoPago.pagado,
      );
    });

    test('un estado desconocido cae en enProceso', () {
      expect(
        estadoPagoDesdeGql(Enum$EstadoIndemnizacion.$unknown),
        EstadoPago.enProceso,
      );
    });
  });

  group('montoDesdeGql', () {
    test('un decimal como texto se redondea a pesos enteros', () {
      final g = Fragment$MontoCampos(valor: '450000', moneda: 'COP');
      expect(montoDesdeGql(g), 450000);
    });

    test('un decimal con fracción se redondea', () {
      final g = Fragment$MontoCampos(valor: '450000.50', moneda: 'COP');
      expect(montoDesdeGql(g), 450001);
    });
  });

  test('indemnizacionDesdeGql mapea todos los campos, incluido el monto', () {
    final g = Fragment$IndemnizacionCampos.fromJson({
      '__typename': 'Indemnizacion',
      'id': 'indem-1',
      'tipo': 'VUELO_RETRASO',
      'referenciaEvento': 'AV9340',
      'detalleEvento': '+180min',
      'fechaEvento': '2026-11-10T14:30:00.000Z',
      'pagadoEn': '2026-11-10T14:32:00.000Z',
      'estado': 'EN_PROCESO',
      'metodoTransferencia': 'ACH Colombia Interbancario',
      'polizaAnterior': false,
      'monto': {'__typename': 'Monto', 'valor': '450000', 'moneda': 'COP'},
    });

    final indemnizacion = indemnizacionDesdeGql(g);

    expect(indemnizacion.id, 'indem-1');
    expect(indemnizacion.tipo, TipoEventoParametrico.retrasoVuelo);
    expect(indemnizacion.monto, 450000);
    expect(indemnizacion.estado, EstadoPago.enProceso);
    expect(indemnizacion.metodoTransferencia, 'ACH Colombia Interbancario');
    expect(indemnizacion.polizaAnterior, isFalse);
  });

  test('metodoTransferencia null se preserva (regla #6 del backend)', () {
    final g = Fragment$IndemnizacionCampos.fromJson({
      '__typename': 'Indemnizacion',
      'id': 'indem-2',
      'tipo': 'CLIMA',
      'referenciaEvento': '4.71,-74.07',
      'detalleEvento': '62 mm',
      'fechaEvento': '2026-10-02T09:00:00.000Z',
      'pagadoEn': '2026-10-02T09:05:00.000Z',
      'estado': 'EN_PROCESO',
      'metodoTransferencia': null,
      'polizaAnterior': false,
      'monto': {'__typename': 'Monto', 'valor': '300000', 'moneda': 'COP'},
    });

    expect(indemnizacionDesdeGql(g).metodoTransferencia, isNull);
  });

  test('resumenCoberturaDesdeGql mapea el tope y los movimientos', () {
    final indemnizacion = Fragment$IndemnizacionCampos.fromJson({
      '__typename': 'Indemnizacion',
      'id': 'indem-3',
      'tipo': 'CLIMA',
      'referenciaEvento': '4.71,-74.07',
      'detalleEvento': '62 mm',
      'fechaEvento': '2026-10-02T09:00:00.000Z',
      'pagadoEn': '2026-10-02T09:05:00.000Z',
      'estado': 'PAGADA',
      'metodoTransferencia': 'ACH Colombia Interbancario',
      'polizaAnterior': false,
      'monto': {'__typename': 'Monto', 'valor': '300000', 'moneda': 'COP'},
    });
    final g = Query$MiCoberturaParametrica$miCoberturaParametrica.fromJson({
      '__typename': 'ResumenCobertura',
      'producto': 'Solventa Paramétrico Vuelo',
      'numeroPoliza': 'POL-DEMO-0042',
      'vigente': true,
      'vigenteHasta': '2027-11-10T00:00:00.000Z',
      'tope': {'__typename': 'Monto', 'valor': '450000', 'moneda': 'COP'},
      'movimientos': [indemnizacion.toJson()],
    });

    final resumen = resumenCoberturaDesdeGql(g);

    expect(resumen.numeroPoliza, 'POL-DEMO-0042');
    expect(resumen.vigente, isTrue);
    expect(resumen.tope, 450000);
    expect(resumen.movimientos, hasLength(1));
    expect(resumen.movimientos.single.id, 'indem-3');
    // Sin ajuste de prima: el backend no tiene ese dato (M04-D4).
    expect(resumen.saldo, isNull);
  });
}
