import 'dart:async';

import '../log/sol_log.dart';
import '../network/network_exceptions.dart';
import 'llavero_sesion.dart';
import 'sesion_remota.dart';
import 'sesion_store.dart';

/// Avisos del gestor para la presentación (el onboarding los escucha).
sealed class EventoSesion {
  const EventoSesion();
}

/// El refresh ya no sirve (vencido, revocado o la llave se invalidó): se
/// borró todo y hay que volver a pedir correo y clave con `fallaSesionVencida`.
final class SesionVencidaEvento extends EventoSesion {
  const SesionVencidaEvento();
}

/// Resultado de [GestorSesion.renovar].
enum ResultadoRenovar {
  /// Hay un JWT nuevo en memoria y el refresh rotado quedó guardado.
  renovada,

  /// `SESION_VENCIDA`: se borró la sesión y se emitió [SesionVencidaEvento].
  vencida,

  /// Sin red o servicio caído aun tras reintentar: **no** se borra nada.
  sinRed,

  /// No hay refresh en memoria (sesión bloqueada o cerrada).
  sinSesion,
}

/// Resultado de [GestorSesion.desbloquear].
sealed class Desbloqueo {
  const Desbloqueo();
}

/// Sesión abierta: hay JWT y refresh en memoria.
final class Desbloqueada extends Desbloqueo {
  const Desbloqueada();
}

/// La llave privada no se abrió: falta una autenticación válida (p. ej. un
/// rostro «débil»). La presentación pide el PIN del teléfono y reintenta.
final class FaltaAutenticacion extends Desbloqueo {
  const FaltaAutenticacion();
}

/// Sin red al renovar: se conserva el refresh guardado; «Reintentar».
final class DesbloqueoSinRed extends Desbloqueo {
  const DesbloqueoSinRed();
}

/// Ya no hay sesión que recuperar (vencida o revocada).
final class DesbloqueoVencido extends Desbloqueo {
  const DesbloqueoVencido();
}

/// Android invalidó la llave: huella o rostro nuevos, o sin bloqueo de
/// pantalla (D4). Lo guardado ya se borró; se pide correo y clave.
final class DesbloqueoLlaveInvalidada extends Desbloqueo {
  const DesbloqueoLlaveInvalidada();
}

/// Qué encontró [GestorSesion.consultarGuardado] al abrir la app.
enum RefreshGuardado {
  /// No hay sesión guardada: G-03 (crear cuenta o iniciar sesión).
  ninguno,

  /// Hay un refresh que no vence: M02-01.
  vigente,

  /// Había uno pero ya venció (se borró): login con `fallaSesionVencida`.
  vencido,
}

/// Dueño de la sesión de la app (HU-M02; docs/integracion-backend.md §7).
///
/// - El JWT de acceso y el refresh en claro viven **solo en memoria**.
/// - El refresh se persiste cifrado ([SesionStore]) apenas llega («guardar
///   primero»), para que un cierre de la app no deje guardado uno ya rotado.
/// - [renovar] corre una sola vez a la vez (candado): dos 401 simultáneos no
///   disparan dos renovaciones, que el backend tomaría por reuso.
/// - Ante una falla de red reintenta **una** vez con el mismo refresh: el
///   backend lo acepta dentro de su período de gracia (30 s).
final class GestorSesion {
  GestorSesion({
    required this._store,
    required this._remota,
    DateTime Function()? reloj,
  }) : _reloj = reloj ?? DateTime.now;

  final SesionStore _store;
  final SesionRemota _remota;
  final DateTime Function() _reloj;
  final _eventos = StreamController<EventoSesion>.broadcast();

  String? _token;
  DateTime? _expiraEn;
  String? _refresh;
  DateTime? _refreshVenceEn;
  bool _refreshPersistido = false;
  Future<ResultadoRenovar>? _renovando;

  /// Avisos para la presentación.
  Stream<EventoSesion> get eventos => _eventos.stream;

