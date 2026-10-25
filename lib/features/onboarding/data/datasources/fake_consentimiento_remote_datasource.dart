import '../../domain/entities/consentimiento.dart';
import '../fixtures/registrar_consentimiento_fixtures.dart';
import '../graphql/registrar_consentimiento.graphql.dart';
import 'consentimiento_remote_datasource.dart';

/// Fake del BFF para `API_ENV=mock` y pruebas. Parsea las fixtures con el
/// mismo `fromJson` generado que usa la implementación real.
final class FakeConsentimientoRemoteDataSource
    implements ConsentimientoRemoteDataSource {
  const FakeConsentimientoRemoteDataSource({
    this.latencia = const Duration(milliseconds: 600),
  });

  /// Retardo simulado para que se vea el estado de carga.
  final Duration latencia;

  @override
  Future<Mutation$RegistrarConsentimiento$registrarConsentimiento> registrar(
    SolicitudConsentimiento solicitud,
  ) async {
    await Future<void>.delayed(latencia);
    return Mutation$RegistrarConsentimiento.fromJson(
      RegistrarConsentimientoFixtures.vigente,
    ).registrarConsentimiento;
  }
}
