import '../../../../core/errors/resultado.dart';
import '../entities/asistencia.dart';
import '../entities/prestador.dart';

abstract interface class AsistenciaRepository {
  /// Catálogo maestro de prestadores. Sale de la copia del teléfono mientras
  /// esté vigente; solo consulta al backend cuando vence, y si el backend no
  /// responde sigue con la copia que tenga (docs/hu-m06-backend.md).
  Future<Resultado<CatalogoPrestadores>> catalogoPrestadores();

  /// Envía la solicitud (M06-03). Idempotente por `idSolicitud`: reenviarla
  /// (M06-03b) no crea otra asistencia. Un rechazo de negocio vuelve como
  /// `FallaNegocio` con el código del contrato (`CodigosAsistencia`).
  Future<Resultado<Asistencia>> solicitar(SolicitudAsistencia solicitud);

  /// Cancela (M06-05). Cancelar dos veces devuelve la misma cancelada.
  Future<Resultado<Asistencia>> cancelar(String id);
}
