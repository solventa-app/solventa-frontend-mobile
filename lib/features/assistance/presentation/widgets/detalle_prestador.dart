import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/prestador.dart';

/// Ícono del tipo de prestador (el mismo del pin y de la fila).
IconData iconoTipoPrestador(TipoPrestador t) => switch (t) {
  TipoPrestador.medico => SolIcons.medical,
  TipoPrestador.mecanico => SolIcons.mechanic,
  TipoPrestador.grua => SolIcons.towTruck,
};

/// Detalle del prestador al tocar su pin (HU-M06, 2.2). Va en una hoja modal
/// (`SolBottomSheet.show`), no en el globo del mapa. Al cerrarla el pin sigue
/// seleccionado. TalkBack lee juntos el encabezado, el tipo y la llegada.
class DetallePrestador extends StatelessWidget {
  const DetallePrestador({
    super.key,
    required this.cercano,
    required this.destacado,
    required this.tipo,
    required this.onSolicitar,
    required this.onComoLlegar,
    this.tiempo,
  });

  /// Tiempo ya formateado (de la ruta, M15, o aproximado con «~»). Sin él, el
  /// de Haversine.
  final String? tiempo;

  final PrestadorCercano cercano;

  /// De los 3 más cercanos: tiempo exacto; si no, con «~».
  final bool destacado;

  /// Tipo ya traducido («Centro médico», «Grúa»).
  final String tipo;
  final VoidCallback onSolicitar;
  final VoidCallback onComoLlegar;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final p = cercano.prestador;
    final (Color fondo, Color frente) = solProviderColors(context, p.aliado);
    final haversine = SolFormat.minutes(cercano.minutosEstimados);
    final llegada = l10n.m0601DetalleLlegada(
      SolFormat.distanceKm(cercano.distanciaKm),
      tiempo ?? (destacado ? haversine : l10n.m0601Aproximado(haversine)),
    );
    final textoNota = context.solText.body.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolPhotoBanner(
          photoUrl: p.fotoUrl,
          placeholderIcon: iconoTipoPrestador(p.tipo),
        ),
        const SizedBox(height: SolSpacing.md),
        MergeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SolCard.outlined(
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: Container(
                        width: SolSizes.providerIcon,
                        height: SolSizes.providerIcon,
                        decoration: BoxDecoration(
                          color: fondo,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconoTipoPrestador(p.tipo),
                          size: 22,
                          fill: 1,
                          color: frente,
                        ),
                      ),
                    ),
                    const SizedBox(width: SolSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.nombre,
                            style: context.solText.title.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                          if (p.aliado)
                            Row(
                              children: [
                                Icon(
                                  SolIcons.verifiedProvider,
                                  size: 14,
                                  fill: 1,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: SolSpacing.xs),
                                Flexible(
                                  child: Text(
                                    l10n.m0601Aliado,
                                    style: context.solText.labelStrong.copyWith(
                                      color: colors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SolSpacing.md),
              Text(
                p.especialidad.isEmpty
                    ? tipo
                    : l10n.m0601DetalleTipo(tipo, p.especialidad),
                style: textoNota,
              ),
              const SizedBox(height: SolSpacing.xs),
              Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      SolIcons.schedule,
                      size: 18,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(width: SolSpacing.sm),
                  Expanded(
                    child: Text(
                      llegada,
                      style: context.solText.body.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (p.direccion.isNotEmpty) ...[
          const SizedBox(height: SolSpacing.md),
          Semantics(
            hint: l10n.m0601CopiarDireccion,
            child: GestureDetector(
              onLongPress: () async {
                await Clipboard.setData(ClipboardData(text: p.direccion));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.m0601DireccionCopiada)),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(SolSpacing.md),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: SolRadius.fieldAll,
                ),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        SolIcons.location,
                        size: 18,
                        fill: 1,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: SolSpacing.sm),
                    Expanded(
                      child: Text(
                        p.direccion,
                        style: context.solText.body.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (p.horario != null) ...[
          const SizedBox(height: SolSpacing.sm),
          Text(p.horario!, style: textoNota),
        ],
        const SizedBox(height: SolSpacing.lg),
        SolButton.primary(
          label: l10n.m0601SolicitarAsistencia,
          onPressed: onSolicitar,
        ),
        const SizedBox(height: SolSpacing.sm),
        SolButton.tonal(
          label: l10n.m0601ComoLlegarBoton,
          onPressed: onComoLlegar,
        ),
      ],
    );
  }
}
