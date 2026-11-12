import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../data/datasources/asistencia_remote_datasource.dart';
import '../data/datasources/catalogo_local_datasource.dart';
import '../data/datasources/permiso_pedido_store.dart';
import '../data/datasources/ruta_externa_service.dart';
import '../data/repositories/asistencia_repository_impl.dart';
import '../domain/repositories/asistencia_repository.dart';
import 'estilo_mapa_notifier.dart';
import 'prestadores_notifier.dart';
import 'prestadores_state.dart';
import 'solicitud_notifier.dart';
import 'widgets/mapa/mapa_datos.dart';

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

/// Si ya se mostró el diálogo de ubicación (2.0); en memoria en pruebas.
final permisoPedidoProvider = Provider<PermisoPedidoStore>(
  (ref) => _enPruebas
      ? MemoriaPermisoPedidoStore(pedido: true)
      : const PrefsPermisoPedidoStore(),
);

final rutaExternaServiceProvider = Provider<RutaExternaService>(
  (ref) => const UrlLauncherRutaExternaService(),
);

/// Qué dibuja el mapa de M06-01 (M0): Mapbox con token; el mapa falso en
/// pruebas y con `API_ENV=mock` sin token; y fuera de mock sin token, solo la
/// lista (como si el mapa fallara, CA-M06-04).
final motorMapaProvider = Provider<MotorMapa>((ref) {
  if (_enPruebas) return MotorMapa.falso;
  if (AppConfig.mapboxAccessToken.isNotEmpty) return MotorMapa.mapbox;
  return ref.watch(usarFakesProvider) ? MotorMapa.falso : MotorMapa.ninguno;
});

/// Calles o satélite (M14), recordado entre sesiones.
final estiloMapaProvider = NotifierProvider<EstiloMapaNotifier, EstiloMapa>(
  EstiloMapaNotifier.new,
);

final prestadoresProvider =
    NotifierProvider.autoDispose<PrestadoresNotifier, PrestadoresState>(
      PrestadoresNotifier.new,
    );

/// Recorrido desde «Solicitar» (M06-02 a M06-06). No se descarta al cambiar
/// de pantalla: la asistencia confirmada sigue disponible para cancelarla.
final solicitudProvider = NotifierProvider<SolicitudNotifier, SolicitudState>(
  SolicitudNotifier.new,
);
