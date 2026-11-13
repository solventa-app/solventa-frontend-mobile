import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/asistencia.dart';
import '../../domain/entities/prestador.dart';
import '../mis_asistencias_notifier.dart';
import 'detalle_prestador.dart';

/// «Médica», «Mecánica», «Grúa» (el mismo texto de M06-02).
String nombreTipoAsistencia(AppLocalizations l10n, TipoPrestador t) =>
    switch (t) {
      TipoPrestador.medico => l10n.m0602TipoMedica,
      TipoPrestador.mecanico => l10n.m0602TipoMecanica,
      TipoPrestador.grua => l10n.m0602TipoGrua,
    };

/// «Llega en 4 min» o «Llega en menos de 1 min» (4.2).
String cuentaRegresiva(
  AppLocalizations l10n,
  DateTime llegada,
  DateTime ahora,
) {
  final segundos = llegada.difference(ahora).inSeconds;
  return segundos < 60
      ? l10n.asistenciaLlegaMenosDeUno
      : l10n.asistenciaLlegaEn('${(segundos / 60).ceil()}');
}

/// Estado de la tarjeta según la asistencia y el reloj de la pestaña (4.2).
SolAssistanceCardState estadoTarjeta(
  AppLocalizations l10n,
  Asistencia a,
  MisAsistenciasState s, {
  required VoidCallback? onRetry,
}) {
  if (s.llego(a)) {
    final hora = a.llegadaEstimada ?? a.solicitadaEn;
    return SolAssistanceArrived(
      l10n.asistenciaLlego(SolFormat.time(hora.toLocal())),
    );
  }
  final llegada = a.llegadaEstimada;
  final confirmada = a.confirmadaEn;
  if (a.estado != EstadoAsistencia.confirmada || llegada == null) {
    return SolAssistanceUnconfirmed(
      warning: l10n.asistenciaNoConfirmada,
      retryLabel: l10n.asistenciaReintentar,
      onRetry: onRetry,
    );
  }
  final total = confirmada == null
      ? 0
      : llegada.difference(confirmada).inMilliseconds;
  final avance = confirmada == null
      ? 0
      : s.ahora.difference(confirmada).inMilliseconds;
  return SolAssistanceOnTheWay(
    countdown: cuentaRegresiva(l10n, llegada, s.ahora),
    estimatedTime: l10n.asistenciaHoraEstimada(
      SolFormat.time(llegada.toLocal()),
    ),
    progress: total <= 0 ? 0 : avance / total,
  );
}

/// La tarjeta de «Mis asistencias» de [a] (4.2). TalkBack la lee entera:
/// «Clínica Norte, médica, llega en 4 min» (sin anunciar cada segundo: la
/// lectura cambia por minuto).
Widget tarjetaAsistencia(
  BuildContext context,
  Asistencia a,
  MisAsistenciasState s, {
  required VoidCallback onTap,
  required VoidCallback? onRetry,
  Widget? notice,
}) {
  final l10n = context.l10n;
  final tipo = nombreTipoAsistencia(l10n, a.tipo);
  final estado = estadoTarjeta(l10n, a, s, onRetry: onRetry);
  final lecturaEstado = switch (estado) {
    SolAssistanceOnTheWay(:final countdown) => countdown,
    SolAssistanceUnconfirmed(:final warning) => warning,
    SolAssistanceArrived(:final label) => label,
  };
  final nombre = a.prestador.aliado
      ? '${a.prestador.nombre}, ${l10n.m0601Aliado}'
      : a.prestador.nombre;
  return SolAssistanceCard(
    name: a.prestador.nombre,
    icon: iconoTipoPrestador(a.prestador.tipo),
    isPartner: a.prestador.aliado,
    subtitle: l10n.asistenciaPedida(
      tipo,
      SolFormat.time(a.solicitadaEn.toLocal()),
    ),
    state: estado,
    semanticLabel: l10n.asistenciaLectura(nombre, tipo, lecturaEstado),
    onTap: onTap,
    notice: notice,
  );
}
