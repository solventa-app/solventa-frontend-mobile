import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solventa_mobile/app/router.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/log/limpiar.dart';
import 'package:solventa_mobile/core/log/sol_log.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_03_documento_frente_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_04_documento_reverso_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_05_prueba_vida_page.dart';

Widget _envolver(Widget child) => ProviderScope(
  child: MaterialApp(
    theme: SolTheme.light(),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...SolLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: child,
  ),
);

void main() {
  setUp(() {
    SolLocalizations.init();
    SolLog.limpiarHistorialPruebas();
  });

  group('limpiar (beforeSend de Sentry)', () {
    test('elimina documento, correo, token y números de 6+ dígitos', () {
      final evento = SentryEvent(
        message: SentryMessage(
          'Falla con correo maria@solventa.co y cédula 1020304050 y token eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.firma',
        ),
        request: SentryRequest(
          url: 'https://api.solventa.co/graphql?correo=maria@solventa.co&id=99887766',
          queryString: 'correo=maria@solventa.co&documento=1020304050',
          cookies: 'session=secreto123',
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.firma',
            'X-Trace': 'ok-12345678',
          },
          data: {
            'documento': '1020304050',
            'correo': 'maria@solventa.co',
            'token': 'secreto',
            'paso': 'FRENTE_DOCUMENTO',
          },
        ),
        // ignore: deprecated_member_use
        extra: {
          'cedula': '1020304050',
          'email': 'maria@solventa.co',
          'nota': 'Intentos en 1020304050',
        },
        breadcrumbs: [
          Breadcrumb(
            message: 'Usuario maria@solventa.co subió doc 1020304050',
            category: 'onboarding',
            data: {'password': 'Clave123!', 'detalle': '123456'},
          ),
        ],
      );

      final limpio = limpiar(evento, Hint())!;
      final serializado = limpio.toJson().toString();

      expect(serializado, isNot(contains('maria@solventa.co')));
      expect(serializado, isNot(contains('1020304050')));
      expect(serializado, isNot(contains('eyJhbGciOiJIUzI1NiJ9')));
      expect(serializado, isNot(contains('Clave123!')));
      expect(serializado, isNot(contains('secreto123')));
      expect(limpio.request?.headers['Authorization'], '[filtrado]');
      expect((limpio.request?.data as Map)['documento'], '[filtrado]');
      expect((limpio.request?.data as Map)['paso'], 'FRENTE_DOCUMENTO');
    });
  });

  group('SolLog', () {
    test('no filtra documento, correo ni token en los registros', () {
      SolLog.info(
        'Intento de maria@solventa.co con doc 1020304050',
        id: 'onb-1',
        pantalla: 'm01-05b',
        codigo: 'CORREO_YA_REGISTRADO',
      );
      expect(SolLog.historialPruebas, hasLength(1));
      final linea = SolLog.historialPruebas.single;
      expect(linea, isNot(contains('maria@solventa.co')));
      expect(linea, isNot(contains('1020304050')));
      expect(linea, contains('[correo]'));
      expect(linea, contains('[número]'));
      expect(linea, contains('CORREO_YA_REGISTRADO'));
    });

    test('obtenerCodigoSoporte devuelve un código de 8 caracteres', () {
      final codigo = SolLog.obtenerCodigoSoporte();
      expect(codigo.length, 8);
    });
  });

  group(
    'Pantallas de captura enmascaradas (SentryMask y beforeCaptureScreenshot)',
    () {
      test('esRutaSinCaptura bloquea M01-03, M01-04 y M01-05', () {
        expect(esRutaSinCaptura('m01-03'), isTrue);
        expect(esRutaSinCaptura('m01-04'), isTrue);
        expect(esRutaSinCaptura('m01-05'), isTrue);
        expect(esRutaSinCaptura('/onboarding/frente'), isTrue);
        expect(esRutaSinCaptura('m01-01'), isFalse);
        expect(esRutaSinCaptura('g-03'), isFalse);
      });

      testWidgets('M01-03, M01-04 y M01-05 están envueltas en SentryMask', (
        tester,
      ) async {
        await tester.pumpWidget(_envolver(const M0103DocumentoFrentePage()));
        expect(find.byType(SentryMask), findsOneWidget);

        await tester.pumpWidget(_envolver(const M0104DocumentoReversoPage()));
        expect(find.byType(SentryMask), findsOneWidget);

        await tester.pumpWidget(_envolver(const M0105PruebaVidaPage()));
        expect(find.byType(SentryMask), findsOneWidget);
      });
    },
  );
}
