import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/asistencia.dart';
import '../asistencia_routes.dart';
import '../providers.dart';
import '../solicitud_notifier.dart';
import 'm06_06_cancelada_page.dart';

/// Navega en el cuadro siguiente, con el gesto ya terminado: si se cambia de
/// ruta dentro del toque, la barra inferior del inicio recibe ese mismo toque
/// (lo mismo que en M05-05).
void navegarDespues(BuildContext context, VoidCallback ir) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) ir();
  });
  WidgetsBinding.instance.scheduleFrame();
}

/// Desenlace del envío: M06-04a · Asistencia confirmada (Figma 2005:371) o
/// M06-04b · No pudimos confirmar (2005:404). Cancelar abre M06-05.
class M0604ResultadoPage extends ConsumerWidget {
  const M0604ResultadoPage({
    super.key,
    required this.onIrAlMapa,
    required this.onIrAlInicio,
  });

  /// Vuelve a M06-01 (pestaña Asistencia) para elegir otro prestador.
  final VoidCallback onIrAlMapa;

  /// Vuelve a G-03 (pestaña Inicio).
  final VoidCallback onIrAlInicio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(solicitudProvider);
    final nombre = s.prestador?.nombre ?? '';
    return switch (s.envio) {
      Respondida(:final asistencia)
          when asistencia.estado == EstadoAsistencia.confirmada =>
        _Confirmada(asistencia: asistencia, onIrAlMapa: onIrAlMapa),
      Respondida(:final asistencia)
          when asistencia.estado == EstadoAsistencia.cancelada =>
        M0606CanceladaPage(onIrAlMapa: onIrAlMapa, onIrAlInicio: onIrAlInicio),
      Respondida() => _NoConfirmada(
        causa: context.l10n.m0604bSinRespuesta(nombre),
        reintentable: true,
        onIrAlMapa: onIrAlMapa,
      ),
      EnvioFallido(:final falla) => _NoConfirmada(
        causa: _causa(context.l10n, falla, nombre),
        // Un rechazo de negocio no cambia por reenviar: solo elegir otro.
        reintentable: falla.reintentable,
        onIrAlMapa: onIrAlMapa,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  static String _causa(AppLocalizations l10n, Falla falla, String nombre) =>
      switch (falla) {
        FallaNegocio(motivo: CodigosAsistencia.prestadorNoDisponible) =>
          l10n.m0604bNoDisponible(nombre),
        FallaNegocio(motivo: CodigosAsistencia.tipoNoAtendido) =>
          l10n.m0602TipoNoAtendido(nombre),
        _ => l10n.falla(falla),
      };
}

class _Confirmada extends ConsumerWidget {
  const _Confirmada({required this.asistencia, required this.onIrAlMapa});

  final Asistencia asistencia;
  final VoidCallback onIrAlMapa;

  Future<void> _cancelar(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    // M06-05: nunca cancela de inmediato; la acción segura es la de abajo.
    final confirmar = await SolConfirmDialog.show(
      context,
      title: l10n.m0605Titulo,
      message: l10n.m0605Mensaje(asistencia.prestador.nombre),
      confirmLabel: l10n.m0605Confirmar,
      cancelLabel: l10n.m0605Mantener,
    );
    if (!confirmar || !context.mounted) return;
    final ok = await ref.read(solicitudProvider.notifier).cancelar();
    if (!context.mounted) return;
    if (ok) {
      navegarDespues(
        context,
        () => context.pushReplacement(AsistenciaRoutes.cancelada),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.m0604aCancelarFallo)));
    }
  }

  Future<void> _verEnMapa(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(rutaExternaServiceProvider)
        .abrirRuta(
          asistencia.prestador.ubicacion,
          nombre: asistencia.prestador.nombre,
        );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.m0601RutaNoDisponible)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cancelando = ref.watch(solicitudProvider.select((s) => s.cancelando));
    return SolResultScreen(
      title: l10n.m0602Titulo,
      status: SolStatus.success,
      message:
          '${l10n.m0604aTitulo}\n'
          '${switch (asistencia.minutosEstimados) {
            final minutos? => l10n.m0604aMensaje(asistencia.prestador.nombre, minutos),
            null => l10n.m0604aMensajeSinTiempo(asistencia.prestador.nombre),
          }}',
      actionLabel: l10n.m0604aVerMapa,
      onAction: () => _verEnMapa(context, ref),
      onBack: () => navegarDespues(context, onIrAlMapa),
      secondaryAction: SolButton.destructive(
        label: l10n.m0604aCancelar,
        loading: cancelando,
        onPressed: () => _cancelar(context, ref),
      ),
    );
  }
}

class _NoConfirmada extends StatelessWidget {
  const _NoConfirmada({
    required this.causa,
    required this.reintentable,
    required this.onIrAlMapa,
  });

  final String causa;
  final bool reintentable;
  final VoidCallback onIrAlMapa;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SolResultScreen(
      title: l10n.m0602Titulo,
      status: SolStatus.error,
      message: '${l10n.m0604bTitulo}\n$causa',
      actionLabel: l10n.m0604bElegirOtro,
      onAction: () => navegarDespues(context, onIrAlMapa),
      onBack: () => navegarDespues(context, onIrAlMapa),
      // M06-03b: reintentar no vuelve al formulario; reenvía lo ya escrito.
      secondaryAction: reintentable
          ? SolButton.tonal(
              label: l10n.m0604bReintentar,
              onPressed: () => navegarDespues(
                context,
                () => context.pushReplacement(AsistenciaRoutes.enviando),
              ),
            )
          : null,
    );
  }
}
