import 'package:flutter/material.dart';

import '../components/buttons/sol_button.dart';
import '../components/feedback/sol_result_view.dart';
import '../components/feedback/sol_status.dart';
import '../components/navigation/sol_top_bar.dart';
import 'sol_screen_frame.dart';

/// Plantilla de resultado (éxito / en revisión / error, M01-07): tarjeta de
/// estado centrada y una acción principal anclada abajo.
class SolResultScreen extends StatelessWidget {
  const SolResultScreen({
    super.key,
    required this.title,
    required this.status,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.onBack,
    this.showBack = true,
    this.secondaryAction,
  });

  final String title;
  final SolStatus status;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  /// Si se da, intercepta la flecha y el atrás del sistema.
  final VoidCallback? onBack;
  final bool showBack;

  /// Acción alterna opcional (tonal o texto).
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final frame = SolScreenFrame(
      topBar: SolTopBar.flow(title: title, onBack: onBack, showBack: showBack),
      centerBody: true,
      body: SolResultView(status: status, message: message),
      actions: [
        SolButton.primary(label: actionLabel, onPressed: onAction),
        ?secondaryAction,
      ],
    );
    if (onBack == null && showBack) return frame;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onBack?.call();
      },
      child: frame,
    );
  }
}
