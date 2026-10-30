import '../../../../core/errors/resultado.dart';
import '../entities/onboarding.dart';

/// Recorrido de onboarding contra el BFF (contrato v0.20).
///
/// El repositorio guarda en memoria el id del recorrido y su token
/// (`X-Onboarding-Token`, 30 min): no salen de aquí ni se persisten. Los
/// errores de negocio llegan como `FallaNegocio` con el `codigo` del contrato.
abstract interface class OnboardingRepository {
  /// M01-02: crea el recorrido (si no hay uno) y registra el consentimiento
  /// `onboarding-biometrico` antes de cualquier captura.
  Future<Resultado<Onboarding>> iniciarConConsentimiento({
    required String versionTexto,
  });

  /// Pide la URL firmada, hace el PUT directo y confirma la pieza.
  Future<Resultado<Onboarding>> subir(PasoOnboarding paso, Captura captura);

  /// Con las cuatro piezas: responde EN_VERIFICACION y el resultado llega después.
  Future<Resultado<Onboarding>> enviarVerificacion();

  /// M01-05b: crea la cuenta y guarda su sesión.
  Future<Resultado<Onboarding>> crearCuenta({
    required String correo,
    required String clave,
  });

  /// El estado guardado del recorrido (con el token o, si venció, con la sesión).
  Future<Resultado<Onboarding>> consultar();

  /// Tras VERIFICADA: cambia el token `verificacion-pendiente` por uno completo.
  Future<Resultado<void>> actualizarSesion();

  /// M01-07c «Intentar de nuevo»: vuelve a INICIADO y pide las cuatro piezas.
  Future<Resultado<Onboarding>> reintentar();
}
