import '../../../../core/contrato/schema.graphql.dart';
import '../../domain/entities/consentimiento.dart';
import '../graphql/registrar_consentimiento.graphql.dart';

/// Tipo generado del contrato → entidad del dominio.
Consentimiento consentimientoDesdeGql(
  Mutation$RegistrarConsentimiento$registrarConsentimiento g,
) => Consentimiento(
  id: g.id,
  finalidad: g.finalidad,
  versionTexto: g.versionTexto,
  otorgadoEn: g.otorgadoEn,
  venceEn: g.venceEn,
  estado: estadoConsentimientoDesdeGql(g.estado),
);

/// Un valor nuevo del backend (`$unknown`) cae en el más seguro: no vigente,
/// así la app vuelve a pedir el consentimiento en vez de asumirlo.
EstadoConsentimiento estadoConsentimientoDesdeGql(
  Enum$EstadoConsentimiento e,
) => switch (e) {
  Enum$EstadoConsentimiento.VIGENTE => EstadoConsentimiento.vigente,
  Enum$EstadoConsentimiento.VENCIDO => EstadoConsentimiento.vencido,
  Enum$EstadoConsentimiento.REVOCADO => EstadoConsentimiento.revocado,
  Enum$EstadoConsentimiento.$unknown => EstadoConsentimiento.revocado,
};