  /// JWT de acceso para `Authorization: Bearer` (o `null`).
  String? get token => _token;

  /// Vencimiento del JWT en memoria.
  DateTime? get expiraEn => _expiraEn;

  /// `true` si hay JWT y refresh en memoria.
  bool get abierta => _token != null && _refresh != null;

  /// `false` si el refresh de la sesión abierta no se pudo guardar (teléfono
  /// sin bloqueo de pantalla): al cerrar la app habrá que iniciar sesión.
  bool get refreshPersistido => _refreshPersistido;

  /// Abre la sesión con lo que devolvió el login, el registro o la creación de
  /// la cuenta. Guarda el refresh antes de volver.
  Future<void> abrir({
    required String token,
    required DateTime expiraEn,
    String? refresh,
    DateTime? refreshVenceEn,
  }) async {
    _token = token;
    _expiraEn = expiraEn;
    if (refresh != null) {
      _refresh = refresh;
      _refreshVenceEn = refreshVenceEn;
      await _persistir(refresh, refreshVenceEn);
    }
  }

  /// `actualizarSesion` (tras VERIFICADA) cambia solo el JWT; el refresh sigue.
  void actualizarToken(String token, DateTime expiraEn) {
    _token = token;
    _expiraEn = expiraEn;
  }

  /// Reintenta guardar el refresh en memoria (p. ej. tras activar el bloqueo
  /// de pantalla desde M01-08). Devuelve si quedó guardado.
  Future<bool> asegurarPersistencia() async {
    final refresh = _refresh;
    if (refresh == null) return false;
    if (!_refreshPersistido) await _persistir(refresh, _refreshVenceEn);
    return _refreshPersistido;
  }

  /// `true` si hay un refresh guardado que todavía no vence: al abrir la app
  /// se muestra M02-01 en vez de pedir correo y clave.
  Future<bool> hayRefreshVigente() async =>
      await consultarGuardado() == RefreshGuardado.vigente;

  /// Arranque (HU-M02, F6): mira el refresh guardado sin descifrarlo (no
  /// pide huella). Si venció, lo borra.
  Future<RefreshGuardado> consultarGuardado() async {
    if (!await _store.hayRefresh()) return RefreshGuardado.ninguno;
    final vence = await _store.refreshVenceEn();
    if (vence != null && !vence.isAfter(_reloj())) {
      await _limpiar();
      return RefreshGuardado.vencido;
    }
    return RefreshGuardado.vigente;
  }

  /// Tras autenticar con biometría o el PIN del teléfono (M02-01): descifra el
  /// refresh guardado dentro de la ventana de 10 s y renueva la sesión.
  Future<Desbloqueo> desbloquear() async {
    final String refresh;
    try {
      refresh = await _store.leerRefresh();
    } on RequiereAutenticacion {
      return const FaltaAutenticacion();
    } on SinRefreshGuardado {
      await _limpiar();
      return const DesbloqueoVencido();
    } on LlaveInvalidada {
      SolLog.info('Llave de la sesión invalidada: se pide iniciar sesión');
      await _limpiar();
      return const DesbloqueoLlaveInvalidada();
    } on ErrorLlavero catch (e) {
      SolLog.warning('No se pudo leer la sesión guardada (${e.runtimeType})');
      return const FaltaAutenticacion();
    }
    _refresh = refresh;
    _refreshPersistido = true;
    return _desbloqueoDe(await renovar());
  }

  /// «Reintentar» de M02-01 tras [DesbloqueoSinRed]: el refresh ya está en
  /// memoria, así que se renueva sin volver a pedir la huella. Si no lo está
  /// (p. ej. la app se bloqueó entretanto), [FaltaAutenticacion].
  Future<Desbloqueo> reintentarRenovacion() async {
    if (_refresh == null) return const FaltaAutenticacion();
    return _desbloqueoDe(await renovar());
  }

