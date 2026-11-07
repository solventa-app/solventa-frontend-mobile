/// Respuestas de ejemplo del onboarding (contrato v0.21), con la forma exacta
/// del BFF (el `data` de la respuesta GraphQL, con `__typename`). Las usan el
/// fake (API_ENV=mock) y las pruebas; `test/contract/` comprueba que parsean.
abstract final class OnboardingFixtures {
  static Map<String, dynamic> onboarding({
    String estado = 'INICIADO',
    String? motivo,
    int intento = 1,
    int intentosRestantes = 2,
  }) => {
    '__typename': 'Onboarding',
    'id': 'onboarding-demo-1',
    'estado': estado,
    'motivo': motivo,
    'intento': intento,
    'intentosRestantes': intentosRestantes,
  };

  static Map<String, dynamic> error(String codigo, [String? mensaje]) => {
    '__typename': 'ErrorOnboarding',
    'codigo': codigo,
    'mensaje': ?mensaje,
  };

  static Map<String, dynamic> codigoEnviado({
    String correoEnmascarado = 'm•••@ejemplo.co',
    String venceEn = '2026-10-31T21:00:00.000Z',
  }) => {
    '__typename': 'CodigoOnboardingEnviado',
    'correoEnmascarado': correoEnmascarado,
    'venceEn': venceEn,
  };

  static Map<String, dynamic> usuario({
    String id = 'usuario-demo-1',
    String usuario = 'maria@ejemplo.co',
    String? nombre = 'María',
    String rol = 'CLIENTE',
    String estado = 'ACTIVO',
    String? documentoEnmascarado = '••••••4050',
    String? correo = 'maria@ejemplo.co',
    String creadoEn = '2026-10-28T15:00:00.000Z',
    String idioma = 'ES',
    String moneda = 'COP',
    bool tieneContacto = true,
  }) => {
    '__typename': 'Usuario',
    'id': id,
    'usuario': usuario,
    'nombre': nombre,
    'rol': rol,
    'estado': estado,
    'documentoEnmascarado': documentoEnmascarado,
    'correo': correo,
    'creadoEn': creadoEn,
    'idioma': idioma,
    'moneda': moneda,
    'tieneContacto': tieneContacto,
  };

  static final iniciar = <String, dynamic>{
    '__typename': 'Mutation',
    'iniciarOnboarding': {
      '__typename': 'InicioOnboarding',
      'token': 'token-onboarding-demo',
      'tokenVenceEn': '2026-10-28T15:30:00.000Z',
      'onboarding': onboarding(),
    },
  };

  static final consentimiento = <String, dynamic>{
    '__typename': 'Mutation',
    'registrarConsentimientoOnboarding': onboarding(),
  };

  static final subida = <String, dynamic>{
    '__typename': 'Mutation',
    'solicitarSubidaOnboarding': {
      '__typename': 'SubidaArchivo',
      'url': 'https://almacenamiento.demo/subida-firmada',
      'metodo': 'PUT',
      'encabezados': [
        {
          '__typename': 'EncabezadoSubida',
          'nombre': 'Content-Type',
          'valor': 'image/jpeg',
        },
      ],
      'archivo': {'__typename': 'Archivo', 'id': 'archivo-demo-1'},
    },
  };

  static final confirmar = <String, dynamic>{
    '__typename': 'Mutation',
    'confirmarSubidaOnboarding': onboarding(),
  };

  static final cuenta = <String, dynamic>{
    '__typename': 'Mutation',
    'crearCuentaOnboarding': {
      '__typename': 'CuentaOnboarding',
      'sesion': {
        '__typename': 'Sesion',
        'token': 'jwt-demo-verificacion-pendiente',
        'expiraEn': '2026-10-28T16:00:00.000Z',
        'refreshToken': 'refresh-demo-cuenta',
        'refreshExpiraEn': '2026-11-05T15:00:00.000Z',
      },
      'onboarding': onboarding(estado: 'EN_VERIFICACION'),
    },
  };

  static final correoRegistrado = <String, dynamic>{
    '__typename': 'Mutation',
    'crearCuentaOnboarding': {
      '__typename': 'ErrorOnboarding',
      'codigo': 'CORREO_YA_REGISTRADO',
      'segundosRestantes': null,
    },
  };

  static final enviar = <String, dynamic>{
    '__typename': 'Mutation',
    'enviarVerificacion': onboarding(estado: 'EN_VERIFICACION'),
  };

  static final reintentar = <String, dynamic>{
    '__typename': 'Mutation',
    'reintentarOnboarding': onboarding(intento: 2, intentosRestantes: 1),
  };

  static Map<String, dynamic> consultar(Map<String, dynamic>? o) => {
    '__typename': 'Query',
    'onboarding': o,
  };

  static Map<String, dynamic> miVerificacion(Map<String, dynamic>? o) => {
    '__typename': 'Query',
    'miVerificacion': o,
  };

  static final sesionActualizada = <String, dynamic>{
    '__typename': 'Mutation',
    'actualizarSesion': {
      '__typename': 'Sesion',
      'token': 'jwt-demo-completo',
      'expiraEn': '2026-10-28T16:00:00.000Z',
    },
  };

  static final enviarCodigo = <String, dynamic>{
    '__typename': 'Mutation',
    'enviarCodigoOnboarding': codigoEnviado(),
  };

  /// `enviarCodigoOnboarding` rechazado con `ESPERA_REQUERIDA` y los segundos
  /// que faltan (contrato v0.31).
  static Map<String, dynamic> enviarCodigoEspera(int segundosRestantes) => {
    '__typename': 'Mutation',
    'enviarCodigoOnboarding': {
      '__typename': 'ErrorOnboarding',
      'codigo': 'ESPERA_REQUERIDA',
      'segundosRestantes': segundosRestantes,
    },
  };

  static final verificarCodigo = <String, dynamic>{
    '__typename': 'Mutation',
    'verificarCodigoOnboarding': codigoEnviado(),
  };

  static final codigoInvalido = <String, dynamic>{
    '__typename': 'Mutation',
    'verificarCodigoOnboarding': {
      '__typename': 'ErrorOnboarding',
      'codigo': 'CODIGO_INVALIDO',
      'segundosRestantes': null,
    },
  };

  static Map<String, dynamic> iniciarSesionConRol(String rol) => {
    '__typename': 'Mutation',
    'iniciarSesion': {
      '__typename': 'Sesion',
      'token': 'jwt-demo-completo',
      'expiraEn': '2026-10-28T16:00:00.000Z',
      'refreshToken': 'refresh-demo-login',
      'refreshExpiraEn': '2026-11-05T15:00:00.000Z',
      'usuario': usuario(rol: rol),
    },
  };

  static final iniciarSesion = iniciarSesionConRol('CLIENTE');

  static Map<String, dynamic> yo([Map<String, dynamic>? u]) => {
    '__typename': 'Query',
    'yo': u ?? usuario(),
  };

  static Map<String, dynamic> actualizarPreferencias({
    String idioma = 'ES',
    String moneda = 'COP',
  }) => {
    '__typename': 'Mutation',
    'actualizarPreferencias': usuario(idioma: idioma, moneda: moneda),
  };
}
