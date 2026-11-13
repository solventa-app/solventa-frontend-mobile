import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/prestadores_state.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/mapa/mapa_datos.dart';

/// HU-M06 M12: solo la primera carga bloquea y una recarga desde el mismo
/// lugar (menos de 500 m) no recalcula. M14: el estilo se alterna.
void main() {
  late FakeUbicacionService gps;
  late ProviderContainer c;

  setUp(() {
    gps = FakeUbicacionService();
    c = ProviderContainer(
      overrides: [
        asistenciaRemoteDataSourceProvider.overrideWithValue(
          FakeAsistenciaRemoteDataSource(latencia: Duration.zero),
        ),
        catalogoLocalDataSourceProvider.overrideWithValue(
          MemoriaCatalogoLocalDataSource(),
        ),
        ubicacionServiceProvider.overrideWithValue(gps),
      ],
    );
    addTearDown(c.dispose);
  });

  test(
    'una recarga no vuelve a «cargando» y sin moverse no recalcula',
    () async {
      final sub = c.listen(
        prestadoresProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(sub.close);
      final notifier = c.read(prestadoresProvider.notifier);
      await notifier.cargar();
      final primero = c.read(prestadoresProvider);
      expect(primero, isA<PrestadoresListos>());

      final estados = <PrestadoresState>[];
      c.listen(prestadoresProvider, (_, s) => estados.add(s));
      gps.resultado = const UbicacionObtenida(Coordenada(4.6790, -74.0483));
      await notifier.cargar();
      expect(estados.whereType<PrestadoresCargando>(), isEmpty);
      expect(identical(c.read(prestadoresProvider), primero), isTrue);

      // A más de 500 m sí recalcula, también sin pasar por «cargando».
      gps.resultado = const UbicacionObtenida(Coordenada(6.2088, -75.5680));
      await notifier.cargar();
      final medellin = c.read(prestadoresProvider) as PrestadoresListos;
      expect(estados.whereType<PrestadoresCargando>(), isEmpty);
      expect(medellin.destacados.first.prestador.ciudad, 'Medellín');
    },
  );

  test('M14: calles por defecto y el botón alterna con satélite', () async {
    expect(c.read(estiloMapaProvider), EstiloMapa.calles);
    await c.read(estiloMapaProvider.notifier).alternar();
    expect(c.read(estiloMapaProvider), EstiloMapa.satelite);
    await c.read(estiloMapaProvider.notifier).alternar();
    expect(c.read(estiloMapaProvider), EstiloMapa.calles);
  });
}
