import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_onboarding_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/fixtures/onboarding_fixtures.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

import 'soporte/capturas.dart';

/// HU-M01 (KAN-31) en dispositivo, con `API_ENV=mock`: después de agotar los
/// intentos de la prueba de vida, la persona vuelve al inicio, acepta otra vez
/// el consentimiento (M01-02) y llega a la foto de la cédula (M01-03) con un
/// recorrido nuevo. Antes M01-02 se quedaba con el recorrido rechazado y no
/// avanzaba. La cámara es la falsa: el visor no abre la del dispositivo.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'sin intentos se empieza una verificación nueva desde el inicio',
    (tester) async {
      // En el teléfono pequeño el teclado real encoge la pantalla y «Crear
      // cuenta» queda debajo de él: con el teclado de prueba no aparece.
      tester.testTextInput.register();
      addTearDown(tester.testTextInput.unregister);
      final bff = FakeOnboardingRemoteDataSource(latencia: Duration.zero);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fakeOnboardingProvider.overrideWithValue(bff),
            camaraEnVivoHabilitadaProvider.overrideWithValue(false),
            esperasVerificacionProvider.overrideWithValue(const [
              Duration.zero,
              Duration.zero,
              Duration.zero,
            ]),
            biometriaServiceProvider.overrideWithValue(
              FakeBiometriaService(
                estadoActual: EstadoBiometria.biometriaRegistrada,
              ),
            ),
          ],
          child: const SolventaApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Cuenta nueva con el código del fake (123456).
      await tester.tap(find.text('¿No tienes cuenta? Crear cuenta'));
      await tester.pumpAndSettle();
      final campos = find.byType(TextField);
      await tester.enterText(campos.at(0), 'maria@ejemplo.co');
      await tester.enterText(campos.at(1), 'Clave-segura-1');
      await tester.enterText(campos.at(2), 'Clave-segura-1');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Crear cuenta'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Crear cuenta'));
      await tester.pumpAndSettle();
      for (final d in ['1', '2', '3', '4', '5', '6']) {
        await tester.tap(find.text(d));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      Future<void> hastaLaCedula() async {
        await tester.tap(find.text('Empezar'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(SolConsentCheckbox));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continuar'));
        await tester.pumpAndSettle();
        expect(find.text('Captura del documento'), findsWidgets);
      }

      await tester.tap(find.text('Completar registro'));
      await tester.pumpAndSettle();
      await hastaLaCedula();
      await tester.tap(find.text('Capturar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Capturar'));
      await tester.pumpAndSettle();

      // Didit rechaza el rostro y ya no quedan intentos en este recorrido.
      bff.resultado = OnboardingFixtures.onboarding(
        estado: 'RECHAZADA',
        motivo: 'ROSTRO_NO_COINCIDE',
        intento: 3,
        intentosRestantes: 0,
      );
      await tester.tap(find.text('Grabar video'));
      await tester.pumpAndSettle();
      await capturar(tester, 'M01-07c · sin intentos');
      expect(find.textContaining('puedes empezar una nueva'), findsOneWidget);
      await tester.tap(find.text('Ir al inicio'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reintentar verificación'));
      await tester.pumpAndSettle();
      await hastaLaCedula();
      await capturar(tester, 'M01-03 · recorrido nuevo');
      expect(bff.operaciones.where((o) => o == 'iniciar'), hasLength(2));
    },
  );
}
