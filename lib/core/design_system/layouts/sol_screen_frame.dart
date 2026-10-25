import 'package:flutter/material.dart';

import '../responsive/sol_adaptive_body.dart';
import '../tokens/sol_spacing.dart';

/// Marco común de pantallas con barra superior: contenido con scroll y
/// acciones opcionales ancladas abajo o al final del contenido.
///
/// Uso interno de los layouts; las features usan SolFlowScaffold,
/// SolEntryScaffold, SolTransitionalScreen o SolResultScreen.
class SolScreenFrame extends StatelessWidget {
  const SolScreenFrame({
    super.key,
    required this.topBar,
    required this.body,
    this.actions = const [],
    this.anchorActions = true,
    this.centerBody = false,
    this.padding = defaultPadding,
    this.backgroundColor,
  });

  /// Margen lateral de 16 dp y 24 dp arriba y abajo (Figma).
  static const EdgeInsets defaultPadding = EdgeInsets.fromLTRB(
    SolSpacing.screen,
    SolSpacing.xxl,
    SolSpacing.screen,
    SolSpacing.xxl,
  );

  final PreferredSizeWidget topBar;
  final Widget body;
  final List<Widget> actions;
  final bool anchorActions;
  final bool centerBody;
  final EdgeInsets padding;

  /// Fondo de la pantalla; por defecto el del tema (gris #F5F5F5).
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final actionColumn = actions.isEmpty
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(height: SolSpacing.sm),
                actions[i],
              ],
            ],
          );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        body,
        if (!anchorActions && actionColumn != null) ...[
          const SizedBox(height: SolSpacing.xxxl),
          actionColumn,
        ],
      ],
    );

    final scroll = CustomScrollView(
      slivers: [
        if (centerBody)
          // El padding va dentro para que el centrado sea exacto.
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: padding,
              child: SolAdaptiveBody(
                alignment: Alignment.center,
                child: content,
              ),
            ),
          )
        else
          SliverPadding(
            padding: padding,
            sliver: SliverToBoxAdapter(child: SolAdaptiveBody(child: content)),
          ),
      ],
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: topBar,
      body: Column(
        children: [
          Expanded(child: scroll),
          if (anchorActions && actionColumn != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SolSpacing.screen,
                  0,
                  SolSpacing.screen,
                  SolSpacing.xxl,
                ),
                child: SolAdaptiveBody(child: actionColumn),
              ),
            ),
        ],
      ),
    );
  }
}
