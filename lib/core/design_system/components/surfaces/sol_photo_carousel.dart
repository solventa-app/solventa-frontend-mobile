import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_radius.dart';
import '../../tokens/sol_spacing.dart';
import '../feedback/sol_skeleton.dart';

/// Una foto del carrusel: su URL (vacía = no disponible) y lo que lee TalkBack.
@immutable
class SolPhoto {
  const SolPhoto({required this.url, required this.semanticLabel});

  final String url;
  final String semanticLabel;
}

/// Carrusel horizontal de fotos (HU-M05, M05-07): se desliza con el dedo, deja
/// ver el borde de la siguiente, muestra «1/3» y puntos de posición, y al
/// tocar una foto llama a [onOpen] (el visor a pantalla completa). Hecho con
/// `PageView`, sin paquetes.
///
/// Mientras carga, un esqueleto; si la URL está vacía o la foto no carga, el
/// marcador «Imagen no disponible» ([unavailableLabel]) y [onUnavailable]
/// (p. ej. pedir una URL firmada nueva).
class SolPhotoCarousel extends StatefulWidget {
  const SolPhotoCarousel({
    super.key,
    required this.photos,
    required this.unavailableLabel,
    required this.heroTagPrefix,
    this.onOpen,
    this.onUnavailable,
    this.height = 200,
  });

  final List<SolPhoto> photos;
  final String unavailableLabel;

  /// Prefijo único de los `Hero`: la foto «vuela» al visor.
  final String heroTagPrefix;
  final ValueChanged<int>? onOpen;
  final VoidCallback? onUnavailable;
  final double height;

  @override
  State<SolPhotoCarousel> createState() => _SolPhotoCarouselState();
}

class _SolPhotoCarouselState extends State<SolPhotoCarousel> {
  late final PageController _paginas = PageController(
    viewportFraction: widget.photos.length > 1 ? 0.88 : 1,
  );
  int _actual = 0;

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.photos.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _paginas,
            itemCount: total,
            padEnds: false,
            onPageChanged: (i) => setState(() => _actual = i),
            itemBuilder: (context, i) => Padding(
              padding: EdgeInsetsDirectional.only(
                end: i == total - 1 ? 0 : SolSpacing.sm,
              ),
              child: _Pagina(
                photo: widget.photos[i],
                heroTag: '${widget.heroTagPrefix}-$i',
                unavailableLabel: widget.unavailableLabel,
                onTap: widget.onOpen == null ? null : () => widget.onOpen!(i),
                onUnavailable: widget.onUnavailable,
                contador: total > 1 ? '${i + 1}/$total' : null,
              ),
            ),
          ),
        ),
        if (total > 1) ...[
          const SizedBox(height: SolSpacing.sm),
          ExcludeSemantics(
            child: _Puntos(total: total, actual: _actual),
          ),
        ],
      ],
    );
  }
}

class _Pagina extends StatelessWidget {
  const _Pagina({
    required this.photo,
    required this.heroTag,
    required this.unavailableLabel,
    required this.onTap,
    required this.onUnavailable,
    required this.contador,
  });

  final SolPhoto photo;
  final String heroTag;
  final String unavailableLabel;
  final VoidCallback? onTap;
  final VoidCallback? onUnavailable;
  final String? contador;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: onTap != null,
      image: true,
      label: photo.semanticLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: SolRadius.cardAll,
          border: Border.all(color: colors.outlineVariant),
        ),
        child: ClipRRect(
          borderRadius: SolRadius.cardAll,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: heroTag,
                child: SolPhotoImage(
                  url: photo.url,
                  unavailableLabel: unavailableLabel,
                  onUnavailable: onUnavailable,
                ),
              ),
              if (contador case final texto?)
                PositionedDirectional(
                  top: SolSpacing.sm,
                  end: SolSpacing.sm,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.scrim.withValues(alpha: 0.6),
                      borderRadius: SolRadius.fullAll,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SolSpacing.sm,
                        vertical: SolSpacing.xxs,
                      ),
                      child: Text(
                        texto,
                        style: context.solText.labelStrong.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// La imagen de una foto con su esqueleto de carga y su marcador de «no
/// disponible». La usan el carrusel y el visor.
class SolPhotoImage extends StatelessWidget {
  const SolPhotoImage({
    super.key,
    required this.url,
    required this.unavailableLabel,
    this.fit = BoxFit.cover,
    this.onUnavailable,
    this.dark = false,
  });

  final String url;
  final String unavailableLabel;
  final BoxFit fit;
  final VoidCallback? onUnavailable;

  /// Sobre fondo negro (visor).
  final bool dark;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _noDisponible(context);
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progreso) =>
          progreso == null ? child : const SolSkeleton(height: double.infinity),
      errorBuilder: (context, _, _) {
        // La URL firmada venció o el archivo no está: que la pantalla pida otra.
        if (onUnavailable case final avisar?) {
          WidgetsBinding.instance.addPostFrameCallback((_) => avisar());
        }
        return _noDisponible(context);
      },
    );
  }

  Widget _noDisponible(BuildContext context) {
    final colors = context.colors;
    final tinta = dark ? Colors.white70 : colors.onSurfaceVariant;
    return ColoredBox(
      color: dark ? Colors.black : colors.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(SolIcons.imageOff, size: 32, color: tinta),
            const SizedBox(height: SolSpacing.xs),
            Text(
              unavailableLabel,
              style: context.solText.body.copyWith(color: tinta),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Puntos extends StatelessWidget {
  const _Puntos({required this.total, required this.actual});

  final int total;
  final int actual;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duracion = SolMotion.of(context, SolMotion.short);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++)
          AnimatedContainer(
            duration: duracion,
            margin: const EdgeInsets.symmetric(horizontal: SolSpacing.xxs),
            width: i == actual ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == actual ? colors.primary : colors.outlineVariant,
              borderRadius: SolRadius.fullAll,
            ),
          ),
      ],
    );
  }
}
