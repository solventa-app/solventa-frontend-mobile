import 'package:flutter/material.dart';

import '../../../core/design_system/solventa_ui.dart';

/// Destino «Asistencia» provisional hasta implementar HU-M06.
class AssistancePlaceholderPage extends StatelessWidget {
  const AssistancePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(SolSpacing.screen),
      child: SolInlineNote(
        icon: SolIcons.assistanceActive,
        text: 'Asistencia en sitio — próximamente',
        center: true,
      ),
    );
  }
}
