import 'package:flutter/widgets.dart';

import '../../l10n/gen/app_localizations.dart';

/// Textos por defecto del sistema de diseño (botón «Volver», etiquetas de
/// `Semantics`, «Mostrar clave»…) en el idioma activo, desde los mismos
/// catálogos ARB de la app (docs/arquitectura.md §7, claves `sol*`).
extension SolTextosX on BuildContext {
  /// Sin el delegado de la app (galería, goldens de componentes o una prueba
  /// suelta) usa español, los textos del Figma.
  AppLocalizations get solTextos =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(const Locale('es'));
}
