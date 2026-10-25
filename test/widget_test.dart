import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';

void main() {
  testWidgets('La app arranca en Home G-03 con el tema de Solventa', (
    tester,
  ) async {
    await tester.pumpWidget(const SolventaApp());
    await tester.pumpAndSettle();

    expect(find.text('Solventa'), findsOneWidget);
    expect(find.text('Hola, María'), findsOneWidget);
    expect(find.text('Completar registro'), findsOneWidget);
    expect(find.byType(SolBottomNav), findsOneWidget);

    final context = tester.element(find.byType(HomePage));
    expect(Theme.of(context).colorScheme.primary, const Color(0xFF1E4680));
    expect(Localizations.localeOf(context), const Locale('es', 'CO'));
  });

  testWidgets('Cerrar sesión pide confirmación', (tester) async {
    await tester.pumpWidget(const SolventaApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('¿Quieres cerrar sesión?'), findsOneWidget);
    await tester.tap(find.text('No, seguir aquí'));
    await tester.pumpAndSettle();
    expect(find.text('Hola, María'), findsOneWidget);
  });
}
