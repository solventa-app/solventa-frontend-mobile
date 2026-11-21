import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/design_system/solventa_ui.dart';

/// Paso de la prueba de vida mientras se graba: la cara gira a un lado, al
/// otro y vuelve al centro, unos 5 s cada uno (15 s en total).
enum PasoPruebaVida { izquierda, derecha, centro }

/// Guía animada del rostro en M01-05 (pedido de felipe, 2026-11-21): reemplaza
/// el óvalo punteado fijo cuando la pantalla la pasa a [SolCameraFrame.faceGuide].
///
/// - **Lista**: óvalo con un halo que respira y líneas que giran despacio
///   alrededor, para invitar a encuadrar la cara.
/// - **Grabando**: un anillo verde se va llenando alrededor del óvalo durante
///   los [duracion] segundos, con partículas que orbitan, una línea de escaneo
///   que sube y baja y una flecha que indica hacia dónde girar la cara.
/// - **Completo**: anillo lleno en verde con un check.
///
/// El progreso lo marca el tiempo de grabación (no hay detección facial en el
/// teléfono): es una guía visual, la verificación la hace el proveedor KYC.
/// Con «reducir movimiento» del sistema no hay partículas ni giros: solo el
/// anillo que se llena.
class GuiaPruebaVida extends StatefulWidget {
  const GuiaPruebaVida({
    super.key,
    required this.grabando,
    this.completo = false,
    this.duracion = const Duration(seconds: 15),
  });

  final bool grabando;
  final bool completo;
  final Duration duracion;

  /// El paso que toca a los [segundos] de grabación.
  static PasoPruebaVida pasoEn(int segundos, Duration duracion) {
    final tramo = duracion.inSeconds / PasoPruebaVida.values.length;
    final i = (segundos / tramo).floor().clamp(
      0,
      PasoPruebaVida.values.length - 1,
    );
    return PasoPruebaVida.values[i];
  }

  @override
  State<GuiaPruebaVida> createState() => _GuiaPruebaVidaState();
}

