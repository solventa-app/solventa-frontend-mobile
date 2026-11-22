import '../../../../core/almacen/almacen_local.dart';
import '../../../../core/log/sol_log.dart';
import '../../domain/entities/reporte_guardado.dart';
import '../../domain/repositories/almacen_reportes.dart';

/// Lo que el teléfono deja de guardar (plan 4.2 y 4.6). Nunca borra un
/// reporte completo que siga sin enviar: eso solo lo decide el cliente.
///
/// - Borradores sin tocar por 7 días.
/// - Enviados hace más de 24 horas: ya están en la aseguradora.
/// - Todo lo de una cuenta que no entra hace 30 días.
Future<void> limpiarReportes({
  required AlmacenReportes almacen,
  required AlmacenLocal local,
  required String cuentaId,
  required DateTime ahora,
}) async {
  try {
    for (final r in await almacen.deCuenta(cuentaId)) {
      final borradorViejo =
          r.estado == EstadoLocal.borrador &&
          ahora.difference(r.actualizadoEn) > LimitesLocales.vidaBorrador;
      final enviadoViejo =
          r.estado == EstadoLocal.enviado &&
          ahora.difference(r.enviadoEn ?? r.actualizadoEn) >
              LimitesLocales.vidaEnviado;
      if (borradorViejo || enviadoViejo) await almacen.borrar(r.id);
    }
    final limite = ahora.subtract(LimitesLocales.vidaOtraCuenta);
    for (final otra in await local.cuentasSinEntrarDesde(limite)) {
      if (otra == cuentaId) continue;
      await almacen.borrarDeCuenta(otra);
      await local.olvidarCuenta(otra);
    }
  } on Object catch (e) {
    SolLog.warning(
      'No se pudo limpiar el almacén local',
      codigo: e.runtimeType.toString(),
    );
  }
}
