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
  String get m0105DemoRevision => 'Simular que la identidad queda en revisión';

  @override
  String get m0105DemoRechazo => 'Simular que el documento es rechazado';

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
  String get m0108NoActivada =>
      'Aún no detectamos huella o rostro en tu teléfono.';

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
}
