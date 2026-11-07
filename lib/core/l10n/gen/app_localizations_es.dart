// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get localeChip => 'ES · COP';

  @override
  String get m0101Titulo => 'Bienvenida a Solventa';

  @override
  String get m0101Intro =>
      'Antes de activar tu cuenta, vamos a verificar tu identidad en 3 pasos rápidos:';

  @override
  String get m0101Paso1 => 'Autorización de tratamiento de datos';

  @override
  String get m0101Paso2 =>
      'Captura de tu documento de identidad (frente y reverso)';

  @override
  String get m0101Paso3 => 'Prueba de vida (selfie)';

  @override
  String m0101PasoSemantica(int numero, String texto) {
    return 'Paso $numero de 3: $texto';
  }

  @override
  String get m0101Empezar => 'Empezar';

  @override
  String get m0102Titulo => 'Autorización de datos';

  @override
  String get m0102Legal =>
      'Para verificar tu identidad necesitamos tu autorización para tratar tus datos personales conforme a la Ley 1581 de 2012 (Habeas Data).';

  @override
  String get m0102Consentimiento =>
      'Autorizo el tratamiento de mis datos personales';

  @override
  String get continuar => 'Continuar';

  @override
  String get m0103Titulo => 'Captura del documento';

  @override
  String get m0103Tipo => 'Cédula de ciudadanía';

  @override
  String get m0103Instruccion =>
      'Ubica el FRENTE del documento dentro del marco';

  @override
  String get m0103Consejo =>
      'Evita reflejos de luz directa y sombras pronunciadas';

  @override
  String get repetir => 'Repetir';

  @override
  String get capturar => 'Capturar';

  @override
  String get m0104Paso => 'Paso 2 de 2: Reverso';

  @override
  String get m0104LadoPosterior => 'Lado posterior';

  @override
  String get m0104Instruccion =>
      'Ubica el REVERSO del documento dentro del marco';

  @override
  String get m0104Consejo =>
      'Evita reflejos de luz directa y sombras pronunciadas sobre el código de barras y la huella.';

  @override
  String get m0104Calidad => 'Enfoque y luz adecuados';

  @override
  String get m0105Titulo => 'Prueba de vida';

  @override
  String get m0105Instruccion =>
      'Gira tu rostro lentamente dentro del marco (cámara frontal)';

  @override
  String get verificacionTitulo => 'Verificación';

  @override
  String get m0106Validando => 'Validando con el proveedor KYC/AML...';

  @override
  String get m0107aMensaje => '¡Identidad verificada! Bienvenido a Solventa.';

  @override
  String get m0107aAccion => 'Ir a mi cuenta';

  @override
  String get m0107bMensaje => 'Estamos revisando tu identidad, te avisamos.';

  @override
  String get m0107bAccion => 'Entendido';

  @override
  String get m0107cMensaje =>
      'No pudimos verificar tu documento (imagen ilegible)';

  @override
  String get reintentar => 'Reintentar';

  @override
  String get m0108Titulo => 'Activación';

  @override
  String get m0108Encabezado => 'Necesitamos activar tu huella o rostro';

  @override
  String get m0108Explicacion =>
      'Solventa protege tu cuenta con la seguridad de tu propio teléfono: para continuar, tu celular debe tener huella dactilar o reconocimiento facial activado. Es lo mismo que usas para desbloquear el teléfono — Solventa nunca ve ni guarda ese dato.';

  @override
  String get m0108Sello => 'Validación biométrica encriptada localmente';

  @override
  String get m0108Ajustes => 'Ir a configuración del teléfono';

  @override
  String get m0108Continuar => 'Ya lo activé, continuar';

  @override
  String get m0108Requisito =>
      'Sin huella o rostro activado en el equipo, la app no puede usarse — es un requisito, no una opción.';

  @override
  String get fallaSinConexion =>
      'No tienes conexión. Revisa tu internet e intenta de nuevo.';

  @override
  String get fallaServicio =>
      'El servicio tardó más de lo esperado. Intenta nuevamente.';

  @override
  String get fallaGenerica => 'Algo salió mal. Intenta nuevamente.';

  @override
  String get localeChipSemantica =>
      'Idioma español, moneda pesos colombianos. Toca para cambiar a inglés.';

  @override
  String get m0105bTitulo => 'Crea tu cuenta';

  @override
  String get m0105bIntro =>
      'Mientras verificamos tu identidad, crea la cuenta con la que vas a entrar a Solventa.';

  @override
  String get m0105bCorreo => 'Correo electrónico';

  @override
  String get m0105bContrasena => 'Clave';

  @override
  String get m0105bConfirmar => 'Confirma la clave';

  @override
  String get m0105bRequisitoCumplido => 'cumplido';

  @override
  String get m0105bRequisitoPendiente => 'pendiente';

  @override
  String get m0105bAyudaContrasena => 'Entre 8 y 128 caracteres.';

  @override
  String get m0105bErrorCorreo => 'Escribe un correo válido.';

  @override
  String get m0105bErrorContrasena =>
      'La clave debe cumplir todos los requisitos.';

  @override
  String get m0105bErrorContrasenaLogin => 'Ingresa tu clave.';

  @override
  String get m0105bErrorConfirmar => 'Las claves no coinciden.';

  @override
  String get m0105bCorreoRegistrado =>
      'Ya hay una cuenta con este correo. Inicia sesión.';

  @override
  String get m0105bCrear => 'Crear cuenta';

  @override
  String get m0106Demora =>
      'Está tardando más de lo normal. Puedes actualizar o volver más tarde: la verificación sigue.';

  @override
  String get actualizar => 'Actualizar';

  @override
  String get irAlInicio => 'Ir al inicio';

  @override
  String get m0107cRostro =>
      'El rostro del video no coincide con el del documento.';

  @override
  String get m0107cSuplantacion =>
      'No pudimos confirmar que la prueba de vida la hiciste tú, en vivo.';

  @override
  String get m0107cMenor =>
      'Debes ser mayor de edad para tener una cuenta en Solventa.';

  @override
  String get m0107cDocumentoRegistrado =>
      'Este documento ya tiene una cuenta en Solventa.';

  @override
  String get m0107cSinIntentos =>
      'Ya no quedan intentos. Escríbenos a soporte para revisar tu caso.';

  @override
  String get fallaRegistroVencido => 'Tu registro venció. Empieza de nuevo.';

  @override
  String get fallaEmpezarDeNuevo => 'Empezar de nuevo';

  @override
  String get fallaAlmacenamiento =>
      'El servicio de almacenamiento de documentos no está disponible en este momento. Intenta de nuevo.';

  @override
  String get fallaObjetoNoSubido =>
      'No pudimos recibir tu archivo completo. Revisa tu conexión y toca Reintentar envío.';

  @override
  String get fallaTamanoNoAdmitido =>
      'El archivo supera el peso máximo permitido (5 MB foto de documento, 2 MB selfie, 15 MB video).';

  @override
  String get fallaTipoNoAdmitido =>
      'El formato del archivo no es compatible (usa JPEG para fotos y MP4 para video).';

  @override
  String get fallaPiezasIncompletas =>
      'Falta confirmar alguna de las capturas. Toca Reintentar envío para completar la subida.';

  @override
  String get fallaSinConsentimiento =>
      'Debes aceptar la autorización de tratamiento de datos personales para continuar.';

  @override
  String get fallaProveedorNoDisponible =>
      'El proveedor de verificación de identidad está tardando en responder. Reintenta en unos segundos.';

  @override
  String get fallaCodigoInvalido =>
      'El código ingresado no es correcto. Revísalo e intenta de nuevo.';

  @override
  String get fallaCodigoVencido =>
      'El código venció. Solicita uno nuevo para continuar.';

  @override
  String get fallaIntentosAgotados =>
      'Agotaste los intentos de este código o verificación. Solicita uno nuevo.';

  @override
  String get fallaCredencialesInvalidas =>
      'El correo o la clave no son correctos. Revísalos e intenta de nuevo.';

  @override
  String get fallaSesionVencida =>
      'Tu sesión venció. Inicia sesión nuevamente.';

  @override
  String get fallaSinPermiso =>
      'No tienes permiso para realizar esta operación.';

  @override
  String get cuentaModoCrear => 'Crear cuenta';

  @override
  String get cuentaModoIngresar => 'Iniciar sesión';

  @override
  String get cuentaTituloIngresar => 'Inicia sesión';

  @override
  String get cuentaIntroCrear =>
      'Ingresa tu correo electrónico y crea tu clave para empezar en Solventa. Te enviaremos un código de 6 dígitos para confirmar tu correo.';

  @override
  String get cuentaIntroIngresar =>
      'Ingresa con el correo y la clave de tu cuenta en Solventa.';

  @override
  String get cuentaBotonIngresar => 'Ingresar';

  @override
  String get cuentaCambiarAIngresar => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get cuentaCambiarACrear => '¿No tienes cuenta? Crear cuenta';

  @override
  String get otpTitulo => 'Verifica tu correo';

  @override
  String otpInstruccion(String correo) {
    return 'Ingresa el código de 6 dígitos que enviamos a $correo.';
  }

  @override
  String get otpVence => 'El código vence en 10 minutos.';

  @override
  String otpIntentosRestantes(int intentos) {
    return 'Intentos restantes: $intentos';
  }

  @override
  String get otpVerificar => 'Verificar código';

  @override
  String get otpReenviar => 'Enviar otro código';

  @override
  String otpReenviarEn(String tiempo) {
    return 'Reenviar en $tiempo';
  }

  @override
  String get fallaEsperaRequerida =>
      'Espera un momento antes de pedir otro código.';

  @override
  String get m0105bReqLargo => 'Entre 8 y 128 caracteres';

  @override
  String get m0105bReqMayuscula => 'Una letra mayúscula';

  @override
  String get m0105bReqMinuscula => 'Una letra minúscula';

  @override
  String get m0105bReqEspecial =>
      'Un carácter especial (por ejemplo ! ¿ @ # €)';

  @override
  String get otpReenviado => 'Te enviamos un código nuevo a tu correo.';

  @override
  String get homeSaludoBienvenida => 'Bienvenido a Solventa';

  @override
  String homeSaludoHola(String nombre) {
    return 'Hola, $nombre';
  }

  @override
  String get homePendienteTexto =>
      'Completa tu registro para activar tu cuenta';

  @override
  String get homePendienteBoton => 'Completar registro';

  @override
  String get homeEnRevisionTitulo => 'Estamos revisando tu identidad';

  @override
  String get homeEnRevisionTexto =>
      'Validamos tus documentos y prueba de vida con nuestro proveedor KYC/AML. Te avisaremos apenas esté lista.';

  @override
  String get homeEnRevisionBoton => 'Consultar estado';

  @override
  String get homeRechazadaTitulo => 'No pudimos verificar tu identidad';

  @override
  String get homeRechazadaBoton => 'Reintentar verificación';

  @override
  String get homeVerificadaTitulo => 'Identidad verificada';

  @override
  String get homeVerificadaTexto =>
      'Tu cuenta está activa y protegida con validación biométrica.';

  @override
  String get homeVerificadaWeb =>
      'Tu verificación fue exitosa. Ya puedes entrar también a la web de Solventa con el mismo correo y clave.';

  @override
  String get homeSoloAppAviso =>
      'Mientras tu identidad no esté verificada solo puedes entrar a esta app. La web no te dejará entrar hasta que termines la verificación aquí.';

  @override
  String get homeAsistenciaTile => 'Solicitar asistencia en sitio';

  @override
  String get homeBilleteraNota => 'Billetera y estado de póliza — próximamente';

  @override
  String get navInicio => 'Inicio';

  @override
  String get navAsistencia => 'Asistencia';

  @override
  String get navPerfil => 'Mi perfil';

  @override
  String get navCerrarSesion => 'Cerrar sesión';

  @override
  String get preferenciasModalTitulo => 'Idioma y moneda';

  @override
  String get preferenciasModalSubtitulo =>
      'Selecciona el idioma de la aplicación y la moneda de visualización.';

  @override
  String get preferenciasIdiomaLabel => 'Idioma';

  @override
  String get preferenciasIdiomaEs => 'Español (ES)';

  @override
  String get preferenciasIdiomaEn => 'English (EN)';

  @override
  String get preferenciasMonedaLabel => 'Moneda';

  @override
  String get preferenciasListo => 'Listo';

  @override
  String get monedaNombreCOP => 'Peso colombiano (COP)';

  @override
  String get monedaNombreMXN => 'Peso mexicano (MXN)';

  @override
  String get monedaNombreBRL => 'Real brasileño (BRL)';

  @override
  String get monedaNombreCLP => 'Peso chileno (CLP)';

  @override
  String get monedaNombrePEN => 'Sol peruano (PEN)';

  @override
  String get monedaNombreUSD => 'Dólar estadounidense (USD)';

  @override
  String get monedaNombreEUR => 'Euro (EUR)';

  @override
  String get perfilTitulo => 'Mi perfil';

  @override
  String get perfilSubtitulo => 'Tu cuenta en Solventa';

  @override
  String get perfilSoloLectura => 'Solo lectura';

  @override
  String get perfilCargando => 'Cargando tu perfil…';

  @override
  String get perfilError => 'No pudimos cargar tu perfil en este momento.';

  @override
  String get perfilActiva => 'Cuenta activa';

  @override
  String get perfilPendiente => 'Verificación pendiente';

  @override
  String get perfilSuspendida => 'Cuenta suspendida';

  @override
  String get perfilDatos => 'Datos de la cuenta';

  @override
  String get perfilUsuario => 'Correo';

  @override
  String get perfilNombre => 'Nombre';

  @override
  String get perfilNombrePendiente => 'Pendiente de verificación de documento';

  @override
  String get perfilRol => 'Rol';

  @override
  String get perfilRolCliente => 'Cliente';

  @override
  String get perfilDocumento => 'Documento';

  @override
  String get perfilRegistro => 'Fecha de registro';

  @override
  String get perfilPreferencias => 'Preferencias';

  @override
  String get perfilPreferenciasTexto =>
      'Idioma y moneda con los que se abre la app cada vez que inicias sesión.';

  @override
  String get perfilGuardarPreferencias => 'Guardar preferencias';

  @override
  String get perfilPreferenciasGuardadas => 'Preferencias guardadas.';

  @override
  String get perfilNotaLegal =>
      'Los datos de tu cuenta provienen de tu documento verificado y son de solo lectura. Tus datos personales se tratan conforme a la Ley 1581 de 2012 de Habeas Data.';

  @override
  String get cerrarSesionTitulo => '¿Quieres cerrar sesión?';

  @override
  String get cerrarSesionMensaje =>
      'Tendrás que ingresar de nuevo para usar Solventa.';

  @override
  String get cerrarSesionConfirmar => 'Sí, cerrar sesión';

  @override
  String get cerrarSesionCancelar => 'No, seguir aquí';

  @override
  String get camaraEnVivoListo => 'Cámara activa en el visor';

  @override
  String get camaraReintentarEnvio => 'Reintentar envío';

  @override
  String get m0108DemoActivar =>
      'Simular huella/rostro activado en el emulador';

  @override
  String soporteCodigoTexto(String codigo) {
    return 'Si escribes a soporte, comparte este código: $codigo';
  }

  @override
  String get soporteCopiarCodigo => 'Copiar código de soporte';

  @override
  String get soporteCodigoCopiado => 'Código copiado al portapapeles.';

  @override
  String get camaraPermisoTitulo => 'Necesitamos acceso a tu cámara';

  @override
  String get camaraPermisoTexto =>
      'La usamos solo para tomar las fotos de tu documento y la prueba de vida. No guardamos nada en tu teléfono.';

  @override
  String get camaraPermitir => 'Permitir cámara';

  @override
  String get camaraPermisoBloqueado =>
      'Bloqueaste el acceso a la cámara. Actívalo en Ajustes → Permisos → Cámara y vuelve aquí.';

  @override
  String get camaraAbrirAjustes => 'Abrir ajustes';

  @override
  String get camaraNoDisponible =>
      'No encontramos una cámara disponible en este dispositivo.';

  @override
  String get fallaCamaraNoDisponible =>
      'No pudimos usar la cámara. Revisa el permiso de cámara e inténtalo de nuevo.';

  @override
  String get biometriaMotivo => 'Confirma que eres tú para entrar a Solventa';

  @override
  String get m0108SoloPin =>
      'Tu teléfono no tiene huella ni rostro registrados. Puedes continuar con el PIN del teléfono, aunque te recomendamos registrar tu huella.';

  @override
  String get m0108SinBloqueo =>
      'Tu teléfono no tiene bloqueo de pantalla. Activa un PIN, patrón o huella en los ajustes para proteger tu cuenta.';

  @override
  String get m0108NoDisponible =>
      'No pudimos consultar la seguridad de tu teléfono. Intenta de nuevo.';

  @override
  String get m0108NoReconocido => 'No te reconocimos. Intenta de nuevo.';

  @override
  String get m0108BloqueoTemporal =>
      'Hiciste demasiados intentos. Espera unos segundos o usa el PIN del teléfono.';

  @override
  String get m0201Titulo => 'Desbloquea tu cuenta';

  @override
  String get m0201Sensor => 'Huella o rostro';

  @override
  String get m0201Escanear => 'Desbloquear con huella o rostro';

  @override
  String get m0201Motivo => 'Desbloquea tu cuenta de Solventa';

  @override
  String get m0201UsarPin => 'Usar PIN del teléfono';

  @override
  String get m0201SimularNoReconoce => 'Simular que no reconoce la biometría';

  @override
  String get m0201Reintentar => 'Reintentar';

  @override
  String get m0201SinRed =>
      'No hay conexión. Tu sesión sigue guardada en este teléfono: reintenta cuando vuelva la señal.';

  @override
  String get m0201BloqueoTemporal =>
      'Hiciste demasiados intentos. Espera unos segundos o usa el PIN del teléfono.';

  @override
  String get m0201BloqueoPermanente =>
      'Tu teléfono bloqueó la biometría. Desbloquéala con el PIN, patrón o contraseña del teléfono.';

  @override
  String get m0201FaltaAutenticacion =>
      'Tu teléfono no confirmó tu identidad con la seguridad necesaria. Usa el PIN del teléfono.';

  @override
  String get m0201SinBloqueo =>
      'Tu teléfono ya no tiene bloqueo de pantalla. Actívalo en Ajustes o ingresa con tu correo y clave.';

  @override
  String get m0201NoDisponible =>
      'Tu teléfono no puede verificar tu identidad ahora. Revisa Ajustes o ingresa con tu correo y clave.';

  @override
  String get m0201IrAjustes => 'Ir a ajustes';

  @override
  String get m0201UsarCorreo => 'Ingresar con correo y clave';

  @override
  String get m0201aTitulo => 'No te reconocimos';

  @override
  String get m0201aMensaje =>
      'No pudimos verificar tu huella o rostro. Intenta de nuevo o ingresa con el PIN de tu teléfono.';

  @override
  String get m0203Titulo => 'Acceso concedido';

  @override
  String get m0203SaludoSinNombre => 'Hola de nuevo.';

  @override
  String get m0203Progreso => 'Entrando a tu cuenta';

  @override
  String m0203Saludo(String nombre) {
    return 'Hola de nuevo, $nombre.';
  }

  @override
  String get m0601Titulo => 'Prestadores cercanos';

  @override
  String m0601Disponibles(int cantidad) {
    return '$cantidad disponibles';
  }

  @override
  String get m0601Solicitar => 'Solicitar';

  @override
  String get m0601TipoMedico => 'Médico';

  @override
  String get m0601TipoMecanico => 'Mecánico';

  @override
  String get m0601Buscando => 'Buscando prestadores cerca de ti…';

  @override
  String get m0601SinPrestadores =>
      'No hay prestadores disponibles cerca de ti en este momento.';

  @override
  String get m0601SinPermiso =>
      'Necesitamos tu ubicación para mostrarte los prestadores más cercanos.';

  @override
  String get m0601GpsApagado =>
      'Tu ubicación está desactivada. Actívala para ver los prestadores cercanos.';

  @override
  String get m0601PermitirUbicacion => 'Permitir ubicación';

  @override
  String get m0601AbrirAjustes => 'Abrir ajustes';

  @override
  String get m0601Reintentar => 'Reintentar';

  @override
  String get m0601TuUbicacion => 'Tu ubicación';

  @override
  String m0601ComoLlegar(String nombre, String tiempo) {
    return 'Cómo llegar a $nombre, $tiempo';
  }

  @override
  String get m0601RutaNoDisponible =>
      'No encontramos una app de mapas para abrir la ruta.';

  @override
  String get m0601Atribucion => '© colaboradores de OpenStreetMap';
}
