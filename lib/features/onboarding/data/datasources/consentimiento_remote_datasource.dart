import '../../../../core/contrato/schema.graphql.dart';
import '../../../../core/network/graphql_client.dart';
import '../../domain/entities/consentimiento.dart';
import '../graphql/registrar_consentimiento.graphql.dart';

/// Acceso al BFF para el consentimiento. Devuelve tipos generados del
/// contrato; el repositorio los mapea a entidades.
abstract interface class ConsentimientoRemoteDataSource {
  Future<Mutation$RegistrarConsentimiento$registrarConsentimiento> registrar(
    SolicitudConsentimiento solicitud,
  );
}

/// Implementación real contra `POST /graphql/app`.
final class GqlConsentimientoRemoteDataSource
    implements ConsentimientoRemoteDataSource {
  const GqlConsentimientoRemoteDataSource(this._cliente);

  /// Canal que el BFF registra en AUTH (`ConsentimientoInput.canal`).
  static const canal = 'APP';

  final GraphqlClient _cliente;

  @override
  Future<Mutation$RegistrarConsentimiento$registrarConsentimiento> registrar(
    SolicitudConsentimiento solicitud,
  ) async {
    final variables = Variables$Mutation$RegistrarConsentimiento(
      entrada: Input$ConsentimientoInput(
        finalidad: solicitud.finalidad,
        versionTexto: solicitud.versionTexto,
        documentoIdentidad: solicitud.documentoIdentidad,
        canal: canal,
      ),
    );
    final data = await _cliente.ejecutar(
      documentNodeMutationRegistrarConsentimiento,
      variables: variables.toJson(),
    );
    return Mutation$RegistrarConsentimiento.fromJson(data)
        .registrarConsentimiento;
  }
}
