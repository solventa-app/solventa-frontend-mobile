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

  /// Disparador de demo (solo debug)
  ///
  /// In es, this message translates to:
  /// **'Simular que la identidad queda en revisión'**
  String get m0105DemoRevision;

  /// Disparador de demo (solo debug)
  ///
  /// In es, this message translates to:
  /// **'Simular que el documento es rechazado'**
  String get m0105DemoRechazo;

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

  /// M01-08 aviso si no está activada
  ///
  /// In es, this message translates to:
  /// **'Aún no detectamos huella o rostro en tu teléfono.'**
  String get m0108NoActivada;

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
