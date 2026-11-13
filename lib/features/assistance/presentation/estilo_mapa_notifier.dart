import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/mapa/mapa_datos.dart';

/// Estilo del mapa elegido con el botón de capas (M14). Calles por defecto;
/// la elección se recuerda en `SharedPreferences` (no es un dato personal).
final class EstiloMapaNotifier extends Notifier<EstiloMapa> {
  static const clave = 'solventa.asistencia.estiloMapa';

  @override
  EstiloMapa build() {
    unawaited(_leer());
    return EstiloMapa.calles;
  }

  Future<void> _leer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final guardado = prefs.getString(clave);
      if (!ref.mounted) return;
      if (guardado == EstiloMapa.satelite.name) state = EstiloMapa.satelite;
    } catch (_) {
      // Sin plugin (pruebas): queda el estilo por defecto.
    }
  }

  Future<void> alternar() async {
    state = state == EstiloMapa.calles
        ? EstiloMapa.satelite
        : EstiloMapa.calles;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(clave, state.name);
    } catch (_) {
      // Sin plugin: la elección vale mientras dure la sesión.
    }
  }
}
