import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import '../../helpers/sol_test_app.dart';

void main() {
  testWidgets('La galería muestra todas las secciones sin errores', (
    tester,
  ) async {
    await pumpSol(tester, const SolGalleryPage(), scaffold: false);
    for (final title in [
      'Botón (2018:16)',
      'Barra superior (2018:35)',
      'Fila de prestador (2018:103)',
      'PIN y teclado',
      'Hojas, diálogos y layouts',
    ]) {
      await tester.scrollUntilVisible(
        find.text(title),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(title), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('En debug, un toque largo en el wordmark abre la galería', (
    tester,
  ) async {
    await tester.pumpWidget(const SolventaApp());
    await tester.pumpAndSettle();
    await tester.longPress(find.text('Solventa'));
    // La galería tiene indicadores de carga infinitos: no se usa
    // pumpAndSettle.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SolGalleryPage), findsOneWidget);
  });

  test('La ruta solo responde a /galeria', () {
    expect(SolGalleryPage.route(const RouteSettings(name: '/otra')), isNull);
    expect(
      SolGalleryPage.route(const RouteSettings(name: SolGalleryPage.routeName)),
      isNotNull,
    );
  });
}
