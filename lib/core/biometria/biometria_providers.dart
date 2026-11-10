import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/network_providers.dart';
import 'biometria_service.dart';

/// Biometría del teléfono (M01-08 y M02). Con `API_ENV=mock`, un fake que
/// siempre autentica (el disparador de demo de M02 cambia su respuesta).
final biometriaServiceProvider = Provider<BiometriaService>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeBiometriaService()
      : LocalAuthBiometriaService(),
);

/// Qué método biométrico tiene el teléfono (ícono y texto de M02-01). Mientras carga se asume la huella.
final tipoBiometriaProvider = FutureProvider<TipoBiometria>(
  (ref) => ref.watch(biometriaServiceProvider).tipo(),
);
