import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/onboarding/domain/regla_clave.dart';

void main() {
  test('clave1234 falla: sin mayúscula ni especial', () {
    final r = ReglaClave.evaluar('clave1234');
    expect(
      (r.largo, r.mayuscula, r.minuscula, r.especial, r.cumple),
      (true, false, true, false, false),
    );
  });

  test('claves globales que cumplen (Unicode)', () {
    for (final c in ['Contraseña¿1', 'Ñandú€uno', 'Zażółć gęślą', 'Straße-Ä1']) {
      expect(ReglaClave.evaluar(c).cumple, isTrue, reason: c);
    }
  });

  test('el emoji y el espacio cuentan como especial', () {
    expect(ReglaClave.evaluar('Abcdefg😀').cumple, isTrue);
    expect(ReglaClave.evaluar('Abcdef g').cumple, isTrue);
  });

  test('una ñ es letra, no especial; letras sin caso no cumplen', () {
    expect(ReglaClave.evaluar('Contraseñaa').especial, isFalse);
    final r = ReglaClave.evaluar('密码密码密码密码!');
    expect((r.mayuscula, r.minuscula, r.cumple), (false, false, false));
  });

  test('largo entre 8 y 128 caracteres, no bytes', () {
    expect(ReglaClave.evaluar('Aa!aaaa').largo, isFalse);
    expect(ReglaClave.evaluar('Aa!aaaaa').largo, isTrue);
    expect(ReglaClave.evaluar('Aa!${'a' * 125}').largo, isTrue);
    expect(ReglaClave.evaluar('Aa!${'a' * 126}').largo, isFalse);
  });
}
