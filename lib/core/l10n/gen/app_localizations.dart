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

  /// M01-05 instrucción antes de grabar (los pasos van debajo del visor)
  ///
  /// In es, this message translates to:
  /// **'Pon tu rostro dentro del óvalo y toca «Grabar video».'**
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

  /// M01-07a resumen: el documento pasó la verificación de autenticidad (KAN-130)
  ///
  /// In es, this message translates to:
  /// **'Documento auténtico'**
  String get m0107aDocumento;

  /// M01-07a resumen: la prueba de vida pasó (KAN-130)
  ///
  /// In es, this message translates to:
  /// **'Prueba de vida superada'**
  String get m0107aPruebaVida;

  /// M01-07a resumen: el rostro coincide con la foto del documento (KAN-130)
  ///
  /// In es, this message translates to:
  /// **'Tu rostro coincide con el documento'**
  String get m0107aRostro;

  /// M01-07a botón
  ///
  /// In es, this message translates to:
  /// **'Activar huella o rostro'**
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

  /// M01-07c: ILEGIBLE o motivo desconocido
  ///
  /// In es, this message translates to:
  /// **'No pudimos leer bien tu documento. Tómale de nuevo las fotos con buena luz, sin reflejos y con la cédula completa dentro del marco.'**
  String get m0107cMensaje;

  /// M01-07c y tarjeta del inicio: rechazo técnico (PROVEEDOR_NO_DISPONIBLE o IMAGEN_NO_DISPONIBLE, KAN-131), no gasta intento
  ///
  /// In es, this message translates to:
  /// **'No pudimos terminar tu verificación por un problema técnico. No perdiste ningún intento: inténtalo de nuevo.'**
  String get m0107cFallaTecnica;

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

  /// M01-08 título según el método del teléfono
  ///
  /// In es, this message translates to:
  /// **'{tipo, select, huella{Activa tu huella} rostro{Activa tu rostro} bloqueo{Activa el bloqueo del teléfono} other{Activa la seguridad de tu teléfono}}'**
  String m0108Encabezado(String tipo);

  /// M01-08 explicación según el método del teléfono
  ///
  /// In es, this message translates to:
  /// **'{tipo, select, huella{Entra más rápido sin escribir tu contraseña. Te pediremos tu huella una sola vez.} rostro{Entra más rápido sin escribir tu contraseña. Te pediremos tu rostro una sola vez.} bloqueo{Entra más rápido sin escribir tu contraseña. Te pediremos el bloqueo de tu teléfono una sola vez.} other{Entra más rápido sin escribir tu contraseña. Te pediremos la seguridad de tu teléfono una sola vez.}}'**
  String m0108Explicacion(String tipo);

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

  /// M01-08 botón principal cuando el teléfono ya tiene biometría registrada
  ///
  /// In es, this message translates to:
  /// **'{tipo, select, huella{Activar huella} rostro{Activar rostro} bloqueo{Activar bloqueo} other{Activar seguridad}}'**
  String m0108Activar(String tipo);

  /// No description provided for @m0108AhoraNo.
  ///
  /// In es, this message translates to:
  /// **'Ahora no, ir al inicio'**
  String get m0108AhoraNo;

  /// No description provided for @m0108AvisoLuego.
  ///
  /// In es, this message translates to:
  /// **'Puedes activar tu huella o rostro cuando quieras en Mi perfil.'**
  String get m0108AvisoLuego;

  /// M01-08 nota
  ///
  /// In es, this message translates to:
  /// **'Puedes activarla después en los ajustes del teléfono: Solventa la usará apenas esté lista. Mientras tanto entrarás con tu correo y clave.'**
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
  /// **'El rostro del video no coincide con el de tu documento. Grábalo de nuevo de frente, con buena luz y sin gafas, gorra ni tapabocas.'**
  String get m0107cRostro;

  /// M01-07c: SUPLANTACION
  ///
  /// In es, this message translates to:
  /// **'No pudimos confirmar que la prueba de vida la hiciste tú, en vivo. Grábala de nuevo tú mismo, sin fotos ni pantallas frente a la cámara.'**
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
  /// **'Ya no quedan intentos en esta verificación. Desde el inicio puedes empezar una nueva.'**
  String get m0107cSinIntentos;

  /// Onboarding: TOKEN_INVALIDO
  ///
  /// In es, this message translates to:
  /// **'Tu registro venció. Empieza de nuevo.'**
  String get fallaRegistroVencido;

  /// Onboarding: acción del aviso cuando el registro venció (TOKEN_INVALIDO)
  ///
  /// In es, this message translates to:
  /// **'Empezar de nuevo'**
  String get fallaEmpezarDeNuevo;

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

  /// HU-M02 (D4): Android invalidó la llave de la sesión guardada
  ///
  /// In es, this message translates to:
  /// **'Cambió la huella, el rostro o el bloqueo de tu teléfono. Por tu seguridad, inicia sesión con tu correo y clave.'**
  String get fallaSeguridadTelefono;

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

  /// No description provided for @m0105bReqTitulo.
  ///
  /// In es, this message translates to:
  /// **'Tu clave debe tener:'**
  String get m0105bReqTitulo;

  /// No description provided for @m0105bRequisitoIncumplido.
  ///
  /// In es, this message translates to:
  /// **'falta'**
  String get m0105bRequisitoIncumplido;

  /// No description provided for @m0105bClavesCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Las claves coinciden.'**
  String get m0105bClavesCoinciden;

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

  /// No description provided for @perfilBiometria.
  ///
  /// In es, this message translates to:
  /// **'Huella o rostro del teléfono'**
  String get perfilBiometria;

  /// No description provided for @homeBiometriaPista.
  ///
  /// In es, this message translates to:
  /// **'Activa tu huella o rostro para entrar más rápido.'**
  String get homeBiometriaPista;

  /// No description provided for @homeBiometriaActivar.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get homeBiometriaActivar;

  /// No description provided for @homeBiometriaCerrar.
  ///
  /// In es, this message translates to:
  /// **'Cerrar aviso'**
  String get homeBiometriaCerrar;

  /// No description provided for @perfilBiometriaActiva.
  ///
  /// In es, this message translates to:
  /// **'Activada'**
  String get perfilBiometriaActiva;

  /// No description provided for @perfilBiometriaInactiva.
  ///
  /// In es, this message translates to:
  /// **'Sin activar · Toca para activar'**
  String get perfilBiometriaInactiva;

  /// No description provided for @perfilNotaLegal.
  ///
  /// In es, this message translates to:
  /// **'Los datos de tu cuenta provienen de tu documento verificado y son de solo lectura. Tus datos personales se tratan conforme a la Ley 1581 de 2012 de Habeas Data.'**
  String get perfilNotaLegal;

  /// Perfil: interruptor de preferencia de push (KAN-259)
  ///
  /// In es, this message translates to:
  /// **'Notificaciones push'**
  String get perfilNotificacionesPush;

  /// Perfil: texto de ayuda del interruptor de push
  ///
  /// In es, this message translates to:
  /// **'Avisa cuando se liquide una indemnización, entre otros.'**
  String get perfilNotificacionesPushTexto;

  /// Perfil: error al cambiar la preferencia de push
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar tu preferencia. Intenta de nuevo.'**
  String get perfilNotificacionesPushError;

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

  /// M02-01: texto bajo el sensor según lo que tiene el teléfono
  ///
  /// In es, this message translates to:
  /// **'Ingresa con tu huella'**
  String get m0201IngresaHuella;

  /// M02-01: texto bajo el sensor según lo que tiene el teléfono
  ///
  /// In es, this message translates to:
  /// **'Ingresa con tu rostro'**
  String get m0201IngresaRostro;

  /// M02-01: método biométrico desconocido (huella y rostro posibles a la vez, Android 8 o 9, o la consulta falló); ícono del escudo
  ///
  /// In es, this message translates to:
  /// **'Ingresa con la seguridad de tu teléfono'**
  String get m0201IngresaSeguridad;

  /// M02-01: texto bajo el sensor según lo que tiene el teléfono
  ///
  /// In es, this message translates to:
  /// **'Ingresa con el bloqueo de tu teléfono'**
  String get m0201IngresaBloqueo;

  /// M02-01: texto del diálogo biométrico del sistema
  ///
  /// In es, this message translates to:
  /// **'Desbloquea tu cuenta de Solventa'**
  String get m0201Motivo;

  /// Título del diálogo del sistema al desbloquear (Android lo muestra tal cual)
  ///
  /// In es, this message translates to:
  /// **'Desbloquea Solventa'**
  String get m0201DialogoTitulo;

  /// Subtítulo del diálogo del sistema al desbloquear
  ///
  /// In es, this message translates to:
  /// **'Confirma que eres tú'**
  String get m0201DialogoSubtitulo;

  /// Botón de abajo del diálogo del sistema cuando solo acepta biometría
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get m0201DialogoCancelar;

  /// M02-01 y M02-01a: abre el diálogo del sistema con el PIN, patrón o contraseña del teléfono (D2)
  ///
  /// In es, this message translates to:
  /// **'Usar el bloqueo del teléfono'**
  String get m0201UsarBloqueo;

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
  /// **'Hiciste demasiados intentos. Espera unos segundos o usa el bloqueo de tu teléfono.'**
  String get m0201BloqueoTemporal;

  /// M02-01: biometría bloqueada hasta usar la credencial del teléfono
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono bloqueó la biometría. Desbloquéala con el PIN, patrón o contraseña del teléfono.'**
  String get m0201BloqueoPermanente;

  /// M02-01: la llave del Keystore pidió una autenticación más fuerte
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono no pudo abrir tu huella o rostro. Usa el bloqueo de tu teléfono.'**
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
  /// **'Usar correo y contraseña'**
  String get m0201UsarCorreo;

  /// M02-01a: título
  ///
  /// In es, this message translates to:
  /// **'No te reconocimos'**
  String get m0201aTitulo;

  /// M02-01a: explicación
  ///
  /// In es, this message translates to:
  /// **'No pudimos verificar tu huella o rostro. Intenta de nuevo o usa el bloqueo de tu teléfono.'**
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

  /// M06-01 tipo grúa (v0.49)
  ///
  /// In es, this message translates to:
  /// **'Grúa'**
  String get m0601TipoGrua;

  /// M06-01 insignia del prestador aliado (v0.49)
  ///
  /// In es, this message translates to:
  /// **'Aliado Solventa'**
  String get m0601Aliado;

  /// M06-01 cargando
  ///
  /// In es, this message translates to:
  /// **'Buscando prestadores cerca de ti…'**
  String get m0601Buscando;

  /// M06-01 lista vacía
  ///
  /// In es, this message translates to:
  /// **'Aún no tenemos prestadores en tu zona.'**
  String get m0601SinPrestadores;

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

  /// M06-01 sin app de mapas
  ///
  /// In es, this message translates to:
  /// **'No encontramos una app de mapas para abrir la ruta.'**
  String get m0601RutaNoDisponible;

  /// M06-01 lectura del pin del mapa; abre el detalle
  ///
  /// In es, this message translates to:
  /// **'{nombre}, {tipo}, {tiempo}'**
  String m0601PinSemantica(String nombre, String tipo, String tiempo);

  /// M06-01 botón de capas (M14) cuando está en calles
  ///
  /// In es, this message translates to:
  /// **'Ver satélite'**
  String get m0601VerSatelite;

  /// M06-01 botón de capas (M14) cuando está en satélite
  ///
  /// In es, this message translates to:
  /// **'Ver calles'**
  String get m0601VerCalles;

  /// M06-01 botón «Volver a centrar» (M8)
  ///
  /// In es, this message translates to:
  /// **'Volver a centrar en mi ubicación'**
  String get m0601Recentrar;

  /// M06-01 acción de TalkBack del tirador de la hoja (M9)
  ///
  /// In es, this message translates to:
  /// **'Expandir lista'**
  String get m0601ExpandirLista;

  /// M06-01 acción de TalkBack del tirador de la hoja (M9)
  ///
  /// In es, this message translates to:
  /// **'Contraer lista'**
  String get m0601ContraerLista;

  /// M06-01 subtítulo de la hoja expandida (M9)
  ///
  /// In es, this message translates to:
  /// **'Más prestadores en tu ciudad'**
  String get m0601MasPrestadores;

  /// M06-01 tiempo aproximado de los que no son de los 3 (M9)
  ///
  /// In es, this message translates to:
  /// **'~{tiempo}'**
  String m0601Aproximado(String tiempo);

  /// Detalle del prestador (2.2): tipo y especialidad
  ///
  /// In es, this message translates to:
  /// **'{tipo} · {especialidad}'**
  String m0601DetalleTipo(String tipo, String especialidad);

  /// Detalle del prestador (2.2): distancia y llegada
  ///
  /// In es, this message translates to:
  /// **'{distancia} · llega en {tiempo}'**
  String m0601DetalleLlegada(String distancia, String tiempo);

  /// Detalle del prestador (2.2): botón primario
  ///
  /// In es, this message translates to:
  /// **'Solicitar asistencia'**
  String get m0601SolicitarAsistencia;

  /// Detalle del prestador (2.2): botón secundario (M13)
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar'**
  String get m0601ComoLlegarBoton;

  /// Aviso al copiar la dirección
  ///
  /// In es, this message translates to:
  /// **'Dirección copiada'**
  String get m0601DireccionCopiada;

  /// Pista de TalkBack de la dirección del prestador
  ///
  /// In es, this message translates to:
  /// **'Mantén pulsado para copiar la dirección'**
  String get m0601CopiarDireccion;

  /// Aviso sin app de mapas (M13): copiar la dirección
  ///
  /// In es, this message translates to:
  /// **'Copiar'**
  String get m0601Copiar;

  /// Aviso sin app de mapas (M13)
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get m0601Cerrar;

  /// 2.0 explicación antes del diálogo del sistema
  ///
  /// In es, this message translates to:
  /// **'Necesitamos tu ubicación'**
  String get ubicacionExplicaTitulo;

  /// 2.0 explicación
  ///
  /// In es, this message translates to:
  /// **'Para mostrarte los prestadores más cercanos y cuánto tardan en llegar.'**
  String get ubicacionExplicaTexto;

  /// 2.0 botón principal
  ///
  /// In es, this message translates to:
  /// **'Permitir ubicación'**
  String get ubicacionPermitir;

  /// 2.0 permiso negado
  ///
  /// In es, this message translates to:
  /// **'No tenemos tu ubicación'**
  String get ubicacionNegadaTitulo;

  /// 2.0 permiso negado
  ///
  /// In es, this message translates to:
  /// **'Puedes darnos el permiso o escribir dónde estás. Con la dirección te mostramos los mismos prestadores.'**
  String get ubicacionNegadaTexto;

  /// 2.0 permiso negado para siempre
  ///
  /// In es, this message translates to:
  /// **'Abrir Ajustes'**
  String get ubicacionAbrirAjustes;

  /// 2.0 GPS apagado
  ///
  /// In es, this message translates to:
  /// **'Tu GPS está apagado'**
  String get gpsApagadoTitulo;

  /// 2.0 GPS apagado
  ///
  /// In es, this message translates to:
  /// **'Enciende la ubicación del teléfono para encontrar los prestadores cerca de ti.'**
  String get gpsApagadoTexto;

  /// 2.0 GPS apagado: abre los ajustes de ubicación
  ///
  /// In es, this message translates to:
  /// **'Activar ubicación'**
  String get gpsActivar;

  /// 2.0 botón secundario
  ///
  /// In es, this message translates to:
  /// **'Escribir mi dirección'**
  String get direccionEscribir;

  /// 2.0 hoja para escribir la dirección
  ///
  /// In es, this message translates to:
  /// **'¿Dónde estás?'**
  String get direccionTitulo;

  /// 2.0 campo de la dirección
  ///
  /// In es, this message translates to:
  /// **'Dirección, ciudad o punto de referencia'**
  String get direccionCampo;

  /// 2.0 enviar el texto escrito sin elegir sugerencia
  ///
  /// In es, this message translates to:
  /// **'Buscar esta dirección'**
  String get direccionBuscar;

  /// 2.0 ubicarDireccion: DIRECCION_NO_ENCONTRADA
  ///
  /// In es, this message translates to:
  /// **'No pudimos ubicar esa dirección. Prueba con otra o con un punto de referencia'**
  String get direccionNoEncontrada;

  /// 2.0 ubicarDireccion: SERVICIO_NO_DISPONIBLE o sin red
  ///
  /// In es, this message translates to:
  /// **'No pudimos buscar direcciones ahora. Intenta de nuevo'**
  String get direccionServicioCaido;

  /// 2.0 aviso sobre el mapa con la dirección escrita
  ///
  /// In es, this message translates to:
  /// **'Usando: {direccion}'**
  String direccionUsando(String direccion);

  /// 2.0 aviso: volver a escribir la dirección
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get direccionCambiar;

  /// 2.0 aviso: el permiso se dio al volver de Ajustes
  ///
  /// In es, this message translates to:
  /// **'Usar mi ubicación actual'**
  String get direccionUsarActual;

  /// 2.0 etiqueta del pin del cliente
  ///
  /// In es, this message translates to:
  /// **'Dirección escrita'**
  String get direccionPinEtiqueta;

  /// Inicio: entrada a HU-M05
  ///
  /// In es, this message translates to:
  /// **'Reportar un siniestro'**
  String get homeReportarTile;

  /// M05 título de la barra
  ///
  /// In es, this message translates to:
  /// **'Reportar siniestro'**
  String get m05Titulo;

  /// M05 botón continuar
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get m05Continuar;

  /// M05 reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get m05Reintentar;

  /// M05-01 sección póliza
  ///
  /// In es, this message translates to:
  /// **'¿Sobre qué póliza?'**
  String get m0501Poliza;

  /// M05-01 fila de póliza
  ///
  /// In es, this message translates to:
  /// **'Póliza {numero}'**
  String m0501PolizaNumero(String numero);

  /// M05-01 vigencia de la póliza
  ///
  /// In es, this message translates to:
  /// **'Vigente hasta el {fecha}'**
  String m0501Vigencia(String fecha);

  /// M05-01 cargando
  ///
  /// In es, this message translates to:
  /// **'Buscando tus pólizas…'**
  String get m0501Cargando;

  /// M05-01 sin pólizas
  ///
  /// In es, this message translates to:
  /// **'No tienes pólizas de auto emitidas sobre las que reportar.'**
  String get m0501SinPolizas;

  /// M05-01 campo fecha
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo pasó?'**
  String get m0501Fecha;

  /// M05-01 fecha fuera de vigencia
  ///
  /// In es, this message translates to:
  /// **'Esa fecha está fuera de la vigencia de la póliza.'**
  String get m0501FechaFuera;

  /// M05-01 fecha anterior al inicio de la vigencia
  ///
  /// In es, this message translates to:
  /// **'Tu póliza empezó a cubrirte el {desde}. Elige una fecha y hora desde ese momento.'**
  String m0501FechaAntes(String desde);

  /// M05-01 valor del campo fecha sin elegir
  ///
  /// In es, this message translates to:
  /// **'Elige el día y la hora'**
  String get m0501FechaElegir;

  /// M05-01 ayuda del campo fecha sin póliza elegida
  ///
  /// In es, this message translates to:
  /// **'Primero elige la póliza afectada.'**
  String get m0501ElegirPoliza;

  /// M05-01 ayuda del campo fecha con el inicio de la vigencia
  ///
  /// In es, this message translates to:
  /// **'Tu póliza cubre desde el {desde}.'**
  String m0501CubreDesde(String desde);

  /// M05-02 título
  ///
  /// In es, this message translates to:
  /// **'Fotos del daño'**
  String get m0502Titulo;

  /// M05-02 instrucción
  ///
  /// In es, this message translates to:
  /// **'Toma de 1 a 3 fotos del daño. Cada foto guarda dónde la tomaste.'**
  String get m0502Instruccion;

  /// M05-02 botón de captura
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get m0502Tomar;

  /// M05-02 contador de fotos
  ///
  /// In es, this message translates to:
  /// **'{cantidad} de 3 fotos'**
  String m0502Contador(int cantidad);

  /// M05-02 lectura del botón quitar
  ///
  /// In es, this message translates to:
  /// **'Quitar la foto {numero}'**
  String m0502Quitar(int numero);

  /// M05-02 ubicación obtenida
  ///
  /// In es, this message translates to:
  /// **'Ubicación lista: tus fotos quedan geoetiquetadas.'**
  String get m0502Ubicada;

  /// M05-02 sin permiso de ubicación
  ///
  /// In es, this message translates to:
  /// **'No tenemos tu GPS. Actívalo o escribe la dirección donde pasó el siniestro.'**
  String get m0502SinUbicacion;

  /// M05-02 reintentar permiso
  ///
  /// In es, this message translates to:
  /// **'Permitir ubicación'**
  String get m0502PermitirUbicacion;

  /// M05-02 abrir ajustes
  ///
  /// In es, this message translates to:
  /// **'Abrir ajustes'**
  String get m0502AbrirAjustes;

  /// M05-02 sin cámara
  ///
  /// In es, this message translates to:
  /// **'No pudimos usar la cámara. Revisa el permiso de cámara e inténtalo de nuevo.'**
  String get m0502CamaraNoDisponible;

  /// M05-02 lectura del visor
  ///
  /// In es, this message translates to:
  /// **'Visor de la cámara'**
  String get m0502Visor;

  /// M05-03 título
  ///
  /// In es, this message translates to:
  /// **'¿Qué pasó?'**
  String get m0503Titulo;

  /// M05-03 campo relato
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos qué pasó'**
  String get m0503Relato;

  /// M05-03 ayuda del relato
  ///
  /// In es, this message translates to:
  /// **'De 10 a 1000 caracteres.'**
  String get m0503RelatoAyuda;

  /// M05-03 campo lugar
  ///
  /// In es, this message translates to:
  /// **'¿Dónde pasó?'**
  String get m0503Lugar;

  /// M05-03 ayuda del lugar
  ///
  /// In es, this message translates to:
  /// **'Dirección o punto de referencia.'**
  String get m0503LugarAyuda;

  /// M05-03 campo ciudad
  ///
  /// In es, this message translates to:
  /// **'Ciudad'**
  String get m0503Ciudad;

  /// M05-03 campo obligatorio
  ///
  /// In es, this message translates to:
  /// **'Completa este campo.'**
  String get m0503Requerido;

  /// M05-03 botón enviar
  ///
  /// In es, this message translates to:
  /// **'Enviar reporte'**
  String get m0503Enviar;

  /// M05-04 título
  ///
  /// In es, this message translates to:
  /// **'Enviando tu reporte'**
  String get m0504Titulo;

  /// M05-04 mensaje
  ///
  /// In es, this message translates to:
  /// **'Estamos subiendo tus fotos y registrando tu caso…'**
  String get m0504Mensaje;

  /// M05-05 título de éxito
  ///
  /// In es, this message translates to:
  /// **'Recibimos tu reporte'**
  String get m0505Exito;

  /// M05-05 mensaje de éxito
  ///
  /// In es, this message translates to:
  /// **'Tu caso {radicado} quedó pendiente de revisión. Te daremos una respuesta a más tardar el {fecha}.'**
  String m0505ExitoMensaje(String radicado, String fecha);

  /// M05-05 título de error
  ///
  /// In es, this message translates to:
  /// **'No pudimos enviar tu reporte'**
  String get m0505Error;

  /// M05-05 volver al inicio
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio'**
  String get m0505VolverInicio;

  /// M05-05 volver a corregir
  ///
  /// In es, this message translates to:
  /// **'Revisar el reporte'**
  String get m0505Revisar;

  /// M05-05 foto sin confirmar
  ///
  /// In es, this message translates to:
  /// **'Una de las fotos no se subió bien. Tómala de nuevo.'**
  String get m0505FotoNoConfirmada;

  /// Inicio: entrada a M05-06
  ///
  /// In es, this message translates to:
  /// **'Mis siniestros'**
  String get homeMisSiniestrosTile;

  /// Inicio: entrada a M04-04 (HU-M04)
  ///
  /// In es, this message translates to:
  /// **'Mi cobertura'**
  String get homeMiCoberturaTile;

  /// M05-05 enlace a M05-06
  ///
  /// In es, this message translates to:
  /// **'Ver mis siniestros'**
  String get m0505VerMisSiniestros;

  /// M05-06 título
  ///
  /// In es, this message translates to:
  /// **'Mis siniestros'**
  String get m0506Titulo;

  /// M05-06 cargando
  ///
  /// In es, this message translates to:
  /// **'Buscando tus reportes…'**
  String get m0506Cargando;

  /// M05-06 lista vacía
  ///
  /// In es, this message translates to:
  /// **'Aún no has reportado siniestros.'**
  String get m0506Vacio;

  /// M05-06 fecha y fotos del caso
  ///
  /// In es, this message translates to:
  /// **'Reportado el {fecha} · {fotos, plural, =1{1 foto} other{{fotos} fotos}}'**
  String m0506Reportado(String fecha, int fotos);

  /// M05-06 estado PENDIENTE
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get m0506Pendiente;

  /// M05-06 detalle PENDIENTE
  ///
  /// In es, this message translates to:
  /// **'Lo revisaremos a más tardar el {fecha}.'**
  String m0506PendienteDetalle(String fecha);

  /// M05-06 estado EN_REVISION
  ///
  /// In es, this message translates to:
  /// **'En revisión'**
  String get m0506EnRevision;

  /// M05-06 detalle EN_REVISION
  ///
  /// In es, this message translates to:
  /// **'Un perito está evaluando tu caso.'**
  String get m0506EnRevisionDetalle;

  /// M05-06 estado APROBADO
  ///
  /// In es, this message translates to:
  /// **'Aprobado'**
  String get m0506Aprobado;

  /// M05-06 detalle APROBADO
  ///
  /// In es, this message translates to:
  /// **'Tu indemnización está en proceso de pago.'**
  String get m0506AprobadoDetalle;

  /// M05-06 estado RECHAZADO
  ///
  /// In es, this message translates to:
  /// **'Rechazado'**
  String get m0506Rechazado;

  /// M05-06 detalle RECHAZADO
  ///
  /// In es, this message translates to:
  /// **'Te enviamos el motivo y cómo presentar un recurso.'**
  String get m0506RechazadoDetalle;

  /// M06-02 título de la barra
  ///
  /// In es, this message translates to:
  /// **'Solicitar asistencia'**
  String get m0602Titulo;

  /// M06-02 rótulo de la tarjeta del prestador
  ///
  /// In es, this message translates to:
  /// **'Prestador asignado'**
  String get m0602PrestadorAsignado;

  /// M06-02 etiqueta del selector
  ///
  /// In es, this message translates to:
  /// **'Tipo de asistencia'**
  String get m0602Tipo;

  /// M06-02 opción del selector
  ///
  /// In es, this message translates to:
  /// **'Médica'**
  String get m0602TipoMedica;

  /// M06-02 opción del selector
  ///
  /// In es, this message translates to:
  /// **'Mecánica'**
  String get m0602TipoMecanica;

  /// M06-02 opción del selector (v0.49)
  ///
  /// In es, this message translates to:
  /// **'Grúa'**
  String get m0602TipoGrua;

  /// M06-02 selector sin valor
  ///
  /// In es, this message translates to:
  /// **'Elige una opción'**
  String get m0602TipoElegir;

  /// M06-02 banner (S2)
  ///
  /// In es, this message translates to:
  /// **'Atención inmediata'**
  String get m0602AtencionInmediata;

  /// M06-02 banner (S2)
  ///
  /// In es, this message translates to:
  /// **'Estamos coordinando tu solicitud en tiempo real'**
  String get m0602AtencionInmediataTexto;

  /// M06-02 con la dirección escrita (S1)
  ///
  /// In es, this message translates to:
  /// **'{direccion} (la dirección que escribiste)'**
  String m0602UbicacionEscrita(String direccion);

  /// M06-02 error del selector vacío
  ///
  /// In es, this message translates to:
  /// **'Elige el tipo de asistencia.'**
  String get m0602TipoRequerido;

  /// M06-02 y M06-04b: el prestador no atiende el tipo elegido
  ///
  /// In es, this message translates to:
  /// **'{nombre} no atiende este tipo de asistencia. Elige otro prestador en el mapa.'**
  String m0602TipoNoAtendido(String nombre);

  /// M06-02 etiqueta de la descripción (opcional)
  ///
  /// In es, this message translates to:
  /// **'Describe brevemente qué pasó'**
  String get m0602Descripcion;

  /// M06-02 ejemplo de la descripción
  ///
  /// In es, this message translates to:
  /// **'Ej. dolor en el pecho, mareo…'**
  String get m0602DescripcionHint;

  /// M06-02 error de texto largo
  ///
  /// In es, this message translates to:
  /// **'Usa máximo {maximo} caracteres.'**
  String m0602TextoLargo(int maximo);

  /// M06-02 ubicación del GPS que se enviará
  ///
  /// In es, this message translates to:
  /// **'Ubicación detectada automáticamente: {coordenadas}'**
  String m0602UbicacionDetectada(String coordenadas);

  /// M06-02 tiempo del prestador elegido
  ///
  /// In es, this message translates to:
  /// **'Tiempo estimado de llegada: {tiempo}'**
  String m0602TiempoLlegada(String tiempo);

  /// M06-02 botón principal
  ///
  /// In es, this message translates to:
  /// **'Enviar solicitud'**
  String get m0602Enviar;

  /// M06-03 estado transitorio
  ///
  /// In es, this message translates to:
  /// **'Confirmando disponibilidad con {nombre}…'**
  String m0603Mensaje(String nombre);

  /// M06-03b estado transitorio del reintento
  ///
  /// In es, this message translates to:
  /// **'Reenviando tu solicitud a {nombre}…'**
  String m0603bMensaje(String nombre);

  /// M06-04a título del éxito
  ///
  /// In es, this message translates to:
  /// **'Solicitud confirmada'**
  String get m0604aTitulo;

  /// M06-04a pedida con la dirección a mano: sin coordenadas no hay tiempo estimado
  ///
  /// In es, this message translates to:
  /// **'{nombre} está en camino a la dirección que indicaste.'**
  String m0604aMensajeSinTiempo(String nombre);

  /// M06-04a detalle; el tiempo se lee completo, sin abreviar
  ///
  /// In es, this message translates to:
  /// **'{nombre} está en camino. Llegada estimada en {minutos} minutos.'**
  String m0604aMensaje(String nombre, int minutos);

  /// M06-04a abre la ruta al prestador
  ///
  /// In es, this message translates to:
  /// **'Ver en el mapa'**
  String get m0604aVerMapa;

  /// M06-04a acción destructiva
  ///
  /// In es, this message translates to:
  /// **'Cancelar asistencia'**
  String get m0604aCancelar;

  /// M06-04a aviso si cancelar falla
  ///
  /// In es, this message translates to:
  /// **'No pudimos cancelar la asistencia. Intenta de nuevo.'**
  String get m0604aCancelarFallo;

  /// M06-04b título del fallo
  ///
  /// In es, this message translates to:
  /// **'No pudimos confirmar tu solicitud'**
  String get m0604bTitulo;

  /// M06-04b causa PRESTADOR_SIN_RESPUESTA
  ///
  /// In es, this message translates to:
  /// **'{nombre} no respondió a tiempo. Puedes elegir otro prestador o intentar de nuevo.'**
  String m0604bSinRespuesta(String nombre);

  /// M06-04b causa PRESTADOR_NO_DISPONIBLE
  ///
  /// In es, this message translates to:
  /// **'{nombre} ya no está disponible. Elige otro prestador cercano.'**
  String m0604bNoDisponible(String nombre);

  /// M06-04b vuelve al mapa
  ///
  /// In es, this message translates to:
  /// **'Elegir otro prestador'**
  String get m0604bElegirOtro;

  /// M06-04b reenvía los mismos datos (M06-03b)
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get m0604bReintentar;

  /// M06-05 título del diálogo
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres cancelar?'**
  String get m0605Titulo;

  /// M06-05 consecuencia de cancelar
  ///
  /// In es, this message translates to:
  /// **'{nombre} ya está en camino. Si cancelas ahora, tendrás que solicitar asistencia de nuevo desde cero.'**
  String m0605Mensaje(String nombre);

  /// M06-05 acción destructiva
  ///
  /// In es, this message translates to:
  /// **'Sí, cancelar'**
  String get m0605Confirmar;

  /// M06-05 acción segura
  ///
  /// In es, this message translates to:
  /// **'No, mantener solicitud'**
  String get m0605Mantener;

  /// M06-06 título de la barra
  ///
  /// In es, this message translates to:
  /// **'Cancelar asistencia'**
  String get m0606Titulo;

  /// M06-06 confirmación explícita de la cancelación
  ///
  /// In es, this message translates to:
  /// **'Tu solicitud fue cancelada. El servicio asignado quedó sin efecto y no se realizarán cobros asociados a esta solicitud.'**
  String get m0606Mensaje;

  /// M06-06 acción principal
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio'**
  String get m0606VolverInicio;

  /// M06-06 vuelve al mapa de prestadores
  ///
  /// In es, this message translates to:
  /// **'Solicitar de nuevo'**
  String get m0606SolicitarDeNuevo;

  /// Barra inferior: destino «Mis asistencias» (HU-M06 4.1)
  ///
  /// In es, this message translates to:
  /// **'Mis asistencias'**
  String get navMisAsistencias;

  /// TalkBack del destino con badge (4.1)
  ///
  /// In es, this message translates to:
  /// **'Mis asistencias, {cantidad} en camino'**
  String navMisAsistenciasEnCamino(String cantidad);

  /// 4.1 título de la pestaña
  ///
  /// In es, this message translates to:
  /// **'Mis asistencias'**
  String get misAsistenciasTitulo;

  /// 4.1 estado vacío
  ///
  /// In es, this message translates to:
  /// **'Aún no has pedido asistencia'**
  String get misAsistenciasVacio;

  /// 4.1 estado vacío: va a la pestaña Asistencia
  ///
  /// In es, this message translates to:
  /// **'Solicitar asistencia en sitio'**
  String get misAsistenciasSolicitar;

  /// 4.1 acordeón (A7)
  ///
  /// In es, this message translates to:
  /// **'En camino ({cantidad})'**
  String misAsistenciasEnCamino(String cantidad);

  /// 4.1 acordeón (A7)
  ///
  /// In es, this message translates to:
  /// **'Ya llegaron ({cantidad})'**
  String misAsistenciasYaLlegaron(String cantidad);

  /// 4.1 error al cargar
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar tus asistencias.'**
  String get misAsistenciasError;

  /// 4.1 cargando la lista o el detalle
  ///
  /// In es, this message translates to:
  /// **'Cargando tus asistencias…'**
  String get misAsistenciasCargando;

  /// 4.2 subtítulo de la tarjeta
  ///
  /// In es, this message translates to:
  /// **'{tipo} · pedida {hora}'**
  String asistenciaPedida(String tipo, String hora);

  /// 4.2 cuenta regresiva
  ///
  /// In es, this message translates to:
  /// **'Llega en {minutos} min'**
  String asistenciaLlegaEn(String minutos);

  /// 4.2 cuenta regresiva bajo 1 min
  ///
  /// In es, this message translates to:
  /// **'Llega en menos de 1 min'**
  String get asistenciaLlegaMenosDeUno;

  /// 4.2 hora estimada
  ///
  /// In es, this message translates to:
  /// **'Hora estimada {hora}'**
  String asistenciaHoraEstimada(String hora);

  /// 4.2 insignia ya llegó
  ///
  /// In es, this message translates to:
  /// **'Llegó · {hora}'**
  String asistenciaLlego(String hora);

  /// 4.2 aviso de no confirmada
  ///
  /// In es, this message translates to:
  /// **'No pudimos confirmar'**
  String get asistenciaNoConfirmada;

  /// 4.2 reintentar (reenvío de M06-03b)
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get asistenciaReintentar;

  /// 4.4 estado en el detalle
  ///
  /// In es, this message translates to:
  /// **'En camino · llega en {minutos} min'**
  String asistenciaEnCaminoLlega(String minutos);

  /// 4.5 título de la notificación
  ///
  /// In es, this message translates to:
  /// **'Tu asistencia llegó'**
  String get asistenciaNotifTitulo;

  /// 4.5 cuerpo de la notificación
  ///
  /// In es, this message translates to:
  /// **'{prestador} ya debería estar en tu ubicación'**
  String asistenciaNotifCuerpo(String prestador);

  /// 4.5 línea antes de pedir el permiso de notificaciones
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos cuando llegue el prestador.'**
  String get asistenciaNotifNota;

  /// 4.5 aviso con la app abierta
  ///
  /// In es, this message translates to:
  /// **'{prestador} llegó'**
  String asistenciaLlegoSnack(String prestador);

  /// 4.5 acción del aviso
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get asistenciaVer;

  /// 4.4 título del detalle
  ///
  /// In es, this message translates to:
  /// **'Tu asistencia'**
  String get asistenciaDetalleTitulo;

  /// 4.4b aviso
  ///
  /// In es, this message translates to:
  /// **'Te alejaste del lugar donde pediste la asistencia. El prestador va a {direccion}'**
  String asistenciaTeAlejaste(String direccion);

  /// 4.4b sin dirección escrita
  ///
  /// In es, this message translates to:
  /// **'el lugar donde la pediste'**
  String get asistenciaLugarPedido;

  /// 4.4b acción
  ///
  /// In es, this message translates to:
  /// **'Cancelar y pedir otra'**
  String get asistenciaCancelarYPedirOtra;

  /// 4.2 lectura de TalkBack de la tarjeta
  ///
  /// In es, this message translates to:
  /// **'{prestador}, {tipo}, {estado}'**
  String asistenciaLectura(String prestador, String tipo, String estado);

  /// 4.4 detalle: ajena o inexistente
  ///
  /// In es, this message translates to:
  /// **'No encontramos esa asistencia.'**
  String get asistenciaNoEncontrada;

  /// M04-02: título de la barra
  ///
  /// In es, this message translates to:
  /// **'Indemnización'**
  String get m0402Titulo;

  /// M04-02: mensaje de celebración
  ///
  /// In es, this message translates to:
  /// **'¡Tu indemnización ya está en camino!'**
  String get m0402Mensaje;

  /// M04-02: monto depositado
  ///
  /// In es, this message translates to:
  /// **'{monto} depositados'**
  String m0402Monto(String monto);

  /// M04-02: método de transferencia
  ///
  /// In es, this message translates to:
  /// **'Pagado por {metodo}'**
  String m0402Cuenta(String metodo);

  /// M04-02: botón al detalle
  ///
  /// In es, this message translates to:
  /// **'Ver detalle'**
  String get m0402VerDetalle;

  /// M04-02 y M04-03: cargando
  ///
  /// In es, this message translates to:
  /// **'Consultando tu indemnización…'**
  String get m0402Cargando;

  /// M04-03: título de la barra
  ///
  /// In es, this message translates to:
  /// **'Detalle de la indemnización'**
  String get m0403Titulo;

  /// M04-03: cabecera para retraso de vuelo
  ///
  /// In es, this message translates to:
  /// **'Evento detectado: retraso de vuelo {ref} ({detalle})'**
  String m0403EventoRetrasoVuelo(String ref, String detalle);

  /// M04-03: cabecera para cancelación de vuelo
  ///
  /// In es, this message translates to:
  /// **'Evento detectado: cancelación de vuelo {ref}'**
  String m0403EventoCancelacionVuelo(String ref);

  /// M04-03: cabecera para lluvia
  ///
  /// In es, this message translates to:
  /// **'Evento detectado: lluvia sobre el umbral en {ciudad} ({detalle})'**
  String m0403EventoLluvia(String ciudad, String detalle);

  /// M04-03: fila del monto
  ///
  /// In es, this message translates to:
  /// **'Indemnización'**
  String get m0403Indemnizacion;

  /// M04-03: fila
  ///
  /// In es, this message translates to:
  /// **'Fecha del evento'**
  String get m0403FechaEvento;

  /// M04-03: fila
  ///
  /// In es, this message translates to:
  /// **'Fecha de pago'**
  String get m0403FechaPago;

  /// M04-03: fila
  ///
  /// In es, this message translates to:
  /// **'Método de pago'**
  String get m0403Cuenta;

  /// M04-03: insignia de éxito
  ///
  /// In es, this message translates to:
  /// **'Pago procesado automáticamente'**
  String get m0403Automatico;

  /// M04-03: botón principal
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get m0403Cerrar;

  /// M04-04: título de la barra
  ///
  /// In es, this message translates to:
  /// **'Mi cobertura'**
  String get m0404Titulo;

  /// M04-04: cargando
  ///
  /// In es, this message translates to:
  /// **'Consultando tu cobertura…'**
  String get m0404Cargando;

  /// M04-04: producto y estado de la póliza
  ///
  /// In es, this message translates to:
  /// **'{producto} · {estado}'**
  String m0404Producto(String producto, String estado);

  /// M04-04: estado de la póliza
  ///
  /// In es, this message translates to:
  /// **'Vigente'**
  String get m0404Vigente;

  /// M04-04: estado de la póliza
  ///
  /// In es, this message translates to:
  /// **'Vencida'**
  String get m0404Vencida;

  /// M04-04: número y vigencia
  ///
  /// In es, this message translates to:
  /// **'Póliza {numero} · hasta {fecha}'**
  String m0404Poliza(String numero, String fecha);

  /// M04-04: etiqueta del tope
  ///
  /// In es, this message translates to:
  /// **'Tope de cobertura'**
  String get m0404Tope;

  /// M04-04: porcentaje usado (también lectura de la barra)
  ///
  /// In es, this message translates to:
  /// **'{porcentaje} % del tope usado'**
  String m0404PorcentajeUsado(int porcentaje);

  /// M04-04: etiqueta del disponible
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get m0404Disponible;

  /// M04-04: etiqueta del total
  ///
  /// In es, this message translates to:
  /// **'Total indemnizado'**
  String get m0404TotalIndemnizado;

  /// M04-04: explicación del total
  ///
  /// In es, this message translates to:
  /// **'Suma de {pagos, plural, =1{el pago que has recibido} other{los {pagos} pagos que has recibido}} desde {mes}, en todas tus pólizas.'**
  String m0404TotalDetalle(int pagos, String mes);

  /// M04-04: método de transferencia del último pago
  ///
  /// In es, this message translates to:
  /// **'Pagado por {metodo}'**
  String m0404Depositado(String metodo);

  /// M04-04: saldo de prima a favor (el signo va en el texto, no solo el color)
  ///
  /// In es, this message translates to:
  /// **'+ {monto} a tu favor'**
  String m0404SaldoFavor(String monto);

  /// M04-04: detalle del saldo a favor
  ///
  /// In es, this message translates to:
  /// **'Ajuste de prima de {mes}. Se descuenta de tu próximo cobro.'**
  String m0404SaldoFavorDetalle(String mes);

  /// M04-04: saldo de prima en contra (U+2212)
  ///
  /// In es, this message translates to:
  /// **'− {monto} pendiente'**
  String m0404SaldoContra(String monto);

  /// M04-04: detalle del saldo en contra
  ///
  /// In es, this message translates to:
  /// **'Diferencia de prima de {mes}. Se suma a tu próximo cobro.'**
  String m0404SaldoContraDetalle(String mes);

  /// M04-04: encabezado de la lista
  ///
  /// In es, this message translates to:
  /// **'Movimientos indemnizados'**
  String get m0404Movimientos;

  /// M04-04: número de pagos
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 pago} other{{n} pagos}}'**
  String m0404Pagos(int n);

  /// M04-04: estado del pago
  ///
  /// In es, this message translates to:
  /// **'Pagado'**
  String get m0404Pagado;

  /// M04-04: estado del pago
  ///
  /// In es, this message translates to:
  /// **'En proceso'**
  String get m0404EnProceso;

  /// M04-04: meta de un pago de una póliza vencida
  ///
  /// In es, this message translates to:
  /// **'póliza anterior'**
  String get m0404PolizaAnterior;

  /// M04-04: fecha y detalle de la fila
  ///
  /// In es, this message translates to:
  /// **'{fecha} · {detalle}'**
  String m0404Meta(String fecha, String detalle);

  /// M04-04: nota al pie
  ///
  /// In es, this message translates to:
  /// **'El tope se reinicia con cada renovación. Los pagos de pólizas anteriores no descuentan del cupo actual.'**
  String get m0404Nota;

  /// M04-04: sin movimientos
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes pagos indemnizados.'**
  String get m0404Vacio;

  /// M04: reintentar tras un error
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get m04Reintentar;

  /// M04: título del evento
  ///
  /// In es, this message translates to:
  /// **'Retraso de vuelo {ref}'**
  String m04EventoRetrasoVuelo(String ref);

  /// M04: título del evento
  ///
  /// In es, this message translates to:
  /// **'Cancelación de vuelo {ref}'**
  String m04EventoCancelacionVuelo(String ref);

  /// M04: título del evento
  ///
  /// In es, this message translates to:
  /// **'Lluvia sobre el umbral'**
  String get m04EventoLluvia;

  /// M04: ciudad y milímetros de lluvia
  ///
  /// In es, this message translates to:
  /// **'{ciudad}, {detalle}'**
  String m04DetalleLluvia(String ciudad, String detalle);

  /// M04-02: lectura de TalkBack del método de transferencia
  ///
  /// In es, this message translates to:
  /// **'Pagado por {metodo}'**
  String m0402CuentaSemantica(String metodo);

  /// M05-01 (KAN-290): una póliza de auto, con la marca y la placa enmascarada
  ///
  /// In es, this message translates to:
  /// **'Auto {vehiculo}'**
  String m0501PolizaAuto(String vehiculo);

  /// No description provided for @m0501QuePaso.
  ///
  /// In es, this message translates to:
  /// **'¿Qué le pasó al vehículo?'**
  String get m0501QuePaso;

  /// No description provided for @m0501ElegirTipo.
  ///
  /// In es, this message translates to:
  /// **'Elige qué le pasó al vehículo para continuar.'**
  String get m0501ElegirTipo;

  /// No description provided for @m05TipoChoqueParcial.
  ///
  /// In es, this message translates to:
  /// **'Choque con daños que se pueden reparar'**
  String get m05TipoChoqueParcial;

  /// No description provided for @m05TipoPerdidaTotal.
  ///
  /// In es, this message translates to:
  /// **'Pérdida total por un choque'**
  String get m05TipoPerdidaTotal;

  /// No description provided for @m05TipoHurtoTotal.
  ///
  /// In es, this message translates to:
  /// **'Me robaron el vehículo'**
  String get m05TipoHurtoTotal;

  /// No description provided for @m05TipoHurtoParcial.
  ///
  /// In es, this message translates to:
  /// **'Me robaron partes del vehículo'**
  String get m05TipoHurtoParcial;

  /// No description provided for @m05TipoResponsabilidadCivil.
  ///
  /// In es, this message translates to:
  /// **'Le causé daños a otra persona o vehículo'**
  String get m05TipoResponsabilidadCivil;

  /// No description provided for @cuentaOlvideClave.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get cuentaOlvideClave;

  /// No description provided for @m0204Titulo.
  ///
  /// In es, this message translates to:
  /// **'Recupera tu contraseña'**
  String get m0204Titulo;

  /// No description provided for @m0204Intro.
  ///
  /// In es, this message translates to:
  /// **'Escribe el correo de tu cuenta y, si existe, te enviaremos un enlace para elegir una contraseña nueva.'**
  String get m0204Intro;

  /// No description provided for @m0204Enviar.
  ///
  /// In es, this message translates to:
  /// **'Enviar enlace'**
  String get m0204Enviar;

  /// No description provided for @m0204EnviadoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu correo'**
  String get m0204EnviadoTitulo;

  /// No description provided for @m0204EnviadoTexto.
  ///
  /// In es, this message translates to:
  /// **'Si hay una cuenta con ese correo, te enviamos un enlace. Ábrelo para elegir tu contraseña nueva; vence en 30 minutos y sirve una sola vez.'**
  String get m0204EnviadoTexto;

  /// No description provided for @m0204Volver.
  ///
  /// In es, this message translates to:
  /// **'Volver a iniciar sesión'**
  String get m0204Volver;

  /// Botón de «Inicia sesión» para entrar con la llave del teléfono, según su método
  ///
  /// In es, this message translates to:
  /// **'{tipo, select, huella{Ingresar con huella} rostro{Ingresar con rostro} bloqueo{Ingresar con el bloqueo del teléfono} other{Ingresar con la seguridad del teléfono}}'**
  String cuentaIngresarConHuella(String tipo);

  /// No description provided for @accesoBiometricoMotivo.
  ///
  /// In es, this message translates to:
  /// **'Confirma que eres tú para entrar a Solventa'**
  String get accesoBiometricoMotivo;

  /// No description provided for @accesoBiometricoActivarMotivo.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu huella o rostro para entrar sin escribir la contraseña'**
  String get accesoBiometricoActivarMotivo;

  /// No description provided for @fallaDispositivoNoValido.
  ///
  /// In es, this message translates to:
  /// **'No pudimos verificar este teléfono. Ingresa con tu correo y contraseña.'**
  String get fallaDispositivoNoValido;

  /// M01-05 botón que toma la selfie y graba el video
  ///
  /// In es, this message translates to:
  /// **'Grabar video'**
  String get m0105Grabar;

  /// M01-05 etiqueta sobre el visor mientras graba
  ///
  /// In es, this message translates to:
  /// **'Grabando'**
  String get m0105Grabando;

  /// M01-05 instrucción mientras graba, con la cuenta regresiva
  ///
  /// In es, this message translates to:
  /// **'Mueve la cabeza despacio de un lado a otro… {segundos}'**
  String m0105GrabandoInstruccion(int segundos);

  /// M01-05 capturas tomadas (la cámara ya se cerró)
  ///
  /// In es, this message translates to:
  /// **'Listo, ya tenemos tu selfie y tu video.'**
  String get m0105Capturado;

  /// M01-05 mientras sube y espera a Didit
  ///
  /// In es, this message translates to:
  /// **'Estamos enviando tus fotos y verificando tu identidad con nuestro proveedor. Puede tardar unos segundos.'**
  String get m0105Verificando;

  /// Inicio: cargando perfil y verificación (TalkBack)
  ///
  /// In es, this message translates to:
  /// **'Cargando tu cuenta…'**
  String get homeCargandoCuenta;

  /// Inicio: no cargó el perfil ni la verificación
  ///
  /// In es, this message translates to:
  /// **'No pudimos cargar la información de tu cuenta. Revisa tu conexión e inténtalo de nuevo.'**
  String get homeCuentaSinCargar;

  /// Inicio: reintentar la carga de la cuenta
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get homeReintentarCuenta;

  /// M05-07 título
  ///
  /// In es, this message translates to:
  /// **'Detalle del siniestro'**
  String get m0507Titulo;

  /// M05-07 caso no está en la lista
  ///
  /// In es, this message translates to:
  /// **'No encontramos este siniestro.'**
  String get m0507NoEncontrado;

  /// M05-07 fecha del siniestro
  ///
  /// In es, this message translates to:
  /// **'Ocurrió el {fecha}'**
  String m0507Ocurrio(String fecha);

  /// M05-07 título del bloque de resolución
  ///
  /// In es, this message translates to:
  /// **'Resolución'**
  String get m0507Resolucion;

  /// M05-07 fecha de la resolución
  ///
  /// In es, this message translates to:
  /// **'Resuelto el {fecha}'**
  String m0507ResueltoEl(String fecha);

  /// M05-07 monto aprobado
  ///
  /// In es, this message translates to:
  /// **'Indemnización aprobada: {monto}'**
  String m0507Indemnizacion(String monto);

  /// M05-07 plazo de dispersión
  ///
  /// In es, this message translates to:
  /// **'Plazo de pago: {plazo}'**
  String m0507PlazoPago(String plazo);

  /// M05-07 motivo del rechazo
  ///
  /// In es, this message translates to:
  /// **'Motivo: {motivo}'**
  String m0507Motivo(String motivo);

  /// M05-07 vía de recurso
  ///
  /// In es, this message translates to:
  /// **'Cómo pedir una revisión: {via}'**
  String m0507ViaRecurso(String via);

  /// M05-07 motivo EVIDENCIA_INSUFICIENTE
  ///
  /// In es, this message translates to:
  /// **'la evidencia no fue suficiente'**
  String get m0507MotivoEvidencia;

  /// M05-07 motivo FUERA_DE_COBERTURA
  ///
  /// In es, this message translates to:
  /// **'el hecho está fuera de la cobertura'**
  String get m0507MotivoCobertura;

  /// M05-07 motivo POLIZA_NO_VIGENTE
  ///
  /// In es, this message translates to:
  /// **'la póliza no estaba vigente'**
  String get m0507MotivoPoliza;

  /// M05-07 motivo INCONSISTENCIA_EN_RELATO
  ///
  /// In es, this message translates to:
  /// **'el relato no es consistente con la evidencia'**
  String get m0507MotivoRelato;

  /// M05-07 motivo OTRO
  ///
  /// In es, this message translates to:
  /// **'otro motivo'**
  String get m0507MotivoOtro;

  /// M05-07 tiempo que queda del plazo de revisión
  ///
  /// In es, this message translates to:
  /// **'Tiempo restante: {tiempo}'**
  String m0507Restante(String tiempo);

  /// M05-07 plazo vencido, aprobación automática en curso
  ///
  /// In es, this message translates to:
  /// **'El plazo de revisión venció. Estamos procesando tu caso: verás el resultado aquí en unos minutos.'**
  String get m0507PlazoVencido;

  /// M05-03 título de la lista de ciudades
  ///
  /// In es, this message translates to:
  /// **'Elige la ciudad'**
  String get m0503CiudadElegir;

  /// M05-03 opción para escribir una ciudad que no está en la lista
  ///
  /// In es, this message translates to:
  /// **'Otra ciudad'**
  String get m0503CiudadOtra;

  /// Nombre del canal de notificaciones en Ajustes de Android (H3)
  ///
  /// In es, this message translates to:
  /// **'Asistencias'**
  String get asistenciaCanalNombre;

  /// Descripción del canal de notificaciones en Ajustes de Android (H3)
  ///
  /// In es, this message translates to:
  /// **'Aviso cuando llega el prestador de una asistencia'**
  String get asistenciaCanalDescripcion;

  /// Aviso de privacidad de la ubicación en M06-01 (H5, contrato v0.51)
  ///
  /// In es, this message translates to:
  /// **'Tu ubicación viaja cifrada a Solventa y a nuestro proveedor de mapas solo para calcular las rutas. Guardamos un registro cifrado durante 90 días para auditoría.'**
  String get ubicacionPrivacidad;

  /// Especialidad URGENCIAS (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Urgencias'**
  String get m0601EspecialidadUrgencias;

  /// Especialidad MEDICINA_GENERAL (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Medicina general'**
  String get m0601EspecialidadMedicinaGeneral;

  /// Especialidad MECANICA_GENERAL (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Mecánica general'**
  String get m0601EspecialidadMecanicaGeneral;

  /// Especialidad LLANTAS_Y_FRENOS (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Llantas y frenos'**
  String get m0601EspecialidadLlantasYFrenos;

  /// Especialidad GRUA_LIVIANA (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Grúa liviana'**
  String get m0601EspecialidadGruaLiviana;

  /// Especialidad GRUA_Y_CARRO_TALLER (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Grúa y carro taller'**
  String get m0601EspecialidadGruaYCarroTaller;

  /// Horario del prestador abierto 24 h (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Abierto 24 h'**
  String get m0601Abierto24h;

  /// Horario del prestador de lunes a domingo (v0.53)
  ///
  /// In es, this message translates to:
  /// **'Todos los días'**
  String get m0601TodosLosDias;

  /// Rango de días del horario: «lun a sáb» (v0.53)
  ///
  /// In es, this message translates to:
  /// **'{desde} a {hasta}'**
  String m0601RangoDias(String desde, String hasta);

  /// Horario del prestador: «Lun a sáb, 7:00 a. m. a 7:00 p. m.» (v0.53)
  ///
  /// In es, this message translates to:
  /// **'{dias}, {abre} a {cierra}'**
  String m0601Horario(String dias, String abre, String cierra);

  /// Día abreviado del horario (v0.53)
  ///
  /// In es, this message translates to:
  /// **'lun'**
  String get m0601DiaLunes;

  /// Día abreviado del horario (v0.53)
  ///
  /// In es, this message translates to:
  /// **'mar'**
  String get m0601DiaMartes;

  /// Día abreviado del horario (v0.53)
  ///
  /// In es, this message translates to:
  /// **'mié'**
  String get m0601DiaMiercoles;

  /// Día abreviado del horario (v0.53)
  ///
  /// In es, this message translates to:
  /// **'jue'**
  String get m0601DiaJueves;

  /// Día abreviado del horario (v0.53)
  ///
  /// In es, this message translates to:
  /// **'vie'**
  String get m0601DiaViernes;

  /// Día abreviado del horario (v0.53)
  ///
  /// In es, this message translates to:
  /// **'sáb'**
  String get m0601DiaSabado;

  /// Día abreviado del horario (v0.53)
  ///
  /// In es, this message translates to:
  /// **'dom'**
  String get m0601DiaDomingo;

  /// M01-05 y M01-07c: tras un rechazo del rostro, vuelve a tomar la cédula (KAN-31)
  ///
  /// In es, this message translates to:
  /// **'Cambiar fotos del documento'**
  String get m0105CambiarDocumento;

  /// RECORRIDOS_AGOTADOS: 3 verificaciones rechazadas en 24 h (contrato v0.56)
  ///
  /// In es, this message translates to:
  /// **'Hoy ya no puedes intentar la verificación otra vez. Vuelve mañana.'**
  String get fallaRecorridosAgotados;

  /// M06-02 selector de póliza (v0.55)
  ///
  /// In es, this message translates to:
  /// **'Póliza que cubre la asistencia'**
  String get m0602Poliza;

  /// M06-02 selector de póliza sin elegir
  ///
  /// In es, this message translates to:
  /// **'Elige la póliza de tu vehículo'**
  String get m0602PolizaElegir;

  /// M06-02 cargando pólizas
  ///
  /// In es, this message translates to:
  /// **'Buscando tus pólizas…'**
  String get m0602PolizaCargando;

  /// M06-02 error: falta la póliza
  ///
  /// In es, this message translates to:
  /// **'Elige la póliza de tu vehículo para enviar la solicitud.'**
  String get m0602PolizaRequerida;

  /// M06-02 sin pólizas de auto vigentes
  ///
  /// In es, this message translates to:
  /// **'Para pedir asistencia necesitas una póliza de vehículo vigente.'**
  String get m0602SinPoliza;

  /// M06-04b rechazo POLIZA_NO_VALIDA
  ///
  /// In es, this message translates to:
  /// **'Esa póliza no cubre la asistencia. Elige una póliza de vehículo vigente.'**
  String get m0602PolizaNoValida;

  /// M06-02 número de póliza
  ///
  /// In es, this message translates to:
  /// **'Póliza {numero}'**
  String m0602PolizaNumero(String numero);

  /// M01-05 aviso previo de la duración y los pasos de la grabación
  ///
  /// In es, this message translates to:
  /// **'Grabaremos 15 segundos: gira la cara a la izquierda, luego a la derecha y vuelve al centro. Verás el tiempo mientras avanza.'**
  String get m0105AvisoDuracion;

  /// M01-05 etiqueta sobre el visor mientras graba, con el tiempo que avanza (00:07 / 00:15)
  ///
  /// In es, this message translates to:
  /// **'Grabando · {transcurrido} / {total}'**
  String m0105GrabandoTiempo(String transcurrido, String total);

  /// M01-05 paso 1 de la grabación
  ///
  /// In es, this message translates to:
  /// **'Izquierda'**
  String get m0105PasoIzquierda;

  /// M01-05 paso 2 de la grabación
  ///
  /// In es, this message translates to:
  /// **'Derecha'**
  String get m0105PasoDerecha;

  /// M01-05 paso 3 de la grabación
  ///
  /// In es, this message translates to:
  /// **'Centro'**
  String get m0105PasoCentro;

  /// M01-05 instrucción del paso 1
  ///
  /// In es, this message translates to:
  /// **'Gira la cara despacio hacia la izquierda'**
  String get m0105GiraIzquierda;

  /// M01-05 instrucción del paso 2
  ///
  /// In es, this message translates to:
  /// **'Ahora gírala despacio hacia la derecha'**
  String get m0105GiraDerecha;

  /// M01-05 instrucción del paso 3
  ///
  /// In es, this message translates to:
  /// **'Vuelve al centro y mira la cámara'**
  String get m0105MiraCentro;

  /// M01-05 al terminar los 15 s
  ///
  /// In es, this message translates to:
  /// **'¡Listo! Ya tenemos tu video.'**
  String get m0105Listo;

  /// Onboarding: error inesperado con salida (reintentar o empezar de nuevo)
  ///
  /// In es, this message translates to:
  /// **'No pudimos completar este paso. Toca «Reintentar envío»; si sigue fallando, empieza de nuevo la verificación.'**
  String get fallaGenericaOnboarding;

  /// Notificación fija mientras el prestador va en camino
  ///
  /// In es, this message translates to:
  /// **'Tu asistencia va en camino'**
  String get asistenciaEnCaminoTitulo;

  /// Cuerpo de la notificación fija de en camino
  ///
  /// In es, this message translates to:
  /// **'{prestador} va hacia tu ubicación. Toca para ver el detalle.'**
  String asistenciaEnCaminoCuerpo(String prestador);

  /// Canal silencioso de la notificación fija de en camino
  ///
  /// In es, this message translates to:
  /// **'Asistencia en curso'**
  String get asistenciaEnCaminoCanalNombre;

  /// Descripción del canal de en camino en Ajustes de Android
  ///
  /// In es, this message translates to:
  /// **'Muestra la cuenta regresiva mientras el prestador va en camino'**
  String get asistenciaEnCaminoCanalDescripcion;

  /// M05-02 abre la búsqueda de dirección (Places) cuando no hay GPS
  ///
  /// In es, this message translates to:
  /// **'Escribir la dirección'**
  String get m0502EscribirDireccion;

  /// M05-02 ubicación tomada de la dirección escrita
  ///
  /// In es, this message translates to:
  /// **'Ubicación: {direccion}'**
  String m0502UbicadaDireccion(String direccion);

  /// M05-02 vuelve a abrir la búsqueda de dirección
  ///
  /// In es, this message translates to:
  /// **'Cambiar dirección'**
  String get m0502CambiarDireccion;

  /// M05-07 plazo vencido sin aprobación automática (auto parcial o RC)
  ///
  /// In es, this message translates to:
  /// **'El plazo de revisión venció. Como hay que valorar el daño, un operador revisará tu caso y verás el resultado aquí.'**
  String get m0507ValorandoDano;

  /// M05-07 título del carrusel de fotos
  ///
  /// In es, this message translates to:
  /// **'Fotos que enviaste'**
  String get m0507Fotos;

  /// M05-07 lo que lee TalkBack en una foto del carrusel
  ///
  /// In es, this message translates to:
  /// **'Foto {n} de {total}. Toca para verla en pantalla completa.'**
  String m0507Foto(int n, int total);

  /// M05-07 foto que no carga
  ///
  /// In es, this message translates to:
  /// **'Imagen no disponible'**
  String get m0507FotoNoDisponible;

  /// M05-07 cerrar el visor de fotos
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get m0507CerrarFoto;

  /// M05-07 título de la línea de tiempo
  ///
  /// In es, this message translates to:
  /// **'Seguimiento'**
  String get m0507Seguimiento;

  /// M05-07 paso: reportado
  ///
  /// In es, this message translates to:
  /// **'Reportado'**
  String get m0507HitoReportado;

  /// M05-07 paso: derivado a perito
  ///
  /// In es, this message translates to:
  /// **'En revisión con un perito'**
  String get m0507HitoRevision;

  /// M05-07 paso: aprobado
  ///
  /// In es, this message translates to:
  /// **'Aprobado'**
  String get m0507HitoAprobado;

  /// M05-07 paso: rechazado
  ///
  /// In es, this message translates to:
  /// **'Rechazado'**
  String get m0507HitoRechazado;

  /// M05-07 paso por venir: la resolución
  ///
  /// In es, this message translates to:
  /// **'Resolución'**
  String get m0507HitoResolucion;

  /// M05-07 subtítulo del paso por venir
  ///
  /// In es, this message translates to:
  /// **'A más tardar el {fecha}'**
  String m0507HitoResolucionPlazo(String fecha);

  /// M05-07 TalkBack: paso terminado
  ///
  /// In es, this message translates to:
  /// **'completado'**
  String get m0507EstadoCompletado;

  /// M05-07 TalkBack: paso actual
  ///
  /// In es, this message translates to:
  /// **'paso actual'**
  String get m0507EstadoActual;

  /// M05-07 TalkBack: paso por venir
  ///
  /// In es, this message translates to:
  /// **'pendiente'**
  String get m0507EstadoPendiente;

  /// M05-07 título de la tarjeta de póliza
  ///
  /// In es, this message translates to:
  /// **'Tu póliza'**
  String get m0507Poliza;

  /// M05-07 número de póliza
  ///
  /// In es, this message translates to:
  /// **'Póliza {numero}'**
  String m0507PolizaNumero(String numero);

  /// M05-07 sección plegable con el reporte
  ///
  /// In es, this message translates to:
  /// **'Lo que reportaste'**
  String get m0507LoQueReportaste;

  /// M05-07 etiqueta del tipo de siniestro
  ///
  /// In es, this message translates to:
  /// **'Qué pasó'**
  String get m0507QuePaso;

  /// M05-07 etiqueta del lugar
  ///
  /// In es, this message translates to:
  /// **'Dónde'**
  String get m0507Lugar;

  /// M05-07 etiqueta del relato
  ///
  /// In es, this message translates to:
  /// **'Tu relato'**
  String get m0507Relato;

  /// M05-06 filtro: todos
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get m0506FiltroTodos;

  /// M05-06 filtro: pendientes y en revisión
  ///
  /// In es, this message translates to:
  /// **'En curso'**
  String get m0506FiltroEnCurso;

  /// M05-06 filtro: aprobados y rechazados
  ///
  /// In es, this message translates to:
  /// **'Resueltos'**
  String get m0506FiltroResueltos;

  /// M05-06 filtro sin resultados
  ///
  /// In es, this message translates to:
  /// **'No tienes siniestros en este grupo.'**
  String get m0506VacioFiltro;

  /// M05-06 monto aprobado en la fila
  ///
  /// In es, this message translates to:
  /// **'Indemnización: {monto}'**
  String m0506Monto(String monto);

  /// M05-06 tiempo restante en la fila
  ///
  /// In es, this message translates to:
  /// **'Quedan {tiempo} para la revisión'**
  String m0506Quedan(String tiempo);

  /// M05-06 plazo vencido sin aprobación automática
  ///
  /// In es, this message translates to:
  /// **'Un operador está valorando el daño'**
  String get m0506PorValorar;

  /// Franja de red: título sin salida a internet
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get redSinConexionTitulo;

  /// Franja de red: mensaje sin conexión
  ///
  /// In es, this message translates to:
  /// **'Revisa tu Wi-Fi o tus datos móviles.'**
  String get redSinConexionMensaje;

  /// Franja de red: título con conexión mala
  ///
  /// In es, this message translates to:
  /// **'Conexión lenta'**
  String get redLentaTitulo;

  /// Franja de red: conexión mala por datos móviles
  ///
  /// In es, this message translates to:
  /// **'Estás con datos móviles y poca señal. El envío puede tardar.'**
  String get redLentaDatos;

  /// Franja de red: conexión mala por Wi-Fi
  ///
  /// In es, this message translates to:
  /// **'Tu Wi-Fi responde lento. El envío puede tardar.'**
  String get redLentaWifi;

  /// Franja de red: conexión mala por otra interfaz
  ///
  /// In es, this message translates to:
  /// **'Tu conexión responde lento. El envío puede tardar.'**
  String get redLentaOtra;

  /// Franja de red: volvió la conexión; se oculta sola
  ///
  /// In es, this message translates to:
  /// **'Conexión restablecida'**
  String get redRestablecidaTitulo;

  /// Píldora de red por Wi-Fi con su calidad
  ///
  /// In es, this message translates to:
  /// **'Wi-Fi · {calidad}'**
  String redChipWifi(String calidad);

  /// Píldora de red por datos móviles con su calidad
  ///
  /// In es, this message translates to:
  /// **'Datos · {calidad}'**
  String redChipDatos(String calidad);

  /// Píldora de red por otra interfaz con su calidad
  ///
  /// In es, this message translates to:
  /// **'Conexión · {calidad}'**
  String redChipOtra(String calidad);

  /// Calidad de red: responde rápido
  ///
  /// In es, this message translates to:
  /// **'buena'**
  String get redCalidadBuena;

  /// Calidad de red: responde aceptable
  ///
  /// In es, this message translates to:
  /// **'regular'**
  String get redCalidadRegular;

  /// Calidad de red: responde lento o con cortes
  ///
  /// In es, this message translates to:
  /// **'mala'**
  String get redCalidadMala;

  /// Píldora de red sin salida a internet
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get redChipSinConexion;

  /// Disparador de demo: fuerza el estado sin conexión
  ///
  /// In es, this message translates to:
  /// **'Simular sin conexión'**
  String get redDemoSinConexion;

  /// Disparador de demo: fuerza la conexión mala
  ///
  /// In es, this message translates to:
  /// **'Simular conexión lenta'**
  String get redDemoLenta;

  /// Disparador de demo: quita la simulación de red
  ///
  /// In es, this message translates to:
  /// **'Volver a la conexión real'**
  String get redDemoReal;

  /// Tiempo relativo: menos de un minuto
  ///
  /// In es, this message translates to:
  /// **'hace un momento'**
  String get tiempoHaceMomento;

  /// Tiempo relativo en minutos
  ///
  /// In es, this message translates to:
  /// **'hace {n} min'**
  String tiempoHaceMin(int n);

  /// Tiempo relativo en horas
  ///
  /// In es, this message translates to:
  /// **'hace {n} h'**
  String tiempoHaceHoras(int n);

  /// Tiempo relativo en días
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{hace 1 día} other{hace {n} días}}'**
  String tiempoHaceDias(int n);

  /// M05-06 sección de reportes guardados en el teléfono
  ///
  /// In es, this message translates to:
  /// **'Por enviar'**
  String get m0506PorEnviar;

  /// M05-06 sección de casos ya radicados
  ///
  /// In es, this message translates to:
  /// **'Enviados'**
  String get m0506Enviados;

  /// M05-06 antigüedad de la copia sin conexión
  ///
  /// In es, this message translates to:
  /// **'Actualizado {cuando}'**
  String m0506Actualizado(String cuando);

  /// M05-06 sin conexión y sin copia guardada
  ///
  /// In es, this message translates to:
  /// **'Conéctate para ver tus siniestros enviados.'**
  String get m0506SinCopia;

  /// M05-06 insignia de borrador
  ///
  /// In es, this message translates to:
  /// **'Sin terminar'**
  String get m0506SinTerminar;

  /// M05-06 título de un borrador sin póliza elegida
  ///
  /// In es, this message translates to:
  /// **'Reporte sin terminar'**
  String get m0506BorradorTitulo;

  /// M05-06 fecha y fotos de un borrador
  ///
  /// In es, this message translates to:
  /// **'Última edición: {fecha} · {fotos, plural, =0{sin fotos} =1{1 foto} other{{fotos} fotos}}'**
  String m0506UltimaEdicion(String fecha, int fotos);

  /// M05-06 aviso de borrador por vencer
  ///
  /// In es, this message translates to:
  /// **'{dias, plural, =0{Se borrará hoy si no lo terminas.} =1{Se borrará en 1 día si no lo terminas.} other{Se borrará en {dias} días si no lo terminas.}}'**
  String m0506BorradorSeBorra(int dias);

  /// M05-06 retomar un borrador
  ///
  /// In es, this message translates to:
  /// **'Continuar reporte'**
  String get m0506Continuar;

  /// M05-06 borrar un reporte guardado
  ///
  /// In es, this message translates to:
  /// **'Descartar reporte'**
  String get m0506Descartar;

  /// Diálogo de descartar: título
  ///
  /// In es, this message translates to:
  /// **'¿Descartar este reporte?'**
  String get m0506DescartarTitulo;

  /// Diálogo de descartar: mensaje
  ///
  /// In es, this message translates to:
  /// **'Se borrarán de este teléfono sus fotos y lo que escribiste. No se puede deshacer.'**
  String get m0506DescartarMensaje;

  /// Diálogo de descartar: confirmar
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get m0506DescartarConfirmar;

  /// Diálogo de descartar: cancelar
  ///
  /// In es, this message translates to:
  /// **'Conservar'**
  String get m0506DescartarCancelar;

  /// Aviso único: la base local se reinició
  ///
  /// In es, this message translates to:
  /// **'No pudimos leer lo guardado'**
  String get m0506BaseReiniciadaTitulo;

  /// Aviso único: la base local se reinició
  ///
  /// In es, this message translates to:
  /// **'Los reportes sin enviar que había en este teléfono se perdieron. Si alguno no aparece en la lista, repórtalo de nuevo.'**
  String get m0506BaseReiniciadaMensaje;

  /// M05-01 nota de pólizas en copia sin conexión
  ///
  /// In es, this message translates to:
  /// **'Pólizas guardadas en este teléfono el {fecha}. Se validan de nuevo al enviar.'**
  String m0501PolizasGuardadas(String fecha);

  /// M05-01 sin conexión y sin pólizas guardadas
  ///
  /// In es, this message translates to:
  /// **'Conéctate una vez para descargar tus pólizas.'**
  String get m0501SinPolizasGuardadas;

  /// M05-01 aviso de reportes pendientes al empezar otro
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Ya tienes 1 reporte por enviar.} other{Ya tienes {n} reportes por enviar.}}'**
  String m0501YaTienes(int n);

  /// M05-01 tope de reportes sin enviar
  ///
  /// In es, this message translates to:
  /// **'Tienes {n} reportes sin enviar, que es el máximo. Envía o descarta alguno para crear otro.'**
  String m0501TopeReportes(int n);

  /// M05-01 enlace a Mis siniestros desde el aviso de pendientes
  ///
  /// In es, this message translates to:
  /// **'Ver mis reportes'**
  String get m0501VerPendientes;

  /// M05-02 nota de privacidad de las fotos
  ///
  /// In es, this message translates to:
  /// **'Las fotos se guardan cifradas en este teléfono hasta que se envíen. No van a tu galería.'**
  String get m0502FotosCifradas;

  /// M05-02 foto que supera el tope
  ///
  /// In es, this message translates to:
  /// **'Esa foto pesa más de 10 MB. Tómala de nuevo.'**
  String get m0502FotoMuyGrande;

  /// M05 aviso: sin espacio en el teléfono
  ///
  /// In es, this message translates to:
  /// **'Tu teléfono no tiene espacio para guardar el reporte. Libera espacio para no perderlo.'**
  String get m05SinEspacio;

  /// M05 aviso: el guardado local falló
  ///
  /// In es, this message translates to:
  /// **'No pudimos guardar el reporte en este teléfono. Si cierras la app, se pierde.'**
  String get m05NoGuardado;

  /// Nombre del canal de notificaciones locales del reporte de siniestro en Ajustes de Android
  ///
  /// In es, this message translates to:
  /// **'Reportes de siniestro'**
  String get avisoReporteCanal;

  /// Descripción del canal de reportes
  ///
  /// In es, this message translates to:
  /// **'Avisos de tus reportes de siniestro: enviado, por corregir y recordatorios.'**
  String get avisoReporteCanalDescripcion;

  /// Nombre del canal silencioso con el progreso del envío
  ///
  /// In es, this message translates to:
  /// **'Envío de reportes'**
  String get avisoReporteProgresoCanal;

  /// Descripción del canal de progreso
  ///
  /// In es, this message translates to:
  /// **'Avance del envío de tus reportes. No suena.'**
  String get avisoReporteProgresoCanalDescripcion;

  /// Notificación fija de progreso de un reporte
  ///
  /// In es, this message translates to:
  /// **'Enviando tu reporte · {porcentaje} %'**
  String avisoReporteEnviando(int porcentaje);

  /// Notificación fija de progreso con varios reportes en cola
  ///
  /// In es, this message translates to:
  /// **'Enviando {posicion} de {total} reportes · {porcentaje} %'**
  String avisoReporteEnviandoVarios(int posicion, int total, int porcentaje);

  /// Paso del envío: qué foto se está subiendo
  ///
  /// In es, this message translates to:
  /// **'Foto {foto} de {fotos}'**
  String avisoReporteFoto(int foto, int fotos);

  /// Paso del envío: las fotos ya subieron y se crea el caso
  ///
  /// In es, this message translates to:
  /// **'Registrando tu caso'**
  String get avisoReporteRadicando;

  /// Notificación cuando se cae la red a mitad de un envío
  ///
  /// In es, this message translates to:
  /// **'Envío en pausa · {porcentaje} %'**
  String avisoReportePausa(int porcentaje);

  /// Cuerpo de la notificación de envío en pausa
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Sigue solo cuando vuelva la señal.'**
  String get avisoReportePausaCuerpo;

  /// Notificación al recibir el radicado
  ///
  /// In es, this message translates to:
  /// **'Tu reporte fue enviado'**
  String get avisoReporteEnviado;

  /// Cuerpo de la notificación de reporte enviado
  ///
  /// In es, this message translates to:
  /// **'Radicado {radicado}. La aseguradora responde antes del {fecha}.'**
  String avisoReporteEnviadoCuerpo(String radicado, String fecha);

  /// Notificación cuando la cola envió varios reportes
  ///
  /// In es, this message translates to:
  /// **'Tus {n} reportes fueron enviados'**
  String avisoReportesEnviados(int n);

  /// Notificación cuando la cola terminó con enviados y rechazados
  ///
  /// In es, this message translates to:
  /// **'{enviados, plural, =1{1 enviado} other{{enviados} enviados}} y {porCorregir} por corregir'**
  String avisoReportesMixto(int enviados, int porCorregir);

  /// Cuerpo de la notificación con varios reportes
  ///
  /// In es, this message translates to:
  /// **'Abre Solventa para verlos.'**
  String get avisoReportesVer;

  /// Notificación cuando la aseguradora rechaza un reporte guardado
  ///
  /// In es, this message translates to:
  /// **'No pudimos enviar tu reporte'**
  String get avisoReporteRechazado;

  /// Cuerpo de la notificación de rechazo, sin datos del reporte
  ///
  /// In es, this message translates to:
  /// **'Ábrelo para ver el motivo y corregirlo.'**
  String get avisoReporteRechazadoCuerpo;

  /// Cuerpo de la notificación cuando el envío falló muchas veces
  ///
  /// In es, this message translates to:
  /// **'Abre Solventa para intentarlo de nuevo.'**
  String get avisoReporteAtencionCuerpo;

  /// Notificación silenciosa, una vez por reporte
  ///
  /// In es, this message translates to:
  /// **'Tu reporte espera Wi-Fi'**
  String get avisoReporteEsperaWifi;

  /// Cuerpo de la notificación de espera de Wi-Fi
  ///
  /// In es, this message translates to:
  /// **'Se envía solo al conectarte a Wi-Fi. Ábrelo si prefieres enviarlo con datos.'**
  String get avisoReporteEsperaWifiCuerpo;

  /// Notificación cuando la sesión venció con reportes pendientes
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para enviar tu reporte'**
  String get avisoReporteSesion;

  /// Cuerpo de la notificación de sesión vencida
  ///
  /// In es, this message translates to:
  /// **'Tu reporte sigue guardado en este teléfono.'**
  String get avisoReporteSesionCuerpo;

  /// Recordatorio local (30 min, 3 h y 24 h) de reportes pendientes
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Tienes un reporte por enviar} other{Tienes {n} reportes por enviar}}'**
  String avisoReporteRecordatorio(int n);

  /// Cuerpo del recordatorio: no promete nada, puede salir sin internet
  ///
  /// In es, this message translates to:
  /// **'Abre Solventa cuando tengas señal.'**
  String get avisoReporteRecordatorioCuerpo;

  /// Franja sin conexión en el reporte de siniestro, sin reportes pendientes
  ///
  /// In es, this message translates to:
  /// **'Puedes reportar un siniestro. Se envía cuando vuelva la señal.'**
  String get redSinConexionReporte;

  /// Franja sin conexión con reportes en cola
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 reporte por enviar} other{{n} reportes por enviar}}'**
  String redReportesPorEnviar(int n);

  /// Acción de la franja de conexión: abre lo pendiente o el caso enviado
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get redVer;

  /// Franja mientras la cola envía con conexión
  ///
  /// In es, this message translates to:
  /// **'Envío en curso'**
  String get redEnviandoTitulo;

  /// Mensaje de la franja con el avance de la cola
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Enviando 1 reporte…} other{Enviando {n} reportes…}} {porcentaje} %'**
  String redEnviandoReportes(int n, int porcentaje);

  /// Franja al terminar el envío de un reporte
  ///
  /// In es, this message translates to:
  /// **'Reporte enviado'**
  String get redReporteEnviado;

  /// Franja al terminar el envío de varios reportes
  ///
  /// In es, this message translates to:
  /// **'{n} reportes enviados'**
  String redReportesEnviados(int n);

  /// Mensaje de la franja con el radicado del reporte enviado
  ///
  /// In es, this message translates to:
  /// **'Radicado {radicado}'**
  String redRadicado(String radicado);

  /// Hoja que pregunta una vez si enviar el reporte por datos móviles
  ///
  /// In es, this message translates to:
  /// **'Estás usando datos móviles'**
  String get m05DatosTitulo;

  /// Cuánto gasta enviar las fotos por datos móviles
  ///
  /// In es, this message translates to:
  /// **'{fotos, plural, =1{Enviar 1 foto} other{Enviar {fotos} fotos}} gasta cerca de {tamano} de tu plan.'**
  String m05DatosMensaje(int fotos, String tamano);

  /// Enviar el reporte por datos móviles, solo este
  ///
  /// In es, this message translates to:
  /// **'Enviar ahora con datos'**
  String get m05EnviarConDatos;

  /// Dejar el reporte guardado hasta tener Wi-Fi
  ///
  /// In es, this message translates to:
  /// **'Esperar Wi-Fi'**
  String get m05EsperarWifi;

  /// Casilla de la hoja de datos móviles
  ///
  /// In es, this message translates to:
  /// **'Recordar mi elección. Puedes cambiarla en Mi perfil.'**
  String get m05DatosRecordar;

  /// M05-03 botón final sin conexión
  ///
  /// In es, this message translates to:
  /// **'Guardar y enviar después'**
  String get m0503GuardarDespues;

  /// M05-03 nota sobre el botón, sin conexión
  ///
  /// In es, this message translates to:
  /// **'No hay conexión. Guardaremos tu reporte y lo enviaremos cuando vuelva la señal.'**
  String get m0503SinConexionNota;

  /// M05-03 nota antes de pedir el permiso de notificaciones
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos cuando tu reporte se envíe.'**
  String get m0503Avisaremos;

  /// M05-04 salir de la pantalla sin cortar el envío
  ///
  /// In es, this message translates to:
  /// **'Seguir en segundo plano'**
  String get m0504SegundoPlano;

  /// M05-04 porcentaje dentro del anillo
  ///
  /// In es, this message translates to:
  /// **'{porcentaje} %'**
  String m0504Porcentaje(int porcentaje);

  /// M05-04 lo que lee TalkBack al avanzar
  ///
  /// In es, this message translates to:
  /// **'Enviando, {porcentaje} por ciento. {paso}'**
  String m0504AvanceSemantica(int porcentaje, String paso);

  /// M05-04 texto bajo el anillo
  ///
  /// In es, this message translates to:
  /// **'{paso}. Puedes salir de esta pantalla: el envío sigue y te avisamos al terminar.'**
  String m0504Avance(String paso);

  /// M05-04 fila de una foto en la lista de pasos
  ///
  /// In es, this message translates to:
  /// **'Foto {numero}'**
  String m0504Foto(int numero);

  /// M05-04 último paso del envío
  ///
  /// In es, this message translates to:
  /// **'Registrar el caso'**
  String get m0504Radicar;

  /// M05-04 estado de un paso terminado
  ///
  /// In es, this message translates to:
  /// **'lista'**
  String get m0504PasoListo;

  /// M05-04 estado del paso en curso
  ///
  /// In es, this message translates to:
  /// **'enviando'**
  String get m0504PasoEnCurso;

  /// M05-04 estado de un paso que no ha empezado
  ///
  /// In es, this message translates to:
  /// **'en espera'**
  String get m0504PasoEnEspera;

  /// M05-05 desenlace sin conexión: guardado, sin radicado
  ///
  /// In es, this message translates to:
  /// **'Reporte guardado'**
  String get m0505Guardado;

  /// M05-05 reporte guardado, sin conexión
  ///
  /// In es, this message translates to:
  /// **'Lo guardamos a las {hora} y lo enviaremos a la aseguradora apenas vuelva la conexión. Todavía no tiene radicado: te avisaremos cuando lo reciban.'**
  String m0505GuardadoSinRed(String hora);

  /// M05-05 reporte guardado, esperando Wi-Fi
  ///
  /// In es, this message translates to:
  /// **'Lo guardamos a las {hora} y lo enviaremos cuando te conectes a Wi-Fi. Todavía no tiene radicado: te avisaremos cuando lo reciban.'**
  String m0505GuardadoWifi(String hora);

  /// M05-05 reporte guardado, sin sesión abierta
  ///
  /// In es, this message translates to:
  /// **'Lo guardamos a las {hora} y lo enviaremos cuando vuelvas a iniciar sesión. Todavía no tiene radicado.'**
  String m0505GuardadoSesion(String hora);

  /// M05-05 reporte guardado tras una falla técnica que se reintenta sola
  ///
  /// In es, this message translates to:
  /// **'Lo guardamos a las {hora}, pero no pudimos enviarlo ahora. Lo intentaremos de nuevo en un momento, sin que tengas que hacer nada. Todavía no tiene radicado.'**
  String m0505GuardadoReintento(String hora);

  /// M05-05 detalle del reporte guardado
  ///
  /// In es, this message translates to:
  /// **'Guardado cifrado en este teléfono con {fotos, plural, =1{1 foto} other{{fotos} fotos}} y tu ubicación.'**
  String m0505GuardadoDetalle(int fotos);

  /// M05-05 advertencia del reporte guardado
  ///
  /// In es, this message translates to:
  /// **'Si desinstalas la app o borras sus datos, se pierde.'**
  String get m0505GuardadoAviso;

  /// Enviar ya un reporte guardado, sin esperar el reintento
  ///
  /// In es, this message translates to:
  /// **'Enviar ahora'**
  String get m05EnviarAhora;

  /// M05-06 estado de un reporte completo que espera red o turno
  ///
  /// In es, this message translates to:
  /// **'Pendiente de envío'**
  String get m0506PendienteEnvio;

  /// M05-06 estado de un reporte que espera Wi-Fi por la preferencia del cliente
  ///
  /// In es, this message translates to:
  /// **'Esperando Wi-Fi'**
  String get m0506EsperandoWifi;

  /// M05-06 estado de un reporte que la cola está enviando
  ///
  /// In es, this message translates to:
  /// **'Enviando'**
  String get m0506Enviando;

  /// M05-06 estado de un reporte con la foto que se sube
  ///
  /// In es, this message translates to:
  /// **'Enviando · foto {foto} de {fotos}'**
  String m0506EnviandoFoto(int foto, int fotos);

  /// M05-06 estado de un reporte que la aseguradora rechazó
  ///
  /// In es, this message translates to:
  /// **'Con error'**
  String get m0506ConError;

  /// M05-06 estado de un reporte que falló muchas veces por razones técnicas
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar'**
  String get m0506NecesitaAtencion;

  /// M05-06 cuándo quedó guardado un reporte pendiente
  ///
  /// In es, this message translates to:
  /// **'Guardado el {fecha} · {fotos, plural, =1{1 foto} other{{fotos} fotos}}'**
  String m0506GuardadoEl(String fecha, int fotos);

  /// M05-07b título del detalle de un reporte guardado en el teléfono
  ///
  /// In es, this message translates to:
  /// **'Reporte por enviar'**
  String get m0507bTitulo;

  /// M05-07b el reporte ya no existe en el teléfono
  ///
  /// In es, this message translates to:
  /// **'Este reporte ya no está guardado en el teléfono. Si se envió, lo encuentras en Mis siniestros.'**
  String get m0507bYaNoEsta;

  /// M05-07b abre el caso ya recibido por la aseguradora
  ///
  /// In es, this message translates to:
  /// **'Ver el caso'**
  String get m0507bVerCaso;

  /// M05-07b corregir un reporte rechazado
  ///
  /// In es, this message translates to:
  /// **'Corregir y enviar'**
  String get m0507bCorregir;

  /// M05-07b editar un reporte pendiente
  ///
  /// In es, this message translates to:
  /// **'Editar reporte'**
  String get m0507bEditar;

  /// M05-07b título de la línea de tiempo
  ///
  /// In es, this message translates to:
  /// **'Estado del envío'**
  String get m0507bEstadoEnvio;

  /// M05-07b primer paso de la línea de tiempo
  ///
  /// In es, this message translates to:
  /// **'Guardado en este teléfono'**
  String get m0507bGuardadoTelefono;

  /// M05-07b paso actual de un borrador
  ///
  /// In es, this message translates to:
  /// **'Termínalo para poder enviarlo.'**
  String get m0507bBorradorNota;

  /// M05-07b paso actual sin conexión
  ///
  /// In es, this message translates to:
  /// **'Esperando conexión'**
  String get m0507bEsperandoConexion;

  /// M05-07b nota del paso sin conexión
  ///
  /// In es, this message translates to:
  /// **'Se envía solo cuando vuelva la señal.'**
  String get m0507bEsperandoConexionNota;

  /// M05-07b paso actual sin sesión abierta
  ///
  /// In es, this message translates to:
  /// **'Esperando que inicies sesión'**
  String get m0507bEsperandoSesion;

  /// M05-07b nota del paso esperando Wi-Fi
  ///
  /// In es, this message translates to:
  /// **'Se envía solo al conectarte a Wi-Fi.'**
  String get m0507bEsperandoWifiNota;

  /// M05-07b paso actual con conexión, esperando turno o reintento
  ///
  /// In es, this message translates to:
  /// **'En cola de envío'**
  String get m0507bEnCola;

  /// M05-07b nota del paso en cola
  ///
  /// In es, this message translates to:
  /// **'Sale en un momento.'**
  String get m0507bEnColaNota;

  /// M05-07b cuándo será el próximo intento
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar. A las {hora} lo intentamos de nuevo, sin que hagas nada.'**
  String m0507bReintento(String hora);

  /// M05-07b paso actual de un reporte rechazado
  ///
  /// In es, this message translates to:
  /// **'La aseguradora no lo aceptó'**
  String get m0507bNoAceptado;

  /// M05-07b nota del paso rechazado
  ///
  /// In es, this message translates to:
  /// **'Corrige el dato y vuelve a enviarlo.'**
  String get m0507bNoAceptadoNota;

  /// M05-07b falla técnica repetida
  ///
  /// In es, this message translates to:
  /// **'Falló varias veces. Puedes intentar enviarlo de nuevo.'**
  String get m0507bErrorTecnico;

  /// M05-07b aviso cuando el envío falló 8 veces
  ///
  /// In es, this message translates to:
  /// **'Falló varias veces y dejamos de reintentarlo. Toca «Enviar ahora» para intentarlo de nuevo. Tu reporte sigue guardado.'**
  String get m0507bAtencion;

  /// M05-07b último paso de la línea de tiempo
  ///
  /// In es, this message translates to:
  /// **'Recibido por la aseguradora'**
  String get m0507bRecibido;

  /// M05-07b nota del último paso
  ///
  /// In es, this message translates to:
  /// **'Aquí verás tu radicado.'**
  String get m0507bRecibidoNota;

  /// M05-07b el intento de radicar quedó sin respuesta
  ///
  /// In es, this message translates to:
  /// **'Estamos confirmando si la aseguradora ya lo recibió. Por ahora no se puede editar.'**
  String get m0507bIncierto;

  /// M05-07b nota mientras se envía
  ///
  /// In es, this message translates to:
  /// **'Puedes seguir usando la app. No cierres sesión mientras se envía.'**
  String get m0507bEnviandoNota;

  /// M05-07b nota de un reporte rechazado
  ///
  /// In es, this message translates to:
  /// **'Tus fotos y tu relato siguen guardados. No se perdió nada.'**
  String get m0507bNadaSePerdio;

  /// M05-07b nota si el permiso de notificaciones está negado
  ///
  /// In es, this message translates to:
  /// **'Activa las notificaciones para avisarte cuando se envíe.'**
  String get m0507bActivaAvisos;

  /// M05-07b dato del reporte
  ///
  /// In es, this message translates to:
  /// **'Póliza'**
  String get m0507bPoliza;

  /// M05-07b dato del reporte
  ///
  /// In es, this message translates to:
  /// **'Qué pasó'**
  String get m0507bQuePaso;

  /// M05-07b dato del reporte
  ///
  /// In es, this message translates to:
  /// **'Cuándo'**
  String get m0507bCuando;

  /// M05-07b dato del reporte
  ///
  /// In es, this message translates to:
  /// **'Dónde'**
  String get m0507bDonde;

  /// M05-07b dato del reporte
  ///
  /// In es, this message translates to:
  /// **'Fotos'**
  String get m0507bFotos;

  /// M05-07b cuántas fotos tiene el reporte y cuántas ya subieron
  ///
  /// In es, this message translates to:
  /// **'{subidas, plural, =0{{fotos}} other{{fotos}, {subidas} ya subidas}}'**
  String m0507bFotosSubidas(int fotos, int subidas);

  /// M05-02: sin red no se puede escribir la dirección, solo usar el GPS.
  ///
  /// In es, this message translates to:
  /// **'Para reportar sin conexión necesitamos la ubicación de tu teléfono.'**
  String get m0502UbicacionSinRed;

  /// Inicio: insignia de «Mis siniestros» con los reportes guardados que faltan por enviar.
  ///
  /// In es, this message translates to:
  /// **'{n} por enviar'**
  String homePorEnviar(int n);

  /// G-04: cierre de sesión con reportes de siniestro completos que no se han enviado.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Tienes 1 reporte sin enviar. Quedará guardado en este teléfono y se enviará cuando vuelvas a iniciar sesión con esta cuenta.} other{Tienes {n} reportes sin enviar. Quedarán guardados en este teléfono y se enviarán cuando vuelvas a iniciar sesión con esta cuenta.}}'**
  String cerrarSesionReportesSinEnviar(int n);

  /// G-04: cierre de sesión cuando solo hay borradores de reporte.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{Tienes 1 reporte sin terminar. Quedará guardado en este teléfono para cuando vuelvas a iniciar sesión con esta cuenta.} other{Tienes {n} reportes sin terminar. Quedarán guardados en este teléfono para cuando vuelvas a iniciar sesión con esta cuenta.}}'**
  String cerrarSesionReportesSinTerminar(int n);

  /// G-04: casilla para borrar del teléfono los reportes sin enviar al cerrar sesión.
  ///
  /// In es, this message translates to:
  /// **'Borrar también los reportes guardados'**
  String get cerrarSesionBorrarReportes;

  /// G-04: con conexión, enviar los reportes pendientes antes de cerrar sesión.
  ///
  /// In es, this message translates to:
  /// **'Enviar ahora'**
  String get cerrarSesionEnviarAhora;

  /// Mi perfil: título de la sección del envío de reportes de siniestro.
  ///
  /// In es, this message translates to:
  /// **'Envío de reportes'**
  String get perfilEnvioTitulo;

  /// Mi perfil, Envío de reportes: fila con el estado de la conexión.
  ///
  /// In es, this message translates to:
  /// **'Conexión'**
  String get perfilEnvioConexion;

  /// Mi perfil, Envío de reportes: explicación bajo «Conexión».
  ///
  /// In es, this message translates to:
  /// **'Se revisa mientras reportas un siniestro'**
  String get perfilEnvioConexionTexto;

  /// Mi perfil, Envío de reportes: interruptor de solo Wi-Fi.
  ///
  /// In es, this message translates to:
  /// **'Enviar las fotos solo con Wi-Fi'**
  String get perfilEnvioSoloWifi;

  /// Mi perfil: estado del interruptor de solo Wi-Fi apagado.
  ///
  /// In es, this message translates to:
  /// **'Apagado: se envía con Wi-Fi o con datos móviles'**
  String get perfilEnvioSoloWifiApagado;

  /// Mi perfil: estado del interruptor de solo Wi-Fi encendido.
  ///
  /// In es, this message translates to:
  /// **'Encendido: las fotos esperan a que haya Wi-Fi'**
  String get perfilEnvioSoloWifiEncendido;

  /// Mi perfil, Envío de reportes: acceso a los reportes guardados en el teléfono.
  ///
  /// In es, this message translates to:
  /// **'Reportes por enviar'**
  String get perfilEnvioPorEnviar;

  /// Mi perfil: no hay reportes por enviar.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get perfilEnvioNinguno;

  /// Mi perfil: cuántos reportes por enviar hay guardados en el teléfono.
  ///
  /// In es, this message translates to:
  /// **'{n, plural, =1{1 guardado en este teléfono} other{{n} guardados en este teléfono}}'**
  String perfilEnvioGuardados(int n);

  /// M05-07: detalle de un caso abierto sin conexión; se muestra el resumen de la lista.
  ///
  /// In es, this message translates to:
  /// **'Conéctate para ver el detalle completo.'**
  String get m0507SinConexion;

  /// Sin conexión: razón por la que una opción está deshabilitada.
  ///
  /// In es, this message translates to:
  /// **'Necesita conexión'**
  String get redNecesitaConexion;

  /// Inicio de sesión sin conexión y sin sesión guardada: mensaje de la franja de conexión.
  ///
  /// In es, this message translates to:
  /// **'Para entrar sin internet necesitas haber iniciado sesión antes en este teléfono con el bloqueo de pantalla activo.'**
  String get accesoSinConexionLogin;

  /// Inicio de sesión sin conexión con la sesión guardada vencida: mensaje de la franja de conexión.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión guardada venció. Conéctate para iniciar sesión.'**
  String get accesoSesionVencidaSinConexion;

  /// Modo sin conexión: lo que muestran las pestañas de asistencia.
  ///
  /// In es, this message translates to:
  /// **'Conéctate para solicitar asistencia y ver tus asistencias.'**
  String get homeSinConexionPestana;

  /// Mi perfil sin conexión: datos que no se guardan en el teléfono.
  ///
  /// In es, this message translates to:
  /// **'Correo y documento'**
  String get perfilSinConexionDatos;

  /// Mi perfil sin conexión: explicación de por qué no se ven el correo y el documento.
  ///
  /// In es, this message translates to:
  /// **'Conéctate para ver tus datos completos'**
  String get perfilSinConexionDatosTexto;

  /// Mi perfil sin conexión: fila deshabilitada de preferencias.
  ///
  /// In es, this message translates to:
  /// **'Idioma y moneda'**
  String get perfilIdiomaMoneda;

  /// Mi perfil sin conexión: idioma y moneda actuales; no se pueden cambiar sin red.
  ///
  /// In es, this message translates to:
  /// **'{idioma} · {moneda} · Necesita conexión'**
  String perfilPreferenciasSinConexion(String idioma, String moneda);

  /// Mi perfil sin conexión: la huella o el rostro están activos.
  ///
  /// In es, this message translates to:
  /// **'Activada · con ella entraste sin conexión'**
  String get perfilBiometriaSinConexion;

  /// Inicio: pista para activar la biometría, que además permite el modo sin conexión.
  ///
  /// In es, this message translates to:
  /// **'Activa tu huella o rostro para entrar más rápido y poder reportar un siniestro sin conexión.'**
  String get homeBiometriaPistaReporte;
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
