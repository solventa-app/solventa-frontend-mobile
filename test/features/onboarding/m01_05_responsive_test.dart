import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_05_prueba_vida_page.dart';

class _EstadoFijo extends OnboardingNotifier {
  _EstadoFijo(this._estado);
  final OnboardingState _estado;

  @override
  OnboardingState build() => _estado;
}

/// M01-05 no se desborda en teléfonos bajos ni con texto grande, ni antes de
/// grabar ni mientras graba (hallazgo de felipe, 2026-11-21: franja amarilla
/// bajo los pasos).
void main() {
  setUp(SolLocalizations.init);

  final casos = <(Size, double)>[
    (const Size(320, 568), 1),
    (const Size(360, 640), 1),
    (const Size(360, 640), 1.3),
    (const Size(390, 844), 2),
    (const Size(600, 960), 1),
  ];

  for (final grabando in [false, true]) {
    for (final (tamano, escala) in casos) {
      testWidgets(
        'sin desborde · ${tamano.width.toInt()}×${tamano.height.toInt()} · '
        'texto ${(escala * 100).toInt()} % · ${grabando ? 'grabando' : 'lista'}',
        (tester) async {
          tester.view.physicalSize = tamano;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                onboardingProvider.overrideWith(
                  () => _EstadoFijo(OnboardingState(grabandoVideo: grabando)),
                ),
              ],
              child: MaterialApp(
                theme: SolTheme.light(),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  ...SolLocalizations.delegates,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('es'),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(escala)),
                  child: child!,
                ),
                home: const M0105PruebaVidaPage(),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }
}
