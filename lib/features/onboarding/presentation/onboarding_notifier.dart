import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../domain/entities/consentimiento.dart';
import '../domain/entities/verificacion_identidad.dart';
import 'providers.dart';

/// Estado del flujo de onboarding (M01-01 a M01-08). Vive en memoria y se
/// pierde al cerrar la app: las capturas nunca se guardan.
final class OnboardingState {
  const OnboardingState({
    this.consentimientoMarcado = false,
    this.registrandoConsentimiento = false,
    this.consentimiento,
    this.frenteCapturado = false,
    this.reversoCapturado = false,
    this.verificacion,
    this.falla,
  });

  final bool consentimientoMarcado;
  final bool registrandoConsentimiento;
  final Consentimiento? consentimiento;
  final bool frenteCapturado;
  final bool reversoCapturado;
  final EstadoVerificacion? verificacion;

  /// Última falla para mostrar con su texto del ARB; se limpia al reintentar.
  final Falla? falla;

  OnboardingState copyWith({
    bool? consentimientoMarcado,
    bool? registrandoConsentimiento,
    Consentimiento? consentimiento,
    bool? frenteCapturado,
    bool? reversoCapturado,
    EstadoVerificacion? verificacion,
    Falla? falla,
    bool limpiarFalla = false,
    bool limpiarVerificacion = false,
  }) => OnboardingState(
    consentimientoMarcado: consentimientoMarcado ?? this.consentimientoMarcado,
    registrandoConsentimiento:
        registrandoConsentimiento ?? this.registrandoConsentimiento,
    consentimiento: consentimiento ?? this.consentimiento,
    frenteCapturado: frenteCapturado ?? this.frenteCapturado,
    reversoCapturado: reversoCapturado ?? this.reversoCapturado,
    verificacion: limpiarVerificacion
        ? null
        : verificacion ?? this.verificacion,
    falla: limpiarFalla ? null : falla ?? this.falla,
  );
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  /// Texto legal vigente de M01-02 (se registra con el consentimiento).
  static const finalidad = 'verificacion-identidad';
  static const versionTexto = 'v1';

  @override
  OnboardingState build() => const OnboardingState();

  void marcarConsentimiento(bool valor) =>
      state = state.copyWith(consentimientoMarcado: valor, limpiarFalla: true);

  /// Registra el consentimiento en el BFF. `true` si quedó vigente.
  Future<bool> registrarConsentimiento() async {
    if (!state.consentimientoMarcado || state.registrandoConsentimiento) {
      return false;
    }
    state = state.copyWith(registrandoConsentimiento: true, limpiarFalla: true);
    final r = await ref
        .read(consentimientoRepositoryProvider)
        .registrar(
          const SolicitudConsentimiento(
            finalidad: finalidad,
            versionTexto: versionTexto,
          ),
        );
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(
          registrandoConsentimiento: false,
          consentimiento: valor,
        );
        return valor.vigente;
      case Fracaso(:final falla):
        state = state.copyWith(registrandoConsentimiento: false, falla: falla);
        return false;
    }
  }

  void capturarFrente() => state = state.copyWith(frenteCapturado: true);
  void capturarReverso() => state = state.copyWith(reversoCapturado: true);

  /// Repetir descarta la captura del lado indicado.
  void repetirFrente() => state = OnboardingState(
    consentimientoMarcado: state.consentimientoMarcado,
    consentimiento: state.consentimiento,
  );
  void repetirReverso() => state = OnboardingState(
    consentimientoMarcado: state.consentimientoMarcado,
    consentimiento: state.consentimiento,
    frenteCapturado: state.frenteCapturado,
  );

  /// Disparadores de demo de M01-05 (solo debug).
  void simular(EstadoVerificacion escenario) =>
      ref.read(fakeVerificacionProvider).escenario = escenario;

  Future<void> verificar() async {
    state = state.copyWith(limpiarVerificacion: true, limpiarFalla: true);
    final r = await ref.read(verificacionRepositoryProvider).verificar();
    state = switch (r) {
      Exito(:final valor) => state.copyWith(verificacion: valor),
      Fracaso(:final falla) => state.copyWith(falla: falla),
    };
  }

  /// M01-07c «Reintentar»: vuelve a capturar el documento.
  void reintentarCaptura() {
    ref.read(fakeVerificacionProvider).escenario =
        EstadoVerificacion.verificada;
    repetirFrente();
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
