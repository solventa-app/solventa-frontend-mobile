import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/subida_archivo_service.dart';
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

  test('el correo ya registrado es una FallaNegocio no reintentable', () async {
    bff.cuenta = OnboardingFixtures.correoRegistrado;
    await repo.iniciarConConsentimiento(versionTexto: 'v1');

    final r = await repo.crearCuenta(correo: 'm@e.co', clave: 'clave-segura');

    final falla = fallaDe(r);
    expect((falla.motivo, falla.reintentable), ('CORREO_YA_REGISTRADO', false));
    expect(sesion.token, isNull);
    expect(await guardada.hayRefresh(), isFalse);
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
