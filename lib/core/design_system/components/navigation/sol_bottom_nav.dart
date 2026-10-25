import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Destino de la barra inferior.
@immutable
class SolNavDestination {
  const SolNavDestination({
    required this.label,
    required this.icon,
    IconData? selectedIcon,
  }) : selectedIcon = selectedIcon ?? icon;

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Barra de navegación inferior M3 de 80 dp (Figma 2018:76).
///
/// Ícono y etiqueta siempre visibles. Solo en pantallas de nivel superior.
class SolBottomNav extends StatelessWidget {
  const SolBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.destinations = defaultDestinations,
  });

  /// Inicio, Asistencia y Cerrar sesión, como en el Figma.
  static const List<SolNavDestination> defaultDestinations = [
    SolNavDestination(label: 'Inicio', icon: SolIcons.home),
    SolNavDestination(
      label: 'Asistencia',
      icon: SolIcons.assistance,
      selectedIcon: SolIcons.assistanceActive,
    ),
    SolNavDestination(label: 'Cerrar sesión', icon: SolIcons.logout),
  ];

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<SolNavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.outline)),
        ),
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: SolSizes.bottomNavHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SolSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    Expanded(
                      child: _NavItem(
                        destination: destinations[i],
                        selected: i == selectedIndex,
                        index: i,
                        count: destinations.length,
                        onTap: () => onDestinationSelected(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.index,
    required this.count,
    required this.onTap,
  });

  final SolNavDestination destination;
  final bool selected;
  final int index;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final color = selected ? colors.primary : colors.onSurfaceVariant;
    final labelStyle = context.solText.labelStrong.copyWith(
      color: color,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
    );
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      hint: 'Pestaña ${index + 1} de $count',
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: SolSizes.minTouchTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: SolSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: SolMotion.of(context, SolMotion.short),
                  width: SolSizes.navIndicatorWidth,
                  height: SolSizes.navIndicatorHeight,
                  decoration: BoxDecoration(
                    color: selected ? sol.navIndicator : Colors.transparent,
                    borderRadius: SolRadius.fullAll,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    selected ? destination.selectedIcon : destination.icon,
                    size: SolSizes.icon,
                    fill: selected ? 1 : 0,
                    color: color,
                  ),
                ),
                const SizedBox(height: SolSpacing.xxs),
                Text(
                  destination.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: labelStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
