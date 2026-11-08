import '../../../../core/errors/guardar_fallas.dart';
import '../../../../core/errors/resultado.dart';
import '../../domain/entities/asistencia.dart';
import '../../domain/entities/prestador.dart';
import '../../domain/repositories/asistencia_repository.dart';
import '../datasources/asistencia_remote_datasource.dart';
import '../datasources/catalogo_local_datasource.dart';
import '../mappers/asistencia_mapper.dart';
import '../mappers/prestador_mapper.dart';

/// El catálogo es un dato maestro: se usa la copia del teléfono mientras esté
/// vigente y solo al vencer se le pregunta al backend si cambió de versión.
final class AsistenciaRepositoryImpl implements AsistenciaRepository {
  AsistenciaRepositoryImpl(
    this._remote,
    this._local, {
    this.vigencia = const Duration(days: 7),
    DateTime Function()? reloj,
  }) : _reloj = reloj ?? DateTime.now;

  final AsistenciaRemoteDataSource _remote;
  final CatalogoLocalDataSource _local;
  final DateTime Function() _reloj;

  /// Cada cuánto se revisa con el backend si hay una versión nueva.
  final Duration vigencia;

  @override
  Future<Resultado<CatalogoPrestadores>> catalogoPrestadores() async {
    final copia = await _local.leer();
    final ahora = _reloj();
    if (copia != null && ahora.difference(copia.revisadoEn) < vigencia) {
      return guardarFallas(() async => catalogoDesdeMapa(copia.catalogo));
    }

    final r = await guardarFallas(() async {
      final respuesta = await _remote.catalogoPrestadores(
        versionLocal: copia?.version,
      );
      final vigente = respuesta['vigente'] == true && copia != null;
      final mapa = vigente ? copia.catalogo : respuesta;
      // Se mapea antes de guardar: una respuesta que no cumple el contrato
      // no reemplaza la copia buena.
      final catalogo = catalogoDesdeMapa(mapa);
      await _local.guardar(CopiaCatalogo(catalogo: mapa, revisadoEn: ahora));
      return catalogo;
    });

    // Sin red o backend caído: se sigue con la copia vencida si la hay.
    if (r is Fracaso<CatalogoPrestadores> && copia != null) {
      return guardarFallas(() async => catalogoDesdeMapa(copia.catalogo));
    }
    return r;
  }

  @override
  Future<Resultado<Asistencia>> solicitar(SolicitudAsistencia solicitud) =>
      _union(
        () => solicitud.ubicacion == null
            ? _remote.solicitarAsistenciaConDireccion(
                entradaSolicitudConDireccion(solicitud),
              )
            : _remote.solicitarAsistencia(entradaSolicitud(solicitud)),
      );

  @override
  Future<Resultado<Asistencia>> cancelar(String id) =>
      _union(() => _remote.cancelarAsistencia(id));

  /// Las fallas técnicas (red, 503, contrato) las convierte `guardarFallas`;
  /// el `ErrorAsistencia` de la union vuelve como valor con su código.
  Future<Resultado<Asistencia>> _union(
    Future<Map<String, Object?>> Function() llamada,
  ) async {
    final r = await guardarFallas(
      () async => asistenciaDesdeMapa(await llamada()),
    );
    return switch (r) {
      Exito(:final valor) => valor,
      Fracaso(:final falla) => Fracaso(falla),
    };
  }
}
