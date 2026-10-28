import '../../../../core/contrato/schema.graphql.dart';
import '../../../../core/network/graphql_client.dart';
import '../graphql/onboarding.graphql.dart';

/// Acceso al BFF para el onboarding (contrato v0.20). Devuelve los tipos
/// generados; el repositorio los mapea. [token] es el `X-Onboarding-Token`.
abstract interface class OnboardingRemoteDataSource {
  Future<Mutation$IniciarOnboarding$iniciarOnboarding> iniciar(
    Enum$TipoDocumentoOnboarding tipoDocumento,
  );

  Future<
    Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding
  >
  registrarConsentimiento(String token, String id, String versionTexto);

  Future<Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding>
  solicitarSubida(
    String token,
    String id,
    Enum$PasoOnboarding paso,
    String tipoContenido,
    int tamanoBytes,
  );

  Future<Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding>
  confirmarSubida(String token, String id, String archivoId);

  Future<Mutation$CrearCuentaOnboarding$crearCuentaOnboarding> crearCuenta(
    String token,
    String id,
    String correo,
    String clave,
  );

  Future<Mutation$EnviarVerificacion$enviarVerificacion> enviarVerificacion(
    String token,
    String id,
  );

  Future<Mutation$ReintentarOnboarding$reintentarOnboarding> reintentar(
    String token,
    String id,
  );

  /// `null` si el token ya no es de ese recorrido (p. ej. venció).
  Future<Fragment$OnboardingCampos?> consultar(String token, String id);

  /// Con la sesión de la cuenta.
  Future<Fragment$OnboardingCampos?> miVerificacion();

  Future<Mutation$ActualizarSesion$actualizarSesion> actualizarSesion();
}

/// Implementación real contra `POST /graphql/app`.
final class GqlOnboardingRemoteDataSource
    implements OnboardingRemoteDataSource {
  const GqlOnboardingRemoteDataSource(this._cliente);

  static const cabeceraToken = 'X-Onboarding-Token';

  final GraphqlClient _cliente;

  Map<String, String> _con(String token) => {cabeceraToken: token};

  @override
  Future<Mutation$IniciarOnboarding$iniciarOnboarding> iniciar(
    Enum$TipoDocumentoOnboarding tipoDocumento,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationIniciarOnboarding,
      variables: Variables$Mutation$IniciarOnboarding(
        entrada: Input$IniciarOnboardingInput(tipoDocumento: tipoDocumento),
      ).toJson(),
    );
    return Mutation$IniciarOnboarding.fromJson(data).iniciarOnboarding;
  }

  @override
  Future<
    Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding
  >
  registrarConsentimiento(String token, String id, String versionTexto) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationRegistrarConsentimientoOnboarding,
      variables: Variables$Mutation$RegistrarConsentimientoOnboarding(
        onboardingId: id,
        versionTexto: versionTexto,
      ).toJson(),
      cabeceras: _con(token),
    );
    return Mutation$RegistrarConsentimientoOnboarding.fromJson(data)
        .registrarConsentimientoOnboarding;
  }

  @override
  Future<Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding>
  solicitarSubida(
    String token,
    String id,
    Enum$PasoOnboarding paso,
    String tipoContenido,
    int tamanoBytes,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationSolicitarSubidaOnboarding,
      variables: Variables$Mutation$SolicitarSubidaOnboarding(
        onboardingId: id,
        paso: paso,
        tipoContenido: tipoContenido,
        tamanoBytes: tamanoBytes,
      ).toJson(),
      cabeceras: _con(token),
    );
    return Mutation$SolicitarSubidaOnboarding.fromJson(data)
        .solicitarSubidaOnboarding;
  }

  @override
  Future<Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding>
  confirmarSubida(String token, String id, String archivoId) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationConfirmarSubidaOnboarding,
      variables: Variables$Mutation$ConfirmarSubidaOnboarding(
        onboardingId: id,
        archivoId: archivoId,
      ).toJson(),
      cabeceras: _con(token),
    );
    return Mutation$ConfirmarSubidaOnboarding.fromJson(data)
        .confirmarSubidaOnboarding;
  }

  @override
  Future<Mutation$CrearCuentaOnboarding$crearCuentaOnboarding> crearCuenta(
    String token,
    String id,
    String correo,
    String clave,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationCrearCuentaOnboarding,
      variables: Variables$Mutation$CrearCuentaOnboarding(
        onboardingId: id,
        entrada: Input$CuentaOnboardingInput(correo: correo, clave: clave),
      ).toJson(),
      cabeceras: _con(token),
    );
    return Mutation$CrearCuentaOnboarding.fromJson(data).crearCuentaOnboarding;
  }

  @override
  Future<Mutation$EnviarVerificacion$enviarVerificacion> enviarVerificacion(
    String token,
    String id,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationEnviarVerificacion,
      variables: Variables$Mutation$EnviarVerificacion(onboardingId: id)
          .toJson(),
      cabeceras: _con(token),
    );
    return Mutation$EnviarVerificacion.fromJson(data).enviarVerificacion;
  }

  @override
  Future<Mutation$ReintentarOnboarding$reintentarOnboarding> reintentar(
    String token,
    String id,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationReintentarOnboarding,
      variables: Variables$Mutation$ReintentarOnboarding(onboardingId: id)
          .toJson(),
      cabeceras: _con(token),
    );
    return Mutation$ReintentarOnboarding.fromJson(data).reintentarOnboarding;
  }

  @override
  Future<Fragment$OnboardingCampos?> consultar(String token, String id) async {
    final data = await _cliente.ejecutar(
      documentNodeQueryConsultarOnboarding,
      variables: Variables$Query$ConsultarOnboarding(id: id).toJson(),
      cabeceras: _con(token),
    );
    return Query$ConsultarOnboarding.fromJson(data).onboarding;
  }

  @override
  Future<Fragment$OnboardingCampos?> miVerificacion() async {
    final data = await _cliente.ejecutar(documentNodeQueryMiVerificacion);
    return Query$MiVerificacion.fromJson(data).miVerificacion;
  }

  @override
  Future<Mutation$ActualizarSesion$actualizarSesion> actualizarSesion() async {
    final data = await _cliente.ejecutar(documentNodeMutationActualizarSesion);
    return Mutation$ActualizarSesion.fromJson(data).actualizarSesion;
  }
}
