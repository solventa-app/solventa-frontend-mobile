import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';

/// Qué eligió el cliente al cerrar sesión con reportes en el teléfono.
sealed class CierreConReportes {
  const CierreConReportes();
}

/// Cerrar sesión; [borrar] si además pidió borrar los reportes guardados.
final class CerrarSesion extends CierreConReportes {
  const CerrarSesion({required this.borrar});

  final bool borrar;
}

/// Enviar primero lo pendiente: la sesión sigue abierta.
final class EnviarAntes extends CierreConReportes {
  const EnviarAntes();
}

/// G-04 con reportes de siniestro sin enviar (plan 4.6): nunca se borran sin
/// que el cliente lo pida. Dice cuántos hay, que quedan guardados para cuando
/// vuelva a entrar con la misma cuenta, y deja borrarlos con una casilla.
class DialogoCierreConReportes extends StatefulWidget {
  const DialogoCierreConReportes({
    super.key,
    required this.sinEnviar,
    required this.sinTerminar,
    required this.puedeEnviar,
  });

  /// Reportes completos que esperan envío (pendientes, con error…).
  final int sinEnviar;

  /// Borradores.
  final int sinTerminar;

  /// Hay conexión y algo que se pueda enviar ya: se ofrece «Enviar ahora».
  final bool puedeEnviar;

  /// `null` si el cliente decide quedarse (o cierra el diálogo).
  static Future<CierreConReportes?> preguntar(
    BuildContext context, {
    required int sinEnviar,
    required int sinTerminar,
    required bool puedeEnviar,
  }) => showDialog<CierreConReportes>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(SolSpacing.lg),
      shape: const RoundedRectangleBorder(borderRadius: SolRadius.cardAll),
      child: SingleChildScrollView(
        child: DialogoCierreConReportes(
          sinEnviar: sinEnviar,
          sinTerminar: sinTerminar,
          puedeEnviar: puedeEnviar,
        ),
      ),
    ),
  );

  @override
  State<DialogoCierreConReportes> createState() =>
      _DialogoCierreConReportesState();
}

class _DialogoCierreConReportesState extends State<DialogoCierreConReportes> {
  bool _borrar = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                    l10n.cerrarSesionTitulo,
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
            widget.sinEnviar > 0
                ? l10n.cerrarSesionReportesSinEnviar(widget.sinEnviar)
                : l10n.cerrarSesionReportesSinTerminar(widget.sinTerminar),
            style: context.solText.body.copyWith(
              color: colors.onSurface,
              height: 22.75 / 14,
            ),
          ),
          const SizedBox(height: SolSpacing.md),
          SolConsentCheckbox(
            value: _borrar,
            onChanged: (v) => setState(() => _borrar = v),
            label: l10n.cerrarSesionBorrarReportes,
          ),
          const SizedBox(height: SolSpacing.xl),
          if (widget.puedeEnviar) ...[
            SolButton.primary(
              label: l10n.cerrarSesionEnviarAhora,
              onPressed: () => Navigator.pop(context, const EnviarAntes()),
            ),
            const SizedBox(height: SolSpacing.sm),
          ],
          SolButton.destructive(
            label: l10n.cerrarSesionConfirmar,
            onPressed: () =>
                Navigator.pop(context, CerrarSesion(borrar: _borrar)),
          ),
          const SizedBox(height: SolSpacing.sm),
          SolButton.tonal(
            label: l10n.cerrarSesionCancelar,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
