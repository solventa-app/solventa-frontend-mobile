import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/network_providers.dart';
import 'conectividad.dart';
import 'estado_red.dart';
import 'senales_red.dart';
import 'sonda_red.dart';

/// Interfaz de red del teléfono. Con `API_ENV=mock`, una falsa con Wi-Fi.
final conectividadProvider = Provider<Conectividad>((ref) {
  if (ref.watch(usarFakesProvider)) {
    final falsa = ConectividadFalsa();
    ref.onDispose(() => unawaited(falsa.cerrar()));
    return falsa;
  }
  return ConectividadDelTelefono();
});

/// Prueba de salida real a internet. Con `API_ENV=mock` siempre responde.
final sondaRedProvider = Provider<SondaRed>((ref) {
  if (ref.watch(usarFakesProvider)) return SondaFalsa();
  final sonda = SondaGateway(baseUrl: ref.watch(apiBaseUrlProvider));
  ref.onDispose(sonda.cerrar);
  return sonda;
});

/// Estado de la red de toda la app: interfaz, calidad y si hay salida real.
final estadoRedProvider = NotifierProvider<EstadoRedNotifier, EstadoRed>(
  EstadoRedNotifier.new,
);

/// Decide el estado de la red con tres fuentes:
///
/// 1. La interfaz del teléfono (`connectivity_plus`), que avisa al instante.
/// 2. Una prueba al gateway (`/health`), que dice si de verdad hay salida y
///    cuánto tarda. Solo se repite mientras alguna pantalla la necesita
///    ([vigilar]) y la app está al frente.
/// 3. Las peticiones reales de la app ([SenalesRed]).
///
/// Una sola prueba fallida no declara «sin conexión»: primero baja a «mala»
/// y se confirma a los dos segundos, para no asustar por un corte breve.
final class EstadoRedNotifier extends Notifier<EstadoRed> {
  late Conectividad _conectividad;
  late SondaRed _sonda;

  StreamSubscription<TipoRed>? _cambios;
  Timer? _periodica;
  Timer? _confirmacion;

  TipoRed _tipo = TipoRed.otra;
  int _vigilantes = 0;
  bool _alFrente = true;
  bool _ultimaFallo = false;
  CalidadRed? _simulada;

  /// Cambia cada vez que cambia la interfaz: el resultado de una prueba que
  /// empezó en otra interfaz ya no vale.
  int _generacion = 0;
  int _generacionEnCurso = -1;
  Future<void>? _enCurso;

  @override
  EstadoRed build() {
    _conectividad = ref.watch(conectividadProvider);
    _sonda = ref.watch(sondaRedProvider);
    ref.watch(senalesRedProvider)
      ..alFallarConexion = _peticionSinConexion
      ..alAgotarTiempo = _peticionLenta
      ..alResponder = _peticionRespondida;

    _cambios = _conectividad.cambios.listen(_interfazCambio);
    ref.onDispose(() {
      unawaited(_cambios?.cancel());
      _periodica?.cancel();
      _confirmacion?.cancel();
      _generacion++;
    });

    _tipo = TipoRed.otra;
    _ultimaFallo = false;
    _programarPeriodica();
    unawaited(_leerInterfaz());
    return _simulada == null ? EstadoRed.inicial : _estadoSimulado(_simulada!);
  }

  /// Una pantalla que muestra el estado de la red lo pide mientras está
  /// montada. Devuelve cómo soltarlo. Sin nadie mirando no se gasta batería
  /// ni datos en pruebas periódicas.
  void Function() vigilar() {
    _vigilantes++;
    if (_vigilantes == 1) {
      _programarPeriodica();
      unawaited(comprobar());
    }
    var suelto = false;
    return () {
      if (suelto) return;
      suelto = true;
      _vigilantes--;
      if (_vigilantes == 0) {
        _periodica?.cancel();
        _periodica = null;
        _confirmacion?.cancel();
        _confirmacion = null;
      }
    };
  }

  /// Prueba ahora mismo. Varias llamadas a la vez comparten una sola prueba.
  Future<void> comprobar() {
    final enCurso = _enCurso;
    if (enCurso != null && _generacionEnCurso == _generacion) return enCurso;
    final generacion = _generacion;
    _generacionEnCurso = generacion;
    late final Future<void> prueba;
    prueba = _probar(generacion).whenComplete(() {
      if (identical(_enCurso, prueba)) _enCurso = null;
    });
    return _enCurso = prueba;
  }

  /// La app pasó a segundo plano: se detienen las pruebas.
  void alOcultarse() {
    _alFrente = false;
    _periodica?.cancel();
    _periodica = null;
    _confirmacion?.cancel();
    _confirmacion = null;
  }

