import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:solventa_mobile/core/contrato/schema.graphql.dart';
import 'package:solventa_mobile/core/network/graphql_client.dart';
import 'package:solventa_mobile/core/push/instalacion_id.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/data/graphql/onboarding.graphql.dart';

/// BFF de prueba: responde [data] a cualquier operación y guarda la última
/// petición (cuerpo y cabeceras) para revisar qué mandó el datasource.
class _Bff {
  _Bff({InstalacionIdStore? instalacion}) {
    final dio = Dio(BaseOptions(baseUrl: 'http://bff.test'));
    _adaptador = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          cuerpo = o.data as Map<String, dynamic>;
          cabeceras = o.headers;
          h.next(o);
        },
      ),
    );
    remoto = GqlOnboardingRemoteDataSource(
      GraphqlClient(dio),
      instalacion: instalacion,
    );
  }

  late final DioAdapter _adaptador;
  late final GqlOnboardingRemoteDataSource remoto;
  Map<String, dynamic> cuerpo = const {};
  Map<String, dynamic> cabeceras = const {};

  void responder(Map<String, dynamic> data) => _adaptador.onPost(
    GraphqlClient.ruta,
    (server) => server.reply(200, {'data': data}),
  );

  Map<String, dynamic> get variables =>
      cuerpo['variables'] as Map<String, dynamic>;

  String get query => cuerpo['query'] as String;

  String? get tokenOnboarding =>
      cabeceras[GqlOnboardingRemoteDataSource.cabeceraToken] as String?;
}

