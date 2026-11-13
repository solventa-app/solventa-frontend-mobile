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
      'Pon tu rostro dentro del círculo. Al tocar «Grabar video» grabaremos 3 segundos: mueve la cabeza despacio de un lado a otro.';

  @override
  String get verificacionTitulo => 'Verificación';

  @override
  String get m0106Validando => 'Validando con el proveedor KYC/AML...';

  @override
  String get m0107aMensaje => '¡Identidad verificada! Bienvenido a Solventa.';

  @override
  String get m0107aAccion => 'Activar huella o rostro';

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
  String m0108Encabezado(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Activa tu huella',
      'rostro': 'Activa tu rostro',
      'bloqueo': 'Activa el bloqueo del teléfono',
      'other': 'Activa la seguridad de tu teléfono',
    });
    return '$_temp0';
  }

  @override
  String m0108Explicacion(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Entra más rápido sin escribir tu contraseña. Te pediremos tu huella una sola vez.',
      'rostro': 'Entra más rápido sin escribir tu contraseña. Te pediremos tu rostro una sola vez.',
      'bloqueo': 'Entra más rápido sin escribir tu contraseña. Te pediremos el bloqueo de tu teléfono una sola vez.',
      'other': 'Entra más rápido sin escribir tu contraseña. Te pediremos la seguridad de tu teléfono una sola vez.',
    });
    return '$_temp0';
  }

  @override
  String get m0108Sello => 'Validación biométrica encriptada localmente';

  @override
  String get m0108Ajustes => 'Ir a configuración del teléfono';

  @override
  String get m0108Continuar => 'Ya lo activé, continuar';

  @override
  String m0108Activar(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Activar huella',
      'rostro': 'Activar rostro',
      'bloqueo': 'Activar bloqueo',
      'other': 'Activar seguridad',
    });
    return '$_temp0';
  }

  @override
  String get m0108AhoraNo => 'Ahora no, ir al inicio';

  @override
  String get m0108AvisoLuego =>
      'Puedes activar tu huella o rostro cuando quieras en Mi perfil.';

  @override
  String get m0108Requisito =>
      'Puedes activarla después en los ajustes del teléfono: Solventa la usará apenas esté lista. Mientras tanto entrarás con tu correo y clave.';

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
  String get fallaSeguridadTelefono =>
      'Cambió la huella, el rostro o el bloqueo de tu teléfono. Por tu seguridad, inicia sesión con tu correo y clave.';

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
  String get m0105bReqTitulo => 'Tu clave debe tener:';

  @override
  String get m0105bRequisitoIncumplido => 'falta';

  @override
  String get m0105bClavesCoinciden => 'Las claves coinciden.';

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
  String get perfilBiometria => 'Huella o rostro del teléfono';

  @override
  String get homeBiometriaPista =>
      'Activa tu huella o rostro para entrar más rápido.';

  @override
  String get homeBiometriaActivar => 'Activar';

  @override
  String get homeBiometriaCerrar => 'Cerrar aviso';

  @override
  String get perfilBiometriaActiva => 'Activada';

  @override
  String get perfilBiometriaInactiva => 'Sin activar · Toca para activar';

  @override
  String get perfilNotaLegal =>
      'Los datos de tu cuenta provienen de tu documento verificado y son de solo lectura. Tus datos personales se tratan conforme a la Ley 1581 de 2012 de Habeas Data.';

  @override
  String get perfilNotificacionesPush => 'Notificaciones push';

  @override
  String get perfilNotificacionesPushTexto =>
      'Avisa cuando se liquide una indemnización, entre otros.';

  @override
  String get perfilNotificacionesPushError =>
      'No se pudo guardar tu preferencia. Intenta de nuevo.';

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
  String get m0201IngresaHuella => 'Ingresa con tu huella';

  @override
  String get m0201IngresaRostro => 'Ingresa con tu rostro';

  @override
  String get m0201IngresaSeguridad => 'Ingresa con la seguridad de tu teléfono';

  @override
  String get m0201IngresaBloqueo => 'Ingresa con el bloqueo de tu teléfono';

  @override
  String get m0201Motivo => 'Desbloquea tu cuenta de Solventa';

  @override
  String get m0201DialogoTitulo => 'Desbloquea Solventa';

  @override
  String get m0201DialogoSubtitulo => 'Confirma que eres tú';

  @override
  String get m0201DialogoCancelar => 'Cancelar';

  @override
  String get m0201UsarBloqueo => 'Usar el bloqueo del teléfono';

  @override
  String get m0201SimularNoReconoce => 'Simular que no reconoce la biometría';

  @override
  String get m0201Reintentar => 'Reintentar';

  @override
  String get m0201SinRed =>
      'No hay conexión. Tu sesión sigue guardada en este teléfono: reintenta cuando vuelva la señal.';

  @override
  String get m0201BloqueoTemporal =>
      'Hiciste demasiados intentos. Espera unos segundos o usa el bloqueo de tu teléfono.';

  @override
  String get m0201BloqueoPermanente =>
      'Tu teléfono bloqueó la biometría. Desbloquéala con el PIN, patrón o contraseña del teléfono.';

  @override
  String get m0201FaltaAutenticacion =>
      'Tu teléfono no pudo abrir tu huella o rostro. Usa el bloqueo de tu teléfono.';

  @override
  String get m0201SinBloqueo =>
      'Tu teléfono ya no tiene bloqueo de pantalla. Actívalo en Ajustes o ingresa con tu correo y clave.';

  @override
  String get m0201NoDisponible =>
      'Tu teléfono no puede verificar tu identidad ahora. Revisa Ajustes o ingresa con tu correo y clave.';

  @override
  String get m0201IrAjustes => 'Ir a ajustes';

  @override
  String get m0201UsarCorreo => 'Usar correo y contraseña';

  @override
  String get m0201aTitulo => 'No te reconocimos';

  @override
  String get m0201aMensaje =>
      'No pudimos verificar tu huella o rostro. Intenta de nuevo o usa el bloqueo de tu teléfono.';

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
  String get m0601TipoGrua => 'Grúa';

  @override
  String get m0601Aliado => 'Aliado Solventa';

  @override
  String get m0601Buscando => 'Buscando prestadores cerca de ti…';

  @override
  String get m0601SinPrestadores => 'Aún no tenemos prestadores en tu zona.';

  @override
  String get m0601Reintentar => 'Reintentar';

  @override
  String get m0601TuUbicacion => 'Tu ubicación';

  @override
  String get m0601RutaNoDisponible =>
      'No encontramos una app de mapas para abrir la ruta.';

  @override
  String m0601PinSemantica(String nombre, String tipo, String tiempo) {
    return '$nombre, $tipo, $tiempo';
  }

  @override
  String get m0601VerSatelite => 'Ver satélite';

  @override
  String get m0601VerCalles => 'Ver calles';

  @override
  String get m0601Recentrar => 'Volver a centrar en mi ubicación';

  @override
  String get m0601ExpandirLista => 'Expandir lista';

  @override
  String get m0601ContraerLista => 'Contraer lista';

  @override
  String get m0601MasPrestadores => 'Más prestadores en tu ciudad';

  @override
  String m0601Aproximado(String tiempo) {
    return '~$tiempo';
  }

  @override
  String m0601DetalleTipo(String tipo, String especialidad) {
    return '$tipo · $especialidad';
  }

  @override
  String m0601DetalleLlegada(String distancia, String tiempo) {
    return '$distancia · llega en $tiempo';
  }

  @override
  String get m0601SolicitarAsistencia => 'Solicitar asistencia';

  @override
  String get m0601ComoLlegarBoton => 'Cómo llegar';

  @override
  String get m0601DireccionCopiada => 'Dirección copiada';

  @override
  String get m0601CopiarDireccion => 'Mantén pulsado para copiar la dirección';

  @override
  String get m0601Copiar => 'Copiar';

  @override
  String get m0601Cerrar => 'Cerrar';

  @override
  String get ubicacionExplicaTitulo => 'Necesitamos tu ubicación';

  @override
  String get ubicacionExplicaTexto =>
      'Para mostrarte los prestadores más cercanos y cuánto tardan en llegar.';

  @override
  String get ubicacionPermitir => 'Permitir ubicación';

  @override
  String get ubicacionNegadaTitulo => 'No tenemos tu ubicación';

  @override
  String get ubicacionNegadaTexto =>
      'Puedes darnos el permiso o escribir dónde estás. Con la dirección te mostramos los mismos prestadores.';

  @override
  String get ubicacionAbrirAjustes => 'Abrir Ajustes';

  @override
  String get gpsApagadoTitulo => 'Tu GPS está apagado';

  @override
  String get gpsApagadoTexto =>
      'Enciende la ubicación del teléfono para encontrar los prestadores cerca de ti.';

  @override
  String get gpsActivar => 'Activar ubicación';

  @override
  String get direccionEscribir => 'Escribir mi dirección';

  @override
  String get direccionTitulo => '¿Dónde estás?';

  @override
  String get direccionCampo => 'Dirección, ciudad o punto de referencia';

  @override
  String get direccionBuscar => 'Buscar esta dirección';

  @override
  String get direccionNoEncontrada =>
      'No pudimos ubicar esa dirección. Prueba con otra o con un punto de referencia';

  @override
  String get direccionServicioCaido =>
      'No pudimos buscar direcciones ahora. Intenta de nuevo';

  @override
  String direccionUsando(String direccion) {
    return 'Usando: $direccion';
  }

  @override
  String get direccionCambiar => 'Cambiar';

  @override
  String get direccionUsarActual => 'Usar mi ubicación actual';

  @override
  String get direccionPinEtiqueta => 'Dirección escrita';

  @override
  String get homeReportarTile => 'Reportar un siniestro';

  @override
  String get m05Titulo => 'Reportar siniestro';

  @override
  String get m05Continuar => 'Continuar';

  @override
  String get m05Reintentar => 'Reintentar';

  @override
  String get m0501Poliza => '¿Sobre qué póliza?';

  @override
  String m0501PolizaNumero(String numero) {
    return 'Póliza $numero';
  }

  @override
  String m0501Vigencia(String fecha) {
    return 'Vigente hasta el $fecha';
  }

  @override
  String get m0501Cargando => 'Buscando tus pólizas…';

  @override
  String get m0501SinPolizas =>
      'No tienes pólizas de auto emitidas sobre las que reportar.';

  @override
  String get m0501Fecha => '¿Cuándo pasó?';

  @override
  String get m0501FechaFuera =>
      'Esa fecha está fuera de la vigencia de la póliza.';

  @override
  String m0501FechaAntes(String desde) {
    return 'Tu póliza empezó a cubrirte el $desde. Elige una fecha y hora desde ese momento.';
  }

  @override
  String get m0501FechaElegir => 'Elige el día y la hora';

  @override
  String get m0501ElegirPoliza => 'Primero elige la póliza afectada.';

  @override
  String m0501CubreDesde(String desde) {
    return 'Tu póliza cubre desde el $desde.';
  }

  @override
  String get m0502Titulo => 'Fotos del daño';

  @override
  String get m0502Instruccion =>
      'Toma de 1 a 3 fotos del daño. Cada foto guarda dónde la tomaste.';

  @override
  String get m0502Tomar => 'Tomar foto';

  @override
  String m0502Contador(int cantidad) {
    return '$cantidad de 3 fotos';
  }

  @override
  String m0502Quitar(int numero) {
    return 'Quitar la foto $numero';
  }

  @override
  String get m0502Ubicada =>
      'Ubicación lista: tus fotos quedan geoetiquetadas.';

  @override
  String get m0502SinUbicacion =>
      'Necesitamos tu ubicación para ubicar el siniestro. Actívala para continuar.';

  @override
  String get m0502PermitirUbicacion => 'Permitir ubicación';

  @override
  String get m0502AbrirAjustes => 'Abrir ajustes';

  @override
  String get m0502CamaraNoDisponible =>
      'No pudimos usar la cámara. Revisa el permiso de cámara e inténtalo de nuevo.';

  @override
  String get m0502Visor => 'Visor de la cámara';

  @override
  String get m0503Titulo => '¿Qué pasó?';

  @override
  String get m0503Relato => 'Cuéntanos qué pasó';

  @override
  String get m0503RelatoAyuda => 'De 10 a 1000 caracteres.';

  @override
  String get m0503Lugar => '¿Dónde pasó?';

  @override
  String get m0503LugarAyuda => 'Dirección o punto de referencia.';

  @override
  String get m0503Ciudad => 'Ciudad';

  @override
  String get m0503Requerido => 'Completa este campo.';

  @override
  String get m0503Enviar => 'Enviar reporte';

  @override
  String get m0504Titulo => 'Enviando tu reporte';

  @override
  String get m0504Mensaje =>
      'Estamos subiendo tus fotos y registrando tu caso…';

  @override
  String get m0505Exito => 'Recibimos tu reporte';

  @override
  String m0505ExitoMensaje(String radicado, String fecha) {
    return 'Tu caso $radicado quedó pendiente de revisión. Te daremos una respuesta a más tardar el $fecha.';
  }

  @override
  String get m0505Error => 'No pudimos enviar tu reporte';

  @override
  String get m0505VolverInicio => 'Volver al inicio';

  @override
  String get m0505Revisar => 'Revisar el reporte';

  @override
  String get m0505FotoNoConfirmada =>
      'Una de las fotos no se subió bien. Tómala de nuevo.';

  @override
  String get homeMisSiniestrosTile => 'Mis siniestros';

  @override
  String get homeMiCoberturaTile => 'Mi cobertura';

  @override
  String get m0505VerMisSiniestros => 'Ver mis siniestros';

  @override
  String get m0506Titulo => 'Mis siniestros';

  @override
  String get m0506Cargando => 'Buscando tus reportes…';

  @override
  String get m0506Vacio => 'Aún no has reportado siniestros.';

  @override
  String m0506Reportado(String fecha, int fotos) {
    String _temp0 = intl.Intl.pluralLogic(
      fotos,
      locale: localeName,
      other: '$fotos fotos',
      one: '1 foto',
    );
    return 'Reportado el $fecha · $_temp0';
  }

  @override
  String get m0506Pendiente => 'Pendiente';

  @override
  String m0506PendienteDetalle(String fecha) {
    return 'Lo revisaremos a más tardar el $fecha.';
  }

  @override
  String get m0506EnRevision => 'En revisión';

  @override
  String get m0506EnRevisionDetalle => 'Un perito está evaluando tu caso.';

  @override
  String get m0506Aprobado => 'Aprobado';

  @override
  String get m0506AprobadoDetalle =>
      'Tu indemnización está en proceso de pago.';

  @override
  String get m0506Rechazado => 'Rechazado';

  @override
  String get m0506RechazadoDetalle =>
      'Te enviamos el motivo y cómo presentar un recurso.';

  @override
  String get m0602Titulo => 'Solicitar asistencia';

  @override
  String get m0602PrestadorAsignado => 'Prestador asignado';

  @override
  String get m0602Tipo => 'Tipo de asistencia';

  @override
  String get m0602TipoMedica => 'Médica';

  @override
  String get m0602TipoMecanica => 'Mecánica';

  @override
  String get m0602TipoGrua => 'Grúa';

  @override
  String get m0602TipoElegir => 'Elige una opción';

  @override
  String get m0602AtencionInmediata => 'Atención inmediata';

  @override
  String get m0602AtencionInmediataTexto =>
      'Estamos coordinando tu solicitud en tiempo real';

  @override
  String m0602UbicacionEscrita(String direccion) {
    return '$direccion (la dirección que escribiste)';
  }

  @override
  String get m0602TipoRequerido => 'Elige el tipo de asistencia.';

  @override
  String m0602TipoNoAtendido(String nombre) {
    return '$nombre no atiende este tipo de asistencia. Elige otro prestador en el mapa.';
  }

  @override
  String get m0602Descripcion => 'Describe brevemente qué pasó';

  @override
  String get m0602DescripcionHint => 'Ej. dolor en el pecho, mareo…';

  @override
  String m0602TextoLargo(int maximo) {
    return 'Usa máximo $maximo caracteres.';
  }

  @override
  String m0602UbicacionDetectada(String coordenadas) {
    return 'Ubicación detectada automáticamente: $coordenadas';
  }

  @override
  String m0602TiempoLlegada(String tiempo) {
    return 'Tiempo estimado de llegada: $tiempo';
  }

  @override
  String get m0602Enviar => 'Enviar solicitud';

  @override
  String m0603Mensaje(String nombre) {
    return 'Confirmando disponibilidad con $nombre…';
  }

  @override
  String m0603bMensaje(String nombre) {
    return 'Reenviando tu solicitud a $nombre…';
  }

  @override
  String get m0604aTitulo => 'Solicitud confirmada';

  @override
  String m0604aMensajeSinTiempo(String nombre) {
    return '$nombre está en camino a la dirección que indicaste.';
  }

  @override
  String m0604aMensaje(String nombre, int minutos) {
    return '$nombre está en camino. Llegada estimada en $minutos minutos.';
  }

  @override
  String get m0604aVerMapa => 'Ver en el mapa';

  @override
  String get m0604aCancelar => 'Cancelar asistencia';

  @override
  String get m0604aCancelarFallo =>
      'No pudimos cancelar la asistencia. Intenta de nuevo.';

  @override
  String get m0604bTitulo => 'No pudimos confirmar tu solicitud';

  @override
  String m0604bSinRespuesta(String nombre) {
    return '$nombre no respondió a tiempo. Puedes elegir otro prestador o intentar de nuevo.';
  }

  @override
  String m0604bNoDisponible(String nombre) {
    return '$nombre ya no está disponible. Elige otro prestador cercano.';
  }

  @override
  String get m0604bElegirOtro => 'Elegir otro prestador';

  @override
  String get m0604bReintentar => 'Reintentar';

  @override
  String get m0605Titulo => '¿Seguro que quieres cancelar?';

  @override
  String m0605Mensaje(String nombre) {
    return '$nombre ya está en camino. Si cancelas ahora, tendrás que solicitar asistencia de nuevo desde cero.';
  }

  @override
  String get m0605Confirmar => 'Sí, cancelar';

  @override
  String get m0605Mantener => 'No, mantener solicitud';

  @override
  String get m0606Titulo => 'Cancelar asistencia';

  @override
  String get m0606Mensaje =>
      'Tu solicitud fue cancelada. El servicio asignado quedó sin efecto y no se realizarán cobros asociados a esta solicitud.';

  @override
  String get m0606VolverInicio => 'Volver al inicio';

  @override
  String get m0606SolicitarDeNuevo => 'Solicitar de nuevo';

  @override
  String get navMisAsistencias => 'Mis asistencias';

  @override
  String navMisAsistenciasEnCamino(String cantidad) {
    return 'Mis asistencias, $cantidad en camino';
  }

  @override
  String get misAsistenciasTitulo => 'Mis asistencias';

  @override
  String get misAsistenciasVacio => 'Aún no has pedido asistencia';

  @override
  String get misAsistenciasSolicitar => 'Solicitar asistencia en sitio';

  @override
  String misAsistenciasEnCamino(String cantidad) {
    return 'En camino ($cantidad)';
  }

  @override
  String misAsistenciasYaLlegaron(String cantidad) {
    return 'Ya llegaron ($cantidad)';
  }

  @override
  String get misAsistenciasError => 'No pudimos cargar tus asistencias.';

  @override
  String get misAsistenciasCargando => 'Cargando tus asistencias…';

  @override
  String asistenciaPedida(String tipo, String hora) {
    return '$tipo · pedida $hora';
  }

  @override
  String asistenciaLlegaEn(String minutos) {
    return 'Llega en $minutos min';
  }

  @override
  String get asistenciaLlegaMenosDeUno => 'Llega en menos de 1 min';

  @override
  String asistenciaHoraEstimada(String hora) {
    return 'Hora estimada $hora';
  }

  @override
  String asistenciaLlego(String hora) {
    return 'Llegó · $hora';
  }

  @override
  String get asistenciaNoConfirmada => 'No pudimos confirmar';

  @override
  String get asistenciaReintentar => 'Reintentar';

  @override
  String asistenciaEnCaminoLlega(String minutos) {
    return 'En camino · llega en $minutos min';
  }

  @override
  String get asistenciaNotifTitulo => 'Tu asistencia llegó';

  @override
  String asistenciaNotifCuerpo(String prestador) {
    return '$prestador ya debería estar en tu ubicación';
  }

  @override
  String get asistenciaNotifNota => 'Te avisaremos cuando llegue el prestador.';

  @override
  String asistenciaLlegoSnack(String prestador) {
    return '$prestador llegó';
  }

  @override
  String get asistenciaVer => 'Ver';

  @override
  String get asistenciaDetalleTitulo => 'Tu asistencia';

  @override
  String asistenciaTeAlejaste(String direccion) {
    return 'Te alejaste del lugar donde pediste la asistencia. El prestador va a $direccion';
  }

  @override
  String get asistenciaLugarPedido => 'el lugar donde la pediste';

  @override
  String get asistenciaCancelarYPedirOtra => 'Cancelar y pedir otra';

  @override
  String asistenciaLectura(String prestador, String tipo, String estado) {
    return '$prestador, $tipo, $estado';
  }

  @override
  String get asistenciaNoEncontrada => 'No encontramos esa asistencia.';

  @override
  String get m0402Titulo => 'Indemnización';

  @override
  String get m0402Mensaje => '¡Tu indemnización ya está en camino!';

  @override
  String m0402Monto(String monto) {
    return '$monto depositados';
  }

  @override
  String m0402Cuenta(String metodo) {
    return 'Pagado por $metodo';
  }

  @override
  String get m0402VerDetalle => 'Ver detalle';

  @override
  String get m0402Cargando => 'Consultando tu indemnización…';

  @override
  String get m0403Titulo => 'Detalle de la indemnización';

  @override
  String m0403EventoRetrasoVuelo(String ref, String detalle) {
    return 'Evento detectado: retraso de vuelo $ref ($detalle)';
  }

  @override
  String m0403EventoCancelacionVuelo(String ref) {
    return 'Evento detectado: cancelación de vuelo $ref';
  }

  @override
  String m0403EventoLluvia(String ciudad, String detalle) {
    return 'Evento detectado: lluvia sobre el umbral en $ciudad ($detalle)';
  }

  @override
  String get m0403Indemnizacion => 'Indemnización';

  @override
  String get m0403FechaEvento => 'Fecha del evento';

  @override
  String get m0403FechaPago => 'Fecha de pago';

  @override
  String get m0403Cuenta => 'Método de pago';

  @override
  String get m0403Automatico => 'Pago procesado automáticamente';

  @override
  String get m0403Cerrar => 'Cerrar';

  @override
  String get m0404Titulo => 'Mi cobertura';

  @override
  String get m0404Cargando => 'Consultando tu cobertura…';

  @override
  String m0404Producto(String producto, String estado) {
    return '$producto · $estado';
  }

  @override
  String get m0404Vigente => 'Vigente';

  @override
  String get m0404Vencida => 'Vencida';

  @override
  String m0404Poliza(String numero, String fecha) {
    return 'Póliza $numero · hasta $fecha';
  }

  @override
  String get m0404Tope => 'Tope de cobertura';

  @override
  String m0404PorcentajeUsado(int porcentaje) {
    return '$porcentaje % del tope usado';
  }

  @override
  String get m0404Disponible => 'Disponible';

  @override
  String get m0404TotalIndemnizado => 'Total indemnizado';

  @override
  String m0404TotalDetalle(int pagos, String mes) {
    String _temp0 = intl.Intl.pluralLogic(
      pagos,
      locale: localeName,
      other: 'los $pagos pagos que has recibido',
      one: 'el pago que has recibido',
    );
    return 'Suma de $_temp0 desde $mes, en todas tus pólizas.';
  }

  @override
  String m0404Depositado(String metodo) {
    return 'Pagado por $metodo';
  }

  @override
  String m0404SaldoFavor(String monto) {
    return '+ $monto a tu favor';
  }

  @override
  String m0404SaldoFavorDetalle(String mes) {
    return 'Ajuste de prima de $mes. Se descuenta de tu próximo cobro.';
  }

  @override
  String m0404SaldoContra(String monto) {
    return '− $monto pendiente';
  }

  @override
  String m0404SaldoContraDetalle(String mes) {
    return 'Diferencia de prima de $mes. Se suma a tu próximo cobro.';
  }

  @override
  String get m0404Movimientos => 'Movimientos indemnizados';

  @override
  String m0404Pagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pagos',
      one: '1 pago',
    );
    return '$_temp0';
  }

  @override
  String get m0404Pagado => 'Pagado';

  @override
  String get m0404EnProceso => 'En proceso';

  @override
  String get m0404PolizaAnterior => 'póliza anterior';

  @override
  String m0404Meta(String fecha, String detalle) {
    return '$fecha · $detalle';
  }

  @override
  String get m0404Nota =>
      'El tope se reinicia con cada renovación. Los pagos de pólizas anteriores no descuentan del cupo actual.';

  @override
  String get m0404Vacio => 'Aún no tienes pagos indemnizados.';

  @override
  String get m04Reintentar => 'Reintentar';

  @override
  String m04EventoRetrasoVuelo(String ref) {
    return 'Retraso de vuelo $ref';
  }

  @override
  String m04EventoCancelacionVuelo(String ref) {
    return 'Cancelación de vuelo $ref';
  }

  @override
  String get m04EventoLluvia => 'Lluvia sobre el umbral';

  @override
  String m04DetalleLluvia(String ciudad, String detalle) {
    return '$ciudad, $detalle';
  }

  @override
  String m0402CuentaSemantica(String metodo) {
    return 'Pagado por $metodo';
  }

  @override
  String m0501PolizaAuto(String vehiculo) {
    return 'Auto $vehiculo';
  }

  @override
  String get m0501QuePaso => '¿Qué le pasó al vehículo?';

  @override
  String get m0501ElegirTipo => 'Elige qué le pasó al vehículo para continuar.';

  @override
  String get m05TipoChoqueParcial => 'Choque con daños que se pueden reparar';

  @override
  String get m05TipoPerdidaTotal => 'Pérdida total por un choque';

  @override
  String get m05TipoHurtoTotal => 'Me robaron el vehículo';

  @override
  String get m05TipoHurtoParcial => 'Me robaron partes del vehículo';

  @override
  String get m05TipoResponsabilidadCivil =>
      'Le causé daños a otra persona o vehículo';

  @override
  String get cuentaOlvideClave => '¿Olvidaste tu contraseña?';

  @override
  String get m0204Titulo => 'Recupera tu contraseña';

  @override
  String get m0204Intro =>
      'Escribe el correo de tu cuenta y, si existe, te enviaremos un enlace para elegir una contraseña nueva.';

  @override
  String get m0204Enviar => 'Enviar enlace';

  @override
  String get m0204EnviadoTitulo => 'Revisa tu correo';

  @override
  String get m0204EnviadoTexto =>
      'Si hay una cuenta con ese correo, te enviamos un enlace. Ábrelo para elegir tu contraseña nueva; vence en 30 minutos y sirve una sola vez.';

  @override
  String get m0204Volver => 'Volver a iniciar sesión';

  @override
  String cuentaIngresarConHuella(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Ingresar con huella',
      'rostro': 'Ingresar con rostro',
      'bloqueo': 'Ingresar con el bloqueo del teléfono',
      'other': 'Ingresar con la seguridad del teléfono',
    });
    return '$_temp0';
  }

  @override
  String get accesoBiometricoMotivo =>
      'Confirma que eres tú para entrar a Solventa';

  @override
  String get accesoBiometricoActivarMotivo =>
      'Confirma tu huella o rostro para entrar sin escribir la contraseña';

  @override
  String get fallaDispositivoNoValido =>
      'No pudimos verificar este teléfono. Ingresa con tu correo y contraseña.';

  @override
  String get m0105Grabar => 'Grabar video';

  @override
  String get m0105Grabando => 'Grabando';

  @override
  String m0105GrabandoInstruccion(int segundos) {
    return 'Mueve la cabeza despacio de un lado a otro… $segundos';
  }

  @override
  String get m0105Capturado => 'Listo, ya tenemos tu selfie y tu video.';

  @override
  String get m0105Verificando =>
      'Estamos enviando tus fotos y verificando tu identidad con nuestro proveedor. Puede tardar unos segundos.';

  @override
  String get homeCargandoCuenta => 'Cargando tu cuenta…';

  @override
  String get homeCuentaSinCargar =>
      'No pudimos cargar la información de tu cuenta. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get homeReintentarCuenta => 'Reintentar';

  @override
  String get m0507Titulo => 'Detalle del siniestro';

  @override
  String get m0507NoEncontrado => 'No encontramos este siniestro.';

  @override
  String m0507Ocurrio(String fecha) {
    return 'Ocurrió el $fecha';
  }

  @override
  String get m0507Resolucion => 'Resolución';

  @override
  String m0507ResueltoEl(String fecha) {
    return 'Resuelto el $fecha';
  }

  @override
  String m0507Indemnizacion(String monto) {
    return 'Indemnización aprobada: $monto';
  }

  @override
  String m0507PlazoPago(String plazo) {
    return 'Plazo de pago: $plazo';
  }

  @override
  String m0507Motivo(String motivo) {
    return 'Motivo: $motivo';
  }

  @override
  String m0507ViaRecurso(String via) {
    return 'Cómo pedir una revisión: $via';
  }

  @override
  String get m0507MotivoEvidencia => 'la evidencia no fue suficiente';

  @override
  String get m0507MotivoCobertura => 'el hecho está fuera de la cobertura';

  @override
  String get m0507MotivoPoliza => 'la póliza no estaba vigente';

  @override
  String get m0507MotivoRelato =>
      'el relato no es consistente con la evidencia';

  @override
  String get m0507MotivoOtro => 'otro motivo';

  @override
  String m0507Restante(String tiempo) {
    return 'Tiempo restante: $tiempo';
  }

  @override
  String get m0507PlazoVencido =>
      'El plazo de revisión venció. Estamos procesando tu caso: verás el resultado aquí en unos minutos.';
}
