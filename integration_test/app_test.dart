import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:solventa_mobile/main.dart' as app;

/// Prueba de humo en dispositivo: la app arranca y pinta su primera
/// pantalla. Corre en los emuladores de GitHub Actions (emuladores.yml) y
/// en Firebase Test Lab (test-lab.yml). Cada HU con un recorrido agrega aquí
/// su prueba.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('la app arranca sin errores', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
