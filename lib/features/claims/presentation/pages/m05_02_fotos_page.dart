import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/network_providers.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_routes.dart';
import '../widgets/visor_camara_reporte.dart';

/// M05-02 · Fotos del daño con GPS (KAN-276). Cada foto lleva la ubicación
/// del teléfono en el momento de tomarla (CA-M05-02).
class M0502FotosPage extends ConsumerStatefulWidget {
  const M0502FotosPage({super.key});

  @override
  ConsumerState<M0502FotosPage> createState() => _M0502FotosPageState();
}

class _M0502FotosPageState extends ConsumerState<M0502FotosPage> {
  late final AppLifecycleListener _ciclo;
  bool _volviendoDeAjustes = false;

  @override
  void initState() {
    super.initState();
    _ciclo = AppLifecycleListener(
      onResume: () {
        if (_volviendoDeAjustes) {
          _volviendoDeAjustes = false;
          unawaited(ref.read(reporteProvider.notifier).prepararUbicacion());
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ref.read(reporteProvider).ubicacion == null) {
        unawaited(ref.read(reporteProvider.notifier).prepararUbicacion());
      }
    });
  }

  @override
  void dispose() {
    _ciclo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(reporteProvider);
    final notifier = ref.read(reporteProvider.notifier);
    final sol = context.solColors;
    // Primero la ubicación y después la cámara: Android no muestra dos
    // permisos a la vez y el segundo quedaría colgado.
    final ubicacionLista =
        estado.ubicacion != null || estado.ubicacionSinPermiso;

    return SolFlowScaffold(
      title: l10n.m0502Titulo,
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.m0502Instruccion, style: context.solText.body),
          const SizedBox(height: SolSpacing.md),
          VisorCamaraReporte(
            habilitada:
                ref.watch(camaraReporteHabilitadaProvider) && ubicacionLista,
            esPrueba: !ref.watch(camaraReporteHabilitadaProvider),
            permitirRespaldo: ref.watch(usarFakesProvider),
            puedeTomar: estado.puedeTomarMasFotos && ubicacionLista,
            onCapturada: notifier.agregarFoto,
            etiquetaTomar: l10n.m0502Tomar,
            etiquetaVisor: l10n.m0502Visor,
            textoSinCamara: l10n.m0502CamaraNoDisponible,
          ),
          const SizedBox(height: SolSpacing.md),
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.m0502Contador(estado.fotos.length),
              style: context.solText.titleSmall,
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
          _Miniaturas(
            fotos: estado.fotos,
            etiquetaQuitar: l10n.m0502Quitar,
            onQuitar: notifier.quitarFoto,
          ),
          const SizedBox(height: SolSpacing.md),
          if (estado.ubicacion != null)
            SolInlineNote(
              icon: SolIcons.location,
              text: l10n.m0502Ubicada,
              color: sol.success,
            )
          else if (estado.ubicacionSinPermiso) ...[
            SolInlineNote(
              icon: SolIcons.location,
              text: l10n.m0502SinUbicacion,
            ),
            SolButtonPair(
              primary: SolButton.tonal(
                label: l10n.m0502PermitirUbicacion,
                onPressed: () => unawaited(notifier.prepararUbicacion()),
              ),
              secondary: SolButton.text(
                label: l10n.m0502AbrirAjustes,
                onPressed: () {
                  _volviendoDeAjustes = true;
                  unawaited(notifier.abrirAjustesUbicacion());
                },
              ),
            ),
          ],
        ],
      ),
      actions: [
        SolButton.primary(
          label: l10n.m05Continuar,
          onPressed:
              estado.fotos.length >= ReglasReporte.minFotos &&
                  estado.ubicacion != null
              ? () => context.push(ReporteRoutes.relato)
              : null,
        ),
      ],
    );
  }
}

class _Miniaturas extends StatelessWidget {
  const _Miniaturas({
    required this.fotos,
    required this.etiquetaQuitar,
    required this.onQuitar,
  });

  final List<FotoSiniestro> fotos;
  final String Function(int numero) etiquetaQuitar;
  final ValueChanged<int> onQuitar;

  @override
  Widget build(BuildContext context) {
    if (fotos.isEmpty) return const SizedBox.shrink();
    final colors = context.colors;
    return Wrap(
      spacing: SolSpacing.sm,
      runSpacing: SolSpacing.sm,
      children: [
        for (final (i, f) in fotos.indexed)
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: SolRadius.fieldAll,
                  child: ExcludeSemantics(
                    child: Image.memory(
                      f.bytes,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (_, _, _) => ColoredBox(
                        color: colors.surfaceContainerHighest,
                        child: Icon(SolIcons.camera, color: colors.outline),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton.filledTonal(
                    tooltip: etiquetaQuitar(i + 1),
                    icon: const Icon(SolIcons.close, size: 18),
                    onPressed: () => onQuitar(i),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
