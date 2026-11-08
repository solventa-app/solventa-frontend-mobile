import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/parametric/data/datasources/cobertura_remote_datasource.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_02_celebracion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_03_detalle_indemnizacion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_04_cobertura_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/providers.dart';

import 'soporte/capturas.dart';

/// HU-M04 (KAN-260, KAN-280) en dispositivo: M04-02, M04-03 y M04-04 con datos
/// mock. Sin navegación ni push todavía (`docs/hu-m04/README.md`, M04-D2):
/// cada prueba monta la página directamente. Con `CAPTURAS=true` deja las
/// capturas en el reporte HTML de Emuladores.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const id = 'IND-2026-0912';

  Future<void> montar(
    WidgetTester tester,
    Widget pagina,
    EscenarioCobertura escenario,
  ) async {
    final contenedor = ProviderContainer(
      overrides: [
        coberturaRemoteDataSourceProvider.overrideWithValue(
          FakeCoberturaRemoteDataSource(
            escenario: escenario,
            latencia: Duration.zero,
          ),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: contenedor,
        child: MaterialApp(
          theme: SolTheme.light(),
          locale: AppLocales.es,
          supportedLocales: SolLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...SolLocalizations.delegates,
          ],
          home: pagina,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  const casos = {
    EscenarioCobertura.sinSaldo: 'M04-04 · lista de movimientos',
    EscenarioCobertura.aFavor: 'M04-04 · saldo a favor',
    EscenarioCobertura.enContra: 'M04-04 · saldo en contra',
  };
  for (final MapEntry(key: escenario, value: nombre) in casos.entries) {
    testWidgets(nombre, (tester) async {
      final tocados = <String>[];
      await montar(
        tester,
        M0404CoberturaPage(onBack: () {}, onTapMovimiento: tocados.add),
        escenario,
      );
      expect(find.text('Mi cobertura'), findsOneWidget);
      await capturar(tester, nombre);

      final ultima = find.text('Cancelación de vuelo LA4012');
      await tester.scrollUntilVisible(
        ultima,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await capturar(tester, '$nombre (final de la lista)');

      await tester.tap(ultima);
      await tester.pump();
      expect(tocados, ['IND-2026-0703']);
    });
  }

  testWidgets('M04-02 · celebración', (tester) async {
    var detalle = 0;
    await montar(
      tester,
      M0402CelebracionPage(
        id: id,
        onBack: () {},
        onVerDetalle: () => detalle++,
      ),
      EscenarioCobertura.sinSaldo,
    );
    expect(find.textContaining('depositados'), findsOneWidget);
    await capturar(tester, 'M04-02 · celebración');

    await tester.tap(find.text('Ver detalle'));
    await tester.pump();
    expect(detalle, 1);
  });

  testWidgets('M04-03 · detalle de la indemnización', (tester) async {
    var cerrado = 0;
    await montar(
      tester,
      M0403DetalleIndemnizacionPage(
        id: id,
        onBack: () {},
        onCerrar: () => cerrado++,
      ),
      EscenarioCobertura.sinSaldo,
    );
    expect(find.text('Detalle de la indemnización'), findsOneWidget);
    await capturar(tester, 'M04-03 · detalle');

    await tester.tap(find.text('Cerrar'));
    await tester.pump();
    expect(cerrado, 1);
  });
}
