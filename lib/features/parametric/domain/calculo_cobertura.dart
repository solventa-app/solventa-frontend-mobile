import 'entities/cobertura.dart';

/// Cifras de M04-04 a partir del resumen (funciones puras).
///
/// El saldo de prima no entra en ninguna de estas cuentas (M04-D4).
extension CalculoCobertura on ResumenCobertura {
  /// Pagos de la póliza vigente (los de pólizas anteriores no descuentan).
  int get usado => movimientos
      .where((m) => !m.polizaAnterior)
      .fold(0, (total, m) => total + m.monto);

  /// Lo que queda del tope; nunca negativo.
  int get disponible => tope - usado < 0 ? 0 : tope - usado;

  /// Fracción exacta del tope usada (0 a 1), para la barra.
  double get fraccionUsada => tope <= 0 ? 0 : (usado / tope).clamp(0, 1);

  /// Porcentaje redondeado para el texto: 630.000 / 2.000.000 → 32.
  int get porcentajeUsado => (fraccionUsada * 100).round();

  /// Todos los pagos recibidos, de todas las pólizas.
  int get totalIndemnizado => movimientos.fold(0, (t, m) => t + m.monto);

  /// Fecha del pago más antiguo (o `null` sin pagos).
  DateTime? get desde => movimientos.isEmpty
      ? null
      : movimientos
            .map((m) => m.pagadoEn)
            .reduce((a, b) => a.isBefore(b) ? a : b);
}
