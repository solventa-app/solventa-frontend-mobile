import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/solventa_ui.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/regla_clave.dart';
import '../onboarding_notifier.dart';
import '../onboarding_routes.dart';

/// M01-05b · Crea tu cuenta o Inicia sesión (plan de HU-M01).
///
/// Permite:
/// - **Crear cuenta**: correo + clave + confirmación. Si se activa desde el
///   inicio o con el enlace de verificación por correo, envía un código OTP de
///   6 dígitos a `M0105cCodigoPage`; en el flujo continuo tras la prueba de
///   vida crea la cuenta directamente y sigue a `M01-06`.
/// - **Iniciar sesión**: correo + clave existentes para recuperar la cuenta y
///   volver al Home.
class M0105bCuentaPage extends ConsumerStatefulWidget {
  const M0105bCuentaPage({
    super.key,
    this.modoInicialLogin = false,
  });

  final bool modoInicialLogin;

  @override
  ConsumerState<M0105bCuentaPage> createState() => _M0105bCuentaPageState();
}

class _M0105bCuentaPageState extends ConsumerState<M0105bCuentaPage> {
  static final _correoValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _validar = false;
  late bool _modoLogin = widget.modoInicialLogin;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  String? _errorCorreo(AppLocalizations l10n) =>
      _correoValido.hasMatch(_correo.text.trim())
      ? null
      : l10n.m0105bErrorCorreo;

  /// Misma regla que AUTH (`validar_clave`, T17).
  ReglaClave get _regla => ReglaClave.evaluar(_clave.text);

  String? _errorClave(AppLocalizations l10n) {
    // Al iniciar sesión no se exigen las reglas de longitud de la creación:
    // la clave existente la valida el servidor.
    if (_modoLogin) {
      return _clave.text.isNotEmpty ? null : l10n.m0105bErrorContrasenaLogin;
    }
    return _regla.cumple ? null : l10n.m0105bErrorContrasena;
  }

  Future<void> _enviar(AppLocalizations l10n) async {
    setState(() => _validar = true);
    if (_errorCorreo(l10n) != null || _errorClave(l10n) != null) {
      return;
    }
    final notifier = ref.read(onboardingProvider.notifier);
    final correoLimpio = _correo.text.trim();
    final claveTexto = _clave.text;

    if (_modoLogin) {
      final ok = await notifier.iniciarSesion(
        correo: correoLimpio,
        clave: claveTexto,
      );
      if (ok && mounted) context.go('/');
      return;
    }

    // El correo se verifica siempre con el código real enviado por correo.
    final ok = await notifier.solicitarCodigoCorreo(
      correo: correoLimpio,
      clave: claveTexto,
    );
    if (ok && mounted) await context.push(OnboardingRoutes.codigoCorreo);
  }

  void _alternarModo() {
    ref.read(onboardingProvider.notifier).limpiarFalla();
    // Crear cuenta e iniciar sesión no comparten lo escrito ni sus errores.
    _correo.clear();
    _clave.clear();
    setState(() {
      _modoLogin = !_modoLogin;
      _validar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final estado = ref.watch(onboardingProvider);
    final falla = estado.falla;
    final correoRegistrado =
        falla is FallaNegocio && falla.motivo == 'CORREO_YA_REGISTRADO';

    final puedeVolver = Navigator.maybeOf(context)?.canPop() ?? false;

    return SolFlowScaffold(
      title: _modoLogin ? l10n.cuentaTituloIngresar : l10n.m0105bTitulo,
      anchorActions: false,
      showBack: puedeVolver,
      showProfile: false,
      onBack: puedeVolver ? () => context.pop() : null,
      body: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _modoLogin ? l10n.cuentaIntroIngresar : l10n.m0105bIntro,
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
              textInputAction: TextInputAction.done,
              autofillHints: [
                _modoLogin ? AutofillHints.password : AutofillHints.newPassword,
              ],
              onChanged: (_) => setState(() {}),
              errorText: _validar ? _errorClave(l10n) : null,
            ),
            if (!_modoLogin) ...[
              const SizedBox(height: SolSpacing.xs),
              _RequisitoClave(
                texto: l10n.m0105bReqLargo,
                estado: _regla.largo
                    ? l10n.m0105bRequisitoCumplido
                    : l10n.m0105bRequisitoPendiente,
                cumplido: _regla.largo,
              ),
              _RequisitoClave(
                texto: l10n.m0105bReqMayuscula,
                estado: _regla.mayuscula
                    ? l10n.m0105bRequisitoCumplido
                    : l10n.m0105bRequisitoPendiente,
                cumplido: _regla.mayuscula,
              ),
              _RequisitoClave(
                texto: l10n.m0105bReqMinuscula,
                estado: _regla.minuscula
                    ? l10n.m0105bRequisitoCumplido
                    : l10n.m0105bRequisitoPendiente,
                cumplido: _regla.minuscula,
              ),
              _RequisitoClave(
                texto: l10n.m0105bReqEspecial,
                estado: _regla.especial
                    ? l10n.m0105bRequisitoCumplido
                    : l10n.m0105bRequisitoPendiente,
                cumplido: _regla.especial,
              ),
            ],
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
          label: _modoLogin ? l10n.cuentaBotonIngresar : l10n.m0105bCrear,
          loading: estado.ocupado,
          onPressed: _modoLogin || _regla.cumple ? () => _enviar(l10n) : null,
        ),
        const SizedBox(height: SolSpacing.sm),
        Center(
          child: SolLinkButton(
            label: _modoLogin
                ? l10n.cuentaCambiarACrear
                : l10n.cuentaCambiarAIngresar,
            onPressed: estado.ocupado ? null : _alternarModo,
          ),
        ),
      ],
    );
  }
}

/// Requisito de la clave con ✓ cuando se cumple (no solo color: ícono y texto).
class _RequisitoClave extends StatelessWidget {
  const _RequisitoClave({
    required this.texto,
    required this.estado,
    required this.cumplido,
  });

  final String texto;

  /// Lo que lee el lector de pantalla junto al requisito («cumplido» / «pendiente»).
  final String estado;
  final bool cumplido;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = cumplido ? colors.primary : colors.onSurfaceVariant;
    return Semantics(
      label: '$texto, $estado',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(left: SolSpacing.xs),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                cumplido ? SolIcons.success : SolIcons.pendingRegistration,
                size: 16,
                color: color,
              ),
            ),
            const SizedBox(width: SolSpacing.xs),
            Expanded(
              child: Text(
                texto,
                style: context.solText.note.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
