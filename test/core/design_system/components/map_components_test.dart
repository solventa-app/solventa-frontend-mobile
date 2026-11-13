import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import '../../../helpers/sol_test_app.dart';

/// HU-M06: piezas del mapa del sistema de diseño (M1, M3, M4, M8, M9, M14).
void main() {
  group('SolMapPin', () {
    test('destacado 44 dp, normal 32 y el seleccionado crece un paso', () {
      const normal = SolMapPinStyle(
        type: SolProviderType.mecanico,
        isPartner: false,
      );
      expect(normal.diameter, 32);
      const destacado = SolMapPinStyle(
        type: SolProviderType.medico,
        isPartner: true,
        featured: true,
        label: '6 min',
      );
      expect(destacado.diameter, 44);
      const elegido = SolMapPinStyle(
        type: SolProviderType.medico,
        isPartner: true,
        featured: true,
        selected: true,
        label: '6 min',
      );
      expect(elegido.diameter, 52);
      // La etiqueta solo la llevan los destacados y suma alto al lienzo.
      expect(
        destacado.sizeFor(40).height,
        greaterThan(normal.sizeFor(0).height + 12),
      );
    });

    testWidgets('el PNG para Mapbox sale a la densidad pedida', (tester) async {
      await pumpSol(tester, const SizedBox());
      final colores = SolMapPinColors.of(tester.element(find.byType(SizedBox)));
      const style = SolMapPinStyle(
        type: SolProviderType.grua,
        isPartner: false,
      );
      final png = await tester.runAsync(
        () => SolMapPin.toPng(style, colores, pixelRatio: 2),
      );
      expect(png, isNotNull);
      // Firma PNG.
      expect(png!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    });
  });

  testWidgets('SolMapFab: 48 dp de área táctil y la etiqueta dice la acción', (
    tester,
  ) async {
    var toques = 0;
    await pumpSol(
      tester,
      Center(
        child: SolMapFab(
          icon: SolIcons.layers,
          semanticLabel: 'Ver satélite',
          onPressed: () => toques++,
        ),
      ),
    );
    expect(tester.getSize(find.byType(SolMapFab)), const Size(48, 48));
    await tester.tap(find.bySemanticsLabel('Ver satélite'));
    expect(toques, 1);
    await expectA11yGuidelines(tester);
  });

  testWidgets('SolDraggableSheet: acciones de TalkBack para subir y bajar', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    final controlador = DraggableScrollableController();
    addTearDown(controlador.dispose);
    await pumpSol(
      tester,
      SizedBox(
        height: 600,
        child: SolDraggableSheet(
          controller: controlador,
          minFraction: 0.15,
          initialFraction: 0.4,
          expandLabel: 'Expandir lista',
          collapseLabel: 'Contraer lista',
          builder: (context, scroll) => ListView(
            controller: scroll,
            children: const [Text('Prestadores cercanos')],
          ),
        ),
      ),
    );
    expect(controlador.size, closeTo(0.4, 0.01));
    final nodo = tester.getSemantics(find.byType(GestureDetector).first);
    final acciones = nodo
        .getSemanticsData()
        .customSemanticsActionIds!
        .map(CustomSemanticsAction.getAction)
        .map((a) => a!.label)
        .toSet();
    expect(acciones, {'Expandir lista', 'Contraer lista'});
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();
    expect(controlador.size, closeTo(0.85, 0.01));
    semantica.dispose();
  });

  testWidgets('SolPhotoBanner: sin foto, el placeholder del tipo', (
    tester,
  ) async {
    await pumpSol(
      tester,
      const SolPhotoBanner(placeholderIcon: SolIcons.towTruck),
    );
    expect(find.byIcon(SolIcons.towTruck), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
