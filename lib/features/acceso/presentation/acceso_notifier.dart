import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/biometria/biometria_providers.dart';
import '../../../core/biometria/biometria_service.dart';
import '../../../core/log/sol_log.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/sesion/gestor_sesion.dart';
import '../../onboarding/presentation/onboarding_notifier.dart';
import 'acceso_routes.dart';

/// En qué punto del ingreso está la app (HU-M02).
enum FaseAcceso {
  /// Arrancando: se mira si hay un refresh guardado. `/` muestra un fondo
  /// vacío, sin parpadeo de G-03 a M02-01.
  comprobando,

  /// Sin sesión guardada, o con la sesión ya abierta: rutas normales.
  normal,

  /// Hay sesión guardada y falta desbloquearla: solo M02-01.
  bloqueada,

  /// Recién desbloqueada: M02-03 y luego el Home.
  concedida,
}

/// Aviso de M02-01, distinto de «no reconocida» (que es M02-01a).
enum AvisoAcceso {
  /// Sin red al renovar: el refresh sigue guardado. «Reintentar».
  sinRed,

  /// Demasiados intentos: esperar o usar el PIN del teléfono.
  bloqueoTemporal,

  /// La biometría quedó bloqueada hasta usar el PIN del teléfono.
  bloqueoPermanente,

  /// El diálogo aceptó, pero la llave pidió una autenticación más fuerte
  /// (p. ej. un rostro «débil»): usar el PIN del teléfono.
  faltaAutenticacion,

  /// El teléfono ya no tiene bloqueo de pantalla: Ajustes o correo y clave.
  sinBloqueoPantalla,

  /// Sin hardware o sin servicio de biometría: Ajustes o correo y clave.
  noDisponible,
}

final class AccesoState {
  const AccesoState({
    this.fase = FaseAcceso.comprobando,
    this.autenticando = false,
    this.noReconocida = false,
    this.aviso,
  });

  final FaseAcceso fase;

  /// Diálogo del sistema abierto o renovación en curso: botones inactivos.
  final bool autenticando;

  /// M02-01a: la huella o el rostro no coincidieron.
  final bool noReconocida;
  final AvisoAcceso? aviso;

  AccesoState copyWith({
    FaseAcceso? fase,
    bool? autenticando,
    bool? noReconocida,
    AvisoAcceso? aviso,
    bool limpiarAviso = false,
  }) => AccesoState(
    fase: fase ?? this.fase,
    autenticando: autenticando ?? this.autenticando,
    noReconocida: noReconocida ?? this.noReconocida,
    aviso: limpiarAviso ? null : aviso ?? this.aviso,
  );
}

/// Título, subtítulo y botón de cancelar del diálogo del sistema, ya traducidos (catálogo de idiomas). Sin ellos
/// Android los escribe en inglés.
typedef TextosDialogo = ({String? titulo, String? subtitulo, String? cancelar});

const _sinTextosDialogo = (titulo: null, subtitulo: null, cancelar: null);

/// Reloj del bloqueo por segundo plano (las pruebas lo sustituyen).
final relojAccesoProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Cuánto muestra M02-03 «Acceso concedido» antes de ir al Home.
final duracionAccesoConcedidoProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 1500),
);

/// Ingreso con biometría (HU-M02): arranque con sesión guardada (F6),
/// desbloqueo con huella, rostro o PIN del teléfono (D1, D2) y bloqueo tras
/// 15 minutos en segundo plano.
class AccesoNotifier extends Notifier<AccesoState> {
  /// Tiempo en segundo plano tras el que se vuelve a pedir la huella.
  static const bloqueoTrasSegundoPlano = Duration(minutes: 15);

  DateTime? _enSegundoPlanDesde;

  @override
  AccesoState build() {
    final gestor = ref.watch(gestorSesionProvider);
    final eventos = gestor.eventos.listen((evento) {
      // El onboarding ya muestra «Inicia sesión» con el aviso; aquí solo se
      // sale de M02 si se estaba en ella.
      if (evento is SesionVencidaEvento && state.fase != FaseAcceso.normal) {
        state = const AccesoState(fase: FaseAcceso.normal);
      }
    });
    ref.onDispose(eventos.cancel);
    unawaited(Future.microtask(_arrancar));
    return const AccesoState();
  }

  OnboardingNotifier get _onboarding => ref.read(onboardingProvider.notifier);

  Future<void> _arrancar() async {
    RefreshGuardado guardado;
    try {
      guardado = await ref.read(gestorSesionProvider).consultarGuardado();
    } on Object catch (e) {
      SolLog.warning('No se pudo leer la sesión guardada (${e.runtimeType})');
      guardado = RefreshGuardado.ninguno;
    }
    if (!ref.mounted || state.fase != FaseAcceso.comprobando) return;
    switch (guardado) {
      case RefreshGuardado.vigente:
        state = const AccesoState(fase: FaseAcceso.bloqueada);
      case RefreshGuardado.vencido:
        _onboarding.marcarSesionVencida();
        state = const AccesoState(fase: FaseAcceso.normal);
      case RefreshGuardado.ninguno:
        state = const AccesoState(fase: FaseAcceso.normal);
    }
  }

