import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/solventa_app.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';
import 'package:solventa_mobile/features/claims/data/datasources/reporte_siniestro_remote_datasource.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/local/copias_reporte.dart';
import 'package:solventa_mobile/features/claims/data/notificaciones_reporte.dart';
import 'package:solventa_mobile/features/claims/data/preferencias_envio.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/onboarding.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';

class _Sesion extends OnboardingNotifier {
  _Sesion(this._verificacion);

  final EstadoVerificacion _verificacion;

  @override
  OnboardingState build() => OnboardingState(
    cuentaCreada: true,
    verificacion: _verificacion,
    perfil: PerfilUsuario(
      id: 'c1',
      usuario: 'laura',
      rol: 'CLIENTE',
      estado: 'ACTIVO',
      creadoEn: '2026-06-01T15:00:00Z',
      idioma: 'ES',
      moneda: 'COP',
      nombre: 'Laura',
    ),
  );

  @override
  Future<void> cargarPerfilYEstado() async {}
}

/// HU-M05 (plan 4.2), con la app entera: abrir el inicio con red ya deja las
/// pólizas guardadas en el teléfono, sin entrar a «Reportar un siniestro».
void main() {
  late AlmacenLocalMemoria local;
  late ProviderContainer contenedor;

  Future<void> abrir(
    WidgetTester tester,
    EstadoVerificacion verificacion,
  ) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    local = AlmacenLocalMemoria();
    contenedor = ProviderContainer(
      overrides: [
        usarFakesProvider.overrideWithValue(true),
        onboardingProvider.overrideWith(() => _Sesion(verificacion)),
        almacenLocalProvider.overrideWithValue(local),
        almacenReportesProvider.overrideWithValue(AlmacenReportesMemoria()),
        reporteSiniestroRemoteDataSourceProvider.overrideWithValue(
          FakeReporteSiniestroRemoteDataSource(latencia: Duration.zero),
        ),
        conectividadProvider.overrideWithValue(ConectividadFalsa()),
        sondaRedProvider.overrideWithValue(SondaFalsa()),
        notificacionesReporteProvider.overrideWithValue(
          FakeNotificacionesReporte(),
        ),
        preferenciasEnvioStoreProvider.overrideWithValue(
          MemoriaPreferenciasEnvioStore(),
        ),
      ],
    );
    addTearDown(contenedor.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: contenedor,
        child: const SolventaApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> terminar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    contenedor.dispose();
    await tester.pump();
  }

  testWidgets('con la cuenta verificada, el inicio guarda las pólizas', (
    tester,
  ) async {
    await abrir(tester, EstadoVerificacion.verificada);

    expect(find.text('Hola, Laura'), findsOneWidget);
    expect((await local.cuentaActiva())?.id, 'c1');
    final polizas = await local.leerCopia('c1', CopiasReporte.clavePolizas);
    expect(polizas, isNotNull);
    expect(
      await local.leerCopia('c1', CopiasReporte.claveSiniestros),
      isNotNull,
    );
    await terminar(tester);
  });

  testWidgets('sin verificar no se piden: todavía no puede reportar', (
    tester,
  ) async {
    await abrir(tester, EstadoVerificacion.enRevision);

    expect(await local.leerCopia('c1', CopiasReporte.clavePolizas), isNull);
    await terminar(tester);
  });
}
