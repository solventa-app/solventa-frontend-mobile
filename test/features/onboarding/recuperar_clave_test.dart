import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

/// M02-04 · «¿Olvidaste tu contraseña?» (KAN-26): pide solo el correo y responde
/// siempre lo mismo; el enlace llega por correo y se abre en la web.
void main() {
  late FakeOnboardingRemoteDataSource bff;

  Future<void> abrirLogin(WidgetTester tester) async {
    bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [fakeOnboardingProvider.overrideWithValue(bff)],
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'el ingreso enlaza a M02-04 y el enlace se pide solo con correo',
    (tester) async {
      await abrirLogin(tester);
      await tester.tap(find.text('¿Olvidaste tu contraseña?'));
      await tester.pumpAndSettle();

      expect(find.text('Recupera tu contraseña'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Un correo inválido no sale a la red.
      await tester.enterText(find.byType(TextField), 'no-es-correo');
      await tester.tap(find.text('Enviar enlace'));
      await tester.pumpAndSettle();
      expect(
        bff.operaciones,
        isNot(contains('solicitarRestablecimientoClave')),
      );

      await tester.enterText(find.byType(TextField), 'nadie@ejemplo.com');
      await tester.tap(find.text('Enviar enlace'));
      await tester.pumpAndSettle();

      expect(bff.operaciones, contains('solicitarRestablecimientoClave'));
      expect(find.text('Revisa tu correo'), findsOneWidget);
      expect(
        find.textContaining('Si hay una cuenta con ese correo'),
        findsOneWidget,
      );
      expect(find.text('Enviar enlace'), findsNothing);
    },
  );

  testWidgets('desde M02-04 se vuelve al ingreso', (tester) async {
    await abrirLogin(tester);
    await tester.tap(find.text('¿Olvidaste tu contraseña?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volver a iniciar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Inicia sesión'), findsOneWidget);
  });
}
