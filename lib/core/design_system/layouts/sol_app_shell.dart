import 'package:flutter/material.dart';

import '../components/navigation/sol_bottom_nav.dart';
import 'sol_top_level_scaffold.dart';

/// Navegación de nivel superior con la barra inferior.
///
/// Destinos: Inicio (0), Asistencia (1), Mis asistencias (2, HU-M06 4.1) y
/// Cerrar sesión (3). «Cerrar sesión» no cambia de pestaña: llama a
/// [onLogout]. El atrás del sistema en otra pestaña vuelve a Inicio.
class SolAppShell extends StatefulWidget {
  const SolAppShell({
    super.key,
    required this.home,
    required this.assistance,
    required this.onLogout,
    this.misAsistencias = const SizedBox.shrink(),
    this.destinations = SolBottomNav.defaultDestinations,
    this.initialIndex = 0,
    this.onLocaleTap,
    this.onWordmarkLongPress,
    this.pestana,
  });

  final Widget home;
  final Widget assistance;
  final Widget misAsistencias;

  /// Textos traducidos y badge de «Mis asistencias».
  final List<SolNavDestination> destinations;
  final VoidCallback onLogout;
  final int initialIndex;
  final VoidCallback? onLocaleTap;
  final VoidCallback? onWordmarkLongPress;

  /// Control opcional de la pestaña activa desde fuera (p. ej. volver a
  /// Asistencia al terminar un recorrido). Se mantiene al día con los toques.
  final ValueNotifier<int>? pestana;

  static const int homeIndex = 0;
  static const int assistanceIndex = 1;
  static const int misAsistenciasIndex = 2;
  static const int logoutIndex = 3;

  @override
  State<SolAppShell> createState() => _SolAppShellState();
}

class _SolAppShellState extends State<SolAppShell> {
  late int _index = widget.initialIndex;

  /// Pestañas ya abiertas. Una pestaña se construye la primera vez que se
  /// visita (Asistencia pide el permiso de ubicación al construirse) y
  /// después conserva su estado en el [IndexedStack].
  late final Set<int> _visitadas = {widget.initialIndex};

  @override
  void initState() {
    super.initState();
    widget.pestana?.addListener(_desdeFuera);
  }

  @override
  void didUpdateWidget(SolAppShell old) {
    super.didUpdateWidget(old);
    if (old.pestana != widget.pestana) {
      old.pestana?.removeListener(_desdeFuera);
      widget.pestana?.addListener(_desdeFuera);
    }
  }

  @override
  void dispose() {
    widget.pestana?.removeListener(_desdeFuera);
    super.dispose();
  }

  void _desdeFuera() {
    final i = widget.pestana!.value;
    if (i != _index) _select(i);
  }

  void _select(int i) {
    if (i == SolAppShell.logoutIndex) {
      widget.onLogout();
      return;
    }
    setState(() {
      _index = i;
      _visitadas.add(i);
    });
    widget.pestana?.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _index == SolAppShell.homeIndex,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _select(SolAppShell.homeIndex);
      },
      child: SolTopLevelScaffold(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: widget.destinations,
        onLocaleTap: widget.onLocaleTap,
        onWordmarkLongPress: widget.onWordmarkLongPress,
        body: IndexedStack(
          index: _index,
          children: [
            for (final (i, tab) in [
              widget.home,
              widget.assistance,
              widget.misAsistencias,
            ].indexed)
              _visitadas.contains(i) ? tab : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
