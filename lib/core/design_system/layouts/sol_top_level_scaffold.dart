import 'package:flutter/material.dart';

import '../components/navigation/sol_bottom_nav.dart';
import '../components/navigation/sol_top_bar.dart';
import '../responsive/sol_adaptive_body.dart';

/// Pantalla de nivel superior (G-03, M06-01): barra «Inicio» y barra de
/// navegación inferior. Nada queda debajo de la barra inferior.
class SolTopLevelScaffold extends StatelessWidget {
  const SolTopLevelScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.destinations = SolBottomNav.defaultDestinations,
    this.onLocaleTap,
    this.onWordmarkLongPress,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<SolNavDestination> destinations;
  final VoidCallback? onLocaleTap;
  final VoidCallback? onWordmarkLongPress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SolTopBar.home(
        onLocaleTap: onLocaleTap,
        onWordmarkLongPress: onWordmarkLongPress,
      ),
      body: SolAdaptiveBody(child: body),
      bottomNavigationBar: SolBottomNav(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      ),
    );
  }
}
