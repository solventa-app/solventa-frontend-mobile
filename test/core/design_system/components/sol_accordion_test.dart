import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// SolAccordion: abre y cierra con o sin «quitar animaciones» del sistema.
void main() {
  Future<void> montar(
    WidgetTester tester, {
    required bool reducirAnimaciones,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: SolTheme.light(),
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(disableAnimations: reducirAnimaciones),
        child: app!,
      ),
      home: const Scaffold(
        body: SolAccordion(
          title: 'En camino (1)',
          children: [Text('Grúa Express')],
        ),
      ),
    ),
  );

  for (final reducir in [false, true]) {
    testWidgets('abre y cierra sin errores (quitar animaciones: $reducir)', (
      tester,
    ) async {
      await montar(tester, reducirAnimaciones: reducir);
      expect(find.text('Grúa Express'), findsOneWidget);

      await tester.tap(find.text('En camino (1)'));
      await tester.pumpAndSettle();
      expect(find.text('Grúa Express'), findsNothing);

      await tester.tap(find.text('En camino (1)'));
      await tester.pumpAndSettle();
      expect(find.text('Grúa Express'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
