import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Catálogo semántico de íconos (Material Symbols, estilo outlined).
///
/// Es el único set de la app. Para la versión rellena (destino activo,
/// estados) usa `Icon(SolIcons.home, fill: 1)`.
abstract final class SolIcons {
  // Navegación.
  static const IconData back = Symbols.arrow_back;
  static const IconData chevronRight = Symbols.chevron_right;
  static const IconData expandMore = Symbols.expand_more;
  static const IconData close = Symbols.close;
  static const IconData home = Symbols.home;
  static const IconData assistance = Symbols.support;
  static const IconData assistanceActive = Symbols.support_agent;
  static const IconData logout = Symbols.logout;

  // Cuenta e idioma.
  static const IconData language = Symbols.language;
  static const IconData profile = Symbols.person;
  static const IconData lock = Symbols.lock;
  static const IconData backspace = Symbols.backspace;

  // Prestadores.
  static const IconData medical = Symbols.medical_services;
  static const IconData mechanic = Symbols.build;
  static const IconData verifiedProvider = Symbols.verified;
  static const IconData location = Symbols.location_on;
  static const IconData schedule = Symbols.schedule;

  // Home y registro.
  static const IconData pendingRegistration = Symbols.pending_actions;
  static const IconData wallet = Symbols.account_balance_wallet;

  // Estados (siempre con texto al lado).
  static const IconData success = Symbols.check_circle;
  static const IconData inReview = Symbols.arrow_circle_right;
  static const IconData failure = Symbols.cancel;
  static const IconData warning = Symbols.warning;
  static const IconData info = Symbols.info;
  static const IconData check = Symbols.check;
  static const IconData attention = Symbols.priority_high;
  static const IconData error = Symbols.error;

  // Captura de documento y prueba de vida.
  static const IconData camera = Symbols.photo_camera;
  static const IconData retry = Symbols.refresh;
  static const IconData idCard = Symbols.badge;
  static const IconData lighting = Symbols.light_mode;
  static const IconData face = Symbols.face;
  static const IconData portrait = Symbols.account_box;
}
