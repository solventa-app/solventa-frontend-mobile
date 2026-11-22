import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/almacen/almacen_providers.dart';
import '../../../core/errors/resultado.dart';
import '../../../core/network/network_providers.dart';
import '../../../core/network/subida_archivo_service.dart';
import '../../../core/red/estado_red_notifier.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../data/cola_reportes.dart';
import '../data/datasources/reporte_siniestro_remote_datasource.dart';
import '../data/local/almacen_reportes_drift.dart';
import '../data/local/almacen_reportes_memoria.dart';
import '../data/local/copias_reporte.dart';
import '../data/notificaciones_reporte.dart';
import '../data/preferencias_envio.dart';
import '../data/repositories/reporte_siniestro_repository_impl.dart';
import '../domain/entities/reporte_guardado.dart';
import '../domain/entities/reporte_siniestro.dart';
import '../domain/repositories/almacen_reportes.dart';
import '../domain/repositories/reporte_siniestro_repository.dart';
import 'reporte_notifier.dart';

bool get _enPruebas => Platform.environment.containsKey('FLUTTER_TEST');

/// Con `API_ENV=mock` el fake; si no, el BFF real (contrato v0.35). El fake
/// respeta la red simulada de la demo: sin conexión, falla como el real.
final reporteSiniestroRemoteDataSourceProvider =
    Provider<ReporteSiniestroRemoteDataSource>((ref) {
      if (!ref.watch(usarFakesProvider)) {
        return GqlReporteSiniestroRemoteDataSource(
          ref.watch(graphqlClientProvider),
        );
      }
      final fake = FakeReporteSiniestroRemoteDataSource();
      ref.listen(
        estadoRedProvider.select((red) => red.conectado),
        (_, conectado) => fake.sinRed = !conectado,
        fireImmediately: true,
      );
      return fake;
    });

/// Con `API_ENV=mock` cada foto tarda un momento, para ver avanzar la barra.
final subidaFotoSiniestroProvider = Provider<SubidaArchivoService>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeSubidaArchivoService(
          latencia: _enPruebas
              ? Duration.zero
              : const Duration(milliseconds: 900),
        )
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

/// Reportes guardados en el teléfono: la base cifrada, o memoria con
/// `API_ENV=mock` y en pruebas.
final almacenReportesProvider = Provider<AlmacenReportes>((ref) {
  final almacen = ref.watch(almacenEnDiscoProvider)
      ? AlmacenReportesDrift(ref.watch(baseLocalProvider))
      : AlmacenReportesMemoria();
  ref.onDispose(almacen.cerrar);
  return almacen;
});

/// La cuenta dueña de lo que se guarda en el teléfono. `null` sin sesión: no
/// se guarda nada.
final cuentaReporteProvider = Provider<String?>(
  (ref) => ref.watch(cuentaActualProvider),
);

final copiasReporteProvider = Provider<CopiasReporte>(
  (ref) => CopiasReporte(
    repositorio: ref.watch(reporteSiniestroRepositoryProvider),
    local: ref.watch(almacenLocalProvider),
    cuenta: () => ref.read(cuentaReporteProvider),
    conectado: () => ref.read(estadoRedProvider).conectado,
    reloj: ref.watch(relojReporteProvider),
  ),
);

/// Los reportes de la cuenta guardados en el teléfono (borradores, por enviar
/// y recién enviados), al día con cada cambio.
final reportesGuardadosProvider = StreamProvider<List<ReporteGuardado>>((
  ref,
) async* {
  final cuenta = ref.watch(cuentaReporteProvider);
  if (cuenta == null) {
    yield const [];
    return;
  }
  final almacen = ref.watch(almacenReportesProvider);
  yield await almacen.deCuenta(cuenta);
  await for (final _ in almacen.cambios) {
    yield await almacen.deCuenta(cuenta);
  }
});

/// Los que aún no tienen radicado, el de la última edición primero.
final reportesPorEnviarProvider = Provider<List<ReporteGuardado>>(
  (ref) => [
    for (final r
        in ref.watch(reportesGuardadosProvider).value ??
            const <ReporteGuardado>[])
      if (r.porEnviar) r,
  ]..sort((a, b) => b.actualizadoEn.compareTo(a.actualizadoEn)),
);

/// M05-01: las pólizas, o su última copia si no hay conexión.
final polizasConCopiaProvider =
    FutureProvider.autoDispose<Resultado<ConCopia<List<PolizaReportable>>>>(
      (ref) => ref.watch(copiasReporteProvider).polizas(),
    );

