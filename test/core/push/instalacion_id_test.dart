import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solventa_mobile/core/push/instalacion_id.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('genera un UUID v4 válido la primera vez', () async {
    final store = SharedPrefsInstalacionIdStore();
    final id = await store.obtener();

    expect(
      id,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });

  test('persiste el mismo id entre llamadas', () async {
    final store = SharedPrefsInstalacionIdStore();
    final primero = await store.obtener();
    final segundo = await SharedPrefsInstalacionIdStore().obtener();

    expect(primero, segundo);
  });

  test('MemoriaInstalacionIdStore siempre da el mismo id fijo', () async {
    const store = MemoriaInstalacionIdStore('fijo-123');
    expect(await store.obtener(), 'fijo-123');
    expect(await store.obtener(), 'fijo-123');
  });
}
