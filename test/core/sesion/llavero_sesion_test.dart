import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';

/// HU-M02 (D3): el lado Dart del canal `com.solventa/llavero_sesion`. El
/// cifrado real (Kotlin) se valida en un dispositivo; aquí, el contrato.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const canal = MethodChannel(LlaveroSesionNativo.nombreCanal);
  final llamadas = <MethodCall>[];

  void responder(Object? Function(MethodCall) respuesta) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(canal, (llamada) async {
          llamadas.add(llamada);
          return respuesta(llamada);
        });
  }

  setUp(llamadas.clear);
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(canal, null),
  );

  final llavero = LlaveroSesionNativo(alias: 'dev.solventa.sesion.llave');

  test('envía el alias del ambiente en cada llamada', () async {
    responder(
      (l) => switch (l.method) {
        'existe' => true,
        'cifrar' => 'cifrado',
        'descifrar' => 'refresh',
        _ => null,
      },
    );

    expect(await llavero.existe(), isTrue);
    expect(await llavero.cifrar('refresh'), 'cifrado');
    expect(await llavero.descifrar('cifrado'), 'refresh');
    await llavero.crear();
    await llavero.borrar();

    expect(llamadas.map((l) => l.method), [
      'existe',
      'cifrar',
      'descifrar',
      'crear',
      'borrar',
    ]);
    for (final l in llamadas) {
      expect(
        (l.arguments as Map<Object?, Object?>)['alias'],
        'dev.solventa.sesion.llave',
      );
    }
  });

  test('traduce los códigos del canal nativo', () async {
    for (final (codigo, tipo) in [
      ('REQUIERE_AUTENTICACION', RequiereAutenticacion),
      ('LLAVE_INVALIDADA', LlaveInvalidada),
      ('SIN_BLOQUEO_PANTALLA', SinBloqueoPantalla),
      ('INTERNO', FallaLlavero),
    ]) {
      responder((_) => throw PlatformException(code: codigo));
      await expectLater(
        llavero.descifrar('x'),
        throwsA(predicate<Object>((e) => e.runtimeType == tipo)),
        reason: codigo,
      );
    }
  });

  test('ningún error lleva el texto que se cifraba', () async {
    responder((_) => throw PlatformException(code: 'INTERNO'));

    try {
      await llavero.cifrar('refresh-secreto');
      fail('debía lanzar');
    } on ErrorLlavero catch (e) {
      expect(e.toString(), isNot(contains('refresh-secreto')));
    }
  });

  group('LlaveroSesionMemoria', () {
    test('simula la ventana de autenticación', () async {
      final fake = LlaveroSesionMemoria(exigeAutenticacion: true);
      await fake.crear();
      final cifrado = await fake.cifrar('refresh');

      expect(cifrado, isNot('refresh'));
      await expectLater(
        fake.descifrar(cifrado),
        throwsA(isA<RequiereAutenticacion>()),
      );
      fake.autenticar();
      expect(await fake.descifrar(cifrado), 'refresh');
      // La ventana se usa una vez.
      await expectLater(
        fake.descifrar(cifrado),
        throwsA(isA<RequiereAutenticacion>()),
      );
    });

    test('sin bloqueo de pantalla no crea la llave', () async {
      final fake = LlaveroSesionMemoria(conBloqueoPantalla: false);

      await expectLater(fake.crear(), throwsA(isA<SinBloqueoPantalla>()));
    });
  });
}
