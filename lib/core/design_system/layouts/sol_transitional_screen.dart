import 'package:flutter/material.dart';

import '../components/feedback/sol_loading_state.dart';
import '../components/navigation/sol_top_bar.dart';
import '../tokens/sol_spacing.dart';
import 'sol_screen_frame.dart';

/// Pantalla transitoria (verificando, enviando): solo carga, sin flecha y
/// sin atrás del sistema; la app navega sola al terminar.
class SolTransitionalScreen extends StatelessWidget {
  const SolTransitionalScreen({
    super.key,
    required this.title,
    required this.message,
    this.footer,
  });

  final String title;

  /// Qué está pasando, p. ej. «Validando con el proveedor KYC/AML...».
  final String message;

  /// Contenido opcional bajo el indicador (p. ej. un SolDemoTrigger).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SolScreenFrame(
        topBar: SolTopBar.flow(
          title: title,
          showBack: false,
          showProfile: false,
        ),
        padding: const EdgeInsets.fromLTRB(
          SolSpacing.screen,
          SolSpacing.xxxl,
          SolSpacing.screen,
          SolSpacing.xxxl,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SolLoadingState(message: message),
            if (footer != null) ...[
              const SizedBox(height: SolSpacing.sm),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
