import 'package:flutter/material.dart';

import '../../../core/design_system/solventa_ui.dart';

/// G-03 · Home del cliente (registro pendiente).
///
/// Se arma solo con piezas de la librería; va dentro de [SolAppShell].
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.userName,
    required this.onCompleteRegistration,
    required this.onRequestAssistance,
  });

  final String userName;
  final VoidCallback onCompleteRegistration;
  final VoidCallback onRequestAssistance;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        SolSpacing.screen,
        SolSpacing.xl,
        SolSpacing.screen,
        SolSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Hola, $userName',
              style: context.solText.headline.copyWith(color: colors.onSurface),
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          SolCard.elevated(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        SolIcons.pendingRegistration,
                        size: SolSizes.icon,
                        color: context.solColors.warning,
                      ),
                    ),
                    const SizedBox(width: SolSpacing.md),
                    Expanded(
                      child: Text(
                        'Completa tu registro para activar tu cuenta',
                        style: context.solText.body.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SolSpacing.lg),
                SolButton.primary(
                  label: 'Completar registro',
                  onPressed: onCompleteRegistration,
                ),
              ],
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          SolActionTile(
            icon: SolIcons.assistanceActive,
            title: 'Solicitar asistencia en sitio',
            onTap: onRequestAssistance,
          ),
          const SizedBox(height: SolSpacing.xl),
          const SolInlineNote(
            icon: SolIcons.wallet,
            text: 'Billetera y estado de póliza — próximamente',
            center: true,
          ),
        ],
      ),
    );
  }
}
