import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import '../../../helpers/sol_test_app.dart';

void main() {
  group('SolStatusBadge / SolStatusBanner', () {
    testWidgets('cada estado lleva ícono y texto, no solo color', (
      tester,
    ) async {
      await pumpSol(
        tester,
        const Column(
          children: [
            SolStatusBadge(status: SolStatus.success, label: 'Verificada'),
            SolStatusBadge(status: SolStatus.warning, label: 'En revisión'),
            SolStatusBadge(status: SolStatus.error, label: 'Rechazada'),
          ],
        ),
      );
      expect(find.byType(Icon), findsNWidgets(3));
      expect(find.bySemanticsLabel('Éxito: Verificada'), findsOneWidget);
      expect(find.bySemanticsLabel('Atención: En revisión'), findsOneWidget);
      expect(find.bySemanticsLabel('Error: Rechazada'), findsOneWidget);
    });

    testWidgets('el banner es liveRegion y usa los colores del estado', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpSol(
        tester,
        const SolStatusBanner(
          status: SolStatus.warning,
          title: 'En revisión',
          message: 'Te avisamos.',
        ),
      );
      final node = tester.getSemantics(find.byType(SolStatusBanner));
      expect(node.flagsCollection.isLiveRegion, isTrue);
      final title = tester.widget<Text>(find.text('En revisión'));
      expect(title.style!.color, const Color(0xFF8D651E));
      handle.dispose();
      await expectA11yGuidelines(tester);
    });
  });

  group('SolConsentCheckbox', () {
    testWidgets('toda la fila alterna el valor y se anuncia marcado', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var value = false;
      await pumpSol(
        tester,
        StatefulBuilder(
          builder: (context, setState) => SolConsentCheckbox(
            value: value,
            onChanged: (v) => setState(() => value = v),
            label: 'Autorizo el tratamiento de mis datos personales',
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(InkWell)).height,
        greaterThanOrEqualTo(48),
      );
      await tester.tap(
        find.text('Autorizo el tratamiento de mis datos personales'),
      );
      await tester.pump();
      expect(value, isTrue);
      expect(
        tester.getSemantics(find.byType(SolConsentCheckbox)),
        matchesSemantics(
          label: 'Autorizo el tratamiento de mis datos personales',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
      await expectA11yGuidelines(tester);
    });

    testWidgets('casilla de 20 dp', (tester) async {
      await pumpSol(
        tester,
        SolConsentCheckbox(value: true, onChanged: (_) {}, label: 'Acepto'),
      );
      final box = find.descendant(
        of: find.byType(SolConsentCheckbox),
        matching: find.byType(AnimatedContainer),
      );
      expect(tester.getSize(box), const Size(20, 20));
    });
  });

  group('SolPinIndicator y SolNumericKeypad', () {
    testWidgets('el teclado escribe y borra; el indicador lo anuncia', (
      tester,
    ) async {
      var pin = '';
      await pumpSol(
        tester,
        StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              SolPinIndicator(filled: pin.length),
              SolNumericKeypad(
                onDigit: (d) => setState(() => pin += '$d'),
                onBackspace: () => setState(
                  () => pin = pin.isEmpty
                      ? pin
                      : pin.substring(0, pin.length - 1),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('1'));
      await tester.tap(find.text('9'));
      await tester.pump();
      expect(pin, '19');
      expect(
        find.bySemanticsLabel('PIN: 2 de 4 dígitos ingresados'),
        findsOneWidget,
      );
      await tester.tap(find.bySemanticsLabel('Borrar dígito'));
      await tester.pump();
      expect(pin, '1');
      // Teclas de 48 dp con radio de 8 dp.
      final key = find.ancestor(
        of: find.text('5'),
        matching: find.byType(InkWell),
      );
      expect(tester.getSize(key).height, 48);
      await expectA11yGuidelines(tester, contrast: false);
    });
  });

  group('SolCard y SolActionTile', () {
    testWidgets('radio de 12 dp, borde outline y tap ≥ 48 dp', (tester) async {
      var taps = 0;
      await pumpSol(
        tester,
        Column(
          children: [
            const SolCard(child: Text('Delineada')),
            SolActionTile(
              icon: SolIcons.assistanceActive,
              title: 'Solicitar asistencia en sitio',
              onTap: () => taps++,
            ),
          ],
        ),
      );
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(SolCard).first,
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final deco = box.decoration as BoxDecoration;
      expect(deco.borderRadius, SolRadius.cardAll);
      expect((deco.border! as Border).top.color, const Color(0xFFD9D9D9));
      await tester.tap(find.text('Solicitar asistencia en sitio'));
      expect(taps, 1);
      expect(
        find.bySemanticsLabel('Solicitar asistencia en sitio'),
        findsOneWidget,
      );
      await expectA11yGuidelines(tester);
    });
  });

  group('SolTextField', () {
    testWidgets('escribe, muestra ayuda y error con ícono', (tester) async {
      String? value;
      await pumpSol(
        tester,
        Column(
          children: [
            SolTextField(
              label: 'Correo',
              helperText: 'Ayuda',
              onChanged: (v) => value = v,
            ),
            const SolTextField(label: 'Cédula', errorText: 'Dato inválido'),
          ],
        ),
      );
      await tester.enterText(find.byType(TextField).first, 'maria@correo.co');
      expect(value, 'maria@correo.co');
      expect(find.text('Ayuda'), findsOneWidget);
      expect(find.text('Dato inválido'), findsOneWidget);
      expect(find.bySemanticsLabel('Error: Dato inválido'), findsOneWidget);
      expect(find.byIcon(SolIcons.error), findsOneWidget);
      expect(
        tester.getSize(find.byType(AnimatedContainer).first).height,
        greaterThanOrEqualTo(56),
      );
    });

    testWidgets('el selector abre con tap', (tester) async {
      var taps = 0;
      await pumpSol(
        tester,
        SolTextField.select(
          label: 'Tipo de asistencia',
          value: 'Médica',
          onTap: () => taps++,
        ),
      );
      expect(find.text('Médica'), findsOneWidget);
      expect(find.byIcon(SolIcons.expandMore), findsOneWidget);
      await tester.tap(find.text('Médica'));
      expect(taps, greaterThanOrEqualTo(1));
    });

    testWidgets('al 200 % no desborda', (tester) async {
      await pumpSol(
        tester,
        const SolTextField(
          label: 'Describe brevemente qué pasó',
          hint: 'Ej. dolor en el pecho, mareo...',
          errorText: 'Cuéntanos qué pasó para enviar la solicitud.',
          maxLines: 4,
        ),
        textScale: 2,
        size: const Size(360, 800),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('SolBottomSheet y SolConfirmDialog', () {
    testWidgets('la hoja modal se abre y se cierra', (tester) async {
      await pumpSol(
        tester,
        Builder(
          builder: (context) => SolButton.primary(
            label: 'Abrir',
            onPressed: () => SolBottomSheet.show<void>(
              context,
              builder: (_) => const Text('Contenido de la hoja'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      expect(find.text('Contenido de la hoja'), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Contenido de la hoja'), findsNothing);
    });

    testWidgets('confirmar devuelve true; mantener devuelve false', (
      tester,
    ) async {
      final results = <bool>[];
      await pumpSol(
        tester,
        Builder(
          builder: (context) => SolButton.destructive(
            label: 'Cancelar asistencia',
            onPressed: () async => results.add(
              await SolConfirmDialog.show(
                context,
                title: '¿Seguro que quieres cancelar?',
                message: 'Tendrás que solicitar asistencia de nuevo.',
                confirmLabel: 'Sí, cancelar',
                cancelLabel: 'No, mantener solicitud',
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Cancelar asistencia'));
      await tester.pumpAndSettle();
      expect(find.text('¿Seguro que quieres cancelar?'), findsOneWidget);
      await expectA11yGuidelines(tester);
      await tester.tap(find.text('Sí, cancelar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar asistencia'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No, mantener solicitud'));
      await tester.pumpAndSettle();
      expect(results, [true, false]);
    });

    testWidgets('el panel fijo dibuja el tirador de 40 × 4 dp', (tester) async {
      await pumpSol(tester, const SolBottomSheetPanel(child: Text('Lista')));
      final handle = find.descendant(
        of: find.byType(SolBottomSheetPanel),
        matching: find.byWidgetPredicate(
          (w) => w is Container && w.constraints?.maxWidth == 40,
        ),
      );
      expect(tester.getSize(handle), const Size(40, 4));
    });
  });

  group('SolLoadingState y SolResultView', () {
    testWidgets('la carga se anuncia y respeta «quitar animaciones»', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpSol(
        tester,
        const SolLoadingState(message: 'Validando...'),
        disableAnimations: true,
      );
      final node = tester.getSemantics(find.byType(SolLoadingState));
      expect(node.label, 'Validando...');
      expect(node.flagsCollection.isLiveRegion, isTrue);
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, isNotNull);
      handle.dispose();
    });

    testWidgets('el resultado anuncia estado y mensaje', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpSol(
        tester,
        const SolResultView(
          status: SolStatus.error,
          message: 'No pudimos verificar tu documento',
        ),
      );
      final node = tester.getSemantics(find.byType(SolResultView));
      expect(node.label, 'Error. No pudimos verificar tu documento');
      expect(node.flagsCollection.isLiveRegion, isTrue);
      handle.dispose();
    });
  });

  group('SolCameraFrame', () {
    testWidgets('describe el visor para TalkBack y no desborda al 200 %', (
      tester,
    ) async {
      await pumpSol(
        tester,
        const SolCameraFrame(
          label: 'Cédula de ciudadanía',
          instruction: 'Ubica el FRENTE del documento dentro del marco',
        ),
        textScale: 2,
        size: const Size(360, 800),
      );
      expect(tester.takeException(), isNull);
      expect(
        find.bySemanticsLabel(
          'Cédula de ciudadanía. Visor de cámara. Ubica el FRENTE del '
          'documento dentro del marco',
        ),
        findsOneWidget,
      );
    });
  });

  group('Varios', () {
    testWidgets('divisor de 1 dp y encabezado marcado como header', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpSol(
        tester,
        const Column(
          children: [
            SolSectionHeader(title: 'Prestadores', count: '3 disponibles'),
            SolDivider(),
            SolInlineNote(text: 'Próximamente', icon: SolIcons.wallet),
          ],
        ),
      );
      expect(tester.getSize(find.byType(SolDivider)).height, 1);
      expect(
        tester.getSemantics(find.text('Prestadores')),
        matchesSemantics(label: 'Prestadores', isHeader: true),
      );
      handle.dispose();
    });
  });
}
