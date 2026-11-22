import 'dart:convert';

import '../../../../core/ubicacion/coordenada.dart';
import '../../domain/entities/reporte_guardado.dart';
import '../../domain/entities/reporte_siniestro.dart';

/// De las entidades de HU-M05 a JSON y de vuelta, para la base cifrada.
/// Las fechas van en ISO 8601 UTC.

String? _iso(DateTime? t) => t?.toUtc().toIso8601String();

DateTime? _fecha(Object? valor) =>
    valor is String ? DateTime.tryParse(valor)?.toUtc() : null;

Map<String, Object?> _mapa(Object? valor) =>
    valor is Map ? valor.cast<String, Object?>() : const {};

TipoSiniestroAuto? tipoAutoDeCodigo(Object? codigo) {
  for (final tipo in TipoSiniestroAuto.values) {
    if (tipo.codigo == codigo) return tipo;
  }
  return null;
}

Map<String, Object?> polizaAJson(PolizaReportable p) => {
  'id': p.id,
  'numero': p.numero,
  'vigenciaDesde': _iso(p.vigenciaDesde),
  'vigenciaHasta': _iso(p.vigenciaHasta),
  'esAuto': p.esAuto,
  'vehiculo': p.vehiculo,
};

PolizaReportable? polizaDesdeJson(Object? valor) {
  final j = _mapa(valor);
  final id = j['id'];
  final numero = j['numero'];
  final desde = _fecha(j['vigenciaDesde']);
  final hasta = _fecha(j['vigenciaHasta']);
  if (id is! String || numero is! String || desde == null || hasta == null) {
    return null;
  }
  return PolizaReportable(
    id: id,
    numero: numero,
    vigenciaDesde: desde,
    vigenciaHasta: hasta,
    esAuto: j['esAuto'] == true,
    vehiculo: j['vehiculo'] as String?,
  );
}

String polizasAJson(List<PolizaReportable> polizas) =>
    jsonEncode([for (final p in polizas) polizaAJson(p)]);

List<PolizaReportable> polizasDesdeJson(String json) {
  final lista = jsonDecode(json);
  if (lista is! List) return const [];
  return [for (final e in lista) ?polizaDesdeJson(e)];
}

Map<String, Object?> _resolucionAJson(ResolucionSiniestro r) => {
  'tipo': r.tipo,
  'resueltaEn': _iso(r.resueltaEn),
  'motivo': r.motivo,
  'viaRecurso': r.viaRecurso,
  'indemnizacion': r.indemnizacion,
  'plazoDispersion': r.plazoDispersion,
};

ResolucionSiniestro? _resolucionDesdeJson(Object? valor) {
  final j = _mapa(valor);
  final tipo = j['tipo'];
  final en = _fecha(j['resueltaEn']);
  if (tipo is! String || en == null) return null;
  return ResolucionSiniestro(
    tipo: tipo,
    resueltaEn: en,
    motivo: j['motivo'] as String?,
    viaRecurso: j['viaRecurso'] as String?,
    indemnizacion: j['indemnizacion'] as num?,
    plazoDispersion: j['plazoDispersion'] as String?,
  );
}

Map<String, Object?> siniestroAJson(SiniestroReportado s) => {
  'id': s.id,
  'radicado': s.radicado,
  'estado': s.estado,
  'notificadoEn': _iso(s.notificadoEn),
  'venceDictamenEn': _iso(s.venceDictamenEn),
  'fotos': s.fotos,
  'ocurridoEn': _iso(s.ocurridoEn),
  'polizaId': s.polizaId,
  'tipoAuto': s.tipoAuto?.codigo,
  'resolucion': switch (s.resolucion) {
    final r? => _resolucionAJson(r),
    null => null,
  },
};

