import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/cobertura.dart';

/// 12/400 (texto secundario de los mockups de HU-M04).
TextStyle textoPequeno(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!;

/// Ícono del tipo de evento: avión para vuelos, tormenta para lluvia.
IconData iconoEvento(TipoEventoParametrico tipo) => switch (tipo) {
  TipoEventoParametrico.retrasoVuelo ||
  TipoEventoParametrico.cancelacionVuelo => SolIcons.flight,
  TipoEventoParametrico.lluvia => SolIcons.thunderstorm,
};

/// «Retraso de vuelo AV204», «Lluvia sobre el umbral».
String tituloEvento(AppLocalizations l10n, Indemnizacion m) => switch (m.tipo) {
  TipoEventoParametrico.retrasoVuelo => l10n.m04EventoRetrasoVuelo(
    m.referenciaEvento,
  ),
  TipoEventoParametrico.cancelacionVuelo => l10n.m04EventoCancelacionVuelo(
    m.referenciaEvento,
  ),
  TipoEventoParametrico.lluvia => l10n.m04EventoLluvia,
};

/// «+3h40», «Bogotá, 62 mm» o «póliza anterior».
String detalleEvento(AppLocalizations l10n, Indemnizacion m) {
  if (m.polizaAnterior) return l10n.m0404PolizaAnterior;
  return switch (m.tipo) {
    TipoEventoParametrico.lluvia => l10n.m04DetalleLluvia(
      m.referenciaEvento,
      m.detalleEvento,
    ),
    _ => m.detalleEvento,
  };
}

/// Círculo de 36 dp con un ícono de 20 (mockups de M04-04 y Figma M04-03).
class CirculoIcono extends StatelessWidget {
  const CirculoIcono({
    super.key,
    required this.icono,
    this.fondo,
    this.color,
    this.diametro = 36,
    this.tamano = 20,
  });

  final IconData icono;
  final Color? fondo;
  final Color? color;
  final double diametro;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: diametro,
        height: diametro,
        decoration: BoxDecoration(
          color: fondo ?? context.solColors.navIndicator,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icono,
          size: tamano,
          fill: 1,
          color: color ?? context.colors.primary,
        ),
      ),
    );
  }
}

/// Error con «Reintentar» (mismo patrón que M05-06).
class ErrorConReintento extends StatelessWidget {
  const ErrorConReintento({
    super.key,
    required this.texto,
    required this.onReintentar,
  });

  final String texto;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SolInlineNote(text: texto),
        SolButton.text(
          label: context.l10n.m04Reintentar,
          onPressed: onReintentar,
        ),
      ],
    );
  }
}

/// Método de transferencia del pago: nunca un número de cuenta real (regla
/// #6 del backend). No se renderiza nada si el backend no lo informa.
class MetodoPago extends StatelessWidget {
  const MetodoPago({
    super.key,
    required this.metodo,
    required this.estilo,
    required this.texto,
    this.semantica,
  });

  final String? metodo;
  final TextStyle estilo;

  /// Texto alrededor del método (p. ej. «Pagado por {metodo}»).
  final String Function(String metodo) texto;

  /// Lectura para TalkBack; por defecto, la misma que [texto].
  final String Function(String metodo)? semantica;

  @override
  Widget build(BuildContext context) {
    final m = metodo;
    if (m == null) return const SizedBox.shrink();
    final s = semantica;
    return Semantics(
      label: s == null ? texto(m) : s(m),
      excludeSemantics: true,
      child: Text(texto(m), style: estilo),
    );
  }
}
