import 'package:flutter/widgets.dart';

import '../design_system/icons/sol_icons.dart';
import 'biometria_service.dart';

/// Un ícono por método (M02-01, M01-08): la huella y el rostro cuando el sistema lo confirma, el candado si el teléfono
/// solo tiene bloqueo de pantalla y el escudo cuando no se sabe cuál.
extension TipoBiometriaIcono on TipoBiometria {
  IconData get icono => switch (this) {
    TipoBiometria.huella => SolIcons.fingerprint,
    TipoBiometria.rostro => SolIcons.face,
    TipoBiometria.ninguna => SolIcons.lock,
    TipoBiometria.generica => SolIcons.shield,
  };
}
