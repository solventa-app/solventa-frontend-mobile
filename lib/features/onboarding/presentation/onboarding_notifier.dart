import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../data/fixtures/onboarding_fixtures.dart';
import '../domain/entities/onboarding.dart';
import '../domain/entities/verificacion_identidad.dart';
import 'providers.dart';

/// Estado del flujo de onboarding (M01-01 a M01-08). Vive en memoria y se
/// pierde al cerrar la app: las capturas nunca se guardan.
final class OnboardingState {
  const OnboardingState({
    this.consentimientoMarcado = false,
    this.registrandoConsentimiento = false,
    this.onboarding,
    this.frenteCapturado = false,
    this.reversoCapturado = false,
    this.ocupado = false,
    this.verificacion,
    this.consultasAgotadas = false,
    this.falla,
  });

  final bool consentimientoMarcado;
  final bool registrandoConsentimiento;

  /// El recorrido tal como lo devolvió el backend la última vez.
  final Onboarding? onboarding;
  final bool frenteCapturado;
  final bool reversoCapturado;

  /// Capturando, enviando o creando la cuenta: deshabilita el botón principal.
  final bool ocupado;
  final EstadoVerificacion? verificacion;

  /// M01-06 ya hizo sus consultas y el resultado no llegó: muestra «Actualizar».
  final bool consultasAgotadas;

  /// Última falla para mostrar con su texto del ARB; se limpia al reintentar.
  final Falla? falla;

  /// Intentos que quedan tras un rechazo (0: ya no se puede repetir).
  int get intentosRestantes => onboarding?.intentosRestantes ?? 0;

  OnboardingState copyWith({
    bool? consentimientoMarcado,
    bool? registrandoConsentimiento,
    Onboarding? onboarding,
    bool? frenteCapturado,
    bool? reversoCapturado,
    bool? ocupado,
    EstadoVerificacion? verificacion,
    bool? consultasAgotadas,
    Falla? falla,
    bool limpiarFalla = false,
    bool limpiarVerificacion = false,
  }) => OnboardingState(
    consentimientoMarcado: consentimientoMarcado ?? this.consentimientoMarcado,
    registrandoConsentimiento:
        registrandoConsentimiento ?? this.registrandoConsentimiento,
    onboarding: onboarding ?? this.onboarding,
    frenteCapturado: frenteCapturado ?? this.frenteCapturado,
    reversoCapturado: reversoCapturado ?? this.reversoCapturado,
    ocupado: ocupado ?? this.ocupado,
    verificacion: limpiarVerificacion
        ? null
        : verificacion ?? this.verificacion,
    consultasAgotadas: consultasAgotadas ?? this.consultasAgotadas,
    falla: limpiarFalla ? null : falla ?? this.falla,
  );
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  /// Versión del texto legal de M01-02 (se registra con el consentimiento
  /// `onboarding-biometrico`).
  static const versionTexto = 'v1';

  /// Subidas en curso: cada captura se sube apenas se toma, sin hacer esperar.
  final _subidas = <PasoOnboarding, Future<Resultado<Onboarding>>>{};

  @override
  OnboardingState build() => const OnboardingState();

  void marcarConsentimiento(bool valor) =>
      state = state.copyWith(consentimientoMarcado: valor, limpiarFalla: true);

