/// Regla de la clave al crear la cuenta (T17). Es la misma que aplica AUTH
/// (`validar_clave`): entre 8 y 128 caracteres contados como puntos de código,
/// con al menos una mayúscula, una minúscula y un carácter especial.
///
/// Es global (Unicode): mayúscula es `\p{Lu}`, minúscula `\p{Ll}` y especial
/// cualquier carácter que no sea letra ni número. El servidor sigue siendo la
/// autoridad; esto solo guía al usuario mientras escribe.
final class ReglaClave {
  const ReglaClave._({
    required this.largo,
    required this.mayuscula,
    required this.minuscula,
    required this.especial,
  });

  static final _mayuscula = RegExp(r'\p{Lu}', unicode: true);
  static final _minuscula = RegExp(r'\p{Ll}', unicode: true);
  static final _especial = RegExp(r'[^\p{L}\p{N}]', unicode: true);

  factory ReglaClave.evaluar(String clave) {
    final n = clave.runes.length;
    return ReglaClave._(
      largo: n >= 8 && n <= 128,
      mayuscula: _mayuscula.hasMatch(clave),
      minuscula: _minuscula.hasMatch(clave),
      especial: _especial.hasMatch(clave),
    );
  }

  final bool largo;
  final bool mayuscula;
  final bool minuscula;
  final bool especial;

  bool get cumple => largo && mayuscula && minuscula && especial;
}
