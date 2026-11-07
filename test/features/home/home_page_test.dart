import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';

/// T15: lo que el Home dice del acceso a la app y a la web según la
/// verificación de identidad.
void main() {
  const avisoWeb =
      'Tu verificación fue exitosa. Ya puedes entrar también a la web de '
      'Solventa con el mismo correo y clave.';
  const avisoSoloApp =
      'Mientras tu identidad no esté verificada solo puedes entrar a esta '
      'app. La web no te dejará entrar hasta que termines la verificación '
      'aquí.';

  Future<void> abrir(
    WidgetTester tester, {
    EstadoVerificacion? verificacion,
    Locale locale = AppLocales.es,
  }) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: SolTheme.light(),
        locale: locale,
        supportedLocales: AppLocales.supported,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...SolLocalizations.delegates,
        ],
        home: Scaffold(
          body: HomePage(
            userName: 'María',
            verificacion: verificacion,
            onCompleteRegistration: () {},
            onRequestAssistance: () {},
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('verificada: avisa que ya puede entrar también a la web', (
    tester,
  ) async {
    await abrir(tester, verificacion: EstadoVerificacion.verificada);

    expect(find.text('Identidad verificada'), findsOneWidget);
    expect(find.text(avisoWeb), findsOneWidget);
    expect(find.text(avisoSoloApp), findsNothing);
  });

  testWidgets('en revisión: solo entra a la app mientras no verifique', (
    tester,
  ) async {
    await abrir(tester, verificacion: EstadoVerificacion.enRevision);

    expect(find.text(avisoSoloApp), findsOneWidget);
    expect(find.text(avisoWeb), findsNothing);
  });

  testWidgets('rechazada: solo entra a la app mientras no verifique', (
    tester,
  ) async {
    await abrir(tester, verificacion: EstadoVerificacion.rechazada);

    expect(find.text(avisoSoloApp), findsOneWidget);
    expect(find.text(avisoWeb), findsNothing);
  });

  testWidgets('sin verificar (Completa tu registro) no cambia', (tester) async {
    await abrir(tester);

    expect(find.text('Completar registro'), findsOneWidget);
    expect(find.text(avisoSoloApp), findsNothing);
    expect(find.text(avisoWeb), findsNothing);
  });

  testWidgets('el aviso sale en inglés con el idioma en inglés', (
    tester,
  ) async {
    await abrir(
      tester,
      verificacion: EstadoVerificacion.verificada,
      locale: AppLocales.en,
    );

    expect(
      find.textContaining('Your verification was successful'),
      findsOneWidget,
    );
  });
}
