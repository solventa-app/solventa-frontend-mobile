/// Respuestas del BFF (`data`) para el fake de HU-M05 y las pruebas de
/// contrato (contrato v0.35).
abstract final class ReporteSiniestroFixtures {
  static const Map<String, Object?> polizas = {
    '__typename': 'Query',
    'propuestas': {
      '__typename': 'PaginaPropuestas',
      'propuestas': [
        {
          '__typename': 'Propuesta',
          'poliza': {
            '__typename': 'Poliza',
            'id': 'pol-demo-01',
            'numero': 'SOL-2026-000123',
            'vigenciaDesde': '2026-02-10T05:00:00+00:00',
            'vigenciaHasta': '2027-02-10T05:00:00+00:00',
          },
        },
        {
          '__typename': 'Propuesta',
          'poliza': {
            '__typename': 'Poliza',
            'id': 'pol-demo-02',
            'numero': 'SOL-2026-000456',
            'vigenciaDesde': '2026-06-01T05:00:00+00:00',
            'vigenciaHasta': '2027-06-01T05:00:00+00:00',
          },
        },
      ],
    },
  };

  static Map<String, Object?> subida(String archivoId) => {
    '__typename': 'Mutation',
    'solicitarSubidaEvidenciaSiniestro': {
      '__typename': 'SubidaArchivo',
      'url': 'https://almacen.demo/$archivoId',
      'metodo': 'PUT',
      'encabezados': [
        {
          '__typename': 'EncabezadoSubida',
          'nombre': 'Content-Type',
          'valor': 'image/jpeg',
        },
      ],
      'archivo': {'__typename': 'Archivo', 'id': archivoId},
    },
  };

  static Map<String, Object?> confirmada(String archivoId) => {
    '__typename': 'Mutation',
    'confirmarSubidaArchivo': {
      '__typename': 'Archivo',
      'id': archivoId,
      'estado': 'DISPONIBLE',
    },
  };

  static Map<String, Object?> reportado(String id, int fotos) => {
    '__typename': 'Mutation',
    'reportarSiniestro': {
      '__typename': 'SiniestroReportado',
      'id': id,
      'radicado': 'SIN-2026-1001',
      'estado': 'PENDIENTE',
      'polizaId': 'pol-demo-01',
      'ocurridoEn': '2026-11-04T13:00:00+00:00',
      'notificadoEn': '2026-11-04T15:00:00+00:00',
      'venceDictamenEn': '2026-11-06T22:00:00+00:00',
      'fotos': fotos,
    },
  };

  static const Map<String, Object?> rechazado = {
    '__typename': 'Mutation',
    'reportarSiniestro': {
      '__typename': 'ErrorSiniestro',
      'mensaje':
          'La fecha del siniestro está fuera de la vigencia de la póliza.',
    },
  };
}
