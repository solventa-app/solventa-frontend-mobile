import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';

void main() {
  ProviderContainer crear(String env) {
    final c = ProviderContainer(
      overrides: [
        apiEnvProvider.overrideWithValue(env),
        apiBaseUrlProvider.overrideWithValue('http://bff.test'),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('con API_ENV=mock todo es en memoria y con fakes', () {
    final c = crear('mock');

    expect(c.read(usarFakesProvider), isTrue);
    expect(c.read(llaveroSesionProvider), isA<LlaveroSesionMemoria>());
    expect(c.read(sesionStoreProvider), isA<MemoriaSesionStore>());
    expect(c.read(sesionRemotaProvider), isA<FakeSesionRemota>());
  });

  for (final env in ['local', 'dev', 'prod']) {
    test('con API_ENV=$env usa el Keystore, el almacén seguro y el BFF', () {
      final c = crear(env);

      expect(c.read(usarFakesProvider), isFalse);
      expect(c.read(llaveroSesionProvider), isA<LlaveroSesionNativo>());
      expect(c.read(sesionStoreProvider), isA<SecureSesionStore>());
      expect(c.read(sesionRemotaProvider), isA<GqlSesionRemota>());
    });
  }

  test('el Dio apunta a la URL base del gateway', () {
    final dio = crear('mock').read(dioProvider);

    expect(dio.options.baseUrl, 'http://bff.test');
    expect(dio.options.contentType, 'application/json');
  });

  test('sin sesión, el lector de token devuelve null', () async {
    final c = crear('mock');

    expect(await c.read(lectorTokenProvider)(), isNull);
  });

  test('los clientes GraphQL se construyen', () {
    final c = crear('mock');

    expect(c.read(graphqlClientProvider).renovarSesion, isNotNull);
    expect(c.read(graphqlClientSesionProvider).renovarSesion, isNull);
  });
}
