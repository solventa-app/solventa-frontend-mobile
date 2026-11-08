import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/cobertura.dart';
import '../providers.dart';
import '../widgets/cobertura_widgets.dart';

/// M04-03 · Detalle de la indemnización (Figma 2005:217, KAN-146).
///
/// Avance preliminar: sigue el frame de Figma. Faltan la fuente del evento, el
/// umbral, el desglose del cálculo y la referencia para soporte que pide Jira
/// (pendiente 1 de `docs/hu-m04/README.md`). Sin navegación (M04-D2).
class M0403DetalleIndemnizacionPage extends ConsumerWidget {
  const M0403DetalleIndemnizacionPage({
    super.key,
    required this.id,
    this.onBack,
    this.onCerrar,
  });

  final String id;
  final VoidCallback? onBack;
  final VoidCallback? onCerrar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detalle = ref.watch(indemnizacionProvider(id));

    final cuerpo = switch (detalle) {
      AsyncData(value: Exito(:final valor)) => _Detalle(indemnizacion: valor),
      AsyncData(value: Fracaso(:final falla)) => ErrorConReintento(
        texto: l10n.falla(falla),
        onReintentar: () => ref.invalidate(indemnizacionProvider(id)),
      ),
      _ => SolLoadingState(message: l10n.m0402Cargando),
    };

    return SolFlowScaffold(
      title: l10n.m0403Titulo,
      onBack: onBack,
      body: cuerpo,
      actions: [
        SolButton.primary(
          label: l10n.m0403Cerrar,
          onPressed: () => onCerrar?.call(),
        ),
      ],
    );
  }
}

class _Detalle extends StatelessWidget {
  const _Detalle({required this.indemnizacion});

  final Indemnizacion indemnizacion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final m = indemnizacion;
    final valor = context.solText.titleSmall.copyWith(color: colors.onSurface);
    final evento = switch (m.tipo) {
      TipoEventoParametrico.retrasoVuelo => l10n.m0403EventoRetrasoVuelo(
        m.referenciaEvento,
        m.detalleEvento,
      ),
      TipoEventoParametrico.cancelacionVuelo =>
        l10n.m0403EventoCancelacionVuelo(m.referenciaEvento),
      TipoEventoParametrico.lluvia => l10n.m0403EventoLluvia(
        m.referenciaEvento,
        m.detalleEvento,
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CirculoIcono(icono: iconoEvento(m.tipo), diametro: 32),
                  const SizedBox(width: SolSpacing.md),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        evento,
                        style: context.solText.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SolSpacing.md),
              const SolDivider(),
              _FilaDato(
                etiqueta: l10n.m0403Indemnizacion,
                valor: Text(
                  SolFormat.currency(m.monto),
                  style: context.solText.title.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              const SolDivider(),
              _FilaDato(
                etiqueta: l10n.m0403FechaEvento,
                valor: Text(SolFormat.date(m.fechaEvento), style: valor),
              ),
              const SolDivider(),
              _FilaDato(
                etiqueta: l10n.m0403FechaPago,
                valor: Text(SolFormat.dateTime(m.pagadoEn), style: valor),
              ),
              const SolDivider(),
              _FilaDato(
                etiqueta: l10n.m0403Cuenta,
                valor: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        SolIcons.bank,
                        size: 18,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: SolSpacing.xs),
                    Flexible(
                      child: CuentaEnmascarada(
                        cuenta: m.cuentaDestino,
                        estilo: valor,
                      ),
                    ),
                  ],
                ),
                ultima: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: SolSpacing.lg),
        Center(
          child: SolStatusBadge(
            status: SolStatus.success,
            label: l10n.m0403Automatico,
          ),
        ),
      ],
    );
  }
}

/// Etiqueta a la izquierda y valor a la derecha. Si no caben en una línea
/// (texto al 200 %), el valor pasa debajo de la etiqueta (CA adaptativo de
/// KAN-146).
class _FilaDato extends StatelessWidget {
  const _FilaDato({
    required this.etiqueta,
    required this.valor,
    this.ultima = false,
  });

  final String etiqueta;
  final Widget valor;
  final bool ultima;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Padding(
        padding: EdgeInsets.only(
          top: SolSpacing.lg,
          bottom: ultima ? SolSpacing.xs : SolSpacing.lg,
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: SolSpacing.lg,
          runSpacing: SolSpacing.xs,
          children: [
            Text(
              etiqueta,
              style: context.solText.body.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            valor,
          ],
        ),
      ),
    );
  }
}
