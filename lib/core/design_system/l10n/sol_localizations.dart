import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'sol_formatters.dart';

/// Configuración regional de la app (es-CO).
abstract final class SolLocalizations {
  static const Locale locale = SolFormat.locale;

  static const List<Locale> supportedLocales = [
    Locale('es', 'CO'),
    Locale('es'),
    Locale('en'),
  ];

  static const List<LocalizationsDelegate<dynamic>> delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Fija es_CO como locale por defecto de `intl`.
  static void init() {
    Intl.defaultLocale = SolFormat.localeName;
  }
}
