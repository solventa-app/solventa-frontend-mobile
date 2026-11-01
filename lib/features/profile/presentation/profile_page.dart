import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/solventa_ui.dart';
import '../../../core/l10n/l10n.dart';
import '../../onboarding/domain/entities/onboarding.dart';
import '../../onboarding/presentation/onboarding_notifier.dart';
import '../../onboarding/presentation/providers.dart';

/// G-05 · Mi perfil (equivalente móvil de `MiPerfil.vue` en `solventa-frontend-web`).
///
/// Muestra los datos reales del usuario (`yo`): nombre, correo/usuario, rol,
/// documento enmascarado, estado de la cuenta, fecha de registro y preferencias
/// de idioma (`ES`/`EN`) y moneda (`COP`, `MXN`, `BRL`, `CLP`, `PEN`, `USD`, `EUR`).
/// Incluye el botón para cerrar sesión con modal de confirmación (`G-04`).
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, this.onLogout, this.enShell = false});

  final VoidCallback? onLogout;
  final bool enShell;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _cargando = false;
  bool _guardandoPreferencias = false;
  bool _preferenciasGuardadas = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_cargar);
  }

  Future<void> _cargar() async {
    if (!mounted) return;
    setState(() => _cargando = true);
    await ref.read(onboardingProvider.notifier).cargarPerfilYEstado();
    if (mounted) setState(() => _cargando = false);
  }

  Future<void> _guardarPreferencias(String idioma, String moneda) async {
    setState(() {
      _guardandoPreferencias = true;
      _preferenciasGuardadas = false;
    });
    await ref
        .read(onboardingRepositoryProvider)
        .actualizarPreferencias(idioma: idioma, moneda: moneda);
    await ref.read(onboardingProvider.notifier).cargarPerfilYEstado();
    if (!mounted) return;
    setState(() {
      _guardandoPreferencias = false;
      _preferenciasGuardadas = true;
    });
  }

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
    final estado = ref.watch(onboardingProvider);
    final locale = ref.watch(localeProvider);
    final moneda = ref.watch(monedaProvider);

    final PerfilUsuario? perfil = estado.perfil;
    final nombreMostrado = (perfil?.nombre?.trim().isNotEmpty ?? false)
        ? perfil!.nombre!.trim()
        : l10n.perfilNombrePendiente;
    final correoMostrado = perfil?.usuario ?? estado.correoPendiente ?? '—';
    final verificado =
        (perfil?.verificado ?? false) ||
        estado.onboarding?.estado == EstadoOnboarding.verificada;
    // Sin documento de relleno: lo enmascara el backend (T24) o se ve «—».
    final documento = (perfil?.documentoEnmascarado?.trim().isNotEmpty ?? false)
        ? perfil!.documentoEnmascarado!.trim()
        : '—';
    final fechaRegistro = (perfil?.creadoEn ?? '—').split('T').first;

    final contenido = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        SolSpacing.screen,
        SolSpacing.xl,
        SolSpacing.screen,
        SolSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: SolSpacing.sm,
            runSpacing: SolSpacing.xs,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: context.solText.body.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(SolIcons.lock, size: 16, color: colors.onSurfaceVariant),
                  const SizedBox(width: SolSpacing.xxs),
                  Flexible(
                    child: Text(
                      l10n.perfilSoloLectura,
                      style: context.solText.note.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SolSpacing.md),
          const SolDivider(),
          const SizedBox(height: SolSpacing.lg),
          if (_cargando && perfil == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: SolSpacing.xxl),
              child: SolLoadingState(message: l10n.perfilCargando),
            )
          else ...[
            // Tarjeta principal de identidad y estado (G-05)
            SolCard.outlined(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SolAvatar(
                        initials: _iniciales(
                          verificado ? nombreMostrado : correoMostrado,
                        ),
                        size: 48,
                      ),
                      const SizedBox(width: SolSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verificado ? nombreMostrado : correoMostrado,
                              style: context.solText.title.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: SolSpacing.xs),
                            SolStatusBadge(
                              status: verificado
                                  ? SolStatus.success
                                  : SolStatus.warning,
                              label: verificado
                                  ? l10n.perfilActiva
                                  : l10n.perfilPendiente,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.md),
                  const SolDivider(),
                  const SizedBox(height: SolSpacing.sm),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: SolSpacing.sm,
                    runSpacing: SolSpacing.xxs,
                    children: [
                      Text(
                        l10n.perfilRegistro,
                        style: context.solText.note.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        fechaRegistro,
                        style: context.solText.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: SolSpacing.lg),
            // Tarjeta de datos de la cuenta
            SolCard.outlined(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(SolIcons.idCard, size: 20, color: colors.primary),
                      const SizedBox(width: SolSpacing.xs),
                      Expanded(
                        child: Text(
                          l10n.perfilDatos,
                          style: context.solText.titleSmall.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.sm),
                  const SolDivider(),
                  const SizedBox(height: SolSpacing.md),
                  _DatoLectura(
                    etiqueta: l10n.perfilNombre,
                    valor: nombreMostrado,
                  ),
                  const SizedBox(height: SolSpacing.md),
                  _DatoLectura(
                    etiqueta: l10n.perfilDocumento,
                    valor: documento,
                  ),
                  const SizedBox(height: SolSpacing.md),
                  // Correo: solo lectura, el del propio usuario (T10/T24).
                  _DatoLectura(
                    etiqueta: l10n.perfilUsuario,
                    valor: correoMostrado,
                  ),
                  const SizedBox(height: SolSpacing.md),
                  _DatoLectura(
                    etiqueta: l10n.perfilRol,
                    valor: l10n.perfilRolCliente,
                  ),
                ],
              ),
            ),
            const SizedBox(height: SolSpacing.lg),
            // Tarjeta de preferencias (idioma y moneda, como en KAN-209 Web)
            SolCard.outlined(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(SolIcons.language, size: 20, color: colors.primary),
                      const SizedBox(width: SolSpacing.xs),
                      Expanded(
                        child: Text(
                          l10n.perfilPreferencias,
                          style: context.solText.titleSmall.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.xs),
                  Text(
                    l10n.perfilPreferenciasTexto,
                    style: context.solText.note.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: SolSpacing.md),
                  Text(
                    l10n.preferenciasIdiomaLabel,
                    style: context.solText.note.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: SolSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: _ChipOpcion(
                          etiqueta: l10n.preferenciasIdiomaEs,
                          seleccionado: locale.languageCode == 'es',
                          onTap: () => ref
                              .read(localeProvider.notifier)
                              .cambiar(AppLocales.es),
                        ),
                      ),
                      const SizedBox(width: SolSpacing.sm),
                      Expanded(
                        child: _ChipOpcion(
                          etiqueta: l10n.preferenciasIdiomaEn,
                          seleccionado: locale.languageCode == 'en',
                          onTap: () => ref
                              .read(localeProvider.notifier)
                              .cambiar(AppLocales.en),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SolSpacing.md),
                  Text(
                    l10n.preferenciasMonedaLabel,
                    style: context.solText.note.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: SolSpacing.xs),
                  Wrap(
                    spacing: SolSpacing.xs,
                    runSpacing: SolSpacing.xs,
                    children: [
                      for (final m in AppMonedas.supported)
                        _ChipMoneda(
                          codigo: m,
                          seleccionada: moneda == m,
                          onTap: () =>
                              ref.read(monedaProvider.notifier).cambiar(m),
                        ),
                    ],
                  ),
                  if (_preferenciasGuardadas) ...[
                    const SizedBox(height: SolSpacing.md),
                    SolStatusBanner(
                      status: SolStatus.success,
                      title: l10n.perfilPreferenciasGuardadas,
                    ),
                  ],
                  const SizedBox(height: SolSpacing.md),
                  SolButton.tonal(
                    label: l10n.perfilGuardarPreferencias,
                    loading: _guardandoPreferencias,
                    onPressed: () => _guardarPreferencias(
                      locale.languageCode.toUpperCase(),
                      moneda,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SolSpacing.lg),
            SolInlineNote(
              icon: SolIcons.info,
              text: l10n.perfilNotaLegal,
              iconColor: colors.primary,
            ),
            if (widget.onLogout != null) ...[
              const SizedBox(height: SolSpacing.xl),
              SolButton.outlined(
                label: l10n.navCerrarSesion,
                icon: SolIcons.logout,
                onPressed: widget.onLogout,
              ),
            ],
          ],
        ],
      ),
    );

    if (widget.enShell) return contenido;
    return SolFlowScaffold(
      title: l10n.perfilTitulo,
      anchorActions: false,
      onHomeTap: () => context.go('/'),
      padding: EdgeInsets.zero,
      body: contenido,
    );
  }
}

