import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/solventa_ui.dart';
import '../../../core/l10n/l10n.dart';

/// Hoja inferior (`SolBottomSheet`) para elegir idioma (`ES` / `EN`) y
/// cualquiera de las 7 monedas soportadas (`COP`, `MXN`, `BRL`, `CLP`, `PEN`,
/// `USD`, `EUR`).
class SolPreferenciasSheet extends ConsumerWidget {
  const SolPreferenciasSheet({super.key});

  static Future<void> show(BuildContext context) {
    return SolBottomSheet.show<void>(
      context,
      builder: (_) => const SolPreferenciasSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final locale = ref.watch(localeProvider);
    final moneda = ref.watch(monedaProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.preferenciasModalTitulo,
              style: context.solText.title.copyWith(color: colors.onSurface),
            ),
          ),
          const SizedBox(height: SolSpacing.xxs),
          Text(
            l10n.preferenciasModalSubtitulo,
            style: context.solText.note.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          Text(
            l10n.preferenciasIdiomaLabel,
            style: context.solText.labelStrong.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: SolSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _BotonIdioma(
                  etiqueta: l10n.preferenciasIdiomaEs,
                  seleccionado: locale.languageCode == 'es',
                  onTap: () =>
                      ref.read(localeProvider.notifier).cambiar(AppLocales.es),
                ),
              ),
              const SizedBox(width: SolSpacing.sm),
              Expanded(
                child: _BotonIdioma(
                  etiqueta: l10n.preferenciasIdiomaEn,
                  seleccionado: locale.languageCode == 'en',
                  onTap: () =>
                      ref.read(localeProvider.notifier).cambiar(AppLocales.en),
                ),
              ),
            ],
          ),
          const SizedBox(height: SolSpacing.lg),
          Text(
            l10n.preferenciasMonedaLabel,
            style: context.solText.labelStrong.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: SolSpacing.xs),
          for (final codigo in AppMonedas.supported) ...[
            _FilaMoneda(
              codigo: codigo,
              nombre: l10n.nombreMoneda(codigo),
              seleccionada: moneda == codigo,
              onTap: () => ref.read(monedaProvider.notifier).cambiar(codigo),
            ),
          ],
          const SizedBox(height: SolSpacing.lg),
          SolButton.primary(
            label: l10n.preferenciasListo,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _BotonIdioma extends StatelessWidget {
  const _BotonIdioma({
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
  });

  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: SolRadius.fieldAll,
      child: Container(
        constraints: const BoxConstraints(minHeight: SolSizes.minTouchTarget),
        padding: const EdgeInsets.symmetric(
          horizontal: SolSpacing.md,
          vertical: SolSpacing.xs,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: seleccionado ? colors.secondaryContainer : colors.surface,
          borderRadius: SolRadius.fieldAll,
          border: Border.all(
            color: seleccionado ? colors.primary : colors.outline,
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: Text(
          etiqueta,
          textAlign: TextAlign.center,
          style: context.solText.labelStrong.copyWith(
            color: seleccionado ? colors.primary : colors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _FilaMoneda extends StatelessWidget {
  const _FilaMoneda({
    required this.codigo,
    required this.nombre,
    required this.seleccionada,
    required this.onTap,
  });

  final String codigo;
  final String nombre;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: SolRadius.fieldAll,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SolSpacing.sm,
            vertical: SolSpacing.xs,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: seleccionada
                      ? colors.primary
                      : colors.surfaceContainer,
                  borderRadius: SolRadius.fullAll,
                ),
                child: Text(
                  codigo,
                  style: context.solText.labelStrong.copyWith(
                    color: seleccionada ? colors.onPrimary : colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: SolSpacing.sm),
              Expanded(
                child: Text(
                  nombre,
                  style: context.solText.body.copyWith(
                    fontWeight: seleccionada
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: colors.onSurface,
                  ),
                ),
              ),
              if (seleccionada)
                Icon(SolIcons.check, size: 20, color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