  /// La app volvió al frente: la red pudo cambiar mientras tanto.
  Future<void> alVolverAlFrente() async {
    _alFrente = true;
    _programarPeriodica();
    await _leerInterfaz();
  }

  /// Solo demo (`API_ENV=mock`): fuerza una calidad sin tocar el teléfono.
  /// `null` vuelve al estado real.
  void simular(CalidadRed? calidad) {
    _simulada = calidad;
    _confirmacion?.cancel();
    if (calidad != null) {
      state = _estadoSimulado(calidad);
      return;
    }
    _ultimaFallo = false;
    _generacion++;
    state = EstadoRed(
      tipo: _tipo,
      calidad: _tipo == TipoRed.ninguna
          ? CalidadRed.sinConexion
          : CalidadRed.buena,
    );
    unawaited(comprobar());
  }

  static EstadoRed _estadoSimulado(CalidadRed calidad) => EstadoRed(
    tipo: switch (calidad) {
      CalidadRed.sinConexion => TipoRed.ninguna,
      CalidadRed.mala => TipoRed.movil,
      CalidadRed.buena || CalidadRed.regular => TipoRed.wifi,
    },
    calidad: calidad,
    simulado: true,
  );

  /// De la duración de la prueba a la calidad (decisión del plan, 4.2).
  static CalidadRed calidadDe(Duration duracion) {
    if (duracion < UmbralesRed.buena) return CalidadRed.buena;
    if (duracion <= UmbralesRed.mala) return CalidadRed.regular;
    return CalidadRed.mala;
  }

  Future<void> _leerInterfaz() async {
    final generacion = _generacion;
    final tipo = await _conectividad.actual();
    if (!ref.mounted || generacion != _generacion) return;
    if (tipo != _tipo) {
      _interfazCambio(tipo);
    } else {
      await comprobar();
    }
  }

  void _interfazCambio(TipoRed tipo) {
    if (!ref.mounted || tipo == _tipo) return;
    _tipo = tipo;
    _generacion++;
    _ultimaFallo = false;
    _confirmacion?.cancel();
    _confirmacion = null;
    if (_simulada != null) return;
    if (tipo == TipoRed.ninguna) {
      state = const EstadoRed(
        tipo: TipoRed.ninguna,
        calidad: CalidadRed.sinConexion,
      );
      return;
    }
    // Hasta que la prueba conteste se conserva lo que se sabía: si no había
    // conexión, tener Wi-Fi todavía no es tener internet.
    state = EstadoRed(tipo: tipo, calidad: state.calidad);
    unawaited(comprobar());
  }

  Future<void> _probar(int generacion) async {
    if (_simulada != null || _tipo == TipoRed.ninguna) return;
    final resultado = await _sonda.probar();
    if (!ref.mounted || generacion != _generacion || _simulada != null) return;
    switch (resultado) {
      case SondaConRespuesta(:final duracion):
        _ultimaFallo = false;
        state = EstadoRed(tipo: _tipo, calidad: calidadDe(duracion));
      case SondaSinRespuesta():
        final confirmada = _ultimaFallo || !state.conectado;
        _ultimaFallo = true;
        state = EstadoRed(
          tipo: _tipo,
          calidad: confirmada ? CalidadRed.sinConexion : CalidadRed.mala,
        );
        if (!confirmada) _programarConfirmacion();
    }
  }

  void _peticionSinConexion() {
    if (!ref.mounted || _simulada != null) return;
    _ultimaFallo = true;
    if (state.conectado) {
      state = EstadoRed(tipo: _tipo, calidad: CalidadRed.sinConexion);
    }
  }

  void _peticionLenta() {
    if (!ref.mounted || _simulada != null || !state.conectado) return;
    if (state.calidad != CalidadRed.mala) {
      state = EstadoRed(tipo: _tipo, calidad: CalidadRed.mala);
    }
    _programarConfirmacion();
  }

  void _peticionRespondida() {
    if (!ref.mounted || _simulada != null || state.conectado) return;
    if (_tipo == TipoRed.ninguna) return;
    _ultimaFallo = false;
    // Contestó el servidor: hay salida. La prueba dirá qué tan buena.
    state = EstadoRed(tipo: _tipo, calidad: CalidadRed.regular);
    unawaited(comprobar());
  }

  void _programarPeriodica() {
    _periodica?.cancel();
    _periodica = null;
    if (_vigilantes == 0 || !_alFrente) return;
    _periodica = Timer.periodic(
      UmbralesRed.periodo,
      (_) => unawaited(comprobar()),
    );
  }

  void _programarConfirmacion() {
    _confirmacion?.cancel();
    _confirmacion = null;
    if (_vigilantes == 0 || !_alFrente) return;
    _confirmacion = Timer(
      UmbralesRed.confirmacion,
      () => unawaited(comprobar()),
    );
  }
}
