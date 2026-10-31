import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../data/datasources/biometria_service.dart';
import '../data/datasources/captura_service.dart';
import '../data/datasources/fake_onboarding_remote_datasource.dart';
import '../data/datasources/onboarding_remote_datasource.dart';
import '../data/datasources/subida_archivo_service.dart';
import '../data/repositories/onboarding_repository_impl.dart';
import '../domain/repositories/onboarding_repository.dart';

/// Con `API_ENV=mock` el fake del BFF; si no, el real (contrato v0.21).
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

/// Indica si el visor de cámara en vivo debe inicializarse dentro del marco.
/// En el emulador o teléfono se activa siempre (tanto en `local.json` como en
/// `mock.json`); solo se desactiva durante `flutter test` para mantener las
/// pruebas y goldens deterministas.
final camaraEnVivoHabilitadaProvider = Provider<bool>(
  (ref) => !esEntornoDePruebas,
);

/// Captura de respaldo (sin cámara) permitida con `API_ENV=mock` o `local`.
final respaldoCapturaPermitidoProvider = Provider<bool>(
  (ref) => const {'mock', 'local'}.contains(ref.watch(apiEnvProvider)),
);

final capturaServiceProvider = Provider<CapturaService>(
  (ref) => ref.watch(camaraEnVivoHabilitadaProvider)
      ? CamaraCapturaService(
          permitirRespaldo: ref.watch(respaldoCapturaPermitidoProvider),
        )
      : const FakeCapturaService(),
);

/// Estado del visor de cámara.
enum EstadoCamara {
  iniciando,
  lista,
  sinPermiso,
  sinPermisoPermanente,
  sinCamara,
}

/// Solo para pruebas y goldens: fija el estado del visor sin abrir la cámara.
final estadoCamaraForzadoProvider = Provider<EstadoCamara?>((ref) => null);

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
  (ref) => ref.watch(usarFakesProvider)
      ? FakeBiometriaService()
      : LocalAuthBiometriaService(),
);
