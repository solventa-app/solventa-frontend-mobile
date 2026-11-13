import '../../../../core/contrato/schema.graphql.dart';
import '../../../../core/network/graphql_client.dart';
import '../../../../core/push/instalacion_id.dart';
import '../graphql/onboarding.graphql.dart';

/// Acceso al BFF para el onboarding y sesión de la app (contrato v0.21).
/// Devuelve los tipos generados; el repositorio los mapea. [token] es el
/// `X-Onboarding-Token`.
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

  /// Registra una cuenta con correo, clave y código OTP sin token de onboarding.
  Future<Mutation$RegistrarCuenta$registrarCuenta> registrarCuenta(
    String correo,
    String clave,
    String codigo,
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

  /// Envía un código OTP de 6 dígitos al correo durante el onboarding.
  Future<Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding> enviarCodigo(
    String token,
    String correo,
  );

  /// Verifica el código OTP de 6 dígitos enviado al correo.
  Future<Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding>
  verificarCodigo(String token, String correo, String codigo);

  /// Inicia sesión con usuario/correo y clave en el canal app.
  Future<Mutation$IniciarSesion$iniciarSesion> iniciarSesion(
    String usuario,
    String clave,
  );

  /// Pide el enlace para elegir una clave nueva (público; no revela si la
  /// cuenta existe). El enlace llega por correo y se abre en la web.
  Future<bool> solicitarRestablecimientoClave(String correo);

  /// Con sesión: guarda la llave pública del teléfono. Devuelve el id.
  Future<String> registrarDispositivo(String clavePublica);

  /// Pública: el reto que el teléfono firma con su llave.
  Future<String> desafioDispositivo(String dispositivoId);

  /// Pública: entra con la firma del reto, sin clave.
  Future<Mutation$IniciarSesionConDispositivo$iniciarSesionConDispositivo>
  iniciarSesionConDispositivo(String dispositivoId, String reto, String firma);

  /// Devuelve el usuario autenticado (`yo`).
  Future<Fragment$UsuarioCampos?> yo();

  /// Actualiza el idioma y moneda preferidos del usuario.
  Future<Mutation$ActualizarPreferencias$actualizarPreferencias>
  actualizarPreferencias(String idioma, String moneda);

  /// HU-M04 Fase 6 (KAN-259): liga el token de FCM a esta instalación.
  Future<bool> registrarTokenPush(String instalacionId, String tokenFcm);

  /// Perfil, interruptor «Notificaciones push».
  Future<bool> actualizarPreferenciaPush(bool habilitado);
}