class _GuiaPruebaVidaState extends State<GuiaPruebaVida>
    with TickerProviderStateMixin {
  /// Movimiento continuo (halo, órbitas, escaneo): un ciclo cada 3 s.
  late final AnimationController _ciclo = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  /// Avance de la grabación, de 0 a 1 en [GuiaPruebaVida.duracion].
  late final AnimationController _avance = AnimationController(
    vsync: this,
    duration: widget.duracion,
  );

  bool _sinMovimiento = false;

  @override
  void initState() {
    super.initState();
    if (widget.grabando) _avance.forward(from: 0);
    if (widget.completo) _avance.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sinMovimiento = SolMotion.sinBucles(context);
    if (_sinMovimiento) {
      _ciclo.stop();
    } else if (!_ciclo.isAnimating) {
      _ciclo.repeat();
    }
  }

  @override
  void didUpdateWidget(GuiaPruebaVida old) {
    super.didUpdateWidget(old);
    if (widget.grabando && !old.grabando) _avance.forward(from: 0);
    if (!widget.grabando && old.grabando && !widget.completo) _avance.reset();
    if (widget.completo) _avance.value = 1;
  }

  @override
  void dispose() {
    _ciclo.dispose();
    _avance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verde = context.solColors.success;
    return Padding(
      padding: const EdgeInsets.only(top: SolSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: AspectRatio(
          aspectRatio: 200 / 260,
          child: AnimatedBuilder(
            animation: Listenable.merge([_ciclo, _avance]),
            builder: (context, _) {
              return CustomPaint(
                painter: _AnilloPainter(
                  ciclo: _sinMovimiento ? 0 : _ciclo.value,
                  avance: _avance.value,
                  grabando: widget.grabando,
                  completo: widget.completo,
                  verde: verde,
                  conMovimiento: !_sinMovimiento,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: widget.completo
                        ? Icon(
                            Icons.check_circle_rounded,
                            key: const ValueKey('completo'),
                            size: 56,
                            color: verde,
                          )
                        : _CabezaGiro(
                            key: const ValueKey('cabeza'),
                            guinada: widget.grabando
                                ? guinadaEn(_avance.value)
                                : 0,
                            ciclo: _sinMovimiento ? 0 : _ciclo.value,
                            activa: widget.grabando,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Hacia dónde mira la silueta: -1 izquierda, 0 de frente, 1 derecha.
///
/// Dentro de cada paso de 5 s la cabeza gira suave durante el primer 40 % y se
/// queda en esa posición el resto, como debe hacerlo la persona.
double guinadaEn(double avance) {
  const objetivo = [-1.0, 1.0, 0.0];
  final tramos = avance.clamp(0.0, 0.9999) * PasoPruebaVida.values.length;
  final i = tramos.floor();
  final local = (tramos - i) / 0.4;
  final desde = i == 0 ? 0.0 : objetivo[i - 1];
  final t = Curves.easeInOut.transform(local.clamp(0.0, 1.0));
  return desde + (objetivo[i] - desde) * t;
}

/// Silueta de una cabeza que gira hacia el lado del paso (pedido de felipe,
/// 2026-11-21), con unas flechas suaves del lado al que va. La cámara frontal
/// se ve como espejo: la izquierda de la persona es la izquierda de la pantalla.
class _CabezaGiro extends StatelessWidget {
  const _CabezaGiro({
    super.key,
    required this.guinada,
    required this.ciclo,
    required this.activa,
  });

  final double guinada;
  final double ciclo;
  final bool activa;

  @override
  Widget build(BuildContext context) {
    final vaiven = math.sin(ciclo * math.pi * 2 * 2).abs();
    final flecha = guinada.abs() > 0.5;
    return SizedBox(
      width: 150,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(110, 150),
            painter: _CabezaPainter(guinada: guinada, activa: activa),
          ),
          if (activa && flecha)
            Align(
              alignment: Alignment(guinada.sign, -0.05),
              child: Transform.translate(
                offset: Offset(guinada.sign * 4 * vaiven, 0),
                child: Icon(
                  guinada < 0
                      ? Icons.keyboard_double_arrow_left_rounded
                      : Icons.keyboard_double_arrow_right_rounded,
                  size: 30,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CabezaPainter extends CustomPainter {
  const _CabezaPainter({required this.guinada, required this.activa});

  final double guinada;
  final bool activa;

  @override
  void paint(Canvas canvas, Size size) {
    final g = guinada.clamp(-1.0, 1.0);
    final a = g.abs();
    final cx = size.width / 2;
    final cy = size.height * 0.42;
    final rx = size.width * 0.38 * (1 - 0.06 * a);
    final ry = size.height * 0.36;
    // Encima de la cámara en vivo: trazo semitransparente para que la persona
    // se siga viendo por debajo.
    final alfa = activa ? 0.7 : 0.5;
    final trazo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white.withValues(alpha: alfa);
    final relleno = Paint()..color = Colors.white.withValues(alpha: 0.05);

    // Cuello y hombros (fijos: gira la cabeza, no el cuerpo).
    final hombros = Path()
      ..moveTo(cx - rx * 0.42, cy + ry * 0.92)
      ..lineTo(cx - rx * 0.42, cy + ry * 1.12)
      ..quadraticBezierTo(
        cx - rx * 1.25,
        cy + ry * 1.2,
        cx - rx * 1.4,
        size.height,
      )
      ..moveTo(cx + rx * 0.42, cy + ry * 0.92)
      ..lineTo(cx + rx * 0.42, cy + ry * 1.12)
      ..quadraticBezierTo(
        cx + rx * 1.25,
        cy + ry * 1.2,
        cx + rx * 1.4,
        size.height,
      );
    canvas.drawPath(hombros, trazo);

    // Orejas: al girar se ve solo la del lado que queda de frente.
    void oreja(double lado, double visible) {
      if (visible <= 0.02) return;
      final r = Rect.fromCenter(
        center: Offset(cx + lado * rx * 1.02, cy + ry * 0.05),
        width: rx * 0.22 * visible,
        height: ry * 0.32,
      );
      canvas
        ..drawOval(r, relleno)
        ..drawOval(
          r,
          trazo..color = Colors.white.withValues(alpha: alfa * visible),
        );
      trazo.color = Colors.white.withValues(alpha: alfa);
    }

    oreja(-1, (1 - g).clamp(0.0, 1.0));
    oreja(1, (1 + g).clamp(0.0, 1.0));

    // Cabeza.
    final cabeza = Rect.fromCenter(
      center: Offset(cx, cy),
      width: rx * 2,
      height: ry * 2,
    );
    canvas
      ..drawOval(cabeza, relleno)
      ..drawOval(cabeza, trazo);

    // Rasgos: se corren hacia el lado al que mira y el ojo lejano se achica.
    final desvio = g * rx * 0.48;
    final ojoY = cy - ry * 0.08;
    final sep = rx * 0.38 * (1 - 0.25 * a);
    for (final lado in [-1.0, 1.0]) {
      final lejos = (lado * g) < 0 ? a : 0.0;
      final ancho = rx * 0.2 * (1 - 0.6 * lejos);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + desvio + lado * sep * (1 - 0.35 * lejos), ojoY),
          width: ancho,
          height: ry * 0.09,
        ),
        Paint()..color = Colors.white.withValues(alpha: alfa),
      );
    }
    // Cejas.
    for (final lado in [-1.0, 1.0]) {
      final lejos = (lado * g) < 0 ? a : 0.0;
      final x = cx + desvio + lado * sep * (1 - 0.35 * lejos);
      final w = rx * 0.26 * (1 - 0.5 * lejos);
      canvas.drawLine(
        Offset(x - w / 2, ojoY - ry * 0.16),
        Offset(x + w / 2, ojoY - ry * 0.18),
        trazo,
      );
    }
    // Nariz: apunta hacia el lado del giro.
    final nx = cx + desvio * 1.1;
    canvas.drawPath(
      Path()
        ..moveTo(nx, ojoY + ry * 0.06)
        ..lineTo(nx + g * rx * 0.22, cy + ry * 0.28)
        ..lineTo(nx - g * rx * 0.02, cy + ry * 0.32),
      trazo,
    );
    // Boca.
    final bx = cx + desvio * 0.95;
    final bw = rx * 0.5 * (1 - 0.3 * a);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(bx, cy + ry * 0.48),
        width: bw,
        height: ry * 0.16,
      ),
      0.15 * math.pi,
      0.7 * math.pi,
      false,
      trazo,
    );
  }

  @override
  bool shouldRepaint(_CabezaPainter old) =>
      old.guinada != guinada || old.activa != activa;
}

class _AnilloPainter extends CustomPainter {
  _AnilloPainter({
    required this.ciclo,
    required this.avance,
    required this.grabando,
    required this.completo,
    required this.verde,
    required this.conMovimiento,
  });

  final double ciclo;
  final double avance;
  final bool grabando;
  final bool completo;
  final Color verde;
  final bool conMovimiento;

  static const _cian = Color(0xFF6FE7FF);

  Path _ovalo(Rect r) =>
      Path()
        ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(r.width / 2)));

  @override
  void paint(Canvas canvas, Size size) {
    final base = Offset.zero & size;
    final ovalo = _ovalo(base);
    final anillo = _ovalo(base.inflate(7));
    final metrica = anillo.computeMetrics().first;
    final activo = grabando || completo;
    final acento = activo ? verde : _cian;

    // Velo fuera del óvalo para centrar la mirada en la cara.
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(base.inflate(400))
        ..addPath(ovalo, Offset.zero),
      Paint()..color = const Color(0x59000000),
    );

    // Halo que respira.
    final respiro = 0.5 + 0.5 * math.sin(ciclo * math.pi * 2);
    canvas.drawPath(
      anillo,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..color = acento.withValues(alpha: 0.10 + 0.12 * respiro)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Pista del anillo.
    canvas.drawPath(
      anillo,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colors.white.withValues(alpha: 0.22),
    );

    // Progreso de la grabación en verde, con brillo.
    if (activo && avance > 0) {
      final arco = metrica.extractPath(0, metrica.length * avance);
      canvas
        ..drawPath(
          arco,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 9
            ..strokeCap = StrokeCap.round
            ..color = verde.withValues(alpha: 0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        )
        ..drawPath(
          arco,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round
            ..color = verde,
        );
      // Punta luminosa del progreso.
      final punta = metrica.getTangentForOffset(metrica.length * avance);
      if (punta != null && !completo) {
        canvas.drawCircle(
          punta.position,
          5,
          Paint()
            ..color = Colors.white
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }

    if (!conMovimiento) return;

    // Segmentos que giran por fuera del anillo (efecto de escáner).
    final exterior = _ovalo(base.inflate(15)).computeMetrics().first;
    final trazo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = acento.withValues(alpha: 0.75);
    for (var i = 0; i < 4; i++) {
      final inicio = ((ciclo + i / 4) % 1) * exterior.length;
      final largo = exterior.length * 0.06;
      final fin = inicio + largo;
      if (fin <= exterior.length) {
        canvas.drawPath(exterior.extractPath(inicio, fin), trazo);
      } else {
        canvas
          ..drawPath(exterior.extractPath(inicio, exterior.length), trazo)
          ..drawPath(exterior.extractPath(0, fin - exterior.length), trazo);
      }
    }

    // Partículas que orbitan alrededor del óvalo.
    final particula = Paint();
    for (var i = 0; i < 18; i++) {
      final semilla = i * 0.618033;
      final velocidad = 0.6 + (semilla % 1) * 0.8;
      final t = ((ciclo * velocidad) + semilla) % 1;
      final tan = exterior.getTangentForOffset(t * exterior.length);
      if (tan == null) continue;
      final normal = Offset(-tan.vector.dy, tan.vector.dx);
      final desvio = 4 + 10 * math.sin((t + semilla) * math.pi * 2).abs();
      final alfa = 0.25 + 0.6 * math.sin(t * math.pi).abs();
      particula.color = acento.withValues(alpha: alfa);
      canvas.drawCircle(
        tan.position + normal * desvio,
        1.2 + (i % 3) * 0.6,
        particula,
      );
    }

    // Línea de escaneo dentro del óvalo mientras se graba.
    if (grabando && !completo) {
      canvas
        ..save()
        ..clipPath(ovalo);
      final y = size.height * (0.5 + 0.42 * math.sin(ciclo * math.pi * 2));
      canvas
        ..drawRect(
          Rect.fromLTWH(0, y - 18, size.width, 36),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                verde.withValues(alpha: 0),
                verde.withValues(alpha: 0.18),
                verde.withValues(alpha: 0),
              ],
            ).createShader(Rect.fromLTWH(0, y - 18, size.width, 36)),
        )
        ..drawLine(
          Offset(0, y),
          Offset(size.width, y),
          Paint()
            ..strokeWidth = 1.5
            ..color = verde.withValues(alpha: 0.8),
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_AnilloPainter old) =>
      old.ciclo != ciclo ||
      old.avance != avance ||
      old.grabando != grabando ||
      old.completo != completo ||
      old.verde != verde;
}

/// Los tres pasos debajo del visor: el actual resaltado, los hechos con check.
class PasosPruebaVida extends StatelessWidget {
  const PasosPruebaVida({
    super.key,
    required this.etiquetas,
    required this.actual,
    required this.grabando,
  });

  /// Textos de izquierda, derecha y centro (traducidos por la pantalla).
  final List<String> etiquetas;
  final PasoPruebaVida actual;
  final bool grabando;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final verde = context.solColors.success;
    return Row(
      children: [
        for (final paso in PasoPruebaVida.values) ...[
          if (paso.index > 0) const SizedBox(width: SolSpacing.xs),
          Expanded(
            child: Builder(
              builder: (context) {
                final hecho = grabando && paso.index < actual.index;
                final activo = grabando && paso == actual;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SolSpacing.xs,
                    vertical: SolSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: activo
                        ? verde.withValues(alpha: 0.12)
                        : colors.surfaceContainer,
                    borderRadius: SolRadius.fullAll,
                    border: Border.all(
                      color: activo || hecho ? verde : colors.outlineVariant,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        hecho
                            ? Icons.check_circle_rounded
                            : switch (paso) {
                                PasoPruebaVida.izquierda =>
                                  Icons.arrow_back_rounded,
                                PasoPruebaVida.derecha =>
                                  Icons.arrow_forward_rounded,
                                PasoPruebaVida.centro =>
                                  Icons.radio_button_checked_rounded,
                              },
                        size: 16,
                        color: activo || hecho ? verde : colors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          etiquetas[paso.index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.solText.note.copyWith(
                            fontWeight: activo
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: activo ? colors.onSurface : colors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
