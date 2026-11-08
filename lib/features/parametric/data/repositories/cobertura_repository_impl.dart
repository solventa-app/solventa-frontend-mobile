import '../../../../core/errors/guardar_fallas.dart';
import '../../../../core/errors/resultado.dart';
import '../../domain/entities/cobertura.dart';
import '../../domain/repositories/cobertura_repository.dart';
import '../datasources/cobertura_remote_datasource.dart';

final class CoberturaRepositoryImpl implements CoberturaRepository {
  CoberturaRepositoryImpl(this._remote);

  final CoberturaRemoteDataSource _remote;

  @override
  Future<Resultado<ResumenCobertura>> resumen() =>
      guardarFallas(_remote.resumen);

  @override
  Future<Resultado<Indemnizacion>> indemnizacion(String id) =>
      guardarFallas(() => _remote.indemnizacion(id));
}