/// Implementación real contra `POST /graphql/app`.
final class GqlOnboardingRemoteDataSource
    implements OnboardingRemoteDataSource {
  const GqlOnboardingRemoteDataSource(this._cliente, {this._instalacion});

  static const cabeceraToken = 'X-Onboarding-Token';

  /// La app móvil es solo del cliente: `iniciarSesion` lo manda siempre como
  /// `CredencialesInput.rol` (contrato v0.29, T17). Si la cuenta tiene otro
  /// rol, el backend responde igual que con una clave errada.
  static const rolApp = Enum$RolUsuario.CLIENTE;

  final GraphqlClient _cliente;

  /// KAN-259: con él, `iniciarSesion` manda `CredencialesInput.dispositivo` para que AUTH deje
  /// activo el dispositivo de push de esta instalación. Sin eso, `registrarTokenPush` responde
  /// error (no hay dispositivo con push activo) y el teléfono nunca recibe pushes.
  final InstalacionIdStore? _instalacion;

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
  Future<Mutation$RegistrarCuenta$registrarCuenta> registrarCuenta(
    String correo,
    String clave,
    String codigo,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationRegistrarCuenta,
      variables: Variables$Mutation$RegistrarCuenta(
        correo: correo,
        clave: clave,
        codigo: codigo,
      ).toJson(),
    );
    return Mutation$RegistrarCuenta.fromJson(data).registrarCuenta;
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

  @override
  Future<Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding> enviarCodigo(
    String token,
    String correo,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationEnviarCodigoOnboarding,
      variables: Variables$Mutation$EnviarCodigoOnboarding(correo: correo)
          .toJson(),
      cabeceras: _con(token),
    );
    return Mutation$EnviarCodigoOnboarding.fromJson(data)
        .enviarCodigoOnboarding;
  }

  @override
  Future<Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding>
  verificarCodigo(String token, String correo, String codigo) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationVerificarCodigoOnboarding,
      variables: Variables$Mutation$VerificarCodigoOnboarding(
        correo: correo,
        codigo: codigo,
      ).toJson(),
      cabeceras: _con(token),
    );
    return Mutation$VerificarCodigoOnboarding.fromJson(data)
        .verificarCodigoOnboarding;
  }

  @override
  Future<String> registrarDispositivo(String clavePublica) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationRegistrarDispositivo,
      variables: Variables$Mutation$RegistrarDispositivo(
        clavePublica: clavePublica,
      ).toJson(),
    );
    return Mutation$RegistrarDispositivo.fromJson(data).registrarDispositivo;
  }

  @override
  Future<String> desafioDispositivo(String dispositivoId) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationDesafioDispositivo,
      variables: Variables$Mutation$DesafioDispositivo(
        dispositivoId: dispositivoId,
      ).toJson(),
    );
    return Mutation$DesafioDispositivo.fromJson(data).desafioDispositivo.reto;
  }

  @override
  Future<Mutation$IniciarSesionConDispositivo$iniciarSesionConDispositivo>
  iniciarSesionConDispositivo(
    String dispositivoId,
    String reto,
    String firma,
  ) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationIniciarSesionConDispositivo,
      variables: Variables$Mutation$IniciarSesionConDispositivo(
        dispositivoId: dispositivoId,
        reto: reto,
        firma: firma,
      ).toJson(),
    );
    return Mutation$IniciarSesionConDispositivo.fromJson(data)
        .iniciarSesionConDispositivo;
  }

  @override
  Future<bool> solicitarRestablecimientoClave(String correo) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationSolicitarRestablecimientoClave,
      variables: Variables$Mutation$SolicitarRestablecimientoClave(
        correo: correo,
      ).toJson(),
    );
    return Mutation$SolicitarRestablecimientoClave.fromJson(data)
        .solicitarRestablecimientoClave;
  }

  @override
  Future<Mutation$IniciarSesion$iniciarSesion> iniciarSesion(
    String usuario,
    String clave,
  ) async {
    final instalacionId = await _instalacion?.obtener();
    final data = await _cliente.ejecutar(
      documentNodeMutationIniciarSesion,
      variables: Variables$Mutation$IniciarSesion(
        entrada: Input$CredencialesInput(
          usuario: usuario,
          clave: clave,
          rol: rolApp,
          dispositivo: instalacionId == null
              ? null
              : Input$DispositivoPushInput(
                  instalacionId: instalacionId,
                  plataforma: Enum$PlataformaMovil.ANDROID,
                ),
        ),
      ).toJson(),
    );
    return Mutation$IniciarSesion.fromJson(data).iniciarSesion;
  }

  @override
  Future<Fragment$UsuarioCampos?> yo() async {
    final data = await _cliente.ejecutar(documentNodeQueryYo);
    return Query$Yo.fromJson(data).yo;
  }

  @override
  Future<Mutation$ActualizarPreferencias$actualizarPreferencias>
  actualizarPreferencias(String idioma, String moneda) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationActualizarPreferencias,
      variables: Variables$Mutation$ActualizarPreferencias(
        entrada: Input$PreferenciasInput(idioma: idioma, moneda: moneda),
      ).toJson(),
    );
    return Mutation$ActualizarPreferencias.fromJson(data)
        .actualizarPreferencias;
  }

  @override
  Future<bool> registrarTokenPush(String instalacionId, String tokenFcm) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationRegistrarTokenPush,
      variables: Variables$Mutation$RegistrarTokenPush(
        instalacionId: instalacionId,
        tokenFcm: tokenFcm,
      ).toJson(),
    );
    return Mutation$RegistrarTokenPush.fromJson(data).registrarTokenPush;
  }

  @override
  Future<bool> actualizarPreferenciaPush(bool habilitado) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationActualizarPreferenciaPush,
      variables: Variables$Mutation$ActualizarPreferenciaPush(
        habilitado: habilitado,
      ).toJson(),
    );
    return Mutation$ActualizarPreferenciaPush.fromJson(data)
        .actualizarPreferenciaPush;
  }
}
