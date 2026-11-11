import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';

void main() {
  // HU-M02 (D4): quien registró una huella nueva no ve «sesión vencida» ni un
  // error técnico, sino por qué debe entrar con su correo y clave.
  test('la llave invalidada explica el cambio y pide correo y clave', () {
    final es = lookupAppLocalizations(const Locale('es'));
    final en = lookupAppLocalizations(const Locale('en'));

    expect(
      es.falla(const SeguridadTelefonoCambio()),
      contains('correo y clave'),
    );
    expect(es.falla(const SeguridadTelefonoCambio()), contains('huella'));
    expect(
      en.falla(const SeguridadTelefonoCambio()),
      contains('email and password'),
    );
    expect(
      es.falla(const SeguridadTelefonoCambio()),
      isNot(es.falla(const SesionVencida())),
    );
  });
}
