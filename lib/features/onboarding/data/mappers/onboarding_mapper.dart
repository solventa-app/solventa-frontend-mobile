import '../../../../core/contrato/schema.graphql.dart';
import '../../domain/entities/onboarding.dart';
import '../graphql/onboarding.graphql.dart';

/// Tipo generado del contrato → entidad del dominio.
Onboarding onboardingDesdeGql(Fragment$OnboardingCampos g) => Onboarding(
  id: g.id,
  estado: estadoOnboardingDesdeGql(g.estado),
  motivo: switch (g.motivo) {
    null => null,
    Enum$MotivoOnboarding.$unknown => 'DESCONOCIDO',
    final m => m.name,
  },
  intento: g.intento,
  intentosRestantes: g.intentosRestantes,
);

/// Un estado nuevo del backend (`$unknown`) cae en «en revisión»: la app no
/// promete un resultado que no conoce ni pide repetir las capturas.
EstadoOnboarding estadoOnboardingDesdeGql(Enum$EstadoOnboarding e) =>
    switch (e) {
      Enum$EstadoOnboarding.INICIADO => EstadoOnboarding.iniciado,
      Enum$EstadoOnboarding.EN_VERIFICACION => EstadoOnboarding.enVerificacion,
      Enum$EstadoOnboarding.VERIFICADA => EstadoOnboarding.verificada,
      Enum$EstadoOnboarding.RECHAZADA => EstadoOnboarding.rechazada,
      Enum$EstadoOnboarding.EN_REVISION => EstadoOnboarding.enRevision,
      Enum$EstadoOnboarding.$unknown => EstadoOnboarding.enRevision,
    };

Enum$PasoOnboarding pasoAGql(PasoOnboarding p) => switch (p) {
  PasoOnboarding.anverso => Enum$PasoOnboarding.ANVERSO,
  PasoOnboarding.reverso => Enum$PasoOnboarding.REVERSO,
  PasoOnboarding.rostro => Enum$PasoOnboarding.ROSTRO,
  PasoOnboarding.video => Enum$PasoOnboarding.VIDEO,
};

CodigoOnboarding codigoOnboardingDesdeGql(Fragment$CodigoOnboardingCampos g) =>
    CodigoOnboarding(
      correoEnmascarado: g.correoEnmascarado,
      expiraEn: g.venceEn.toIso8601String(),
      intentosRestantes: 5,
      verificado: true,
    );

PerfilUsuario perfilUsuarioDesdeGql(Fragment$UsuarioCampos g) => PerfilUsuario(
  id: g.id,
  usuario: g.usuario,
  nombre: g.nombre,
  rol: g.rol.name,
  estado: g.estado.name,
  documentoEnmascarado: g.documentoEnmascarado,
  correo: g.correo,
  creadoEn: g.creadoEn.toIso8601String(),
  idioma: g.idioma,
  moneda: g.moneda,
);
