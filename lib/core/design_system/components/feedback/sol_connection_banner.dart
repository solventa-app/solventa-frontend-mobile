import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../responsive/sol_adaptive_body.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_sizes.dart';
import '../../tokens/sol_spacing.dart';

/// Qué cuenta la franja de conexión.
enum SolConnectionTone {
  /// Sin salida a internet.
  offline,

  /// Hay conexión, pero responde lento.
  slow,

  /// Volvió la conexión y hay algo enviándose.
  syncing,

  /// Lo pendiente ya se envió, o la conexión volvió.
  done,
}

/// Franja de estado de la red: va pegada bajo la barra superior, a todo el
/// ancho, y empuja el contenido (nunca lo tapa).
///
/// Siempre lleva ícono y texto, nunca solo color. Se anuncia a TalkBack al
/// aparecer. Con el teclado abierto se reduce a una sola línea para no
/// quitarle espacio al campo (lo decide [SolBannerScope]).
class SolConnectionBanner extends StatelessWidget {
  const SolConnectionBanner({
    super.key,
    required this.tone,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'La acción necesita texto y destino.',
       );

  final SolConnectionTone tone;
  final String title;
  final String? message;

  /// Acción corta a la derecha («Ver»).
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final (Color fondo, Color acento, IconData icono) = switch (tone) {
      SolConnectionTone.offline => (
        sol.warningContainer,
        sol.warning,
        SolIcons.offline,
      ),
      SolConnectionTone.slow => (
        sol.warningContainer,
        sol.warning,
        SolIcons.slowConnection,
      ),
      SolConnectionTone.syncing => (
        colors.primaryContainer,
        colors.primary,
        SolIcons.syncing,
      ),
      SolConnectionTone.done => (
        sol.successContainer,
        sol.success,
        SolIcons.synced,
      ),
    };
    final compacto = SolBannerScope.compactOf(context);
    final mensaje = compacto ? null : message;
    final base = context.solText.linkSmall;

    return Semantics(
      container: true,
      liveRegion: true,
      child: ColoredBox(
        color: fondo,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SolSpacing.screen,
              vertical: compacto ? SolSpacing.xs : SolSpacing.sm,
            ),
            child: SolAdaptiveBody(
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      icono,
                      size: 20,
                      opticalSize: 20,
                      color: acento,
                    ),
                  ),
                  const SizedBox(width: SolSpacing.md),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: compacto ? 1 : null,
                          overflow: compacto ? TextOverflow.ellipsis : null,
                          style: base.copyWith(
                            fontWeight: FontWeight.w600,
                            color: acento,
                          ),
                        ),
                        if (mensaje != null)
                          Text(
                            mensaje,
                            style: base.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colors.onSurface,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (actionLabel != null && !compacto) ...[
                    const SizedBox(width: SolSpacing.sm),
                    Semantics(
                      button: true,
                      label: actionLabel,
                      onTap: onAction,
                      excludeSemantics: true,
                      child: InkWell(
                        onTap: onAction,
                        customBorder: const StadiumBorder(),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: SolSizes.minTouchTarget,
                            minWidth: SolSizes.minTouchTarget,
                          ),
                          child: Center(
                            widthFactor: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SolSpacing.sm,
                              ),
                              child: Text(
                                actionLabel!,
                                style: base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lo que los layouts le cuentan a la franja que alojan: si debe ir en una
/// línea porque el teclado está abierto.
class SolBannerScope extends InheritedWidget {
  const SolBannerScope({
    super.key,
    required this.compact,
    required super.child,
  });

  final bool compact;

  static bool compactOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SolBannerScope>()?.compact ??
      false;

  @override
  bool updateShouldNotify(SolBannerScope oldWidget) =>
      compact != oldWidget.compact;
}

/// Hueco de la franja en un layout: la anima al aparecer y desaparecer, y le
/// avisa si el teclado está abierto. Uso interno de los layouts.
class SolBannerSlot extends StatelessWidget {
  const SolBannerSlot({super.key, required this.banner, required this.compact});

  final Widget? banner;

  /// El layout lo calcula con [keyboardOpen] por encima de su Scaffold:
  /// dentro del cuerpo el teclado ya no aparece en MediaQuery.
  final bool compact;

  static bool keyboardOpen(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom > 0;

  @override
  Widget build(BuildContext context) {
    final banner = this.banner;
    if (banner == null) return const SizedBox.shrink();
    return SolBannerScope(
      compact: compact,
      child: AnimatedSize(
        duration: SolMotion.of(context, SolMotion.medium),
        curve: SolMotion.standard,
        alignment: Alignment.topCenter,
        child: SizedBox(width: double.infinity, child: banner),
      ),
    );
  }
}

/// Calidad de la conexión para [SolNetworkChip].
enum SolNetworkQuality { good, fair, poor, offline }

/// Por dónde sale la conexión.
enum SolNetworkLink { wifi, mobile, other }

/// Píldora «Wi-Fi · buena», «Datos · mala», «Sin conexión»: ícono de la
/// interfaz con sus barras y texto. El color acompaña, no informa solo.
class SolNetworkChip extends StatelessWidget {
  const SolNetworkChip({
    super.key,
    required this.quality,
    required this.label,
    this.link = SolNetworkLink.other,
  });

  final SolNetworkQuality quality;
  final SolNetworkLink link;
  final String label;

  IconData get _icono => switch ((link, quality)) {
    (_, SolNetworkQuality.offline) => SolIcons.offline,
    (SolNetworkLink.wifi, SolNetworkQuality.good) => SolIcons.wifi,
    (SolNetworkLink.wifi, SolNetworkQuality.fair) => SolIcons.wifiFair,
    (SolNetworkLink.wifi, SolNetworkQuality.poor) => SolIcons.wifiPoor,
    (_, SolNetworkQuality.good) => SolIcons.mobileData,
    (_, SolNetworkQuality.fair) => SolIcons.mobileDataFair,
    (_, SolNetworkQuality.poor) => SolIcons.mobileDataPoor,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final neutra = quality == SolNetworkQuality.fair;
    final (Color fondo, Color frente) = switch (quality) {
      SolNetworkQuality.good => (sol.successContainer, sol.success),
      // Neutra: blanca con borde, para verse sobre tarjeta y sobre el fondo.
      SolNetworkQuality.fair => (colors.surface, colors.onSurfaceVariant),
      SolNetworkQuality.poor ||
      SolNetworkQuality.offline => (sol.warningContainer, sol.warning),
    };
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SolSpacing.md,
          vertical: SolSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: SolRadius.fullAll,
          border: Border.all(color: neutra ? colors.outline : fondo),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icono, size: 14, opticalSize: 20, weight: 700, color: frente),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: context.solText.labelStrong.copyWith(color: frente),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