class _DatoLectura extends StatelessWidget {
  const _DatoLectura({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          etiqueta,
          style: context.solText.note.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: SolSpacing.xxs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SolSpacing.md,
            vertical: SolSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: SolRadius.fieldAll,
            border: Border.all(color: colors.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  valor,
                  style: context.solText.body.copyWith(color: colors.onSurface),
                ),
              ),
              // Solo lectura: no hay edición en ningún lado (T24).
              ExcludeSemantics(
                child: Icon(
                  SolIcons.lock,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChipOpcion extends StatelessWidget {
  const _ChipOpcion({
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
  });

  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: SolRadius.fieldAll,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(
          horizontal: SolSpacing.sm,
          vertical: SolSpacing.xs,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: seleccionado ? colors.secondaryContainer : colors.surface,
          borderRadius: SolRadius.fieldAll,
          border: Border.all(
            color: seleccionado ? colors.primary : colors.outline,
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: Text(
          etiqueta,
          textAlign: TextAlign.center,
          style: context.solText.labelStrong.copyWith(
            color: seleccionado ? colors.primary : colors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ChipMoneda extends StatelessWidget {
  const _ChipMoneda({
    required this.codigo,
    required this.seleccionada,
    required this.onTap,
  });

  final String codigo;
  final bool seleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: SolRadius.fullAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SolSpacing.md,
          vertical: SolSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: seleccionada ? colors.primary : colors.surfaceContainer,
          borderRadius: SolRadius.fullAll,
          border: Border.all(
            color: seleccionada ? colors.primary : colors.outline,
          ),
        ),
        child: Text(
          codigo,
          style: context.solText.labelStrong.copyWith(
            color: seleccionada ? colors.onPrimary : colors.onSurface,
          ),
        ),
      ),
    );
  }
}
