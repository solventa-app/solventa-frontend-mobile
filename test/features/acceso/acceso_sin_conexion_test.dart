import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';

import 'acceso_test_utils.dart';

/// HU-M05, sin conexión (plan 4.5): la huella abre la sesión guardada y, si
/// lo único que falla es la red, se entra con la cuenta que ya está en el
/// teléfono. La sesión se renueva sola cuando la red vuelve.
void main() {
  const motivo = 'Desbloquea tu cuenta de Solventa';

  late FakeBiometriaService biometria;
  late StoreProgramable store;
  late FakeSesionRemota remota;
  late GestorSesion gestor;
  late OnboardingEspia onboarding;
  late AlmacenLocalMemoria local;
  late ConectividadFalsa conectividad;
  late DateTime ahora;

  CuentaLocal cuenta({bool verificada = true}) => CuentaLocal(
    id: 'c1',
    nombre: 'Laura',
    verificada: verificada,
    ultimaConexion: DateTime.utc(2026, 11, 20, 8),
  );

  setUp(() {
    ahora = DateTime.utc(2026, 11, 22, 9);
    biometria = FakeBiometriaService();
    store = StoreProgramable();
    remota = FakeSesionRemota(errorRed: const ErrorRed());
    gestor = GestorSesion(store: store, remota: remota, reloj: () => ahora);
    local = AlmacenLocalMemoria();
    conectividad = ConectividadFalsa(TipoRed.ninguna);
  });

  Future<void> asentar() async {
    for (var i = 0; i < 12; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  /// La app arranca sin red, con la sesión guardada: queda en M02-01.
  Future<ProviderContainer> bloqueada({
    CuentaLocal? guardada,
    DateTime? refreshVence,
  }) async {
    if (guardada != null) await local.guardarCuenta(guardada);
    await store.guardarRefresh(
      'refresh-0',
      refreshVence ?? ahora.add(const Duration(days: 6)),
    );
    final c = ProviderContainer(
      overrides: [
        biometriaServiceProvider.overrideWithValue(biometria),
        gestorSesionProvider.overrideWithValue(gestor),
        onboardingProvider.overrideWith(() => onboarding = OnboardingEspia()),
        relojAccesoProvider.overrideWithValue(() => ahora),
        almacenLocalProvider.overrideWithValue(local),
        conectividadProvider.overrideWithValue(conectividad),
        sondaRedProvider.overrideWithValue(SondaFalsa()),
      ],
    );
    addTearDown(c.dispose);
    c
      ..listen(estadoRedProvider, (_, _) {})
      ..listen(accesoProvider, (_, _) {})
      ..read(onboardingProvider);
    await asentar();
    expect(c.read(estadoRedProvider).conectado, isFalse);
    expect(c.read(accesoProvider).fase, FaseAcceso.bloqueada);
    return c;
  }

  Future<ProviderContainer> sinConexion() async {
    final c = await bloqueada(guardada: cuenta());
    await c.read(accesoProvider.notifier).desbloquear(motivo: motivo);
    expect(c.read(accesoProvider).fase, FaseAcceso.sinConexion);
    return c;
  }

  group('entrada con la huella y sin red', () {
    test('con la cuenta verificada guardada entra sin conexión', () async {
      final c = await sinConexion();

      final estado = c.read(accesoProvider);
      expect(estado.cuentaLocal?.nombre, 'Laura');
      expect(estado.aviso, isNull);
      expect(c.read(cuentaActualProvider), 'c1');
      // No hay JWT: la sesión queda por renovar, con el refresh intacto.
      expect(gestor.abierta, isFalse);
      expect(gestor.porRenovar, isTrue);
      expect(await store.hayRefresh(), isTrue);
      expect(onboarding.reanudadas, 0);
      expect(biometria.autenticaciones, [true]);
    });

    test('sin cuenta guardada en el teléfono queda el aviso sin red', () async {
      final c = await bloqueada();
      await c.read(accesoProvider.notifier).desbloquear(motivo: motivo);

      final estado = c.read(accesoProvider);
      expect(estado.fase, FaseAcceso.bloqueada);
      expect(estado.aviso, AvisoAcceso.sinRed);
      expect(c.read(cuentaActualProvider), isNull);
    });

    test('con la cuenta sin verificar no entra: aviso sin red', () async {
      final c = await bloqueada(guardada: cuenta(verificada: false));
      await c.read(accesoProvider.notifier).desbloquear(motivo: motivo);

      final estado = c.read(accesoProvider);
      expect(estado.fase, FaseAcceso.bloqueada);
      expect(estado.aviso, AvisoAcceso.sinRed);
      expect(c.read(cuentaActualProvider), isNull);
    });

    test(
      'si la sesión guardada venció mientras tanto, va a «Inicia sesión»',
      () async {
        final c = await bloqueada(
          guardada: cuenta(),
          refreshVence: ahora.add(const Duration(minutes: 5)),
        );
        ahora = ahora.add(const Duration(minutes: 6));
        await c.read(accesoProvider.notifier).desbloquear(motivo: motivo);

        expect(c.read(accesoProvider).fase, FaseAcceso.normal);
        expect(onboarding.vencidas, 1);
        expect(c.read(cuentaActualProvider), isNull);
        expect(await store.hayRefresh(), isFalse);
      },
    );
  });

  group('la sesión se renueva sola', () {
    test('al volver la red abre la sesión sin pedir la huella', () async {
      final c = await sinConexion();

      remota.errorRed = null;
      conectividad.cambiar(TipoRed.wifi);
      await asentar();
      await asentar();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(gestor.abierta, isTrue);
      expect(gestor.porRenovar, isFalse);
      expect(onboarding.reanudadas, 1);
      // La cuenta del teléfono sigue siendo la misma: nada se pierde.
      expect(c.read(cuentaActualProvider), 'c1');
      expect(biometria.autenticaciones, [true]);
    });

    test('si la renovación sigue sin red, se queda sin conexión', () async {
      final c = await sinConexion();

      await c.read(accesoProvider.notifier).renovarSiHayRed();

      expect(c.read(accesoProvider).fase, FaseAcceso.sinConexion);
      expect(c.read(accesoProvider).cuentaLocal?.id, 'c1');
      expect(gestor.porRenovar, isTrue);
    });

    test('si el servidor ya no acepta la sesión, va a «Inicia sesión» y '
        'los reportes guardados quedan en el teléfono', () async {
      final c = await sinConexion();

      remota
        ..errorRed = null
        ..rechazar = true;
      await c.read(accesoProvider.notifier).renovarSiHayRed();
      await asentar();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(onboarding.vencidas, greaterThanOrEqualTo(1));
      expect(c.read(cuentaActualProvider), isNull);
      expect(gestor.porRenovar, isFalse);
      // La cuenta local no se borra: al iniciar sesión siguen sus reportes.
      expect((await local.cuentaActiva())?.id, 'c1');
    });

    test('fuera del modo sin conexión no hace nada', () async {
      final c = await bloqueada(guardada: cuenta());
      remota.errorRed = null;

      await c.read(accesoProvider.notifier).renovarSiHayRed();

      expect(c.read(accesoProvider).fase, FaseAcceso.bloqueada);
      expect(remota.renovaciones, 0);
    });
  });

  group('segundo plano en modo sin conexión', () {
    test('a los 15 min bloquea y la huella vuelve a entrar sin red', () async {
      final c = await sinConexion();
      final notifier = c.read(accesoProvider.notifier)..alPasarASegundoPlano();
      ahora = ahora.add(AccesoNotifier.bloqueoTrasSegundoPlano);
      notifier.alVolverAPrimerPlano();

      expect(c.read(accesoProvider).fase, FaseAcceso.bloqueada);
      expect(gestor.porRenovar, isFalse);

      await notifier.desbloquear(motivo: motivo);

      expect(c.read(accesoProvider).fase, FaseAcceso.sinConexion);
      expect(biometria.autenticaciones, [true, true]);
    });

    test('antes de 15 min no bloquea y aprovecha para renovar', () async {
      final c = await sinConexion();
      final notifier = c.read(accesoProvider.notifier)..alPasarASegundoPlano();
      ahora = ahora.add(const Duration(minutes: 3));
      remota.errorRed = null;
      notifier.alVolverAPrimerPlano();
      await asentar();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(gestor.abierta, isTrue);
      expect(biometria.autenticaciones, [true]);
    });
  });

  test(
    'cerrar sesión sin conexión deja las rutas normales y sin cuenta',
    () async {
      final c = await sinConexion();

      c.read(accesoProvider.notifier).alCerrarSesion();

      expect(c.read(accesoProvider).fase, FaseAcceso.normal);
      expect(c.read(accesoProvider).cuentaLocal, isNull);
      expect(c.read(cuentaActualProvider), isNull);
    },
  );
}
