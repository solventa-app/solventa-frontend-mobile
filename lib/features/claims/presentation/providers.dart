import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/resultado.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/network/subida_archivo_service.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../data/datasources/reporte_siniestro_remote_datasource.dart';
import '../data/repositories/reporte_siniestro_repository_impl.dart';
import '../domain/entities/reporte_siniestro.dart';
import '../domain/repositories/reporte_siniestro_repository.dart';
import 'reporte_notifier.dart';

bool get _enPruebas => Platform.environment.containsKey('FLUTTER_TEST');

/// Con `API_ENV=mock` el fake; si no, el BFF real (contrato v0.35).
final reporteSiniestroRemoteDataSourceProvider =
    Provider<ReporteSiniestroRemoteDataSource>(
      (ref) => ref.watch(usarFakesProvider)
          ? FakeReporteSiniestroRemoteDataSource()
          : GqlReporteSiniestroRemoteDataSource(
              ref.watch(graphqlClientProvider),
            ),
    );

final subidaFotoSiniestroProvider = Provider<SubidaArchivoService>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeSubidaArchivoService()
      : DioSubidaArchivoService(),
);

/// Uno por app: recuerda las fotos ya subidas de cada reporte para reintentar.
final reporteSiniestroRepositoryProvider = Provider<ReporteSiniestroRepository>(
  (ref) => ReporteSiniestroRepositoryImpl(
    ref.watch(reporteSiniestroRemoteDataSourceProvider),
    ref.watch(subidaFotoSiniestroProvider),
  ),
);

/// GPS real en `local`, `dev` y `prod`; fijo (Bogotá) con `mock` y en pruebas.
final ubicacionReporteProvider = Provider<UbicacionService>(
  (ref) => _enPruebas || ref.watch(usarFakesProvider)
      ? FakeUbicacionService()
      : const GeolocatorUbicacionService(),
);

/// Cámara en vivo en emulador y teléfono; apagada en `flutter test`.
final camaraReporteHabilitadaProvider = Provider<bool>((ref) => !_enPruebas);

/// Hora de la toma (fija en pruebas).
final relojReporteProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final polizasReportablesProvider =
    FutureProvider.autoDispose<Resultado<List<PolizaReportable>>>(
      (ref) => ref.watch(reporteSiniestroRepositoryProvider).polizas(),
    );

final reporteProvider = NotifierProvider<ReporteNotifier, ReporteState>(
  ReporteNotifier.new,
);
