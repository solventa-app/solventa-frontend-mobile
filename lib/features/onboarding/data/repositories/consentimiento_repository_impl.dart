import '../../../../core/errors/guardar_fallas.dart';
import '../../../../core/errors/resultado.dart';
import '../../domain/entities/consentimiento.dart';
import '../../domain/repositories/consentimiento_repository.dart';
import '../datasources/consentimiento_remote_datasource.dart';
import '../mappers/consentimiento_mapper.dart';

final class ConsentimientoRepositoryImpl implements ConsentimientoRepository {
  const ConsentimientoRepositoryImpl(this._remoto);

  final ConsentimientoRemoteDataSource _remoto;

  @override
  Future<Resultado<Consentimiento>> registrar(
    SolicitudConsentimiento solicitud,
  ) => guardarFallas(
    () async => consentimientoDesdeGql(await _remoto.registrar(solicitud)),
  );
}
