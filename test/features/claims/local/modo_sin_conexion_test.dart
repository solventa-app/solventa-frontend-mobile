import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/almacen_local.dart';
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
import 'package:solventa_mobile/features/home/presentation/home_page.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';
import 'package:solventa_mobile/features/profile/presentation/perfil_sin_conexion.dart';

final _ahora = DateTime.utc(2026, 11, 22, 9);

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

/// HU-M05 (plan 4.5): lo que se ve al entrar con la huella y sin red. Solo
/// queda activo lo que vive en el teléfono.
void main() {
  group('inicio sin conexión', () {
    late Map<String, int> toques;

    Future<void> abrir(
      WidgetTester tester, {
      bool sinConexion = true,
      Locale locale = AppLocales.es,
    }) async {
      toques = {};
      void contar(String cual) => toques[cual] = (toques[cual] ?? 0) + 1;
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(
          locale: locale,
          HomePage(
            userName: 'Laura',
            verificacion: EstadoVerificacion.verificada,
            sinConexion: sinConexion,
            onCompleteRegistration: () {},
            onRequestAssistance: () => contar('asistencia'),
            onReportClaim: () => contar('reportar'),
            onMyClaims: () => contar('siniestros'),
            onMyCoverage: () => contar('cobertura'),
            porEnviar: 1,
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('asistencia y cobertura dicen «Necesita conexión» y no abren', (
      tester,
    ) async {
      await abrir(tester);

      expect(find.text('Hola, Laura'), findsOneWidget);
      expect(find.text('Necesita conexión'), findsNWidgets(2));
      expect(
        find.bySemanticsLabel(
          'Solicitar asistencia en sitio. Necesita conexión',
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Mi cobertura. Necesita conexión'),
        findsOneWidget,
      );

      await tester.tap(
        find.text('Solicitar asistencia en sitio'),
        warnIfMissed: false,
      );
      await tester.tap(find.text('Mi cobertura'), warnIfMissed: false);

      expect(toques, isEmpty);
    });

    testWidgets('el reporte y «Mis siniestros» siguen abriendo', (
      tester,
    ) async {
      await abrir(tester);

      await tester.tap(find.text('Reportar un siniestro'));
      await tester.tap(find.text('Mis siniestros'));

      expect(toques, {'reportar': 1, 'siniestros': 1});
      expect(find.text('1 por enviar'), findsOneWidget);
    });

    testWidgets('con conexión todo abre y nada dice «Necesita conexión»', (
      tester,
    ) async {
      await abrir(tester, sinConexion: false);

      expect(find.text('Necesita conexión'), findsNothing);
      await tester.tap(find.text('Solicitar asistencia en sitio'));
      await tester.tap(find.text('Mi cobertura'));

      expect(toques, {'asistencia': 1, 'cobertura': 1});
    });

    testWidgets('en inglés dice «Needs connection»', (tester) async {
      await abrir(tester, locale: AppLocales.en);

      expect(find.text('Needs connection'), findsNWidgets(2));
    });
  });

  group('Mi perfil sin conexión', () {
    late AlmacenReportesMemoria almacen;
    late MemoriaPreferenciasEnvioStore preferencias;
    var abiertos = 0;
    var cierres = 0;

    Future<void> abrir(
      WidgetTester tester, {
      String nombre = 'Laura Gómez',
      Locale locale = AppLocales.es,
      bool conCierre = true,
    }) async {
      abiertos = 0;
      cierres = 0;
      tester.view.physicalSize = const Size(390, 2200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final contenedor = ProviderContainer(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          cuentaReporteProvider.overrideWithValue('c1'),
          almacenReportesProvider.overrideWithValue(almacen),
          conectividadProvider.overrideWithValue(
            ConectividadFalsa(TipoRed.ninguna),
          ),
          preferenciasEnvioStoreProvider.overrideWithValue(preferencias),
        ],
      );
      addTearDown(contenedor.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: contenedor,
          child: _app(
            locale: locale,
            Padding(
              padding: const EdgeInsets.all(SolSpacing.md),
              child: PerfilSinConexion(
                cuenta: CuentaLocal(
                  id: 'c1',
                  nombre: nombre,
                  verificada: true,
                  ultimaConexion: _ahora,
                ),
                idioma: 'ES',
                moneda: 'COP',
                onVerPorEnviar: () => abiertos++,
                onLogout: conCierre ? () => cierres++ : null,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    setUp(() {
      almacen = AlmacenReportesMemoria();
      preferencias = MemoriaPreferenciasEnvioStore();
    });

    testWidgets('muestra el nombre guardado y pide conexión para lo demás', (
      tester,
    ) async {
      await abrir(tester);

      expect(find.text('Laura Gómez'), findsOneWidget);
      expect(find.text('LG'), findsOneWidget);
      expect(find.text('Cuenta activa'), findsOneWidget);
      expect(find.text('Correo y documento'), findsOneWidget);
      expect(
        find.text('Conéctate para ver tus datos completos'),
        findsOneWidget,
      );
      expect(find.text('ES · COP · Necesita conexión'), findsOneWidget);
      expect(
        find.text('Activada · con ella entraste sin conexión'),
        findsOneWidget,
      );
      // Ningún dato personal más: ni correo ni documento salen del teléfono.
      expect(find.textContaining('@'), findsNothing);
    });

    testWidgets('las notificaciones push quedan apagadas y sin tocar', (
      tester,
    ) async {
      await abrir(tester);

      final push = tester.widget<Switch>(find.byType(Switch).last);
      expect(push.onChanged, isNull);
      expect(find.text('Necesita conexión'), findsOneWidget);
    });

    testWidgets('«Envío de reportes» sigue activo: interruptor y lista', (
      tester,
    ) async {
      await almacen.guardar(
        ReporteGuardado(
          id: 'r1',
          cuentaId: 'c1',
          estado: EstadoLocal.pendiente,
          creadoEn: _ahora,
          actualizadoEn: _ahora,
          guardadoEn: _ahora,
        ),
      );
      await abrir(tester);

      expect(find.text('Sin conexión'), findsOneWidget);
      await tester.tap(find.byKey(const Key('perfil-solo-wifi')));
      await tester.pumpAndSettle();
      expect((await preferencias.leer()).soloWifi, isTrue);

      await tester.tap(find.byKey(const Key('perfil-por-enviar')));
      expect(abiertos, 1);
    });

    testWidgets('cerrar sesión sigue disponible', (tester) async {
      await abrir(tester);

      await tester.tap(find.text('Cerrar sesión'));
      expect(cierres, 1);
    });

    testWidgets('sin nombre guardado no inventa uno', (tester) async {
      await abrir(tester, nombre: '');

      expect(find.text('S'), findsOneWidget);
      expect(find.text('Cuenta activa'), findsOneWidget);
    });

    testWidgets('en inglés', (tester) async {
      await abrir(tester, locale: AppLocales.en);

      expect(find.text('Email and ID'), findsOneWidget);
      expect(find.text('ES · COP · Needs connection'), findsOneWidget);
      expect(find.text('On · you used it to get in offline'), findsOneWidget);
    });
  });
}
