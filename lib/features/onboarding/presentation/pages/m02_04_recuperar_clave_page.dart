import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/l10n/l10n.dart';
import '../onboarding_notifier.dart';

/// M02-04 · Recupera tu contraseña (KAN-26, contrato v0.43).
///
/// Pide solo el correo. La respuesta es siempre la misma exista o no la
/// cuenta: «Si hay una cuenta con ese correo, te enviamos un enlace». El enlace
/// llega por correo y se abre en el navegador (la web pide la contraseña
/// nueva y su confirmación); la app no maneja el token.
class M0204RecuperarClavePage extends ConsumerStatefulWidget {
  const M0204RecuperarClavePage({super.key});

  @override
  ConsumerState<M0204RecuperarClavePage> createState() =>
      _M0204RecuperarClavePageState();
}

class _M0204RecuperarClavePageState
    extends ConsumerState<M0204RecuperarClavePage> {
  static final _correoValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _correo = TextEditingController();
  bool _validar = false;
  bool _enviado = false;

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    setState(() => _validar = true);
    if (!_correoValido.hasMatch(_correo.text.trim())) return;
    final ok = await ref
        .read(onboardingProvider.notifier)
        .solicitarRestablecimientoClave(_correo.text.trim());
    if (ok && mounted) setState(() => _enviado = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(onboardingProvider);
    final falla = estado.falla;

    return SolFlowScaffold(
      title: l10n.m0204Titulo,
      anchorActions: false,
      showProfile: false,
      onBack: () => context.pop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_enviado) ...[
            SolStatusBanner(
              status: SolStatus.info,
              title: l10n.m0204EnviadoTitulo,
              message: l10n.m0204EnviadoTexto,
            ),
          ] else ...[
            Text(
              l10n.m0204Intro,
              style: context.solText.body.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: SolSpacing.xl),
            SolTextField(
              label: l10n.m0105bCorreo,
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) => setState(() {}),
              errorText:
                  _validar && !_correoValido.hasMatch(_correo.text.trim())
                  ? l10n.m0105bErrorCorreo
                  : null,
            ),
            if (falla != null) ...[
              const SizedBox(height: SolSpacing.lg),
              SolStatusBanner(
                status: SolStatus.error,
                title: l10n.falla(falla),
              ),
            ],
          ],
        ],
      ),
      actions: [
        if (!_enviado)
          SolButton.primary(
            label: l10n.m0204Enviar,
            loading: estado.ocupado,
            onPressed: _enviar,
          ),
        const SizedBox(height: SolSpacing.sm),
        Center(
          child: SolLinkButton(
            label: l10n.m0204Volver,
            onPressed: estado.ocupado ? null : () => context.pop(),
          ),
        ),
      ],
    );
  }
}
