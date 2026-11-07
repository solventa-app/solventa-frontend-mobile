import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';

/// Almacén en memoria con fallas programables del llavero.
final class StoreProgramable implements SesionStore {
  final _memoria = MemoriaSesionStore();

  /// Cada lectura toma y lanza el siguiente error, si hay.
  final erroresAlLeer = <Object>[];

  /// Simula un teléfono sin bloqueo de pantalla al guardar.
  bool sinBloqueo = false;

  @override
  Future<bool> hayRefresh() => _memoria.hayRefresh();

  @override
  Future<DateTime?> refreshVenceEn() => _memoria.refreshVenceEn();

  @override
  Future<void> guardarRefresh(String refresh, DateTime? venceEn) {
    if (sinBloqueo) throw const SinBloqueoPantalla();
    return _memoria.guardarRefresh(refresh, venceEn);
  }

  @override
  Future<String> leerRefresh() {
    if (erroresAlLeer.isNotEmpty) throw erroresAlLeer.removeAt(0);
    return _memoria.leerRefresh();
  }

  @override
  Future<void> borrar() => _memoria.borrar();
}

/// Onboarding que solo cuenta lo que M02 le pide.
class OnboardingEspia extends OnboardingNotifier {
  int reanudadas = 0;
  int vencidas = 0;
  int cierres = 0;

  @override
  OnboardingState build() => const OnboardingState();

  @override
  Future<void> reanudarSesion() async {
    reanudadas++;
    state = state.copyWith(cuentaCreada: true);
  }

  @override
  void marcarSesionVencida() {
    vencidas++;
    state = const OnboardingState(sesionCerrada: true);
  }

  @override
  Future<void> cerrarSesion() async {
    cierres++;
    await ref.read(gestorSesionProvider).cerrar();
    state = const OnboardingState(sesionCerrada: true);
  }

  @override
  Future<void> cargarPerfilYEstado() async {}
}