  /// M02-01: abre el diálogo del sistema. Con [conPin] (o si el teléfono
  /// solo tiene PIN) el diálogo acepta el PIN, patrón o contraseña del
  /// teléfono; si no, solo biometría.
  Future<void> desbloquear({
    required String motivo,
    TextosDialogo dialogo = _sinTextosDialogo,
    bool conPin = false,
  }) async {
    if (state.fase != FaseAcceso.bloqueada || state.autenticando) return;
    state = state.copyWith(
      autenticando: true,
      noReconocida: false,
      limpiarAviso: true,
    );
    final servicio = ref.read(biometriaServiceProvider);
    final estado = await servicio.estado();
    if (!ref.mounted) return;
    switch (estado) {
      case EstadoBiometria.sinBloqueoPantalla:
        _terminar(aviso: AvisoAcceso.sinBloqueoPantalla);
        return;
      case EstadoBiometria.noDisponible:
        _terminar(aviso: AvisoAcceso.noDisponible);
        return;
      case EstadoBiometria.biometriaRegistrada:
      case EstadoBiometria.soloCredencial:
        break;
    }
    final pin = conPin || estado == EstadoBiometria.soloCredencial;
    final resultado = await servicio.autenticar(
      motivo: motivo,
      permitirCredencialDispositivo: pin,
      titulo: dialogo.titulo,
      subtitulo: dialogo.subtitulo,
      cancelar: dialogo.cancelar,
    );
    if (!ref.mounted) return;
    switch (resultado) {
      case Autenticado():
        await _abrirSesion(motivo: motivo, dialogo: dialogo, conPin: pin);
      case NoReconocido():
        _terminar(noReconocida: true);
      case Cancelado():
        _terminar();
      case BloqueoTemporal():
        _terminar(aviso: AvisoAcceso.bloqueoTemporal);
      // Sin biometría usable: el PIN del teléfono también desbloquea (D1).
      case BloqueoPermanente():
        if (pin) {
          _terminar(aviso: AvisoAcceso.bloqueoPermanente);
        } else {
          await _reintentarConPin(motivo, dialogo);
        }
      case SinBiometriaRegistrada():
        if (pin) {
          _terminar(aviso: AvisoAcceso.noDisponible);
        } else {
          await _reintentarConPin(motivo, dialogo);
        }
      case SinBloqueoPantalla():
        _terminar(aviso: AvisoAcceso.sinBloqueoPantalla);
      case NoDisponible():
        _terminar(aviso: AvisoAcceso.noDisponible);
    }
  }

  Future<void> _reintentarConPin(String motivo, TextosDialogo dialogo) async {
    state = state.copyWith(autenticando: false);
    await desbloquear(motivo: motivo, dialogo: dialogo, conPin: true);
  }

  /// Con el diálogo aceptado, descifra el refresh dentro de la ventana de
  /// 10 s de la llave y renueva la sesión.
  Future<void> _abrirSesion({
    required String motivo,
    required TextosDialogo dialogo,
    required bool conPin,
  }) async {
    final gestor = ref.read(gestorSesionProvider);
    var desbloqueo = await gestor.desbloquear();
    if (!ref.mounted) return;
    if (desbloqueo is FaltaAutenticacion && !conPin) {
      // La biometría «débil» pasa el diálogo pero no abre la llave: se pide
      // el PIN del teléfono una vez.
      final otra = await ref
          .read(biometriaServiceProvider)
          .autenticar(
            motivo: motivo,
            permitirCredencialDispositivo: true,
            titulo: dialogo.titulo,
            subtitulo: dialogo.subtitulo,
            cancelar: dialogo.cancelar,
          );
      if (!ref.mounted) return;
      if (otra is! Autenticado) {
        _terminar(aviso: AvisoAcceso.faltaAutenticacion);
        return;
      }
      desbloqueo = await gestor.desbloquear();
      if (!ref.mounted) return;
    }
    _aplicar(desbloqueo);
  }

  void _aplicar(Desbloqueo desbloqueo) {
    switch (desbloqueo) {
      case Desbloqueada():
        state = const AccesoState(fase: FaseAcceso.concedida);
        unawaited(_onboarding.reanudarSesion());
      case FaltaAutenticacion():
        _terminar(aviso: AvisoAcceso.faltaAutenticacion);
      case DesbloqueoSinRed():
        _terminar(aviso: AvisoAcceso.sinRed);
      case DesbloqueoVencido():
        _onboarding.marcarSesionVencida();
        state = const AccesoState(fase: FaseAcceso.normal);
      case DesbloqueoLlaveInvalidada():
        _onboarding.marcarSeguridadTelefonoCambio();
        state = const AccesoState(fase: FaseAcceso.normal);
    }
  }

