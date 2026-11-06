import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';

/// HU-M02 (F3): refresh cifrado, prefijo de ambiente y migración.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late LlaveroSesionMemoria llavero;
  late SecureSesionStore store;
  const almacen = FlutterSecureStorage();
  final vence = DateTime.utc(2026, 11, 14, 15);

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    llavero = LlaveroSesionMemoria();
    store = SecureSesionStore(llavero, ambiente: 'dev');
  });

  test('guarda el refresh cifrado, con prefijo de ambiente', () async {
    await store.guardarRefresh('refresh-1', vence);

    final todo = await almacen.readAll();
    expect(todo.keys, {
      'dev.solventa.sesion.refresh',
      'dev.solventa.sesion.refreshVenceEn',
    });
    expect(todo['dev.solventa.sesion.refresh'], isNot('refresh-1'));
    expect(await store.leerRefresh(), 'refresh-1');
    expect(await store.refreshVenceEn(), vence);
    expect(await store.hayRefresh(), isTrue);
  });

  test('crea la llave la primera vez', () async {
    expect(await llavero.existe(), isFalse);

    await store.guardarRefresh('refresh-1', null);

    expect(await llavero.existe(), isTrue);
  });

  test('cada ambiente tiene su propia sesión', () async {
    await store.guardarRefresh('refresh-dev', vence);
    final prod = SecureSesionStore(llavero, ambiente: 'prod');

    expect(await prod.hayRefresh(), isFalse);
  });

  test('borra la clave vieja sin ambiente (solo JWT) una vez', () async {
    FlutterSecureStorage.setMockInitialValues({
      SecureSesionStore.claveAnterior: 'jwt-viejo',
    });

    expect(await store.hayRefresh(), isFalse);
    expect(await almacen.read(key: SecureSesionStore.claveAnterior), isNull);
  });

  test('leer exige la autenticación del llavero', () async {
    llavero.exigeAutenticacion = true;
    await store.guardarRefresh('refresh-1', vence);

    await expectLater(
      store.leerRefresh(),
      throwsA(isA<RequiereAutenticacion>()),
    );
    llavero.autenticar();
    expect(await store.leerRefresh(), 'refresh-1');
  });

  test('sin refresh guardado lanza SinRefreshGuardado', () async {
    await expectLater(store.leerRefresh(), throwsA(isA<SinRefreshGuardado>()));
  });

  test('sin bloqueo de pantalla no guarda nada', () async {
    llavero.conBloqueoPantalla = false;

    await expectLater(
      store.guardarRefresh('refresh-1', vence),
      throwsA(isA<SinBloqueoPantalla>()),
    );
    expect(await store.hayRefresh(), isFalse);
  });

  test('borrar quita el refresh, el vencimiento y la llave', () async {
    await store.guardarRefresh('refresh-1', vence);

    await store.borrar();

    expect(await almacen.readAll(), isEmpty);
    expect(await llavero.existe(), isFalse);
  });
}
