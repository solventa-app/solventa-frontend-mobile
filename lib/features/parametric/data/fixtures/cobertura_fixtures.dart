import '../../domain/entities/cobertura.dart';

/// Los tres estados de M04-04 (mockups de `docs/hu-m04/diseno/`).
enum EscenarioCobertura { sinSaldo, aFavor, enContra }

/// Datos de los mockups de HU-M04. Montos en pesos; la cuenta va completa
/// (16 dígitos) y solo se muestran los últimos 4 (M04-D1).
abstract final class CoberturaFixtures {
  static const cuenta = '4532015112834821';

  static final retrasoVuelo = Indemnizacion(
    id: 'IND-2026-0912',
    tipo: TipoEventoParametrico.retrasoVuelo,
    referenciaEvento: 'AV204',
    detalleEvento: '+3h40',
    fechaEvento: DateTime(2026, 9, 12),
    pagadoEn: DateTime(2026, 9, 12, 11, 2),
    monto: 450000,
    estado: EstadoPago.pagado,
    cuentaDestino: cuenta,
  );

  static final lluvia = Indemnizacion(
    id: 'IND-2026-0828',
    tipo: TipoEventoParametrico.lluvia,
    referenciaEvento: 'Bogotá',
    detalleEvento: '62 mm',
    fechaEvento: DateTime(2026, 8, 28),
    pagadoEn: DateTime(2026, 8, 28, 16, 40),
    monto: 180000,
    estado: EstadoPago.pagado,
    cuentaDestino: cuenta,
  );

  static final cancelacionVuelo = Indemnizacion(
    id: 'IND-2026-0703',
    tipo: TipoEventoParametrico.cancelacionVuelo,
    referenciaEvento: 'LA4012',
    detalleEvento: '',
    fechaEvento: DateTime(2026, 7, 3),
    pagadoEn: DateTime(2026, 7, 3, 9, 15),
    monto: 320000,
    estado: EstadoPago.pagado,
    cuentaDestino: cuenta,
    polizaAnterior: true,
  );

  static final movimientos = [retrasoVuelo, lluvia, cancelacionVuelo];

  static SaldoPrima? saldo(EscenarioCobertura escenario) => switch (escenario) {
    EscenarioCobertura.sinSaldo => null,
    EscenarioCobertura.aFavor => SaldoPrima(
      monto: 38500,
      periodo: DateTime(2026, 10),
    ),
    EscenarioCobertura.enContra => SaldoPrima(
      monto: -38500,
      periodo: DateTime(2026, 10),
    ),
  };

  /// Póliza `SOL-PV-2026-00381`: tope $ 2.000.000, usado $ 630.000 (32 %),
  /// disponible $ 1.370.000 y total indemnizado $ 950.000.
  static ResumenCobertura resumen(
    EscenarioCobertura escenario, {
    bool sinMovimientos = false,
  }) => ResumenCobertura(
    producto: 'Viaje paramétrico',
    numeroPoliza: 'SOL-PV-2026-00381',
    vigente: true,
    vigenteHasta: DateTime(2026, 11, 30),
    tope: 2000000,
    cuentaDestino: cuenta,
    movimientos: sinMovimientos ? const [] : movimientos,
    saldo: saldo(escenario),
  );
}
