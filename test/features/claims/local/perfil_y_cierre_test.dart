import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/cuenta_local.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
import 'package:solventa_mobile/core/almacen/almacen_providers.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/features/claims/data/local/almacen_reportes_memoria.dart';
import 'package:solventa_mobile/features/claims/data/preferencias_envio.dart';
import 'package:solventa_mobile/features/claims/domain/entities/reporte_guardado.dart';
import 'package:solventa_mobile/features/claims/presentation/providers.dart';
import 'package:solventa_mobile/features/claims/presentation/widgets/cierre_sesion_reportes.dart';
import 'package:solventa_mobile/features/claims/presentation/widgets/seccion_envio_reportes.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';

final _ahora = DateTime.utc(2026, 11, 20, 15);

Widget _app(Widget hijo, {Locale locale = AppLocales.es}) => MaterialApp(
  theme: SolTheme.light(),
  locale: locale,
  supportedLocales: AppLocales.supported,
  localizationsDelegates: [
    AppLocalizations.delegate,
    ...SolLocalizations.delegates,
  ],
  home: Scaffold(body: SingleChildScrollView(child: hijo)),
);

ReporteGuardado _reporte(
  String id, {
  EstadoLocal estado = EstadoLocal.pendiente,
  String cuenta = 'c1',
}) => ReporteGuardado(
  id: id,
  cuentaId: cuenta,
  estado: estado,
  creadoEn: _ahora,
  actualizadoEn: _ahora,
  guardadoEn: _ahora,
);

