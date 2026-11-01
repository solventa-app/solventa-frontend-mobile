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
      'Slowly turn your face inside the frame (front camera)';

  @override
  String get verificacionTitulo => 'Verification';

  @override
  String get m0106Validando => 'Checking with the KYC/AML provider...';

  @override
  String get m0107aMensaje => 'Identity verified! Welcome to Solventa.';

  @override
  String get m0107aAccion => 'Go to my account';

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
  String get m0108Encabezado =>
      'We need to turn on your fingerprint or face unlock';

  @override
  String get m0108Explicacion =>
      'Solventa protects your account with your phone\'s own security: to continue, your phone must have fingerprint or face unlock turned on. It\'s the same one you use to unlock your phone — Solventa never sees or stores that data.';

  @override
  String get m0108Sello => 'Biometric check encrypted on your device';

  @override
  String get m0108Ajustes => 'Open phone settings';

  @override
  String get m0108Continuar => 'I turned it on, continue';

  @override
  String get m0108Requisito =>
      'Without fingerprint or face unlock on the device the app can\'t be used — it\'s a requirement, not an option.';

  @override
  String get m0108NoActivada =>
      'We still can\'t find fingerprint or face unlock on your phone.';

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
  String get fallaEsperaRequerida => 'Please wait a moment before requesting another code.';

  @override
  String get m0105bReqLargo => 'Between 8 and 128 characters';

  @override
  String get m0105bReqMayuscula => 'One uppercase letter';

  @override
  String get m0105bReqMinuscula => 'One lowercase letter';

  @override
  String get m0105bReqEspecial => 'One special character (for example ! ? @ # €)';

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
  String get perfilNotaLegal =>
      'Your account details come from your verified ID document and are read only. Your personal data is processed under Colombian Law 1581 of 2012 (Habeas Data).';

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
}
