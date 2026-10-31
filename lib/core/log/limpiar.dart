import 'package:sentry_flutter/sentry_flutter.dart';

/// Campos sensibles que nunca deben viajar a Sentry (docs/plan-sentry.md §0).
const Set<String> _camposSensibles = {
  'documento',
  'cedula',
  'nombre',
  'correo',
  'email',
  'telefono',
  'celular',
  'direccion',
  'token',
  'password',
  'contrasena',
  'tarjeta',
  'cvv',
  'iban',
  'authorization',
  'cookie',
  'set-cookie',
};

final RegExp _numerosLargos = RegExp(r'\b\d{6,}\b');
final RegExp _patronCorreo = RegExp(
  r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
);
final RegExp _patronJwt = RegExp(
  r'eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+',
);

/// Limpia cualquier texto reemplazando JWTs, correos y números de 6+ dígitos.
String limpiarTexto(String valor) => valor
    .replaceAll(_patronJwt, '[token]')
    .replaceAll(_patronCorreo, '[correo]')
    .replaceAll(_numerosLargos, '[número]');

/// Limpia un mapa recursivamente eliminando claves sensibles y sanitizando strings.
Map<String, dynamic> limpiarMapa(Map<String, dynamic> mapa) {
  final limpio = <String, dynamic>{};
  for (final entry in mapa.entries) {
    final k = entry.key.toLowerCase();
    if (_camposSensibles.contains(k) ||
        _camposSensibles.any((c) => k.contains(c))) {
      limpio[entry.key] = '[filtrado]';
    } else {
      limpio[entry.key] = _limpiarValor(entry.value);
    }
  }
  return limpio;
}

dynamic _limpiarValor(dynamic valor) {
  if (valor is String) return limpiarTexto(valor);
  if (valor is Map<String, dynamic>) return limpiarMapa(valor);
  if (valor is Map) {
    return limpiarMapa(valor.map((k, v) => MapEntry(k.toString(), v)));
  }
  if (valor is List) return valor.map(_limpiarValor).toList();
  return valor;
}

String? _limpiarQuery(String? query) {
  if (query == null || query.isEmpty) return query;
  final partes = query.split('&').map((par) {
    final idx = par.indexOf('=');
    if (idx < 0) return limpiarTexto(par);
    final clave = par.substring(0, idx);
    final valor = par.substring(idx + 1);
    final k = clave.toLowerCase();
    if (_camposSensibles.contains(k) ||
        _camposSensibles.any((c) => k.contains(c))) {
      return '$clave=[filtrado]';
    }
    return '$clave=${limpiarTexto(valor)}';
  });
  return partes.join('&');
}

String? _limpiarUrl(String? url) {
  if (url == null || url.isEmpty) return url;
  final idx = url.indexOf('?');
  if (idx < 0) return limpiarTexto(url);
  final base = limpiarTexto(url.substring(0, idx));
  final query = _limpiarQuery(url.substring(idx + 1));
  return '$base?$query';
}

/// Callback `beforeSend` de Sentry que garantiza que ningún PII (documento,
/// correo, token, números de 6+ dígitos) salga del dispositivo.
SentryEvent? limpiar(SentryEvent event, Hint hint) {
  final req = event.request;
  if (req != null) {
    final headersLimpios = <String, String>{};
    for (final entry in req.headers.entries) {
      final k = entry.key.toLowerCase();
      if (_camposSensibles.contains(k) ||
          _camposSensibles.any((c) => k.contains(c))) {
        headersLimpios[entry.key] = '[filtrado]';
      } else {
        headersLimpios[entry.key] = limpiarTexto(entry.value);
      }
    }
    event.request = SentryRequest(
      url: _limpiarUrl(req.url),
      method: req.method,
      queryString: _limpiarQuery(req.queryString),
      cookies: req.cookies != null ? '[filtrado]' : null,
      fragment: req.fragment != null ? limpiarTexto(req.fragment!) : null,
      apiTarget: req.apiTarget,
      data: _limpiarValor(req.data),
      headers: headersLimpios,
      env: req.env.map((k, v) => MapEntry(k, limpiarTexto(v))),
    );
  }

  // ignore: deprecated_member_use
  final extra = event.extra;
  if (extra != null) {
    // ignore: deprecated_member_use
    event.extra = limpiarMapa(extra);
  }

  final migas = event.breadcrumbs;
  if (migas != null) {
    event.breadcrumbs = migas
        .map(
          (b) => Breadcrumb(
            message: b.message != null ? limpiarTexto(b.message!) : null,
            timestamp: b.timestamp,
            category: b.category,
            data: b.data != null ? limpiarMapa(b.data!) : null,
            level: b.level,
            type: b.type,
          ),
        )
        .toList();
  }

  if (event.message != null) {
    final msg = event.message!;
    event.message = SentryMessage(
      limpiarTexto(msg.formatted),
      template: msg.template != null ? limpiarTexto(msg.template!) : null,
      params: msg.params?.map(_limpiarValor).toList(),
    );
  }

  return event;
}
