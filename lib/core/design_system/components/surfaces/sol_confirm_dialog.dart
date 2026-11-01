import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';
import '../buttons/sol_button.dart';

/// Contenido de confirmación de una acción destructiva (M06-05): ícono de
/// advertencia + título, explicación, botón destructivo y botón tonal.
class SolConfirmPanel extends StatelessWidget {
  const SolConfirmPanel({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    return Padding(
      padding: const EdgeInsets.all(SolSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Icon(SolIcons.warning, size: 24, color: sol.warning),
              ),
              const SizedBox(width: SolSpacing.sm),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: context.solText.title.copyWith(
                      color: sol.warning,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SolSpacing.sm),
          Text(
            message,
            style: context.solText.body.copyWith(
              color: colors.onSurface,
              height: 22.75 / 14,
            ),
          ),
          const SizedBox(height: SolSpacing.xxxl),
          SolButton.destructive(label: confirmLabel, onPressed: onConfirm),
          const SizedBox(height: SolSpacing.sm),
          SolButton.tonal(label: cancelLabel, onPressed: onCancel),
        ],
      ),
    );
  }
}

/// Diálogo de confirmación para acciones destructivas.
///
/// `await SolConfirmDialog.show(...)` devuelve `true` solo si el usuario
/// confirma; cerrar o tocar fuera devuelve `false`.
abstract final class SolConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(SolSpacing.lg),
        shape: const RoundedRectangleBorder(borderRadius: SolRadius.cardAll),
        child: SingleChildScrollView(
          child: SolConfirmPanel(
            title: title,
            message: message,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            onConfirm: () => Navigator.pop(context, true),
            onCancel: () => Navigator.pop(context, false),
          ),
        ),
      ),
    );
    return result ?? false;
  }
}
