import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import 'm06_04_resultado_page.dart';

/// M06-06 · Asistencia cancelada (Figma 2005:529, KAN-159). La cancelación se
/// confirma explícitamente; desde aquí se vuelve al inicio o se pide de nuevo.
class M0606CanceladaPage extends StatelessWidget {
  const M0606CanceladaPage({
    super.key,
    required this.onIrAlMapa,
    required this.onIrAlInicio,
  });

  final VoidCallback onIrAlMapa;
  final VoidCallback onIrAlInicio;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SolResultScreen(
      title: l10n.m0606Titulo,
      status: SolStatus.info,
      message: l10n.m0606Mensaje,
      actionLabel: l10n.m0606VolverInicio,
      onAction: () => navegarDespues(context, onIrAlInicio),
      onBack: () => navegarDespues(context, onIrAlInicio),
      secondaryAction: SolButton.tonal(
        label: l10n.m0606SolicitarDeNuevo,
        onPressed: () => navegarDespues(context, onIrAlMapa),
      ),
    );
  }
}
