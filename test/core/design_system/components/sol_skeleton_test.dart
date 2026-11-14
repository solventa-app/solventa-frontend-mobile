import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// SolSkeleton: bloques que sustituyen al círculo de carga en las listas.
void main() {
  Future<void> montar(
    WidgetTester tester, {
    bool reducirAnimaciones = false,
    Widget? hijo,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: SolTheme.light(),
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(disableAnimations: reducirAnimaciones),
        child: app!,
      ),
      home: Scaffold(
        body: SolSkeletonGroup(
          message: 'Cargando tus reportes',
          child:
              hijo ??
              const Column(
                children: [
                  SolSkeleton(widthFactor: 0.5, height: 20),
                  SolSkeleton.circle(size: 24),
                ],
              ),
        ),
      ),
    ),
  );

  Color? colorDelBloque(WidgetTester tester) {
    final caja = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(SolSkeleton).first,
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return (caja.decoration as BoxDecoration).color;
  }

  testWidgets('TalkBack oye una sola frase y no los bloques', (tester) async {
    final semantica = tester.ensureSemantics();
    await montar(tester);

    expect(find.bySemanticsLabel('Cargando tus reportes'), findsOneWidget);
    expect(
      tester
          .getSemantics(find.byType(SolSkeletonGroup))
          .flagsCollection
          .isLiveRegion,
      isTrue,
    );
    semantica.dispose();
  });

  testWidgets('los bloques laten juntos: el color cambia con el tiempo', (
    tester,
  ) async {
    await montar(tester);
    final inicio = colorDelBloque(tester);

    await tester.pump(const Duration(milliseconds: 450));

    expect(colorDelBloque(tester), isNot(inicio));
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('con «quitar animaciones» quedan quietos', (tester) async {
    await montar(tester, reducirAnimaciones: true);
    final inicio = colorDelBloque(tester);

    await tester.pump(const Duration(milliseconds: 450));

    expect(colorDelBloque(tester), inicio);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('el ancho se puede fijar o dar como fracción', (tester) async {
    await montar(
      tester,
      hijo: const Column(
        children: [
          SolSkeleton(width: 88, height: 24),
          SolSkeleton(widthFactor: 0.5),
          SolSkeleton.circle(size: 24),
        ],
      ),
    );

    final bloques = find.byType(SolSkeleton);
    expect(tester.getSize(bloques.at(0)), const Size(88, 24));
    expect(
      tester.getSize(bloques.at(1)).width,
      closeTo(tester.getSize(find.byType(Scaffold)).width * 0.5, 0.5),
    );
    expect(tester.getSize(bloques.at(2)), const Size(24, 24));
  });

  testWidgets('suelto, fuera de un grupo, se ve igual sin latir', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SolTheme.light(),
        home: const Scaffold(body: SolSkeleton(height: 12)),
      ),
    );

    expect(find.byType(SolSkeleton), findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);
  });
}
