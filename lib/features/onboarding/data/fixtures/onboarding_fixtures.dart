/// Respuestas de ejemplo del onboarding (contrato v0.20), con la forma exacta
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

  static Map<String, dynamic> error(String codigo) => {
    '__typename': 'ErrorOnboarding',
    'codigo': codigo,
  };

  static final iniciar = <String, dynamic>{
    '__typename': 'Mutation',
    'iniciarOnboarding': {
      '__typename': 'InicioOnboarding',
      'token': 'token-onboarding-demo',
      'tokenVenceEn': '2026-10-28T15:30:00Z',
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
        'expiraEn': '2026-10-28T16:00:00Z',
      },
      'onboarding': onboarding(estado: 'EN_VERIFICACION'),
    },
  };

  static final correoRegistrado = <String, dynamic>{
    '__typename': 'Mutation',
    'crearCuentaOnboarding': error('CORREO_YA_REGISTRADO'),
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
      'expiraEn': '2026-10-28T16:00:00Z',
    },
  };
}
