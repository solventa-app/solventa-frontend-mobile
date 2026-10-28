import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-05b · Crea tu cuenta (nueva, plan de HU-M01). Se muestra justo
/// después del video: mientras la persona la llena, la verificación ya corre.
/// El nombre no se pide: sale del documento. Atrás bloqueado: las capturas
/// ya se enviaron.
class M0105bCuentaPage extends ConsumerStatefulWidget {
  const M0105bCuentaPage({super.key});

  @override
  ConsumerState<M0105bCuentaPage> createState() => _M0105bCuentaPageState();
}

class _M0105bCuentaPageState extends ConsumerState<M0105bCuentaPage> {
  static final _correoValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _correo = TextEditingController();
  final _clave = TextEditingController();
  final _confirmacion = TextEditingController();
  bool _validar = false;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    _confirmacion.dispose();
    super.dispose();
  }

  String? _errorCorreo(AppLocalizations l10n) =>
      _correoValido.hasMatch(_correo.text.trim())
      ? null
      : l10n.m0105bErrorCorreo;

  String? _errorClave(AppLocalizations l10n) {
    final n = _clave.text.length;
    return n >= 8 && n <= 128 ? null : l10n.m0105bErrorContrasena;
  }

  String? _errorConfirmacion(AppLocalizations l10n) =>
      _confirmacion.text == _clave.text ? null : l10n.m0105bErrorConfirmar;

  Future<void> _crear(AppLocalizations l10n) async {
    setState(() => _validar = true);
    if (_errorCorreo(l10n) != null ||
        _errorClave(l10n) != null ||
        _errorConfirmacion(l10n) != null) {
      return;
    }
    final ok = await ref
        .read(onboardingProvider.notifier)
        .crearCuenta(correo: _correo.text.trim(), clave: _clave.text);
    if (ok && mounted) context.go(OnboardingRoutes.verificando);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(onboardingProvider);
    final falla = estado.falla;
    final correoRegistrado =
        falla is FallaNegocio && falla.motivo == 'CORREO_YA_REGISTRADO';

    return PopScope(
      canPop: false,
      child: SolFlowScaffold(
        title: l10n.m0105bTitulo,
        anchorActions: false,
        body: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.m0105bIntro,
                style: context.solText.body.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(height: SolSpacing.xl),
              SolTextField(
                label: l10n.m0105bCorreo,
                controller: _correo,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onChanged: (_) => setState(() {}),
                errorText: correoRegistrado
                    ? l10n.m0105bCorreoRegistrado
                    : _validar
                    ? _errorCorreo(l10n)
                    : null,
              ),
              const SizedBox(height: SolSpacing.lg),
              SolTextField(
                label: l10n.m0105bContrasena,
                controller: _clave,
                obscureText: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                helperText: l10n.m0105bAyudaContrasena,
                onChanged: (_) => setState(() {}),
                errorText: _validar ? _errorClave(l10n) : null,
              ),
              const SizedBox(height: SolSpacing.lg),
              SolTextField(
                label: l10n.m0105bConfirmar,
                controller: _confirmacion,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
                errorText: _validar ? _errorConfirmacion(l10n) : null,
              ),
              if (falla != null && !correoRegistrado) ...[
                const SizedBox(height: SolSpacing.lg),
                SolStatusBanner(
                  status: SolStatus.error,
                  title: l10n.falla(falla),
                ),
              ],
            ],
          ),
        ),
        actions: [
          SolButton.primary(
            label: l10n.m0105bCrear,
            loading: estado.ocupado,
            onPressed: () => _crear(l10n),
          ),
        ],
      ),
    );
  }
}
