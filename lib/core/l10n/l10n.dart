import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/falla.dart';
import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension L10nX on BuildContext {
  /// Textos de la app en el idioma activo (`lib/core/l10n/arb/`).
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Idiomas de la app: español de Colombia (por defecto) e inglés.
abstract final class AppLocales {
  static const es = Locale('es', 'CO');
  static const en = Locale('en');
  static const supported = [es, en];
}

/// Idioma activo. La píldora «ES · COP» de la barra superior lo alterna.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => AppLocales.es;

  void alternar() =>
      state = state.languageCode == 'es' ? AppLocales.en : AppLocales.es;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// Texto para el usuario de cada [Falla] (nunca un error técnico).
extension FallaTextoX on AppLocalizations {
  String falla(Falla f) => switch (f) {
    SinConexion() => fallaSinConexion,
    ServicioNoDisponible() => fallaServicio,
    _ => fallaGenerica,
  };
}
