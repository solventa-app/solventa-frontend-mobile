import 'package:flutter/material.dart';

import '../components/navigation/sol_bottom_nav.dart';
import 'sol_top_level_scaffold.dart';

/// Navegación de nivel superior con la barra inferior.
///
/// Destinos: Inicio (0), Asistencia (1) y Cerrar sesión (2). «Cerrar
/// sesión» no cambia de pestaña: llama a [onLogout]. El atrás del sistema
/// en Asistencia vuelve a Inicio.
class SolAppShell extends StatefulWidget {
  const SolAppShell({
    super.key,
    required this.home,
    required this.assistance,
    required this.onLogout,
    this.initialIndex = 0,
    this.onLocaleTap,
    this.onWordmarkLongPress,
  });

  final Widget home;
  final Widget assistance;
  final VoidCallback onLogout;
  final int initialIndex;
  final VoidCallback? onLocaleTap;
  final VoidCallback? onWordmarkLongPress;

  static const int homeIndex = 0;
  static const int assistanceIndex = 1;
  static const int logoutIndex = 2;

  @override
  State<SolAppShell> createState() => _SolAppShellState();
}

class _SolAppShellState extends State<SolAppShell> {
  late int _index = widget.initialIndex;

  void _select(int i) {
    if (i == SolAppShell.logoutIndex) {
      widget.onLogout();
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == SolAppShell.homeIndex,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _index = SolAppShell.homeIndex);
      },
      child: SolTopLevelScaffold(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: SolBottomNav.defaultDestinations,
        onLocaleTap: widget.onLocaleTap,
        onWordmarkLongPress: widget.onWordmarkLongPress,
        body: IndexedStack(
          index: _index,
          children: [widget.home, widget.assistance],
        ),
      ),
    );
  }
}
