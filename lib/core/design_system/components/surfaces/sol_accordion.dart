import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Acordeón con título y contador (HU-M06, «Mis asistencias» 4.1): «En camino
/// (3)» abierto y «Ya llegaron (1)» cerrado. El encabezado es un botón con su
/// estado expandido para TalkBack.
class SolAccordion extends StatefulWidget {
  const SolAccordion({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = true,
  });

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<SolAccordion> createState() => _SolAccordionState();
}

class _SolAccordionState extends State<SolAccordion> {
  late bool _abierto = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: SolRadius.cardAll,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _abierto,
            child: InkWell(
              onTap: () => setState(() => _abierto = !_abierto),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SolSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: context.solText.title.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _abierto ? 0.5 : 0,
                        duration: SolMotion.of(context, SolMotion.short),
                        child: ExcludeSemantics(
                          child: Icon(
                            SolIcons.expandMore,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: SolMotion.of(context, SolMotion.medium),
            curve: SolMotion.standard,
            alignment: Alignment.topCenter,
            child: _abierto
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.children,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
