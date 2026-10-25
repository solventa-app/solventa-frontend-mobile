import 'package:flutter/widgets.dart';

import '../tokens/sol_sizes.dart';

/// Limita el contenido a 600 dp y lo centra en pantallas anchas
/// (plegables, tablets, horizontal). En teléfonos no cambia nada.
class SolAdaptiveBody extends StatelessWidget {
  const SolAdaptiveBody({
    super.key,
    required this.child,
    this.maxWidth = SolSizes.maxContentWidth,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
