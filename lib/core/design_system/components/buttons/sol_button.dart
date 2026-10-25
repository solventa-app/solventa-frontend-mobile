import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Variantes del Botón de la librería (Figma 2018:16).
enum SolButtonVariant {
  /// Acción principal. Solo una por pantalla.
  primary,

  /// Acción secundaria (fondo #EEEDF3).
  tonal,

  /// Acción destructiva; siempre tras una confirmación.
  destructive,

  /// Secundaria delineada («Repetir» en M01-03).
  outlined,

  /// Acción alterna de baja jerarquía, sin fondo.
  text,
}

/// Botón M3 de 48 dp, píldora completa, Inter 16/600.
///
/// Deshabilitado = `onPressed: null` (aún no se cumple la condición).
/// Con [loading] muestra un indicador y anuncia «cargando».
class SolButton extends StatelessWidget {
  const SolButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SolButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expand = true,
  });

  const SolButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  }) : variant = SolButtonVariant.primary;

  const SolButton.tonal({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  }) : variant = SolButtonVariant.tonal;

  const SolButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  }) : variant = SolButtonVariant.destructive;

  const SolButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  }) : variant = SolButtonVariant.outlined;

  const SolButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = false,
  }) : variant = SolButtonVariant.text;

  final String label;
  final VoidCallback? onPressed;
  final SolButtonVariant variant;
  final IconData? icon;
  final bool loading;

  /// Ocupa todo el ancho disponible (por defecto en las variantes con fondo).
  final bool expand;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final (Color bg, Color fg) = switch (variant) {
      SolButtonVariant.primary => (colors.primary, colors.onPrimary),
      SolButtonVariant.tonal => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      SolButtonVariant.destructive => (colors.error, colors.onError),
      SolButtonVariant.outlined => (colors.surface, colors.primary),
      SolButtonVariant.text => (Colors.transparent, colors.secondary),
    };
    final isText = variant == SolButtonVariant.text;
    // El cargando conserva los colores de la variante (no es deshabilitado).
    final disabled = onPressed == null;
    final background = disabled && !isText ? sol.disabledContainer : bg;
    final foreground = disabled ? sol.disabledContent : fg;

    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(SolSizes.minTouchTarget, SolSizes.buttonHeight),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: SolSpacing.xxl),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: SolRadius.fullAll,
          side: variant == SolButtonVariant.outlined && !disabled
              ? BorderSide(color: colors.primary)
              : BorderSide.none,
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      overlayColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.pressed)
            ? foreground.withValues(alpha: 0.12)
            : states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.hovered)
            ? foreground.withValues(alpha: 0.08)
            : null,
      ),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: WidgetStatePropertyAll(
        variant == SolButtonVariant.outlined
            ? sol.softShadow
            : Colors.transparent,
      ),
      textStyle: WidgetStatePropertyAll(context.solText.button),
      tapTargetSize: MaterialTapTargetSize.padded,
      animationDuration: SolMotion.of(context, kThemeChangeDuration),
    );

    final content = _ButtonContent(
      label: label,
      icon: icon,
      loading: loading,
      color: foreground,
    );

    final button = TextButton(
      onPressed: _enabled ? onPressed : null,
      style: style,
      child: content,
    );

    return Semantics(
      label: loading ? '$label, cargando' : null,
      excludeSemantics: loading,
      button: loading ? true : null,
      enabled: loading ? false : null,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.loading,
    required this.color,
  });

  final String label;
  final IconData? icon;
  final bool loading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: TextAlign.center,
      style: context.solText.button.copyWith(color: color),
    );
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: color),
          const SizedBox(width: SolSpacing.xs),
        ],
        Flexible(child: text),
      ],
    );
    if (!loading) return row;
    // Se conserva el ancho del texto para que el botón no salte.
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0, child: row),
        SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: color,
            backgroundColor: Colors.transparent,
            value: SolMotion.reduced(context) ? 0.75 : null,
          ),
        ),
      ],
    );
  }
}
