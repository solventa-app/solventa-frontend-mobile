import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:solventa_mobile/core/biometria/biometria_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_08_biometria_page.dart';

/// Almacén que cifra con el llavero en memoria (para el caso sin bloqueo).
final class _Store implements SesionStore {
  _Store(this.llavero);
  final LlaveroSesionMemoria llavero;
  String? _c;

  @override
  Future<bool> hayRefresh() async => _c != null;
  @override
  Future<DateTime?> refreshVenceEn() async => null;
  @override
  Future<void> guardarRefresh(String r, DateTime? v) async {
    if (!await llavero.existe()) await llavero.crear();
    _c = await llavero.cifrar(r);
  }

  @override
  Future<String> leerRefresh() async => llavero.descifrar(_c!);
  @override
  Future<void> borrar() async => _c = null;
}

/// HU-M02 (F9): M01-08 con el servicio de biometría compartido.
void main() {
  late FakeBiometriaService biometria;
  late GestorSesion gestor;

  Future<void> montar(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/biometria',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('HOME')),
        ),
        GoRoute(
          path: '/biometria',
          builder: (_, _) => const M0108BiometriaPage(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          biometriaServiceProvider.overrideWithValue(biometria),
          gestorSesionProvider.overrideWithValue(gestor),
        ],
        child: MaterialApp.router(
          theme: SolTheme.light(),
          locale: SolLocalizations.locale,
          supportedLocales: SolLocalizations.supportedLocales,
          localizationsDelegates: SolLocalizations.delegates,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    biometria = FakeBiometriaService();
    gestor = GestorSesion(
      store: MemoriaSesionStore(),
      remota: FakeSesionRemota(),
    );
  });

  testWidgets('con huella: autentica y va al inicio', (tester) async {
    await montar(tester);

    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(biometria.autenticaciones, [true]);
  });

  testWidgets('solo PIN (D1): avisa y deja continuar', (tester) async {
    biometria.estadoActual = EstadoBiometria.soloCredencial;
    await montar(tester);

    expect(find.textContaining('Puedes continuar con el PIN'), findsOneWidget);
    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('sin bloqueo de pantalla: no abre el diálogo ni sigue', (
    tester,
  ) async {
    biometria.estadoActual = EstadoBiometria.sinBloqueoPantalla;
    await montar(tester);

    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('no tiene bloqueo de pantalla'), findsOneWidget);
    expect(biometria.autenticaciones, isEmpty);
    expect(find.text('HOME'), findsNothing);
  });

  testWidgets('no reconocido: avisa y se queda', (tester) async {
    biometria.resultados.add(const NoReconocido());
    await montar(tester);

    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();

    expect(find.text('No te reconocimos. Intenta de nuevo.'), findsOneWidget);
    expect(find.text('HOME'), findsNothing);
  });

  testWidgets('cancelar el diálogo no muestra error', (tester) async {
    biometria.resultados.add(const Cancelado());
    await montar(tester);

    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();

    expect(find.byType(SolStatusBanner), findsNothing);
    expect(find.text('HOME'), findsNothing);
  });

  testWidgets('«Ir a configuración» abre los ajustes de seguridad', (
    tester,
  ) async {
    await montar(tester);

    await tester.tap(find.text('Ir a configuración del teléfono'));
    await tester.pump();

    expect(biometria.aperturasAjustes, 1);
  });

  testWidgets('al volver de Ajustes vuelve a consultar el teléfono', (
    tester,
  ) async {
    biometria.estadoActual = EstadoBiometria.sinBloqueoPantalla;
    await montar(tester);
    expect(find.textContaining('no tiene bloqueo de pantalla'), findsOneWidget);

    biometria.estadoActual = EstadoBiometria.biometriaRegistrada;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(find.textContaining('no tiene bloqueo de pantalla'), findsNothing);
  });

  testWidgets('tras autenticar guarda el refresh que estaba solo en memoria', (
    tester,
  ) async {
    final llavero = LlaveroSesionMemoria(conBloqueoPantalla: false);
    final store = _Store(llavero);
    gestor = GestorSesion(store: store, remota: FakeSesionRemota());
    await gestor.abrir(
      token: 'jwt',
      expiraEn: DateTime.utc(2026, 11, 6),
      refresh: 'refresh',
    );
    expect(gestor.refreshPersistido, isFalse);
    llavero.conBloqueoPantalla = true; // la persona activó el bloqueo
    await montar(tester);

    await tester.tap(find.text('Ya lo activé, continuar'));
    await tester.pumpAndSettle();

    expect(gestor.refreshPersistido, isTrue);
    expect(await store.hayRefresh(), isTrue);
  });
}
