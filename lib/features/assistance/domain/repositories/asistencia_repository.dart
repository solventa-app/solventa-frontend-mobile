import '../../../../core/errors/resultado.dart';
import '../entities/prestador.dart';

abstract interface class AsistenciaRepository {
  /// Catálogo maestro de prestadores. Sale de la copia del teléfono mientras
  /// esté vigente; solo consulta al backend cuando vence, y si el backend no
  /// responde sigue con la copia que tenga (docs/hu-m06-backend.md).
  Future<Resultado<CatalogoPrestadores>> catalogoPrestadores();
}
