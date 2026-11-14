import 'dart:typed_data';

import '../../../../core/ubicacion/coordenada.dart';

/// Póliza del cliente sobre la que puede reportar (M05-01).
final class PolizaReportable {
  const PolizaReportable({
    required this.id,
    required this.numero,
    required this.vigenciaDesde,
    required this.vigenciaHasta,
    this.esAuto = false,
    this.vehiculo,
  });

  final String id;
  final String numero;
  final DateTime vigenciaDesde;
  final DateTime vigenciaHasta;

  /// KAN-290: póliza de auto todo riesgo. Su reporte exige [TipoSiniestroAuto].
  final bool esAuto;

  /// «MAZDA ABC•••» en una póliza de auto (la placa llega enmascarada).
  final String? vehiculo;

  bool cubre(DateTime fecha) =>
      !fecha.isBefore(vigenciaDesde) && !fecha.isAfter(vigenciaHasta);
}

/// KAN-290: qué le pasó al vehículo (contrato v0.42, `TipoSiniestroAuto`). Decide
/// la cobertura y cómo se calcula la indemnización.
enum TipoSiniestroAuto {
  choqueParcial('CHOQUE_PARCIAL'),
  perdidaTotalDanos('PERDIDA_TOTAL_DANOS'),
  hurtoTotal('HURTO_TOTAL'),
  hurtoParcial('HURTO_PARCIAL'),
  responsabilidadCivil('RESPONSABILIDAD_CIVIL');

  const TipoSiniestroAuto(this.codigo);

  /// El valor del enum en el contrato.
  final String codigo;
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
    this.tipoAuto,
  });

  final String idReporte;
  final PolizaReportable poliza;

  /// Solo en una póliza de auto.
  final TipoSiniestroAuto? tipoAuto;
  final DateTime ocurridoEn;
  final String descripcion;
  final String lugar;
  final String ciudad;
  final Coordenada ubicacion;
  final List<FotoSiniestro> fotos;
}

/// Cómo terminó la revisión de un caso, lo que el cliente puede ver (M05-07).
/// Sin el comentario del operador ni datos del perito: el contrato no los envía.
final class ResolucionSiniestro {
  const ResolucionSiniestro({
    required this.tipo,
    required this.resueltaEn,
    this.motivo,
    this.viaRecurso,
    this.indemnizacion,
    this.plazoDispersion,
  });

  /// `APROBACION`, `RECHAZO` o `DERIVACION` (en revisión con un perito).
  final String tipo;
  final DateTime resueltaEn;

  /// Solo en un rechazo: `EVIDENCIA_INSUFICIENTE`, `FUERA_DE_COBERTURA`,
  /// `POLIZA_NO_VIGENTE`, `INCONSISTENCIA_EN_RELATO` u `OTRO`.
  final String? motivo;
  final String? viaRecurso;

  /// Solo en una aprobación, como pesos enteros.
  final num? indemnizacion;
  final String? plazoDispersion;
}

/// El caso como lo ve el cliente después de reportar (M05-05) y en su detalle
/// (M05-07).
final class SiniestroReportado {
  const SiniestroReportado({
    required this.id,
    required this.radicado,
    required this.estado,
    required this.notificadoEn,
    required this.venceDictamenEn,
    required this.fotos,
    this.ocurridoEn,
    this.resolucion,
  });

  final String id;
  final String radicado;

  /// `PENDIENTE`, `EN_REVISION`, `APROBADO` o `RECHAZADO` (contrato).
  final String estado;

  /// Cuándo se reportó.
  final DateTime notificadoEn;
  final DateTime venceDictamenEn;
  final int fotos;

  /// Cuándo ocurrió el siniestro, según el reporte.
  final DateTime? ocurridoEn;

  /// `null` mientras el caso está `PENDIENTE`.
  final ResolucionSiniestro? resolucion;
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
