import 'falla.dart';

/// Resultado de una operación de repositorio: [Exito] o [Fracaso], nunca una excepción.
sealed class Resultado<T> {
  const Resultado();
}

final class Exito<T> extends Resultado<T> {
  const Exito(this.valor);
  final T valor;
}

final class Fracaso<T> extends Resultado<T> {
  const Fracaso(this.falla);
  final Falla falla;
}
