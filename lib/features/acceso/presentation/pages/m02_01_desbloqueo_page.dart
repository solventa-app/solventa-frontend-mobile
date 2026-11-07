import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/biometria/biometria_providers.dart';
import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../acceso_notifier.dart';
import '../widgets/acceso_widgets.dart';

/// M02-01 · Desbloquea tu cuenta (2005:565) y su estado M02-01a · No te
/// reconocimos (2005:472).
///
/// Al entrar abre sola el diálogo del sistema. «Usar PIN del teléfono» lo
/// abre aceptando el PIN, patrón o contraseña del teléfono (D2: sin PIN
/// propio de la app). El atrás del sistema cierra la app: es la única ruta.
class M0201DesbloqueoPage extends ConsumerStatefulWidget {
  const M0201DesbloqueoPage({super.key, this.autoIniciar = true});

  /// Abre el diálogo al entrar. Las pruebas y goldens lo apagan.
  final bool autoIniciar;

  @override
  ConsumerState<M0201DesbloqueoPage> createState() =>
      _M0201DesbloqueoPageState();
}

class _M0201DesbloqueoPageState extends ConsumerState<M0201DesbloqueoPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.autoIniciar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final estado = ref.read(accesoProvider);
        if (estado.aviso == null && !estado.noReconocida) _desbloquear();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Al volver de Ajustes, el teléfono puede tener ya bloqueo o huella.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(accesoProvider.notifier).alVolverDeAjustes();
    }
  }

  Future<void> _desbloquear({bool conPin = false}) => ref
      .read(accesoProvider.notifier)
      .desbloquear(motivo: context.l10n.m0201Motivo, conPin: conPin);

  Future<void> _reintentar() => ref
      .read(accesoProvider.notifier)
      .reintentar(motivo: context.l10n.m0201Motivo);

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(accesoProvider);
    return AccesoMarco(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 328),
        child: estado.noReconocida
            ? _NoReconocida(
                ocupado: estado.autenticando,
                onReintentar: _desbloquear,
                onUsarPin: () => _desbloquear(conPin: true),
              )
            : _Desbloqueo(
                estado: estado,
                onSensor: _desbloquear,
                onUsarPin: () => _desbloquear(conPin: true),
                onReintentar: _reintentar,
                onAjustes: () =>
                    ref.read(biometriaServiceProvider).abrirAjustesSeguridad(),
                onUsarCorreo: () =>
                    ref.read(accesoProvider.notifier).usarCorreo(),
                onSimularNoReconoce: () =>
                    ref.read(accesoProvider.notifier).simularNoReconocida(),
              ),
      ),
    );
  }
}

/// M02-01: tarjeta de 28 dp de radio con sombra marcada (Figma 2005:568).
class _Desbloqueo extends StatelessWidget {
  const _Desbloqueo({
    required this.estado,
    required this.onSensor,
    required this.onUsarPin,
    required this.onReintentar,
    required this.onAjustes,
    required this.onUsarCorreo,
    required this.onSimularNoReconoce,
  });

