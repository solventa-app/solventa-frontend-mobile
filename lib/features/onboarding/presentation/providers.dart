import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../data/datasources/consentimiento_remote_datasource.dart';
import '../data/datasources/fake_consentimiento_remote_datasource.dart';
import '../data/repositories/consentimiento_repository_impl.dart';
import '../domain/repositories/consentimiento_repository.dart';

/// Con `API_ENV=mock` usa el fake; si no, el BFF real.
final consentimientoRemoteDataSourceProvider =
    Provider<ConsentimientoRemoteDataSource>(
      (ref) => ref.watch(usarFakesProvider)
          ? const FakeConsentimientoRemoteDataSource()
          : GqlConsentimientoRemoteDataSource(ref.watch(graphqlClientProvider)),
    );

final consentimientoRepositoryProvider = Provider<ConsentimientoRepository>(
  (ref) => ConsentimientoRepositoryImpl(
    ref.watch(consentimientoRemoteDataSourceProvider),
  ),
);
