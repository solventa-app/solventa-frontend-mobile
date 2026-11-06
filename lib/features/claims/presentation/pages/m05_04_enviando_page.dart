import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../providers.dart';
import '../reporte_notifier.dart';
import '../reporte_routes.dart';

/// M05-04 · Enviando: sube las fotos y crea el caso; avanza sola al desenlace.
class M0504EnviandoPage extends ConsumerStatefulWidget {
  const M0504EnviandoPage({super.key});

  @override
  ConsumerState<M0504EnviandoPage> createState() => _M0504EnviandoPageState();
}

class _M0504EnviandoPageState extends ConsumerState<M0504EnviandoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(ref.read(reporteProvider.notifier).enviar());
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(reporteProvider.select((s) => s.envio), (_, envio) {
      if (envio is Enviado || envio is EnvioFallido) {
        context.pushReplacement(ReporteRoutes.resultado);
      }
    });
    final l10n = context.l10n;
    return SolTransitionalScreen(
      title: l10n.m0504Titulo,
      message: l10n.m0504Mensaje,
    );
  }
}
