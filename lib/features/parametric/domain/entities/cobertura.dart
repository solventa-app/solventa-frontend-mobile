/// Seguro paramétrico (HU-M04): el pago se dispara solo cuando un evento
/// externo supera el umbral de la póliza.
enum TipoEventoParametrico { retrasoVuelo, cancelacionVuelo, lluvia }

enum EstadoPago { pagado, enProceso }

/// Un pago automático por un evento cubierto.
final class Indemnizacion {
  const Indemnizacion({
    required this.id,
    required this.tipo,
    required this.referenciaEvento,
    required this.detalleEvento,
    required this.fechaEvento,
    required this.pagadoEn,
    required this.monto,
    required this.estado,
    required this.cuentaDestino,
    this.polizaAnterior = false,
  });

  /// `IND-2026-0912`.
  final String id;
  final TipoEventoParametrico tipo;

  /// Vuelo (`AV204`) o ciudad (`Bogotá`).
  final String referenciaEvento;

  /// Cuánto superó el umbral: `+3h40`, `62 mm`.
  final String detalleEvento;
  final DateTime fechaEvento;
  final DateTime pagadoEn;

  /// Pesos, entero.
  final int monto;
  final EstadoPago estado;

  /// Número completo de la cuenta o tarjeta. Nunca se muestra entero: la
  /// presentación lo enmascara con `SolFormat.maskedAccountFull` (M04-D1).
  final String cuentaDestino;

  /// `true`: pago de una póliza ya vencida, no descuenta del cupo actual.
  final bool polizaAnterior;
}

/// Ajuste de prima entre el cliente y Solventa. No es cobertura: no cuenta
/// en el cupo usado ni en el disponible (M04-D4).
final class SaldoPrima {
  const SaldoPrima({required this.monto, required this.periodo});

  /// Pesos: mayor que 0 a favor del cliente, menor que 0 en contra.
  final int monto;

  /// Mes del ajuste.
  final DateTime periodo;

  bool get aFavor => monto > 0;
}

/// M04-04 · Mi cobertura.
final class ResumenCobertura {
  const ResumenCobertura({
    required this.producto,
    required this.numeroPoliza,
    required this.vigente,
    required this.vigenteHasta,
    required this.tope,
    required this.cuentaDestino,
    required this.movimientos,
    this.saldo,
  });

  /// `Viaje paramétrico`.
  final String producto;
  final String numeroPoliza;
  final bool vigente;
  final DateTime vigenteHasta;

  /// Tope de cobertura de la póliza vigente, en pesos.
  final int tope;

  /// Número completo; se enmascara al mostrarlo.
  final String cuentaDestino;

  /// Del más reciente al más antiguo.
  final List<Indemnizacion> movimientos;
  final SaldoPrima? saldo;
}
