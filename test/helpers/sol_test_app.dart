import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// Monta [child] con el tema y el locale de Solventa.
Future<void> pumpSol(
  WidgetTester tester,
  Widget child, {
  double textScale = 1.0,
  Size size = const Size(390, 844),
  bool scaffold = true,
  bool disableAnimations = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: SolTheme.light(),
      locale: SolLocalizations.locale,
      supportedLocales: SolLocalizations.supportedLocales,
      localizationsDelegates: SolLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: disableAnimations,
        ),
        child: app!,
      ),
      home: scaffold
          ? Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            )
          : child,
    ),
  );
}

/// Verifica las guías de accesibilidad de Flutter sobre la pantalla actual.
///
/// [contrast] usa el muestreo de píxeles de Flutter; en nodos que mezclan
/// ícono, píldora y texto da falsos positivos, y ahí el contraste lo cubre
/// el test de pares de color del tema.
Future<void> expectA11yGuidelines(
  WidgetTester tester, {
  bool contrast = true,
}) async {
  final handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  if (contrast) {
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }
  handle.dispose();
}
