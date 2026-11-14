import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Hoja arrastrable encima del mapa con tres alturas (HU-M06, M9): mínima
/// (solo el título), inicial (título y los destacados) y expandida (~85 %).
///
/// El contenido va en [builder], que recibe el [ScrollController] de la hoja:
/// debe usarlo en su lista para que arrastrar y desplazar sean un solo gesto.
/// El tirador tiene las acciones de TalkBack [expandLabel] y [collapseLabel].
class SolDraggableSheet extends StatefulWidget {
  const SolDraggableSheet({
    super.key,
    required this.builder,
    required this.minFraction,
    required this.initialFraction,
    required this.expandLabel,
    required this.collapseLabel,
    this.maxFraction = 0.85,
    this.controller,
  });

  final Widget Function(BuildContext context, ScrollController scroll) builder;
  final double minFraction;
  final double initialFraction;
  final double maxFraction;
  final String expandLabel;
  final String collapseLabel;
  final DraggableScrollableController? controller;

  @override
  State<SolDraggableSheet> createState() => _SolDraggableSheetState();
}

class _SolDraggableSheetState extends State<SolDraggableSheet> {
  late final DraggableScrollableController _controller =
      widget.controller ?? DraggableScrollableController();

  double get _min => widget.minFraction.clamp(0.05, widget.maxFraction);
  double get _initial => widget.initialFraction.clamp(_min, widget.maxFraction);

  void _ir(double fraccion) {
    if (!_controller.isAttached) return;
    final duracion = SolMotion.of(context, SolMotion.medium);
    if (duracion == Duration.zero) {
      _controller.jumpTo(fraccion);
    } else {
      _controller.animateTo(
        fraccion,
        duration: duracion,
        curve: SolMotion.standard,
      );
    }
  }

  void _expandir() => _ir(
    _controller.isAttached && _controller.size < _initial - 0.01
        ? _initial
        : widget.maxFraction,
  );

  void _contraer() => _ir(
    _controller.isAttached && _controller.size > _initial + 0.01
        ? _initial
        : _min,
  );

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DraggableScrollableSheet(
      controller: _controller,
      minChildSize: _min,
      initialChildSize: _initial,
      maxChildSize: widget.maxFraction,
      snap: true,
      snapSizes: [_initial],
      builder: (context, scroll) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: SolRadius.sheetTop,
          boxShadow: [
            BoxShadow(color: context.solColors.softShadow, blurRadius: 12),
          ],
        ),
        child: Column(
          children: [
            Semantics(
              customSemanticsActions: {
                CustomSemanticsAction(label: widget.expandLabel): _expandir,
                CustomSemanticsAction(label: widget.collapseLabel): _contraer,
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _expandir,
                child: SizedBox(
                  height: 24,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.solColors.sheetHandle,
                        borderRadius: SolRadius.fullAll,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SolSpacing.screen,
                ),
                child: widget.builder(context, scroll),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
