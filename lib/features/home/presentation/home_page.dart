import 'package:flutter/material.dart';

import '../../../core/design_system/solventa_ui.dart';
import '../../../core/l10n/l10n.dart';
import '../../onboarding/domain/entities/verificacion_identidad.dart';

/// G-03 · Home del cliente.
///
/// Soporta todos los estados del recorrido de onboarding:
/// - Sin verificar (`verificacion == null`): muestra la tarjeta «Completa tu
///   registro para activar tu cuenta». Si [userName] está vacío (aún no se ha
///   extraído por OCR), saluda con «Bienvenido a Solventa»; si se pasa
///   [userName], saluda con «Hola, {userName}».
/// - `EstadoVerificacion.enRevision`: muestra la tarjeta de revisión en curso y
///   el botón para consultar estado.
/// - `EstadoVerificacion.rechazada`: muestra el motivo del rechazo y el botón
///   para reintentar verificación.
/// - `EstadoVerificacion.verificada`: saluda con «Hola, {userName}» y muestra
///   la insignia de identidad verificada.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.userName,
    required this.onCompleteRegistration,
    required this.onRequestAssistance,
    this.onReportClaim,
    this.onMyClaims,
    this.verificacion,
    this.motivoRechazo,
    this.onCheckStatus,
    this.onOpenProfile,
  });

  final String userName;
  final VoidCallback onCompleteRegistration;
  final VoidCallback onRequestAssistance;

  /// HU-M05: entrada al reporte de siniestro. Sin ella no se muestra.
  final VoidCallback? onReportClaim;

  /// HU-M05: los siniestros que reportó y su estado (M05-06).
  final VoidCallback? onMyClaims;
  final EstadoVerificacion? verificacion;
  final String? motivoRechazo;
  final VoidCallback? onCheckStatus;
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sol = context.solColors;
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);

    final tieneNombre = userName.trim().isNotEmpty;
    final saludo = tieneNombre
        ? (l10n?.homeSaludoHola(userName.trim()) ?? 'Hola, ${userName.trim()}')
        : (l10n?.homeSaludoBienvenida ?? 'Bienvenido a Solventa');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        SolSpacing.screen,
        SolSpacing.xl,
        SolSpacing.screen,
        SolSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              saludo,
              // El Figma aplica -0,6 solo a este saludo (2001:183).
              style: context.solText.headline.copyWith(
                color: colors.onSurface,
                letterSpacing: -0.6,
              ),
            ),
          ),
          const SizedBox(height: SolSpacing.lg),
          switch (verificacion) {
            EstadoVerificacion.enRevision => SolCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          SolIcons.inReview,
                          size: SolSizes.icon,
                          color: sol.warning,
                        ),
                      ),
                      const SizedBox(width: SolSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n?.homeEnRevisionTitulo ??
                              'Estamos revisando tu identidad',
                          style: context.solText.titleSmall.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.xs),
                  Text(
                    l10n?.homeEnRevisionTexto ?? 'Validamos tus documentos y prueba de vida con nuestro proveedor KYC/AML. Te avisaremos apenas esté lista.',
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const _AvisoAcceso(verificada: false),
                  const SizedBox(height: SolSpacing.lg),
                  SolButton.tonal(
                    label: l10n?.homeEnRevisionBoton ?? 'Consultar estado',
                    onPressed: onCheckStatus ?? onCompleteRegistration,
                  ),
                ],
              ),
            ),
            EstadoVerificacion.rechazada => SolCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          SolIcons.failure,
                          size: SolSizes.icon,
                          color: colors.error,
                        ),
                      ),
                      const SizedBox(width: SolSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n?.homeRechazadaTitulo ??
                              'No pudimos verificar tu identidad',
                          style: context.solText.titleSmall.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.xs),
                  Text(
                    motivoRechazo ??
                        l10n?.m0107cMensaje ??
                        'No pudimos verificar tu documento (imagen ilegible)',
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const _AvisoAcceso(verificada: false),
                  const SizedBox(height: SolSpacing.lg),
                  SolButton.primary(
                    label:
                        l10n?.homeRechazadaBoton ?? 'Reintentar verificación',
                    onPressed: onCompleteRegistration,
                  ),
                ],
              ),
            ),
            EstadoVerificacion.verificada => SolCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          SolIcons.verifiedProvider,
                          size: SolSizes.icon,
                          color: sol.success,
                        ),
                      ),
                      const SizedBox(width: SolSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n?.homeVerificadaTitulo ?? 'Identidad verificada',
                          style: context.solText.titleSmall.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.xs),
                  Text(
                    l10n?.homeVerificadaTexto ?? 'Tu cuenta está activa y protegida con validación biométrica.',
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const _AvisoAcceso(verificada: true),
                  if (onOpenProfile != null) ...[
                    const SizedBox(height: SolSpacing.md),
                    SolButton.tonal(
                      label: l10n?.navPerfil ?? 'Mi perfil',
                      icon: SolIcons.profile,
                      onPressed: onOpenProfile,
                    ),
                  ],
                ],
              ),
            ),
            null => SolCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          SolIcons.pendingRegistration,
                          size: SolSizes.icon,
                          color: sol.warning,
                        ),
                      ),
                      const SizedBox(width: SolSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n?.homePendienteTexto ??
                              'Completa tu registro para activar tu cuenta',
                          style: context.solText.body.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.lg),
                  SolButton.primary(
                    label: l10n?.homePendienteBoton ?? 'Completar registro',
                    onPressed: onCompleteRegistration,
                  ),
                ],
              ),
            ),
          },
          const SizedBox(height: SolSpacing.lg),
          SolActionTile(
            icon: SolIcons.assistanceActive,
            title: l10n?.homeAsistenciaTile ?? 'Solicitar asistencia en sitio',
            onTap: onRequestAssistance,
          ),
          if (onReportClaim case final reportar?) ...[
            const SizedBox(height: SolSpacing.sm),
            SolActionTile(
              icon: SolIcons.camera,
              title: l10n?.homeReportarTile ?? 'Reportar un siniestro',
              onTap: reportar,
            ),
          ],
          if (onMyClaims case final misSiniestros?) ...[
            const SizedBox(height: SolSpacing.sm),
            SolActionTile(
              icon: SolIcons.success,
              title: l10n?.homeMisSiniestrosTile ?? 'Mis siniestros',
              onTap: misSiniestros,
            ),
          ],
          const SizedBox(height: SolSpacing.xl),
          SolInlineNote(
            icon: SolIcons.wallet,
            text:
                l10n?.homeBilleteraNota ??
                'Billetera y estado de póliza — próximamente',
            center: true,
          ),
        ],
      ),
    );
  }
}

/// Aviso de acceso (T15): una cuenta creada en la app entra a la app mientras
/// no verifique su identidad; al verificar, entra también a la web con el
/// mismo correo y clave. Sin los textos del idioma activo no muestra nada.
class _AvisoAcceso extends StatelessWidget {
  const _AvisoAcceso({required this.verificada});

  final bool verificada;

  @override
  Widget build(BuildContext context) {
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (l10n == null) return const SizedBox.shrink();
    return SolInlineNote(
      icon: SolIcons.info,
      text: verificada ? l10n.homeVerificadaWeb : l10n.homeSoloAppAviso,
    );
  }
}
