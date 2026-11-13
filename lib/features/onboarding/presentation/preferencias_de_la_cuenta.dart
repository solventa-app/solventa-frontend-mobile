import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import 'onboarding_notifier.dart';

/// Lo guardado en la cuenta manda al abrir la sesión: el idioma y la moneda del perfil (`yo`) pasan a la app, de
/// modo que lo que se eligió en la web o en otro teléfono se ve aquí. Si ya coinciden con los del teléfono no se
/// toca nada. Lo contrario (lo que se cambia aquí se guarda en la cuenta) lo hace `OnboardingNotifier`.
///
/// Se mantiene vivo desde `SolventaApp` (`ref.watch`).
final preferenciasDeLaCuentaProvider = Provider<void>((ref) {
  ref.listen(onboardingProvider.select((s) => s.perfil), (antes, ahora) {
    if (ahora == null) return;
    if (antes?.id == ahora.id &&
        antes?.idioma == ahora.idioma &&
        antes?.moneda == ahora.moneda) {
      return;
    }
    ref.read(localeProvider.notifier).cambiarPorCodigo(ahora.idioma);
    ref.read(monedaProvider.notifier).cambiar(ahora.moneda);
  });
});
