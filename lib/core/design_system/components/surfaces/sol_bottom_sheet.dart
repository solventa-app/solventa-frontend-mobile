import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Hoja inferior de Solventa: superficie blanca, esquinas superiores de
/// 12 dp y tirador de 40 × 4 dp (M06-01).
abstract final class SolBottomSheet {
  /// Abre una hoja modal. Arrastrable y con cierre por el atrás del sistema.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SolSpacing.lg,
            0,
            SolSpacing.lg,
            SolSpacing.xxl,
          ),
          child: builder(context),
        ),
      ),
    );
  }
}

/// Fondo (mapa) que ocupa todo el alto libre y hoja fija pegada abajo, que
/// toma solo el alto de su contenido (M06-01, Figma 2005:3).
///
/// La hoja se limita a [maxSheetFactor] del alto disponible real (no del de
/// pantalla), así funciona también en ventanas partidas.
class SolSheetLayout extends StatelessWidget {
  const SolSheetLayout({
    super.key,
    required this.background,
    required this.sheet,
    this.maxSheetFactor = 0.6,
  });

  final Widget background;

  /// Normalmente un [SolBottomSheetPanel].
  final Widget sheet;
  final double maxSheetFactor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: background),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * maxSheetFactor,
            ),
            child: sheet,
          ),
        ],
      ),
    );
  }
}

/// Hoja fija en pantalla (no modal), como la lista de prestadores de M06-01.
///
/// Va pegada a la barra inferior; úsala dentro de [SolSheetLayout]. Toma
/// solo el alto de su contenido, hasta [maxHeightFactor] del alto de
/// pantalla; si no alcanza, el contenido hace scroll dentro de la hoja.
class SolBottomSheetPanel extends StatelessWidget {
  const SolBottomSheetPanel({
    super.key,
    required this.child,
    this.maxHeightFactor = 0.6,
  });

  final Widget child;

  /// Fracción máxima del alto de pantalla que puede ocupar la hoja.
  final double maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    final sol = context.solColors;
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;
    final panel = DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SolRadius.card),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SolSpacing.lg,
          SolSpacing.md,
          SolSpacing.lg,
          SolSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: sol.sheetHandle,
                  borderRadius: SolRadius.fullAll,
                ),
              ),
            ),
            const SizedBox(height: SolSpacing.md),
            // Si el alto no alcanza (texto grande, horizontal) el contenido
            // hace scroll dentro de la hoja.
            Flexible(child: SingleChildScrollView(child: child)),
          ],
        ),
      ),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: panel,
    );
  }
}
