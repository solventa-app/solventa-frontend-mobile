import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../onboarding/presentation/onboarding_notifier.dart';
import '../acceso_notifier.dart';
import '../widgets/acceso_widgets.dart';

/// M02-03 · Acceso concedido (2005:499).
///
/// Transitoria: no tiene botones ni atrás. La barra se llena en
/// [duracionAccesoConcedidoProvider] (1,5 s) y la app va sola al Home. Con
/// «quitar animaciones» la barra aparece llena y solo se espera el tiempo.
/// La nota de prototipado de Figma («Auto-navega al inicio…») es anotación
/// del diseño y no se muestra.
class M0203AccesoConcedidoPage extends ConsumerStatefulWidget {
  const M0203AccesoConcedidoPage({super.key, this.autoAvanzar = true});

  /// Las pruebas y goldens lo apagan para no dejar temporizadores.
  final bool autoAvanzar;

  @override
  ConsumerState<M0203AccesoConcedidoPage> createState() =>
      _M0203AccesoConcedidoPageState();
}

class _M0203AccesoConcedidoPageState
    extends ConsumerState<M0203AccesoConcedidoPage> {
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    if (widget.autoAvanzar) {
      _temporizador = Timer(
        ref.read(duracionAccesoConcedidoProvider),
        () => ref.read(accesoProvider.notifier).terminarConcesion(),
      );
    }
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sol = context.solColors;
    final nombre = ref.watch(onboardingProvider).perfil?.nombre?.trim() ?? '';
    final saludo = nombre.isEmpty
        ? l10n.m0203SaludoSinNombre
        : l10n.m0203Saludo(nombre);
    final duracion = ref.watch(duracionAccesoConcedidoProvider);
    final reducir = SolMotion.reduced(context) || !widget.autoAvanzar;

    return PopScope(
      canPop: false,
      child: AccesoMarco(
        centrar: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 384),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: sol.softShadow,
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SolSpacing.xxxl,
                SolSpacing.xxxl,
                SolSpacing.xxxl,
                SolSpacing.xxxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícono de 80 dp con halo de 10 dp (Figma 2005:517).
                  ExcludeSemantics(
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sol.successContainer.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: AccesoIconoCirculo(
                        icono: SolIcons.success,
                        fondo: sol.successContainer,
                        color: sol.success,
                        diametro: 80,
                        relleno: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: SolSpacing.lg),
                  Semantics(
                    header: true,
                    liveRegion: true,
                    child: Text(
                      l10n.m0203Titulo,
                      textAlign: TextAlign.center,
                      style: context.solText.title.copyWith(
                        color: sol.success,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: SolSpacing.xs),
                  Text(
                    saludo,
                    textAlign: TextAlign.center,
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: SolSpacing.xxl),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Semantics(
                      label: l10n.m0203Progreso,
                      child: ClipRRect(
                        borderRadius: SolRadius.fullAll,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: reducir ? 1 : 0, end: 1),
                          duration: reducir ? Duration.zero : duracion,
                          builder: (context, valor, _) =>
                              LinearProgressIndicator(
                                value: valor,
                                minHeight: 6,
                                color: sol.success,
                                backgroundColor: colors.secondaryContainer,
                              ),
                        ),
                      ),
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
