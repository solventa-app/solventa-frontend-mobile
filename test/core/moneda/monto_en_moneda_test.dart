import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/moneda/conversor_montos.dart';
import 'package:solventa_mobile/core/moneda/monto_en_moneda.dart';

String plain(String s) => s.replaceAll(SolFormat.nbsp, ' ');

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    locale: ref.watch(localeProvider),
    supportedLocales: AppLocales.supported,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...SolLocalizations.delegates,
    ],
    home: Scaffold(
      body: Consumer(
        builder: (context, ref, _) => Column(
          children: [
            Text(plain(ref.monto(context, 450000)), key: const Key('monto')),
            const NotaMontosDeReferencia(),
          ],
        ),
      ),
    ),
  );
}

String _monto(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('monto'))).data!;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'al cambiar moneda o idioma el monto y la nota cambian al instante',
    (tester) async {
      final contenedor = ProviderContainer(
        overrides: [
          conversorMontosProvider.overrideWithValue(FakeConversorMontos()),
        ],
      );
      addTearDown(contenedor.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(container: contenedor, child: const _App()),
      );
      await tester.pumpAndSettle();
      expect(_monto(tester), r'$ 450.000');
      expect(find.byType(SolInlineNote), findsNothing);

      contenedor.read(monedaProvider.notifier).cambiar('USD');
      await tester.pumpAndSettle();
      expect(_monto(tester), 'USD 109,76');
      expect(
        find.textContaining('Valores de referencia en USD'),
        findsOneWidget,
      );

      contenedor.read(localeProvider.notifier).cambiar(AppLocales.en);
      await tester.pumpAndSettle();
      expect(_monto(tester), 'USD 109.76');
      expect(find.textContaining('Reference values in USD'), findsOneWidget);

      contenedor.read(monedaProvider.notifier).cambiar('COP');
      await tester.pumpAndSettle();
      expect(_monto(tester), 'COP 450,000');
      expect(find.byType(SolInlineNote), findsNothing);
    },
  );

  testWidgets('si la conversión falla se ve el monto en COP', (tester) async {
    final contenedor = ProviderContainer(
      overrides: [
        conversorMontosProvider.overrideWithValue(
          FakeConversorMontos(fallar: true),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: contenedor, child: const _App()),
    );
    contenedor.read(monedaProvider.notifier).cambiar('EUR');
    await tester.pumpAndSettle();
    expect(_monto(tester), r'$ 450.000');
  });
}
