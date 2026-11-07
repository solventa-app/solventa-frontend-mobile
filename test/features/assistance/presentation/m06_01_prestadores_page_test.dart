import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/ruta_externa_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_01_prestadores_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';

void main() {
  late FakeAsistenciaRemoteDataSource bff;
  late FakeUbicacionService gps;
  late FakeRutaExternaService rutas;
  late List<Prestador> solicitados;

  Future<void> abrir(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 748);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          asistenciaRemoteDataSourceProvider.overrideWithValue(bff),
          catalogoLocalDataSourceProvider.overrideWithValue(
            MemoriaCatalogoLocalDataSource(),
          ),
          ubicacionServiceProvider.overrideWithValue(gps),
          rutaExternaServiceProvider.overrideWithValue(rutas),
          plantillaTeselasProvider.overrideWithValue(''),
        ],
        child: MaterialApp(
          theme: SolTheme.light(),
          locale: AppLocales.es,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: M0601PrestadoresPage(onSolicitar: solicitados.add),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    bff = FakeAsistenciaRemoteDataSource(latencia: Duration.zero);
    gps = FakeUbicacionService();
    rutas = FakeRutaExternaService();
    solicitados = [];
  });

  testWidgets('CA-M06-01: muestra los 3 prestadores con distancia y tiempo', (
    tester,
  ) async {
    await abrir(tester);
    expect(find.text('Prestadores cercanos'), findsOneWidget);
    expect(find.text('3 disponibles'), findsOneWidget);
    expect(find.byType(SolProviderRow), findsNWidgets(3));
    expect(find.textContaining('Médico · 1,1'), findsOneWidget);
  });

  testWidgets('«Solicitar» entrega el prestador de la fila', (tester) async {
    await abrir(tester);
    await tester.tap(find.text('Solicitar').first);
    expect(solicitados.single.nombre, 'Clínica Norte');
  });

  testWidgets('tocar el pin abre la ruta en la app de mapas', (tester) async {
    final semantica = tester.ensureSemantics();
    await abrir(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('Cómo llegar a Taller')));
    await tester.pump();
    expect(rutas.abiertas, hasLength(1));
    semantica.dispose();
  });

  testWidgets('sin prestadores, la hoja lo dice en lugar de quedar vacía', (
    tester,
  ) async {
    // El emulador arranca en California: ningún prestador a menos de 50 km.
    gps.resultado = const UbicacionObtenida(Coordenada(37.422, -122.084));
    await abrir(tester);
    expect(
      find.text('No hay prestadores disponibles cerca de ti en este momento.'),
      findsOneWidget,
    );
    expect(find.byType(SolProviderRow), findsNothing);
  });

  testWidgets('CA-M06-02: sin permiso ofrece permitir la ubicación', (
    tester,
  ) async {
    gps.resultado = const UbicacionSinPermiso(permanente: false);
    await abrir(tester);
    expect(find.text('Permitir ubicación'), findsOneWidget);

    gps.resultado = const UbicacionObtenida(Coordenada(4.6767, -74.0483));
    await tester.tap(find.text('Permitir ubicación'));
    await tester.pumpAndSettle();
    expect(find.byType(SolProviderRow), findsNWidgets(3));
  });

  testWidgets('permiso negado para siempre o GPS apagado: «Abrir ajustes»', (
    tester,
  ) async {
    gps.resultado = const UbicacionNoDisponible();
    await abrir(tester);
    expect(find.textContaining('ubicación está desactivada'), findsOneWidget);
    expect(find.text('Abrir ajustes'), findsOneWidget);
  });
}
