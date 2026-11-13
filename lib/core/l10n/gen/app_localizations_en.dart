// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localeChip => 'EN · COP';

  @override
  String get m0101Titulo => 'Welcome to Solventa';

  @override
  String get m0101Intro =>
      'Before activating your account, we\'ll verify your identity in 3 quick steps:';

  @override
  String get m0101Paso1 => 'Personal data processing authorization';

  @override
  String get m0101Paso2 => 'Photo of your ID document (front and back)';

  @override
  String get m0101Paso3 => 'Liveness check (selfie)';

  @override
  String m0101PasoSemantica(int numero, String texto) {
    return 'Step $numero of 3: $texto';
  }

  @override
  String get m0101Empezar => 'Start';

  @override
  String get m0102Titulo => 'Data authorization';

  @override
  String get m0102Legal =>
      'To verify your identity we need your authorization to process your personal data under Colombian Law 1581 of 2012 (Habeas Data).';

  @override
  String get m0102Consentimiento =>
      'I authorize the processing of my personal data';

  @override
  String get continuar => 'Continue';

  @override
  String get m0103Titulo => 'ID capture';

  @override
  String get m0103Tipo => 'Citizenship ID card';

  @override
  String get m0103Instruccion => 'Place the FRONT of your ID inside the frame';

  @override
  String get m0103Consejo => 'Avoid direct glare and strong shadows';

  @override
  String get repetir => 'Retake';

  @override
  String get capturar => 'Capture';

  @override
  String get m0104Paso => 'Step 2 of 2: Back';

  @override
  String get m0104LadoPosterior => 'Back side';

  @override
  String get m0104Instruccion => 'Place the BACK of your ID inside the frame';

  @override
  String get m0104Consejo =>
      'Avoid direct glare and strong shadows over the barcode and fingerprint.';

  @override
  String get m0104Calidad => 'Good focus and lighting';

  @override
  String get m0105Titulo => 'Liveness check';

  @override
  String get m0105Instruccion =>
      'Place your face inside the circle. When you tap “Record video” we\'ll record 3 seconds: slowly move your head from side to side.';

  @override
  String get verificacionTitulo => 'Verification';

  @override
  String get m0106Validando => 'Checking with the KYC/AML provider...';

  @override
  String get m0107aMensaje => 'Identity verified! Welcome to Solventa.';

  @override
  String get m0107aAccion => 'Turn on fingerprint or face unlock';

  @override
  String get m0107bMensaje =>
      'We\'re reviewing your identity, we\'ll let you know.';

  @override
  String get m0107bAccion => 'Got it';

  @override
  String get m0107cMensaje =>
      'We couldn\'t verify your document (unreadable image)';

  @override
  String get reintentar => 'Try again';

  @override
  String get m0108Titulo => 'Activation';

  @override
  String m0108Encabezado(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Turn on your fingerprint',
      'rostro': 'Turn on your face',
      'bloqueo': 'Turn on your phone lock',
      'other': 'Turn on your phone\'s security',
    });
    return '$_temp0';
  }

  @override
  String m0108Explicacion(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Get in faster without typing your password. We\'ll ask for your fingerprint just once.',
      'rostro': 'Get in faster without typing your password. We\'ll ask for your face just once.',
      'bloqueo': 'Get in faster without typing your password. We\'ll ask for your phone lock just once.',
      'other': 'Get in faster without typing your password. We\'ll ask for your phone\'s security just once.',
    });
    return '$_temp0';
  }

  @override
  String get m0108Sello => 'Biometric check encrypted on your device';

  @override
  String get m0108Ajustes => 'Open phone settings';

  @override
  String get m0108Continuar => 'I turned it on, continue';

  @override
  String m0108Activar(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Turn on fingerprint',
      'rostro': 'Turn on face unlock',
      'bloqueo': 'Turn on phone lock',
      'other': 'Turn on phone security',
    });
    return '$_temp0';
  }

  @override
  String get m0108AhoraNo => 'Not now, go to home';

  @override
  String get m0108AvisoLuego =>
      'You can turn on your fingerprint or face unlock any time in My profile.';

  @override
  String get m0108Requisito =>
      'You can turn it on later in your phone settings: Solventa will use it as soon as it is ready. Until then you will sign in with your email and password.';

  @override
  String get fallaSinConexion =>
      'You\'re offline. Check your connection and try again.';

  @override
  String get fallaServicio =>
      'The service took longer than expected. Please try again.';

  @override
  String get fallaGenerica => 'Something went wrong. Please try again.';

  @override
  String get localeChipSemantica =>
      'English language, Colombian pesos. Tap to switch to Spanish.';

  @override
  String get m0105bTitulo => 'Create your account';

  @override
  String get m0105bIntro =>
      'While we verify your identity, create the account you will use to sign in to Solventa.';

  @override
  String get m0105bCorreo => 'Email';

  @override
  String get m0105bContrasena => 'Password';

  @override
  String get m0105bConfirmar => 'Confirm your password';

  @override
  String get m0105bRequisitoCumplido => 'met';

  @override
  String get m0105bRequisitoPendiente => 'not met yet';

  @override
  String get m0105bAyudaContrasena => '8 to 128 characters.';

  @override
  String get m0105bErrorCorreo => 'Enter a valid email.';

  @override
  String get m0105bErrorContrasena =>
      'Your password must meet all the requirements.';

  @override
  String get m0105bErrorContrasenaLogin => 'Enter your password.';

  @override
  String get m0105bErrorConfirmar => 'The passwords don\'t match.';

  @override
  String get m0105bCorreoRegistrado =>
      'There is already an account with this email. Sign in.';

  @override
  String get m0105bCrear => 'Create account';

  @override
  String get m0106Demora =>
      'This is taking longer than usual. You can refresh or come back later: the check keeps running.';

  @override
  String get actualizar => 'Refresh';

  @override
  String get irAlInicio => 'Go to home';

  @override
  String get m0107cRostro =>
      'The face in the video doesn\'t match the one on the document.';

  @override
  String get m0107cSuplantacion =>
      'We couldn\'t confirm that you took the liveness check yourself, live.';

  @override
  String get m0107cMenor =>
      'You must be of legal age to have a Solventa account.';

  @override
  String get m0107cDocumentoRegistrado =>
      'This document already has a Solventa account.';

  @override
  String get m0107cSinIntentos =>
      'There are no attempts left. Contact support so we can review your case.';

  @override
  String get fallaRegistroVencido =>
      'Your sign-up expired. Please start again.';

  @override
  String get fallaEmpezarDeNuevo => 'Start over';

  @override
  String get fallaAlmacenamiento =>
      'The document storage service is unavailable right now. Please try again.';

  @override
  String get fallaObjetoNoSubido =>
      'We couldn\'t receive your complete file. Check your connection and tap Retry upload.';

  @override
  String get fallaTamanoNoAdmitido =>
      'The file exceeds the maximum allowed size (5 MB ID photo, 2 MB selfie, 15 MB video).';

  @override
  String get fallaTipoNoAdmitido =>
      'The file format is not supported (use JPEG for photos and MP4 for video).';

  @override
  String get fallaPiezasIncompletas =>
      'Some captures still need confirmation. Tap Retry upload to finish uploading.';

  @override
  String get fallaSinConsentimiento =>
      'You must accept the personal data processing authorization to continue.';

  @override
  String get fallaProveedorNoDisponible =>
      'The identity verification provider is taking longer than expected. Try again in a few seconds.';

  @override
  String get fallaCodigoInvalido =>
      'The code you entered is incorrect. Check it and try again.';

  @override
  String get fallaCodigoVencido =>
      'The code expired. Request a new one to continue.';

  @override
  String get fallaIntentosAgotados =>
      'You have no attempts left for this code or verification. Request a new one.';

  @override
  String get fallaCredencialesInvalidas =>
      'Incorrect email or password. Check them and try again.';

  @override
  String get fallaSesionVencida =>
      'Your session expired. Please sign in again.';

  @override
  String get fallaSeguridadTelefono =>
      'Your phone\'s fingerprint, face or screen lock changed. For your security, sign in with your email and password.';

  @override
  String get fallaSinPermiso =>
      'You do not have permission to perform this operation.';

  @override
  String get cuentaModoCrear => 'Create account';

  @override
  String get cuentaModoIngresar => 'Sign in';

  @override
  String get cuentaTituloIngresar => 'Sign in';

  @override
  String get cuentaIntroCrear =>
      'Enter your email and create your password to get started on Solventa. We\'ll send you a 6-digit code to confirm your email.';

  @override
  String get cuentaIntroIngresar =>
      'Sign in with your Solventa email and password.';

  @override
  String get cuentaBotonIngresar => 'Sign in';

  @override
  String get cuentaCambiarAIngresar => 'Already have an account? Sign in';

  @override
  String get cuentaCambiarACrear => 'Don\'t have an account? Create account';

  @override
  String get otpTitulo => 'Verify your email';

  @override
  String otpInstruccion(String correo) {
    return 'Enter the 6-digit code we sent to $correo.';
  }

  @override
  String get otpVence => 'The code expires in 10 minutes.';

  @override
  String otpIntentosRestantes(int intentos) {
    return 'Attempts remaining: $intentos';
  }

  @override
  String get otpVerificar => 'Verify code';

  @override
  String get otpReenviar => 'Send another code';

  @override
  String otpReenviarEn(String tiempo) {
    return 'Resend in $tiempo';
  }

  @override
  String get fallaEsperaRequerida =>
      'Please wait a moment before requesting another code.';

  @override
  String get m0105bReqLargo => 'Between 8 and 128 characters';

  @override
  String get m0105bReqMayuscula => 'One uppercase letter';

  @override
  String get m0105bReqMinuscula => 'One lowercase letter';

  @override
  String get m0105bReqEspecial =>
      'One special character (for example ! ? @ # €)';

  @override
  String get m0105bReqTitulo => 'Your password needs:';

  @override
  String get m0105bRequisitoIncumplido => 'missing';

  @override
  String get m0105bClavesCoinciden => 'The passwords match.';

  @override
  String get otpReenviado => 'We sent a new code to your email.';

  @override
  String get homeSaludoBienvenida => 'Welcome to Solventa';

  @override
  String homeSaludoHola(String nombre) {
    return 'Hello, $nombre';
  }

  @override
  String get homePendienteTexto =>
      'Complete your registration to activate your account';

  @override
  String get homePendienteBoton => 'Complete registration';

  @override
  String get homeEnRevisionTitulo => 'We\'re reviewing your identity';

  @override
  String get homeEnRevisionTexto =>
      'We\'re validating your ID and liveness check with our KYC/AML provider. We\'ll notify you as soon as it\'s ready.';

  @override
  String get homeEnRevisionBoton => 'Check status';

  @override
  String get homeRechazadaTitulo => 'We couldn\'t verify your identity';

  @override
  String get homeRechazadaBoton => 'Retry verification';

  @override
  String get homeVerificadaTitulo => 'Identity verified';

  @override
  String get homeVerificadaTexto =>
      'Your account is active and protected with biometric validation.';

  @override
  String get homeVerificadaWeb =>
      'Your verification was successful. You can now also sign in to the Solventa website with the same email and password.';

  @override
  String get homeSoloAppAviso =>
      'Until your identity is verified you can only sign in to this app. The website will not let you in until you finish the verification here.';

  @override
  String get homeAsistenciaTile => 'Request on-site assistance';

  @override
  String get homeBilleteraNota => 'Wallet and policy status — coming soon';

  @override
  String get navInicio => 'Home';

  @override
  String get navAsistencia => 'Assistance';

  @override
  String get navPerfil => 'My profile';

  @override
  String get navCerrarSesion => 'Sign out';

  @override
  String get preferenciasModalTitulo => 'Language & currency';

  @override
  String get preferenciasModalSubtitulo =>
      'Select the app language and display currency.';

  @override
  String get preferenciasIdiomaLabel => 'Language';

  @override
  String get preferenciasIdiomaEs => 'Español (ES)';

  @override
  String get preferenciasIdiomaEn => 'English (EN)';

  @override
  String get preferenciasMonedaLabel => 'Currency';

  @override
  String get preferenciasListo => 'Done';

  @override
  String get monedaNombreCOP => 'Colombian peso (COP)';

  @override
  String get monedaNombreMXN => 'Mexican peso (MXN)';

  @override
  String get monedaNombreBRL => 'Brazilian real (BRL)';

  @override
  String get monedaNombreCLP => 'Chilean peso (CLP)';

  @override
  String get monedaNombrePEN => 'Peruvian sol (PEN)';

  @override
  String get monedaNombreUSD => 'US dollar (USD)';

  @override
  String get monedaNombreEUR => 'Euro (EUR)';

  @override
  String get perfilTitulo => 'My profile';

  @override
  String get perfilSubtitulo => 'Your Solventa account';

  @override
  String get perfilSoloLectura => 'Read only';

  @override
  String get perfilCargando => 'Loading your profile…';

  @override
  String get perfilError => 'We couldn\'t load your profile right now.';

  @override
  String get perfilActiva => 'Active account';

  @override
  String get perfilPendiente => 'Verification pending';

  @override
  String get perfilSuspendida => 'Suspended account';

  @override
  String get perfilDatos => 'Account details';

  @override
  String get perfilUsuario => 'Email';

  @override
  String get perfilNombre => 'Name';

  @override
  String get perfilNombrePendiente => 'Pending document verification';

  @override
  String get perfilRol => 'Role';

  @override
  String get perfilRolCliente => 'Customer';

  @override
  String get perfilDocumento => 'ID Document';

  @override
  String get perfilRegistro => 'Registration date';

  @override
  String get perfilPreferencias => 'Preferences';

  @override
  String get perfilPreferenciasTexto =>
      'Language and currency the app opens with every time you sign in.';

  @override
  String get perfilGuardarPreferencias => 'Save preferences';

  @override
  String get perfilPreferenciasGuardadas => 'Preferences saved.';

  @override
  String get perfilBiometria => 'Phone fingerprint or face unlock';

  @override
  String get homeBiometriaPista =>
      'Turn on your fingerprint or face unlock to sign in faster.';

  @override
  String get homeBiometriaActivar => 'Turn on';

  @override
  String get homeBiometriaCerrar => 'Dismiss';

  @override
  String get perfilBiometriaActiva => 'On';

  @override
  String get perfilBiometriaInactiva => 'Off · Tap to turn on';

  @override
  String get perfilNotaLegal =>
      'Your account details come from your verified ID document and are read only. Your personal data is processed under Colombian Law 1581 of 2012 (Habeas Data).';

  @override
  String get perfilNotificacionesPush => 'Push notifications';

  @override
  String get perfilNotificacionesPushTexto =>
      'Get notified when a payout is settled, among other things.';

  @override
  String get perfilNotificacionesPushError =>
      'We couldn\'t save your preference. Try again.';

  @override
  String get cerrarSesionTitulo => 'Do you want to sign out?';

  @override
  String get cerrarSesionMensaje =>
      'You will need to sign in again to use Solventa.';

  @override
  String get cerrarSesionConfirmar => 'Yes, sign out';

  @override
  String get cerrarSesionCancelar => 'No, stay here';

  @override
  String get camaraEnVivoListo => 'Live camera active in viewfinder';

  @override
  String get camaraReintentarEnvio => 'Retry upload';

  @override
  String get m0108DemoActivar =>
      'Simulate fingerprint/face enabled on emulator';

  @override
  String soporteCodigoTexto(String codigo) {
    return 'If you contact support, share this code: $codigo';
  }

  @override
  String get soporteCopiarCodigo => 'Copy support code';

  @override
  String get soporteCodigoCopiado => 'Support code copied to clipboard.';

  @override
  String get camaraPermisoTitulo => 'We need access to your camera';

  @override
  String get camaraPermisoTexto =>
      'We only use it to take the photos of your ID and the liveness check. Nothing is saved on your phone.';

  @override
  String get camaraPermitir => 'Allow camera';

  @override
  String get camaraPermisoBloqueado =>
      'You blocked camera access. Turn it on in Settings → Permissions → Camera and come back.';

  @override
  String get camaraAbrirAjustes => 'Open settings';

  @override
  String get camaraNoDisponible =>
      'We couldn\'t find an available camera on this device.';

  @override
  String get fallaCamaraNoDisponible =>
      'We couldn\'t use the camera. Check the camera permission and try again.';

  @override
  String get biometriaMotivo => 'Confirm it\'s you to open Solventa';

  @override
  String get m0108SoloPin =>
      'Your phone has no fingerprint or face registered. You can continue with your phone PIN, but we recommend adding a fingerprint.';

  @override
  String get m0108SinBloqueo =>
      'Your phone has no screen lock. Turn on a PIN, pattern or fingerprint in settings to protect your account.';

  @override
  String get m0108NoDisponible =>
      'We couldn\'t check your phone\'s security. Please try again.';

  @override
  String get m0108NoReconocido => 'We didn\'t recognize you. Please try again.';

  @override
  String get m0108BloqueoTemporal =>
      'Too many attempts. Wait a few seconds or use your phone PIN.';

  @override
  String get m0201Titulo => 'Unlock your account';

  @override
  String get m0201Sensor => 'Fingerprint or face';

  @override
  String get m0201Escanear => 'Unlock with fingerprint or face';

  @override
  String get m0201IngresaHuella => 'Sign in with your fingerprint';

  @override
  String get m0201IngresaRostro => 'Sign in with your face';

  @override
  String get m0201IngresaSeguridad => 'Sign in with your phone\'s security';

  @override
  String get m0201IngresaBloqueo => 'Sign in with your phone\'s screen lock';

  @override
  String get m0201Motivo => 'Unlock your Solventa account';

  @override
  String get m0201DialogoTitulo => 'Unlock Solventa';

  @override
  String get m0201DialogoSubtitulo => 'Confirm it\'s you';

  @override
  String get m0201DialogoCancelar => 'Cancel';

  @override
  String get m0201UsarBloqueo => 'Use your phone lock';

  @override
  String get m0201SimularNoReconoce => 'Simulate biometrics not recognized';

  @override
  String get m0201Reintentar => 'Try again';

  @override
  String get m0201SinRed =>
      'No connection. Your session is still saved on this phone: try again when you\'re back online.';

  @override
  String get m0201BloqueoTemporal =>
      'Too many attempts. Wait a few seconds or use your phone lock.';

  @override
  String get m0201BloqueoPermanente =>
      'Your phone locked biometrics. Unlock it with your phone PIN, pattern or password.';

  @override
  String get m0201FaltaAutenticacion =>
      'Your phone couldn\'t open your fingerprint or face. Use your phone lock.';

  @override
  String get m0201SinBloqueo =>
      'Your phone no longer has a screen lock. Turn it on in settings or sign in with your email and password.';

  @override
  String get m0201NoDisponible =>
      'Your phone can\'t verify your identity right now. Check settings or sign in with your email and password.';

  @override
  String get m0201IrAjustes => 'Go to settings';

  @override
  String get m0201UsarCorreo => 'Use email and password';

  @override
  String get m0201aTitulo => 'We couldn\'t recognize you';

  @override
  String get m0201aMensaje =>
      'We couldn\'t verify your fingerprint or face. Try again or use your phone lock.';

  @override
  String get m0203Titulo => 'Access granted';

  @override
  String get m0203SaludoSinNombre => 'Welcome back.';

  @override
  String get m0203Progreso => 'Opening your account';

  @override
  String m0203Saludo(String nombre) {
    return 'Welcome back, $nombre.';
  }

  @override
  String get m0601Titulo => 'Nearby providers';

  @override
  String m0601Disponibles(int cantidad) {
    return '$cantidad available';
  }

  @override
  String get m0601Solicitar => 'Request';

  @override
  String get m0601TipoMedico => 'Medical';

  @override
  String get m0601TipoMecanico => 'Mechanic';

  @override
  String get m0601TipoGrua => 'Tow truck';

  @override
  String get m0601Aliado => 'Solventa partner';

  @override
  String get m0601Buscando => 'Looking for providers near you…';

  @override
  String get m0601SinPrestadores =>
      'We don\'t have providers in your area yet.';

  @override
  String get m0601Reintentar => 'Try again';

  @override
  String get m0601TuUbicacion => 'Your location';

  @override
  String get m0601RutaNoDisponible =>
      'We couldn\'t find a maps app to open the route.';

  @override
  String m0601PinSemantica(String nombre, String tipo, String tiempo) {
    return '$nombre, $tipo, $tiempo';
  }

  @override
  String get m0601VerSatelite => 'Show satellite';

  @override
  String get m0601VerCalles => 'Show streets';

  @override
  String get m0601Recentrar => 'Re-center on my location';

  @override
  String get m0601ExpandirLista => 'Expand list';

  @override
  String get m0601ContraerLista => 'Collapse list';

  @override
  String get m0601MasPrestadores => 'More providers in your city';

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
    return '$distancia · arrives in $tiempo';
  }

  @override
  String get m0601SolicitarAsistencia => 'Request assistance';

  @override
  String get m0601ComoLlegarBoton => 'Get directions';

  @override
  String get m0601DireccionCopiada => 'Address copied';

  @override
  String get m0601CopiarDireccion => 'Long-press to copy the address';

  @override
  String get m0601Copiar => 'Copy';

  @override
  String get m0601Cerrar => 'Close';

  @override
  String get ubicacionExplicaTitulo => 'We need your location';

  @override
  String get ubicacionExplicaTexto =>
      'To show you the nearest providers and how long they take to arrive.';

  @override
  String get ubicacionPermitir => 'Allow location';

  @override
  String get ubicacionNegadaTitulo => 'We don\'t have your location';

  @override
  String get ubicacionNegadaTexto =>
      'You can grant permission or type where you are. With the address we show you the same providers.';

  @override
  String get ubicacionAbrirAjustes => 'Open Settings';

  @override
  String get gpsApagadoTitulo => 'Your GPS is off';

  @override
  String get gpsApagadoTexto =>
      'Turn on your phone\'s location to find providers near you.';

  @override
  String get gpsActivar => 'Turn on location';

  @override
  String get direccionEscribir => 'Type my address';

  @override
  String get direccionTitulo => 'Where are you?';

  @override
  String get direccionCampo => 'Address, city or landmark';

  @override
  String get direccionBuscar => 'Search this address';

  @override
  String get direccionNoEncontrada =>
      'We couldn\'t find that address. Try another one or a landmark';

  @override
  String get direccionServicioCaido =>
      'We couldn\'t search addresses right now. Try again';

  @override
  String direccionUsando(String direccion) {
    return 'Using: $direccion';
  }

  @override
  String get direccionCambiar => 'Change';

  @override
  String get direccionUsarActual => 'Use my current location';

  @override
  String get direccionPinEtiqueta => 'Typed address';

  @override
  String get homeReportarTile => 'Report a claim';

  @override
  String get m05Titulo => 'Report a claim';

  @override
  String get m05Continuar => 'Continue';

  @override
  String get m05Reintentar => 'Try again';

  @override
  String get m0501Poliza => 'Which policy?';

  @override
  String m0501PolizaNumero(String numero) {
    return 'Policy $numero';
  }

  @override
  String m0501Vigencia(String fecha) {
    return 'Valid until $fecha';
  }

  @override
  String get m0501Cargando => 'Looking for your policies…';

  @override
  String get m0501SinPolizas => 'You have no issued car policies to report on.';

  @override
  String get m0501Fecha => 'When did it happen?';

  @override
  String get m0501FechaFuera =>
      'That date is outside the policy\'s coverage period.';

  @override
  String m0501FechaAntes(String desde) {
    return 'Your policy started covering you on $desde. Choose a date and time from then on.';
  }

  @override
  String get m0501FechaElegir => 'Choose the day and time';

  @override
  String get m0501ElegirPoliza => 'First choose the affected policy.';

  @override
  String m0501CubreDesde(String desde) {
    return 'Your policy covers from $desde.';
  }

  @override
  String get m0502Titulo => 'Photos of the damage';

  @override
  String get m0502Instruccion =>
      'Take 1 to 3 photos of the damage. Each photo records where you took it.';

  @override
  String get m0502Tomar => 'Take photo';

  @override
  String m0502Contador(int cantidad) {
    return '$cantidad of 3 photos';
  }

  @override
  String m0502Quitar(int numero) {
    return 'Remove photo $numero';
  }

  @override
  String get m0502Ubicada => 'Location ready: your photos are geotagged.';

  @override
  String get m0502SinUbicacion =>
      'We need your location to place the claim. Turn it on to continue.';

  @override
  String get m0502PermitirUbicacion => 'Allow location';

  @override
  String get m0502AbrirAjustes => 'Open settings';

  @override
  String get m0502CamaraNoDisponible =>
      'We couldn\'t use the camera. Check the camera permission and try again.';

  @override
  String get m0502Visor => 'Camera viewfinder';

  @override
  String get m0503Titulo => 'What happened?';

  @override
  String get m0503Relato => 'Tell us what happened';

  @override
  String get m0503RelatoAyuda => '10 to 1000 characters.';

  @override
  String get m0503Lugar => 'Where did it happen?';

  @override
  String get m0503LugarAyuda => 'Address or landmark.';

  @override
  String get m0503Ciudad => 'City';

  @override
  String get m0503Requerido => 'Fill in this field.';

  @override
  String get m0503Enviar => 'Send report';

  @override
  String get m0504Titulo => 'Sending your report';

  @override
  String get m0504Mensaje =>
      'We\'re uploading your photos and registering your case…';

  @override
  String get m0505Exito => 'We received your report';

  @override
  String m0505ExitoMensaje(String radicado, String fecha) {
    return 'Your case $radicado is pending review. We\'ll get back to you by $fecha.';
  }

  @override
  String get m0505Error => 'We couldn\'t send your report';

  @override
  String get m0505VolverInicio => 'Back to home';

  @override
  String get m0505Revisar => 'Review the report';

  @override
  String get m0505FotoNoConfirmada =>
      'One of the photos didn\'t upload correctly. Please take it again.';

  @override
  String get homeMisSiniestrosTile => 'My claims';

  @override
  String get homeMiCoberturaTile => 'My coverage';

  @override
  String get m0505VerMisSiniestros => 'See my claims';

  @override
  String get m0506Titulo => 'My claims';

  @override
  String get m0506Cargando => 'Looking for your reports…';

  @override
  String get m0506Vacio => 'You haven\'t reported any claims yet.';

  @override
  String m0506Reportado(String fecha, int fotos) {
    String _temp0 = intl.Intl.pluralLogic(
      fotos,
      locale: localeName,
      other: '$fotos photos',
      one: '1 photo',
    );
    return 'Reported on $fecha · $_temp0';
  }

  @override
  String get m0506Pendiente => 'Pending';

  @override
  String m0506PendienteDetalle(String fecha) {
    return 'We\'ll review it by $fecha.';
  }

  @override
  String get m0506EnRevision => 'Under review';

  @override
  String get m0506EnRevisionDetalle => 'An adjuster is evaluating your case.';

  @override
  String get m0506Aprobado => 'Approved';

  @override
  String get m0506AprobadoDetalle => 'Your payout is being processed.';

  @override
  String get m0506Rechazado => 'Rejected';

  @override
  String get m0506RechazadoDetalle =>
      'We sent you the reason and how to appeal.';

  @override
  String get m0602Titulo => 'Request assistance';

  @override
  String get m0602PrestadorAsignado => 'Assigned provider';

  @override
  String get m0602Tipo => 'Type of assistance';

  @override
  String get m0602TipoMedica => 'Medical';

  @override
  String get m0602TipoMecanica => 'Mechanical';

  @override
  String get m0602TipoGrua => 'Tow truck';

  @override
  String get m0602TipoElegir => 'Choose an option';

  @override
  String get m0602AtencionInmediata => 'Immediate attention';

  @override
  String get m0602AtencionInmediataTexto =>
      'We are coordinating your request in real time';

  @override
  String m0602UbicacionEscrita(String direccion) {
    return '$direccion (the address you typed)';
  }

  @override
  String get m0602TipoRequerido => 'Choose the type of assistance.';

  @override
  String m0602TipoNoAtendido(String nombre) {
    return '$nombre doesn\'t handle this type of assistance. Choose another provider on the map.';
  }

  @override
  String get m0602Descripcion => 'Briefly describe what happened';

  @override
  String get m0602DescripcionHint => 'E.g. chest pain, dizziness…';

  @override
  String m0602TextoLargo(int maximo) {
    return 'Use $maximo characters at most.';
  }

  @override
  String m0602UbicacionDetectada(String coordenadas) {
    return 'Location detected automatically: $coordenadas';
  }

  @override
  String m0602TiempoLlegada(String tiempo) {
    return 'Estimated arrival time: $tiempo';
  }

  @override
  String get m0602Enviar => 'Send request';

  @override
  String m0603Mensaje(String nombre) {
    return 'Confirming availability with $nombre…';
  }

  @override
  String m0603bMensaje(String nombre) {
    return 'Resending your request to $nombre…';
  }

  @override
  String get m0604aTitulo => 'Request confirmed';

  @override
  String m0604aMensajeSinTiempo(String nombre) {
    return '$nombre is on the way to the address you entered.';
  }

  @override
  String m0604aMensaje(String nombre, int minutos) {
    return '$nombre is on the way. Estimated arrival in $minutos minutes.';
  }

  @override
  String get m0604aVerMapa => 'View on the map';

  @override
  String get m0604aCancelar => 'Cancel assistance';

  @override
  String get m0604aCancelarFallo =>
      'We couldn\'t cancel the assistance. Please try again.';

  @override
  String get m0604bTitulo => 'We couldn\'t confirm your request';

  @override
  String m0604bSinRespuesta(String nombre) {
    return '$nombre didn\'t respond in time. You can choose another provider or try again.';
  }

  @override
  String m0604bNoDisponible(String nombre) {
    return '$nombre is no longer available. Choose another nearby provider.';
  }

  @override
  String get m0604bElegirOtro => 'Choose another provider';

  @override
  String get m0604bReintentar => 'Try again';

  @override
  String get m0605Titulo => 'Are you sure you want to cancel?';

  @override
  String m0605Mensaje(String nombre) {
    return '$nombre is already on the way. If you cancel now, you\'ll have to request assistance again from scratch.';
  }

  @override
  String get m0605Confirmar => 'Yes, cancel';

  @override
  String get m0605Mantener => 'No, keep request';

  @override
  String get m0606Titulo => 'Cancel assistance';

  @override
  String get m0606Mensaje =>
      'Your request was cancelled. The assigned service no longer applies and there will be no charges for this request.';

  @override
  String get m0606VolverInicio => 'Back to home';

  @override
  String get m0606SolicitarDeNuevo => 'Request again';

  @override
  String get navMisAsistencias => 'My requests';

  @override
  String navMisAsistenciasEnCamino(String cantidad) {
    return 'My requests, $cantidad on the way';
  }

  @override
  String get misAsistenciasTitulo => 'My requests';

  @override
  String get misAsistenciasVacio => 'You haven\'t requested assistance yet';

  @override
  String get misAsistenciasSolicitar => 'Request on-site assistance';

  @override
  String misAsistenciasEnCamino(String cantidad) {
    return 'On the way ($cantidad)';
  }

  @override
  String misAsistenciasYaLlegaron(String cantidad) {
    return 'Arrived ($cantidad)';
  }

  @override
  String get misAsistenciasError => 'We couldn\'t load your requests.';

  @override
  String get misAsistenciasCargando => 'Loading your requests…';

  @override
  String asistenciaPedida(String tipo, String hora) {
    return '$tipo · requested $hora';
  }

  @override
  String asistenciaLlegaEn(String minutos) {
    return 'Arrives in $minutos min';
  }

  @override
  String get asistenciaLlegaMenosDeUno => 'Arrives in less than 1 min';

  @override
  String asistenciaHoraEstimada(String hora) {
    return 'Estimated time $hora';
  }

  @override
  String asistenciaLlego(String hora) {
    return 'Arrived · $hora';
  }

  @override
  String get asistenciaNoConfirmada => 'We couldn\'t confirm';

  @override
  String get asistenciaReintentar => 'Try again';

  @override
  String asistenciaEnCaminoLlega(String minutos) {
    return 'On the way · arrives in $minutos min';
  }

  @override
  String get asistenciaNotifTitulo => 'Your assistance has arrived';

  @override
  String asistenciaNotifCuerpo(String prestador) {
    return '$prestador should be at your location now';
  }

  @override
  String get asistenciaNotifNota =>
      'We\'ll let you know when the provider arrives.';

  @override
  String asistenciaLlegoSnack(String prestador) {
    return '$prestador has arrived';
  }

  @override
  String get asistenciaVer => 'View';

  @override
  String get asistenciaDetalleTitulo => 'Your assistance';

  @override
  String asistenciaTeAlejaste(String direccion) {
    return 'You moved away from where you requested assistance. The provider is going to $direccion';
  }

  @override
  String get asistenciaLugarPedido => 'the place where you requested it';

  @override
  String get asistenciaCancelarYPedirOtra => 'Cancel and request another';

  @override
  String asistenciaLectura(String prestador, String tipo, String estado) {
    return '$prestador, $tipo, $estado';
  }

  @override
  String get asistenciaNoEncontrada => 'We couldn\'t find that request.';

  @override
  String get m0402Titulo => 'Payout';

  @override
  String get m0402Mensaje => 'Your payout is on its way!';

  @override
  String m0402Monto(String monto) {
    return '$monto deposited';
  }

  @override
  String m0402Cuenta(String metodo) {
    return 'Paid via $metodo';
  }

  @override
  String get m0402VerDetalle => 'See details';

  @override
  String get m0402Cargando => 'Loading your payout…';

  @override
  String get m0403Titulo => 'Payout details';

  @override
  String m0403EventoRetrasoVuelo(String ref, String detalle) {
    return 'Event detected: flight $ref delayed ($detalle)';
  }

  @override
  String m0403EventoCancelacionVuelo(String ref) {
    return 'Event detected: flight $ref cancelled';
  }

  @override
  String m0403EventoLluvia(String ciudad, String detalle) {
    return 'Event detected: rainfall over the threshold in $ciudad ($detalle)';
  }

  @override
  String get m0403Indemnizacion => 'Payout';

  @override
  String get m0403FechaEvento => 'Event date';

  @override
  String get m0403FechaPago => 'Payment date';

  @override
  String get m0403Cuenta => 'Payment method';

  @override
  String get m0403Automatico => 'Payment processed automatically';

  @override
  String get m0403Cerrar => 'Close';

  @override
  String get m0404Titulo => 'My coverage';

  @override
  String get m0404Cargando => 'Loading your coverage…';

  @override
  String m0404Producto(String producto, String estado) {
    return '$producto · $estado';
  }

  @override
  String get m0404Vigente => 'Active';

  @override
  String get m0404Vencida => 'Expired';

  @override
  String m0404Poliza(String numero, String fecha) {
    return 'Policy $numero · until $fecha';
  }

  @override
  String get m0404Tope => 'Coverage limit';

  @override
  String m0404PorcentajeUsado(int porcentaje) {
    return '$porcentaje% of the limit used';
  }

  @override
  String get m0404Disponible => 'Available';

  @override
  String get m0404TotalIndemnizado => 'Total paid out';

  @override
  String m0404TotalDetalle(int pagos, String mes) {
    String _temp0 = intl.Intl.pluralLogic(
      pagos,
      locale: localeName,
      other: 'the $pagos payments you\'ve received',
      one: 'the payment you\'ve received',
    );
    return 'Sum of $_temp0 since $mes, across all your policies.';
  }

  @override
  String m0404Depositado(String metodo) {
    return 'Paid via $metodo';
  }

  @override
  String m0404SaldoFavor(String monto) {
    return '+ $monto in your favor';
  }

  @override
  String m0404SaldoFavorDetalle(String mes) {
    return 'Premium adjustment for $mes. It will be deducted from your next charge.';
  }

  @override
  String m0404SaldoContra(String monto) {
    return '− $monto pending';
  }

  @override
  String m0404SaldoContraDetalle(String mes) {
    return 'Premium difference for $mes. It will be added to your next charge.';
  }

  @override
  String get m0404Movimientos => 'Payouts';

  @override
  String m0404Pagos(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n payments',
      one: '1 payment',
    );
    return '$_temp0';
  }

  @override
  String get m0404Pagado => 'Paid';

  @override
  String get m0404EnProceso => 'Processing';

  @override
  String get m0404PolizaAnterior => 'previous policy';

  @override
  String m0404Meta(String fecha, String detalle) {
    return '$fecha · $detalle';
  }

  @override
  String get m0404Nota =>
      'The limit resets with each renewal. Payouts from previous policies don\'t count against the current limit.';

  @override
  String get m0404Vacio => 'You don\'t have any payouts yet.';

  @override
  String get m04Reintentar => 'Try again';

  @override
  String m04EventoRetrasoVuelo(String ref) {
    return 'Flight $ref delayed';
  }

  @override
  String m04EventoCancelacionVuelo(String ref) {
    return 'Flight $ref cancelled';
  }

  @override
  String get m04EventoLluvia => 'Rainfall over the threshold';

  @override
  String m04DetalleLluvia(String ciudad, String detalle) {
    return '$ciudad, $detalle';
  }

  @override
  String m0402CuentaSemantica(String metodo) {
    return 'Paid via $metodo';
  }

  @override
  String m0501PolizaAuto(String vehiculo) {
    return 'Car $vehiculo';
  }

  @override
  String get m0501QuePaso => 'What happened to the vehicle?';

  @override
  String get m0501ElegirTipo =>
      'Choose what happened to the vehicle to continue.';

  @override
  String get m05TipoChoqueParcial => 'Crash with repairable damage';

  @override
  String get m05TipoPerdidaTotal => 'Total loss from a crash';

  @override
  String get m05TipoHurtoTotal => 'My vehicle was stolen';

  @override
  String get m05TipoHurtoParcial => 'Parts of my vehicle were stolen';

  @override
  String get m05TipoResponsabilidadCivil =>
      'I damaged another person or vehicle';

  @override
  String get cuentaOlvideClave => 'Forgot your password?';

  @override
  String get m0204Titulo => 'Recover your password';

  @override
  String get m0204Intro =>
      'Enter your account email and, if it exists, we will send you a link to choose a new password.';

  @override
  String get m0204Enviar => 'Send link';

  @override
  String get m0204EnviadoTitulo => 'Check your email';

  @override
  String get m0204EnviadoTexto =>
      'If there is an account with that email, we sent you a link. Open it to choose your new password; it expires in 30 minutes and works only once.';

  @override
  String get m0204Volver => 'Back to sign in';

  @override
  String cuentaIngresarConHuella(String tipo) {
    String _temp0 = intl.Intl.selectLogic(tipo, {
      'huella': 'Sign in with fingerprint',
      'rostro': 'Sign in with face',
      'bloqueo': 'Sign in with your phone lock',
      'other': 'Sign in with your phone\'s security',
    });
    return '$_temp0';
  }

  @override
  String get accesoBiometricoMotivo =>
      'Confirm it\'s you to sign in to Solventa';

  @override
  String get accesoBiometricoActivarMotivo =>
      'Confirm your fingerprint or face to sign in without typing your password';

  @override
  String get fallaDispositivoNoValido =>
      'We could not verify this phone. Sign in with your email and password.';

  @override
  String get m0105Grabar => 'Record video';

  @override
  String get m0105Grabando => 'Recording';

  @override
  String m0105GrabandoInstruccion(int segundos) {
    return 'Slowly move your head from side to side… $segundos';
  }

  @override
  String get m0105Capturado => 'Done, we have your selfie and your video.';

  @override
  String get m0105Verificando =>
      'We\'re sending your photos and verifying your identity with our provider. It may take a few seconds.';

  @override
  String get homeCargandoCuenta => 'Loading your account…';

  @override
  String get homeCuentaSinCargar =>
      'We couldn\'t load your account information. Check your connection and try again.';

  @override
  String get homeReintentarCuenta => 'Try again';

  @override
  String get m0507Titulo => 'Claim details';

  @override
  String get m0507NoEncontrado => 'We couldn\'t find this claim.';

  @override
  String m0507Ocurrio(String fecha) {
    return 'Happened on $fecha';
  }

  @override
  String get m0507Resolucion => 'Resolution';

  @override
  String m0507ResueltoEl(String fecha) {
    return 'Resolved on $fecha';
  }

  @override
  String m0507Indemnizacion(String monto) {
    return 'Approved compensation: $monto';
  }

  @override
  String m0507PlazoPago(String plazo) {
    return 'Payment deadline: $plazo';
  }

  @override
  String m0507Motivo(String motivo) {
    return 'Reason: $motivo';
  }

  @override
  String m0507ViaRecurso(String via) {
    return 'How to ask for a review: $via';
  }

  @override
  String get m0507MotivoEvidencia => 'the evidence was not enough';

  @override
  String get m0507MotivoCobertura => 'the event is outside the coverage';

  @override
  String get m0507MotivoPoliza => 'the policy was not in force';

  @override
  String get m0507MotivoRelato => 'the account does not match the evidence';

  @override
  String get m0507MotivoOtro => 'another reason';

  @override
  String m0507Restante(String tiempo) {
    return 'Time left: $tiempo';
  }

  @override
  String get m0507PlazoVencido =>
      'The review period has ended. We are processing your claim: you will see the result here in a few minutes.';
}
