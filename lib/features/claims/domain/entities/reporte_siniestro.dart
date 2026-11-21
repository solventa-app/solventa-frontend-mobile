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
    this.polizaId,
    this.tipoAuto,
  });

  final String id;
  final String radicado;

  /// La póliza del caso (para mostrar el vehículo en la lista).
  final String? polizaId;

  /// Qué le pasó al vehículo; `null` en pólizas que no son de auto.
  final TipoSiniestroAuto? tipoAuto;

  /// Vencido el plazo, ¿el sistema lo aprueba solo? No en auto parcial o RC:
  /// el operador valora el daño (KAN-290).
  bool get apruebaAlVencer => !const {
    TipoSiniestroAuto.choqueParcial,
    TipoSiniestroAuto.hurtoParcial,
    TipoSiniestroAuto.responsabilidadCivil,
  }.contains(tipoAuto);

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

/// Una foto que el cliente subió con su reporte, ya en el almacenamiento
/// (M05-07). [url] es una URL firmada que vence en minutos; vacía si el archivo
/// no está disponible.
final class FotoDelCaso {
  const FotoDelCaso({
    required this.id,
    required this.url,
    required this.registradaEn,
  });

  final String id;
  final String url;
  final DateTime registradaEn;
}

/// Un paso de la línea de tiempo del caso: `PENDIENTE` al reportar,
/// `EN_REVISION` si pasó a un perito, y `APROBADO` o `RECHAZADO`.
final class HitoDelCaso {
  const HitoDelCaso({required this.estado, required this.en});

  final String estado;
  final DateTime en;
}

/// La póliza del caso, como la ve el cliente en el detalle.
final class PolizaDelCaso {
  const PolizaDelCaso({
    required this.numero,
    required this.esAuto,
    this.vehiculo,
  });

  final String numero;
  final bool esAuto;

  /// «Mazda 3 · ABC•••» en una póliza de auto.
  final String? vehiculo;
}

/// El detalle completo de un caso del cliente (M05-07, contrato v0.54).
final class DetalleSiniestro {
  const DetalleSiniestro({
    required this.id,
    required this.radicado,
    required this.estado,
    required this.ocurridoEn,
    required this.notificadoEn,
    required this.venceDictamenEn,
    required this.descripcion,
    required this.lugar,
    required this.ciudad,
    required this.poliza,
    required this.fotos,
    required this.historial,
    required this.apruebaAlVencer,
    this.tipoAuto,
    this.resolucion,
  });

  final String id;
  final String radicado;

  /// `PENDIENTE`, `EN_REVISION`, `APROBADO` o `RECHAZADO` (contrato).
  final String estado;
  final DateTime ocurridoEn;
  final DateTime notificadoEn;
  final DateTime venceDictamenEn;
  final String descripcion;
  final String lugar;
  final String ciudad;
  final PolizaDelCaso poliza;
  final List<FotoDelCaso> fotos;
  final List<HitoDelCaso> historial;

  /// Vencido el plazo estando `PENDIENTE`, el sistema lo aprueba solo. `false`
  /// en auto parcial o de responsabilidad civil: el operador valora el daño.
  final bool apruebaAlVencer;
  final TipoSiniestroAuto? tipoAuto;

  /// `null` mientras está `PENDIENTE`.
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