  /// M01-02: inicia el recorrido y registra el consentimiento. `true` si quedó.
  Future<bool> registrarConsentimiento() async {
    if (!state.consentimientoMarcado || state.registrandoConsentimiento) {
      return false;
    }
    state = state.copyWith(registrandoConsentimiento: true, limpiarFalla: true);
    final r = await ref
        .read(onboardingRepositoryProvider)
        .iniciarConConsentimiento(versionTexto: versionTexto);
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(
          registrandoConsentimiento: false,
          onboarding: valor,
        );
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(registrandoConsentimiento: false, falla: falla);
        return false;
    }
  }

  /// Toma la foto y deja la subida corriendo. `false` si se canceló la cámara.
  Future<bool> _capturar(
    PasoOnboarding paso,
    Future<Captura?> Function() tomar,
  ) async {
    if (state.ocupado) return false;
    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final captura = await tomar();
    state = state.copyWith(ocupado: false);
    if (captura == null) return false;
    _subidas[paso] = ref
        .read(onboardingRepositoryProvider)
        .subir(paso, captura);
    return true;
  }

  Future<bool> capturarFrente() async {
    final ok = await _capturar(
      PasoOnboarding.anverso,
      ref.read(capturaServiceProvider).documento,
    );
    if (ok) state = state.copyWith(frenteCapturado: true);
    return ok;
  }

  Future<bool> capturarReverso() async {
    final ok = await _capturar(
      PasoOnboarding.reverso,
      ref.read(capturaServiceProvider).documento,
    );
    if (ok) state = state.copyWith(reversoCapturado: true);
    return ok;
  }

  /// Repetir descarta la captura del lado indicado.
  void repetirFrente() {
    _subidas.clear();
    state = OnboardingState(
      consentimientoMarcado: state.consentimientoMarcado,
      onboarding: state.onboarding,
    );
  }

  void repetirReverso() {
    _subidas.remove(PasoOnboarding.reverso);
    state = OnboardingState(
      consentimientoMarcado: state.consentimientoMarcado,
      onboarding: state.onboarding,
      frenteCapturado: state.frenteCapturado,
    );
  }

  /// M01-05: selfie y video, espera las cuatro subidas y envía la verificación.
  /// `true` si quedó EN_VERIFICACION; luego va M01-05b «Crea tu cuenta».
  Future<bool> completarPruebaDeVida() async {
    final captura = ref.read(capturaServiceProvider);
    if (!await _capturar(PasoOnboarding.rostro, captura.rostro)) return false;
    if (!await _capturar(PasoOnboarding.video, captura.video)) return false;
    state = state.copyWith(ocupado: true);
    for (final subida in _subidas.values) {
      if (await subida case Fracaso(:final falla)) {
        // Se vuelve a tomar todo: la URL firmada de la pieza ya no sirve.
        _subidas.clear();
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
      }
    }
    final r = await ref.read(onboardingRepositoryProvider).enviarVerificacion();
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(ocupado: false, onboarding: valor);
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
    }
  }

  /// M01-05b: crea la cuenta (la verificación ya corre). `true` si quedó.
  Future<bool> crearCuenta({
    required String correo,
    required String clave,
  }) async {
    if (state.ocupado) return false;
    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final r = await ref
        .read(onboardingRepositoryProvider)
        .crearCuenta(correo: correo, clave: clave);
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(ocupado: false, onboarding: valor);
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
    }
  }

  /// Disparadores de demo de M01-05 (solo debug, con el fake).
  void simular(EstadoVerificacion escenario) {
    ref.read(fakeOnboardingProvider).resultado = switch (escenario) {
      EstadoVerificacion.verificada => OnboardingFixtures.onboarding(
        estado: 'VERIFICADA',
      ),
      EstadoVerificacion.enRevision => OnboardingFixtures.onboarding(
        estado: 'EN_REVISION',
        motivo: 'PROVEEDOR_NO_DISPONIBLE',
      ),
      EstadoVerificacion.rechazada => OnboardingFixtures.onboarding(
        estado: 'RECHAZADA',
        motivo: 'ILEGIBLE',
      ),
    };
  }

  /// M01-06: consulta a los 3, 8 y 20 s y para. Si no llegó, `consultasAgotadas`.
  Future<void> verificar() async {
    state = state.copyWith(
      limpiarVerificacion: true,
      limpiarFalla: true,
      consultasAgotadas: false,
    );
    for (final espera in ref.read(esperasVerificacionProvider)) {
      await Future<void>.delayed(espera);
      if (!ref.mounted) return;
      if (await _consultar()) return;
    }
    state = state.copyWith(consultasAgotadas: true);
  }

  /// «Actualizar» en M01-06: una consulta más.
  Future<void> actualizar() async {
    state = state.copyWith(consultasAgotadas: false, limpiarFalla: true);
    if (!await _consultar()) state = state.copyWith(consultasAgotadas: true);
  }

  /// `true` si ya hay un resultado (o una falla que mostrar).
  Future<bool> _consultar() async {
    final repo = ref.read(onboardingRepositoryProvider);
    final r = await repo.consultar();
    switch (r) {
      case Fracaso(:final falla):
        state = state.copyWith(falla: falla);
        return true;
      case Exito(:final valor) when valor.pendiente:
        state = state.copyWith(onboarding: valor);
        return false;
      case Exito(:final valor):
        if (valor.estado == EstadoOnboarding.verificada) {
          // Sin esto el token sigue siendo `verificacion-pendiente`. Si falla,
          // la app lo vuelve a pedir al abrir; no bloquea el resultado.
          await repo.actualizarSesion();
        }
        state = state.copyWith(
          onboarding: valor,
          verificacion: switch (valor.estado) {
            EstadoOnboarding.verificada => EstadoVerificacion.verificada,
            EstadoOnboarding.rechazada => EstadoVerificacion.rechazada,
            _ => EstadoVerificacion.enRevision,
          },
        );
        return true;
    }
  }

  /// M01-07c «Intentar de nuevo»: el backend vuelve a INICIADO y pide las
  /// cuatro piezas otra vez. `true` si se puede volver a capturar.
  Future<bool> reintentarCaptura() async {
    final r = await ref.read(onboardingRepositoryProvider).reintentar();
    switch (r) {
      case Exito(:final valor):
        repetirFrente();
        state = state.copyWith(onboarding: valor);
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(falla: falla);
        return false;
    }
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
