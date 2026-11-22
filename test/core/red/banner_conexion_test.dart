import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/presentation/banner_conexion.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';

void main() {
  late ConectividadFalsa conectividad;
  late SondaFalsa sonda;

  setUp(() {
    conectividad = ConectividadFalsa();
    sonda = SondaFalsa();
    addTearDown(conectividad.cerrar);
  });

  Future<void> montar(
    WidgetTester tester, {
    Locale locale = AppLocales.es,
    double textScale = 1,
    Size size = const Size(390, 844),
    double teclado = 0,
    Widget? cuerpo,
    bool usarFakes = true,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          usarFakesProvider.overrideWithValue(usarFakes),
          conectividadProvider.overrideWithValue(conectividad),
          sondaRedProvider.overrideWithValue(sonda),
        ],
        child: MaterialApp(
          theme: SolTheme.light(),
          locale: locale,
          supportedLocales: AppLocales.supported,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, app) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
              viewInsets: EdgeInsets.only(bottom: teclado),
            ),
            child: app!,
          ),
          home: SolFlowScaffold(
            title: 'Reportar siniestro',
            onBack: () {},
            banner: const BannerConexion(),
            body: cuerpo ?? const Text('Contenido'),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  EstadoRedNotifier notifier(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(BannerConexion)))
          .read(estadoRedProvider.notifier);

  testWidgets('con buena conexión no ocupa espacio', (tester) async {
    await montar(tester);

    expect(find.byType(SolConnectionBanner), findsNothing);
    expect(tester.getSize(find.byType(BannerConexion)).height, 0);
  });

  testWidgets('sin conexión lo dice con ícono y texto', (tester) async {
    await montar(tester);

    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();

    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.text('Revisa tu Wi-Fi o tus datos móviles.'), findsOneWidget);
    expect(find.byIcon(SolIcons.offline), findsOneWidget);
    // Empuja el contenido: no lo tapa.
    expect(
      tester.getTopLeft(find.text('Contenido')).dy,
      greaterThan(tester.getBottomLeft(find.byType(SolConnectionBanner)).dy),
    );
  });

  testWidgets('al volver avisa «Conexión restablecida» y se oculta sola', (
    tester,
  ) async {
    await montar(tester);
    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();

    conectividad.cambiar(TipoRed.wifi);
    await tester.pumpAndSettle();
    expect(find.text('Conexión restablecida'), findsOneWidget);
    expect(find.text('Sin conexión'), findsNothing);

    await tester.pump(BannerConexion.duracionRestablecida);
    await tester.pumpAndSettle();
    expect(find.byType(SolConnectionBanner), findsNothing);
  });

  testWidgets(
    'si se cae otra vez antes de ocultarse, vuelve a «Sin conexión»',
    (tester) async {
      await montar(tester);
      conectividad.cambiar(TipoRed.ninguna);
      await tester.pumpAndSettle();
      conectividad.cambiar(TipoRed.wifi);
      await tester.pumpAndSettle();

      conectividad.cambiar(TipoRed.ninguna);
      await tester.pumpAndSettle();
      await tester.pump(BannerConexion.duracionRestablecida);

      expect(find.text('Sin conexión'), findsOneWidget);
      expect(find.text('Conexión restablecida'), findsNothing);
    },
  );

  testWidgets('conexión lenta dice por dónde: datos o Wi-Fi', (tester) async {
    await montar(tester);
    sonda.resultado = const SondaConRespuesta(Duration(seconds: 3));

    conectividad.cambiar(TipoRed.movil);
    await tester.pumpAndSettle();
    expect(find.text('Conexión lenta'), findsOneWidget);
    expect(
      find.text('Estás con datos móviles y poca señal. El envío puede tardar.'),
      findsOneWidget,
    );

    conectividad.cambiar(TipoRed.wifi);
    await tester.pumpAndSettle();
    expect(
      find.text('Tu Wi-Fi responde lento. El envío puede tardar.'),
      findsOneWidget,
    );
  });

  testWidgets('en inglés', (tester) async {
    await montar(tester, locale: AppLocales.en);

    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();

    expect(find.text('No connection'), findsOneWidget);
    expect(find.text('Check your Wi-Fi or mobile data.'), findsOneWidget);
  });

  testWidgets('a 360 dp con el texto al 200 % crece sin desbordarse', (
    tester,
  ) async {
    await montar(tester, size: const Size(360, 640), textScale: 2);
    sonda.resultado = const SondaConRespuesta(Duration(seconds: 3));

    conectividad.cambiar(TipoRed.movil);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(SolConnectionBanner)).height,
      greaterThan(80),
    );
  });

  testWidgets('en una tablet el texto no pasa de 600 dp', (tester) async {
    await montar(tester, size: const Size(1280, 800));

    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();

    final franja = tester.getSize(find.byType(SolConnectionBanner));
    final titulo = tester.getTopLeft(find.text('Sin conexión'));
    expect(franja.width, 1280);
    expect(titulo.dx, greaterThan(340));
  });

  testWidgets('con el teclado abierto queda en una línea', (tester) async {
    await montar(tester, teclado: 300);

    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();

    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.text('Revisa tu Wi-Fi o tus datos móviles.'), findsNothing);
    expect(
      tester.getSize(find.byType(SolConnectionBanner)).height,
      lessThan(32),
    );
  });

  testWidgets('se anuncia a TalkBack al aparecer', (tester) async {
    final semantica = tester.ensureSemantics();
    await montar(tester);

    conectividad.cambiar(TipoRed.ninguna);
    await tester.pumpAndSettle();

    final nodo = tester.getSemantics(find.byType(SolConnectionBanner));
    expect(nodo.flagsCollection.isLiveRegion, isTrue);
    semantica.dispose();
  });

  testWidgets('mientras está montada vigila la red; al salir, deja de probar', (
    tester,
  ) async {
    await montar(tester);
    final antes = sonda.pruebas;

    await tester.pump(UmbralesRed.periodo);
    expect(sonda.pruebas, antes + 1);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(UmbralesRed.periodo * 3);
    expect(sonda.pruebas, antes + 1);
  });

  group('ChipRed', () {
    Future<void> montarChip(WidgetTester tester) =>
        montar(tester, cuerpo: const ChipRed());

    testWidgets('dice la interfaz y la calidad', (tester) async {
      await montarChip(tester);
      expect(find.text('Wi-Fi · buena'), findsOneWidget);

      sonda.resultado = const SondaConRespuesta(Duration(seconds: 1));
      conectividad.cambiar(TipoRed.movil);
      await tester.pumpAndSettle();
      expect(find.text('Datos · regular'), findsOneWidget);

      sonda.resultado = const SondaConRespuesta(Duration(seconds: 3));
      conectividad.cambiar(TipoRed.otra);
      await tester.pumpAndSettle();
      expect(find.text('Conexión · mala'), findsOneWidget);

      conectividad.cambiar(TipoRed.ninguna);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(SolNetworkChip),
          matching: find.text('Sin conexión'),
        ),
        findsOneWidget,
      );
    });
  });

  group('DemoRed', () {
    testWidgets('en la demo simula sin conexión, lenta y vuelve a la real', (
      tester,
    ) async {
      await montar(tester, cuerpo: const DemoRed());

      await tester.tap(find.text('Simular sin conexión →'));
      await tester.pumpAndSettle();
      expect(find.text('Sin conexión'), findsOneWidget);
      expect(notifier(tester).state.simulado, isTrue);

      await tester.tap(find.text('Volver a la conexión real →'));
      await tester.pumpAndSettle();
      expect(find.text('Conexión restablecida'), findsOneWidget);

      // El aviso de que volvió tiene prioridad sus 4 segundos.
      await tester.pump(BannerConexion.duracionRestablecida);
      await tester.tap(find.text('Simular conexión lenta →'));
      await tester.pumpAndSettle();
      expect(find.text('Conexión lenta'), findsOneWidget);
    });

    testWidgets('contra un backend real no existe', (tester) async {
      await montar(tester, cuerpo: const DemoRed(), usarFakes: false);

      expect(find.byType(SolDemoTrigger), findsNothing);
    });
  });
}
