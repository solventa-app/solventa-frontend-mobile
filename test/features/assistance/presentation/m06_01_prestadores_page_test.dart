import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/ruta_externa_service.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_01_prestadores_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/detalle_prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/mapa/mapa_prestadores.dart';

void main() {
  late FakeAsistenciaRemoteDataSource bff;
  late FakeUbicacionService gps;
  late FakeRutaExternaService rutas;
  late List<Prestador> solicitados;
  late List<Prestador> conDireccion;

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
          motorMapaProvider.overrideWithValue(MotorMapa.falso),
        ],
        child: MaterialApp(
          theme: SolTheme.light(),
          locale: AppLocales.es,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: M0601PrestadoresPage(
              onSolicitar: (c, _) => solicitados.add(c.prestador),
              onSolicitarConDireccion: conDireccion.add,
            ),
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
    conDireccion = [];
  });

  List<String> nombresDeFilas(WidgetTester tester) => tester
      .widgetList<SolProviderRow>(find.byType(SolProviderRow))
      .map((r) => r.name)
      .toList();

  testWidgets('CA-M06-01: los 3 más cercanos primero, con distancia y tiempo', (
    tester,
  ) async {
    await abrir(tester);
    expect(find.text('Prestadores cercanos'), findsOneWidget);
    // M1: la zona entera cuenta (8 en Bogotá), los 3 primeros son los del Figma.
    expect(find.text('8 disponibles'), findsOneWidget);
    expect(nombresDeFilas(tester).take(3), [
      'Clínica Norte',
      'Taller AutoAyuda',
      'Centro Médico Sur',
    ]);
    expect(find.textContaining('Médico · 1,1'), findsOneWidget);
  });

  testWidgets('M1 y M9: el resto de la ciudad con tiempo aproximado', (
    tester,
  ) async {
    await abrir(tester);
    final mas = find.text('Más prestadores en tu ciudad');
    await tester.scrollUntilVisible(
      mas,
      100,
      scrollable: find.byType(Scrollable).last,
    );
    expect(mas, findsOneWidget);
    expect(find.textContaining('~'), findsWidgets);
    expect(nombresDeFilas(tester), contains('Grúas Express'));
  });

  testWidgets('M4: tocar un pin lo selecciona y abre el detalle', (
    tester,
  ) async {
    final semantica = tester.ensureSemantics();
    await abrir(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^Taller AutoAyuda, ')));
    await tester.pumpAndSettle();

    expect(find.byType(DetallePrestador), findsOneWidget);
    expect(find.text('Mecánico · Mecánica general'), findsOneWidget);
    expect(find.text('Aliado Solventa'), findsOneWidget);
    expect(find.textContaining(RegExp(r'llega en \d+\smin')), findsOneWidget);

    await tester.tap(find.text('Cómo llegar'));
    await tester.pump();
    expect(rutas.abiertas, hasLength(1));

    await tester.tap(find.text('Solicitar asistencia'));
    await tester.pumpAndSettle();
    expect(solicitados.single.nombre, 'Taller AutoAyuda');
    expect(find.byType(DetallePrestador), findsNothing);
    // Al cerrar, la fila queda marcada.
    final fila = tester
        .widgetList<SolProviderRow>(find.byType(SolProviderRow))
        .firstWhere((r) => r.name == 'Taller AutoAyuda');
    expect(fila.selected, isTrue);
    semantica.dispose();
  });

  testWidgets('M5: tocar la fila enfoca el pin sin abrir el detalle', (
    tester,
  ) async {
    await abrir(tester);
    await tester.tap(find.textContaining('Médico · 1,1'));
    await tester.pumpAndSettle();
    expect(find.byType(DetallePrestador), findsNothing);
    final mapa = tester.widget<MapaPrestadores>(find.byType(MapaPrestadores));
    expect(mapa.datos.seleccionadoId, 'prs-bog-001');
    expect(mapa.orden, isA<EnfocarPrestador>());
    // M8: tras enfocar aparece «Volver a centrar»; al tocarlo, encuadra.
    await tester.tap(find.bySemanticsLabel('Volver a centrar en mi ubicación'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MapaPrestadores>(find.byType(MapaPrestadores)).orden,
      isA<EncuadrarInicio>(),
    );
    expect(
      find.bySemanticsLabel('Volver a centrar en mi ubicación'),
      findsNothing,
    );
  });

  testWidgets('M14: el botón de capas alterna calles y satélite', (
    tester,
  ) async {
    await abrir(tester);
    EstiloMapa estilo() => tester
        .widget<MapaPrestadores>(find.byType(MapaPrestadores))
        .datos
        .estilo;
    expect(estilo(), EstiloMapa.calles);
    await tester.tap(find.bySemanticsLabel('Ver satélite'));
    await tester.pumpAndSettle();
    expect(estilo(), EstiloMapa.satelite);
    expect(find.bySemanticsLabel('Ver calles'), findsOneWidget);
  });

  testWidgets('M13: sin app de mapas, aviso con la dirección y «Copiar»', (
    tester,
  ) async {
    rutas.resultado = false;
    final semantica = tester.ensureSemantics();
    await abrir(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^Clínica Norte, ')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cómo llegar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('Cl. 93 # 14-20'), findsWidgets);
    expect(find.text('Copiar'), findsOneWidget);
    semantica.dispose();
  });

  testWidgets('«Solicitar» entrega el prestador de la fila', (tester) async {
    await abrir(tester);
    await tester.tap(find.text('Solicitar').first);
    expect(solicitados.single.nombre, 'Clínica Norte');
  });

  testWidgets('M11: fuera de cobertura, el mapa con el cliente y el aviso', (
    tester,
  ) async {
    // El emulador arranca en California: ningún prestador a menos de 50 km.
    gps.resultado = const UbicacionObtenida(Coordenada(37.422, -122.084));
    await abrir(tester);
    expect(find.text('Aún no tenemos prestadores en tu zona.'), findsOneWidget);
    expect(find.byType(SolProviderRow), findsNothing);
    expect(find.byType(MapaPrestadores), findsOneWidget);
    expect(find.byType(SolMapUserPin), findsOneWidget);
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
    expect(nombresDeFilas(tester).first, 'Clínica Norte');
  });

  testWidgets(
    'CA-M06-02: sin permiso se puede seguir con la dirección a mano',
    (tester) async {
      gps.resultado = const UbicacionSinPermiso(permanente: true);
      await abrir(tester);
      await tester.tap(find.text('Escribir mi dirección'));
      await tester.pumpAndSettle();

      expect(find.text('Elige un prestador'), findsOneWidget);
      expect(find.byType(MapaPrestadores), findsNothing);
      final filas = find.byType(SolProviderRow);
      expect(filas, findsWidgets);
      // Sin coordenadas no hay tiempo: la fila dice la ciudad.
      expect(find.textContaining(' min'), findsNothing);
      expect(find.textContaining('Bogotá'), findsWidgets);

      await tester.tap(find.text('Solicitar').first);
      expect(conDireccion, hasLength(1));
      expect(solicitados, isEmpty);
    },
  );

  testWidgets('CA-M06-02: con el GPS apagado también, y se puede volver a él', (
    tester,
  ) async {
    gps.resultado = const UbicacionNoDisponible();
    await abrir(tester);
    await tester.tap(find.text('Escribir mi dirección'));
    await tester.pumpAndSettle();

    gps.resultado = const UbicacionObtenida(Coordenada(4.6767, -74.0483));
    final volver = find.text('Usar mi ubicación');
    await tester.ensureVisible(volver);
    await tester.pumpAndSettle();
    await tester.tap(volver);
    await tester.pumpAndSettle();
    expect(find.byType(MapaPrestadores), findsOneWidget);
    expect(nombresDeFilas(tester).first, 'Clínica Norte');
  });

  testWidgets('CA-M06-04: si el mapa falla queda la lista, no un error', (
    tester,
  ) async {
    await abrir(tester);
    tester.widget<MapaPrestadores>(find.byType(MapaPrestadores)).onFallo();
    await tester.pumpAndSettle();

    expect(find.byType(MapaPrestadores), findsNothing);
    expect(find.byType(SolMapFab), findsNothing);
    expect(nombresDeFilas(tester).take(3), hasLength(3));
    expect(find.text('Prestadores cercanos'), findsOneWidget);
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
