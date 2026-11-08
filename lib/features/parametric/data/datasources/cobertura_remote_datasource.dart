import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/cobertura.dart';
import '../fixtures/cobertura_fixtures.dart';

/// Origen de la cobertura paramétrica (HU-M04).
///
/// TODO(KAN-259/BFF): agregar `GqlCoberturaRemoteDataSource` cuando exista la
/// consulta en el contrato. Hoy no hay tipos generados, así que el fake
/// devuelve directamente las entidades (M04-D3).
abstract interface class CoberturaRemoteDataSource {
  Future<ResumenCobertura> resumen();
  Future<Indemnizacion> indemnizacion(String id);
}

/// Datos de los mockups. Con [fallar] lanza [ErrorRed] (estado de error).
final class FakeCoberturaRemoteDataSource implements CoberturaRemoteDataSource {
  FakeCoberturaRemoteDataSource({
    this.escenario = EscenarioCobertura.aFavor,
    this.latencia = const Duration(milliseconds: 400),
    this.fallar = false,
    this.sinMovimientos = false,
  });

  final EscenarioCobertura escenario;
  final Duration latencia;
  bool fallar;

  /// Cliente sin pagos todavía (estado vacío de M04-04).
  final bool sinMovimientos;

  Future<void> _esperar() async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    if (fallar) throw const ErrorRed();
  }

  @override
  Future<ResumenCobertura> resumen() async {
    await _esperar();
    return CoberturaFixtures.resumen(escenario, sinMovimientos: sinMovimientos);
  }

  @override
  Future<Indemnizacion> indemnizacion(String id) async {
    await _esperar();
    return CoberturaFixtures.movimientos.firstWhere(
      (m) => m.id == id,
      orElse: () => throw StateError('Indemnización desconocida'),
    );
  }
}