SiniestroReportado? siniestroDesdeJson(Object? valor) {
  final j = _mapa(valor);
  final id = j['id'];
  final radicado = j['radicado'];
  final estado = j['estado'];
  final notificado = _fecha(j['notificadoEn']);
  final vence = _fecha(j['venceDictamenEn']);
  if (id is! String ||
      radicado is! String ||
      estado is! String ||
      notificado == null ||
      vence == null) {
    return null;
  }
  return SiniestroReportado(
    id: id,
    radicado: radicado,
    estado: estado,
    notificadoEn: notificado,
    venceDictamenEn: vence,
    fotos: (j['fotos'] as num?)?.toInt() ?? 0,
    ocurridoEn: _fecha(j['ocurridoEn']),
    polizaId: j['polizaId'] as String?,
    tipoAuto: tipoAutoDeCodigo(j['tipoAuto']),
    resolucion: _resolucionDesdeJson(j['resolucion']),
  );
}

String siniestrosAJson(List<SiniestroReportado> casos) =>
    jsonEncode([for (final s in casos) siniestroAJson(s)]);

List<SiniestroReportado> siniestrosDesdeJson(String json) {
  final lista = jsonDecode(json);
  if (lista is! List) return const [];
  return [for (final e in lista) ?siniestroDesdeJson(e)];
}

/// Los datos de un reporte guardado, sin `id`, `cuentaId`, `estado` ni las
/// fechas de creación y cambio (van en columnas) y sin las fotos (su tabla).
String datosDeReporteAJson(ReporteGuardado r) => jsonEncode({
  'poliza': switch (r.poliza) {
    final p? => polizaAJson(p),
    null => null,
  },
  'tipoAuto': r.tipoAuto?.codigo,
  'ocurridoEn': _iso(r.ocurridoEn),
  'descripcion': r.descripcion,
  'lugar': r.lugar,
  'ciudad': r.ciudad,
  'latitud': r.ubicacion?.latitud,
  'longitud': r.ubicacion?.longitud,
  'direccionEscrita': r.direccionEscrita,
  'guardadoEn': _iso(r.guardadoEn),
  'intentos': r.intentos,
  'proximoIntentoEn': _iso(r.proximoIntentoEn),
  'ultimoError': r.ultimoError,
  'radicacionIncierta': r.radicacionIncierta,
  'datosPermitidos': r.datosPermitidos,
  'avisoWifiDado': r.avisoWifiDado,
  'resultado': switch (r.resultado) {
    final s? => siniestroAJson(s),
    null => null,
  },
  'enviadoEn': _iso(r.enviadoEn),
});

ReporteGuardado reporteDesdeDatos({
  required String id,
  required String cuentaId,
  required String estado,
  required DateTime creadoEn,
  required DateTime actualizadoEn,
  required String datos,
  List<FotoGuardada> fotos = const [],
}) {
  final j = _mapa(jsonDecode(datos));
  final latitud = j['latitud'] as num?;
  final longitud = j['longitud'] as num?;
  return ReporteGuardado(
    id: id,
    cuentaId: cuentaId,
    estado: EstadoLocal.deCodigo(estado),
    creadoEn: creadoEn,
    actualizadoEn: actualizadoEn,
    poliza: polizaDesdeJson(j['poliza']),
    tipoAuto: tipoAutoDeCodigo(j['tipoAuto']),
    ocurridoEn: _fecha(j['ocurridoEn']),
    descripcion: j['descripcion'] as String? ?? '',
    lugar: j['lugar'] as String? ?? '',
    ciudad: j['ciudad'] as String? ?? '',
    ubicacion: latitud != null && longitud != null
        ? Coordenada(latitud.toDouble(), longitud.toDouble())
        : null,
    direccionEscrita: j['direccionEscrita'] as String?,
    guardadoEn: _fecha(j['guardadoEn']),
    intentos: (j['intentos'] as num?)?.toInt() ?? 0,
    proximoIntentoEn: _fecha(j['proximoIntentoEn']),
    ultimoError: j['ultimoError'] as String?,
    radicacionIncierta: j['radicacionIncierta'] == true,
    datosPermitidos: j['datosPermitidos'] == true,
    avisoWifiDado: j['avisoWifiDado'] == true,
    resultado: siniestroDesdeJson(j['resultado']),
    enviadoEn: _fecha(j['enviadoEn']),
    fotos: fotos,
  );
}
