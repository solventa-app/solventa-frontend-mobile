import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/parametric/data/datasources/cobertura_remote_datasource.dart';
import 'package:solventa_mobile/features/parametric/data/fixtures/cobertura_fixtures.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_02_celebracion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_03_detalle_indemnizacion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_04_cobertura_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/providers.dart';

/// HU-M04: M04-02, M04-03 y M04-04 con datos mock y sin navegación (M04-D2:
/// se verifica que se llamen los callbacks).
void main() {
  late FakeCoberturaRemoteDataSource fake;

  String pesos(int monto) => SolFormat.currency(monto);
  const metodo = CoberturaFixtures.metodo;

  Future<void> montar(
    WidgetTester tester,
    Widget page, {
    EscenarioCobertura escenario = EscenarioCobertura.aFavor,
    bool fallar = false,
    bool sinMovimientos = false,
    double textScale = 1,
    double ancho = 390,
  }) async {
    tester.view.physicalSize = Size(ancho, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    fake = FakeCoberturaRemoteDataSource(
      escenario: escenario,
      latencia: Duration.zero,
      fallar: fallar,
      sinMovimientos: sinMovimientos,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [coberturaRemoteDataSourceProvider.overrideWithValue(fake)],
        child: MaterialApp(
          theme: SolTheme.light(),
          locale: AppLocales.es,
          supportedLocales: SolLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...SolLocalizations.delegates,
          ],
          builder: (context, app) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: app!,
          ),
          home: page,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('M04-04 · Mi cobertura', () {
    testWidgets('cupo, disponible, total y movimientos de los mockups', (
      tester,
    ) async {
      await montar(
        tester,
        const M0404CoberturaPage(),
        escenario: EscenarioCobertura.sinSaldo,
      );

      expect(find.text('Mi cobertura'), findsOneWidget);
      expect(find.text('Viaje paramétrico · Vigente'), findsOneWidget);
      expect(find.text(pesos(2000000)), findsOneWidget);
      expect(find.text('32 % del tope usado'), findsOneWidget);
      expect(find.text(pesos(1370000)), findsOneWidget);
      expect(find.text(pesos(950000)), findsOneWidget);
      expect(find.textContaining('desde jul 2026'), findsOneWidget);
      expect(find.text('3 pagos'), findsOneWidget);
      expect(find.textContaining('a tu favor'), findsNothing);
      expect(find.textContaining('pendiente'), findsNothing);
    });

    testWidgets('muestra el método de transferencia del último pago', (
      tester,
    ) async {
      await montar(tester, const M0404CoberturaPage());

      expect(find.textContaining(metodo), findsOneWidget);
    });

    testWidgets('saldo a favor: signo, texto e ícono además del color', (
      tester,
    ) async {
      await montar(tester, const M0404CoberturaPage());

      expect(find.text('+ ${pesos(38500)} a tu favor'), findsOneWidget);
      expect(find.textContaining('Ajuste de prima de octubre'), findsOne);
      expect(find.byIcon(SolIcons.success), findsWidgets);
    });

    testWidgets('saldo en contra: signo menos y texto', (tester) async {
      await montar(
        tester,
        const M0404CoberturaPage(),
        escenario: EscenarioCobertura.enContra,
      );

      expect(find.text('− ${pesos(38500)} pendiente'), findsOneWidget);
      expect(find.textContaining('Se suma a tu próximo cobro'), findsOne);
      expect(find.byIcon(SolIcons.error), findsOneWidget);
    });

    testWidgets('la barra anuncia el porcentaje usado', (tester) async {
      await montar(tester, const M0404CoberturaPage());

      expect(find.bySemanticsLabel('32 % del tope usado'), findsOneWidget);
    });

    testWidgets('tocar una fila llama onTapMovimiento con su id', (
      tester,
    ) async {
      final tocados = <String>[];
      await montar(tester, M0404CoberturaPage(onTapMovimiento: tocados.add));

      await tester.scrollUntilVisible(
        find.text('Retraso de vuelo AV204'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Retraso de vuelo AV204'));
      await tester.pump();

      expect(tocados, ['IND-2026-0912']);
    });

    testWidgets('error: Reintentar vuelve a consultar', (tester) async {
      await montar(tester, const M0404CoberturaPage(), fallar: true);

      expect(find.text('Reintentar'), findsOneWidget);
      fake.fallar = false;
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      expect(find.text(pesos(2000000)), findsOneWidget);
    });

    testWidgets('sin pagos: nota de vacío y sin total ni lista', (
      tester,
    ) async {
      await montar(tester, const M0404CoberturaPage(), sinMovimientos: true);

      expect(find.text('Aún no tienes pagos indemnizados.'), findsOneWidget);
      expect(find.text('Total indemnizado'), findsNothing);
      expect(find.text('Movimientos indemnizados'), findsNothing);
    });

    testWidgets('texto al 200 % en 360 dp sin desbordes', (tester) async {
      await montar(
        tester,
        const M0404CoberturaPage(),
        textScale: 2,
        ancho: 360,
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('M04-03 · Detalle de la indemnización', () {
    testWidgets('evento, monto, fechas y método de pago', (tester) async {
      await montar(
        tester,
        const M0403DetalleIndemnizacionPage(id: 'IND-2026-0912'),
      );

      expect(find.text('Detalle de la indemnización'), findsOneWidget);
      expect(
        find.text('Evento detectado: retraso de vuelo AV204 (+3h40)'),
        findsOneWidget,
      );
      expect(find.text(pesos(450000)), findsOneWidget);
      expect(find.text('12 sep 2026'), findsOneWidget);
      expect(
        find.text(SolFormat.dateTime(DateTime(2026, 9, 12, 11, 2))),
        findsOneWidget,
      );
      expect(find.text(metodo), findsOneWidget);
      expect(find.text('Pago procesado automáticamente'), findsOneWidget);
    });

    testWidgets('«Cerrar» llama onCerrar', (tester) async {
      var cerrado = 0;
      await montar(
        tester,
        M0403DetalleIndemnizacionPage(
          id: 'IND-2026-0912',
          onCerrar: () => cerrado++,
        ),
      );

      await tester.tap(find.text('Cerrar'));
      await tester.pump();

      expect(cerrado, 1);
    });

    testWidgets('texto al 200 % en 360 dp: las filas se apilan sin cortes', (
      tester,
    ) async {
      await montar(
        tester,
        const M0403DetalleIndemnizacionPage(id: 'IND-2026-0912'),
        textScale: 2,
        ancho: 360,
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('M04-02 · Celebración', () {
    testWidgets('monto depositado y método de pago', (tester) async {
      await montar(tester, const M0402CelebracionPage(id: 'IND-2026-0912'));

      expect(find.text('¡Tu indemnización ya está en camino!'), findsOne);
      expect(find.text('${pesos(450000)} depositados'), findsOneWidget);
      expect(find.text('Pagado por $metodo'), findsOneWidget);
    });

    testWidgets('el ícono de celebración no entra al foco', (tester) async {
      await montar(tester, const M0402CelebracionPage(id: 'IND-2026-0912'));

      final icono = find.byIcon(SolIcons.celebration);
      expect(icono, findsOneWidget);
      expect(
        find.ancestor(of: icono, matching: find.byType(ExcludeSemantics)),
        findsWidgets,
      );
    });

    testWidgets('«Ver detalle» llama onVerDetalle', (tester) async {
      var vistos = 0;
      await montar(
        tester,
        M0402CelebracionPage(id: 'IND-2026-0912', onVerDetalle: () => vistos++),
      );

      await tester.tap(find.text('Ver detalle'));
      await tester.pump();

      expect(vistos, 1);
    });

    testWidgets('la flecha llama onBack', (tester) async {
      var atras = 0;
      await montar(
        tester,
        M0402CelebracionPage(id: 'IND-2026-0912', onBack: () => atras++),
      );

      await tester.tap(find.byIcon(SolIcons.back));
      await tester.pump();

      expect(atras, 1);
    });
  });
}
