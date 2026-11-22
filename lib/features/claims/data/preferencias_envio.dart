import 'package:shared_preferences/shared_preferences.dart';

/// Cómo quiere el cliente que salgan sus reportes (HU-M05, plan 4.4). No son
/// datos personales: van en `SharedPreferences`.
final class PreferenciasEnvio {
  const PreferenciasEnvio({
    this.soloWifi = false,
    this.preguntado = false,
    this.permisoPedido = false,
  });

  /// «Enviar las fotos solo con Wi-Fi» de Mi perfil. Apagado por defecto.
  final bool soloWifi;

  /// La pregunta de datos móviles ya se hizo y el cliente pidió recordarla.
  final bool preguntado;

  /// Ya se pidió el permiso de notificaciones por un reporte (no se insiste).
  final bool permisoPedido;

  PreferenciasEnvio copyWith({
    bool? soloWifi,
    bool? preguntado,
    bool? permisoPedido,
  }) => PreferenciasEnvio(
    soloWifi: soloWifi ?? this.soloWifi,
    preguntado: preguntado ?? this.preguntado,
    permisoPedido: permisoPedido ?? this.permisoPedido,
  );
}

abstract interface class PreferenciasEnvioStore {
  Future<PreferenciasEnvio> leer();
  Future<void> guardar(PreferenciasEnvio preferencias);
}

final class PrefsPreferenciasEnvioStore implements PreferenciasEnvioStore {
  const PrefsPreferenciasEnvioStore();

  static const _soloWifi = 'solventa.reportes.soloWifi';
  static const _preguntado = 'solventa.reportes.datosPreguntado';
  static const _permiso = 'solventa.reportes.permisoAvisosPedido';

  @override
  Future<PreferenciasEnvio> leer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return PreferenciasEnvio(
        soloWifi: prefs.getBool(_soloWifi) ?? false,
        preguntado: prefs.getBool(_preguntado) ?? false,
        permisoPedido: prefs.getBool(_permiso) ?? false,
      );
    } catch (_) {
      return const PreferenciasEnvio();
    }
  }

  @override
  Future<void> guardar(PreferenciasEnvio preferencias) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soloWifi, preferencias.soloWifi);
      await prefs.setBool(_preguntado, preferencias.preguntado);
      await prefs.setBool(_permiso, preferencias.permisoPedido);
    } catch (_) {
      // Sin plugin: la elección vale mientras la app siga abierta.
    }
  }
}

final class MemoriaPreferenciasEnvioStore implements PreferenciasEnvioStore {
  MemoriaPreferenciasEnvioStore([this.valor = const PreferenciasEnvio()]);

  PreferenciasEnvio valor;

  @override
  Future<PreferenciasEnvio> leer() async => valor;

  @override
  Future<void> guardar(PreferenciasEnvio preferencias) async =>
      valor = preferencias;
}
