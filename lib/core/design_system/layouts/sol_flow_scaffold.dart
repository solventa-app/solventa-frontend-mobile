import 'package:flutter/material.dart';

import '../components/navigation/sol_top_bar.dart';
import 'sol_screen_frame.dart';

/// Pantalla intermedia: barra «Con volver», contenido con scroll y un solo
/// botón primario. El atrás del sistema hace lo mismo que la flecha.
class SolFlowScaffold extends StatelessWidget {
  const SolFlowScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.anchorActions = true,
    this.centerBody = false,
    this.fillBody = false,
    this.onBack,
    this.showBack = true,
    this.showProfile = true,
    this.onLocaleTap,
    this.onProfileTap,
    this.onHomeTap,
    this.padding,
    this.banner,
  });

  final String title;
  final Widget body;

  /// Acciones de la pantalla: un SolButton.primary y, si hace falta, uno
  /// tonal o de texto. Nunca más de un primario.
  final List<Widget> actions;

  /// `true`: acciones ancladas abajo (M01-03, M01-07). `false`: al final del
  /// contenido (M01-02, M02-02, M06-02).
  final bool anchorActions;

  /// Contenido centrado a lo alto en el espacio libre, p. ej. mientras carga
  /// (`SolLoadingState.page`).
  final bool centerBody;

  /// El cuerpo ocupa todo el alto libre y puede usar `Expanded`: p. ej. el
  /// encabezado arriba y la carga centrada debajo (Mi perfil).
  final bool fillBody;

  /// Si se da, intercepta la flecha y el atrás del sistema (PopScope).
  final VoidCallback? onBack;
  final bool showBack;
  final bool showProfile;
  final VoidCallback? onLocaleTap;
  final VoidCallback? onProfileTap;

  /// Casita al Home en lugar del avatar (Mi perfil).
  final VoidCallback? onHomeTap;
  final EdgeInsets? padding;

  /// Franja bajo la barra superior (estado de la red).
  final Widget? banner;

  @override
  Widget build(BuildContext context) {
    final frame = SolScreenFrame(
      topBar: SolTopBar.flow(
        title: title,
        onBack: onBack,
        showBack: showBack && onBack != null,
        showProfile: showProfile,
        onLocaleTap: onLocaleTap,
        onProfileTap: onProfileTap,
        onHomeTap: onHomeTap,
      ),
      body: body,
      actions: actions,
      anchorActions: anchorActions,
      centerBody: centerBody,
      fillBody: fillBody,
      padding: padding ?? SolScreenFrame.defaultPadding,
      banner: banner,
    );
    if (onBack == null) return frame;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onBack!();
      },
      child: frame,
    );
  }
}
