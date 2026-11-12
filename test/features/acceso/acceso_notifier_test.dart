import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/biometria/biometria_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_routes.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';

import 'acceso_test_utils.dart';

/// HU-M02 (F6, §3.6 del plan): cada resultado del teléfono y del backend
/// lleva a su estado de M02-01, M02-01a o M02-03.
void main() {
  const motivo = 'Desbloquea tu cuenta de Solventa';
  final vigente = DateTime.utc(2099);

  late FakeBiometriaService biometria;
  late StoreProgramable store;
  late FakeSesionRemota remota;
  late GestorSesion gestor;
  late OnboardingEspia onboarding;
  late DateTime ahora;

  setUp(() {
    biometria = FakeBiometriaService();
    store = StoreProgramable();
    remota = FakeSesionRemota();
    gestor = GestorSesion(store: store, remota: remota);
    ahora = DateTime.utc(2026, 11, 6, 9);
  });

  ProviderContainer crear() {
    final c = ProviderContainer(
      overrides: [
        biometriaServiceProvider.overrideWithValue(biometria),
        gestorSesionProvider.overrideWithValue(gestor),
        onboardingProvider.overrideWith(() => onboarding = OnboardingEspia()),
        relojAccesoProvider.overrideWithValue(() => ahora),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<ProviderContainer> arrancar() async {
    final c = crear();
    c
      ..read(accesoProvider)
      ..read(onboardingProvider);
    await pumpEventQueue();
    return c;
  }

  Future<ProviderContainer> bloqueada() async {
    await store.guardarRefresh('refresh-0', vigente);
    final c = await arrancar();
    expect(c.read(accesoProvider).fase, FaseAcceso.bloqueada);
    return c;
  }

  Future<void> desbloquear(ProviderContainer c, {bool conPin = false}) => c
      .read(accesoProvider.notifier)
      .desbloquear(motivo: motivo, conPin: conPin);

  group('arranque (F6)', () {
    test('sin sesión guardada: rutas normales (G-03)', () async {
      final c = await arrancar();
      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(onboarding.vencidas, 0);
    });

    test('con refresh vigente: bloqueada (M02-01), sin pedir huella', () async {
      await bloqueada();
      expect(biometria.autenticaciones, isEmpty);
    });

    test('con refresh vencido: login con aviso y se borra', () async {
      await store.guardarRefresh('refresh-0', DateTime.utc(2000));
      final c = await arrancar();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(onboarding.vencidas, 1);
      expect(await store.hayRefresh(), isFalse);
    });
  });

  group('desbloqueo', () {
    test('huella reconocida: M02-03 y la sesión queda abierta', () async {
      final c = await bloqueada();
      await desbloquear(c);

      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
      expect(biometria.autenticaciones, [false]);
      expect(gestor.abierta, isTrue);
      expect(onboarding.reanudadas, 1);
      // Rotación: quedó guardado el refresh nuevo.
      expect(await store.leerRefresh(), 'refresh-demo-1');
    });

    test('solo PIN en el teléfono (D1): el diálogo acepta el PIN', () async {
      biometria.estadoActual = EstadoBiometria.soloCredencial;
      final c = await bloqueada();
      await desbloquear(c);

      expect(biometria.autenticaciones, [true]);
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
    });

    test(
      '«Usar el bloqueo del teléfono» (D2) abre el diálogo con PIN',
      () async {
        final c = await bloqueada();
        await desbloquear(c, conPin: true);

        expect(biometria.autenticaciones, [true]);
        expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
      },
    );

    test('no reconocida: M02-01a, sin tocar la sesión', () async {
      biometria.resultados.add(const NoReconocido());
      final c = await bloqueada();
      await desbloquear(c);

      final s = c.read(accesoProvider);
      expect(s.fase, FaseAcceso.bloqueada);
      expect(s.noReconocida, isTrue);
      expect(s.autenticando, isFalse);
      expect(await store.hayRefresh(), isTrue);
    });

    test('M02-01a → Reintentar con éxito', () async {
      biometria.resultados.add(const NoReconocido());
      final c = await bloqueada();
      await desbloquear(c);
      await desbloquear(c);

      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
      expect(biometria.autenticaciones, [false, false]);
    });

    test('cancelar el diálogo: queda en M02-01 sin error', () async {
      biometria.resultados.add(const Cancelado());
      final c = await bloqueada();
      await desbloquear(c);

      final s = c.read(accesoProvider);
      expect(s.fase, FaseAcceso.bloqueada);
      expect(s.aviso, isNull);
      expect(s.noReconocida, isFalse);
    });

    test('bloqueo temporal: aviso', () async {
      biometria.resultados.add(const BloqueoTemporal());
      final c = await bloqueada();
      await desbloquear(c);

      expect(c.read(accesoProvider).aviso, AvisoAcceso.bloqueoTemporal);
    });

    test('bloqueo permanente: pasa directo al PIN del teléfono', () async {
      biometria.resultados.add(const BloqueoPermanente());
      final c = await bloqueada();
      await desbloquear(c);

      expect(biometria.autenticaciones, [false, true]);
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
    });

    test('bloqueo permanente aun con PIN: aviso', () async {
      biometria.resultados.add(const BloqueoPermanente());
      final c = await bloqueada();
      await desbloquear(c, conPin: true);

      expect(c.read(accesoProvider).aviso, AvisoAcceso.bloqueoPermanente);
    });

    test('sin biometría registrada: pide el PIN del teléfono (D1)', () async {
      biometria.resultados.add(const SinBiometriaRegistrada());
      final c = await bloqueada();
      await desbloquear(c);

      expect(biometria.autenticaciones, [false, true]);
      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
    });

    test('sin bloqueo de pantalla: aviso y no abre el diálogo', () async {
      biometria.estadoActual = EstadoBiometria.sinBloqueoPantalla;
      final c = await bloqueada();
      await desbloquear(c);

      expect(c.read(accesoProvider).aviso, AvisoAcceso.sinBloqueoPantalla);
      expect(biometria.autenticaciones, isEmpty);
    });

    test('sin hardware: aviso', () async {
      biometria.estadoActual = EstadoBiometria.noDisponible;
      final c = await bloqueada();
      await desbloquear(c);

      expect(c.read(accesoProvider).aviso, AvisoAcceso.noDisponible);
    });

    test('al volver de Ajustes se limpia el aviso de bloqueo', () async {
      biometria.estadoActual = EstadoBiometria.sinBloqueoPantalla;
      final c = await bloqueada();
      await desbloquear(c);
      c.read(accesoProvider.notifier).alVolverDeAjustes();

      expect(c.read(accesoProvider).aviso, isNull);
    });

    test(
      'rostro débil: la llave pide más y se usa el PIN del teléfono',
      () async {
        store.erroresAlLeer.add(const RequiereAutenticacion());
        final c = await bloqueada();
        await desbloquear(c);

        expect(biometria.autenticaciones, [false, true]);
        expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
      },
    );

    test(
      'rostro débil y PIN cancelado: aviso de falta autenticación',
      () async {
        store.erroresAlLeer.add(const RequiereAutenticacion());
        biometria.resultados.addAll([const Autenticado(), const Cancelado()]);
        final c = await bloqueada();
        await desbloquear(c);

        expect(c.read(accesoProvider).aviso, AvisoAcceso.faltaAutenticacion);
        expect(c.read(accesoProvider).fase, FaseAcceso.bloqueada);
      },
    );

    test('llave invalidada (huella nueva): login con su aviso', () async {
      store.erroresAlLeer.add(const LlaveInvalidada());
      final c = await bloqueada();
      await desbloquear(c);

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(onboarding.seguridadCambiada, 1);
      expect(onboarding.vencidas, 0);
      expect(await store.hayRefresh(), isFalse);
    });

    test('sin red: aviso, no se borra y Reintentar no pide huella', () async {
      remota.errorRed = const ErrorRed();
      final c = await bloqueada();
      await desbloquear(c);

      expect(c.read(accesoProvider).aviso, AvisoAcceso.sinRed);
      expect(await store.hayRefresh(), isTrue);

      remota.errorRed = null;
      await c.read(accesoProvider.notifier).reintentar(motivo: motivo);

      expect(c.read(accesoProvider).fase, FaseAcceso.concedida);
      expect(biometria.autenticaciones, [false]);
    });

    test('SESION_VENCIDA al renovar: login con aviso y todo borrado', () async {
      remota.rechazar = true;
      final c = await bloqueada();
      await desbloquear(c);

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(onboarding.vencidas, greaterThanOrEqualTo(1));
      expect(await store.hayRefresh(), isFalse);
    });

    test('«Usar correo y contraseña» borra la sesión guardada', () async {
      final c = await bloqueada();
      await c.read(accesoProvider.notifier).usarCorreo();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(onboarding.cierres, 1);
      expect(await store.hayRefresh(), isFalse);
    });

    test('dos toques seguidos abren un solo diálogo', () async {
      final c = await bloqueada();
      await Future.wait([desbloquear(c), desbloquear(c)]);

      expect(biometria.autenticaciones, [false]);
    });

    test('M02-03 termina y vuelve a las rutas normales', () async {
      final c = await bloqueada();
      await desbloquear(c);
      c.read(accesoProvider.notifier).terminarConcesion();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
    });
  });

  group('bloqueo tras 15 min en segundo plano', () {
    Future<ProviderContainer> conSesionAbierta() async {
      final c = await arrancar();
      await gestor.abrir(
        token: 'jwt-0',
        expiraEn: DateTime.utc(2099),
        refresh: 'refresh-0',
        refreshVenceEn: vigente,
      );
      return c;
    }

    test('a los 15 min bloquea y olvida el JWT', () async {
      final c = await conSesionAbierta();
      final notifier = c.read(accesoProvider.notifier)..alPasarASegundoPlano();
      ahora = ahora.add(AccesoNotifier.bloqueoTrasSegundoPlano);
      notifier.alVolverAPrimerPlano();

      expect(c.read(accesoProvider).fase, FaseAcceso.bloqueada);
      expect(gestor.token, isNull);
      expect(await store.hayRefresh(), isTrue);
    });

    test('antes de 15 min no bloquea', () async {
      final c = await conSesionAbierta();
      final notifier = c.read(accesoProvider.notifier)..alPasarASegundoPlano();
      ahora = ahora.add(const Duration(minutes: 14, seconds: 59));
      notifier.alVolverAPrimerPlano();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(gestor.abierta, isTrue);
    });

    test('sin refresh guardado (sin bloqueo de pantalla) no bloquea', () async {
      store.sinBloqueo = true;
      final c = await conSesionAbierta();
      final notifier = c.read(accesoProvider.notifier)..alPasarASegundoPlano();
      ahora = ahora.add(const Duration(minutes: 30));
      notifier.alVolverAPrimerPlano();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(gestor.abierta, isTrue);
    });

    test('sin sesión abierta no hace nada', () async {
      final c = await arrancar();
      final notifier = c.read(accesoProvider.notifier)..alPasarASegundoPlano();
      ahora = ahora.add(const Duration(minutes: 30));
      notifier.alVolverAPrimerPlano();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
    });
  });

  group('redirección del router', () {
    test('arrancando: solo /', () {
      expect(redirigirAcceso(FaseAcceso.comprobando, '/'), isNull);
      expect(redirigirAcceso(FaseAcceso.comprobando, '/perfil'), '/');
    });

    test('bloqueada: todo va a M02-01', () {
      expect(
        redirigirAcceso(FaseAcceso.bloqueada, '/'),
        AccesoRoutes.desbloqueo,
      );
      expect(
        redirigirAcceso(FaseAcceso.bloqueada, '/perfil'),
        AccesoRoutes.desbloqueo,
      );
      expect(
        redirigirAcceso(FaseAcceso.bloqueada, AccesoRoutes.desbloqueo),
        isNull,
      );
    });

    test('concedida: solo M02-03', () {
      expect(
        redirigirAcceso(FaseAcceso.concedida, AccesoRoutes.desbloqueo),
        AccesoRoutes.concedido,
      );
      expect(
        redirigirAcceso(FaseAcceso.concedida, AccesoRoutes.concedido),
        isNull,
      );
    });

    test('normal: las rutas de M02 vuelven a /', () {
      expect(redirigirAcceso(FaseAcceso.normal, AccesoRoutes.desbloqueo), '/');
      expect(redirigirAcceso(FaseAcceso.normal, AccesoRoutes.concedido), '/');
      expect(redirigirAcceso(FaseAcceso.normal, '/perfil'), isNull);
    });
  });
}
