import '../../../../core/contrato/schema.graphql.dart';
import '../fixtures/onboarding_fixtures.dart';
import '../graphql/onboarding.graphql.dart';
import 'onboarding_remote_datasource.dart';

/// Fake del BFF para `API_ENV=mock` y pruebas. Parsea las fixtures con el
/// mismo `fromJson` generado que usa la implementación real.
final class FakeOnboardingRemoteDataSource
    implements OnboardingRemoteDataSource {
  FakeOnboardingRemoteDataSource({
    this.latencia = const Duration(milliseconds: 600),
  });

  final Duration latencia;

  /// Cómo termina la próxima verificación (los disparadores de demo de M01-05
  /// lo cambian; solo en debug).
  Map<String, dynamic> resultado = OnboardingFixtures.onboarding(
    estado: 'VERIFICADA',
    intentosRestantes: 2,
  );

  /// Cuántas consultas responde EN_VERIFICACION antes del resultado.
  int consultasPendientes = 0;

  /// Respuesta de `crearCuentaOnboarding` (p. ej. el correo ya registrado).
  Map<String, dynamic> cuenta = OnboardingFixtures.cuenta;

  /// Respuesta de `enviarCodigoOnboarding`.
  Map<String, dynamic> respuestaEnviarCodigo = OnboardingFixtures.enviarCodigo;

  /// Respuesta de `verificarCodigoOnboarding`.
  Map<String, dynamic> respuestaVerificarCodigo =
      OnboardingFixtures.verificarCodigo;

  /// Código OTP válido esperado en modo fake (`123456` por defecto).
  String codigoEsperado = '123456';

  /// Usuario actual devuelto por `yo`.
  Map<String, dynamic> usuarioActual = OnboardingFixtures.usuario();

  final operaciones = <String>[];

  Future<Map<String, dynamic>> _responder(
    String operacion,
    Map<String, dynamic> json,
  ) async {
    operaciones.add(operacion);
    await Future<void>.delayed(latencia);
    return json;
  }

  @override
  Future<Mutation$IniciarOnboarding$iniciarOnboarding> iniciar(
    Enum$TipoDocumentoOnboarding tipoDocumento,
  ) async => Mutation$IniciarOnboarding.fromJson(
    await _responder('iniciar', OnboardingFixtures.iniciar),
  ).iniciarOnboarding;

  @override
  Future<
    Mutation$RegistrarConsentimientoOnboarding$registrarConsentimientoOnboarding
  >
  registrarConsentimiento(String token, String id, String versionTexto) async =>
      Mutation$RegistrarConsentimientoOnboarding.fromJson(
        await _responder('consentimiento', OnboardingFixtures.consentimiento),
      ).registrarConsentimientoOnboarding;

  @override
  Future<Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding>
  solicitarSubida(
    String token,
    String id,
    Enum$PasoOnboarding paso,
    String tipoContenido,
    int tamanoBytes,
  ) async => Mutation$SolicitarSubidaOnboarding.fromJson(
    await _responder('subida:${paso.name}', OnboardingFixtures.subida),
  ).solicitarSubidaOnboarding;

  @override
  Future<Mutation$ConfirmarSubidaOnboarding$confirmarSubidaOnboarding>
  confirmarSubida(String token, String id, String archivoId) async =>
      Mutation$ConfirmarSubidaOnboarding.fromJson(
        await _responder('confirmar', OnboardingFixtures.confirmar),
      ).confirmarSubidaOnboarding;

  @override
  Future<Mutation$CrearCuentaOnboarding$crearCuentaOnboarding> crearCuenta(
    String token,
    String id,
    String correo,
    String clave,
  ) async {
    usuarioActual = OnboardingFixtures.usuario(
      usuario: correo,
      nombre: null,
      estado: 'PENDIENTE_VERIFICACION',
    );
    return Mutation$CrearCuentaOnboarding.fromJson(
      await _responder('cuenta', cuenta),
    ).crearCuentaOnboarding;
  }

  @override
  Future<Mutation$RegistrarCuenta$registrarCuenta> registrarCuenta(
    String correo,
    String clave,
    String codigo,
  ) async {
    if (cuenta.containsKey('crearCuentaOnboarding')) {
      final mapa = cuenta['crearCuentaOnboarding'] as Map<String, dynamic>;
      if (mapa['__typename'] == 'ErrorOnboarding') {
        return Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion(
          mensaje: 'Ya hay una cuenta con este correo.',
          codigo: mapa['codigo'] as String?,
        );
      }
    }
    if (codigo.trim() != codigoEsperado) {
      return Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion(
        mensaje: 'El código no es correcto o venció.',
        codigo: 'CODIGO_INVALIDO',
      );
    }
    usuarioActual = OnboardingFixtures.usuario(
      usuario: correo,
      nombre: null,
      estado: 'PENDIENTE_VERIFICACION',
    );
    return Mutation$RegistrarCuenta$registrarCuenta$$Sesion(
      token: 'fake-jwt-token-onboarding',
      expiraEn: DateTime.now().add(const Duration(hours: 1)),
      usuario: Fragment$UsuarioCampos.fromJson(usuarioActual),
    );
  }

  @override
  Future<Mutation$EnviarVerificacion$enviarVerificacion> enviarVerificacion(
    String token,
    String id,
  ) async => Mutation$EnviarVerificacion.fromJson(
    await _responder('enviar', OnboardingFixtures.enviar),
  ).enviarVerificacion;

  @override
  Future<Mutation$ReintentarOnboarding$reintentarOnboarding> reintentar(
    String token,
    String id,
  ) async => Mutation$ReintentarOnboarding.fromJson(
    await _responder('reintentar', OnboardingFixtures.reintentar),
  ).reintentarOnboarding;

  Map<String, dynamic> _estadoActual() {
    if (consultasPendientes > 0) {
      consultasPendientes--;
      return OnboardingFixtures.onboarding(estado: 'EN_VERIFICACION');
    }
    return resultado;
  }

  @override
  Future<Fragment$OnboardingCampos?> consultar(String token, String id) async =>
      Query$ConsultarOnboarding.fromJson(
        await _responder(
          'consultar',
          OnboardingFixtures.consultar(_estadoActual()),
        ),
      ).onboarding;

  @override
  Future<Fragment$OnboardingCampos?> miVerificacion() async =>
      Query$MiVerificacion.fromJson(
        await _responder(
          'miVerificacion',
          OnboardingFixtures.miVerificacion(_estadoActual()),
        ),
      ).miVerificacion;

  @override
  Future<Mutation$ActualizarSesion$actualizarSesion> actualizarSesion() async {
    usuarioActual = OnboardingFixtures.usuario(
      usuario: (usuarioActual['usuario'] as String?) ?? 'maria@ejemplo.co',
      nombre: 'María',
      estado: 'ACTIVO',
    );
    return Mutation$ActualizarSesion.fromJson(
      await _responder(
        'actualizarSesion',
        OnboardingFixtures.sesionActualizada,
      ),
    ).actualizarSesion;
  }

  @override
  Future<Mutation$EnviarCodigoOnboarding$enviarCodigoOnboarding> enviarCodigo(
    String token,
    String correo,
  ) async => Mutation$EnviarCodigoOnboarding.fromJson(
    await _responder('enviarCodigo', respuestaEnviarCodigo),
  ).enviarCodigoOnboarding;

  @override
  Future<Mutation$VerificarCodigoOnboarding$verificarCodigoOnboarding>
  verificarCodigo(String token, String correo, String codigo) async {
    final json = codigo.trim() == codigoEsperado
        ? respuestaVerificarCodigo
        : OnboardingFixtures.codigoInvalido;
    return Mutation$VerificarCodigoOnboarding.fromJson(
      await _responder('verificarCodigo', json),
    ).verificarCodigoOnboarding;
  }

  @override
  Future<Mutation$IniciarSesion$iniciarSesion> iniciarSesion(
    String usuario,
    String clave,
  ) async {
    usuarioActual = OnboardingFixtures.usuario(usuario: usuario);
    return Mutation$IniciarSesion.fromJson(
      await _responder('iniciarSesion', OnboardingFixtures.iniciarSesion),
    ).iniciarSesion;
  }

  @override
  Future<Fragment$UsuarioCampos?> yo() async => Query$Yo.fromJson(
    await _responder('yo', OnboardingFixtures.yo(usuarioActual)),
  ).yo;

  @override
  Future<Mutation$ActualizarPreferencias$actualizarPreferencias>
  actualizarPreferencias(String idioma, String moneda) async {
    usuarioActual = {...usuarioActual, 'idioma': idioma, 'moneda': moneda};
    return Mutation$ActualizarPreferencias.fromJson(
      await _responder(
        'actualizarPreferencias',
        OnboardingFixtures.actualizarPreferencias(
          idioma: idioma,
          moneda: moneda,
        ),
      ),
    ).actualizarPreferencias;
  }
}
