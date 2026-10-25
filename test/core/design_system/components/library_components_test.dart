import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import '../../../helpers/sol_test_app.dart';

void main() {
  group('SolButton', () {
    testWidgets('primario: 48 dp de alto, colores del Figma y tap', (
      tester,
    ) async {
      var taps = 0;
      await pumpSol(
        tester,
        SolButton.primary(label: 'Continuar', onPressed: () => taps++),
      );
      final size = tester.getSize(find.byType(TextButton));
      expect(size.height, 48);
      expect(size.width, 358);
      final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
      expect(style.backgroundColor!.resolve({}), const Color(0xFF1E4680));
      await tester.tap(find.text('Continuar'));
      expect(taps, 1);
      await expectA11yGuidelines(tester);
    });

    testWidgets('cada variante usa su color', (tester) async {
      const expected = {
        SolButtonVariant.tonal: Color(0xFFEEEDF3),
        SolButtonVariant.destructive: Color(0xFF994D4D),
        SolButtonVariant.outlined: Color(0xFFFFFFFF),
        SolButtonVariant.text: Color(0x00000000),
      };
      for (final entry in expected.entries) {
        await pumpSol(
          tester,
          SolButton(label: 'B', variant: entry.key, onPressed: () {}),
        );
        final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
        expect(style.backgroundColor!.resolve({}), entry.value);
      }
    });

    testWidgets('deshabilitado: gris, sin tap y anunciado', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpSol(
        tester,
        const SolButton.primary(label: 'Continuar', onPressed: null),
      );
      final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
      expect(style.backgroundColor!.resolve({}), const Color(0xFFD9D9D9));
      expect(
        tester.getSemantics(find.byType(TextButton)),
        matchesSemantics(
          label: 'Continuar',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          isFocusable: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('cargando: no recibe taps y anuncia «cargando»', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await pumpSol(
        tester,
        SolButton.primary(
          label: 'Enviar',
          loading: true,
          onPressed: () => taps++,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(TextButton), warnIfMissed: false);
      expect(taps, 0);
      expect(find.bySemanticsLabel('Enviar, cargando'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('texto al 200 % crece sin desbordar', (tester) async {
      await pumpSol(
        tester,
        SolButton.primary(label: 'Completar registro', onPressed: () {}),
        textScale: 2,
        size: const Size(360, 800),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(TextButton)).height,
        greaterThanOrEqualTo(48),
      );
    });
  });

  group('SolLinkButton', () {
    testWidgets('48 dp de área táctil y nota en la semántica', (tester) async {
      var taps = 0;
      await pumpSol(
        tester,
        Center(
          child: SolLinkButton(
            label: 'Olvidé mi PIN o patrón',
            note: '(se resuelve en Ajustes del teléfono)',
            size: SolLinkSize.small,
            onPressed: () => taps++,
          ),
        ),
      );
      expect(tester.getSize(find.byType(InkWell)).height, 48);
      await tester.tap(find.byType(InkWell));
      expect(taps, 1);
      expect(
        find.bySemanticsLabel(
          'Olvidé mi PIN o patrón. (se resuelve en Ajustes del teléfono)',
        ),
        findsOneWidget,
      );
      await expectA11yGuidelines(tester);
    });
  });

  group('SolTopBar', () {
    testWidgets('«Con volver»: 56 dp, flecha 48 dp que hace pop', (
      tester,
    ) async {
      var back = 0;
      await pumpSol(
        tester,
        Scaffold(
          appBar: SolTopBar.flow(title: 'Prueba de vida', onBack: () => back++),
        ),
        scaffold: false,
      );
      expect(tester.getSize(find.byType(SolTopBar)).height, 56);
      final arrow = find.byTooltip('Volver');
      expect(tester.getSize(arrow), const Size(48, 48));
      await tester.tap(arrow);
      expect(back, 1);
      expect(find.text('Prueba de vida'), findsOneWidget);
      expect(find.byType(SolLocaleChip), findsOneWidget);
      expect(find.byType(SolAvatar), findsOneWidget);
      await expectA11yGuidelines(tester);
    });

    testWidgets('«Inicio»: wordmark e idioma, sin flecha ni perfil', (
      tester,
    ) async {
      await pumpSol(
        tester,
        const Scaffold(appBar: SolTopBar.home()),
        scaffold: false,
      );
      expect(find.text('Solventa'), findsOneWidget);
      expect(find.byTooltip('Volver'), findsNothing);
      expect(find.byType(SolAvatar), findsNothing);
      final wordmark = tester.widget<Text>(find.text('Solventa'));
      expect(wordmark.style!.color, const Color(0xFF2B5AA3));
      expect(wordmark.style!.fontSize, 20);
    });

    testWidgets('el título se marca como encabezado', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpSol(
        tester,
        const Scaffold(appBar: SolTopBar.flow(title: 'Verificación')),
        scaffold: false,
      );
      expect(
        tester.getSemantics(find.text('Verificación')),
        matchesSemantics(label: 'Verificación', isHeader: true),
      );
      handle.dispose();
    });

    testWidgets('texto al 200 % a 360 dp sin desbordes', (tester) async {
      await pumpSol(
        tester,
        const Scaffold(
          appBar: SolTopBar.flow(title: 'Autorización de datos personales'),
        ),
        scaffold: false,
        textScale: 2,
        size: const Size(360, 800),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('SolBottomNav', () {
    testWidgets('3 destinos con etiqueta, 80 dp y estado seleccionado', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      int? selected;
      await pumpSol(
        tester,
        Scaffold(
          bottomNavigationBar: SolBottomNav(
            selectedIndex: 0,
            onDestinationSelected: (i) => selected = i,
          ),
        ),
        scaffold: false,
      );
      expect(tester.getSize(find.byType(SolBottomNav)).height, 80);
      for (final label in ['Inicio', 'Asistencia', 'Cerrar sesión']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(
        tester.getSemantics(find.bySemanticsLabel('Inicio')),
        matchesSemantics(
          label: 'Inicio',
          hint: 'Pestaña 1 de 3',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.text('Asistencia'));
      expect(selected, 1);
      // El activo no depende solo del color: cambia el peso y el ícono se
      // rellena dentro de la píldora.
      final active = tester.widget<Text>(find.text('Inicio'));
      final inactive = tester.widget<Text>(find.text('Asistencia'));
      expect(active.style!.fontWeight, FontWeight.w600);
      expect(inactive.style!.fontWeight, FontWeight.w400);
      handle.dispose();
      await expectA11yGuidelines(tester, contrast: false);
    });

    testWidgets('texto al 200 % sin desbordes (etiquetas en 2 líneas)', (
      tester,
    ) async {
      await pumpSol(
        tester,
        Scaffold(
          bottomNavigationBar: SolBottomNav(
            selectedIndex: 1,
            onDestinationSelected: (_) {},
          ),
        ),
        scaffold: false,
        textScale: 2,
        size: const Size(360, 800),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('SolLocaleChip', () {
    testWidgets('píldora 32 dp, área táctil 48 dp y semántica', (tester) async {
      var taps = 0;
      await pumpSol(tester, Center(child: SolLocaleChip(onTap: () => taps++)));
      expect(find.text('ES · COP'), findsOneWidget);
      expect(tester.getSize(find.byType(InkWell)).height, 48);
      final pill = find.descendant(
        of: find.byType(SolLocaleChip),
        matching: find.byType(Container),
      );
      expect(tester.getSize(pill).height, 32);
      expect(tester.getSize(pill).width, greaterThanOrEqualTo(96));
      await tester.tap(find.byType(SolLocaleChip));
      expect(taps, 1);
      final handle = tester.ensureSemantics();
      expect(
        tester.getSemantics(find.byType(SolLocaleChip)),
        matchesSemantics(
          label: 'Idioma español, moneda pesos colombianos',
          hint: 'Cambiar idioma y moneda',
          isButton: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
      expect(
        find.bySemanticsLabel('Idioma español, moneda pesos colombianos'),
        findsOneWidget,
      );
      await expectA11yGuidelines(tester);
    });
  });

  group('SolProviderRow', () {
    testWidgets('meta «tipo · distancia · tiempo» y Solicitar', (tester) async {
      var requests = 0;
      await pumpSol(
        tester,
        SolProviderRow(
          name: 'Clínica Norte',
          type: SolProviderType.medico,
          distance: '1.2 km',
          eta: '6 min',
          onRequest: () => requests++,
        ),
      );
      expect(find.text('Médico · 1.2 km · 6 min'), findsOneWidget);
      final button = find.byType(FilledButton);
      expect(tester.getSize(button).height, 48);
      await tester.tap(button);
      expect(requests, 1);
      expect(find.bySemanticsLabel('Solicitar Clínica Norte'), findsOneWidget);
      expect(tester.getSize(find.byType(SolProviderRow)).height, 68);
      await expectA11yGuidelines(tester);
    });

    testWidgets('al 200 % el botón baja de línea sin desbordar', (
      tester,
    ) async {
      await pumpSol(
        tester,
        SolProviderRow(
          name: 'Taller AutoAyuda',
          type: SolProviderType.mecanico,
          distance: '2.0 km',
          eta: '9 min',
          onRequest: () {},
        ),
        textScale: 2,
        size: const Size(360, 800),
      );
      expect(tester.takeException(), isNull);
      final name = tester.getRect(find.text('Taller AutoAyuda'));
      final button = tester.getRect(find.byType(FilledButton));
      expect(button.top, greaterThan(name.bottom));
    });
  });

  group('SolDemoTrigger', () {
    testWidgets('visible en debug, color de anotación y 48 dp', (tester) async {
      var taps = 0;
      await pumpSol(
        tester,
        SolDemoTrigger(label: 'Simular error', onTap: () => taps++),
      );
      expect(kDebugMode, isTrue);
      final text = tester.widget<Text>(find.text('Simular error →'));
      expect(text.style!.color, const Color(0xFF8D651E));
      expect(text.style!.fontSize, 11);
      expect(tester.getSize(find.byType(InkWell)).height, 48);
      await tester.tap(find.byType(InkWell));
      expect(taps, 1);
      expect(find.bySemanticsLabel('Demo: Simular error'), findsOneWidget);
    });
  });

  group('SolAvatar', () {
    testWidgets('32 dp visibles con área táctil de 48 dp', (tester) async {
      await pumpSol(tester, Center(child: SolAvatar(onTap: () {})));
      expect(tester.getSize(find.byType(InkResponse)), const Size(48, 48));
      expect(find.bySemanticsLabel('Mi perfil'), findsOneWidget);
      await expectA11yGuidelines(tester);
    });
  });

  group('Ajustes de la revisión UX', () {
    Widget pair() => SolButtonPair(
      secondary: SolButton.outlined(label: 'Repetir', onPressed: () {}),
      primary: SolButton.primary(label: 'Capturar', onPressed: () {}),
    );

    testWidgets('SolButtonPair: en fila al 100 %, apilado al 200 %', (
      tester,
    ) async {
      await pumpSol(tester, pair());
      final redo = tester.getRect(find.text('Repetir'));
      final shoot = tester.getRect(find.text('Capturar'));
      expect(redo.center.dy, shoot.center.dy);
      expect(redo.left, lessThan(shoot.left));
      expect(tester.getSize(find.byType(SolButton).first).height, 48);

      await pumpSol(tester, pair(), textScale: 2);
      final buttons = find.byType(SolButton);
      final first = tester.getRect(buttons.first);
      final second = tester.getRect(buttons.last);
      // Primaria arriba, 8 dp de separación y ancho completo.
      expect(tester.getRect(find.text('Capturar')).top, lessThan(first.bottom));
      expect(second.top - first.bottom, closeTo(8, 0.5));
      expect(first.width, second.width);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SolTopBar: sin onProfileTap el avatar no es un botón', (
      tester,
    ) async {
      await pumpSol(
        tester,
        const SolTopBar.flow(title: 'Verificación', showBack: false),
        scaffold: false,
      );
      final avatar = tester.widget<SolAvatar>(find.byType(SolAvatar));
      expect(avatar.onTap, isNull);
      expect(
        find.descendant(
          of: find.byType(SolAvatar),
          matching: find.byType(InkResponse),
        ),
        findsNothing,
      );
    });

    testWidgets('SolTransitionalScreen no muestra el avatar', (tester) async {
      await pumpSol(
        tester,
        const SolTransitionalScreen(title: 'Verificación', message: '...'),
        scaffold: false,
      );
      expect(find.byType(SolAvatar), findsNothing);
    });

    testWidgets('SolLinkButton inline: sin padding lateral y 48 dp de alto', (
      tester,
    ) async {
      await pumpSol(
        tester,
        Align(
          alignment: Alignment.topLeft,
          child: SolLinkButton(
            label: 'Abrir Ajustes',
            inline: true,
            onPressed: () {},
          ),
        ),
      );
      final link = tester.getRect(find.byType(SolLinkButton));
      expect(tester.getRect(find.text('Abrir Ajustes')).left, link.left);
      expect(link.height, greaterThanOrEqualTo(48));
    });

    testWidgets('SolTextField deshabilitado: fondo #F5F5F5 y borde #D9D9D9', (
      tester,
    ) async {
      await pumpSol(
        tester,
        const SolTextField(label: 'Cédula', enabled: false),
      );
      final box = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(SolTextField),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final deco = box.decoration! as BoxDecoration;
      expect(deco.color, const Color(0xFFF5F5F5));
      expect((deco.border! as Border).top.color, const Color(0xFFD9D9D9));
    });

    testWidgets('SolSheetLayout: hoja pegada abajo y limitada al 60 %', (
      tester,
    ) async {
      await pumpSol(
        tester,
        const SolSheetLayout(
          background: ColoredBox(color: Colors.green),
          sheet: SolBottomSheetPanel(child: SizedBox(height: 2000)),
        ),
        scaffold: false,
      );
      final sheet = tester.getRect(find.byType(SolBottomSheetPanel));
      expect(sheet.bottom, 844);
      // Contenido largo: la hoja se limita al 60 % y hace scroll dentro.
      expect(sheet.height, closeTo(844 * 0.6, 0.5));
      expect(tester.takeException(), isNull);
    });
  });
}
