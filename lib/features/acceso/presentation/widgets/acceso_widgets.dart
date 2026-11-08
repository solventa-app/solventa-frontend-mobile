import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';

/// Marco de las pantallas de HU-M02 (Figma 2005:565, 2005:472, 2005:499):
/// fondo gris, encabezado de 56 dp solo con la píldora de idioma y moneda
/// (sin título ni flecha: la tarjeta lleva la marca) y el contenido con
/// scroll, centrado si [centrar].
class AccesoMarco extends StatelessWidget {
  const AccesoMarco({super.key, required this.child, this.centrar = false});

  final Widget child;

  /// M02-03 centra la tarjeta en la pantalla; M02-01 la deja arriba.
  final bool centrar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceContainer,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: SolSizes.topBarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SolSpacing.lg),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.3,
                    child: const SolLocaleChip(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        SolSpacing.screen,
                        centrar ? SolSpacing.xxl : SolSpacing.xxxl,
                        SolSpacing.screen,
                        SolSpacing.xxl,
                      ),
                      child: Align(
                        alignment: centrar
                            ? Alignment.center
                            : Alignment.topCenter,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Círculo con ícono de las tarjetas de M02 (sensor, error, éxito).
class AccesoIconoCirculo extends StatelessWidget {
  const AccesoIconoCirculo({
    super.key,
    required this.icono,
    required this.fondo,
    required this.color,
    required this.diametro,
    this.tamanoIcono = 44,
    this.relleno = false,
  });

  final IconData icono;
  final Color fondo;
  final Color color;
  final double diametro;
  final double tamanoIcono;
  final bool relleno;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diametro,
      height: diametro,
      decoration: BoxDecoration(color: fondo, shape: BoxShape.circle),
      child: Icon(
        icono,
        size: tamanoIcono,
        fill: relleno ? 1 : 0,
        color: color,
      ),
    );
  }
}
