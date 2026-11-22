import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/red/presentation/banner_conexion.dart';
import '../providers.dart';

/// Mi perfil · «Envío de reportes» (plan 4.5, boceto 3.8): cómo está la
/// conexión, el interruptor de solo Wi-Fi y el acceso a lo que falta por
/// enviar. Todo vive en el teléfono: funciona igual sin conexión.
class SeccionEnvioReportes extends ConsumerWidget {
  const SeccionEnvioReportes({super.key, required this.onVerPorEnviar});

  /// Abre «Mis siniestros», donde está la lista «Por enviar».
  final VoidCallback onVerPorEnviar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final soloWifi = ref.watch(
      preferenciasEnvioProvider.select((p) => p.soloWifi),
    );
    final porEnviar = ref.watch(reportesPorEnviarProvider).length;
    final titulo = context.solText.titleSmall.copyWith(color: colors.onSurface);
    final nota = context.solText.note.copyWith(color: colors.onSurfaceVariant);

    return SolCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(SolIcons.upload, size: 20, color: colors.primary),
              const SizedBox(width: SolSpacing.xs),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(l10n.perfilEnvioTitulo, style: titulo),
                ),
              ),
            ],
          ),
          const SizedBox(height: SolSpacing.sm),
          const SolDivider(),
          const SizedBox(height: SolSpacing.md),
          MergeSemantics(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: SolSpacing.sm,
              runSpacing: SolSpacing.xs,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.perfilEnvioConexion, style: titulo),
                    const SizedBox(height: SolSpacing.xxs),
                    Text(l10n.perfilEnvioConexionTexto, style: nota),
                  ],
                ),
                const ChipRed(),
              ],
            ),
          ),
          const SizedBox(height: SolSpacing.md),
          const SolDivider(),
          const SizedBox(height: SolSpacing.sm),
          MergeSemantics(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.perfilEnvioSoloWifi, style: titulo),
                      const SizedBox(height: SolSpacing.xxs),
                      Text(
                        soloWifi
                            ? l10n.perfilEnvioSoloWifiEncendido
                            : l10n.perfilEnvioSoloWifiApagado,
                        style: nota,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SolSpacing.sm),
                Switch(
                  key: const Key('perfil-solo-wifi'),
                  value: soloWifi,
                  onChanged: (v) => ref
                      .read(preferenciasEnvioProvider.notifier)
                      .fijarSoloWifi(soloWifi: v),
                ),
              ],
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
          const SolDivider(),
          MergeSemantics(
            child: InkWell(
              key: const Key('perfil-por-enviar'),
              onTap: onVerPorEnviar,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: SolSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.perfilEnvioPorEnviar, style: titulo),
                          const SizedBox(height: SolSpacing.xxs),
                          Text(
                            porEnviar == 0
                                ? l10n.perfilEnvioNinguno
                                : l10n.perfilEnvioGuardados(porEnviar),
                            style: nota,
                          ),
                        ],
                      ),
                    ),
                    if (porEnviar > 0) ...[
                      const SizedBox(width: SolSpacing.sm),
                      SolStatusBadge(
                        status: SolStatus.warning,
                        label: '$porEnviar',
                      ),
                    ],
                    const SizedBox(width: SolSpacing.xs),
                    ExcludeSemantics(
                      child: Icon(
                        SolIcons.chevronRight,
                        size: 20,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
