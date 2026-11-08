import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/calculo_cobertura.dart';
import '../../domain/entities/cobertura.dart';
import '../providers.dart';
import '../widgets/cobertura_widgets.dart';

/// M04-04 · Mi cobertura (KAN-280). Sin frame en Figma: sigue los mockups de
/// `docs/hu-m04/diseno/` (sin saldo, saldo a favor y saldo en contra).
///
/// Sin navegación todavía (M04-D2): la flecha y las filas llaman callbacks.
class M0404CoberturaPage extends ConsumerWidget {
  const M0404CoberturaPage({super.key, this.onBack, this.onTapMovimiento});

  final VoidCallback? onBack;

  /// Recibe el id de la indemnización (irá a M04-03).
  final ValueChanged<String>? onTapMovimiento;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final resumen = ref.watch(resumenCoberturaProvider);

    final cuerpo = switch (resumen) {
      AsyncData(value: Exito(:final valor)) => _Resumen(
        resumen: valor,
        onTapMovimiento: onTapMovimiento,
      ),
      AsyncData(value: Fracaso(:final falla)) => ErrorConReintento(
        texto: l10n.falla(falla),
        onReintentar: () => ref.invalidate(resumenCoberturaProvider),
      ),
      _ => SolLoadingState(message: l10n.m0404Cargando),
    };

    return SolFlowScaffold(
      title: l10n.m0404Titulo,
      onBack: onBack,
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(resumenCoberturaProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [cuerpo],
        ),
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({required this.resumen, required this.onTapMovimiento});

  final ResumenCobertura resumen;
  final ValueChanged<String>? onTapMovimiento;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final hayPagos = resumen.movimientos.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TarjetaCupo(resumen: resumen),
        const SizedBox(height: SolSpacing.md),
        if (hayPagos) ...[
          _TarjetaTotal(resumen: resumen),
          const SizedBox(height: SolSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SolSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.m0404Movimientos,
                      style: context.solText.titleSmall.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
                Text(
                  l10n.m0404Pagos(resumen.movimientos.length),
                  style: textoPequeno(context)
                      .copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: SolSpacing.md),
          _ListaMovimientos(
            movimientos: resumen.movimientos,
            onTap: onTapMovimiento,
          ),
        ] else
          SolInlineNote(text: l10n.m0404Vacio, center: true),
        const SizedBox(height: SolSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SolSpacing.xs),
          child: Text(
            l10n.m0404Nota,
            style: context.solText.note.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

/// Cupo de cobertura: póliza, tope, barra de uso y disponible.
class _TarjetaCupo extends StatelessWidget {
  const _TarjetaCupo({required this.resumen});

  final ResumenCobertura resumen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final variante = textoPequeno(context)
        .copyWith(color: colors.onSurfaceVariant);
    final porcentaje = l10n.m0404PorcentajeUsado(resumen.porcentajeUsado);
    return SolCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const CirculoIcono(icono: SolIcons.flight),
              const SizedBox(width: SolSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.m0404Producto(
                        resumen.producto,
                        resumen.vigente ? l10n.m0404Vigente : l10n.m0404Vencida,
                      ),
                      style: context.solText.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: SolSpacing.xxs),
                    Text(
                      l10n.m0404Poliza(
                        resumen.numeroPoliza,
                        SolFormat.date(resumen.vigenteHasta),
                      ),
                      style: variante,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: SolDivider(),
          ),
          Text(l10n.m0404Tope, style: variante),
          const SizedBox(height: SolSpacing.xxs),
          Text(
            SolFormat.currency(resumen.tope),
            style: context.solText.headline.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: SolSpacing.md),
          Semantics(
            container: true,
            label: porcentaje,
            excludeSemantics: true,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: SolRadius.fullAll,
                border: Border.all(color: colors.outline),
              ),
              child: ClipRRect(
                borderRadius: SolRadius.fullAll,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: resumen.fraccionUsada,
                    heightFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: SolRadius.fullAll,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.sm),
          // Con texto grande el disponible pasa debajo del porcentaje.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: SolSpacing.sm,
            runSpacing: SolSpacing.sm,
            children: [
              ExcludeSemantics(child: Text(porcentaje, style: variante)),
              MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(l10n.m0404Disponible, style: variante),
                    const SizedBox(height: SolSpacing.xxs),
                    Text(
                      SolFormat.currency(resumen.disponible),
                      style: context.solText.titleSmall.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Total indemnizado, cuenta de depósito y, si hay, el saldo de prima.
class _TarjetaTotal extends StatelessWidget {
  const _TarjetaTotal({required this.resumen});

  final ResumenCobertura resumen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sol = context.solColors;
    final variante = textoPequeno(context)
        .copyWith(color: colors.onSurfaceVariant);
    final desde = resumen.desde;
    final saldo = resumen.saldo;
    return SolCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MergeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.m0404TotalIndemnizado, style: variante),
                      const SizedBox(height: SolSpacing.xxs),
                      Text(
                        SolFormat.currency(resumen.totalIndemnizado),
                        style: context.solText.headline.copyWith(
                          color: sol.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CirculoIcono(
                icono: SolIcons.payments,
                fondo: sol.successContainer,
                color: sol.success,
              ),
            ],
          ),
          if (desde != null) ...[
            const SizedBox(height: SolSpacing.sm),
            Text(
              l10n.m0404TotalDetalle(
                resumen.movimientos.length,
                SolFormat.monthYear(desde),
              ),
              style: variante.copyWith(height: 1.45),
            ),
          ],
          const SizedBox(height: SolSpacing.md),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SolStatusBadge(
              status: SolStatus.success,
              label: l10n.m0404Depositado(
                SolFormat.maskedAccountFull(resumen.cuentaDestino),
              ),
            ),
          ),
          if (saldo != null) ...[
            const SizedBox(height: 14),
            _BloqueSaldo(saldo: saldo),
          ],
        ],
      ),
    );
  }
}

/// Saldo de prima: verde a favor, rojo en contra. El signo y el ícono van
/// siempre, no solo el color.
class _BloqueSaldo extends StatelessWidget {
  const _BloqueSaldo({required this.saldo});

