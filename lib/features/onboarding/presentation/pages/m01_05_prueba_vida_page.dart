import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/datasources/captura_service.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';
import '../widgets/falla_banner.dart';
import '../widgets/onboarding_widgets.dart';

/// M01-05 · Prueba de vida (2001:502), en tres momentos:
///
/// 1. **Lista**: la instrucción dice que se graban 3 s y que hay que mover la
///    cabeza; «Grabar video» toma la selfie y empieza el video.
/// 2. **Grabando**: «● Grabando» sobre el visor y una cuenta regresiva que pide
///    mover la cabeza despacio de un lado a otro.
/// 3. **Capturado**: la cámara se cierra (ya no hace falta) y la pantalla dice
///    que tiene la selfie y el video; mientras sube y Didit responde, explica
///    la espera. Si Didit rechaza solo el rostro, la cámara vuelve a abrirse.
///
/// Si una subida falla por red permite «Reintentar envío» sin repetir las
/// capturas. Envuelta en [SentryMask] para no grabar el rostro del usuario.
class M0105PruebaVidaPage extends ConsumerStatefulWidget {
  const M0105PruebaVidaPage({super.key});

  @override
  ConsumerState<M0105PruebaVidaPage> createState() =>
      _M0105PruebaVidaPageState();
}

class _M0105PruebaVidaPageState extends ConsumerState<M0105PruebaVidaPage> {
  Timer? _reloj;
  int _restantes = CamaraCapturaService.duracionVideo.inSeconds;

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }

  void _contar(bool grabando) {
    _reloj?.cancel();
    setState(() => _restantes = CamaraCapturaService.duracionVideo.inSeconds);
    if (!grabando) return;
    _reloj = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _restantes = (_restantes - 1).clamp(1, 99));
    });
  }

  Future<void> _ir() async {
    final notifier = ref.read(onboardingProvider.notifier);
    if (await notifier.completarPruebaDeVida() && mounted) {
      final actual = ref.read(onboardingProvider);
      if (actual.verificacion != null) {
        context.go(OnboardingRoutes.resultado);
      } else {
        context.go(OnboardingRoutes.verificando);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      onboardingProvider.select((s) => s.grabandoVideo),
      (_, grabando) => _contar(grabando),
    );
    final l10n = context.l10n;
    final estado = ref.watch(onboardingProvider);
    final falla = estado.falla;
    final capturado = estado.rostroCapturado && estado.videoCapturado;
    final grabando = estado.grabandoVideo;

    final contenido = capturado
        // Con la selfie y el video en memoria la cámara ya no hace falta.
        ? _Capturado(enviando: estado.ocupado)
        : SolLiveCameraFrame(
            shape: SolCameraFrameShape.face,
            frontal: true,
            label: grabando ? l10n.m0105Grabando : null,
            labelIcon: grabando ? SolIcons.recording : null,
            instruction: grabando
                ? l10n.m0105GrabandoInstruccion(_restantes)
                : l10n.m0105Instruccion,
          );

    final String etiqueta;
    if (falla != null && estado.capturasListasParaReintentar) {
      etiqueta = l10n.camaraReintentarEnvio;
    } else if (capturado) {
      etiqueta = l10n.continuar;
    } else {
      etiqueta = l10n.m0105Grabar;
    }

    return SentryMask(
      SolFlowScaffold(
        title: l10n.m0105Titulo,
        anchorActions: false,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(OnboardingRoutes.reverso);
          }
        },
        padding: const EdgeInsets.fromLTRB(
          SolSpacing.screen,
          0,
          SolSpacing.screen,
          SolSpacing.xxl,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            contenido,
            if (falla != null) ...[
              const SizedBox(height: SolSpacing.lg),
              FallaBanner(falla: falla),
            ],
          ],
        ),
        actions: [
          SolButton.primary(
            label: etiqueta,
            loading: estado.ocupado || grabando,
            onPressed: _ir,
          ),
        ],
      ),
    );
  }
}

/// La selfie y el video ya están tomados: sin cámara abierta, con la espera
/// explicada mientras se envían y Didit responde.
class _Capturado extends StatelessWidget {
  const _Capturado({required this.enviando});

  final bool enviando;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: SolSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            liveRegion: true,
            child: SolStatusBanner(
              status: SolStatus.success,
              title: l10n.m0105Capturado,
            ),
          ),
          if (enviando) ...[
            const SizedBox(height: SolSpacing.xl),
            SolLoadingState(message: l10n.m0105Verificando, center: true),
          ],
        ],
      ),
    );
  }
}
