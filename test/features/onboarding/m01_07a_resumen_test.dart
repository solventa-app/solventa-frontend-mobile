import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_07_resultado_page.dart';

class _EstadoFijo extends OnboardingNotifier {
  _EstadoFijo(this._estado);
  final OnboardingState _estado;

  @override
  OnboardingState build() => _estado;

  @override
  Future<void> cargarPerfilYEstado() async {}
}

/// KAN-130: M01-07a lista lo que quedó verificado, con texto (no solo
/// íconos), en los dos idiomas.
void main() {
  Future<void> montar(
    WidgetTester tester,
    Locale locale,
    EstadoVerificacion verificacion,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingProvider.overrideWith(
            () => _EstadoFijo(OnboardingState(verificacion: verificacion)),
          ),
        ],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const M0107ResultadoPage(),
        ),
      ),
    );
    await tester.pump();
  }

  for (final locale in [AppLocales.es, AppLocales.en]) {
    testWidgets('verificada muestra el resumen (${locale.languageCode})', (
      tester,
    ) async {
      final l10n = lookupAppLocalizations(locale);
      final semantica = tester.ensureSemantics();
      await montar(tester, locale, EstadoVerificacion.verificada);

      for (final fila in [
        l10n.m0107aDocumento,
        l10n.m0107aPruebaVida,
        l10n.m0107aRostro,
      ]) {
        expect(find.text(fila), findsOneWidget);
        // TalkBack lee cada fila junto con el mensaje, no solo el ícono.
        expect(
          find.bySemanticsLabel(RegExp(RegExp.escape(fila))),
          findsWidgets,
        );
      }
      semantica.dispose();
    });
  }

  testWidgets('el resumen no aparece en un rechazo', (tester) async {
    final l10n = lookupAppLocalizations(AppLocales.es);
    await montar(tester, AppLocales.es, EstadoVerificacion.rechazada);
    expect(find.text(l10n.m0107aDocumento), findsNothing);
  });
}
