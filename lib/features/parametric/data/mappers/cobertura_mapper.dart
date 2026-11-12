import '../../../../core/contrato/schema.graphql.dart';
import '../../domain/entities/cobertura.dart';
import '../graphql/parametric.graphql.dart';

/// Tipos generados del contrato (v0.48) → entidades del dominio.
///
/// Mapeo de enums (decisión de la Fase 6, KAN-259):
/// `VUELO_RETRASO`→[TipoEventoParametrico.retrasoVuelo],
/// `VUELO_CANCELADO`→[TipoEventoParametrico.cancelacionVuelo], `CLIMA`→
/// [TipoEventoParametrico.lluvia] (las 3 variables de clima del backend
/// colapsan en un solo tipo, igual que el backend ya las colapsa);
/// `EN_PROCESO`→[EstadoPago.enProceso], `PAGADA`→[EstadoPago.pagado]. Un
/// valor nuevo y desconocido del backend (`$unknown`) cae en el valor más
/// conservador de cada enum en vez de lanzar.
TipoEventoParametrico tipoEventoParametricoDesdeGql(
  Enum$TipoEventoParametrico e,
) => switch (e) {
  Enum$TipoEventoParametrico.VUELO_RETRASO =>
    TipoEventoParametrico.retrasoVuelo,
  Enum$TipoEventoParametrico.VUELO_CANCELADO =>
    TipoEventoParametrico.cancelacionVuelo,
  Enum$TipoEventoParametrico.CLIMA => TipoEventoParametrico.lluvia,
  Enum$TipoEventoParametrico.$unknown => TipoEventoParametrico.lluvia,
};

EstadoPago estadoPagoDesdeGql(Enum$EstadoIndemnizacion e) => switch (e) {
  Enum$EstadoIndemnizacion.EN_PROCESO => EstadoPago.enProceso,
  Enum$EstadoIndemnizacion.PAGADA => EstadoPago.pagado,
  Enum$EstadoIndemnizacion.$unknown => EstadoPago.enProceso,
};

/// `Monto.valor` es un decimal en texto (nunca float); el dominio lo guarda
/// como pesos enteros, igual que el resto de la app (`SolFormat.currency`).
int montoDesdeGql(Fragment$MontoCampos g) => num.parse(g.valor).round();

Indemnizacion indemnizacionDesdeGql(Fragment$IndemnizacionCampos g) =>
    Indemnizacion(
      id: g.id,
      tipo: tipoEventoParametricoDesdeGql(g.tipo),
      referenciaEvento: g.referenciaEvento,
      detalleEvento: g.detalleEvento,
      fechaEvento: g.fechaEvento,
      pagadoEn: g.pagadoEn,
      monto: montoDesdeGql(g.monto),
      estado: estadoPagoDesdeGql(g.estado),
      metodoTransferencia: g.metodoTransferencia,
      polizaAnterior: g.polizaAnterior,
    );

/// `null` sin cobertura paramétrica vigente (CA de Fase 5). Sin `saldo`: el
/// backend no tiene ningún ajuste de prima (M04-D4 ya lo excluía igual).
ResumenCobertura resumenCoberturaDesdeGql(
  Query$MiCoberturaParametrica$miCoberturaParametrica g,
) => ResumenCobertura(
  producto: g.producto,
  numeroPoliza: g.numeroPoliza,
  vigente: g.vigente,
  vigenteHasta: g.vigenteHasta,
  tope: montoDesdeGql(g.tope),
  movimientos: g.movimientos.map(indemnizacionDesdeGql).toList(),
);
