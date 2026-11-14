import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/estilo_mapa_notifier.dart';
import 'package:solventa_mobile/features/assistance/presentation/prestadores_state.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/mapa/mapa_datos.dart';

/// HU-M06 M12: solo la primera carga bloquea y una recarga desde el mismo
/// lugar (menos de 500 m) no recalcula. M14: el estilo se alterna.
void main() {
  late FakeUbicacionService gps;
  late ProviderContainer c;

  setUp(() {
    // El estilo del mapa se recuerda: cada prueba parte sin nada guardado.
    SharedPreferences.setMockInitialValues({});
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

  test(
    'M14: `usar` fija el estilo y lo recuerda (satélite que falla)',
    () async {
      SharedPreferences.setMockInitialValues({
        EstiloMapaNotifier.clave: EstiloMapa.satelite.name,
      });
      // Arranca en calles y, apenas lee lo guardado, queda en satélite.
      expect(c.read(estiloMapaProvider), EstiloMapa.calles);
      await pumpEventQueue();
      expect(c.read(estiloMapaProvider), EstiloMapa.satelite);

      await c.read(estiloMapaProvider.notifier).usar(EstiloMapa.calles);

      expect(c.read(estiloMapaProvider), EstiloMapa.calles);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(EstiloMapaNotifier.clave), EstiloMapa.calles.name);
    },
  );
}
