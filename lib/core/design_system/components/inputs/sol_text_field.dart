import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Campo de texto de Solventa (M06-02): etiqueta 11 sp dentro del campo,
/// borde de 1 dp, radio de 8 dp. Error con ícono + texto (no solo color).
///
/// Con [readOnly] + [onTap] + [trailingIcon] sirve de selector desplegable.
class SolTextField extends StatefulWidget {
  const SolTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.trailingIcon,
    this.focusNode,
    this.obscureText = false,
    this.autofillHints,
  });

  /// Selector de una opción («Tipo de asistencia · Médica»).
  const SolTextField.select({
    super.key,
    required this.label,
    required String value,
    required VoidCallback this.onTap,
    this.helperText,
    this.errorText,
    this.enabled = true,
  }) : controller = null,
       initialValue = value,
       hint = null,
       onChanged = null,
       readOnly = true,
       maxLines = 1,
       minLines = null,
       keyboardType = null,
       textInputAction = null,
       inputFormatters = null,
       trailingIcon = SolIcons.expandMore,
       focusNode = null,
       obscureText = false,
       autofillHints = null;

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? trailingIcon;
  final FocusNode? focusNode;

  /// Claves: oculta el texto (y un campo así siempre es de una línea).
  final bool obscureText;
  final Iterable<String>? autofillHints;

  @override
  State<SolTextField> createState() => _SolTextFieldState();
}

class _SolTextFieldState extends State<SolTextField> {
  FocusNode? _ownFocus;
  TextEditingController? _ownController;

  FocusNode get _focus => widget.focusNode ?? (_ownFocus ??= FocusNode());
  TextEditingController get _controller =>
      widget.controller ??
      (_ownController ??= TextEditingController(text: widget.initialValue));

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(SolTextField old) {
    super.didUpdateWidget(old);
    if (widget.controller == null &&
        widget.readOnly &&
        widget.initialValue != old.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _ownFocus?.dispose();
    _ownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = widget.errorText != null;
    final focused = _focus.hasFocus;
    final borderColor = !widget.enabled
        ? colors.outline
        : hasError
        ? colors.error
        : focused
        ? colors.primary
        : colors.outline;
    final borderWidth = widget.enabled && (hasError || focused) ? 2.0 : 1.0;
    final multiline = (widget.maxLines ?? 2) > 1;
    final valueStyle = context.solText.body.copyWith(
      color: widget.enabled ? colors.onSurface : colors.onSurfaceVariant,
      fontWeight: widget.readOnly ? FontWeight.w500 : FontWeight.w400,
    );

    final field = TextField(
      controller: _controller,
      focusNode: _focus,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      obscureText: widget.obscureText,
      autocorrect: !widget.obscureText,
      enableSuggestions: !widget.obscureText,
      autofillHints: widget.autofillHints,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      style: valueStyle,
      cursorColor: colors.primary,
      decoration:
          InputDecoration.collapsed(
            hintText: widget.hint,
            hintStyle: context.solText.body.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ).copyWith(
            // La etiqueta visible está fuera del TextField; TalkBack la lee aquí.
            semanticCounterText: '',
          ),
    );

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      // El borde crece hacia dentro para no mover el contenido.
      padding: EdgeInsets.fromLTRB(
        (multiline ? SolSpacing.md : 14) - (borderWidth - 1),
        (multiline ? SolSpacing.md : SolSpacing.sm) - (borderWidth - 1),
        (multiline ? SolSpacing.md : 14) - (borderWidth - 1),
        (multiline ? SolSpacing.md : 6) - (borderWidth - 1),
      ),
      constraints: const BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        // Deshabilitado: fondo surfaceContainer y borde outline.
        color: widget.enabled ? colors.surface : colors.surfaceContainer,
        borderRadius: SolRadius.fieldAll,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Text(
                    widget.label,
                    style: context.solText.note.copyWith(
                      color: hasError ? colors.error : colors.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(height: multiline ? SolSpacing.xs : SolSpacing.xxs),
                Semantics(label: widget.label, child: field),
              ],
            ),
          ),
          if (widget.trailingIcon != null)
            ExcludeSemantics(
              child: Icon(
                widget.trailingIcon,
                size: SolSpacing.xxl,
                color: colors.onSurface,
              ),
            ),
        ],
      ),
    );

    final supporting = hasError ? widget.errorText : widget.helperText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.enabled
              ? () {
                  if (widget.readOnly) {
                    widget.onTap?.call();
                  } else {
                    _focus.requestFocus();
                  }
                }
              : null,
          child: box,
        ),
        if (supporting != null)
          Padding(
            padding: const EdgeInsets.only(
              top: SolSpacing.xs,
              left: SolSpacing.xs,
            ),
            child: Semantics(
              liveRegion: hasError,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasError) ...[
                    ExcludeSemantics(
                      child: Icon(
                        SolIcons.error,
                        size: 16,
                        opticalSize: 20,
                        color: colors.error,
                      ),
                    ),
                    const SizedBox(width: SolSpacing.xs),
                  ],
                  Expanded(
                    child: Text(
                      supporting,
                      semanticsLabel: hasError ? 'Error: $supporting' : null,
                      style: context.solText.note.copyWith(
                        color: hasError
                            ? colors.error
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
