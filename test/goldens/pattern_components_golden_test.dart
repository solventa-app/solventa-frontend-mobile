@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import 'golden_helpers.dart';

/// Componentes sacados de patrones repetidos en las pantallas.
void main() {
  void noop() {}

  solGoldenMatrix(
    'status_badges_banners',
    () => GoldenSheet(
      cases: {
        'Badge success': const Align(
          alignment: Alignment.centerLeft,
          child: SolStatusBadge(
            status: SolStatus.success,
            label: 'Identidad verificada',
          ),
        ),
        'Badge warning': const Align(
          alignment: Alignment.centerLeft,
          child: SolStatusBadge(
            status: SolStatus.warning,
            label: 'En revisión',
          ),
        ),
        'Badge error': const Align(
          alignment: Alignment.centerLeft,
          child: SolStatusBadge(
            status: SolStatus.error,
            label: 'No pudimos verificarte',
          ),
        ),
        'Banner success': const SolStatusBanner(
          status: SolStatus.success,
          title: 'Acceso concedido',
        ),
        'Banner warning': const SolStatusBanner(
          status: SolStatus.warning,
          title: 'En revisión',
          message: 'Estamos revisando tu identidad, te avisamos.',
        ),
        'Banner error con acción': SolStatusBanner(
          status: SolStatus.error,
          title: 'Sin permiso de cámara',
          message: 'Actívalo para capturar tu documento.',
          action: SolLinkButton(
            label: 'Abrir Ajustes',
            inline: true,
            onPressed: noop,
          ),
        ),
        'Banner info': const SolStatusBanner(
          status: SolStatus.info,
          title: 'Formato es-CO',
          message: r'Montos «$ 450.000» · fechas «12 sep 2026, 11:02 a. m.»',
        ),
      },
    ),
  );

  solGoldenMatrix(
    'consent_checkbox',
    () => GoldenSheet(
      cases: {
        'Sin marcar (M01-02)': SolConsentCheckbox(
          value: false,
          onChanged: (_) {},
          label: 'Autorizo el tratamiento de mis datos personales',
        ),
        'Marcado (M01-02b)': SolConsentCheckbox(
          value: true,
          onChanged: (_) {},
          label: 'Autorizo el tratamiento de mis datos personales',
        ),
        'Deshabilitado': const SolConsentCheckbox(
          value: false,
          onChanged: null,
          label: 'Autorizo el tratamiento de mis datos personales',
        ),
      },
    ),
    pumpBeforeTest: pumpOnce,
  );

  solGoldenMatrix(
    'pin_keypad',
    () => GoldenSheet(
      cases: {
        'PIN vacío (M02-02)': const Center(child: SolPinIndicator(filled: 0)),
        'PIN 2 de 4': const Center(child: SolPinIndicator(filled: 2)),
        'PIN completo (M02-02b)': const Center(
          child: SolPinIndicator(filled: 4),
        ),
        'Teclado numérico': SolNumericKeypad(
          onDigit: (_) {},
          onBackspace: noop,
        ),
      },
    ),
    pumpBeforeTest: pumpOnce,
  );

  solGoldenMatrix(
    'cards',
    () => GoldenSheet(
      cases: {
        'Tarjeta delineada (SG-01)': const SolCard.outlined(
          child: Text('Contenido de la tarjeta'),
        ),
        'Tarjeta elevada (G-03)': SolCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Completa tu registro para activar tu cuenta'),
              const SizedBox(height: 16),
              SolButton.primary(label: 'Completar registro', onPressed: noop),
            ],
          ),
        ),
        'Tarjeta-acción (G-03)': SolActionTile(
          icon: SolIcons.assistanceActive,
          title: 'Solicitar asistencia en sitio',
          onTap: noop,
        ),
      },
    ),
  );

  solGoldenMatrix(
    'text_fields',
    () => GoldenSheet(
      cases: {
        'Selector (M06-02)': SolTextField.select(
          label: 'Tipo de asistencia',
          value: 'Médica',
          onTap: noop,
        ),
        'Multilínea con sugerencia (M06-02)': const SolTextField(
          label: 'Describe brevemente qué pasó',
          hint: 'Ej. dolor en el pecho, mareo...',
          maxLines: 5,
          minLines: 5,
        ),
        'Con valor y ayuda': const SolTextField(
          label: 'Correo electrónico',
          initialValue: 'maria@correo.co',
          helperText: 'Te enviaremos el comprobante a este correo.',
        ),
        'Con error': const SolTextField(
          label: 'Número de cédula',
          initialValue: '12345',
          errorText: 'La cédula debe tener entre 6 y 10 dígitos.',
        ),
        'Deshabilitado': const SolTextField(
          label: 'Ciudad',
          initialValue: 'Bogotá D.C.',
          enabled: false,
        ),
      },
    ),
  );

  solGoldenMatrix(
    'bottom_sheet_panel',
    () => ColoredBox(
      color: SolColors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SolBottomSheetPanel(
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
    ),
  );

  solGoldenMatrix(
    'confirm_dialog',
    () => GoldenSheet(
      cases: {
        'Confirmación destructiva (M06-05)': Material(
          color: SolColors.surface,
          shape: const RoundedRectangleBorder(borderRadius: SolRadius.cardAll),
          child: SolConfirmPanel(
            title: '¿Seguro que quieres cancelar?',
            message:
                'Clínica Norte ya está en camino. Si cancelas ahora, tendrás '
                'que solicitar asistencia de nuevo desde cero.',
            confirmLabel: 'Sí, cancelar',
            cancelLabel: 'No, mantener solicitud',
            onConfirm: noop,
            onCancel: noop,
          ),
        ),
      },
    ),
  );

  solGoldenMatrix(
    'loading_state',
    () => const GoldenSheet(
      cases: {
        'Alineado al inicio (M01-06)': SolLoadingState(
          message: 'Validando con el proveedor KYC/AML...',
        ),
        'Centrado': SolLoadingState(
          message: 'Enviando solicitud...',
          center: true,
        ),
      },
    ),
    pumpBeforeTest: pumpSpinner,
  );

  solGoldenMatrix(
    'result_view',
    () => const GoldenSheet(
      cases: {
        'Éxito (M01-07a)': SolResultView(
          status: SolStatus.success,
          message: '¡Identidad verificada! Bienvenido a Solventa.',
        ),
        'En revisión (M01-07b)': SolResultView(
          status: SolStatus.warning,
          message: 'Estamos revisando tu identidad, te avisamos.',
        ),
        'Error (M01-07c)': SolResultView(
          status: SolStatus.error,
          message: 'No pudimos verificar tu documento (imagen ilegible)',
        ),
      },
    ),
  );

  solGoldenMatrix(
    'camera_frame',
    () => const GoldenSheet(
      cases: {
        'Documento (M01-03)': Center(
          child: SolCameraFrame(
            label: 'Cédula de ciudadanía',
            labelIcon: SolIcons.idCard,
            instruction: 'Ubica el FRENTE del documento dentro del marco',
          ),
        ),
        'Rostro (prueba de vida)': Center(
          child: SolCameraFrame(
            shape: SolCameraFrameShape.face,
            label: 'Prueba de vida',
            labelIcon: SolIcons.face,
            instruction: 'Centra tu rostro y parpadea despacio',
          ),
        ),
      },
    ),
  );

  solGoldenMatrix(
    'misc_divider_header_links',
    () => GoldenSheet(
      cases: {
        'Divisor 1 dp': const SolDivider(),
        'Encabezado de sección': const SolSectionHeader(
          title: 'Prestadores cercanos',
          count: '3 disponibles',
        ),
        'Enlace (Abrir Ajustes)': Center(
          child: SolLinkButton(label: 'Abrir Ajustes', onPressed: noop),
        ),
        'Enlace pequeño con nota (M02-02)': Center(
          child: SolLinkButton(
            label: 'Olvidé mi PIN o patrón',
            note: '(se resuelve en Ajustes del teléfono)',
            size: SolLinkSize.small,
            onPressed: noop,
          ),
        ),
        'Nota en línea (G-03)': const SolInlineNote(
          icon: SolIcons.wallet,
          text: 'Billetera y estado de póliza — próximamente',
          center: true,
        ),
        'Consejo de captura (M01-03)': const SolInlineNote(
          icon: SolIcons.lighting,
          text: 'Evita reflejos de luz directa y sombras pronunciadas',
          center: true,
        ),
      },
    ),
  );
}
