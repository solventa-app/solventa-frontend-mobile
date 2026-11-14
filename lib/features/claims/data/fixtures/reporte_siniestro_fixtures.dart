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
            'producto': 'VIDA_DEUDOR',
            'vehiculo': null,
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
            // KAN-290: la póliza de auto de demo (Mazda de la placa ABC123).
            'producto': 'AUTO',
            'vehiculo': {
              '__typename': 'VehiculoAsegurado',
              'marca': 'MAZDA',
              'placaEnmascarada': 'ABC•••',
            },
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
      'tipoSiniestroAuto': null, // KAN-290: solo en pólizas de auto
      'resolucion': null, // v0.37: null mientras está PENDIENTE
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

  static Map<String, Object?> _caso(
    String id,
    String radicado,
    String estado,
    String notificadoEn, [
    Map<String, Object?>? resolucion,
  ]) => {
    '__typename': 'SiniestroReportado',
    'id': id,
    'radicado': radicado,
    'estado': estado,
    'polizaId': 'pol-demo-01',
    'ocurridoEn': notificadoEn,
    'notificadoEn': notificadoEn,
    'venceDictamenEn': '2026-11-06T22:00:00+00:00',
    'fotos': 2,
    'tipoSiniestroAuto': null,
    'resolucion': resolucion,
  };

  /// `misSiniestros`: los que reportó en esta sesión del fake (PENDIENTE) y,
  /// con [conDemo], uno de cada estado de la mesa.
  static Map<String, Object?> misSiniestros({
    List<String> nuevos = const [],
    bool conDemo = true,
  }) => {
    '__typename': 'Query',
    'misSiniestros': [
      for (final (i, id) in nuevos.indexed)
        _caso(
          id,
          'SIN-2026-${1001 + i}',
          'PENDIENTE',
          '2026-11-04T15:00:00+00:00',
        ),
      if (conDemo) ...[
        _caso(
          'demo-2',
          'SIN-2026-0987',
          'EN_REVISION',
          '2026-10-28T15:00:00+00:00',
        ),
        _caso(
          'demo-3',
          'SIN-2026-0942',
          'APROBADO',
          '2026-10-15T15:00:00+00:00',
          {
            '__typename': 'ResolucionCliente',
            'tipo': 'APROBACION',
            'resueltaEn': '2026-10-17T15:00:00+00:00',
            'motivo': null,
            'viaRecurso': null,
            'indemnizacion': {
              '__typename': 'Monto',
              'valor': '4500000.00',
              'moneda': 'COP',
            },
            'plazoDispersion': '5 días hábiles',
          },
        ),
        _caso(
          'demo-4',
          'SIN-2026-0915',
          'RECHAZADO',
          '2026-10-02T15:00:00+00:00',
          {
            '__typename': 'ResolucionCliente',
            'tipo': 'RECHAZO',
            'resueltaEn': '2026-10-04T15:00:00+00:00',
            'motivo': 'EVIDENCIA_INSUFICIENTE',
            'viaRecurso': 'Escribe a soporte con tu radicado.',
            'indemnizacion': null,
            'plazoDispersion': null,
          },
        ),
      ],
    ],
  };
}
