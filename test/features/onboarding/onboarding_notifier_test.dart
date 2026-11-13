import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/preferencias_de_la_cuenta.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

/// Cuenta, código por correo, inicio de sesión y consulta del resultado de
/// M01 contra el fake del BFF, sin pasar por las pantallas.
void main() {
  late FakeOnboardingRemoteDataSource bff;
  late ProviderContainer c;

  OnboardingNotifier notifier() => c.read(onboardingProvider.notifier);
  OnboardingState estado() => c.read(onboardingProvider);

  Future<void> conRecorrido() async {
    notifier().marcarConsentimiento(true);
    expect(await notifier().registrarConsentimiento(), isTrue);
  }

  setUp(() {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    c = ProviderContainer(
      overrides: [
        fakeOnboardingProvider.overrideWithValue(bff),
        esperasVerificacionProvider.overrideWithValue(const [
          Duration.zero,
          Duration.zero,
        ]),
      ],
    );
    addTearDown(c.dispose);
    c.read(onboardingProvider);
  });

  group('registro con código de correo', () {
    test('solicitarCodigoCorreo guarda correo y clave pendientes', () async {
      final ok = await notifier().solicitarCodigoCorreo(
        correo: 'maria@ejemplo.co',
        clave: 'Clave-segura-1',
      );

      expect(ok, isTrue);
      expect(estado().correoPendiente, 'maria@ejemplo.co');
      expect(estado().clavePendiente, 'Clave-segura-1');
      expect(estado().ocupado, isFalse);
    });

    test('reenviarCodigoCorreo sin correo pendiente no hace nada', () async {
      expect(await notifier().reenviarCodigoCorreo(), isFalse);
      expect(bff.operaciones, isEmpty);
    });

    test('reenviarCodigoCorreo vuelve a pedir el código', () async {
      await notifier().solicitarCodigoCorreo(
        correo: 'maria@ejemplo.co',
        clave: 'Clave-segura-1',
      );

      expect(await notifier().reenviarCodigoCorreo(), isTrue);
    });

    test('verificarCodigoYCrearCuenta sin pendientes devuelve false', () async {
      expect(await notifier().verificarCodigoYCrearCuenta('123456'), isFalse);
    });

    test(
      'con el código correcto crea la cuenta y limpia las credenciales',
      () async {
        await notifier().solicitarCodigoCorreo(
          correo: 'maria@ejemplo.co',
          clave: 'Clave-segura-1',
        );

        final ok = await notifier().verificarCodigoYCrearCuenta('123456');

        expect(ok, isTrue);
        expect(estado().cuentaCreada, isTrue);
        expect(estado().perfil, isNotNull);
        expect(estado().correoPendiente, isNull);
        expect(estado().clavePendiente, isNull);
      },
    );

    test(
      'con un código errado deja la falla y conserva las credenciales',
      () async {
        await notifier().solicitarCodigoCorreo(
          correo: 'maria@ejemplo.co',
          clave: 'Clave-segura-1',
        );

        final ok = await notifier().verificarCodigoYCrearCuenta('000000');

        expect(ok, isFalse);
        expect(estado().falla, isNotNull);
        expect(estado().cuentaCreada, isFalse);
        expect(estado().correoPendiente, 'maria@ejemplo.co');
        expect(estado().ocupado, isFalse);
      },
    );
  });

  group('crearCuenta', () {
    test('crea la cuenta y trae el perfil', () async {
      await conRecorrido();
      final ok = await notifier().crearCuenta(
        correo: 'maria@ejemplo.co',
        clave: 'Clave-segura-1',
      );

      expect(ok, isTrue);
      expect(estado().cuentaCreada, isTrue);
      expect(estado().onboarding, isNotNull);
    });

    test('con el correo ya registrado deja la falla', () async {
      bff.cuenta = OnboardingFixtures.correoRegistrado;

      final ok = await notifier().crearCuenta(
        correo: 'maria@ejemplo.co',
        clave: 'Clave-segura-1',
      );

      expect(ok, isFalse);
      expect(estado().falla, isNotNull);
      expect(estado().cuentaCreada, isFalse);
    });
  });

  group('iniciarSesion', () {
    test('con credenciales válidas abre la cuenta', () async {
      final ok = await notifier().iniciarSesion(
        correo: 'maria@ejemplo.co',
        clave: 'Clave-segura-1',
      );

      expect(ok, isTrue);
      expect(estado().cuentaCreada, isTrue);
      expect(estado().perfil, isNotNull);
      expect(estado().ocupado, isFalse);
    });

    test('una cuenta con otro rol se rechaza', () async {
      bff.respuestaIniciarSesion = OnboardingFixtures.iniciarSesionConRol(
        'ASESOR',
      );

      final ok = await notifier().iniciarSesion(
        correo: 'asesor@ejemplo.co',
        clave: 'Clave-segura-1',
      );

      expect(ok, isFalse);
      expect(estado().cuentaCreada, isFalse);
    });
  });

  group('resultado de la verificación', () {
    test('verificada: actualiza la sesión y el perfil', () async {
      await notifier().actualizar();

      expect(estado().verificacion, EstadoVerificacion.verificada);
      expect(estado().consultasAgotadas, isFalse);
      expect(bff.operaciones, contains('actualizarSesion'));
    });

    test('rechazada queda como rechazada', () async {
      bff.resultado = OnboardingFixtures.onboarding(estado: 'RECHAZADA');

      await notifier().actualizar();

      expect(estado().verificacion, EstadoVerificacion.rechazada);
    });

    test('en revisión queda como enRevision', () async {
      bff.resultado = OnboardingFixtures.onboarding(estado: 'EN_REVISION');

      await notifier().actualizar();

      expect(estado().verificacion, EstadoVerificacion.enRevision);
    });

    test(
      'si sigue pendiente, actualizar marca las consultas agotadas',
      () async {
        bff.consultasPendientes = 5;

        await notifier().actualizar();

        expect(estado().consultasAgotadas, isTrue);
        expect(estado().verificacion, isNull);
      },
    );

    test('verificar espera el resultado dentro de sus consultas', () async {
      bff.consultasPendientes = 1;

      await notifier().verificar();

      expect(estado().verificacion, EstadoVerificacion.verificada);
      expect(estado().consultasAgotadas, isFalse);
    });

    test('verificar agota las consultas si nunca llega', () async {
      bff.consultasPendientes = 99;

      await notifier().verificar();

      expect(estado().consultasAgotadas, isTrue);
    });
  });

  group('sesión', () {
    test(
      'reanudarSesion marca la cuenta como abierta y trae el perfil',
      () async {
        await notifier().reanudarSesion();

        expect(estado().cuentaCreada, isTrue);
        expect(estado().sesionCerrada, isFalse);
        expect(estado().perfil, isNotNull);
      },
    );

    group('idioma y moneda de la cuenta', () {
      test('al abrir la sesión se aplican las del perfil', () async {
        bff.usuarioActual = {
          ...bff.usuarioActual,
          'idioma': 'EN',
          'moneda': 'USD',
        };
        c.read(preferenciasDeLaCuentaProvider);

        await notifier().reanudarSesion();

        expect(c.read(localeProvider).languageCode, 'en');
        expect(c.read(monedaProvider), 'USD');
        // Ya coinciden con la cuenta: no se vuelven a guardar.
        await Future<void>.delayed(const Duration(milliseconds: 900));
        expect(
          bff.operaciones,
          isNot(contains('actualizarPreferencias')),
          reason:
              'perfil=${estado().perfil?.idioma}/${estado().perfil?.moneda} local=${c.read(localeProvider)}/${c.read(monedaProvider)} cuenta=${bff.usuarioActual['idioma']}/${bff.usuarioActual['moneda']}',
        );
      });

      test('lo que se cambia con sesión se guarda en la cuenta', () async {
        c.read(preferenciasDeLaCuentaProvider);
        await notifier().reanudarSesion();
        expect(c.read(localeProvider).languageCode, 'es');

        c.read(localeProvider.notifier).cambiar(AppLocales.en);
        c.read(monedaProvider.notifier).cambiar('MXN');
        await Future<void>.delayed(const Duration(milliseconds: 900));

        expect(
          bff.operaciones.where((o) => o == 'actualizarPreferencias'),
          hasLength(1),
        );
        expect(estado().perfil!.idioma.toUpperCase(), 'EN');
        expect(estado().perfil!.moneda, 'MXN');
      });

      test('sin sesión no se manda nada a la cuenta', () async {
        c.read(localeProvider.notifier).cambiar(AppLocales.en);
        await Future<void>.delayed(const Duration(milliseconds: 900));

        expect(bff.operaciones, isNot(contains('actualizarPreferencias')));
      });
    });

    test('marcarSesionVencida vuelve a «Inicia sesión» con la falla', () {
      notifier().marcarSesionVencida();

      expect(estado().sesionCerrada, isTrue);
      expect(estado().falla, isNotNull);
    });

    test(
      'marcarSeguridadTelefonoCambio vuelve a «Inicia sesión» con su falla',
      () {
        notifier().marcarSeguridadTelefonoCambio();

        expect(estado().sesionCerrada, isTrue);
        expect(estado().falla, isA<SeguridadTelefonoCambio>());
      },
    );

    test('cerrarSesion reinicia el estado en memoria', () async {
      await notifier().iniciarSesion(
        correo: 'maria@ejemplo.co',
        clave: 'Clave-segura-1',
      );

      await notifier().cerrarSesion();

      expect(estado().sesionCerrada, isTrue);
      expect(estado().cuentaCreada, isFalse);
      expect(estado().perfil, isNull);
    });

    test('limpiarFalla quita la falla', () async {
      notifier().marcarSesionVencida();

      notifier().limpiarFalla();

      expect(estado().falla, isNull);
    });
  });

  group('reintentarCaptura', () {
    test('vuelve a empezar y limpia la verificación', () async {
      await conRecorrido();
      await notifier().actualizar();

      final ok = await notifier().reintentarCaptura();

      expect(ok, isTrue);
      expect(estado().verificacion, isNull);
      expect(estado().frenteCapturado, isFalse);
      expect(estado().onboarding, isNotNull);
    });
  });

  group('recorrido de captura', () {
    test('registrarConsentimiento exige marcar la casilla', () async {
      expect(await notifier().registrarConsentimiento(), isFalse);
      expect(bff.operaciones, isEmpty);
    });

    test('capturar documento y repetir los lados', () async {
      await conRecorrido();

      expect(await notifier().capturarFrente(), isTrue);
      expect(await notifier().capturarReverso(), isTrue);
      expect(estado().frenteCapturado, isTrue);
      expect(estado().reversoCapturado, isTrue);

      notifier().repetirReverso();
      expect(estado().reversoCapturado, isFalse);
      expect(estado().frenteCapturado, isTrue);

      notifier().repetirFrente();
      expect(estado().frenteCapturado, isFalse);
    });

    test('completarPruebaDeVida sube las cuatro piezas y envía', () async {
      await conRecorrido();
      await notifier().capturarFrente();
      await notifier().capturarReverso();

      final ok = await notifier().completarPruebaDeVida();

      expect(ok, isTrue);
      expect(estado().rostroCapturado, isTrue);
      expect(estado().videoCapturado, isTrue);
      expect(estado().ocupado, isFalse);
      expect(bff.operaciones, contains('enviar'));
    });

    test('si falla la subida deja la falla y no envía', () async {
      await conRecorrido();
      await notifier().capturarFrente();
      await notifier().capturarReverso();
      bff.respuestaSubida = OnboardingFixtures.subidaTokenInvalido;

      final ok = await notifier().completarPruebaDeVida();

      expect(ok, isFalse);
      expect(estado().falla, isNotNull);
      expect(estado().ocupado, isFalse);
      expect(bff.operaciones, isNot(contains('enviar')));
    });

    test('reiniciarRecorrido descarta capturas y consentimiento', () async {
      await conRecorrido();
      await notifier().capturarFrente();

      notifier().reiniciarRecorrido();

      expect(estado().frenteCapturado, isFalse);
      expect(estado().consentimientoMarcado, isFalse);
    });
  });
}
