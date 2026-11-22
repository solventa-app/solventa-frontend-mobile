import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/copias_reporte.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';

/// HU-M05 (plan 4.2): las pólizas y «Mis siniestros» quedan guardados desde
/// que se entra con red, sin esperar a que el cliente abra el reporte. Así
/// puede reportar sin conexión aunque nunca lo haya abierto antes.
void main() {
  late FakeReporteSiniestroRemoteDataSource bff;
  late AlmacenLocalMemoria local;
  late ConectividadFalsa conectividad;
  late ProviderContainer contenedor;

  Future<void> asentar() async {
    for (var i = 0; i < 12; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  Future<void> crear({
    TipoRed red = TipoRed.wifi,
    String? cuenta = 'c1',
  }) async {
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    local = AlmacenLocalMemoria();
    conectividad = ConectividadFalsa(red);
    contenedor = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        almacenLocalProvider.overrideWithValue(local),
        conectividadProvider.overrideWithValue(conectividad),
        sondaRedProvider.overrideWithValue(SondaFalsa()),
        reporteSiniestroRemoteDataSourceProvider.overrideWithValue(bff),
        relojReporteProvider.overrideWithValue(
          () => DateTime.utc(2026, 11, 22, 9),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    // La red se conoce antes de que el inicio empiece a mirar.
    contenedor.listen(estadoRedProvider, (_, _) {});
    await asentar();
    contenedor.read(cuentaActualProvider.notifier).fijar(cuenta);
    // Como el inicio: lo observa mientras la sesión está abierta.
    contenedor.listen(cargaInicialReporteProvider, (_, _) {});
    await asentar();
  }

  Future<Copia?> copia(String clave, {String cuenta = 'c1'}) =>
      local.leerCopia(cuenta, clave);

  test('al entrar con red guarda las pólizas y «Mis siniestros»', () async {
    await crear();

    final polizas = await copia(CopiasReporte.clavePolizas);
    expect(polizas, isNotNull);
    expect(polizas!.json, contains('SOL-2026-000456'));
    expect(polizas.guardadaEn, DateTime.utc(2026, 11, 22, 9));
    expect(await copia(CopiasReporte.claveSiniestros), isNotNull);
  });

  test('con eso el reporte encuentra las pólizas sin conexión', () async {
    await crear();

    bff.sinRed = true;
    conectividad.cambiar(TipoRed.ninguna);
    await asentar();
    final polizas = await contenedor.read(polizasConCopiaProvider.future);

    final guardadas = switch (polizas) {
      Exito(:final valor) => valor,
      Fracaso() => null,
    };
    expect(guardadas, isNotNull);
    expect(guardadas!.esCopia, isTrue);
    expect(guardadas.valor, isNotEmpty);
  });

  test('sin red al entrar no guarda nada; al volver la señal, sí', () async {
    await crear(red: TipoRed.ninguna);
    expect(await copia(CopiasReporte.clavePolizas), isNull);

    conectividad.cambiar(TipoRed.wifi);
    await asentar();
    await asentar();

    expect(await copia(CopiasReporte.clavePolizas), isNotNull);
    expect(await copia(CopiasReporte.claveSiniestros), isNotNull);
  });

  test('sin cuenta no pide ni guarda nada', () async {
    await crear(cuenta: null);

    expect(await copia(CopiasReporte.clavePolizas), isNull);
  });

  test('si el servidor falla no rompe nada y no deja copia', () async {
    bff = FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero);
    await crear();
    // Otra cuenta entra con el servidor caído.
    bff.sinRed = true;
    contenedor.read(cuentaActualProvider.notifier).fijar('c2');
    await asentar();

    expect(await copia(CopiasReporte.clavePolizas, cuenta: 'c2'), isNull);
  });

  test('al cambiar de cuenta guarda las de la nueva', () async {
    await crear();

    contenedor.read(cuentaActualProvider.notifier).fijar('c2');
    await asentar();

    expect(await copia(CopiasReporte.clavePolizas, cuenta: 'c2'), isNotNull);
  });
}
