@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/features/home/presentation/home_page.dart';

import 'golden_helpers.dart';

/// Layouts globales y Home G-03 a pantalla completa (alto 844 dp).
void main() {
  void noop() {}
  const height = 844.0;

  solGoldenMatrix('home_g03', () {
    return SolAppShell(
      home: HomePage(
        userName: 'María',
        onCompleteRegistration: noop,
        onRequestAssistance: noop,
      ),
      assistance: const SizedBox.shrink(),
      onLogout: noop,
    );
  }, height: height);

  solGoldenMatrix(
    'flow_scaffold_inline_cta',
    () {
      return SolFlowScaffold(
        title: 'Autorización de datos',
        anchorActions: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Para verificar tu identidad necesitamos tu autorización para '
              'tratar tus datos personales conforme a la Ley 1581 de 2012 '
              '(Habeas Data).',
            ),
            const SizedBox(height: SolSpacing.xxxl),
            SolConsentCheckbox(
              value: true,
              onChanged: (_) {},
              label: 'Autorizo el tratamiento de mis datos personales',
            ),
          ],
        ),
        actions: [SolButton.primary(label: 'Continuar', onPressed: noop)],
      );
    },
    height: height,
    pumpBeforeTest: pumpOnce,
  );

  solGoldenMatrix('flow_scaffold_anchored_cta', () {
    return SolFlowScaffold(
      title: 'Captura del documento',
      padding: const EdgeInsets.fromLTRB(31, 16, 31, 16),
      body: const Column(
        children: [
          SolCameraFrame(
            label: 'Cédula de ciudadanía',
            labelIcon: SolIcons.idCard,
            instruction: 'Ubica el FRENTE del documento dentro del marco',
          ),
          SizedBox(height: SolSpacing.sm),
          SolInlineNote(
            icon: SolIcons.lighting,
            text: 'Evita reflejos de luz directa y sombras pronunciadas',
            center: true,
          ),
        ],
      ),
      actions: [
        SolButtonPair(
          secondary: SolButton.outlined(
            label: 'Repetir',
            icon: SolIcons.retry,
            onPressed: noop,
          ),
          primary: SolButton.primary(
            label: 'Capturar',
            icon: SolIcons.camera,
            onPressed: noop,
          ),
        ),
      ],
    );
  }, height: height);

  solGoldenMatrix(
    'flow_scaffold_pin',
    () {
      return SolFlowScaffold(
        title: 'Ingresa tu PIN',
        anchorActions: false,
        // 32 arriba (2018:528); contenedor de 360 como máximo (2018:527).
        padding: const EdgeInsets.fromLTRB(
          SolSpacing.screen,
          SolSpacing.xxxl,
          SolSpacing.screen,
          SolSpacing.xxl,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: SolColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(SolIcons.lock, color: SolColors.primary),
                ),
                const SizedBox(height: SolSpacing.lg),
                // Título de 280 como máximo (2018:533).
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: const Text(
                    'Ingresa el PIN o patrón de tu teléfono',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                const SizedBox(height: SolSpacing.xxxl),
                const SolPinIndicator(filled: 4),
                const SizedBox(height: SolSpacing.xxxl),
                SolNumericKeypad(onDigit: (_) {}, onBackspace: noop),
              ],
            ),
          ),
        ),
        actions: [
          SolButton.primary(label: 'Ingresar', onPressed: noop),
          SolLinkButton(
            label: 'Olvidé mi PIN o patrón',
            note: '(se resuelve en Ajustes del teléfono)',
            size: SolLinkSize.small,
            onPressed: noop,
          ),
        ],
      );
    },
    height: height,
    pumpBeforeTest: pumpOnce,
  );

  solGoldenMatrix('entry_scaffold', () {
    return SolEntryScaffold(
      title: 'Bienvenido',
      body: const Text(
        'Usa tu huella o tu rostro para ingresar de forma segura.',
      ),
      actions: [
        SolButton.primary(label: 'Usar biometría', onPressed: noop),
        Center(
          child: SolButton.text(label: 'Usar PIN en su lugar', onPressed: noop),
        ),
      ],
    );
  }, height: height);

  solGoldenMatrix(
    'transitional_screen',
    () => const SolTransitionalScreen(
      title: 'Verificación',
      message: 'Validando con el proveedor KYC/AML...',
    ),
    height: height,
    pumpBeforeTest: pumpSpinner,
  );

  for (final (name, status, message, action) in [
    (
      'result_screen_success',
      SolStatus.success,
      '¡Identidad verificada! Bienvenido a Solventa.',
      'Ir a mi cuenta',
    ),
    (
      'result_screen_warning',
      SolStatus.warning,
      'Estamos revisando tu identidad, te avisamos.',
      'Entendido',
    ),
    (
      'result_screen_error',
      SolStatus.error,
      'No pudimos verificar tu documento (imagen ilegible)',
      'Reintentar',
    ),
  ]) {
    solGoldenMatrix(
      name,
      () => SolResultScreen(
        title: 'Verificación',
        status: status,
        message: message,
        actionLabel: action,
        onAction: noop,
      ),
      height: height,
    );
  }

  solGoldenMatrix('top_level_providers_sheet', () {
    return SolTopLevelScaffold(
      selectedIndex: 1,
      onDestinationSelected: (_) {},
      // Mapa flex-1 + hoja pegada a la barra inferior (2005:3).
      body: SolSheetLayout(
        background: const ColoredBox(color: Color(0xFFDCE8DF)),
        sheet: SolBottomSheetPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SolSectionHeader(
                title: 'Prestadores cercanos',
                count: '3 disponibles',
              ),
              SolProviderRow(
                name: 'Clínica Norte',
                type: SolProviderType.medico,
                distance: SolFormat.distanceKm(1.2),
                eta: SolFormat.minutes(6),
                onRequest: noop,
              ),
              const SolDivider(),
              SolProviderRow(
                name: 'Taller AutoAyuda',
                type: SolProviderType.mecanico,
                distance: SolFormat.distanceKm(2),
                eta: SolFormat.minutes(9),
                onRequest: noop,
              ),
            ],
          ),
        ),
      ),
    );
  }, height: height);
}