  final AccesoState estado;
  final VoidCallback onSensor;
  final VoidCallback onUsarPin;
  final VoidCallback onReintentar;
  final VoidCallback onAjustes;
  final VoidCallback onUsarCorreo;
  final VoidCallback onSimularNoReconoce;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final ocupado = estado.autenticando;
    final aviso = estado.aviso;
    final sinAutenticar =
        aviso == AvisoAcceso.sinBloqueoPantalla ||
        aviso == AvisoAcceso.noDisponible;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SolSpacing.xxl,
          SolSpacing.xxl,
          SolSpacing.xxl,
          SolSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Marca(),
            const SizedBox(height: SolSpacing.sm),
            Semantics(
              header: true,
              child: Text(
                l10n.m0201Titulo,
                textAlign: TextAlign.center,
                style: context.solText.title.copyWith(color: colors.onSurface),
              ),
            ),
            const SizedBox(height: SolSpacing.xxl),
            Center(
              child: Semantics(
                button: true,
                enabled: !ocupado && !sinAutenticar,
                label: l10n.m0201Escanear,
                excludeSemantics: true,
                onTap: ocupado || sinAutenticar ? null : onSensor,
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: ocupado || sinAutenticar ? null : onSensor,
                    child: Ink(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        // #EEEDF3 con el velo azul de Figma (2005:591).
                        color: Color.alphaBlend(
                          colors.secondary.withValues(alpha: 0.075),
                          colors.secondaryContainer,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        SolIcons.fingerprint,
                        size: 44,
                        color: colors.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: SolSpacing.lg),
            Text(
              l10n.m0201Sensor,
              textAlign: TextAlign.center,
              style: context.solText.body.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (aviso != null) ...[
              const SizedBox(height: SolSpacing.lg),
              SolStatusBanner(
                status: SolStatus.warning,
                title: _textoAviso(l10n, aviso),
              ),
            ],
            const SizedBox(height: SolSpacing.lg),
            if (aviso == AvisoAcceso.sinRed) ...[
              SolButton.primary(
                label: l10n.m0201Reintentar,
                loading: ocupado,
                onPressed: ocupado ? null : onReintentar,
              ),
              const SizedBox(height: SolSpacing.sm),
            ],
            if (sinAutenticar) ...[
              SolButton.outlined(
                label: l10n.m0201IrAjustes,
                icon: SolIcons.settings,
                onPressed: onAjustes,
              ),
              const SizedBox(height: SolSpacing.sm),
              SolLinkButton(
                label: l10n.m0201UsarCorreo,
                onPressed: onUsarCorreo,
              ),
            ] else
              SolLinkButton(
                label: l10n.m0201UsarPin,
                onPressed: ocupado ? null : onUsarPin,
              ),
            const SizedBox(height: SolSpacing.sm),
            SolDemoTrigger(
              label: l10n.m0201SimularNoReconoce,
              center: true,
              onTap: onSimularNoReconoce,
            ),
          ],
        ),
      ),
    );
  }

  static String _textoAviso(AppLocalizations l10n, AvisoAcceso aviso) =>
      switch (aviso) {
        AvisoAcceso.sinRed => l10n.m0201SinRed,
        AvisoAcceso.bloqueoTemporal => l10n.m0201BloqueoTemporal,
        AvisoAcceso.bloqueoPermanente => l10n.m0201BloqueoPermanente,
        AvisoAcceso.faltaAutenticacion => l10n.m0201FaltaAutenticacion,
        AvisoAcceso.sinBloqueoPantalla => l10n.m0201SinBloqueo,
        AvisoAcceso.noDisponible => l10n.m0201NoDisponible,
      };
}

/// M02-01a: tarjeta de 12 dp con el error y dos botones (Figma 2005:475).
class _NoReconocida extends StatelessWidget {
  const _NoReconocida({
    required this.ocupado,
    required this.onReintentar,
    required this.onUsarPin,
  });

  final bool ocupado;
  final VoidCallback onReintentar;
  final VoidCallback onUsarPin;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: SolColors.surface,
        borderRadius: SolRadius.cardAll,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(SolSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Marca(pequena: true),
            const SizedBox(height: SolSpacing.xxl),
            Center(
              child: ExcludeSemantics(
                child: AccesoIconoCirculo(
                  icono: SolIcons.failure,
                  fondo: colors.errorContainer,
                  color: colors.error,
                  diametro: 64,
                ),
              ),
            ),
            const SizedBox(height: SolSpacing.lg),
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                l10n.m0201aTitulo,
                textAlign: TextAlign.center,
                style: context.solText.title.copyWith(color: colors.onSurface),
              ),
            ),
            const SizedBox(height: SolSpacing.sm),
            Text(
              l10n.m0201aMensaje,
              textAlign: TextAlign.center,
              style: context.solText.body.copyWith(
                fontSize: 13,
                height: 18 / 13,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SolSpacing.xxxl),
            SolButton.primary(
              label: l10n.m0201Reintentar,
              loading: ocupado,
              onPressed: ocupado ? null : onReintentar,
            ),
            const SizedBox(height: SolSpacing.sm),
            SolButton.tonal(
              label: l10n.m0201UsarPin,
              onPressed: ocupado ? null : onUsarPin,
            ),
          ],
        ),
      ),
    );
  }
}

/// «Solventa» arriba de la tarjeta (marca, no se traduce).
class _Marca extends StatelessWidget {
  const _Marca({this.pequena = false});

  /// M02-01a la usa en 14/700; M02-01 en 16/600.
  final bool pequena;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        'Solventa',
        textAlign: TextAlign.center,
        style: context.solText.title.copyWith(
          fontSize: pequena ? 14 : 16,
          fontWeight: pequena ? FontWeight.w700 : FontWeight.w600,
          letterSpacing: pequena ? -0.35 : -0.4,
          color: context.colors.secondary,
        ),
      ),
    );
  }
}
