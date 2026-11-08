import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/network/subida_archivo_service.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/onboarding.dart';

void main() {
  late FakeOnboardingRemoteDataSource bff;
  late FakeSubidaArchivoService subidas;
  late MemoriaSesionStore guardada;
  late FakeSesionRemota remota;
  late GestorSesion sesion;
  late OnboardingRepositoryImpl repo;

  final foto = Captura(
    Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9]),
    'image/jpeg',
  );

  FallaNegocio fallaDe(Resultado<Object?> r) =>
      (r as Fracaso).falla as FallaNegocio;

  setUp(() {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    subidas = FakeSubidaArchivoService();
    guardada = MemoriaSesionStore();
    remota = FakeSesionRemota();
    sesion = GestorSesion(store: guardada, remota: remota);
    repo = OnboardingRepositoryImpl(bff, subidas, sesion);
  });

  test('sin iniciar, cualquier paso falla con TOKEN_INVALIDO', () async {
    final r = await repo.subir(PasoOnboarding.anverso, foto);

    expect(fallaDe(r).motivo, 'TOKEN_INVALIDO');
    expect(bff.operaciones, isEmpty);
  });

  test('inicia una sola vez y consiente antes de subir', () async {
    await repo.iniciarConConsentimiento(versionTexto: 'v1');
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    expect(bff.operaciones, ['iniciar', 'consentimiento', 'consentimiento']);
  });

  Map<String, dynamic> consentimientoRechazado(String codigo) => {
    '__typename': 'Mutation',
    'registrarConsentimientoOnboarding': OnboardingFixtures.error(codigo),
  };

  for (final codigo in ['ESTADO_INVALIDO', 'TOKEN_INVALIDO']) {
    test('con el recorrido viejo agotado ($codigo) abre uno nuevo', () async {
      await repo.iniciarConConsentimiento(versionTexto: 'v1');
      bff.respuestasConsentimiento.add(consentimientoRechazado(codigo));

      final r = await repo.iniciarConConsentimiento(versionTexto: 'v1');

      expect(r, isA<Exito<Onboarding>>());
      expect(bff.operaciones, [
        'iniciar',
        'consentimiento',
        'consentimiento',
        'iniciar',
        'consentimiento',
      ]);
    });
  }

  test('otro rechazo del consentimiento no abre un recorrido nuevo', () async {
    bff.respuestasConsentimiento.add(
      consentimientoRechazado('SIN_CONSENTIMIENTO'),
    );

    final r = await repo.iniciarConConsentimiento(versionTexto: 'v1');

    expect(fallaDe(r).motivo, 'SIN_CONSENTIMIENTO');
    expect(bff.operaciones, ['iniciar', 'consentimiento']);
  });

  test('subir pide la URL, hace el PUT y confirma', () async {
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    final r = await repo.subir(PasoOnboarding.anverso, foto);

    expect(r, isA<Exito<Onboarding>>());
    expect(bff.operaciones.skip(2), ['subida:ANVERSO', 'confirmar']);
    expect(subidas.subidas, hasLength(1));
  });

  test('crear la cuenta abre la sesión y guarda el refresh', () async {
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    final r = await repo.crearCuenta(correo: 'm@e.co', clave: 'clave-segura');

    expect(r, isA<Exito<Onboarding>>());
    expect(sesion.token, 'jwt-demo-verificacion-pendiente');
    expect(await guardada.leerRefresh(), 'refresh-demo-cuenta');
  });

  test('iniciar sesión abre la sesión y guarda el refresh', () async {
    final r = await repo.iniciarSesion(usuario: 'm@e.co', clave: 'clave');

    expect(r, isA<Exito<PerfilUsuario>>());
    expect(sesion.token, 'jwt-demo-completo');
    expect(await guardada.leerRefresh(), 'refresh-demo-login');
  });

  test('descartar el recorrido crea uno nuevo al consentir', () async {
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    repo.descartarRecorrido();
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    expect(bff.operaciones, [
      'iniciar',
      'consentimiento',
      'iniciar',
      'consentimiento',
    ]);
  });

  test('sin recorrido, subir falla con un registro vencido', () async {
    await repo.iniciarConConsentimiento(versionTexto: 'v1');
    repo.descartarRecorrido();

    final r = await repo.subir(PasoOnboarding.anverso, foto);

    final falla = fallaDe(r);
    expect(falla.motivo, 'TOKEN_INVALIDO');
    expect(falla.registroVencido, isTrue);
  });

  test('el perfil trae el correo de Usuario.correo, no el alias', () async {
    bff.usuarioActual = OnboardingFixtures.usuario(
      usuario: 'alias-opaco',
      correo: 'm@e.co',
    );

    final r = await repo.consultarPerfil();

    final perfil = (r as Exito<PerfilUsuario?>).valor;
    expect(perfil?.correo, 'm@e.co');
    expect(perfil?.usuario, 'alias-opaco');
  });

  test('la app no abre sesión con una cuenta que no es de cliente', () async {
    final asesor = OnboardingFixtures.iniciarSesionConRol('ASESOR');
    bff.respuestaIniciarSesion = asesor;

    final r = await repo.iniciarSesion(usuario: 'a@e.co', clave: 'clave');

    // Mismo error que una clave errada: no revela el rol de la cuenta.
    expect(fallaDe(r).motivo, 'CREDENCIALES_INVALIDAS');
    expect(sesion.token, isNull);
    expect(await guardada.hayRefresh(), isFalse);
  });

  test('el correo ya registrado es una FallaNegocio no reintentable', () async {
    bff.cuenta = OnboardingFixtures.correoRegistrado;
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    final r = await repo.crearCuenta(correo: 'm@e.co', clave: 'clave-segura');

    final falla = fallaDe(r);
    expect((falla.motivo, falla.reintentable), ('CORREO_YA_REGISTRADO', false));
    expect(sesion.token, isNull);
    expect(await guardada.hayRefresh(), isFalse);
  });

  test('ESPERA_REQUERIDA trae los segundos que faltan', () async {
    bff.respuestaEnviarCodigo = OnboardingFixtures.enviarCodigoEspera(42);

    final r = await repo.enviarCodigo(correo: 'm@e.co');

    final falla = fallaDe(r);
    expect(falla.motivo, 'ESPERA_REQUERIDA');
    expect(falla.segundosRestantes, 42);
    expect(falla.reintentable, isFalse);
  });

  test('un rechazo sin espera no trae segundosRestantes', () async {
    bff.cuenta = OnboardingFixtures.correoRegistrado;
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    final r = await repo.crearCuenta(correo: 'm@e.co', clave: 'clave-segura');

    expect(fallaDe(r).segundosRestantes, isNull);
  });

  test('consultar usa el token del recorrido y, sin él, la sesión', () async {
    await repo.consultar();
    await repo.iniciarConConsentimiento(versionTexto: 'v1');
    await repo.consultar();

    expect(bff.operaciones, [
      'miVerificacion',
      'iniciar',
      'consentimiento',
      'consultar',
    ]);
  });

  test('actualizar la sesión cambia el token y conserva el refresh', () async {
    await repo.iniciarConConsentimiento(versionTexto: 'v1');
    await repo.crearCuenta(correo: 'm@e.co', clave: 'clave-segura');

    final r = await repo.actualizarSesion();

    expect(r, isA<Exito<void>>());
    expect(sesion.token, 'jwt-demo-completo');
    expect(await guardada.leerRefresh(), 'refresh-demo-cuenta');
  });

  test('cerrar sesión revoca en el backend y borra lo guardado', () async {
    await repo.iniciarSesion(usuario: 'm@e.co', clave: 'clave');

    await repo.cerrarSesion();

    expect(remota.cerrados, ['refresh-demo-login']);
    expect(sesion.token, isNull);
    expect(await guardada.hayRefresh(), isFalse);
  });
}
