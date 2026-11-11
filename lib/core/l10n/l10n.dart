import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/falla.dart';
import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension L10nX on BuildContext {
  /// Textos de la app en el idioma activo (`lib/core/l10n/arb/`).
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Idiomas de la app: español de Colombia (por defecto) e inglés.
abstract final class AppLocales {
  static const es = Locale('es', 'CO');
  static const en = Locale('en');
  static const supported = [es, en];
}

/// Monedas soportadas en toda la plataforma (HU-W02 / KAN-209).
abstract final class AppMonedas {
  static const supported = ['COP', 'MXN', 'BRL', 'CLP', 'PEN', 'USD', 'EUR'];
  static const porDefecto = 'COP';

  static bool esSoportada(String? valor) =>
      valor != null && supported.contains(valor);
}

/// Idioma activo. La píldora «ES · COP» de la barra superior lo alterna o abre
/// el selector de idioma y moneda.
class LocaleNotifier extends Notifier<Locale> {
  static const _claveIdioma = 'solventa.idioma';

  @override
  Locale build() {
    unawaited(_cargarPersistido());
    return AppLocales.es;
  }

  Future<void> _cargarPersistido() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final guardado = prefs.getString(_claveIdioma);
      if (!ref.mounted || guardado == null) return;
      state = guardado.toUpperCase() == 'EN' ? AppLocales.en : AppLocales.es;
    } catch (_) {
      // En entorno sin plugin de SharedPreferences se mantiene en memoria.
    }
  }

  void alternar() {
    cambiar(state.languageCode == 'es' ? AppLocales.en : AppLocales.es);
  }

  void cambiar(Locale nuevo) {
    state = nuevo;
    unawaited(_guardar(nuevo.languageCode.toUpperCase()));
  }

  void cambiarPorCodigo(String codigo) {
    cambiar(codigo.toUpperCase() == 'EN' ? AppLocales.en : AppLocales.es);
  }

  Future<void> _guardar(String codigo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_claveIdioma, codigo);
    } catch (_) {}
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// Moneda activa de visualización (`COP`, `MXN`, `BRL`, `CLP`, `PEN`, `USD`, `EUR`).
class MonedaNotifier extends Notifier<String> {
  static const _claveMoneda = 'solventa.moneda';

  @override
  String build() {
    unawaited(_cargarPersistida());
    return AppMonedas.porDefecto;
  }

  Future<void> _cargarPersistida() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final guardada = prefs.getString(_claveMoneda);
      if (!ref.mounted || !AppMonedas.esSoportada(guardada)) return;
      state = guardada!;
    } catch (_) {}
  }

  void cambiar(String nuevaMoneda) {
    final limpia = nuevaMoneda.toUpperCase();
    if (!AppMonedas.esSoportada(limpia)) return;
    state = limpia;
    unawaited(_guardar(limpia));
  }

  Future<void> _guardar(String codigo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_claveMoneda, codigo);
    } catch (_) {}
  }
}

final monedaProvider = NotifierProvider<MonedaNotifier, String>(
  MonedaNotifier.new,
);

/// Texto para el usuario de cada [Falla] (nunca un error técnico crudo).
extension FallaTextoX on AppLocalizations {
  String falla(Falla f) => switch (f) {
    SinConexion() => fallaSinConexion,
    ServicioNoDisponible() => fallaServicio,
    SesionVencida() => fallaSesionVencida,
    SinPermiso() => fallaSinPermiso,
    FallaNegocio(registroVencido: true) => fallaRegistroVencido,
    FallaNegocio(motivo: 'ALMACENAMIENTO_NO_DISPONIBLE' || 'NO_DISPONIBLE') =>
      fallaAlmacenamiento,
    FallaNegocio(motivo: 'OBJETO_NO_SUBIDO') => fallaObjetoNoSubido,
    FallaNegocio(motivo: 'TAMANO_NO_ADMITIDO') => fallaTamanoNoAdmitido,
    FallaNegocio(motivo: 'TIPO_CONTENIDO_NO_ADMITIDO') => fallaTipoNoAdmitido,
    FallaNegocio(motivo: 'PIEZAS_INCOMPLETAS') => fallaPiezasIncompletas,
    FallaNegocio(motivo: 'SIN_CONSENTIMIENTO') => fallaSinConsentimiento,
    FallaNegocio(motivo: 'PROVEEDOR_NO_DISPONIBLE') =>
      fallaProveedorNoDisponible,
    FallaNegocio(motivo: 'CORREO_YA_REGISTRADO') => m0105bCorreoRegistrado,
    FallaNegocio(motivo: 'CODIGO_INVALIDO') => fallaCodigoInvalido,
    FallaNegocio(motivo: 'CODIGO_VENCIDO') => fallaCodigoVencido,
    FallaNegocio(motivo: 'INTENTOS_AGOTADOS') => fallaIntentosAgotados,
    FallaNegocio(motivo: 'ESPERA_REQUERIDA') => fallaEsperaRequerida,
    FallaNegocio(motivo: 'CLAVE_DEBIL') => m0105bErrorContrasena,
    FallaNegocio(motivo: 'CREDENCIALES_INVALIDAS') =>
      fallaCredencialesInvalidas,
    FallaNegocio(motivo: 'DISPOSITIVO_NO_VALIDO') => fallaDispositivoNoValido,
    FallaNegocio(motivo: 'CAMARA_NO_DISPONIBLE') => fallaCamaraNoDisponible,
    FallaNegocio(motivo: 'ROSTRO_NO_COINCIDE') => m0107cRostro,
    FallaNegocio(motivo: 'SUPLANTACION') => m0107cSuplantacion,
    _ => fallaGenerica,
  };

  /// Nombre legible de cada moneda soportada.
  String nombreMoneda(String codigo) => switch (codigo.toUpperCase()) {
    'COP' => monedaNombreCOP,
    'MXN' => monedaNombreMXN,
    'BRL' => monedaNombreBRL,
    'CLP' => monedaNombreCLP,
    'PEN' => monedaNombrePEN,
    'USD' => monedaNombreUSD,
    'EUR' => monedaNombreEUR,
    _ => codigo,
  };
}
