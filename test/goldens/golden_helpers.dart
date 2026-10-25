import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// Anchos (dp) y escalas de texto que revisa el diseñador.
const goldenWidths = [360.0, 390.0];
const goldenTextScales = [1.0, 2.0];

/// Genera un golden por cada ancho × escala de texto:
/// `<name>_<ancho>_x<escala>.png` (p. ej. `button_variants_390_x1.png`).
///
/// Con [height] se fija el alto (pantallas completas); si no, el alto es
/// el del contenido.
void solGoldenMatrix(
  String name,
  Widget Function() builder, {
  double? height,
  PumpAction pumpBeforeTest = onlyPumpAndSettle,
}) {
  for (final width in goldenWidths) {
    for (final scale in goldenTextScales) {
      goldenTest(
        '$name · ${width.toInt()} dp · texto ${(scale * 100).toInt()} %',
        fileName: '${name}_${width.toInt()}_x${scale.toInt()}',
        textScaleFactor: scale,
        constraints: height == null
            ? BoxConstraints.tightFor(width: width)
            : BoxConstraints.tight(Size(width, height)),
        pumpBeforeTest: pumpBeforeTest,
        builder: builder,
      );
    }
  }
}

/// Lámina de casos de un componente, con su nombre encima de cada uno.
class GoldenSheet extends StatelessWidget {
  const GoldenSheet({super.key, required this.cases, this.padding = 16});

  final Map<String, Widget> cases;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: SolColors.surfaceContainer,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final entry in cases.entries) ...[
              Text(
                entry.key,
                style: context.solText.note.copyWith(
                  color: SolColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              entry.value,
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

/// Avanza ~300 ms para que las ruedas de carga indeterminadas ya muestren
/// su arco en el golden (en el primer cuadro el arco mide casi cero).
final PumpAction pumpSpinner = pumpNTimes(2, const Duration(milliseconds: 150));
