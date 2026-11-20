import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_07_resultado_page.dart';

/// KAN-131: un rechazo técnico (el proveedor siguió fallando o no se pudieron
/// leer las fotos) no gastó intento y lo dice, en M01-07c y en el inicio.
void main() {
  for (final locale in [AppLocales.es, AppLocales.en]) {
    final l10n = lookupAppLocalizations(locale);

    test('motivos técnicos usan su texto propio (${locale.languageCode})', () {
      for (final motivo in [
        'PROVEEDOR_NO_DISPONIBLE',
        'IMAGEN_NO_DISPONIBLE',
      ]) {
        expect(mensajeRechazo(l10n, motivo), l10n.m0107cFallaTecnica);
      }
      expect(l10n.m0107cFallaTecnica, isNot(l10n.m0107cMensaje));
    });

    test('los demás motivos no cambian (${locale.languageCode})', () {
      expect(mensajeRechazo(l10n, 'ILEGIBLE'), l10n.m0107cMensaje);
      expect(mensajeRechazo(l10n, null), l10n.m0107cMensaje);
      expect(mensajeRechazo(l10n, 'ROSTRO_NO_COINCIDE'), l10n.m0107cRostro);
      expect(mensajeRechazo(l10n, 'SUPLANTACION'), l10n.m0107cSuplantacion);
    });
  }

  test('el texto en español dice que no se perdió ningún intento', () {
    final es = lookupAppLocalizations(const Locale('es'));
    expect(es.m0107cFallaTecnica, contains('No perdiste ningún intento'));
  });
}