final polizasReportablesProvider =
    FutureProvider.autoDispose<Resultado<List<PolizaReportable>>>(
      (ref) async => switch (await ref.watch(polizasConCopiaProvider.future)) {
        Exito(:final valor) => Exito(valor.valor),
        Fracaso(:final falla) => Fracaso(falla),
      },
    );

/// M05-06: se recarga al volver a entrar (autoDispose) o al tirar hacia abajo.
/// Sin conexión muestra la última copia con su hora.
final misSiniestrosProvider =
    FutureProvider.autoDispose<Resultado<ConCopia<List<SiniestroReportado>>>>(
      (ref) => ref.watch(copiasReporteProvider).misSiniestros(),
    );

/// M05-07 (v0.54): el detalle de un caso. Se vuelve a pedir al tirar hacia
/// abajo, cuando vence la URL de una foto o, vencido el plazo, hasta ver el
/// cambio de estado.
final miSiniestroProvider = FutureProvider.autoDispose
    .family<Resultado<DetalleSiniestro?>, String>(
      (ref, id) =>
          ref.watch(reporteSiniestroRepositoryProvider).miSiniestro(id),
    );

final reporteProvider = NotifierProvider<ReporteNotifier, ReporteState>(
  ReporteNotifier.new,
);

final preferenciasEnvioStoreProvider = Provider<PreferenciasEnvioStore>(
  (ref) => _enPruebas
      ? MemoriaPreferenciasEnvioStore()
      : const PrefsPreferenciasEnvioStore(),
);

/// «Enviar las fotos solo con Wi-Fi» y lo que ya se le preguntó al cliente.
final class PreferenciasEnvioNotifier extends Notifier<PreferenciasEnvio> {
  @override
  PreferenciasEnvio build() {
    unawaited(_cargar());
    return const PreferenciasEnvio();
  }

  Future<void> _cargar() async {
    final guardadas = await ref.read(preferenciasEnvioStoreProvider).leer();
    if (ref.mounted) state = guardadas;
  }

  Future<void> _fijar(PreferenciasEnvio nuevas) async {
    state = nuevas;
    await ref.read(preferenciasEnvioStoreProvider).guardar(nuevas);
  }

  /// El interruptor de Mi perfil: ya no hace falta preguntar.
  Future<void> fijarSoloWifi({required bool soloWifi}) =>
      _fijar(state.copyWith(soloWifi: soloWifi, preguntado: true));

  Future<void> marcarPermisoPedido() =>
      _fijar(state.copyWith(permisoPedido: true));
}

final preferenciasEnvioProvider =
    NotifierProvider<PreferenciasEnvioNotifier, PreferenciasEnvio>(
      PreferenciasEnvioNotifier.new,
    );

/// Notificaciones locales del reporte. En pruebas, el fake.
final notificacionesReporteProvider = Provider<NotificacionesReporte>(
  (ref) =>
      _enPruebas ? FakeNotificacionesReporte() : LocalNotificacionesReporte(),
);

/// Si hay sesión abierta para enviar (con JWT). Sin ella la cola espera.
final sesionParaEnviarProvider = Provider<bool Function()>((ref) {
  final gestor = ref.watch(gestorSesionProvider);
  return () => gestor.abierta;
});

/// La cola de envío de la app: una sola, para que dos envíos no se pisen.
final colaReportesProvider = Provider<ColaReportes>((ref) {
  final cola = ColaReportes(
    almacen: ref.watch(almacenReportesProvider),
    remoto: ref.watch(reporteSiniestroRemoteDataSourceProvider),
    subida: ref.watch(subidaFotoSiniestroProvider),
    cuenta: () => ref.read(cuentaReporteProvider),
    conectado: () => ref.read(estadoRedProvider).conectado,
    porDatosMoviles: () => ref.read(estadoRedProvider).porDatosMoviles,
    soloWifi: () => ref.read(preferenciasEnvioProvider).soloWifi,
    sesionAbierta: ref.watch(sesionParaEnviarProvider),
    reloj: ref.watch(relojReporteProvider),
  );
  ref.onDispose(cola.cerrar);
  return cola;
});

/// En qué va la cola: porcentaje, foto y por qué espera.
final progresoColaProvider = StreamProvider<ProgresoCola>((ref) async* {
  final cola = ref.watch(colaReportesProvider);
  yield cola.progreso;
  yield* cola.cambios;
});
