import 'package:flutter/material.dart';

import '../../theme/context_x.dart';
import '../../tokens/sol_radius.dart';

/// Carga de una lista o de una tarjeta: bloques grises con la forma de lo que va a llegar, en lugar de un círculo girando.
///
/// Un [SolSkeletonGroup] reúne los bloques ([SolSkeleton]) que se ven a la vez y los hace latir juntos con un solo
/// controlador (con uno por bloque quedarían desfasados). Se anuncia a TalkBack con [message] (liveRegion) y los
/// bloques no se leen. Con «quitar animaciones» el latido se detiene y los bloques quedan quietos: la forma ya dice que
/// se está cargando, y no se mueve nada que moleste.
class SolSkeletonGroup extends StatefulWidget {
  const SolSkeletonGroup({
    super.key,
    required this.message,
    required this.child,
  });

  /// Qué se está cargando, p. ej. «Cargando tus siniestros…». Solo lo oye TalkBack.
  final String message;

  final Widget child;

  @override
  State<SolSkeletonGroup> createState() => _SolSkeletonGroupState();
}

class _SolSkeletonGroupState extends State<SolSkeletonGroup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _latido = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool? _animando;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animar = !MediaQuery.disableAnimationsOf(context);
    if (animar == _animando) return;
    _animando = animar;
    if (animar) {
      _latido.repeat(reverse: true);
    } else {
      _latido
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _latido.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: widget.message,
      excludeSemantics: true,
      child: _Latido(animation: _latido, child: widget.child),
    );
  }
}

class _Latido extends InheritedWidget {
  const _Latido({required this.animation, required super.child});

  final Animation<double> animation;

  static Animation<double>? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Latido>()?.animation;

  @override
  bool updateShouldNotify(_Latido old) => animation != old.animation;
}

/// Un bloque gris con la forma de un texto, un título, una insignia o un ícono.
///
/// Va dentro de un [SolSkeletonGroup]; suelto se ve igual pero sin latir.
class SolSkeleton extends StatelessWidget {
  const SolSkeleton({
    super.key,
    this.width,
    this.widthFactor,
    this.height = 16,
    this.radius = SolRadius.fieldAll,
  });

  /// Círculo: ícono o avatar.
  const SolSkeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      widthFactor = null,
      radius = SolRadius.fullAll;

  /// Ancho fijo. Sin él ni [widthFactor], ocupa todo el ancho disponible.
  final double? width;

  /// Fracción (0 a 1) del ancho disponible, para que las líneas no midan todas lo mismo.
  final double? widthFactor;

  final double height;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = colors.secondaryContainer;
    final claro = Color.alphaBlend(
      colors.surface.withValues(alpha: 0.55),
      base,
    );
    final latido = _Latido.maybeOf(context);

    Widget bloque(double t) => SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.lerp(base, claro, Curves.easeInOut.transform(t)),
          borderRadius: radius,
        ),
      ),
    );

    final contenido = latido == null
        ? bloque(0)
        : AnimatedBuilder(
            animation: latido,
            builder: (_, _) => bloque(latido.value),
          );
    final factor = widthFactor;
    return factor == null
        ? contenido
        : FractionallySizedBox(
            widthFactor: factor,
            alignment: AlignmentDirectional.centerStart,
            child: contenido,
          );
  }
}
