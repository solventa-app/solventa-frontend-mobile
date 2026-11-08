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

/// Cuenta enmascarada con su lectura para TalkBack («cuenta terminada en
/// 4821»), M04-D1.
class CuentaEnmascarada extends StatelessWidget {
  const CuentaEnmascarada({
    super.key,
    required this.cuenta,
    required this.estilo,
    this.texto,
  });

  final String cuenta;
  final TextStyle estilo;

  /// Texto alrededor de la cuenta (p. ej. «En tu cuenta {cuenta}»).
  final String Function(String cuentaVisible)? texto;

  @override
  Widget build(BuildContext context) {
    final visible = SolFormat.maskedAccountFull(cuenta);
    final semantica = SolFormat.maskedAccountSemantics(cuenta);
    final f = texto;
    return Semantics(
      label: f == null ? semantica : f(semantica),
      excludeSemantics: true,
      child: Text(f == null ? visible : f(visible), style: estilo),
    );
  }
}
