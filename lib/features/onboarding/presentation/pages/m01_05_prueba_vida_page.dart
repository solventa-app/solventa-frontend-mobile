import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/datasources/captura_service.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';
import '../widgets/falla_banner.dart';
import '../widgets/guia_prueba_vida.dart';
import '../widgets/onboarding_widgets.dart';

/// M01-05 · Prueba de vida (2001:502), en tres momentos:
///
/// 1. **Lista**: avisa que se graban 15 s y muestra los tres pasos (izquierda,
///    derecha y centro); «Grabar video» toma la selfie y empieza el video.
/// 2. **Grabando**: «● Grabando · 00:07 / 00:15» sobre el visor, un anillo
///    verde que se llena alrededor del óvalo ([GuiaPruebaVida]) y el paso
///    actual resaltado, unos 5 s cada uno.
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
  static final _total = CamaraCapturaService.duracionVideo.inSeconds;

  Timer? _reloj;

  /// Segundos de grabación que ya pasaron (0 a 15).
  int _transcurridos = 0;

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }

  void _contar(bool grabando) {
    _reloj?.cancel();
    setState(() => _transcurridos = 0);
    if (!grabando) return;
    _reloj = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _transcurridos = (_transcurridos + 1).clamp(0, _total));
    });
  }

  static String _mmss(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

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

    final paso = GuiaPruebaVida.pasoEn(
      _transcurridos,
      CamaraCapturaService.duracionVideo,
    );
    final instruccionPaso = switch (paso) {
      PasoPruebaVida.izquierda => l10n.m0105GiraIzquierda,
      PasoPruebaVida.derecha => l10n.m0105GiraDerecha,
      PasoPruebaVida.centro => l10n.m0105MiraCentro,
    };
    final contenido = capturado
        // Con la selfie y el video en memoria la cámara ya no hace falta.
        ? _Capturado(enviando: estado.ocupado)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SolLiveCameraFrame(
                shape: SolCameraFrameShape.face,
                frontal: true,
                label: grabando
                    ? l10n.m0105GrabandoTiempo(
                        _mmss(_transcurridos),
                        _mmss(_total),
                      )
                    : null,
                labelIcon: grabando ? SolIcons.recording : null,
                instruction: grabando ? instruccionPaso : l10n.m0105Instruccion,
                faceGuide: GuiaPruebaVida(
                  grabando: grabando,
                  duracion: CamaraCapturaService.duracionVideo,
                ),
              ),
              const SizedBox(height: SolSpacing.md),
              PasosPruebaVida(
                etiquetas: [
                  l10n.m0105PasoIzquierda,
                  l10n.m0105PasoDerecha,
                  l10n.m0105PasoCentro,
                ],
                actual: paso,
                grabando: grabando,
              ),
              if (!grabando) ...[
                const SizedBox(height: SolSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: context.colors.secondary,
                    ),
                    const SizedBox(width: SolSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.m0105AvisoDuracion,
                        style: context.solText.note.copyWith(
                          color: context.colors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
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
          // KAN-31: tras un rechazo del rostro, muchas veces la foto mala es la
          // de la cédula: se puede volver a tomar en vez de repetir el video.
          if (_rechazoDelRostro(falla) && !estado.ocupado && !grabando)
            SolButton.text(
              label: l10n.m0105CambiarDocumento,
              onPressed: () {
                ref.read(onboardingProvider.notifier).cambiarFotosDocumento();
                context.go(OnboardingRoutes.frente);
              },
            ),
        ],
      ),
    );
  }
}

bool _rechazoDelRostro(Falla? falla) => switch (falla) {
  FallaNegocio(motivo: 'ROSTRO_NO_COINCIDE' || 'SUPLANTACION') => true,
  _ => false,
};

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