  void _terminar({AvisoAcceso? aviso, bool noReconocida = false}) {
    state = AccesoState(
      fase: state.fase,
      aviso: aviso,
      noReconocida: noReconocida,
    );
  }

  /// «Reintentar» del aviso sin red: renueva con el refresh que ya está en
  /// memoria; si ya no está, vuelve a pedir la huella.
  Future<void> reintentar({
    required String motivo,
    TextosDialogo dialogo = _sinTextosDialogo,
  }) async {
    if (state.fase != FaseAcceso.bloqueada || state.autenticando) return;
    if (state.aviso != AvisoAcceso.sinRed) {
      return desbloquear(motivo: motivo, dialogo: dialogo);
    }
    state = state.copyWith(autenticando: true, limpiarAviso: true);
    final desbloqueo = await ref
        .read(gestorSesionProvider)
        .reintentarRenovacion();
    if (!ref.mounted) return;
    if (desbloqueo is FaltaAutenticacion) {
      state = state.copyWith(autenticando: false);
      return desbloquear(motivo: motivo, dialogo: dialogo);
    }
    _aplicar(desbloqueo);
  }

  /// Al volver de Ajustes: si el aviso era de bloqueo o hardware, se limpia
  /// para que la persona vuelva a intentarlo.
  void alVolverDeAjustes() {
    final aviso = state.aviso;
    if (aviso == AvisoAcceso.sinBloqueoPantalla ||
        aviso == AvisoAcceso.noDisponible) {
      state = state.copyWith(limpiarAviso: true);
    }
  }

  /// Salida de M02-01 cuando el teléfono no puede autenticar: borra la
  /// sesión guardada y lleva a «Inicia sesión».
  Future<void> usarCorreo() async {
    await _onboarding.cerrarSesion();
    if (!ref.mounted) return;
    state = const AccesoState(fase: FaseAcceso.normal);
  }

  /// Disparador de demo de M02-01 (solo debug): muestra M02-01a.
  void simularNoReconocida() {
    if (state.fase != FaseAcceso.bloqueada) return;
    state = const AccesoState(fase: FaseAcceso.bloqueada, noReconocida: true);
  }

  /// M02-03 terminó: al Home.
  void terminarConcesion() {
    if (state.fase == FaseAcceso.concedida) {
      state = const AccesoState(fase: FaseAcceso.normal);
    }
  }

  /// La app pasó a segundo plano (`AppLifecycleState.hidden`).
  void alPasarASegundoPlano() {
    _enSegundoPlanDesde ??= ref.read(relojAccesoProvider)();
  }

  /// La app volvió. Tras [bloqueoTrasSegundoPlano] con la sesión abierta y
  /// guardada, la bloquea: olvida el JWT y el refresh en claro y pide la
  /// huella otra vez. Si el refresh no se pudo guardar (teléfono sin bloqueo
  /// de pantalla) no se bloquea: no habría con qué desbloquear.
  void alVolverAPrimerPlano() {
    final desde = _enSegundoPlanDesde;
    _enSegundoPlanDesde = null;
    if (desde == null) return;
    if (state.fase == FaseAcceso.comprobando ||
        state.fase == FaseAcceso.bloqueada) {
      return;
    }
    final gestor = ref.read(gestorSesionProvider);
    if (!gestor.abierta || !gestor.refreshPersistido) return;
    final ahora = ref.read(relojAccesoProvider)();
    if (ahora.difference(desde) < bloqueoTrasSegundoPlano) return;
    SolLog.info('Sesión bloqueada tras 15 min en segundo plano');
    gestor.bloquear();
    state = const AccesoState(fase: FaseAcceso.bloqueada);
  }
}

final accesoProvider = NotifierProvider<AccesoNotifier, AccesoState>(
  AccesoNotifier.new,
);

/// Redirección del router según la fase de acceso (sin estado: se prueba
/// sola). `null` deja pasar.
String? redirigirAcceso(FaseAcceso fase, String ubicacion) {
  return switch (fase) {
    FaseAcceso.comprobando => ubicacion == '/' ? null : '/',
    FaseAcceso.bloqueada =>
      ubicacion == AccesoRoutes.desbloqueo ? null : AccesoRoutes.desbloqueo,
    FaseAcceso.concedida =>
      ubicacion == AccesoRoutes.concedido ? null : AccesoRoutes.concedido,
    FaseAcceso.normal =>
      ubicacion == AccesoRoutes.desbloqueo ||
              ubicacion == AccesoRoutes.concedido
          ? '/'
          : null,
  };
}
