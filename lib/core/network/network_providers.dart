import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../sesion/sesion_store.dart';
import 'graphql_client.dart';

/// Ambiente del backend (`API_ENV` de `config/*.json`): `mock`, `local`, `dev` o `prod`.
///
/// Sin `--dart-define-from-file` vale `mock`: la app nunca apunta a un backend
/// por accidente. Sale de [AppConfig]; las pruebas lo sobrescriben.
final apiEnvProvider = Provider<String>((ref) => AppConfig.apiEnv);

/// `true` con `API_ENV=mock`: los datasources remotos usan su fake.
final usarFakesProvider = Provider<bool>(
  (ref) => ref.watch(apiEnvProvider) == 'mock',
);

/// URL base del gateway, sin `/` final (`API_BASE_URL`).
final apiBaseUrlProvider = Provider<String>((ref) => AppConfig.apiBaseUrl);

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ref.watch(apiBaseUrlProvider),
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

/// Dónde se guarda el JWT: almacenamiento seguro del dispositivo; con
/// `API_ENV=mock`, solo memoria (sin backend no hay sesión real).
final sesionStoreProvider = Provider<SesionStore>(
  (ref) =>
      ref.watch(usarFakesProvider) ? MemoriaSesionStore() : SecureSesionStore(),
);

/// Lector del JWT de la sesión guardada (o `null` sin sesión).
final lectorTokenProvider = Provider<LectorToken>((ref) {
  final store = ref.watch(sesionStoreProvider);
  return store.leer;
});

final graphqlClientProvider = Provider<GraphqlClient>(
  (ref) => GraphqlClient(
    ref.watch(dioProvider),
    leerToken: ref.watch(lectorTokenProvider),
  ),
);
