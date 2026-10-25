import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';

import '../../../helpers/sol_test_app.dart';

Widget _home() => HomePage(
  userName: 'María',
  onCompleteRegistration: () {},
  onRequestAssistance: () {},
);

void main() {
  group('SolFlowScaffold', () {
    testWidgets('la flecha y el atrás del sistema llaman a onBack', (
      tester,
    ) async {
      var backs = 0;
      await pumpSol(
        tester,
        SolFlowScaffold(
          title: 'Autorización de datos',
          onBack: () => backs++,
          body: const Text('Contenido'),
          actions: [SolButton.primary(label: 'Continuar', onPressed: () {})],
        ),
        scaffold: false,
      );
      await tester.tap(find.byTooltip('Volver'));
      expect(backs, 1);
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(backs, 2);
      await expectA11yGuidelines(tester);
    });

    testWidgets('CTA anclado abajo vs. al final del contenido', (tester) async {
      Future<double> ctaTop({required bool anchored}) async {
        await pumpSol(
          tester,
          SolFlowScaffold(
            title: 'Pantalla',
            anchorActions: anchored,
            body: const Text('Contenido corto'),
            actions: [SolButton.primary(label: 'Continuar', onPressed: () {})],
          ),
          scaffold: false,
        );
        return tester.getRect(find.byType(SolButton)).top;
      }

      final anchored = await ctaTop(anchored: true);
      final inline = await ctaTop(anchored: false);
      // 844 − 24 (margen) − 48 (botón) = 772.
      expect(anchored, 772);
      expect(inline, lessThan(200));
    });

    testWidgets('texto al 200 % a 360 dp: hace scroll sin desbordar', (
      tester,
    ) async {
      await pumpSol(
        tester,
        SolFlowScaffold(
          title: 'Autorización de datos',
          anchorActions: false,
          body: Column(
            children: [
              const Text(
                'Para verificar tu identidad necesitamos tu autorización '
                'para tratar tus datos personales conforme a la Ley 1581 '
                'de 2012 (Habeas Data).',
              ),
              SolConsentCheckbox(
                value: false,
                onChanged: (_) {},
                label: 'Autorizo el tratamiento de mis datos personales',
              ),
            ],
          ),
          actions: [
            const SolButton.primary(label: 'Continuar', onPressed: null),
          ],
        ),
        scaffold: false,
        textScale: 2,
        size: const Size(360, 640),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsWidgets);
    });
  });

  group('Pantallas sin flecha', () {
    testWidgets('SolEntryScaffold no tiene flecha', (tester) async {
      await pumpSol(
        tester,
        const SolEntryScaffold(title: 'Bienvenido', body: Text('Hola')),
        scaffold: false,
      );
      expect(find.byTooltip('Volver'), findsNothing);
    });

    testWidgets('SolTransitionalScreen: sin flecha, bloquea el atrás y '
        'anuncia la carga', (tester) async {
      await pumpSol(
        tester,
        const SolTransitionalScreen(
          title: 'Verificación',
          message: 'Validando con el proveedor KYC/AML...',
        ),
        scaffold: false,
      );
      expect(find.byTooltip('Volver'), findsNothing);
      final popScope = tester.widget<PopScope<dynamic>>(
        find.byWidgetPredicate((w) => w is PopScope).first,
      );
      expect(popScope.canPop, isFalse);
      expect(
        find.bySemanticsLabel('Validando con el proveedor KYC/AML...'),
        findsOneWidget,
      );
    });
  });

  group('SolResultScreen', () {
    testWidgets('tarjeta de estado centrada y acción abajo', (tester) async {
      var actions = 0;
      await pumpSol(
        tester,
        SolResultScreen(
          title: 'Verificación',
          status: SolStatus.success,
          message: '¡Identidad verificada! Bienvenido a Solventa.',
          actionLabel: 'Ir a mi cuenta',
          onAction: () => actions++,
        ),
        scaffold: false,
      );
      await tester.tap(find.text('Ir a mi cuenta'));
      expect(actions, 1);
      final card = tester.getRect(find.byType(SolResultView));
      final button = tester.getRect(find.byType(SolButton));
      expect(button.top, 772);
      // Centrada en el área de contenido (entre la barra y el botón).
      expect(card.center.dy, closeTo((56 + 772) / 2, 1));
      await expectA11yGuidelines(tester);
    });
  });

  group('SolAppShell', () {
    testWidgets('cambia de destino, cierra sesión y el atrás vuelve a '
        'Inicio', (tester) async {
      var logouts = 0;
      await pumpSol(
        tester,
        SolAppShell(
          home: _home(),
          assistance: const Text('Pantalla de asistencia'),
          onLogout: () => logouts++,
        ),
        scaffold: false,
      );
      expect(find.text('Hola, María'), findsOneWidget);
      await tester.tap(find.text('Asistencia'));
      await tester.pump();
      expect(find.text('Pantalla de asistencia'), findsOneWidget);
      await tester.tap(find.text('Cerrar sesión'));
      expect(logouts, 1);
      await tester.binding.handlePopRoute();
      await tester.pump();
      final nav = tester.widget<SolBottomNav>(find.byType(SolBottomNav));
      expect(nav.selectedIndex, 0);
    });
  });

  group('Home G-03', () {
    testWidgets('estructura del Figma y accesibilidad', (tester) async {
      await pumpSol(
        tester,
        SolAppShell(
          home: _home(),
          assistance: const SizedBox(),
          onLogout: () {},
        ),
        scaffold: false,
      );
      expect(find.text('Hola, María'), findsOneWidget);
      expect(
        find.text('Completa tu registro para activar tu cuenta'),
        findsOneWidget,
      );
      expect(find.text('Completar registro'), findsOneWidget);
      expect(find.text('Solicitar asistencia en sitio'), findsOneWidget);
      expect(
        find.text('Billetera y estado de póliza — próximamente'),
        findsOneWidget,
      );
      // Saludo a 16 dp del borde y 20 dp bajo la barra superior.
      final greeting = tester.getRect(find.text('Hola, María'));
      expect(greeting.left, 16);
      expect(greeting.top, 56 + 20);
      await expectA11yGuidelines(tester, contrast: false);
    });

    for (final size in const [
      Size(360, 740),
      Size(390, 844),
      Size(412, 915),
      Size(844, 390),
    ]) {
      testWidgets('sin desbordes a ${size.width.toInt()}×'
          '${size.height.toInt()} con texto al 200 %', (tester) async {
        await pumpSol(
          tester,
          SolAppShell(
            home: _home(),
            assistance: const SizedBox(),
            onLogout: () {},
          ),
          scaffold: false,
          textScale: 2,
          size: size,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Responsive', () {
    testWidgets('≥ 600 dp: contenido centrado con máximo 600 dp y barra '
        'inferior intacta', (tester) async {
      await pumpSol(
        tester,
        SolAppShell(
          home: _home(),
          assistance: const SizedBox(),
          onLogout: () {},
        ),
        scaffold: false,
        size: const Size(840, 900),
      );
      final card = tester.getRect(find.byType(SolCard).first);
      expect(card.width, 600 - 32);
      expect(card.center.dx, closeTo(420, 0.5));
      expect(tester.getSize(find.byType(SolBottomNav)).width, 840);
      final context = tester.element(find.byType(HomePage));
      expect(context.isExpandedWindow, isTrue);
    });

    testWidgets('< 600 dp: ventana compacta', (tester) async {
      await pumpSol(tester, const SizedBox(), size: const Size(390, 844));
      final context = tester.element(find.byType(SizedBox).last);
      expect(context.windowSize, SolWindowSize.compact);
    });
  });

  group('SolMotion', () {
    testWidgets('respeta «quitar animaciones»', (tester) async {
      late Duration d;
      await pumpSol(
        tester,
        Builder(
          builder: (context) {
            d = SolMotion.of(context, SolMotion.medium);
            return const SizedBox();
          },
        ),
        disableAnimations: true,
      );
      expect(d, Duration.zero);
    });
  });
}