/// HU-M05 (sin conexión, plan 4.5 y 4.6): lo que el inicio, Mi perfil y el
/// cierre de sesión dicen de los reportes guardados en el teléfono.
void main() {
  group('inicio', () {
    Future<void> abrir(WidgetTester tester, {required int porEnviar}) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(
          HomePage(
            userName: 'María',
            verificacion: EstadoVerificacion.verificada,
            onCompleteRegistration: () {},
            onRequestAssistance: () {},
            onReportClaim: () {},
            onMyClaims: () {},
            porEnviar: porEnviar,
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('con reportes guardados, «Mis siniestros» lleva la insignia', (
      tester,
    ) async {
      await abrir(tester, porEnviar: 2);

      expect(find.text('2 por enviar'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Mis siniestros. 2 por enviar'),
        findsOneWidget,
      );
    });

    testWidgets('sin reportes guardados no hay insignia', (tester) async {
      await abrir(tester, porEnviar: 0);

      expect(find.textContaining('por enviar'), findsNothing);
    });
  });

  group('SolActionTile', () {
    testWidgets('deshabilitada dice por qué y no se puede tocar', (
      tester,
    ) async {
      var toques = 0;
      await tester.pumpWidget(
        _app(
          SolActionTile(
            icon: SolIcons.wallet,
            title: 'Mi cobertura',
            disabledReason: 'Necesita conexión',
            onTap: () => toques++,
          ),
        ),
      );

      expect(find.text('Necesita conexión'), findsOneWidget);
      await tester.tap(find.text('Mi cobertura'), warnIfMissed: false);
      expect(toques, 0);
      expect(
        find.bySemanticsLabel('Mi cobertura. Necesita conexión'),
        findsOneWidget,
      );
    });
  });

  group('Mi perfil · Envío de reportes', () {
    late AlmacenReportesMemoria almacen;
    late MemoriaPreferenciasEnvioStore preferencias;
    late ProviderContainer contenedor;
    var abiertos = 0;

    Future<void> abrir(
      WidgetTester tester, {
      TipoRed red = TipoRed.wifi,
    }) async {
      abiertos = 0;
      contenedor = ProviderContainer(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          cuentaReporteProvider.overrideWithValue('c1'),
          almacenReportesProvider.overrideWithValue(almacen),
          conectividadProvider.overrideWithValue(ConectividadFalsa(red)),
          preferenciasEnvioStoreProvider.overrideWithValue(preferencias),
        ],
      );
      addTearDown(contenedor.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: contenedor,
          child: _app(SeccionEnvioReportes(onVerPorEnviar: () => abiertos++)),
        ),
      );
      await tester.pumpAndSettle();
    }

    setUp(() {
      almacen = AlmacenReportesMemoria();
      preferencias = MemoriaPreferenciasEnvioStore();
    });

    testWidgets('muestra la conexión, el interruptor apagado y «Ninguno»', (
      tester,
    ) async {
      await abrir(tester);

      expect(find.text('Envío de reportes'), findsOneWidget);
      expect(find.text('Wi-Fi · buena'), findsOneWidget);
      expect(
        find.text('Apagado: se envía con Wi-Fi o con datos móviles'),
        findsOneWidget,
      );
      expect(find.text('Ninguno'), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    });

    testWidgets('el interruptor guarda «solo Wi-Fi» y ya no se pregunta', (
      tester,
    ) async {
      await abrir(tester);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(
        find.text('Encendido: las fotos esperan a que haya Wi-Fi'),
        findsOneWidget,
      );
      final guardadas = await preferencias.leer();
      expect(guardadas.soloWifi, isTrue);
      expect(guardadas.preguntado, isTrue);
    });

    testWidgets('sin conexión lo dice y sigue dejando cambiar el interruptor', (
      tester,
    ) async {
      await abrir(tester, red: TipoRed.ninguna);

      expect(find.text('Sin conexión'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect((await preferencias.leer()).soloWifi, isTrue);
    });

    testWidgets('con reportes guardados dice cuántos y abre la lista', (
      tester,
    ) async {
      await almacen.guardar(_reporte('r1'));
      await almacen.guardar(_reporte('r2', estado: EstadoLocal.borrador));
      await almacen.guardar(_reporte('otro', cuenta: 'c2'));
      await abrir(tester);

      expect(find.text('2 guardados en este teléfono'), findsOneWidget);
      await tester.tap(find.text('Reportes por enviar'));
      expect(abiertos, 1);
    });

    testWidgets('en inglés y con el texto al 200 % no se desborda', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await almacen.guardar(_reporte('r1'));
      contenedor = ProviderContainer(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          cuentaReporteProvider.overrideWithValue('c1'),
          almacenReportesProvider.overrideWithValue(almacen),
          preferenciasEnvioStoreProvider.overrideWithValue(preferencias),
        ],
      );
      addTearDown(contenedor.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: contenedor,
          child: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: _app(
              SeccionEnvioReportes(onVerPorEnviar: () {}),
              locale: AppLocales.en,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sending reports'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('cierre de sesión con reportes guardados', () {
    Future<CierreConReportes?> Function() preparar(
      WidgetTester tester, {
      required int sinEnviar,
      required int sinTerminar,
      required bool puedeEnviar,
    }) {
      CierreConReportes? eleccion;
      var respondio = false;
      return () async {
        if (!respondio) {
          await tester.pumpWidget(
            _app(
              Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    eleccion = await DialogoCierreConReportes.preguntar(
                      context,
                      sinEnviar: sinEnviar,
                      sinTerminar: sinTerminar,
                      puedeEnviar: puedeEnviar,
                    );
                    respondio = true;
                  },
                  child: const Text('ABRIR'),
                ),
              ),
            ),
          );
          await tester.tap(find.text('ABRIR'));
          await tester.pumpAndSettle();
          respondio = true;
          return null;
        }
        return eleccion;
      };
    }

    testWidgets('dice que quedan guardados y, por defecto, los conserva', (
      tester,
    ) async {
      final eleccion = preparar(
        tester,
        sinEnviar: 1,
        sinTerminar: 0,
        puedeEnviar: false,
      );
      await eleccion();

      expect(
        find.text(
          'Tienes 1 reporte sin enviar. Quedará guardado en este teléfono y '
          'se enviará cuando vuelvas a iniciar sesión con esta cuenta.',
        ),
        findsOneWidget,
      );
      // Sin conexión no se ofrece enviar.
      expect(find.text('Enviar ahora'), findsNothing);

      await tester.tap(find.text('Sí, cerrar sesión'));
      await tester.pumpAndSettle();

      final r = await eleccion();
      expect(r, isA<CerrarSesion>());
      expect((r! as CerrarSesion).borrar, isFalse);
    });

    testWidgets('con la casilla marcada pide borrarlos', (tester) async {
      final eleccion = preparar(
        tester,
        sinEnviar: 2,
        sinTerminar: 1,
        puedeEnviar: false,
      );
      await eleccion();
      expect(find.textContaining('Tienes 2 reportes sin enviar'), findsOne);

      await tester.tap(find.text('Borrar también los reportes guardados'));
      await tester.pump();
      await tester.tap(find.text('Sí, cerrar sesión'));
      await tester.pumpAndSettle();

      expect(((await eleccion())! as CerrarSesion).borrar, isTrue);
    });

    testWidgets('con conexión ofrece primero «Enviar ahora»', (tester) async {
      final eleccion = preparar(
        tester,
        sinEnviar: 1,
        sinTerminar: 0,
        puedeEnviar: true,
      );
      await eleccion();

      await tester.tap(find.text('Enviar ahora'));
      await tester.pumpAndSettle();

      expect(await eleccion(), isA<EnviarAntes>());
    });

    testWidgets('con solo borradores habla de reportes sin terminar', (
      tester,
    ) async {
      final eleccion = preparar(
        tester,
        sinEnviar: 0,
        sinTerminar: 1,
        puedeEnviar: false,
      );
      await eleccion();

      expect(find.textContaining('Tienes 1 reporte sin terminar'), findsOne);

      await tester.tap(find.text('No, seguir aquí'));
      await tester.pumpAndSettle();
      expect(await eleccion(), isNull);
    });
  });

  group('cerrarCuentaLocal', () {
    late AlmacenReportesMemoria almacen;
    late AlmacenLocalMemoria local;

    Future<void> cerrar(
      WidgetTester tester, {
      required bool borrarReportes,
    }) async {
      almacen = AlmacenReportesMemoria();
      local = AlmacenLocalMemoria();
      await local.guardarCuenta(
        CuentaLocal(
          id: 'c1',
          nombre: 'María',
          verificada: true,
          ultimaConexion: _ahora,
        ),
      );
      await local.guardarCopia('c1', 'polizas', '[]', _ahora);
      await almacen.guardar(_reporte('r1'));
      await almacen.agregarFoto(
        'r1',
        bytes: Uint8List.fromList([1, 2, 3]),
        tipoContenido: 'image/jpeg',
        tomadaEn: _ahora,
      );
      await almacen.guardar(_reporte('otro', cuenta: 'c2'));
      late WidgetRef ref;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            almacenReportesProvider.overrideWithValue(almacen),
            almacenLocalProvider.overrideWithValue(local),
          ],
          child: Consumer(
            builder: (_, r, _) {
              ref = r;
              return const SizedBox();
            },
          ),
        ),
      );
      ref.read(cuentaActualProvider.notifier).fijar('c1');
      await tester.runAsync(
        () => cerrarCuentaLocal(ref, borrarReportes: borrarReportes),
      );
    }

    testWidgets('conserva los reportes y olvida la cuenta y sus copias', (
      tester,
    ) async {
      await cerrar(tester, borrarReportes: false);

      expect(await local.cuentaActiva(), isNull);
      expect(await local.leerCopia('c1', 'polizas'), isNull);
      expect(await almacen.deCuenta('c1'), hasLength(1));
    });

    testWidgets('si el cliente lo pide, borra solo los de su cuenta', (
      tester,
    ) async {
      await cerrar(tester, borrarReportes: true);

      expect(await almacen.deCuenta('c1'), isEmpty);
      expect(await almacen.deCuenta('c2'), hasLength(1));
    });
  });
}
