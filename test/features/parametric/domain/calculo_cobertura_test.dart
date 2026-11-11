import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/parametric/data/fixtures/cobertura_fixtures.dart';
import 'package:solventa_mobile/features/parametric/domain/calculo_cobertura.dart';
import 'package:solventa_mobile/features/parametric/domain/entities/cobertura.dart';

/// HU-M04: las cifras de M04-04 cuadran con los mockups (§3.2 del plan).
void main() {
  test('usado, disponible, porcentaje y total de los mockups', () {
    final r = CoberturaFixtures.resumen(EscenarioCobertura.sinSaldo);

    // La cancelación LA4012 es de una póliza anterior: no descuenta.
    expect(r.usado, 630000);
    expect(r.disponible, 1370000);
    expect(r.fraccionUsada, closeTo(0.315, 1e-9));
    expect(r.porcentajeUsado, 32);
    expect(r.totalIndemnizado, 950000);
    expect(r.desde, DateTime(2026, 7, 3, 9, 15));
  });

  test('el saldo de prima no altera usado ni disponible (M04-D4)', () {
    for (final e in EscenarioCobertura.values) {
      final r = CoberturaFixtures.resumen(e);
      expect(r.usado, 630000, reason: '$e');
      expect(r.disponible, 1370000, reason: '$e');
    }
  });

  test('tope 0 no divide por cero', () {
    final r = ResumenCobertura(
      producto: 'Viaje paramétrico',
      numeroPoliza: 'SOL-PV-0',
      vigente: true,
      vigenteHasta: DateTime(2026, 11, 30),
      tope: 0,
      movimientos: CoberturaFixtures.movimientos,
    );

    expect(r.fraccionUsada, 0);
    expect(r.porcentajeUsado, 0);
    expect(r.disponible, 0);
  });

  test('pagos por encima del tope: disponible 0 y barra llena', () {
    final r = ResumenCobertura(
      producto: 'Viaje paramétrico',
      numeroPoliza: 'SOL-PV-1',
      vigente: true,
      vigenteHasta: DateTime(2026, 11, 30),
      tope: 500000,
      movimientos: CoberturaFixtures.movimientos,
    );

    expect(r.disponible, 0);
    expect(r.fraccionUsada, 1);
    expect(r.porcentajeUsado, 100);
  });

  test('sin movimientos: todo en cero y sin fecha de inicio', () {
    final r = CoberturaFixtures.resumen(
      EscenarioCobertura.aFavor,
      sinMovimientos: true,
    );

    expect(r.usado, 0);
    expect(r.disponible, 2000000);
    expect(r.totalIndemnizado, 0);
    expect(r.desde, isNull);
  });

  test('SaldoPrima.aFavor según el signo', () {
    expect(CoberturaFixtures.saldo(EscenarioCobertura.aFavor)!.aFavor, isTrue);
    expect(
      CoberturaFixtures.saldo(EscenarioCobertura.enContra)!.aFavor,
      isFalse,
    );
    expect(CoberturaFixtures.saldo(EscenarioCobertura.sinSaldo), isNull);
  });
}
