import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Píldora de idioma y moneda de la barra superior
  ///
  /// In es, this message translates to:
  /// **'ES · COP'**
  String get localeChip;

  /// M01-01 título
  ///
  /// In es, this message translates to:
  /// **'Bienvenida a Solventa'**
  String get m0101Titulo;

  /// M01-01 párrafo
  ///
  /// In es, this message translates to:
  /// **'Antes de activar tu cuenta, vamos a verificar tu identidad en 3 pasos rápidos:'**
  String get m0101Intro;

  /// M01-01 paso 1
  ///
  /// In es, this message translates to:
  /// **'Autorización de tratamiento de datos'**
  String get m0101Paso1;

  /// M01-01 paso 2
  ///
  /// In es, this message translates to:
  /// **'Captura de tu documento de identidad (frente y reverso)'**
  String get m0101Paso2;

  /// M01-01 paso 3
  ///
  /// In es, this message translates to:
  /// **'Prueba de vida (selfie)'**
  String get m0101Paso3;

  /// M01-01 lectura de TalkBack de cada paso
  ///
  /// In es, this message translates to:
  /// **'Paso {numero} de 3: {texto}'**
  String m0101PasoSemantica(int numero, String texto);

  /// M01-01 botón
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get m0101Empezar;

  /// M01-02 barra superior
  ///
  /// In es, this message translates to:
  /// **'Autorización de datos'**
  String get m0102Titulo;

  /// M01-02 texto legal
  ///
  /// In es, this message translates to:
  /// **'Para verificar tu identidad necesitamos tu autorización para tratar tus datos personales conforme a la Ley 1581 de 2012 (Habeas Data).'**
  String get m0102Legal;

  /// M01-02 casilla
  ///
  /// In es, this message translates to:
  /// **'Autorizo el tratamiento de mis datos personales'**
  String get m0102Consentimiento;

  /// Botón continuar
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continuar;

  /// M01-03/04 barra superior
  ///
  /// In es, this message translates to:
  /// **'Captura del documento'**
  String get m0103Titulo;

  /// Tipo de documento en el visor
  ///
  /// In es, this message translates to:
  /// **'Cédula de ciudadanía'**
  String get m0103Tipo;

  /// M01-03 instrucción
  ///
  /// In es, this message translates to:
  /// **'Ubica el FRENTE del documento dentro del marco'**
  String get m0103Instruccion;

  /// M01-03 consejo
  ///
  /// In es, this message translates to:
  /// **'Evita reflejos de luz directa y sombras pronunciadas'**
  String get m0103Consejo;

  /// Botón repetir captura
  ///
  /// In es, this message translates to:
  /// **'Repetir'**
  String get repetir;

  /// Botón capturar
  ///
  /// In es, this message translates to:
  /// **'Capturar'**
  String get capturar;

  /// M01-04 indicador de paso
  ///
  /// In es, this message translates to:
  /// **'Paso 2 de 2: Reverso'**
  String get m0104Paso;

  /// M01-04 marca de agua del visor
  ///
  /// In es, this message translates to:
  /// **'Lado posterior'**
  String get m0104LadoPosterior;

  /// M01-04 instrucción
  ///
  /// In es, this message translates to:
  /// **'Ubica el REVERSO del documento dentro del marco'**
  String get m0104Instruccion;

  /// M01-04 consejo
  ///
  /// In es, this message translates to:
  /// **'Evita reflejos de luz directa y sombras pronunciadas sobre el código de barras y la huella.'**
  String get m0104Consejo;

  /// M01-04 estado de calidad
  ///
  /// In es, this message translates to:
  /// **'Enfoque y luz adecuados'**
  String get m0104Calidad;

  /// M01-05 barra superior
  ///
  /// In es, this message translates to:
  /// **'Prueba de vida'**
  String get m0105Titulo;

  /// M01-05 instrucción
  ///
  /// In es, this message translates to:
  /// **'Gira tu rostro lentamente dentro del marco (cámara frontal)'**
  String get m0105Instruccion;

  /// M01-06/07 barra superior
  ///
  /// In es, this message translates to:
  /// **'Verificación'**
  String get verificacionTitulo;

  /// M01-06 mensaje de carga
  ///
  /// In es, this message translates to:
  /// **'Validando con el proveedor KYC/AML...'**
  String get m0106Validando;

  /// M01-07a
  ///
  /// In es, this message translates to:
  /// **'¡Identidad verificada! Bienvenido a Solventa.'**
  String get m0107aMensaje;

  /// M01-07a botón
  ///
  /// In es, this message translates to:
  /// **'Ir a mi cuenta'**
  String get m0107aAccion;

  /// M01-07b
  ///
  /// In es, this message translates to:
  /// **'Estamos revisando tu identidad, te avisamos.'**
  String get m0107bMensaje;

  /// M01-07b botón
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get m0107bAccion;

  /// M01-07c
  ///
  /// In es, this message translates to:
  /// **'No pudimos verificar tu documento (imagen ilegible)'**
  String get m0107cMensaje;

  /// Botón reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get reintentar;

  /// M01-08 barra superior
  ///
  /// In es, this message translates to:
  /// **'Activación'**
  String get m0108Titulo;

  /// M01-08 título
  ///
  /// In es, this message translates to:
  /// **'Necesitamos activar tu huella o rostro'**
  String get m0108Encabezado;

  /// M01-08 explicación
  ///
  /// In es, this message translates to:
  /// **'Solventa protege tu cuenta con la seguridad de tu propio teléfono: para continuar, tu celular debe tener huella dactilar o reconocimiento facial activado. Es lo mismo que usas para desbloquear el teléfono — Solventa nunca ve ni guarda ese dato.'**
  String get m0108Explicacion;

  /// M01-08 sello de confianza
  ///
  /// In es, this message translates to:
  /// **'Validación biométrica encriptada localmente'**
  String get m0108Sello;

  /// M01-08 botón secundario
  ///
  /// In es, this message translates to:
  /// **'Ir a configuración del teléfono'**
  String get m0108Ajustes;

  /// M01-08 botón principal
  ///
  /// In es, this message translates to:
  /// **'Ya lo activé, continuar'**
  String get m0108Continuar;

  /// M01-08 nota
  ///
  /// In es, this message translates to:
  /// **'Sin huella o rostro activado en el equipo, la app no puede usarse — es un requisito, no una opción.'**
  String get m0108Requisito;

  /// Falla SinConexion
  ///
  /// In es, this message translates to:
  /// **'No tienes conexión. Revisa tu internet e intenta de nuevo.'**
  String get fallaSinConexion;

  /// Falla ServicioNoDisponible
  ///
  /// In es, this message translates to:
  /// **'El servicio tardó más de lo esperado. Intenta nuevamente.'**
  String get fallaServicio;

  /// Falla Inesperada
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Intenta nuevamente.'**
  String get fallaGenerica;

  /// Lectura de TalkBack de la píldora de idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma español, moneda pesos colombianos. Toca para cambiar a inglés.'**
  String get localeChipSemantica;

  /// M01-05b: título
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get m0105bTitulo;

  /// M01-05b: texto de entrada
  ///
  /// In es, this message translates to:
  /// **'Mientras verificamos tu identidad, crea la cuenta con la que vas a entrar a Solventa.'**
  String get m0105bIntro;

  /// M01-05b: campo correo
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get m0105bCorreo;

  /// M01-05b: campo clave
  ///
  /// In es, this message translates to:
  /// **'Clave'**
  String get m0105bContrasena;

  /// M01-05b: campo confirmación
  ///
  /// In es, this message translates to:
  /// **'Confirma la clave'**
  String get m0105bConfirmar;

  /// M01-05b: requisito de la clave cumplido (lector de pantalla)
  ///
  /// In es, this message translates to:
  /// **'cumplido'**
  String get m0105bRequisitoCumplido;

  /// M01-05b: requisito de la clave pendiente (lector de pantalla)
  ///
  /// In es, this message translates to:
  /// **'pendiente'**
  String get m0105bRequisitoPendiente;

  /// M01-05b: ayuda de la clave
  ///
  /// In es, this message translates to:
  /// **'Entre 8 y 128 caracteres.'**
  String get m0105bAyudaContrasena;

  /// M01-05b: correo inválido
  ///
  /// In es, this message translates to:
  /// **'Escribe un correo válido.'**
  String get m0105bErrorCorreo;

  /// M01-05b: clave corta o larga
  ///
  /// In es, this message translates to:
  /// **'La clave debe cumplir todos los requisitos.'**
  String get m0105bErrorContrasena;

  /// M01-05b: clave vacía al iniciar sesión
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu clave.'**
  String get m0105bErrorContrasenaLogin;

  /// M01-05b: confirmación distinta
  ///
  /// In es, this message translates to:
  /// **'Las claves no coinciden.'**
  String get m0105bErrorConfirmar;

  /// M01-05b: CORREO_YA_REGISTRADO
  ///
  /// In es, this message translates to:
  /// **'Ya hay una cuenta con este correo. Inicia sesión.'**
  String get m0105bCorreoRegistrado;

  /// M01-05b: botón
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get m0105bCrear;

  /// M01-06: tras las 3 consultas
  ///
  /// In es, this message translates to:
  /// **'Está tardando más de lo normal. Puedes actualizar o volver más tarde: la verificación sigue.'**
  String get m0106Demora;

  /// Botón actualizar
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get actualizar;

  /// Botón ir al inicio
  ///
  /// In es, this message translates to:
  /// **'Ir al inicio'**
  String get irAlInicio;

  /// M01-07c: ROSTRO_NO_COINCIDE
  ///
  /// In es, this message translates to:
  /// **'El rostro del video no coincide con el del documento.'**
  String get m0107cRostro;

  /// M01-07c: SUPLANTACION
  ///
  /// In es, this message translates to:
  /// **'No pudimos confirmar que la prueba de vida la hiciste tú, en vivo.'**
  String get m0107cSuplantacion;

  /// M01-07c: MENOR_DE_EDAD
  ///
  /// In es, this message translates to:
  /// **'Debes ser mayor de edad para tener una cuenta en Solventa.'**
  String get m0107cMenor;

  /// M01-07c: DOCUMENTO_YA_REGISTRADO
  ///
  /// In es, this message translates to:
  /// **'Este documento ya tiene una cuenta en Solventa.'**
  String get m0107cDocumentoRegistrado;

  /// M01-07c: sin intentos
  ///
  /// In es, this message translates to:
  /// **'Ya no quedan intentos. Escríbenos a soporte para revisar tu caso.'**
  String get m0107cSinIntentos;

  /// Onboarding: TOKEN_INVALIDO
  ///
  /// In es, this message translates to:
  /// **'Tu registro venció. Empieza de nuevo.'**
  String get fallaRegistroVencido;

  /// No description provided for @fallaAlmacenamiento.
  ///
  /// In es, this message translates to:
  /// **'El servicio de almacenamiento de documentos no está disponible en este momento. Intenta de nuevo.'**
  String get fallaAlmacenamiento;

  /// No description provided for @fallaObjetoNoSubido.
  ///
  /// In es, this message translates to:
  /// **'No pudimos recibir tu archivo completo. Revisa tu conexión y toca Reintentar envío.'**
  String get fallaObjetoNoSubido;

  /// No description provided for @fallaTamanoNoAdmitido.
  ///
  /// In es, this message translates to:
  /// **'El archivo supera el peso máximo permitido (5 MB foto de documento, 2 MB selfie, 15 MB video).'**
  String get fallaTamanoNoAdmitido;

  /// No description provided for @fallaTipoNoAdmitido.
  ///
  /// In es, this message translates to:
  /// **'El formato del archivo no es compatible (usa JPEG para fotos y MP4 para video).'**
  String get fallaTipoNoAdmitido;

  /// No description provided for @fallaPiezasIncompletas.
  ///
  /// In es, this message translates to:
  /// **'Falta confirmar alguna de las capturas. Toca Reintentar envío para completar la subida.'**
  String get fallaPiezasIncompletas;

  /// No description provided for @fallaSinConsentimiento.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar la autorización de tratamiento de datos personales para continuar.'**
  String get fallaSinConsentimiento;

  /// No description provided for @fallaProveedorNoDisponible.
  ///
  /// In es, this message translates to:
  /// **'El proveedor de verificación de identidad está tardando en responder. Reintenta en unos segundos.'**
  String get fallaProveedorNoDisponible;

  /// No description provided for @fallaCodigoInvalido.
  ///
  /// In es, this message translates to:
  /// **'El código ingresado no es correcto. Revísalo e intenta de nuevo.'**
  String get fallaCodigoInvalido;

  /// No description provided for @fallaCodigoVencido.
  ///
  /// In es, this message translates to:
  /// **'El código venció. Solicita uno nuevo para continuar.'**
  String get fallaCodigoVencido;

  /// No description provided for @fallaIntentosAgotados.
  ///
  /// In es, this message translates to:
  /// **'Agotaste los intentos de este código o verificación. Solicita uno nuevo.'**
  String get fallaIntentosAgotados;

  /// No description provided for @fallaCredencialesInvalidas.
  ///
  /// In es, this message translates to:
  /// **'El correo o la clave no son correctos. Revísalos e intenta de nuevo.'**
  String get fallaCredencialesInvalidas;

  /// No description provided for @fallaSesionVencida.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión venció. Inicia sesión nuevamente.'**
  String get fallaSesionVencida;

  /// No description provided for @fallaSinPermiso.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para realizar esta operación.'**
  String get fallaSinPermiso;

  /// No description provided for @cuentaModoCrear.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get cuentaModoCrear;

  /// No description provided for @cuentaModoIngresar.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get cuentaModoIngresar;

  /// No description provided for @cuentaTituloIngresar.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get cuentaTituloIngresar;

  /// No description provided for @cuentaIntroCrear.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu correo electrónico y crea tu clave para empezar en Solventa. Te enviaremos un código de 6 dígitos para confirmar tu correo.'**
  String get cuentaIntroCrear;

  /// No description provided for @cuentaIntroIngresar.
  ///
  /// In es, this message translates to:
  /// **'Ingresa con el correo y la clave de tu cuenta en Solventa.'**
  String get cuentaIntroIngresar;

  /// No description provided for @cuentaBotonIngresar.
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get cuentaBotonIngresar;

  /// No description provided for @cuentaCambiarAIngresar.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? Inicia sesión'**
  String get cuentaCambiarAIngresar;

  /// No description provided for @cuentaCambiarACrear.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Crear cuenta'**
  String get cuentaCambiarACrear;

  /// No description provided for @otpTitulo.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu correo'**
  String get otpTitulo;

  /// No description provided for @otpInstruccion.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de 6 dígitos que enviamos a {correo}.'**
  String otpInstruccion(String correo);

  /// No description provided for @otpVence.
  ///
  /// In es, this message translates to:
  /// **'El código vence en 10 minutos.'**
  String get otpVence;

  /// No description provided for @otpIntentosRestantes.
  ///
  /// In es, this message translates to:
  /// **'Intentos restantes: {intentos}'**
  String otpIntentosRestantes(int intentos);

  /// No description provided for @otpVerificar.
  ///
  /// In es, this message translates to:
  /// **'Verificar código'**
  String get otpVerificar;

  /// No description provided for @otpReenviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar otro código'**
  String get otpReenviar;

  /// No description provided for @otpReenviarEn.
  ///
  /// In es, this message translates to:
  /// **'Reenviar en {tiempo}'**
  String otpReenviarEn(String tiempo);

  /// No description provided for @fallaEsperaRequerida.
  ///
  /// In es, this message translates to:
  /// **'Espera un momento antes de pedir otro código.'**
  String get fallaEsperaRequerida;

  /// No description provided for @m0105bReqLargo.
  ///
  /// In es, this message translates to:
  /// **'Entre 8 y 128 caracteres'**
  String get m0105bReqLargo;

  /// No description provided for @m0105bReqMayuscula.
  ///
  /// In es, this message translates to:
  /// **'Una letra mayúscula'**
  String get m0105bReqMayuscula;

  /// No description provided for @m0105bReqMinuscula.
  ///
  /// In es, this message translates to:
  /// **'Una letra minúscula'**
  String get m0105bReqMinuscula;

  /// No description provided for @m0105bReqEspecial.
  ///
  /// In es, this message translates to:
  /// **'Un carácter especial (por ejemplo ! ¿ @ # €)'**
  String get m0105bReqEspecial;

  /// No description provided for @otpReenviado.
  ///
  /// In es, this message translates to:
  /// **'Te enviamos un código nuevo a tu correo.'**
  String get otpReenviado;

  /// No description provided for @homeSaludoBienvenida.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a Solventa'**
  String get homeSaludoBienvenida;

  /// No description provided for @homeSaludoHola.
  ///
  /// In es, this message translates to:
  /// **'Hola, {nombre}'**
  String homeSaludoHola(String nombre);

  /// No description provided for @homePendienteTexto.
  ///
  /// In es, this message translates to:
  /// **'Completa tu registro para activar tu cuenta'**
  String get homePendienteTexto;

  /// No description provided for @homePendienteBoton.
  ///
  /// In es, this message translates to:
  /// **'Completar registro'**
  String get homePendienteBoton;

  /// No description provided for @homeEnRevisionTitulo.
  ///
  /// In es, this message translates to:
  /// **'Estamos revisando tu identidad'**
  String get homeEnRevisionTitulo;

  /// No description provided for @homeEnRevisionTexto.
  ///
  /// In es, this message translates to:
  /// **'Validamos tus documentos y prueba de vida con nuestro proveedor KYC/AML. Te avisaremos apenas esté lista.'**
  String get homeEnRevisionTexto;

  /// No description provided for @homeEnRevisionBoton.
  ///
  /// In es, this message translates to:
  /// **'Consultar estado'**
  String get homeEnRevisionBoton;

  /// No description provided for @homeRechazadaTitulo.
  ///
  /// In es, this message translates to:
  /// **'No pudimos verificar tu identidad'**
  String get homeRechazadaTitulo;

  /// No description provided for @homeRechazadaBoton.
  ///
  /// In es, this message translates to:
  /// **'Reintentar verificación'**
  String get homeRechazadaBoton;

  /// No description provided for @homeVerificadaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Identidad verificada'**
  String get homeVerificadaTitulo;

  /// No description provided for @homeVerificadaTexto.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta está activa y protegida con validación biométrica.'**
  String get homeVerificadaTexto;

  /// Home verificado: aviso de verificación exitosa y acceso a la web (T15)
  ///
  /// In es, this message translates to:
  /// **'Tu verificación fue exitosa. Ya puedes entrar también a la web de Solventa con el mismo correo y clave.'**
  String get homeVerificadaWeb;

  /// Home en revisión o rechazado: mientras no verifique, solo entra a la app (T15)
  ///
  /// In es, this message translates to:
  /// **'Mientras tu identidad no esté verificada solo puedes entrar a esta app. La web no te dejará entrar hasta que termines la verificación aquí.'**
  String get homeSoloAppAviso;

  /// No description provided for @homeAsistenciaTile.
  ///
  /// In es, this message translates to:
  /// **'Solicitar asistencia en sitio'**
  String get homeAsistenciaTile;

  /// No description provided for @homeBilleteraNota.
  ///
  /// In es, this message translates to:
  /// **'Billetera y estado de póliza — próximamente'**
  String get homeBilleteraNota;

  /// No description provided for @navInicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navInicio;

  /// No description provided for @navAsistencia.
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get navAsistencia;

  /// No description provided for @navPerfil.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get navPerfil;

  /// No description provided for @navCerrarSesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get navCerrarSesion;

  /// No description provided for @preferenciasModalTitulo.
  ///
  /// In es, this message translates to:
  /// **'Idioma y moneda'**
  String get preferenciasModalTitulo;

  /// No description provided for @preferenciasModalSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el idioma de la aplicación y la moneda de visualización.'**
  String get preferenciasModalSubtitulo;

  /// No description provided for @preferenciasIdiomaLabel.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get preferenciasIdiomaLabel;

  /// No description provided for @preferenciasIdiomaEs.
  ///
  /// In es, this message translates to:
  /// **'Español (ES)'**
  String get preferenciasIdiomaEs;

  /// No description provided for @preferenciasIdiomaEn.
  ///
  /// In es, this message translates to:
  /// **'English (EN)'**
  String get preferenciasIdiomaEn;

  /// No description provided for @preferenciasMonedaLabel.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get preferenciasMonedaLabel;

  /// No description provided for @preferenciasListo.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get preferenciasListo;

  /// No description provided for @monedaNombreCOP.
  ///
  /// In es, this message translates to:
  /// **'Peso colombiano (COP)'**
  String get monedaNombreCOP;

  /// No description provided for @monedaNombreMXN.
  ///
  /// In es, this message translates to:
  /// **'Peso mexicano (MXN)'**
  String get monedaNombreMXN;

  /// No description provided for @monedaNombreBRL.
  ///
  /// In es, this message translates to:
  /// **'Real brasileño (BRL)'**
  String get monedaNombreBRL;

  /// No description provided for @monedaNombreCLP.
  ///
  /// In es, this message translates to:
  /// **'Peso chileno (CLP)'**
  String get monedaNombreCLP;

  /// No description provided for @monedaNombrePEN.
  ///
  /// In es, this message translates to:
  /// **'Sol peruano (PEN)'**
  String get monedaNombrePEN;

  /// No description provided for @monedaNombreUSD.
  ///
  /// In es, this message translates to:
  /// **'Dólar estadounidense (USD)'**
  String get monedaNombreUSD;

  /// No description provided for @monedaNombreEUR.
  ///
  /// In es, this message translates to:
  /// **'Euro (EUR)'**
  String get monedaNombreEUR;

  /// No description provided for @perfilTitulo.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get perfilTitulo;

  /// No description provided for @perfilSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta en Solventa'**
  String get perfilSubtitulo;

  /// No description provided for @perfilSoloLectura.
  ///
  /// In es, this message translates to:
  /// **'Solo lectura'**
  String get perfilSoloLectura;

  /// No description provided for @perfilCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando tu perfil…'**
  String get perfilCargando;

  /// No description provided for @perfilError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tu perfil en este momento.'**
  String get perfilError;

  /// No description provided for @perfilActiva.
  ///
  /// In es, this message translates to:
  /// **'Cuenta activa'**
  String get perfilActiva;

  /// No description provided for @perfilPendiente.
  ///
  /// In es, this message translates to:
  /// **'Verificación pendiente'**
  String get perfilPendiente;

  /// No description provided for @perfilSuspendida.
  ///
  /// In es, this message translates to:
  /// **'Cuenta suspendida'**
  String get perfilSuspendida;

  /// No description provided for @perfilDatos.
  ///
  /// In es, this message translates to:
  /// **'Datos de la cuenta'**
  String get perfilDatos;

  /// No description provided for @perfilUsuario.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get perfilUsuario;

  /// No description provided for @perfilNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get perfilNombre;

  /// No description provided for @perfilNombrePendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente de verificación de documento'**
  String get perfilNombrePendiente;

  /// No description provided for @perfilRol.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get perfilRol;

  /// No description provided for @perfilRolCliente.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get perfilRolCliente;

  /// No description provided for @perfilDocumento.
  ///
  /// In es, this message translates to:
  /// **'Documento'**
  String get perfilDocumento;

  /// No description provided for @perfilRegistro.
  ///
  /// In es, this message translates to:
  /// **'Fecha de registro'**
  String get perfilRegistro;

  /// No description provided for @perfilPreferencias.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get perfilPreferencias;

  /// No description provided for @perfilPreferenciasTexto.
  ///
  /// In es, this message translates to:
  /// **'Idioma y moneda con los que se abre la app cada vez que inicias sesión.'**
  String get perfilPreferenciasTexto;

  /// No description provided for @perfilGuardarPreferencias.
  ///
  /// In es, this message translates to:
  /// **'Guardar preferencias'**
  String get perfilGuardarPreferencias;

  /// No description provided for @perfilPreferenciasGuardadas.
  ///
  /// In es, this message translates to:
  /// **'Preferencias guardadas.'**
  String get perfilPreferenciasGuardadas;

  /// No description provided for @perfilNotaLegal.
  ///
  /// In es, this message translates to:
  /// **'Los datos de tu cuenta provienen de tu documento verificado y son de solo lectura. Tus datos personales se tratan conforme a la Ley 1581 de 2012 de Habeas Data.'**
  String get perfilNotaLegal;

  /// No description provided for @cerrarSesionTitulo.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres cerrar sesión?'**
  String get cerrarSesionTitulo;

  /// No description provided for @cerrarSesionMensaje.
  ///
  /// In es, this message translates to:
  /// **'Tendrás que ingresar de nuevo para usar Solventa.'**
  String get cerrarSesionMensaje;

  /// No description provided for @cerrarSesionConfirmar.
  ///
  /// In es, this message translates to:
  /// **'Sí, cerrar sesión'**
  String get cerrarSesionConfirmar;

  /// No description provided for @cerrarSesionCancelar.
  ///
  /// In es, this message translates to:
  /// **'No, seguir aquí'**
  String get cerrarSesionCancelar;

  /// No description provided for @camaraEnVivoListo.
  ///
  /// In es, this message translates to:
  /// **'Cámara activa en el visor'**
  String get camaraEnVivoListo;

  /// No description provided for @camaraReintentarEnvio.
  ///
  /// In es, this message translates to:
  /// **'Reintentar envío'**
  String get camaraReintentarEnvio;

  /// No description provided for @m0108DemoActivar.
  ///
  /// In es, this message translates to:
  /// **'Simular huella/rostro activado en el emulador'**
  String get m0108DemoActivar;

  /// No description provided for @soporteCodigoTexto.
  ///
  /// In es, this message translates to:
  /// **'Si escribes a soporte, comparte este código: {codigo}'**
  String soporteCodigoTexto(String codigo);

  /// No description provided for @soporteCopiarCodigo.
  ///
  /// In es, this message translates to:
  /// **'Copiar código de soporte'**
  String get soporteCopiarCodigo;

  /// No description provided for @soporteCodigoCopiado.
  ///
  /// In es, this message translates to:
  /// **'Código copiado al portapapeles.'**
  String get soporteCodigoCopiado;

  /// Marco de captura sin permiso de cámara: título
  ///
  /// In es, this message translates to:
  /// **'Necesitamos acceso a tu cámara'**
  String get camaraPermisoTitulo;

  /// Marco de captura sin permiso de cámara: explicación
  ///
  /// In es, this message translates to:
  /// **'La usamos solo para tomar las fotos de tu documento y la prueba de vida. No guardamos nada en tu teléfono.'**
  String get camaraPermisoTexto;

  /// Botón para volver a pedir el permiso de cámara
  ///
  /// In es, this message translates to:
  /// **'Permitir cámara'**
  String get camaraPermitir;

  /// Permiso de cámara denegado para siempre
  ///
  /// In es, this message translates to:
  /// **'Bloqueaste el acceso a la cámara. Actívalo en Ajustes → Permisos → Cámara y vuelve aquí.'**
  String get camaraPermisoBloqueado;

  /// Botón que abre los ajustes de la app
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes'**
  String get camaraAbrirAjustes;

  /// El dispositivo no tiene cámara utilizable
  ///
  /// In es, this message translates to:
  /// **'No encontramos una cámara disponible en este dispositivo.'**
  String get camaraNoDisponible;

  /// Falla al capturar sin cámara activa
  ///
  /// In es, this message translates to:
  /// **'No pudimos usar la cámara. Revisa el permiso de cámara e inténtalo de nuevo.'**
  String get fallaCamaraNoDisponible;

  /// Texto del diálogo del sistema al pedir huella, rostro o PIN del teléfono
  ///
  /// In es, this message translates to:
  /// **'Confirma que eres tú para entrar a Solventa'**
  String get biometriaMotivo;

  /// M01-08: aviso cuando solo hay PIN del teléfono (decisión D1)
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono no tiene huella ni rostro registrados. Puedes continuar con el PIN del teléfono, aunque te recomendamos registrar tu huella.'**
  String get m0108SoloPin;

  /// M01-08: aviso cuando el teléfono no tiene bloqueo de pantalla
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono no tiene bloqueo de pantalla. Activa un PIN, patrón o huella en los ajustes para proteger tu cuenta.'**
  String get m0108SinBloqueo;

  /// M01-08: error al consultar la biometría del sistema
  ///
  /// In es, this message translates to:
  /// **'No pudimos consultar la seguridad de tu teléfono. Intenta de nuevo.'**
  String get m0108NoDisponible;

  /// M01-08: la huella o el rostro no coincidieron
  ///
  /// In es, this message translates to:
  /// **'No te reconocimos. Intenta de nuevo.'**
  String get m0108NoReconocido;

  /// M01-08 y M02-01: sensor bloqueado temporalmente
  ///
  /// In es, this message translates to:
  /// **'Hiciste demasiados intentos. Espera unos segundos o usa el PIN del teléfono.'**
  String get m0108BloqueoTemporal;

  /// M02-01: título de la tarjeta
  ///
  /// In es, this message translates to:
  /// **'Desbloquea tu cuenta'**
  String get m0201Titulo;

  /// M02-01: bajo el botón del sensor (en Android no se dice «Face ID»)
  ///
  /// In es, this message translates to:
  /// **'Huella o rostro'**
  String get m0201Sensor;

  /// M02-01: lectura de TalkBack del botón del sensor
  ///
  /// In es, this message translates to:
  /// **'Desbloquear con huella o rostro'**
  String get m0201Escanear;

  /// M02-01: texto del diálogo biométrico del sistema
  ///
  /// In es, this message translates to:
  /// **'Desbloquea tu cuenta de Solventa'**
  String get m0201Motivo;

  /// M02-01 y M02-01a: abre el diálogo del sistema con el PIN, patrón o contraseña del teléfono (D2)
  ///
  /// In es, this message translates to:
  /// **'Usar PIN del teléfono'**
  String get m0201UsarPin;

  /// M02-01: disparador de demo (solo debug)
  ///
  /// In es, this message translates to:
  /// **'Simular que no reconoce la biometría'**
  String get m0201SimularNoReconoce;

  /// M02-01 y M02-01a: reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get m0201Reintentar;

  /// M02-01: sin red al renovar la sesión
  ///
  /// In es, this message translates to:
  /// **'No hay conexión. Tu sesión sigue guardada en este teléfono: reintenta cuando vuelva la señal.'**
  String get m0201SinRed;

  /// M02-01: sensor bloqueado temporalmente
  ///
  /// In es, this message translates to:
  /// **'Hiciste demasiados intentos. Espera unos segundos o usa el PIN del teléfono.'**
  String get m0201BloqueoTemporal;

  /// M02-01: biometría bloqueada hasta usar la credencial del teléfono
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono bloqueó la biometría. Desbloquéala con el PIN, patrón o contraseña del teléfono.'**
  String get m0201BloqueoPermanente;

  /// M02-01: la llave del Keystore pidió una autenticación más fuerte
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono no confirmó tu identidad con la seguridad necesaria. Usa el PIN del teléfono.'**
  String get m0201FaltaAutenticacion;

  /// M02-01: el teléfono no tiene bloqueo de pantalla
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono ya no tiene bloqueo de pantalla. Actívalo en Ajustes o ingresa con tu correo y clave.'**
  String get m0201SinBloqueo;

  /// M02-01: sin hardware o servicio de biometría
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono no puede verificar tu identidad ahora. Revisa Ajustes o ingresa con tu correo y clave.'**
  String get m0201NoDisponible;

  /// M02-01: abre los ajustes de seguridad del teléfono
  ///
  /// In es, this message translates to:
  /// **'Ir a ajustes'**
  String get m0201IrAjustes;

  /// M02-01: salida cuando el teléfono no puede autenticar
  ///
  /// In es, this message translates to:
  /// **'Ingresar con correo y clave'**
  String get m0201UsarCorreo;

  /// M02-01a: título
  ///
  /// In es, this message translates to:
  /// **'No te reconocimos'**
  String get m0201aTitulo;

  /// M02-01a: explicación
  ///
  /// In es, this message translates to:
  /// **'No pudimos verificar tu huella o rostro. Intenta de nuevo o ingresa con el PIN de tu teléfono.'**
  String get m0201aMensaje;

  /// M02-03: título
  ///
  /// In es, this message translates to:
  /// **'Acceso concedido'**
  String get m0203Titulo;

  /// M02-03: saludo cuando aún no llega el nombre
  ///
  /// In es, this message translates to:
  /// **'Hola de nuevo.'**
  String get m0203SaludoSinNombre;

  /// M02-03: lectura de TalkBack de la barra de progreso
  ///
  /// In es, this message translates to:
  /// **'Entrando a tu cuenta'**
  String get m0203Progreso;

  /// M02-03: saludo con el nombre (neutro en género)
  ///
  /// In es, this message translates to:
  /// **'Hola de nuevo, {nombre}.'**
  String m0203Saludo(String nombre);

  /// M06-01 encabezado de la hoja
  ///
  /// In es, this message translates to:
  /// **'Prestadores cercanos'**
  String get m0601Titulo;

  /// M06-01 píldora del encabezado
  ///
  /// In es, this message translates to:
  /// **'{cantidad} disponibles'**
  String m0601Disponibles(int cantidad);

  /// M06-01 botón de cada fila
  ///
  /// In es, this message translates to:
  /// **'Solicitar'**
  String get m0601Solicitar;

  /// M06-01 especialidad médica
  ///
  /// In es, this message translates to:
  /// **'Médico'**
  String get m0601TipoMedico;

  /// M06-01 especialidad mecánica
  ///
  /// In es, this message translates to:
  /// **'Mecánico'**
  String get m0601TipoMecanico;

  /// M06-01 cargando
  ///
  /// In es, this message translates to:
  /// **'Buscando prestadores cerca de ti…'**
  String get m0601Buscando;

  /// M06-01 lista vacía
  ///
  /// In es, this message translates to:
  /// **'No hay prestadores disponibles cerca de ti en este momento.'**
  String get m0601SinPrestadores;

  /// M06-01 sin permiso de ubicación
  ///
  /// In es, this message translates to:
  /// **'Necesitamos tu ubicación para mostrarte los prestadores más cercanos.'**
  String get m0601SinPermiso;

  /// M06-01 GPS apagado
  ///
  /// In es, this message translates to:
  /// **'Tu ubicación está desactivada. Actívala para ver los prestadores cercanos.'**
  String get m0601GpsApagado;

  /// M06-01 reintentar permiso
  ///
  /// In es, this message translates to:
  /// **'Permitir ubicación'**
  String get m0601PermitirUbicacion;

  /// M06-01 abrir ajustes
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes'**
  String get m0601AbrirAjustes;

  /// M06-01 reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get m0601Reintentar;

  /// M06-01 lectura del pin del cliente
  ///
  /// In es, this message translates to:
  /// **'Tu ubicación'**
  String get m0601TuUbicacion;

  /// M06-01 lectura del pin de prestador; abre la app de mapas
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar a {nombre}, {tiempo}'**
  String m0601ComoLlegar(String nombre, String tiempo);

  /// M06-01 sin app de mapas
  ///
  /// In es, this message translates to:
  /// **'No encontramos una app de mapas para abrir la ruta.'**
  String get m0601RutaNoDisponible;

  /// M06-01 atribución del mapa
  ///
  /// In es, this message translates to:
  /// **'© colaboradores de OpenStreetMap'**
  String get m0601Atribucion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