  static Desbloqueo _desbloqueoDe(ResultadoRenovar r) => switch (r) {
    ResultadoRenovar.renovada => const Desbloqueada(),
    ResultadoRenovar.sinRed => const DesbloqueoSinRed(),
    ResultadoRenovar.vencida ||
    ResultadoRenovar.sinSesion => const DesbloqueoVencido(),
  };

  /// Cambia el refresh en memoria por un par nuevo. Una sola a la vez: las
  /// llamadas concurrentes esperan el mismo resultado.
  Future<ResultadoRenovar> renovar() {
    final enCurso = _renovando;
    if (enCurso != null) return enCurso;
    final nueva = _renovar().whenComplete(() => _renovando = null);
    _renovando = nueva;
    return nueva;
  }

  Future<ResultadoRenovar> _renovar() async {
    final refresh = _refresh;
    if (refresh == null) return ResultadoRenovar.sinSesion;

    Renovacion respuesta;
    try {
      respuesta = await _remota.renovar(refresh);
    } on ErrorCliente catch (e) {
      if (!_esDeRed(e)) return _vencer();
      // La respuesta pudo perderse con el refresh ya rotado: un reintento con
      // el mismo refresh entra en la gracia del backend.
      try {
        respuesta = await _remota.renovar(refresh);
      } on ErrorCliente catch (e2) {
        if (!_esDeRed(e2)) return _vencer();
        SolLog.info('Renovación sin red: se conserva la sesión');
        return ResultadoRenovar.sinRed;
      }
    }

    switch (respuesta) {
      case RenovacionExitosa(
        :final token,
        :final expiraEn,
        refresh: final nuevo,
        :final refreshVenceEn,
      ):
        // Guardar primero: el refresh anterior ya no sirve.
        _refresh = nuevo;
        _refreshVenceEn = refreshVenceEn;
        await _persistir(nuevo, refreshVenceEn);
        _token = token;
        _expiraEn = expiraEn;
        return ResultadoRenovar.renovada;
      case RenovacionRechazada():
        return _vencer();
    }
  }

  /// Cierra la sesión (G-04): revoca en el backend si hay refresh en memoria
  /// y borra todo aunque la red falle.
  Future<void> cerrar() async {
    final refresh = _refresh;
    if (refresh != null) {
      try {
        await _remota.cerrar(refresh);
      } on Object catch (e) {
        SolLog.info('cerrarSesion no llegó al backend (${e.runtimeType})');
      }
    }
    await _limpiar();
  }

  /// Bloquea la sesión sin cerrarla (15 min en segundo plano, HU-M02): olvida
  /// el JWT y el refresh en claro; el refresh cifrado sigue guardado.
  void bloquear() {
    _token = null;
    _expiraEn = null;
    _refresh = null;
    _refreshVenceEn = null;
  }

  Future<void> dispose() => _eventos.close();

  Future<void> _persistir(String refresh, DateTime? venceEn) async {
    try {
      await _store.guardarRefresh(refresh, venceEn);
      _refreshPersistido = true;
    } on SinBloqueoPantalla {
      _refreshPersistido = false;
      SolLog.info('Sin bloqueo de pantalla: la sesión no se guarda');
    } on ErrorLlavero catch (e) {
      _refreshPersistido = false;
      SolLog.warning('No se pudo guardar la sesión (${e.runtimeType})');
    }
  }

  Future<ResultadoRenovar> _vencer() async {
    await _limpiar();
    if (!_eventos.isClosed) _eventos.add(const SesionVencidaEvento());
    return ResultadoRenovar.vencida;
  }

  Future<void> _limpiar() async {
    bloquear();
    SolLog.olvidarSesion();
    _refreshPersistido = false;
    try {
      await _store.borrar();
    } on Object catch (e) {
      SolLog.warning('No se pudo borrar la sesión guardada (${e.runtimeType})');
    }
  }

  static bool _esDeRed(ErrorCliente e) => switch (e) {
    ErrorRed() || ErrorTiempoRespuesta() => true,
    ErrorHttp(status: 502 || 503 || 504) => true,
    _ => false,
  };
}
