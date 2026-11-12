import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/prestador_mapper.dart';
import 'package:solventa_mobile/features/assistance/domain/cercania.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';

/// Parque de la 93, Bogotá (la ubicación fija de `mock`).
const _parque93 = Coordenada(4.6767, -74.0483);

void main() {
  final catalogo = catalogoDesdeMapa(AsistenciaFixtures.catalogo).prestadores;

  test('Haversine: Bogotá–Medellín ≈ 240 km', () {
    final km = Cercania.distanciaKm(
      const Coordenada(4.7110, -74.0721),
      const Coordenada(6.2442, -75.5812),
    );
    expect(km, closeTo(240, 5));
  });

  test('tiempo estimado: 20 km/h más 2 min de alistamiento', () {
    expect(Cercania.minutosEstimados(0), 2);
    expect(Cercania.minutosEstimados(1.2), 6);
    expect(Cercania.minutosEstimados(10), 32);
  });

  test('CA-M06-01: desde el Parque de la 93 salen los 3 del prototipo', () {
    final r = Cercania.masCercanos(_parque93, catalogo);
    expect(r.map((c) => c.prestador.nombre), [
      'Clínica Norte',
      'Taller AutoAyuda',
      'Centro Médico Sur',
    ]);
    expect(r.first.distanciaKm, closeTo(1.1, 0.1));
    expect(r.first.minutosEstimados, 6);
  });

  test('en Medellín solo aparecen los de Medellín (radio de 50 km)', () {
    final r = Cercania.masCercanos(
      const Coordenada(6.2442, -75.5812),
      catalogo,
    );
    expect(r, hasLength(3)); // v0.49: clínica, taller y grúa
    expect(r.every((c) => c.prestador.ciudad == 'Medellín'), isTrue);
  });

  test('lejos de todo (emulador en California): lista vacía', () {
    final r = Cercania.masCercanos(
      const Coordenada(37.422, -122.084),
      catalogo,
    );
    expect(r, isEmpty);
  });
}
