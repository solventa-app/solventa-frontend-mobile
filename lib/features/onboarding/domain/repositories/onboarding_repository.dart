import '../../../../core/errors/resultado.dart';
import '../entities/onboarding.dart';

/// Recorrido de onboarding y cuenta de la app contra el BFF (contrato v0.21).
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

  /// Envía un código OTP de 6 dígitos al correo (inicia recorrido si no existe).
  Future<Resultado<CodigoOnboarding>> enviarCodigo({required String correo});

  /// Verifica el código OTP de 6 dígitos enviado al correo.
  Future<Resultado<CodigoOnboarding>> verificarCodigo({
    required String correo,
    required String codigo,
  });

  /// M01-05b / inicio: crea la cuenta y guarda su sesión.
  Future<Resultado<Onboarding>> crearCuenta({
    required String correo,
    required String clave,
  });

  /// Registra una cuenta con OTP validado (sin requerir token de onboarding).
  Future<Resultado<PerfilUsuario>> registrarCuenta({
    required String correo,
    required String clave,
    required String codigo,
  });

  /// Inicia sesión con usuario/correo y clave en el canal app.
  Future<Resultado<PerfilUsuario>> iniciarSesion({
    required String usuario,
    required String clave,
  });

  /// Devuelve el perfil del usuario autenticado (`yo`).
  Future<Resultado<PerfilUsuario?>> consultarPerfil();

  /// Actualiza el idioma y moneda preferidos del usuario.
  Future<Resultado<PerfilUsuario>> actualizarPreferencias({
    required String idioma,
    required String moneda,
  });

  /// El estado guardado del recorrido (con el token o, si venció, con la sesión).
  Future<Resultado<Onboarding>> consultar();

  /// Tras VERIFICADA: cambia el token `verificacion-pendiente` por uno completo.
  Future<Resultado<void>> actualizarSesion();

  /// M01-07c «Intentar de nuevo»: vuelve a INICIADO y pide las cuatro piezas.
  Future<Resultado<Onboarding>> reintentar();

  /// Descarta el recorrido guardado (id y token): el siguiente consentimiento
  /// crea uno nuevo. Para «Empezar de nuevo» cuando el token venció (T16).
  void descartarRecorrido();

  /// Cierra la sesión actual borrando el token y el recorrido en memoria.
  Future<void> cerrarSesion();
}
