import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../asistencia_routes.dart';
import '../providers.dart';
import '../solicitud_notifier.dart';

/// M06-03 · Enviando solicitud (Figma 2005:340) y M06-03b · Reenviando
/// (2005:671): la misma pantalla transitoria, sin acciones; avanza sola al
/// desenlace. El reenvío manda los mismos datos con el mismo `idSolicitud`.
class M0603EnviandoPage extends ConsumerStatefulWidget {
  const M0603EnviandoPage({super.key});

  @override
  ConsumerState<M0603EnviandoPage> createState() => _M0603EnviandoPageState();
}

class _M0603EnviandoPageState extends ConsumerState<M0603EnviandoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(ref.read(solicitudProvider.notifier).enviar());
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(solicitudProvider.select((s) => s.envio), (_, envio) {
      if (envio is Respondida || envio is EnvioFallido) {
        context.pushReplacement(AsistenciaRoutes.resultado);
      }
    });
    final l10n = context.l10n;
    final s = ref.watch(solicitudProvider);
    final nombre = s.prestador?.nombre ?? '';
    return SolTransitionalScreen(
      title: l10n.m0602Titulo,
      message: s.intentos > 0
          ? l10n.m0603bMensaje(nombre)
          : l10n.m0603Mensaje(nombre),
    );
  }
}
