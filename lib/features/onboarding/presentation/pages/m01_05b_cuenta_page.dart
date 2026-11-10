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
/// Es la entrada de la app y abre en **Iniciar sesión**; «¿No tienes cuenta?
/// Crear cuenta» va debajo (QA 2026-11-10).
///
/// Permite:
/// - **Crear cuenta**: correo + clave + confirmación. Los requisitos de la
///   clave se ven desde el principio en un recuadro: cada uno se marca en verde
///   al cumplirse y, si se intenta crear la cuenta sin cumplirlo, en rojo. Si se activa desde el
///   inicio o con el enlace de verificación por correo, envía un código OTP de
///   6 dígitos a `M0105cCodigoPage`; en el flujo continuo tras la prueba de
///   vida crea la cuenta directamente y sigue a `M01-06`.
/// - **Iniciar sesión**: correo + clave existentes para recuperar la cuenta y
///   volver al Home.
class M0105bCuentaPage extends ConsumerStatefulWidget {
  const M0105bCuentaPage({super.key, this.modoInicialLogin = false});

  final bool modoInicialLogin;

  @override
  ConsumerState<M0105bCuentaPage> createState() => _M0105bCuentaPageState();
}

class _M0105bCuentaPageState extends ConsumerState<M0105bCuentaPage> {
  static final _correoValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _correo = TextEditingController();
  final _clave = TextEditingController();
  final _confirmacion = TextEditingController();
  bool _validar = false;
  late bool _modoLogin = widget.modoInicialLogin;

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

  /// Se avisa en cuanto lo escrito deja de coincidir, sin esperar a enviar:
  /// mientras la confirmación sea el comienzo de la clave, todavía va bien.
  String? _errorConfirmacion(AppLocalizations l10n) {
    if (_modoLogin) return null;
    final confirmacion = _confirmacion.text;
    if (confirmacion == _clave.text) return null;
    final divergio =
        confirmacion.isNotEmpty && !_clave.text.startsWith(confirmacion);
    return _validar || divergio ? l10n.m0105bErrorConfirmar : null;
  }

  Future<void> _enviar(AppLocalizations l10n) async {
    setState(() => _validar = true);
    if (_errorCorreo(l10n) != null ||
        _errorClave(l10n) != null ||
        _errorConfirmacion(l10n) != null) {
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
    _confirmacion.clear();
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
              _modoLogin ? l10n.cuentaIntroIngresar : l10n.cuentaIntroCrear,
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
              textInputAction: _modoLogin
                  ? TextInputAction.done
                  : TextInputAction.next,
              autofillHints: [
                _modoLogin ? AutofillHints.password : AutofillHints.newPassword,
              ],
              onChanged: (_) => setState(() {}),
              // Al crear, el recuadro de requisitos ya dice qué falta.
              errorText: _validar && _modoLogin ? _errorClave(l10n) : null,
            ),
            if (!_modoLogin) ...[
              const SizedBox(height: SolSpacing.sm),
              _RequisitosClave(regla: _regla, marcarFaltantes: _validar),
              const SizedBox(height: SolSpacing.lg),
              SolTextField(
                label: l10n.m0105bConfirmar,
                controller: _confirmacion,
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                onChanged: (_) => setState(() {}),
                errorText: _errorConfirmacion(l10n),
                helperText:
                    _confirmacion.text.isNotEmpty &&
                        _confirmacion.text == _clave.text
                    ? l10n.m0105bClavesCoinciden
                    : null,
              ),
            ],
            if (_modoLogin) ...[
              const SizedBox(height: SolSpacing.xs),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SolLinkButton(
                  label: l10n.cuentaOlvideClave,
                  onPressed: estado.ocupado
                      ? null
                      : () => context.push(OnboardingRoutes.recuperarClave),
                ),
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
          // Siempre activo: un botón apagado no explica qué falta; al tocarlo
          // se marcan en rojo los requisitos pendientes.
          onPressed: () => _enviar(l10n),
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

/// Los requisitos de la clave en un recuadro, visibles desde el principio.
///
/// Tres estados por requisito, siempre con ícono y texto (no solo color):
/// pendiente (círculo vacío, gris), cumplido (✓ verde) y, tras intentar crear
/// la cuenta sin cumplirlo, faltante (✕ rojo).
class _RequisitosClave extends StatelessWidget {
  const _RequisitosClave({required this.regla, required this.marcarFaltantes});

  final ReglaClave regla;
  final bool marcarFaltantes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final incompleto = marcarFaltantes && !regla.cumple;
    return Container(
      padding: const EdgeInsets.all(SolSpacing.md),
      decoration: BoxDecoration(
        color: incompleto ? colors.errorContainer : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(SolRadius.field),
        border: Border.all(
          color: incompleto ? colors.error : colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.m0105bReqTitulo,
            style: context.solText.note.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SolSpacing.xs),
          for (final (texto, cumplido) in [
            (l10n.m0105bReqLargo, regla.largo),
            (l10n.m0105bReqMayuscula, regla.mayuscula),
            (l10n.m0105bReqMinuscula, regla.minuscula),
            (l10n.m0105bReqEspecial, regla.especial),
          ])
            _RequisitoClave(
              texto: texto,
              estado: cumplido
                  ? _EstadoRequisito.cumplido
                  : marcarFaltantes
                  ? _EstadoRequisito.faltante
                  : _EstadoRequisito.pendiente,
            ),
        ],
      ),
    );
  }
}

enum _EstadoRequisito { pendiente, cumplido, faltante }

/// Un requisito: ícono, texto y lo que lee el lector de pantalla.
class _RequisitoClave extends StatelessWidget {
  const _RequisitoClave({required this.texto, required this.estado});

  final String texto;
  final _EstadoRequisito estado;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final (icono, color, lectura) = switch (estado) {
      _EstadoRequisito.cumplido => (
        SolIcons.success,
        context.solColors.success,
        l10n.m0105bRequisitoCumplido,
      ),
      _EstadoRequisito.faltante => (
        SolIcons.failure,
        colors.error,
        l10n.m0105bRequisitoIncumplido,
      ),
      _EstadoRequisito.pendiente => (
        SolIcons.requisitoPendiente,
        colors.onSurfaceVariant,
        l10n.m0105bRequisitoPendiente,
      ),
    };
    return Semantics(
      label: '$texto, $lectura',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SolSpacing.xxs),
        child: Row(
          children: [
            Icon(icono, size: 18, color: color),
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
