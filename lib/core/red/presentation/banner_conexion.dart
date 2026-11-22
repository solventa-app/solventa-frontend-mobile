import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/solventa_ui.dart';
import '../../l10n/l10n.dart';
import '../../network/network_providers.dart';
import '../estado_red.dart';
import '../estado_red_notifier.dart';

/// Franja de red de las pantallas que dependen de la conexión: «Sin
/// conexión», «Conexión lenta» y, al volver, «Conexión restablecida» durante
/// unos segundos. Con buena conexión no ocupa espacio.
///
/// Mientras está montada pide que la red se vigile ([EstadoRedNotifier.vigilar]).
class BannerConexion extends ConsumerStatefulWidget {
  const BannerConexion({super.key, this.mensajeSinConexion});

  /// Qué puede hacer la persona sin conexión en esta pantalla. Sin él, el
  /// mensaje general.
  final String? mensajeSinConexion;

  /// Cuánto se muestra «Conexión restablecida» antes de ocultarse.
  static const duracionRestablecida = Duration(seconds: 4);

  @override
  ConsumerState<BannerConexion> createState() => _BannerConexionState();
}

class _BannerConexionState extends ConsumerState<BannerConexion> {
  void Function()? _soltar;
  Timer? _ocultar;
  bool _restablecida = false;

  @override
  void initState() {
    super.initState();
    _soltar = ref.read(estadoRedProvider.notifier).vigilar();
  }

  @override
  void dispose() {
    _ocultar?.cancel();
    _soltar?.call();
    super.dispose();
  }

  void _alCambiar(EstadoRed? antes, EstadoRed ahora) {
    if (antes == null) return;
    if (!antes.conectado && ahora.conectado) {
      _ocultar?.cancel();
      setState(() => _restablecida = true);
      _ocultar = Timer(BannerConexion.duracionRestablecida, () {
        if (mounted) setState(() => _restablecida = false);
      });
    } else if (!ahora.conectado && _restablecida) {
      _ocultar?.cancel();
      setState(() => _restablecida = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(estadoRedProvider, _alCambiar);
    final red = ref.watch(estadoRedProvider);
    final l10n = context.l10n;

    if (!red.conectado) {
      return SolConnectionBanner(
        tone: SolConnectionTone.offline,
        title: l10n.redSinConexionTitulo,
        message: widget.mensajeSinConexion ?? l10n.redSinConexionMensaje,
      );
    }
    if (_restablecida) {
      return SolConnectionBanner(
        tone: SolConnectionTone.done,
        title: l10n.redRestablecidaTitulo,
      );
    }
    if (red.lenta) {
      return SolConnectionBanner(
        tone: SolConnectionTone.slow,
        title: l10n.redLentaTitulo,
        message: switch (red.tipo) {
          TipoRed.movil => l10n.redLentaDatos,
          TipoRed.wifi => l10n.redLentaWifi,
          TipoRed.otra || TipoRed.ninguna => l10n.redLentaOtra,
        },
      );
    }
    return const SizedBox(width: double.infinity);
  }
}

/// Píldora con la interfaz y la calidad de la red («Wi-Fi · buena»).
class ChipRed extends ConsumerWidget {
  const ChipRed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final red = ref.watch(estadoRedProvider);
    return SolNetworkChip(
      quality: calidadDeChip(red.calidad),
      link: switch (red.tipo) {
        TipoRed.wifi => SolNetworkLink.wifi,
        TipoRed.movil => SolNetworkLink.mobile,
        TipoRed.otra || TipoRed.ninguna => SolNetworkLink.other,
      },
      label: textoDeRed(context.l10n, red),
    );
  }
}

SolNetworkQuality calidadDeChip(CalidadRed calidad) => switch (calidad) {
  CalidadRed.buena => SolNetworkQuality.good,
  CalidadRed.regular => SolNetworkQuality.fair,
  CalidadRed.mala => SolNetworkQuality.poor,
  CalidadRed.sinConexion => SolNetworkQuality.offline,
};

/// «Wi-Fi · buena», «Datos · mala», «Sin conexión».
String textoDeRed(AppLocalizations l10n, EstadoRed red) {
  final calidad = switch (red.calidad) {
    CalidadRed.sinConexion => null,
    CalidadRed.buena => l10n.redCalidadBuena,
    CalidadRed.regular => l10n.redCalidadRegular,
    CalidadRed.mala => l10n.redCalidadMala,
  };
  if (calidad == null) return l10n.redChipSinConexion;
  return switch (red.tipo) {
    TipoRed.wifi => l10n.redChipWifi(calidad),
    TipoRed.movil => l10n.redChipDatos(calidad),
    TipoRed.otra || TipoRed.ninguna => l10n.redChipOtra(calidad),
  };
}

/// Disparador de demo (`API_ENV=mock`, solo debug): alterna la red simulada
/// para recorrer los estados sin apagar el Wi-Fi del teléfono.
class DemoRed extends ConsumerWidget {
  const DemoRed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(usarFakesProvider)) return const SizedBox.shrink();
    final red = ref.watch(estadoRedProvider);
    final l10n = context.l10n;
    final notifier = ref.read(estadoRedProvider.notifier);
    if (red.simulado) {
      return SolDemoTrigger(
        label: l10n.redDemoReal,
        onTap: () => notifier.simular(null),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SolDemoTrigger(
          label: l10n.redDemoSinConexion,
          onTap: () => notifier.simular(CalidadRed.sinConexion),
        ),
        SolDemoTrigger(
          label: l10n.redDemoLenta,
          onTap: () => notifier.simular(CalidadRed.mala),
        ),
      ],
    );
  }
}
