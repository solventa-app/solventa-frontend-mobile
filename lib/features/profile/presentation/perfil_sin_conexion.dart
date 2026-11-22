import 'package:flutter/material.dart';

import '../../../core/almacen/almacen_local.dart';
import '../../../core/design_system/solventa_ui.dart';
import '../../../core/l10n/l10n.dart';
import '../../claims/presentation/widgets/seccion_envio_reportes.dart';

/// G-05 · Mi perfil en modo sin conexión (HU-M05, plan 4.5 y boceto 3.8).
///
/// Solo queda activo lo que vive en el teléfono: el nombre y el estado de la
/// cuenta, y la sección «Envío de reportes». El correo y el documento no se
/// guardan en el teléfono; idioma, moneda y notificaciones push se guardan en
/// el servidor: se ven deshabilitados con «Necesita conexión».
class PerfilSinConexion extends StatelessWidget {
  const PerfilSinConexion({
    super.key,
    required this.cuenta,
    required this.idioma,
    required this.moneda,
    required this.onVerPorEnviar,
    this.onLogout,
  });

  final CuentaLocal cuenta;

  /// Código del idioma activo («ES», «EN»).
  final String idioma;
  final String moneda;
  final VoidCallback onVerPorEnviar;
  final VoidCallback? onLogout;

  String _iniciales(String nombre) {
    final partes = nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    return partes.isEmpty ? 'S' : partes;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final nombre = cuenta.nombre.trim();
    final titulo = context.solText.titleSmall;
    final apagado = colors.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.perfilTitulo,
            style: context.solText.headline.copyWith(
              color: colors.onSurface,
              letterSpacing: -0.6,
            ),
          ),
        ),
        const SizedBox(height: SolSpacing.xxs),
        Text(
          l10n.perfilSubtitulo,
          style: context.solText.body.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: SolSpacing.md),
        const SolDivider(),
        const SizedBox(height: SolSpacing.lg),
        SolCard.outlined(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SolAvatar(initials: _iniciales(nombre), size: 48),
                  const SizedBox(width: SolSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (nombre.isNotEmpty) ...[
                          Text(
                            nombre,
                            style: context.solText.title.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: SolSpacing.xs),
                        ],
                        SolStatusBadge(
                          status: SolStatus.success,
                          label: l10n.perfilActiva,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SolSpacing.md),
              const SolDivider(),
              const SizedBox(height: SolSpacing.md),
              _FilaApagada(
                titulo: l10n.perfilSinConexionDatos,
                detalle: l10n.perfilSinConexionDatosTexto,
              ),
            ],
          ),
        ),
        const SizedBox(height: SolSpacing.lg),
        SeccionEnvioReportes(onVerPorEnviar: onVerPorEnviar),
        const SizedBox(height: SolSpacing.lg),
        SolCard.outlined(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(SolIcons.language, size: 20, color: colors.primary),
                  const SizedBox(width: SolSpacing.xs),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.perfilPreferencias,
                        style: titulo.copyWith(color: colors.onSurface),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SolSpacing.sm),
              const SolDivider(),
              const SizedBox(height: SolSpacing.md),
              _FilaApagada(
                titulo: l10n.perfilIdiomaMoneda,
                detalle: l10n.perfilPreferenciasSinConexion(idioma, moneda),
              ),
              const SizedBox(height: SolSpacing.md),
              const SolDivider(),
              const SizedBox(height: SolSpacing.md),
              // Con la huella se entró: sigue activa y no depende de la red.
              MergeSemantics(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.perfilBiometria,
                            style: titulo.copyWith(color: colors.onSurface),
                          ),
                          const SizedBox(height: SolSpacing.xxs),
                          Text(
                            l10n.perfilBiometriaSinConexion,
                            style: context.solText.note.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: SolSpacing.sm),
                    ExcludeSemantics(
                      child: Icon(
                        SolIcons.fingerprint,
                        size: SolSizes.icon,
                        color: context.solColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SolSpacing.md),
              const SolDivider(),
              const SizedBox(height: SolSpacing.sm),
              MergeSemantics(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.perfilNotificacionesPush,
                            style: titulo.copyWith(color: apagado),
                          ),
                          const SizedBox(height: SolSpacing.xxs),
                          Text(
                            l10n.redNecesitaConexion,
                            style: context.solText.note.copyWith(
                              color: apagado,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: SolSpacing.sm),
                    // El valor real está en el servidor: aquí no se afirma.
                    const Switch(value: false, onChanged: null),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onLogout != null) ...[
          const SizedBox(height: SolSpacing.lg),
          SolButton.outlined(
            label: l10n.navCerrarSesion,
            icon: SolIcons.logout,
            onPressed: onLogout,
          ),
        ],
      ],
    );
  }
}

/// Una fila que necesita al servidor: texto gris y el ícono de sin conexión.
class _FilaApagada extends StatelessWidget {
  const _FilaApagada({required this.titulo, required this.detalle});

  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    final apagado = context.colors.onSurfaceVariant;
    return MergeSemantics(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: context.solText.titleSmall.copyWith(color: apagado),
                ),
                const SizedBox(height: SolSpacing.xxs),
                Text(
                  detalle,
                  style: context.solText.note.copyWith(color: apagado),
                ),
              ],
            ),
          ),
          const SizedBox(width: SolSpacing.sm),
          ExcludeSemantics(
            child: Icon(SolIcons.offline, size: 20, color: apagado),
          ),
        ],
      ),
    );
  }
}
