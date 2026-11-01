import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-05c · Verifica tu correo (código OTP de 6 dígitos enviado por correo).
///
/// Usa los componentes de autenticación del sistema de diseño:
/// [SolPinIndicator] con 6 posiciones y [SolNumericKeypad].
class M0105cCodigoPage extends ConsumerStatefulWidget {
  const M0105cCodigoPage({super.key, this.irAlInicioAlTerminar = true});

  /// `true` cuando viene desde la creación de cuenta inicial; `false` cuando
  /// viene desde el paso M01-05b previo a M01-06.
  final bool irAlInicioAlTerminar;

  @override
  ConsumerState<M0105cCodigoPage> createState() => _M0105cCodigoPageState();
}

class _M0105cCodigoPageState extends ConsumerState<M0105cCodigoPage> {
  String _codigo = '';
  bool _reenviado = false;

  /// Espera mínima entre envíos. El backend la exige también y manda los
  /// segundos restantes (`ESPERA_REQUERIDA`); este valor es solo el de partida.
  static const _esperaReenvio = 60;
  int _segundosRestantes = _esperaReenvio;
  Timer? _reloj;

  @override
  void initState() {
    super.initState();
    _iniciarEspera();
  }

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }

  void _iniciarEspera([int segundos = _esperaReenvio]) {
    _reloj?.cancel();
    setState(() => _segundosRestantes = segundos);
    _reloj = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _segundosRestantes--);
      if (_segundosRestantes <= 0) t.cancel();
    });
  }

  String _formatoEspera(int s) =>
      '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  void _onDigit(int digito) {
    if (_codigo.length >= 6) return;
    ref.read(onboardingProvider.notifier).limpiarFalla();
    setState(() {
      _codigo = '$_codigo$digito';
      _reenviado = false;
    });
    if (_codigo.length == 6) {
      _verificar();
    }
  }

  void _onBackspace() {
    if (_codigo.isEmpty) return;
    ref.read(onboardingProvider.notifier).limpiarFalla();
    setState(() {
      _codigo = _codigo.substring(0, _codigo.length - 1);
    });
  }

  Future<void> _verificar() async {
    if (_codigo.length != 6) return;
    final ok = await ref
        .read(onboardingProvider.notifier)
        .verificarCodigoYCrearCuenta(_codigo);
    if (!mounted) return;
    if (ok) {
      if (widget.irAlInicioAlTerminar) {
        context.go('/');
      } else {
        context.go(OnboardingRoutes.verificando);
      }
    } else {
      setState(() => _codigo = '');
    }
  }

  Future<void> _reenviar() async {
    final ok = await ref
        .read(onboardingProvider.notifier)
        .reenviarCodigoCorreo();
    if (!mounted) return;
    if (ok) {
      setState(() {
        _codigo = '';
        _reenviado = true;
      });
      _iniciarEspera();
    } else if (ref.read(onboardingProvider).falla
        case FallaNegocio(motivo: 'ESPERA_REQUERIDA')) {
      // El backend aún exige esperar: se vuelve a bloquear el botón.
      _iniciarEspera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(onboardingProvider);
    final colors = context.colors;
    final correo =
        estado.codigoOnboarding?.correoEnmascarado ??
        estado.correoPendiente ??
        'tu correo';
    final intentos = estado.codigoOnboarding?.intentosRestantes ?? 5;
    final falla = estado.falla;

    return SolFlowScaffold(
      title: l10n.otpTitulo,
      anchorActions: false,
      showProfile: false,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(OnboardingRoutes.cuenta);
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.otpInstruccion(correo),
            textAlign: TextAlign.center,
            style: context.solText.body.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: SolSpacing.xs),
          Text(
            l10n.otpVence,
            textAlign: TextAlign.center,
            style: context.solText.note.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SolSpacing.xl),
          Center(child: SolPinIndicator(filled: _codigo.length, length: 6)),
          const SizedBox(height: SolSpacing.md),
          Text(
            l10n.otpIntentosRestantes(intentos),
            textAlign: TextAlign.center,
            style: context.solText.note.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          if (_reenviado) ...[
            const SizedBox(height: SolSpacing.md),
            SolStatusBanner(
              status: SolStatus.success,
              title: l10n.otpReenviado,
            ),
          ],
          if (falla != null) ...[
            const SizedBox(height: SolSpacing.md),
            SolStatusBanner(status: SolStatus.error, title: l10n.falla(falla)),
          ],
          const SizedBox(height: SolSpacing.lg),
          Center(
            child: SolNumericKeypad(
              enabled: !estado.ocupado,
              onDigit: _onDigit,
              onBackspace: _onBackspace,
            ),
          ),
        ],
      ),
      actions: [
        SolButton.primary(
          label: l10n.otpVerificar,
          loading: estado.ocupado,
          onPressed: _codigo.length == 6 ? _verificar : null,
        ),
        const SizedBox(height: SolSpacing.sm),
        Center(
          child: SolLinkButton(
            label: _segundosRestantes > 0
                ? l10n.otpReenviarEn(_formatoEspera(_segundosRestantes))
                : l10n.otpReenviar,
            onPressed: estado.ocupado || _segundosRestantes > 0
                ? null
                : _reenviar,
          ),
        ),
      ],
    );
  }
}
