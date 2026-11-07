import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../data/datasources/asistencia_remote_datasource.dart';
import '../data/datasources/catalogo_local_datasource.dart';
import '../data/datasources/ruta_externa_service.dart';
import '../data/repositories/asistencia_repository_impl.dart';
import '../domain/repositories/asistencia_repository.dart';
import 'prestadores_notifier.dart';
import 'prestadores_state.dart';

bool get _enPruebas => Platform.environment.containsKey('FLUTTER_TEST');

/// Con `API_ENV=mock` el fake con la semilla; si no, `catalogoPrestadores` del
/// BFF (contrato v0.36, KAN-263).
final asistenciaRemoteDataSourceProvider = Provider<AsistenciaRemoteDataSource>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeAsistenciaRemoteDataSource()
      : GqlAsistenciaRemoteDataSource(ref.watch(graphqlClientProvider)),
);

/// Copia del catálogo en el teléfono (en memoria durante las pruebas).
final catalogoLocalDataSourceProvider = Provider<CatalogoLocalDataSource>(
  (ref) => _enPruebas
      ? MemoriaCatalogoLocalDataSource()
      : const PrefsCatalogoLocalDataSource(),
);

final asistenciaRepositoryProvider = Provider<AsistenciaRepository>(
  (ref) => AsistenciaRepositoryImpl(
    ref.watch(asistenciaRemoteDataSourceProvider),
    ref.watch(catalogoLocalDataSourceProvider),
  ),
);

/// GPS real en `local`, `dev` y `prod`. Con `mock` y en pruebas, una ubicación
/// fija en Bogotá para que la demo siempre tenga prestadores cerca (el
/// emulador arranca en California).
final ubicacionServiceProvider = Provider<UbicacionService>(
  (ref) => _enPruebas || ref.watch(usarFakesProvider)
      ? FakeUbicacionService()
      : const GeolocatorUbicacionService(),
);

final rutaExternaServiceProvider = Provider<RutaExternaService>(
  (ref) => const UrlLauncherRutaExternaService(),
);

/// Plantilla de teselas del mapa (`MAP_TILE_URL`). Vacía = sin teselas
/// (pruebas y goldens, sin red).
final plantillaTeselasProvider = Provider<String>(
  (ref) => _enPruebas ? '' : AppConfig.mapTileUrl,
);

final prestadoresProvider =
    NotifierProvider.autoDispose<PrestadoresNotifier, PrestadoresState>(
      PrestadoresNotifier.new,
    );
