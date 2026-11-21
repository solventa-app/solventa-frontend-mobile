import 'package:flutter/material.dart';

import '../../icons/sol_icons.dart';
import '../../theme/context_x.dart';
import '../../tokens/sol_motion.dart';
import '../../tokens/sol_spacing.dart';
import 'sol_photo_carousel.dart';

/// Visor de fotos a pantalla completa (HU-M05, M05-07): fondo negro, se pasa
/// de foto deslizando, se acerca con dos dedos (`InteractiveViewer`, hasta 4×)
/// y la foto llega «volando» desde el carrusel (`Hero`). Sin animaciones si el
/// sistema pide quitarlas.
class SolPhotoViewer extends StatefulWidget {
  const SolPhotoViewer({
    super.key,
    required this.photos,
    required this.initialIndex,
    required this.heroTagPrefix,
    required this.closeLabel,
    required this.unavailableLabel,
  });

  final List<SolPhoto> photos;
  final int initialIndex;
  final String heroTagPrefix;
  final String closeLabel;
  final String unavailableLabel;

  /// Abre el visor sobre la pantalla actual.
  static Future<void> open(
    BuildContext context, {
    required List<SolPhoto> photos,
    required int initialIndex,
    required String heroTagPrefix,
    required String closeLabel,
    required String unavailableLabel,
  }) {
    final duracion = SolMotion.of(context, SolMotion.medium);
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        transitionDuration: duracion,
        reverseTransitionDuration: duracion,
        pageBuilder: (_, _, _) => SolPhotoViewer(
          photos: photos,
          initialIndex: initialIndex,
          heroTagPrefix: heroTagPrefix,
          closeLabel: closeLabel,
          unavailableLabel: unavailableLabel,
        ),
        transitionsBuilder: (_, animacion, _, hijo) =>
            FadeTransition(opacity: animacion, child: hijo),
      ),
    );
  }

  @override
  State<SolPhotoViewer> createState() => _SolPhotoViewerState();
}

class _SolPhotoViewerState extends State<SolPhotoViewer> {
  late final PageController _paginas = PageController(
    initialPage: widget.initialIndex,
  );
  late int _actual = widget.initialIndex;

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.photos.length;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _paginas,
            itemCount: total,
            onPageChanged: (i) => setState(() => _actual = i),
            itemBuilder: (context, i) => Semantics(
              image: true,
              label: widget.photos[i].semanticLabel,
              child: InteractiveViewer(
                maxScale: 4,
                child: Center(
                  child: Hero(
                    tag: '${widget.heroTagPrefix}-$i',
                    child: SolPhotoImage(
                      url: widget.photos[i].url,
                      unavailableLabel: widget.unavailableLabel,
                      fit: BoxFit.contain,
                      dark: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SolSpacing.sm),
              child: Row(
                children: [
                  if (total > 1)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: SolSpacing.sm,
                      ),
                      child: Text(
                        '${_actual + 1}/$total',
                        style: context.solText.title.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    tooltip: widget.closeLabel,
                    icon: const Icon(SolIcons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
