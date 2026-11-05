import '../../../../core/errors/resultado.dart';
import '../entities/reporte_siniestro.dart';

abstract interface class ReporteSiniestroRepository {
  /// Pólizas emitidas del cliente, para elegir sobre cuál reporta.
  Future<Resultado<List<PolizaReportable>>> polizas();

  /// Sube las fotos y crea el caso. Una regla que CLAIMS rechaza llega como
  /// `FallaNegocio` con el mensaje para el cliente en `motivo`. Reintentar con
  /// el mismo reporte no vuelve a subir las fotos que ya subieron ni crea otro
  /// caso.
  Future<Resultado<SiniestroReportado>> reportar(ReporteSiniestro reporte);
}
