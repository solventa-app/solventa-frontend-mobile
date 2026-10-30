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
  String get m0105DemoRevision => 'Simulate identity under review';

  @override
  String get m0105DemoRechazo => 'Simulate rejected document';

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
  String get m0105bAyudaContrasena => 'At least 8 characters.';

  @override
  String get m0105bErrorCorreo => 'Enter a valid email.';

  @override
  String get m0105bErrorContrasena =>
      'Your password must be 8 to 128 characters long.';

  @override
  String get m0105bErrorConfirmar => 'The passwords don\'t match.';

  @override
  String get m0105bCorreoRegistrado =>
      'There is already an account with this email. Use another one.';

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
}
