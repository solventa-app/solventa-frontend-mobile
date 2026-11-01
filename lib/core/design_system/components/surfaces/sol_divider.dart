import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_sizes.dart';

/// Divisor de 1 dp en `outline`.
class SolDivider extends StatelessWidget {
  const SolDivider({super.key, this.indent = 0, this.endIndent = 0});

  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: SolSizes.divider,
      thickness: SolSizes.divider,
      indent: indent,
      endIndent: endIndent,
      color: context.colors.outline,
    );
  }
}
