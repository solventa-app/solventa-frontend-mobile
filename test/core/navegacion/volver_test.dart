import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/navegacion/volver.dart';

void main() {
  Future<void> montar(WidgetTester tester, Widget hijo) => tester.pumpWidget(
    MaterialApp(
      theme: SolTheme.light(),
      locale: AppLocales.es,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocales.supported,
      home: hijo,
    ),
  );

  group('salirAlInicioConfirmando', () {
    Widget formulario(VoidCallback? ir) => Builder(
      builder: (context) => SolFlowScaffold(
        title: 'Formulario',
        onBack: () {},
        onHomeTap: salirAlInicioConfirmando(context, ir),
        body: const SizedBox.shrink(),
      ),
    );

    testWidgets('pregunta antes de salir y sale al confirmar', (tester) async {
      var salidas = 0;
      await montar(tester, formulario(() => salidas++));

      await tester.tap(find.byIcon(SolIcons.home));
      await tester.pumpAndSettle();
      expect(find.text('¿Salir al inicio?'), findsOneWidget);
      expect(salidas, 0);

      await tester.tap(find.text('Sí, salir'));
      await tester.pumpAndSettle();
      expect(salidas, 1);
    });

    testWidgets('«No, seguir aquí» deja al usuario en el formulario', (
      tester,
    ) async {
      var salidas = 0;
      await montar(tester, formulario(() => salidas++));

      await tester.tap(find.byIcon(SolIcons.home));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No, seguir aquí'));
      await tester.pumpAndSettle();

      expect(salidas, 0);
      expect(find.text('Formulario'), findsOneWidget);
    });

    testWidgets('sin destino no hay casita', (tester) async {
      await montar(tester, formulario(null));
      expect(find.byIcon(SolIcons.home), findsNothing);
    });
  });

  group('Inicio', () {
    testWidgets('el avatar de la barra abre Mi perfil', (tester) async {
      var perfil = 0;
      await montar(
        tester,
        Scaffold(appBar: SolTopBar.home(onProfileTap: () => perfil++)),
      );

      await tester.tap(find.byType(SolAvatar));
      expect(perfil, 1);
    });

    testWidgets('sin onProfileTap no hay avatar', (tester) async {
      await montar(tester, const Scaffold(appBar: SolTopBar.home()));
      expect(find.byType(SolAvatar), findsNothing);
    });
  });
}
