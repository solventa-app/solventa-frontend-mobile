import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// Un párrafo que ocupa más líneas en los 600 dp de `SolAdaptiveBody` que en el
/// ancho completo de una tablet en horizontal.
final _texto = List.filled(40, 'Estamos enviando tu reporte.').join(' ');

Future<void> _abrir(WidgetTester tester, Size tamano, String texto) async {
  tester.view.physicalSize = tamano;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: SolTheme.light(),
      home: SolScreenFrame(
        topBar: AppBar(),
        centerBody: true,
        body: Text(texto),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets(
    'tablet en horizontal con el teclado abierto: el contenido centrado no se '
    'desborda y se puede desplazar',
    (tester) async {
      await _abrir(tester, const Size(1280, 278), _texto);
      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsOneWidget);
      final posicion = tester
          .state<ScrollableState>(find.byType(Scrollable))
          .position;
      expect(posicion.maxScrollExtent, greaterThan(0));
    },
  );

  testWidgets('si el contenido cabe, sigue centrado en el alto disponible', (
    tester,
  ) async {
    await _abrir(tester, const Size(390, 748), 'Corto');
    expect(tester.takeException(), isNull);
    final barra = tester.getBottomLeft(find.byType(AppBar)).dy;
    final centro = tester.getCenter(find.text('Corto')).dy;
    expect(centro, moreOrLessEquals((barra + 748) / 2, epsilon: 1));
  });
}
