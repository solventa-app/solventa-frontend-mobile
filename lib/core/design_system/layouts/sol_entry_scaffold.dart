import 'package:flutter/material.dart';

import '../components/navigation/sol_top_bar.dart';
import 'sol_screen_frame.dart';

/// Pantalla de entrada (bienvenida, prompt biométrico): sin flecha de
/// volver. Con [title] usa la barra con título; sin él, la barra «Inicio».
class SolEntryScaffold extends StatelessWidget {
  const SolEntryScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions = const [],
    this.anchorActions = true,
    this.centerBody = false,
    this.onLocaleTap,
  });

  final String? title;
  final Widget body;
  final List<Widget> actions;
  final bool anchorActions;
  final bool centerBody;
  final VoidCallback? onLocaleTap;

  @override
  Widget build(BuildContext context) {
    return SolScreenFrame(
      topBar: title == null
          ? SolTopBar.home(onLocaleTap: onLocaleTap)
          : SolTopBar.flow(
              title: title!,
              showBack: false,
              showProfile: false,
              onLocaleTap: onLocaleTap,
            ),
      body: body,
      actions: actions,
      anchorActions: anchorActions,
      centerBody: centerBody,
    );
  }
}
