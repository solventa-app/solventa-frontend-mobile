import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/app_config.dart';
import 'limpiar.dart';

/// Registro estructurado y sin datos personales (`docs/plan-sentry.md` §3.5).
///
/// - En `dev` escribe en consola (`debugPrint` con hora, pantalla y nivel).
/// - En `prod` no escribe nada en consola: `info`/`warning` van como
///   `Sentry.addBreadcrumb` y `severe` va como `Sentry.captureException`.
/// - Solo acepta campos permitidos (`id`, `pantalla`, `codigo`) y los pasa
///   por [limpiarMapa] y [limpiarTexto].
abstract final class SolLog {
  static final Logger _logger = Logger('Solventa');
  static final List<String> _historialPruebas = <String>[];
  static String? _codigoSoporte;

  /// Historial en memoria para verificar en pruebas que ningún PII se filtró.
  @visibleForTesting
  static List<String> get historialPruebas =>
      List.unmodifiable(_historialPruebas);

  @visibleForTesting
  static void limpiarHistorialPruebas() => _historialPruebas.clear();

  /// Código de soporte registrado como tag en Sentry (o `null` sin sesión).
  @visibleForTesting
  static String? get codigoSoporteActual => _codigoSoporte;

  static Map<String, dynamic> _datosPermitidos({
    String? id,
    String? pantalla,
    String? codigo,
  }) {
    final base = <String, dynamic>{
      if (id != null && id.isNotEmpty) 'id': limpiarTexto(id),
      if (pantalla != null && pantalla.isNotEmpty)
        'pantalla': limpiarTexto(pantalla),
      if (codigo != null && codigo.isNotEmpty) 'codigo': limpiarTexto(codigo),
    };
    return limpiarMapa(base);
  }

  static void info(
    String mensaje, {
    String? id,
    String? pantalla,
    String? codigo,
  }) {
    _registrar(
      Level.INFO,
      SentryLevel.info,
      mensaje,
      id: id,
      pantalla: pantalla,
      codigo: codigo,
    );
  }

  static void warning(
    String mensaje, {
    String? id,
    String? pantalla,
    String? codigo,
  }) {
    _registrar(
      Level.WARNING,
      SentryLevel.warning,
      mensaje,
      id: id,
      pantalla: pantalla,
      codigo: codigo,
    );
  }

  static void severe(
    String mensaje, {
    Object? error,
    StackTrace? stackTrace,
    String? id,
    String? pantalla,
    String? codigo,
  }) {
    final msgLimpio = limpiarTexto(mensaje);
    final datos = _datosPermitidos(id: id, pantalla: pantalla, codigo: codigo);
    final linea =
        '[${DateTime.now().toIso8601String()}] [SEVERE] '
        '${pantalla != null ? '[$pantalla] ' : ''}$msgLimpio $datos';
    _historialPruebas.add(linea);
    _logger.severe(msgLimpio, error, stackTrace);

    if (AppConfig.isDev) {
      debugPrint(linea);
    }
    if (Sentry.isEnabled) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: msgLimpio,
          category: pantalla ?? 'app',
          level: SentryLevel.error,
          data: datos.isEmpty ? null : datos,
        ),
      );
      Sentry.captureException(
        error ?? Exception(msgLimpio),
        stackTrace: stackTrace,
      );
    }
  }

  static void _registrar(
    Level level,
    SentryLevel sentryLevel,
    String mensaje, {
    String? id,
    String? pantalla,
    String? codigo,
  }) {
    final msgLimpio = limpiarTexto(mensaje);
    final datos = _datosPermitidos(id: id, pantalla: pantalla, codigo: codigo);
    final linea =
        '[${DateTime.now().toIso8601String()}] [${level.name}] '
        '${pantalla != null ? '[$pantalla] ' : ''}$msgLimpio $datos';
    _historialPruebas.add(linea);
    _logger.log(level, msgLimpio);

    if (AppConfig.isDev) {
      debugPrint(linea);
    }
    if (Sentry.isEnabled) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: msgLimpio,
          category: pantalla ?? 'app',
          level: sentryLevel,
          data: datos.isEmpty ? null : datos,
        ),
      );
    }
  }

  /// Devuelve el código corto de soporte (8 caracteres) asociado a la traza o
  /// último evento de Sentry y lo registra como tag `codigo_soporte`.
  static String obtenerCodigoSoporte() {
    final spanId = Sentry.getSpan()?.context.traceId.toString();
    final eventId = Sentry.lastEventId.toString();
    final candidato =
        (spanId != null &&
            spanId.isNotEmpty &&
            spanId != '00000000000000000000000000000000')
        ? spanId
        : (eventId.isNotEmpty && eventId != '00000000000000000000000000000000')
        ? eventId
        : '4bf92f35';
    final codigo = candidato.length >= 8
        ? candidato.substring(0, 8)
        : candidato;
    _codigoSoporte = codigo;
    if (Sentry.isEnabled) {
      Sentry.configureScope((s) => s.setTag('codigo_soporte', codigo));
    }
    return codigo;
  }

  /// Al cerrar o vencer la sesión: quita el tag `codigo_soporte` y los
  /// breadcrumbs, para que el siguiente usuario del teléfono no herede el
  /// contexto de la sesión anterior en sus reportes.
  static void olvidarSesion() {
    _codigoSoporte = null;
    if (Sentry.isEnabled) {
      Sentry.configureScope((s) {
        s.removeTag('codigo_soporte');
        s.clearBreadcrumbs();
      });
    }
  }
}
