import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../design_system/solventa_ui.dart';
import '../l10n/l10n.dart';

/// Atrás seguro: la flecha y el atrás del sistema vuelven a la pantalla
/// anterior y, si no hay ninguna (la pantalla se abrió directo, p. ej. desde
/// una notificación), llevan al inicio en vez de fallar o cerrar la app.
extension VolverContext on BuildContext {
  void volverOInicio() => canPop() ? pop() : go('/');
}

/// Casita de un formulario: confirma antes de ir al inicio, porque se pierde
/// lo que el usuario lleva. Sin [ir] no hay casita (devuelve `null`).
VoidCallback? salirAlInicioConfirmando(BuildContext context, VoidCallback? ir) {
  if (ir == null) return null;
  return () async {
    final l10n = context.l10n;
    final salir = await SolConfirmDialog.show(
      context,
      title: l10n.salirInicioTitulo,
      message: l10n.salirInicioMensaje,
      confirmLabel: l10n.salirInicioConfirmar,
      cancelLabel: l10n.salirInicioCancelar,
    );
    if (salir) ir();
  };
}
