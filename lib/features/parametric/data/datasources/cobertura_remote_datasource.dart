import '../../../../core/network/graphql_client.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/cobertura.dart';
import '../fixtures/cobertura_fixtures.dart';
import '../graphql/parametric.graphql.dart';
import '../mappers/cobertura_mapper.dart';

/// Origen de la cobertura paramétrica (HU-M04, contrato v0.48).
abstract interface class CoberturaRemoteDataSource {
  Future<ResumenCobertura> resumen();
  Future<Indemnizacion> indemnizacion(String id);
}

/// El BFF real: `indemnizacion(id)` y `miCoberturaParametrica` (ambas
/// resuelven del CLIENTE del token, nunca de otro). `null` del backend se
/// trata como «desconocida»: el mismo caso que ya cubría el fake.
final class GqlCoberturaRemoteDataSource implements CoberturaRemoteDataSource {
  const GqlCoberturaRemoteDataSource(this._cliente);

  final GraphqlClient _cliente;

  @override
  Future<ResumenCobertura> resumen() async {
    final data = await _cliente.ejecutar(
      documentNodeQueryMiCoberturaParametrica,
    );
    final g = Query$MiCoberturaParametrica.fromJson(data)
        .miCoberturaParametrica;
    if (g == null) throw StateError('Sin cobertura paramétrica vigente');
    return resumenCoberturaDesdeGql(g);
  }

  @override
  Future<Indemnizacion> indemnizacion(String id) async {
    final data = await _cliente.ejecutar(
      documentNodeQueryIndemnizacion,
      variables: Variables$Query$Indemnizacion(id: id).toJson(),
    );
    final g = Query$Indemnizacion.fromJson(data).indemnizacion;
    if (g == null) throw StateError('Indemnización desconocida');
    return indemnizacionDesdeGql(g);
  }
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
