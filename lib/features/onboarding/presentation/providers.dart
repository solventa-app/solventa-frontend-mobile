import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../data/datasources/biometria_service.dart';
import '../data/datasources/captura_service.dart';
import '../data/datasources/fake_onboarding_remote_datasource.dart';
import '../data/datasources/onboarding_remote_datasource.dart';
import '../data/datasources/subida_archivo_service.dart';
import '../data/repositories/onboarding_repository_impl.dart';
import '../domain/repositories/onboarding_repository.dart';

/// Con `API_ENV=mock` el fake del BFF; si no, el real (contrato v0.20).
final fakeOnboardingProvider = Provider<FakeOnboardingRemoteDataSource>(
  (ref) => FakeOnboardingRemoteDataSource(),
);

final onboardingRemoteDataSourceProvider = Provider<OnboardingRemoteDataSource>(
  (ref) => ref.watch(usarFakesProvider)
      ? ref.watch(fakeOnboardingProvider)
      : GqlOnboardingRemoteDataSource(ref.watch(graphqlClientProvider)),
);

final subidaArchivoServiceProvider = Provider<SubidaArchivoService>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeSubidaArchivoService()
      : DioSubidaArchivoService(),
);

/// Guarda el id y el token del recorrido en memoria mientras dure la app.
final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(
    ref.watch(onboardingRemoteDataSourceProvider),
    ref.watch(subidaArchivoServiceProvider),
    ref.watch(sesionStoreProvider),
  ),
);

final capturaServiceProvider = Provider<CapturaService>(
  (ref) => ref.watch(usarFakesProvider)
      ? const FakeCapturaService()
      : CamaraCapturaService(),
);

/// Cuándo consulta M01-06 el resultado: a los 3, 8 y 20 s (Didit tarda de 2 a
/// 5 s). Después para y ofrece «Actualizar»: no sondea sin fin.
final esperasVerificacionProvider = Provider<List<Duration>>(
  (ref) => const [
    Duration(seconds: 3),
    Duration(seconds: 5),
    Duration(seconds: 12),
  ],
);

final biometriaServiceProvider = Provider<BiometriaService>(
  (ref) => FakeBiometriaService(),
);
