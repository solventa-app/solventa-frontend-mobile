import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

/// HU-M02 en dispositivo (plan §5.5), con `API_ENV=mock`: biometría y
/// backend falsos, y un almacén que sobrevive a «cerrar la app» (cambiar el
/// `ProviderScope`), como el Keystore. Sin M02-02 (decisión D2): el PIN es
/// el del teléfono y lo pide el diálogo del sistema.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MemoriaSesionStore store;
  late FakeBiometriaService biometria;
  late FakeSesionRemota remota;
  late DateTime ahora;

  setUp(() {
    store = MemoriaSesionStore();
    biometria = FakeBiometriaService();
    remota = FakeSesionRemota();
    ahora = DateTime.now();
  });

  /// Abre la app desde cero (un `ProviderScope` nuevo es un arranque en frío;
  /// lo único que sobrevive es [store]).
  Future<void> abrirApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          sesionStoreProvider.overrideWithValue(store),
          biometriaServiceProvider.overrideWithValue(biometria),
          sesionRemotaProvider.overrideWithValue(remota),
          fakeOnboardingProvider.overrideWithValue(
            FakeOnboardingRemoteDataSource(latencia: Duration.zero),
          ),
          relojAccesoProvider.overrideWithValue(() => ahora),
          duracionAccesoConcedidoProvider.overrideWithValue(
            const Duration(milliseconds: 300),
          ),
        ],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> guardarSesionAnterior() => store.guardarRefresh(
    'refresh-guardado',
    DateTime.now().add(const Duration(days: 8)),
  );

  Future<void> iniciarSesion(WidgetTester tester) async {
    // La entrada ya abre en «Inicia sesión» (QA 2026-11-10).
    expect(find.text('¿No tienes cuenta? Crear cuenta'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'maria@ejemplo.co');
    await tester.enterText(find.byType(TextField).at(1), 'Clave-segura-1');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
  }

  /// M02-03 se muestra unos milisegundos y luego va al Home con un `Timer`.
  /// En el dispositivo ese tiempo es real y `pumpAndSettle` puede terminar
  /// antes (M02-03 no anima), así que se bombea hasta ver el Home.
  Future<void> esperarHome(WidgetTester tester) async {
    for (var i = 0; i < 50; i++) {
      if (find.byType(SolAppShell).evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  testWidgets('login → cerrar la app → M02-01 con huella → M02-03 → Home', (
    tester,
  ) async {
    await abrirApp(tester);
    await iniciarSesion(tester);
    expect(find.byType(SolAppShell), findsOneWidget);
    expect(await store.hayRefresh(), isTrue);

    await abrirApp(tester);

    // El diálogo se abrió solo al entrar a M02-01 y reconoció la huella.
    expect(biometria.autenticaciones, [true]);
    await esperarHome(tester);
    expect(find.byType(SolAppShell), findsOneWidget);
    expect(remota.renovaciones, 1);
  });

  testWidgets('M02-01 → no reconoce → M02-01a → Reintentar → Home', (
    tester,
  ) async {
    await guardarSesionAnterior();
    biometria.resultados.add(const NoReconocido());
    await abrirApp(tester);

    expect(find.text('No te reconocimos'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    await esperarHome(tester);
    expect(find.byType(SolAppShell), findsOneWidget);
  });

  testWidgets('M02-01a → Usar el bloqueo del teléfono → Home (D2)', (
    tester,
  ) async {
    await guardarSesionAnterior();
    biometria.resultados.add(const NoReconocido());
    await abrirApp(tester);

    await tester.tap(find.text('Usar el bloqueo del teléfono'));
    await tester.pumpAndSettle();

    expect(biometria.autenticaciones, [true, true]);
    await esperarHome(tester);
    expect(find.byType(SolAppShell), findsOneWidget);
  });

  testWidgets('refresh vencido o revocado → «Inicia sesión» con aviso', (
    tester,
  ) async {
    await guardarSesionAnterior();
    remota.rechazar = true;
    await abrirApp(tester);

    expect(find.text('Tu sesión venció. Inicia sesión nuevamente.'), findsOne);
    expect(await store.hayRefresh(), isFalse);
  });

  testWidgets('cerrar sesión (G-04) → reabrir → no aparece M02-01', (
    tester,
  ) async {
    await abrirApp(tester);
    await iniciarSesion(tester);

    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí, cerrar sesión'));
    await tester.pumpAndSettle();
    expect(await store.hayRefresh(), isFalse);

    await abrirApp(tester);
    expect(find.text('Desbloquea tu cuenta'), findsNothing);
    expect(biometria.autenticaciones, isEmpty);
  });

  testWidgets('15 min en segundo plano → M02-01 → huella → Home', (
    tester,
  ) async {
    await abrirApp(tester);
    await iniciarSesion(tester);

    // Transiciones válidas de AppLifecycleListener: en el dispositivo
    // `hidden → resumed` directo dispara una aserción.
    void cambiarCiclo(List<AppLifecycleState> estados) {
      for (final estado in estados) {
        tester.binding.handleAppLifecycleStateChanged(estado);
      }
    }

    cambiarCiclo([AppLifecycleState.inactive, AppLifecycleState.hidden]);
    ahora = ahora.add(const Duration(minutes: 15));
    cambiarCiclo([AppLifecycleState.inactive, AppLifecycleState.resumed]);
    await tester.pumpAndSettle();

    // M02-01 abrió el diálogo y, con la huella, volvió al Home.
    expect(biometria.autenticaciones, [true]);
    await esperarHome(tester);
    expect(find.byType(SolAppShell), findsOneWidget);
  });
}
