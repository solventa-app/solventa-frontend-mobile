import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../providers.dart';

/// M01-08 · Activa tu biometría (2001:673). Sin huella o rostro activado la
/// app no puede usarse: «Ya lo activé» lo comprueba antes de seguir.
class M0108BiometriaPage extends ConsumerStatefulWidget {
  const M0108BiometriaPage({super.key});

  @override
  ConsumerState<M0108BiometriaPage> createState() => _M0108BiometriaPageState();
}

class _M0108BiometriaPageState extends ConsumerState<M0108BiometriaPage> {
  bool _comprobando = false;
  bool _noActivada = false;

  Future<void> _continuar() async {
    setState(() => _comprobando = true);
    final ok = await ref.read(biometriaServiceProvider).disponible();
    if (!mounted) return;
    setState(() {
      _comprobando = false;
      _noActivada = !ok;
    });
    if (ok) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sol = context.solColors;
    return SolFlowScaffold(
      title: l10n.m0108Titulo,
      anchorActions: false,
      body: Column(
        children: [
          ExcludeSemantics(
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                SolIcons.fingerprint,
                size: 56,
                color: colors.primary,
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.xxl),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Semantics(
              header: true,
              child: Text(
                l10n.m0108Encabezado,
                textAlign: TextAlign.center,
                style: context.solText.title.copyWith(color: colors.onSurface),
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 316),
            child: Text(
              l10n.m0108Explicacion,
              textAlign: TextAlign.center,
              style: context.solText.body.copyWith(
                color: colors.onSurfaceVariant,
                height: 22.75 / 14,
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.xxl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SolSpacing.lg,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: SolRadius.fullAll,
              boxShadow: [
                BoxShadow(
                  color: sol.softShadow,
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  SolIcons.shield,
                  size: 16,
                  opticalSize: 20,
                  fill: 1,
                  color: sol.success,
                ),
                const SizedBox(width: SolSpacing.xs),
                Flexible(
                  child: Text(
                    l10n.m0108Sello,
                    textAlign: TextAlign.center,
                    style: context.solText.note.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_noActivada) ...[
            const SizedBox(height: SolSpacing.lg),
            SolStatusBanner(
              status: SolStatus.warning,
              title: l10n.m0108NoActivada,
            ),
          ],
        ],
      ),
      actions: [
        SolButton.outlined(
          label: l10n.m0108Ajustes,
          icon: SolIcons.settings,
          onPressed: () => ref.read(biometriaServiceProvider).abrirAjustes(),
        ),
        const SizedBox(height: SolSpacing.lg),
        SolButton.primary(
          label: l10n.m0108Continuar,
          loading: _comprobando,
          onPressed: _continuar,
        ),
        const SizedBox(height: SolSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SolSpacing.sm),
          child: SolInlineNote(
            text: l10n.m0108Requisito,
            center: true,
            color: sol.warning,
          ),
        ),
      ],
    );
  }
}
