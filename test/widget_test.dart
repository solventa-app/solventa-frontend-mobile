import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_05b_cuenta_page.dart';

class _SesionActivaNotifier extends OnboardingNotifier {
  @override
  OnboardingState build() => const OnboardingState(cuentaCreada: true);
}

void main() {
  testWidgets(
    'La app arranca en Crea tu cuenta (M01-05b) con el tema de Solventa',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: SolventaApp()));
      await tester.pumpAndSettle();

      expect(find.text('Crea tu cuenta'), findsOneWidget);
      expect(find.text('Crear cuenta'), findsOneWidget);
      expect(find.byType(M0105bCuentaPage), findsOneWidget);

      final context = tester.element(find.byType(M0105bCuentaPage));
      expect(Theme.of(context).colorScheme.primary, const Color(0xFF1E4680));
      expect(Localizations.localeOf(context), const Locale('es', 'CO'));
    },
  );

  testWidgets(
    'Con sesión activa, Home G-03 muestra bienvenida y cerrar sesión pide confirmación',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingProvider.overrideWith(_SesionActivaNotifier.new),
          ],
          child: const SolventaApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Solventa'), findsOneWidget);
      expect(find.text('Bienvenido a Solventa'), findsOneWidget);
      expect(find.text('Completar registro'), findsOneWidget);
      expect(find.byType(SolBottomNav), findsOneWidget);

      final context = tester.element(find.byType(HomePage));
      expect(Theme.of(context).colorScheme.primary, const Color(0xFF1E4680));
      expect(Localizations.localeOf(context), const Locale('es', 'CO'));

      await tester.tap(find.text('Cerrar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('¿Quieres cerrar sesión?'), findsOneWidget);
      await tester.tap(find.text('No, seguir aquí'));
      await tester.pumpAndSettle();
      expect(find.text('Bienvenido a Solventa'), findsOneWidget);
    },
  );
}
