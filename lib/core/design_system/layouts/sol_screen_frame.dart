import 'package:flutter/material.dart';

import '../components/feedback/sol_connection_banner.dart';
import '../responsive/sol_adaptive_body.dart';
import '../tokens/sol_sizes.dart';
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
    this.fillBody = false,
    this.padding = defaultPadding,
    this.backgroundColor,
    this.banner,
  }) : assert(!(centerBody && fillBody), 'centerBody y fillBody no van juntos');

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

  /// El cuerpo ocupa todo el alto libre (al menos), así su columna puede usar
  /// `Expanded`: p. ej. un encabezado arriba y la carga en el centro de lo que
  /// queda (Mi perfil). Si no cabe, se desplaza.
  final bool fillBody;
  final EdgeInsets padding;

  /// Fondo de la pantalla; por defecto el del tema (gris #F5F5F5).
  final Color? backgroundColor;

  /// Franja bajo la barra superior (estado de la red). Empuja el contenido.
  final Widget? banner;

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

    final Widget scroll = fillBody
        // IntrinsicHeight mide el cuerpo con su ancho real (hasta 600 dp) y lo
        // estira al alto libre; así el Expanded de adentro tiene un alto fijo.
        ? LayoutBuilder(
            builder: (context, limites) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: limites.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: padding,
                    child: Column(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: SolSizes.maxContentWidth,
                            ),
                            child: body,
                          ),
                        ),
                        if (!anchorActions && actionColumn != null) ...[
                          const SizedBox(height: SolSpacing.xxxl),
                          SolAdaptiveBody(child: actionColumn),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : centerBody
        // No se usa SliverFillRemaining: mide con el ancho de la pantalla y no
        // con los 600 dp de SolAdaptiveBody, y en una tablet en horizontal con
        // poco alto el texto ocupa más líneas de las medidas y se desborda.
        ? LayoutBuilder(
            builder: (context, limites) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: limites.maxHeight),
                // El padding va dentro para que el centrado sea exacto.
                child: Padding(
                  padding: padding,
                  child: SolAdaptiveBody(
                    alignment: Alignment.center,
                    child: content,
                  ),
                ),
              ),
            ),
          )
        : CustomScrollView(
            slivers: [
              SliverPadding(
                padding: padding,
                sliver: SliverToBoxAdapter(
                  child: SolAdaptiveBody(child: content),
                ),
              ),
            ],
          );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: topBar,
      body: Column(
        children: [
          SolBannerSlot(
            banner: banner,
            compact: SolBannerSlot.keyboardOpen(context),
          ),
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
