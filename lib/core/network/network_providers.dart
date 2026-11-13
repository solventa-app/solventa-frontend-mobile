import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../config/app_config.dart';
import '../l10n/l10n.dart';
import '../sesion/gestor_sesion.dart';
import '../sesion/llavero_sesion.dart';
import '../sesion/sesion_remota.dart';
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
  dio.addSentry(captureFailedRequests: false);
  ref.onDispose(dio.close);
  return dio;
});

/// Par RSA del Keystore que protege el refresh (HU-M02). Una llave por
/// ambiente; con `API_ENV=mock`, un llavero en memoria.
final llaveroSesionProvider = Provider<LlaveroSesion>(
  (ref) => ref.watch(usarFakesProvider)
      ? LlaveroSesionMemoria()
      : LlaveroSesionNativo(
          alias: '${ref.watch(apiEnvProvider)}.solventa.sesion.llave',
        ),
);

/// Dónde se guarda el refresh cifrado: almacenamiento seguro del dispositivo
/// con prefijo de ambiente; con `API_ENV=mock`, solo memoria.
final sesionStoreProvider = Provider<SesionStore>(
  (ref) => ref.watch(usarFakesProvider)
      ? MemoriaSesionStore()
      : SecureSesionStore(
          ref.watch(llaveroSesionProvider),
          ambiente: ref.watch(apiEnvProvider),
        ),
);

/// Cliente para `renovarSesion` y `cerrarSesion`: sin token ni renovación
/// automática (si renovar falla por sesión, no se vuelve a renovar).
final graphqlClientSesionProvider = Provider<GraphqlClient>(
  (ref) => GraphqlClient(
    ref.watch(dioProvider),
    leerIdioma: () => ref.read(localeProvider).languageCode,
  ),
);

final sesionRemotaProvider = Provider<SesionRemota>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeSesionRemota()
      : GqlSesionRemota(ref.watch(graphqlClientSesionProvider)),
);

/// Dueño de la sesión: JWT y refresh en memoria, refresh cifrado en disco,
/// renovación con candado y período de gracia.
final gestorSesionProvider = Provider<GestorSesion>((ref) {
  final gestor = GestorSesion(
    store: ref.watch(sesionStoreProvider),
    remota: ref.watch(sesionRemotaProvider),
  );
  ref.onDispose(gestor.dispose);
  return gestor;
});

/// Lector del JWT de la sesión abierta (o `null` sin sesión).
final lectorTokenProvider = Provider<LectorToken>((ref) {
  final gestor = ref.watch(gestorSesionProvider);
  return () async => gestor.token;
});

final graphqlClientProvider = Provider<GraphqlClient>((ref) {
  final gestor = ref.watch(gestorSesionProvider);
  return GraphqlClient(
    ref.watch(dioProvider),
    leerIdioma: () => ref.read(localeProvider).languageCode,
    leerToken: ref.watch(lectorTokenProvider),
    renovarSesion: () async =>
        await gestor.renovar() == ResultadoRenovar.renovada,
  );
});
