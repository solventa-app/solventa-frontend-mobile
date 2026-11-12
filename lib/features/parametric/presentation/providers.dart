import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/resultado.dart';
import '../../../core/network/network_providers.dart';
import '../data/datasources/cobertura_remote_datasource.dart';
import '../data/fixtures/cobertura_fixtures.dart';
import '../data/repositories/cobertura_repository_impl.dart';
import '../domain/entities/cobertura.dart';
import '../domain/repositories/cobertura_repository.dart';

export '../data/fixtures/cobertura_fixtures.dart' show EscenarioCobertura;

/// Escenario de los datos mock de M04-04 (sin saldo, a favor o en contra).
/// Solo tiene efecto con `API_ENV=mock` (ver [coberturaRemoteDataSourceProvider]).
class EscenarioNotifier extends Notifier<EscenarioCobertura> {
  @override
  EscenarioCobertura build() => EscenarioCobertura.aFavor;

  void cambiar(EscenarioCobertura escenario) => state = escenario;
}

final escenarioCoberturaProvider =
    NotifierProvider<EscenarioNotifier, EscenarioCobertura>(
      EscenarioNotifier.new,
    );

/// Con `API_ENV=mock` el fake con los mockups; si no, `indemnizacion`/
/// `miCoberturaParametrica` del BFF (contrato v0.48, KAN-259).
final coberturaRemoteDataSourceProvider = Provider<CoberturaRemoteDataSource>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeCoberturaRemoteDataSource(
          escenario: ref.watch(escenarioCoberturaProvider),
        )
      : GqlCoberturaRemoteDataSource(ref.watch(graphqlClientProvider)),
);

final coberturaRepositoryProvider = Provider<CoberturaRepository>(
  (ref) =>
      CoberturaRepositoryImpl(ref.watch(coberturaRemoteDataSourceProvider)),
);

/// M04-04: se recarga al volver a entrar (autoDispose) o al tirar hacia abajo.
final resumenCoberturaProvider =
    FutureProvider.autoDispose<Resultado<ResumenCobertura>>(
      (ref) => ref.watch(coberturaRepositoryProvider).resumen(),
    );

/// M04-02 y M04-03.
final indemnizacionProvider = FutureProvider.autoDispose
    .family<Resultado<Indemnizacion>, String>(
      (ref, id) => ref.watch(coberturaRepositoryProvider).indemnizacion(id),
    );
