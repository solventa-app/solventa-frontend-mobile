import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';

/// Foto de la sede o placeholder del tipo, con un velo blanco y textos
/// opcionales encima (HU-M06: detalle del prestador 2.2, banner de M06-02 S2
/// y detalle de la asistencia 4.4).
///
/// Sin [photoUrl], o si la foto no carga, muestra el placeholder: un degradado
/// suave con el ícono del tipo ([placeholderIcon]). Ajuste A13 del plan: no
/// hay fotos de banco en el repositorio, así que el placeholder se dibuja.
class SolPhotoBanner extends StatelessWidget {
  const SolPhotoBanner({
    super.key,
    required this.placeholderIcon,
    this.photoUrl,
    this.title,
    this.subtitle,
    this.height = 120,
    this.strongVeil = false,
  });

  final String? photoUrl;
  final IconData placeholderIcon;
  final String? title;
  final String? subtitle;
  final double height;

  /// Velo blanco fuerte, para que el texto encima se lea (M06-02).
  final bool strongVeil;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryContainer, colors.surfaceContainer],
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsets.all(SolSpacing.lg),
          child: Icon(
            placeholderIcon,
            size: height * 0.5,
            color: colors.primary.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
    final url = photoUrl;
    return ExcludeSemantics(
      excluding: title == null,
      child: ClipRRect(
        borderRadius: SolRadius.cardAll,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url == null)
                placeholder
              else
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => placeholder,
                ),
              ColoredBox(
                color: colors.surface.withValues(
                  alpha: strongVeil ? 0.78 : 0.25,
                ),
              ),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(SolSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: context.solText.title.copyWith(
                          color: colors.primary,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: context.solText.body.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
