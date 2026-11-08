import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/features/parametric/data/datasources/cobertura_remote_datasource.dart';
import 'package:solventa_mobile/features/parametric/data/fixtures/cobertura_fixtures.dart';
import 'package:solventa_mobile/features/parametric/data/repositories/cobertura_repository_impl.dart';
import 'package:solventa_mobile/features/parametric/domain/entities/cobertura.dart';

/// HU-M04: el repositorio envuelve el fake en `Resultado` (M04-D3).
void main() {
  CoberturaRepositoryImpl repo(EscenarioCobertura e, {bool fallar = false}) =>
      CoberturaRepositoryImpl(
        FakeCoberturaRemoteDataSource(
          escenario: e,
          latencia: Duration.zero,
          fallar: fallar,
        ),
      );

  test('los tres escenarios devuelven su saldo', () async {
    final sin = await repo(EscenarioCobertura.sinSaldo).resumen();
    final favor = await repo(EscenarioCobertura.aFavor).resumen();
    final contra = await repo(EscenarioCobertura.enContra).resumen();

    expect((sin as Exito<ResumenCobertura>).valor.saldo, isNull);
    expect((favor as Exito<ResumenCobertura>).valor.saldo!.monto, 38500);
    expect((contra as Exito<ResumenCobertura>).valor.saldo!.monto, -38500);
    expect(favor.valor.movimientos, hasLength(3));
    expect(favor.valor.cuentaDestino, hasLength(16));
  });

  test('indemnización por id', () async {
    final r = await repo(EscenarioCobertura.aFavor)
        .indemnizacion('IND-2026-0912');

    final m = (r as Exito<Indemnizacion>).valor;
    expect(m.tipo, TipoEventoParametrico.retrasoVuelo);
    expect(m.monto, 450000);
    expect(m.pagadoEn, DateTime(2026, 9, 12, 11, 2));
  });

  test(
    'id desconocido: Fracaso, sin excepción hacia la presentación',
    () async {
      final r = await repo(EscenarioCobertura.aFavor)
          .indemnizacion('NO-EXISTE');
      expect(r, isA<Fracaso<Indemnizacion>>());
    },
  );

  test('sin red: Fracaso con la falla de red', () async {
    final r = await repo(EscenarioCobertura.aFavor, fallar: true).resumen();

    expect(r, isA<Fracaso<ResumenCobertura>>());
    expect((r as Fracaso<ResumenCobertura>).falla, isA<Falla>());
  });
}
