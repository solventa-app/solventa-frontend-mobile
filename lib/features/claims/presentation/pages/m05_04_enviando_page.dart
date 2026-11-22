import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/red/presentation/banner_conexion.dart';
import '../../data/cola_reportes.dart';
import '../../domain/entities/reporte_siniestro.dart';
import '../providers.dart';
import '../reporte_notifier.dart';
import '../reporte_routes.dart';

/// M05-04 · Enviando: sube las fotos y crea el caso; avanza sola al desenlace.
///
/// Con el reporte en la cola (HU-M05, sin conexión) muestra el avance por
/// bytes subidos, paso a paso, y deja «Seguir en segundo plano»: el envío
/// continúa aunque se salga de la pantalla.
class M0504EnviandoPage extends ConsumerStatefulWidget {
  const M0504EnviandoPage({super.key, this.yaEnCurso = false});

  /// Quien abrió la pantalla ya pidió el envío (pudo elegir con qué red): no
  /// se pide otra vez. Si terminó antes de montarla, pasa al resultado.
  final bool yaEnCurso;

  @override
  ConsumerState<M0504EnviandoPage> createState() => _M0504EnviandoPageState();
}

class _M0504EnviandoPageState extends ConsumerState<M0504EnviandoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!widget.yaEnCurso) {
        unawaited(ref.read(reporteProvider.notifier).enviar());
        return;
      }
      if (_termino(ref.read(reporteProvider).envio)) {
        context.pushReplacement(ReporteRoutes.resultado);
      }
    });
  }

  bool _termino(EnvioReporte? envio) =>
      envio is Enviado || envio is EnvioFallido || envio is EnvioGuardado;

  @override
  Widget build(BuildContext context) {
    ref.listen(reporteProvider.select((s) => s.envio), (_, envio) {
      if (_termino(envio)) context.pushReplacement(ReporteRoutes.resultado);
    });
    final l10n = context.l10n;
    final reporte = ref.watch(reporteProvider);
    final progreso = ref.watch(progresoColaProvider).value;
    if (progreso == null || progreso.enviando != reporte.idReporte) {
      return SolTransitionalScreen(
        banner: const BannerConexion(),
        title: l10n.m0504Titulo,
        message: l10n.m0504Mensaje,
      );
    }
    return PopScope(
      canPop: false,
      child: SolFlowScaffold(
        banner: const BannerConexion(),
        title: l10n.m0504Titulo,
        showBack: false,
        showProfile: false,
        body: _Avance(progreso: progreso, fotos: reporte.fotos),
        actions: [
          SolButton.outlined(
            label: l10n.m0504SegundoPlano,
            onPressed: () => context.go('/'),
          ),
        ],
      ),
    );
  }
}

class _Avance extends StatelessWidget {
  const _Avance({required this.progreso, required this.fotos});

  final ProgresoCola progreso;
  final List<FotoSiniestro> fotos;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final porcentaje = progreso.porcentajeReporte;
    final paso = progreso.radicando
        ? l10n.avisoReporteRadicando
        : l10n.avisoReporteFoto(
            progreso.foto.clamp(1, progreso.fotos),
            progreso.fotos,
          );
    final locale = Localizations.localeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: SolSpacing.lg),
        Center(
          child: SolProgressRing(
            value: progreso.fraccionReporte,
            label: l10n.m0504Porcentaje(porcentaje),
            semanticLabel: l10n.m0504AvanceSemantica(porcentaje, paso),
          ),
        ),
        const SizedBox(height: SolSpacing.xl),
        Text(
          l10n.m0504Avance(paso),
          textAlign: TextAlign.center,
          style: context.solText.body.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: SolSpacing.lg),
        SolCard.outlined(
          padding: const EdgeInsets.symmetric(
            horizontal: SolSpacing.lg,
            vertical: SolSpacing.xs,
          ),
          child: Column(
            children: [
              for (final (i, foto) in fotos.indexed) ...[
                _Paso(
                  titulo: l10n.m0504Foto(i + 1),
                  detalle: SolFormat.megabytesFor(foto.bytes.length, locale),
                  estado: progreso.radicando || i + 1 < progreso.foto
                      ? _EstadoPaso.listo
                      : i + 1 == progreso.foto
                      ? _EstadoPaso.enCurso
                      : _EstadoPaso.enEspera,
                ),
                const SolDivider(),
              ],
              _Paso(
                titulo: l10n.m0504Radicar,
                estado: progreso.radicando
                    ? _EstadoPaso.enCurso
                    : _EstadoPaso.enEspera,
              ),
            ],
          ),
        ),
        const SizedBox(height: SolSpacing.lg),
        const Center(child: ChipRed()),
      ],
    );
  }
}

enum _EstadoPaso { listo, enCurso, enEspera }

/// Un paso del envío: ícono, nombre y en qué va (nunca solo color).
class _Paso extends StatelessWidget {
  const _Paso({required this.titulo, required this.estado, this.detalle});

  final String titulo;
  final String? detalle;
  final _EstadoPaso estado;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (icono, color, texto) = switch (estado) {
      _EstadoPaso.listo => (
        SolIcons.success,
        context.solColors.success,
        l10n.m0504PasoListo,
      ),
      _EstadoPaso.enCurso => (
        SolIcons.upload,
        colors.primary,
        l10n.m0504PasoEnCurso,
      ),
      _EstadoPaso.enEspera => (
        SolIcons.requisitoPendiente,
        colors.outline,
        l10n.m0504PasoEnEspera,
      ),
    };
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SolSpacing.md),
        child: Row(
          children: [
            Icon(icono, color: color, size: 22),
            const SizedBox(width: SolSpacing.md),
            Expanded(
              child: Text(
                titulo,
                style: context.solText.body.copyWith(
                  fontWeight: estado == _EstadoPaso.enCurso
                      ? FontWeight.w600
                      : null,
                ),
              ),
            ),
            const SizedBox(width: SolSpacing.sm),
            Flexible(
              child: Text(
                detalle == null ? texto : '$detalle · $texto',
                textAlign: TextAlign.end,
                style: context.solText.body.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
