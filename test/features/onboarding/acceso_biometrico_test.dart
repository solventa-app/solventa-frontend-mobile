import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/biometria/biometria_providers.dart';
import 'package:solventa_mobile/core/biometria/llave_dispositivo.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

/// Acceso con huella o rostro tras cerrar sesión (KAN-26, contrato v0.44). La
/// llave real vive en el Keystore: aquí se prueba la lógica con un doble.
void main() {
  late FakeOnboardingRemoteDataSource bff;
  late FakeLlaveDispositivo llave;
  late MemoriaDispositivoStore almacen;

  ProviderContainer crear() {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    llave = FakeLlaveDispositivo();
    almacen = MemoriaDispositivoStore();
    final c = ProviderContainer(
      overrides: [
        fakeOnboardingProvider.overrideWithValue(bff),
        llaveDispositivoProvider.overrideWithValue(llave),
        dispositivoStoreProvider.overrideWithValue(almacen),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('activar registra la llave pública en AUTH y guarda el id', () async {
    final c = crear();
    final ok = await c
        .read(onboardingProvider.notifier)
        .activarAccesoBiometrico(motivo: 'm');
    expect(ok, isTrue);
    expect(bff.clavePublicaRegistrada, 'llave-publica-demo');
    expect(await almacen.leer(), 'dispositivo-demo');
  });

  test(
    'si no se puede crear la llave no se registra nada ni hay error',
    () async {
      final c = crear();
      llave.puedeCrear = false;
      final n = c.read(onboardingProvider.notifier);
      expect(await n.activarAccesoBiometrico(motivo: 'm'), isFalse);
      expect(bff.operaciones, isNot(contains('registrarDispositivo')));
      expect(await almacen.leer(), isNull);
      expect(c.read(onboardingProvider).falla, isNull);
    },
  );

  test('entrar con la llave pide un reto, lo firma y abre la sesión', () async {
    final c = crear();
    final n = c.read(onboardingProvider.notifier);
    await n.activarAccesoBiometrico(motivo: 'm');
    final ok = await n.iniciarSesionConHuella(motivo: 'm');
    expect(ok, isTrue);
    expect(llave.firmados, ['dispositivo-demo.nonce-demo']);
    expect(
      bff.operaciones,
      containsAllInOrder(['desafioDispositivo', 'iniciarSesionConDispositivo']),
    );
    expect(c.read(onboardingProvider).perfil, isNotNull);
  });

  test('sin dispositivo registrado no hace nada', () async {
    final c = crear();
    expect(
      await c
          .read(onboardingProvider.notifier)
          .iniciarSesionConHuella(motivo: 'm'),
      isFalse,
    );
    expect(bff.operaciones, isEmpty);
  });

  test('cancelar la huella no muestra error ni borra el dispositivo', () async {
    final c = crear();
    final n = c.read(onboardingProvider.notifier);
    await n.activarAccesoBiometrico(motivo: 'm');
    llave.resultadoFirma = const FirmaCancelada();
    expect(await n.iniciarSesionConHuella(motivo: 'm'), isFalse);
    expect(c.read(onboardingProvider).falla, isNull);
    expect(await almacen.leer(), isNotNull);
  });

  test(
    'una llave invalidada borra el dispositivo y pide correo y clave',
    () async {
      final c = crear();
      final n = c.read(onboardingProvider.notifier);
      await n.activarAccesoBiometrico(motivo: 'm');
      llave.resultadoFirma = const LlaveInvalida();
      expect(await n.iniciarSesionConHuella(motivo: 'm'), isFalse);
      expect(await almacen.leer(), isNull);
      expect(llave.existe, isFalse);
      expect(c.read(onboardingProvider).falla, isNotNull);
    },
  );

  test(
    'si AUTH no reconoce el dispositivo (clave cambiada) se olvida',
    () async {
      final c = crear();
      final n = c.read(onboardingProvider.notifier);
      await n.activarAccesoBiometrico(motivo: 'm');
      bff.rechazarDispositivo = true;
      expect(await n.iniciarSesionConHuella(motivo: 'm'), isFalse);
      expect(await almacen.leer(), isNull);
      expect(llave.existe, isFalse);
    },
  );

  testWidgets('el ingreso ofrece «Ingresar con huella» solo con dispositivo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    llave = FakeLlaveDispositivo();
    almacen = MemoriaDispositivoStore();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fakeOnboardingProvider.overrideWithValue(bff),
          llaveDispositivoProvider.overrideWithValue(llave),
          dispositivoStoreProvider.overrideWithValue(almacen),
        ],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ingresar con huella'), findsNothing);

    await almacen.guardar('dispositivo-demo');
    llave.existe = true;
    // El botón se vuelve a evaluar cuando cambia el estado del onboarding.
    final c = ProviderScope.containerOf(
      tester.element(find.byType(SolventaApp)),
    );
    c.invalidate(accesoBiometricoDisponibleProvider);
    await tester.pumpAndSettle();
    expect(find.text('Ingresar con huella'), findsOneWidget);
  });
}
