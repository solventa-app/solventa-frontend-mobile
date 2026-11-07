import 'dart:typed_data';

import '../../../../core/ubicacion/coordenada.dart';

/// Póliza del cliente sobre la que puede reportar (M05-01).
final class PolizaReportable {
  const PolizaReportable({
    required this.id,
    required this.numero,
    required this.vigenciaDesde,
    required this.vigenciaHasta,
  });

  final String id;
  final String numero;
  final DateTime vigenciaDesde;
  final DateTime vigenciaHasta;

  bool cubre(DateTime fecha) =>
      !fecha.isBefore(vigenciaDesde) && !fecha.isAfter(vigenciaHasta);
}

/// Foto del daño tomada en la app (M05-02). Vive solo en memoria hasta que se
/// sube: nunca se guarda en la galería ni en el disco.
final class FotoSiniestro {
  const FotoSiniestro({
    required this.bytes,
    required this.tipoContenido,
    required this.tomadaEn,
    this.ubicacion,
  });

  final Uint8List bytes;
  final String tipoContenido;
  final DateTime tomadaEn;

  /// Donde se tomó; `null` si no hubo permiso o GPS (queda sin geoetiqueta).
  final Coordenada? ubicacion;
}

/// Lo que el cliente envía (M05-04). [idReporte] lo genera la app y es el id
/// del siniestro: reenviar con el mismo no crea otro caso.
final class ReporteSiniestro {
  const ReporteSiniestro({
    required this.idReporte,
    required this.poliza,
    required this.ocurridoEn,
    required this.descripcion,
    required this.lugar,
    required this.ciudad,
    required this.ubicacion,
    required this.fotos,
  });

  final String idReporte;
  final PolizaReportable poliza;
  final DateTime ocurridoEn;
  final String descripcion;
  final String lugar;
  final String ciudad;
  final Coordenada ubicacion;
  final List<FotoSiniestro> fotos;
}

/// El caso como lo ve el cliente después de reportar (M05-05).
final class SiniestroReportado {
  const SiniestroReportado({
    required this.id,
    required this.radicado,
    required this.estado,
    required this.notificadoEn,
    required this.venceDictamenEn,
    required this.fotos,
  });

  final String id;
  final String radicado;

  /// `PENDIENTE`, `EN_REVISION`, `APROBADO` o `RECHAZADO` (contrato).
  final String estado;

  /// Cuándo se reportó.
  final DateTime notificadoEn;
  final DateTime venceDictamenEn;
  final int fotos;
}

/// Motivo cuando el almacenamiento no confirmó una foto (la app pide tomarla
/// de nuevo).
const motivoFotoNoConfirmada = 'FOTO_NO_CONFIRMADA';

/// Reglas del reporte que la app valida antes de enviar (las mismas de CLAIMS).
abstract final class ReglasReporte {
  static const int minFotos = 1;
  static const int maxFotos = 3;
  static const int minRelato = 10;
  static const int maxRelato = 1000;

  /// Tope del tipo `siniestro-foto` en el almacenamiento.
  static const int maxBytesFoto = 10 * 1024 * 1024;

  static bool relatoValido(String texto) {
    final t = texto.trim().length;
    return t >= minRelato && t <= maxRelato;
  }
}