void main() {
  late _Bff bff;

  setUp(() => bff = _Bff());

  test('iniciarSesion manda el rol CLIENTE de la app', () async {
    bff.responder(OnboardingFixtures.iniciarSesion);

    await bff.remoto.iniciarSesion('maria@ejemplo.co', 'Clave-segura-1');

    final entrada = bff.variables['entrada'] as Map<String, dynamic>;
    expect(entrada['rol'], 'CLIENTE');
    expect(entrada['usuario'], 'maria@ejemplo.co');
    expect(entrada['clave'], 'Clave-segura-1');
    expect(bff.tokenOnboarding, isNull);
  });

  test(
    'iniciarSesion manda el dispositivo de push de la instalación (KAN-259)',
    () async {
      final conInstalacion = _Bff(
        instalacion: MemoriaInstalacionIdStore('inst-123'),
      );
      conInstalacion.responder(OnboardingFixtures.iniciarSesion);

      await conInstalacion.remoto.iniciarSesion('maria@ejemplo.co', 'Clave-1');

      final entrada =
          conInstalacion.variables['entrada'] as Map<String, dynamic>;
      expect(entrada['dispositivo'], {
        'instalacionId': 'inst-123',
        'plataforma': 'ANDROID',
      });
    },
  );

  test('sin instalación, iniciarSesion no manda dispositivo', () async {
    bff.responder(OnboardingFixtures.iniciarSesion);

    await bff.remoto.iniciarSesion('maria@ejemplo.co', 'Clave-1');

    final entrada = bff.variables['entrada'] as Map<String, dynamic>;
    expect(entrada.containsKey('dispositivo'), isFalse);
  });

  group('operaciones del recorrido (llevan X-Onboarding-Token)', () {
    test('iniciar manda el tipo de documento y no lleva token', () async {
      bff.responder(OnboardingFixtures.iniciar);

      final r = await bff.remoto.iniciar(Enum$TipoDocumentoOnboarding.CC);

      expect(r, isNotNull);
      expect(bff.query, contains('iniciarOnboarding'));
      expect(
        (bff.variables['entrada'] as Map<String, dynamic>)['tipoDocumento'],
        'CC',
      );
      expect(bff.tokenOnboarding, isNull);
    });

    test('registrarConsentimiento', () async {
      bff.responder(OnboardingFixtures.consentimiento);

      final r = await bff.remoto.registrarConsentimiento('tok', 'onb-1', 'v1');

      expect(r, isA<Fragment$OnboardingCampos>());
      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables, {'onboardingId': 'onb-1', 'versionTexto': 'v1'});
    });

    test('solicitarSubida', () async {
      bff.responder(OnboardingFixtures.subida);

      await bff.remoto.solicitarSubida(
        'tok',
        'onb-1',
        Enum$PasoOnboarding.ANVERSO,
        'image/jpeg',
        2048,
      );

      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables['paso'], 'ANVERSO');
      expect(bff.variables['tipoContenido'], 'image/jpeg');
      expect(bff.variables['tamanoBytes'], 2048);
    });

    test('confirmarSubida', () async {
      bff.responder(OnboardingFixtures.confirmar);

      final r = await bff.remoto.confirmarSubida('tok', 'onb-1', 'arch-9');

      expect(r, isA<Fragment$OnboardingCampos>());
      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables, {'onboardingId': 'onb-1', 'archivoId': 'arch-9'});
    });

    test('crearCuenta manda correo y clave', () async {
      bff.responder(OnboardingFixtures.cuenta);

      final r = await bff.remoto.crearCuenta(
        'tok',
        'onb-1',
        'maria@ejemplo.co',
        'Clave-segura-1',
      );

      expect(
        r,
        isA<
          Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding
        >(),
      );
      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables['entrada'], {
        'correo': 'maria@ejemplo.co',
        'clave': 'Clave-segura-1',
      });
    });

    test('crearCuenta devuelve el error tipado si el correo existe', () async {
      bff.responder(OnboardingFixtures.correoRegistrado);

      final r = await bff.remoto.crearCuenta('tok', 'onb-1', 'a@b.co', 'x');

      expect(
        r,
        isA<
          Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$ErrorOnboarding
        >(),
      );
    });

    test('enviarVerificacion', () async {
      bff.responder(OnboardingFixtures.enviar);

      final r = await bff.remoto.enviarVerificacion('tok', 'onb-1');

      expect(r, isA<Fragment$OnboardingCampos>());
      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables, {'onboardingId': 'onb-1'});
    });

    test('reintentar', () async {
      bff.responder(OnboardingFixtures.reintentar);

      final r = await bff.remoto.reintentar('tok', 'onb-1');

      expect(r, isA<Fragment$OnboardingCampos>());
      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables, {'onboardingId': 'onb-1'});
    });

    test('consultar devuelve el recorrido', () async {
      bff.responder(
        OnboardingFixtures.consultar(OnboardingFixtures.onboarding()),
      );

      final r = await bff.remoto.consultar('tok', 'onb-1');

      expect(r, isNotNull);
      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables, {'id': 'onb-1'});
    });

    test('consultar devuelve null si el token ya no sirve', () async {
      bff.responder(OnboardingFixtures.consultar(null));

      expect(await bff.remoto.consultar('tok', 'onb-1'), isNull);
    });

    test('enviarCodigo', () async {
      bff.responder(OnboardingFixtures.enviarCodigo);

      await bff.remoto.enviarCodigo('tok', 'maria@ejemplo.co');

      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables, {'correo': 'maria@ejemplo.co'});
    });

    test('verificarCodigo', () async {
      bff.responder(OnboardingFixtures.verificarCodigo);

      await bff.remoto.verificarCodigo('tok', 'maria@ejemplo.co', '123456');

      expect(bff.tokenOnboarding, 'tok');
      expect(bff.variables, {'correo': 'maria@ejemplo.co', 'codigo': '123456'});
    });
  });

  group('operaciones con la sesión de la cuenta (sin token de onboarding)', () {
    test('registrarCuenta manda correo, clave y código', () async {
      bff.responder({
        '__typename': 'Mutation',
        'registrarCuenta': {
          '__typename': 'ErrorAutenticacion',
          'mensaje': 'El código no es correcto o venció.',
          'codigo': 'CODIGO_INVALIDO',
        },
      });

      final r = await bff.remoto.registrarCuenta(
        'maria@ejemplo.co',
        'Clave-segura-1',
        '000000',
      );

      expect(
        r,
        isA<Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion>(),
      );
      expect(bff.tokenOnboarding, isNull);
      expect(bff.variables, {
        'correo': 'maria@ejemplo.co',
        'clave': 'Clave-segura-1',
        'codigo': '000000',
      });
    });

    test('miVerificacion', () async {
      bff.responder(
        OnboardingFixtures.miVerificacion(OnboardingFixtures.onboarding()),
      );

      expect(await bff.remoto.miVerificacion(), isNotNull);
      expect(bff.query, contains('miVerificacion'));
      expect(bff.tokenOnboarding, isNull);
    });

    test('miVerificacion devuelve null sin recorrido', () async {
      bff.responder(OnboardingFixtures.miVerificacion(null));

      expect(await bff.remoto.miVerificacion(), isNull);
    });

    test('actualizarSesion', () async {
      bff.responder(OnboardingFixtures.sesionActualizada);

      final r = await bff.remoto.actualizarSesion();

      expect(r, isA<Mutation$ActualizarSesion$actualizarSesion$$Sesion>());
      expect(
        (r as Mutation$ActualizarSesion$actualizarSesion$$Sesion).token,
        'jwt-demo-completo',
      );
    });

    test('yo devuelve el usuario autenticado', () async {
      bff.responder(OnboardingFixtures.yo());

      expect(await bff.remoto.yo(), isNotNull);
      expect(bff.query, contains('yo'));
    });

    test('actualizarPreferencias manda idioma y moneda', () async {
      bff.responder(OnboardingFixtures.actualizarPreferencias());

      await bff.remoto.actualizarPreferencias('en', 'USD');

      expect(bff.variables['entrada'], {'idioma': 'en', 'moneda': 'USD'});
    });
  });
}
