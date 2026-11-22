import '../../../../core/almacen/almacen_local.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/log/sol_log.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../../domain/repositories/reporte_siniestro_repository.dart';
import 'reporte_local_mapper.dart';

/// Lo que respondió el servidor o, sin conexión, su última copia guardada.
final class ConCopia<T> {
  const ConCopia(this.valor, {this.guardadaEn});

  final T valor;

  /// Cuándo se guardó la copia; `null` si [valor] acaba de llegar del servidor.
  final DateTime? guardadaEn;

  bool get esCopia => guardadaEn != null;
}

/// Pólizas y «Mis siniestros» con respaldo en el teléfono: cada respuesta del
/// servidor reemplaza la copia; sin conexión se muestra la copia con su hora.
/// La copia es solo de lectura: lo que manda es siempre el servidor.
final class CopiasReporte {
  CopiasReporte({
    required this.repositorio,
    required this.local,
    required this.cuenta,
    required this.conectado,
    required this.reloj,
  });

  static const clavePolizas = 'polizas';
  static const claveSiniestros = 'siniestros';

  final ReporteSiniestroRepository repositorio;
  final AlmacenLocal local;

  /// La cuenta con sesión; sin ella no se guarda ni se lee copia.
  final String? Function() cuenta;

  /// Si hay salida a internet ahora mismo.
  final bool Function() conectado;
  final DateTime Function() reloj;

  Future<Resultado<ConCopia<List<PolizaReportable>>>> polizas() => _conCopia(
    clavePolizas,
    repositorio.polizas,
    aJson: polizasAJson,
    desdeJson: polizasDesdeJson,
  );

  Future<Resultado<ConCopia<List<SiniestroReportado>>>> misSiniestros() =>
      _conCopia(
        claveSiniestros,
        repositorio.misSiniestros,
        aJson: siniestrosAJson,
        desdeJson: siniestrosDesdeJson,
      );

  Future<Resultado<ConCopia<T>>> _conCopia<T>(
    String clave,
    Future<Resultado<T>> Function() pedir, {
    required String Function(T) aJson,
    required T Function(String) desdeJson,
  }) async {
    final cuenta = this.cuenta();

    Future<ConCopia<T>?> copia() async {
      if (cuenta == null) return null;
      try {
        final guardada = await local.leerCopia(cuenta, clave);
        if (guardada == null) return null;
        return ConCopia(
          desdeJson(guardada.json),
          guardadaEn: guardada.guardadaEn,
        );
      } on Object catch (e) {
        SolLog.warning(
          'Copia local ilegible',
          codigo: e.runtimeType.toString(),
        );
        return null;
      }
    }

    // Sin conexión no se espera a que la petición agote su tiempo.
    if (!conectado()) {
      final guardada = await copia();
      if (guardada != null) return Exito(guardada);
    }

    switch (await pedir()) {
      case Exito(:final valor):
        if (cuenta != null) {
          try {
            await local.guardarCopia(cuenta, clave, aJson(valor), reloj());
          } on Object catch (e) {
            SolLog.warning(
              'No se pudo guardar la copia local',
              codigo: e.runtimeType.toString(),
            );
          }
        }
        return Exito(ConCopia(valor));
      case Fracaso(:final falla):
        if (falla is SinConexion || falla is ServicioNoDisponible) {
          final guardada = await copia();
          if (guardada != null) return Exito(guardada);
        }
        return Fracaso(falla);
    }
  }
}
