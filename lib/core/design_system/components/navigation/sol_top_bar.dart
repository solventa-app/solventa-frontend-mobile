import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';
import '../surfaces/sol_avatar.dart';
import 'sol_locale_chip.dart';

/// Tipos de la Barra superior (Figma 2018:35).
enum SolTopBarType {
  /// Pantallas intermedias: flecha + título + idioma/moneda + perfil.
  flow,

  /// Pantallas de nivel superior: wordmark + idioma/moneda, sin flecha.
  home,
}

/// Top app bar de 56 dp con divisor inferior de 1 dp.
class SolTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Barra «Con volver». Con `showBack: false` sirve a pantallas de entrada
  /// y transitorias (sin flecha).
  const SolTopBar.flow({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.showProfile = true,
    this.onProfileTap,
    this.localeLabel = 'ES · COP',
    this.onLocaleTap,
  }) : type = SolTopBarType.flow,
       onWordmarkLongPress = null;

  /// Barra «Inicio».
  const SolTopBar.home({
    super.key,
    this.localeLabel = 'ES · COP',
    this.onLocaleTap,
    this.onWordmarkLongPress,
  }) : type = SolTopBarType.home,
       title = 'Solventa',
       onBack = null,
       showBack = false,
       showProfile = false,
       onProfileTap = null;

  final SolTopBarType type;
  final String title;
  final VoidCallback? onBack;
  final bool showBack;
  final bool showProfile;
  final VoidCallback? onProfileTap;
  final String localeLabel;
  final VoidCallback? onLocaleTap;

  /// Solo para depuración (abrir la galería interna).
  final VoidCallback? onWordmarkLongPress;

  @override
  Size get preferredSize => const Size.fromHeight(SolSizes.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isHome = type == SolTopBarType.home;
    final hasBack = !isHome && showBack;

    final Widget leading = isHome
        ? Semantics(
            header: true,
            child: GestureDetector(
              onLongPress: onWordmarkLongPress,
              child: Text(
                title,
                maxLines: 1,
                style: context.solText.wordmark.copyWith(
                  color: colors.secondary,
                ),
              ),
            ),
          )
        : Row(
            children: [
              if (hasBack) ...[
                _BackButton(onBack: onBack),
                const SizedBox(width: SolSpacing.xxs),
              ],
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.solText.title.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          );

    // Padding según Figma: «Inicio» 16/16; «Con volver» 6/16 (la flecha
    // ocupa 48 dp, así que el borde izquierdo queda en 4). Con perfil, el
    // área táctil del avatar absorbe 8 dp del margen derecho.
    final padding = EdgeInsetsDirectional.only(
      start: isHome ? SolSpacing.lg : (hasBack ? SolSpacing.xs : SolSpacing.lg),
      end: !isHome && showProfile ? SolSpacing.sm : SolSpacing.lg,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Material(
        color: colors.surface,
        child: SafeArea(
          bottom: false,
          child: Container(
            height: SolSizes.topBarHeight,
            padding: padding,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outline)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: leading,
                  ),
                ),
                const SizedBox(width: SolSpacing.sm),
                SolLocaleChip(label: localeLabel, onTap: onLocaleTap),
                if (!isHome && showProfile)
                  SolAvatar(onTap: onProfileTap ?? () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onBack ?? () => Navigator.maybePop(context),
      tooltip: 'Volver',
      icon: const Icon(SolIcons.back),
      iconSize: SolSizes.icon,
      color: context.colors.onSurface,
      constraints: const BoxConstraints.tightFor(
        width: SolSizes.minTouchTarget,
        height: SolSizes.minTouchTarget,
      ),
      padding: EdgeInsets.zero,
    );
  }
}
