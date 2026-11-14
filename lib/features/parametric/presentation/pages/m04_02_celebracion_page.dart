import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/cobertura.dart';
import '../providers.dart';
import '../widgets/cobertura_widgets.dart';

/// M04-02 · Celebración (Figma 2005:301, KAN-139).
///
/// El monto va en COP (pendiente 2: moneda de la barra). Sin navegación
/// (M04-D2): «Ver detalle» y la flecha llaman callbacks.
class M0402CelebracionPage extends ConsumerWidget {
  const M0402CelebracionPage({
    super.key,
    required this.id,
    this.onBack,
    this.onVerDetalle,
  });

  final String id;
  final VoidCallback? onBack;
  final VoidCallback? onVerDetalle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detalle = ref.watch(indemnizacionProvider(id));

    final cuerpo = switch (detalle) {
      AsyncData(value: Exito(:final valor)) => _Celebracion(
        indemnizacion: valor,
        onVerDetalle: onVerDetalle,
      ),
      AsyncData(value: Fracaso(:final falla)) => ErrorConReintento(
        texto: l10n.falla(falla),
        onReintentar: () => ref.invalidate(indemnizacionProvider(id)),
      ),
      _ => SolLoadingState(message: l10n.m0402Cargando, center: true),
    };

    final frame = SolScreenFrame(
      topBar: SolTopBar.flow(
        title: l10n.m0402Titulo,
        onBack: onBack,
        showBack: onBack != null,
      ),
      centerBody: true,
      body: cuerpo,
    );
    if (onBack == null) return frame;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onBack!();
      },
      child: frame,
    );
  }
}

class _Celebracion extends StatelessWidget {
  const _Celebracion({required this.indemnizacion, required this.onVerDetalle});

  final Indemnizacion indemnizacion;
  final VoidCallback? onVerDetalle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sol = context.solColors;
    final monto = l10n.m0402Monto(SolFormat.currency(indemnizacion.monto));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Decorativo: fuera del recorrido de foco (CA de KAN-139).
        ExcludeSemantics(
          child: Center(
            child: SizedBox(
              width: 120,
              height: 112,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CirculoIcono(
                    icono: SolIcons.celebration,
                    fondo: sol.successContainer,
                    color: sol.success,
                    diametro: 96,
                    tamano: 48,
                  ),
                  PositionedDirectional(
                    top: 0,
                    end: 4,
                    child: _Punto(
                      color: sol.success.withValues(alpha: 0.4),
                      diametro: 12,
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 0,
                    start: 2,
                    child: _Punto(
                      color: colors.secondary.withValues(alpha: 0.3),
                      diametro: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: SolSpacing.xl),
        Semantics(
          header: true,
          child: Text(
            l10n.m0402Mensaje,
            textAlign: TextAlign.center,
            style: context.solText.title.copyWith(color: colors.onSurface),
          ),
        ),
        const SizedBox(height: SolSpacing.sm),
        // Sin maxLines: si la cifra es larga, el bloque crece en alto.
        Semantics(
          label: monto,
          excludeSemantics: true,
          child: Text(
            monto,
            textAlign: TextAlign.center,
            style: context.solText.headline.copyWith(color: sol.success),
          ),
        ),
        const SizedBox(height: SolSpacing.xs),
        Center(
          child: MetodoPago(
            metodo: indemnizacion.metodoTransferencia,
            estilo: textoPequeno(context)
                .copyWith(color: colors.onSurfaceVariant),
            texto: l10n.m0402Cuenta,
            semantica: l10n.m0402CuentaSemantica,
          ),
        ),
        const SizedBox(height: SolSpacing.xxxl),
        SolButton.primary(
          label: l10n.m0402VerDetalle,
          onPressed: () => onVerDetalle?.call(),
        ),
      ],
    );
  }
}

class _Punto extends StatelessWidget {
  const _Punto({required this.color, required this.diametro});

  final Color color;
  final double diametro;

  @override
  Widget build(BuildContext context) => Container(
    width: diametro,
    height: diametro,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
