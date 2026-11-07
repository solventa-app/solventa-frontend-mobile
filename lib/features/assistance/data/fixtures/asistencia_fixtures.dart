/// Respuesta de demo de `catalogoPrestadores`: copia exacta de la semilla que
/// carga el backend (`docs/hu-m06/prestadores-semilla.json`). La prueba
/// `test/contract/prestadores_semilla_test.dart` falla si se desalinean.
///
/// El contrato del BFF todavía no tiene la operación (KAN-263); la forma es la
/// propuesta en `docs/hu-m06-backend.md`.
abstract final class AsistenciaFixtures {
  static const String version = '2026-11-04.1';

  static const List<Map<String, Object?>> prestadores = [
    {
      'id': 'prs-bog-001',
      'nombre': 'Clínica Norte',
      'tipo': 'MEDICO',
      'ciudad': 'Bogotá',
      'latitud': 4.6859,
      'longitud': -74.0524,
      'activo': true,
    },
    {
      'id': 'prs-bog-002',
      'nombre': 'Taller AutoAyuda',
      'tipo': 'MECANICO',
      'ciudad': 'Bogotá',
      'latitud': 4.6835,
      'longitud': -74.0322,
      'activo': true,
    },
    {
      'id': 'prs-bog-003',
      'nombre': 'Centro Médico Sur',
      'tipo': 'MEDICO',
      'ciudad': 'Bogotá',
      'latitud': 4.6536,
      'longitud': -74.0555,
      'activo': true,
    },
    {
      'id': 'prs-bog-004',
      'nombre': 'Taller Express 80',
      'tipo': 'MECANICO',
      'ciudad': 'Bogotá',
      'latitud': 4.695,
      'longitud': -74.087,
      'activo': true,
    },
    {
      'id': 'prs-bog-005',
      'nombre': 'Clínica del Parque',
      'tipo': 'MEDICO',
      'ciudad': 'Bogotá',
      'latitud': 4.628,
      'longitud': -74.065,
      'activo': true,
    },
    {
      'id': 'prs-bog-006',
      'nombre': 'Mecánica Rápida Occidente',
      'tipo': 'MECANICO',
      'ciudad': 'Bogotá',
      'latitud': 4.629,
      'longitud': -74.15,
      'activo': true,
    },
    {
      'id': 'prs-med-001',
      'nombre': 'Clínica El Poblado',
      'tipo': 'MEDICO',
      'ciudad': 'Medellín',
      'latitud': 6.2088,
      'longitud': -75.568,
      'activo': true,
    },
    {
      'id': 'prs-med-002',
      'nombre': 'Taller Las Palmas',
      'tipo': 'MECANICO',
      'ciudad': 'Medellín',
      'latitud': 6.22,
      'longitud': -75.56,
      'activo': true,
    },
    {
      'id': 'prs-cal-001',
      'nombre': 'Centro Médico Granada',
      'tipo': 'MEDICO',
      'ciudad': 'Cali',
      'latitud': 3.46,
      'longitud': -76.532,
      'activo': true,
    },
    {
      'id': 'prs-cal-002',
      'nombre': 'Taller Autopista Sur',
      'tipo': 'MECANICO',
      'ciudad': 'Cali',
      'latitud': 3.4,
      'longitud': -76.52,
      'activo': true,
    },
    {
      'id': 'prs-baq-001',
      'nombre': 'Clínica Alto Prado',
      'tipo': 'MEDICO',
      'ciudad': 'Barranquilla',
      'latitud': 11.004,
      'longitud': -74.811,
      'activo': true,
    },
    {
      'id': 'prs-baq-002',
      'nombre': 'Taller Vía 40',
      'tipo': 'MECANICO',
      'ciudad': 'Barranquilla',
      'latitud': 11.01,
      'longitud': -74.79,
      'activo': true,
    },
  ];

  /// `data.catalogoPrestadores` completo.
  static const Map<String, Object?> catalogo = {
    'version': version,
    'vigente': false,
    'prestadores': prestadores,
  };

  /// `data.catalogoPrestadores` cuando la copia del teléfono ya es la vigente.
  static const Map<String, Object?> catalogoVigente = {
    'version': version,
    'vigente': true,
    'prestadores': <Map<String, Object?>>[],
  };
}
