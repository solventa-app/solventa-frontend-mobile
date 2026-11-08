import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/biometria/biometria_service.dart';
import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/network_providers.dart';
import '../onboarding_routes.dart';
import '../providers.dart';

/// M01-08 · Activa tu biometría (2001:673).
///
/// Al entrar y al volver de Ajustes consulta qué tiene el teléfono. «Ya lo
/// activé» abre el diálogo del sistema (huella, rostro o PIN del teléfono,
/// decisión D1) y, si confirma, deja guardado el refresh de la sesión
/// (HU-M02). Sin bloqueo de pantalla no se puede seguir.
class M0108BiometriaPage extends ConsumerStatefulWidget {
  const M0108BiometriaPage({super.key});

  @override
  ConsumerState<M0108BiometriaPage> createState() => _M0108BiometriaPageState();
}

class _M0108BiometriaPageState extends ConsumerState<M0108BiometriaPage>
    with WidgetsBindingObserver {
  bool _comprobando = false;
  EstadoBiometria? _estado;
  ResultadoBiometria? _ultimo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _consultarEstado();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Al volver de Ajustes, el teléfono puede tener ya huella o bloqueo.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _consultarEstado();
  }

  Future<void> _consultarEstado() async {
    final estado = await ref.read(biometriaServiceProvider).estado();
    if (!mounted) return;
    setState(() {
      _estado = estado;
      _ultimo = null;
    });
  }

  Future<void> _continuar() async {
    final motivo = context.l10n.biometriaMotivo;
    final servicio = ref.read(biometriaServiceProvider);
    setState(() {
      _comprobando = true;
      _ultimo = null;
    });
    final estado = await servicio.estado();
    if (!mounted) return;
    if (estado == EstadoBiometria.sinBloqueoPantalla ||
        estado == EstadoBiometria.noDisponible) {
      setState(() {
        _estado = estado;
        _comprobando = false;
      });
      return;
    }
    final resultado = await servicio.autenticar(
      motivo: motivo,
      permitirCredencialDispositivo: true,
    );
    if (!mounted) return;
    if (resultado is Autenticado) {
      // Si al abrir la sesión no había bloqueo, el refresh quedó solo en
      // memoria: ahora que hay bloqueo se guarda cifrado.
      await ref.read(gestorSesionProvider).asegurarPersistencia();
      if (!mounted) return;
      context.go('/');
      return;
    }
    setState(() {
      _comprobando = false;
      _estado = estado;
      _ultimo = resultado;
    });
  }

  /// Aviso según el último intento o, si no hubo, según el estado.
  (SolStatus, String)? _aviso(AppLocalizations l10n) {
    final ultimo = _ultimo;
    if (ultimo != null) {
      return switch (ultimo) {
        NoReconocido() => (SolStatus.warning, l10n.m0108NoReconocido),
        BloqueoTemporal() ||
        BloqueoPermanente() => (SolStatus.warning, l10n.m0108BloqueoTemporal),
        SinBloqueoPantalla() => (SolStatus.warning, l10n.m0108SinBloqueo),
        SinBiometriaRegistrada() => (SolStatus.info, l10n.m0108SoloPin),
        NoDisponible() => (SolStatus.warning, l10n.m0108NoDisponible),
        Autenticado() || Cancelado() => null,
      };
    }
    return switch (_estado) {
      EstadoBiometria.sinBloqueoPantalla => (
        SolStatus.warning,
        l10n.m0108SinBloqueo,
      ),
      EstadoBiometria.noDisponible => (
        SolStatus.warning,
        l10n.m0108NoDisponible,
      ),
      EstadoBiometria.soloCredencial => (SolStatus.info, l10n.m0108SoloPin),
      EstadoBiometria.biometriaRegistrada || null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sol = context.solColors;
    return SolFlowScaffold(
      title: l10n.m0108Titulo,
      anchorActions: false,
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(OnboardingRoutes.resultado);
        }
      },
      body: Column(
        children: [
          ExcludeSemantics(
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                SolIcons.fingerprint,
                size: 56,
                color: colors.primary,
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.xxl),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Semantics(
              header: true,
              child: Text(
                l10n.m0108Encabezado,
                textAlign: TextAlign.center,
                style: context.solText.title.copyWith(color: colors.onSurface),
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 316),
            child: Text(
              l10n.m0108Explicacion,
              textAlign: TextAlign.center,
              style: context.solText.body.copyWith(
                color: colors.onSurfaceVariant,
                height: 22.75 / 14,
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.xxl),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SolSpacing.lg,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: SolRadius.fullAll,
              boxShadow: [
                BoxShadow(
                  color: sol.softShadow,
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  SolIcons.shield,
                  size: 16,
                  opticalSize: 20,
                  fill: 1,
                  color: sol.success,
                ),
                const SizedBox(width: SolSpacing.xs),
                Flexible(
                  child: Text(
                    l10n.m0108Sello,
                    textAlign: TextAlign.center,
                    style: context.solText.note.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_aviso(l10n) case (final status, final texto)) ...[
            const SizedBox(height: SolSpacing.lg),
            Semantics(
              liveRegion: true,
              child: SolStatusBanner(status: status, title: texto),
            ),
          ],
        ],
      ),
      actions: [
        SolButton.outlined(
          label: l10n.m0108Ajustes,
          icon: SolIcons.settings,
          onPressed: () =>
              ref.read(biometriaServiceProvider).abrirAjustesSeguridad(),
        ),
        const SizedBox(height: SolSpacing.lg),
        SolButton.primary(
          label: l10n.m0108Continuar,
          loading: _comprobando,
          onPressed: _continuar,
        ),
        const SizedBox(height: SolSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SolSpacing.sm),
          child: SolInlineNote(
            text: l10n.m0108Requisito,
            center: true,
            color: sol.warning,
          ),
        ),
      ],
    );
  }
}
