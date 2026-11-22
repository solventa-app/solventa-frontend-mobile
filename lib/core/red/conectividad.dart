import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../log/sol_log.dart';
import 'estado_red.dart';

/// La interfaz de red del teléfono (Wi-Fi, datos o nada). No dice si de
/// verdad hay salida a internet: eso lo decide la sonda al gateway.
abstract interface class Conectividad {
  Future<TipoRed> actual();

  /// Avisa al cambiar la interfaz, al instante.
  Stream<TipoRed> get cambios;
}

/// Sobre `connectivity_plus`. Sin plugin (pruebas) responde [TipoRed.otra]:
/// nunca hace creer que falta la conexión.
final class ConectividadDelTelefono implements Conectividad {
  ConectividadDelTelefono([Connectivity? plugin])
    : _plugin = plugin ?? Connectivity();

  final Connectivity _plugin;

  @override
  Future<TipoRed> actual() async {
    try {
      return tipoRedDe(await _plugin.checkConnectivity());
    } on Object catch (e) {
      SolLog.warning(
        'No se pudo leer la interfaz de red',
        codigo: e.runtimeType.toString(),
      );
      return TipoRed.otra;
    }
  }

  @override
  Stream<TipoRed> get cambios => _plugin.onConnectivityChanged
      .map(tipoRedDe)
      .handleError((Object _) {}, test: (_) => true);
}

/// Con varias interfaces a la vez gana el Wi-Fi (Android enruta por ahí);
/// después los datos del plan.
TipoRed tipoRedDe(List<ConnectivityResult> interfaces) {
  if (interfaces.contains(ConnectivityResult.wifi)) return TipoRed.wifi;
  if (interfaces.contains(ConnectivityResult.mobile)) return TipoRed.movil;
  if (interfaces.isEmpty ||
      interfaces.every((i) => i == ConnectivityResult.none)) {
    return TipoRed.ninguna;
  }
  return TipoRed.otra;
}

/// Para pruebas y `API_ENV=mock`: la interfaz se cambia a mano.
final class ConectividadFalsa implements Conectividad {
  ConectividadFalsa([this._tipo = TipoRed.wifi]);

  TipoRed _tipo;
  final _cambios = StreamController<TipoRed>.broadcast();

  /// Simula que el teléfono cambió de interfaz.
  void cambiar(TipoRed tipo) {
    _tipo = tipo;
    _cambios.add(tipo);
  }

  @override
  Future<TipoRed> actual() async => _tipo;

  @override
  Stream<TipoRed> get cambios => _cambios.stream;

  Future<void> cerrar() => _cambios.close();
}