  final SaldoPrima saldo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sol = context.solColors;
    final monto = SolFormat.currency(saldo.monto.abs());
    final mes = SolFormat.monthName(saldo.periodo);
    final (fondo, color, icono, titulo, detalle) = saldo.aFavor
        ? (
            sol.successContainer,
            sol.success,
            SolIcons.success,
            l10n.m0404SaldoFavor(monto),
            l10n.m0404SaldoFavorDetalle(mes),
          )
        : (
            colors.errorContainer,
            colors.error,
            SolIcons.error,
            l10n.m0404SaldoContra(monto),
            l10n.m0404SaldoContraDetalle(mes),
          );
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SolSpacing.md,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: SolRadius.fieldAll,
        ),
        child: Row(
          children: [
            ExcludeSemantics(child: Icon(icono, size: 20, color: color)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: context.solText.titleSmall.copyWith(color: color),
                  ),
                  Text(
                    detalle,
                    style: textoPequeno(context)
                        .copyWith(color: color, height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaMovimientos extends StatelessWidget {
  const _ListaMovimientos({required this.movimientos, required this.onTap});

  final List<Indemnizacion> movimientos;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: SolRadius.cardAll,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < movimientos.length; i++) ...[
            if (i > 0) const SolDivider(),
            _FilaMovimiento(movimiento: movimientos[i], onTap: onTap),
          ],
        ],
      ),
    );
  }
}

class _FilaMovimiento extends StatelessWidget {
  const _FilaMovimiento({required this.movimiento, required this.onTap});

  final Indemnizacion movimiento;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sol = context.solColors;
    final m = movimiento;
    final pagado = m.estado == EstadoPago.pagado;
    final estadoColor = pagado ? sol.success : sol.warning;
    // Con texto grande (más de 130 %) el monto no cabe al lado del título:
    // pasa debajo, alineado al inicio.
    final apilar = MediaQuery.textScalerOf(context).scale(10) > 13;

    final monto = Text(
      SolFormat.currency(m.monto),
      style: context.solText.titleSmall.copyWith(color: colors.onSurface),
    );
    final estado = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          pagado ? SolIcons.success : SolIcons.schedule,
          size: 14,
          color: estadoColor,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            pagado ? l10n.m0404Pagado : l10n.m0404EnProceso,
            style: context.solText.labelStrong.copyWith(color: estadoColor),
          ),
        ),
      ],
    );
    final textos = <Widget>[
      Text(
        tituloEvento(l10n, m),
        style: context.solText.body.copyWith(
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
        ),
      ),
      const SizedBox(height: SolSpacing.xxs),
      Text(
        l10n.m0404Meta(SolFormat.date(m.fechaEvento), detalleEvento(l10n, m)),
        style: textoPequeno(context).copyWith(color: colors.onSurfaceVariant),
      ),
      if (apilar) ...[
        const SizedBox(height: SolSpacing.xs),
        monto,
        const SizedBox(height: 3),
        estado,
      ],
    ];

    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap == null ? null : () => onTap!(m.id),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                SolSpacing.lg,
                14,
                SolSpacing.md,
                14,
              ),
              child: Row(
                children: [
                  CirculoIcono(icono: iconoEvento(m.tipo)),
                  const SizedBox(width: SolSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: textos,
                    ),
                  ),
                  if (!apilar) ...[
                    const SizedBox(width: SolSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [monto, const SizedBox(height: 3), estado],
                    ),
                  ],
                  const SizedBox(width: SolSpacing.xs),
                  ExcludeSemantics(
                    child: Icon(
                      SolIcons.chevronRight,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
