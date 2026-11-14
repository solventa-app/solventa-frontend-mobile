import '../../../../core/errors/resultado.dart';
import '../entities/cobertura.dart';

/// Cobertura e indemnizaciones paramétricas del cliente (HU-M04).
abstract interface class CoberturaRepository {
  /// M04-04 · Mi cobertura.
  Future<Resultado<ResumenCobertura>> resumen();

  /// M04-02 y M04-03: una indemnización por su id.
  Future<Resultado<Indemnizacion>> indemnizacion(String id);
}
