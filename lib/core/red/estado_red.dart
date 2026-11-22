/// Por dónde sale el teléfono a internet (HU-M05, modo sin conexión).
enum TipoRed {
  wifi,

  /// Datos móviles del plan.
  movil,

  /// Ethernet, VPN u otra interfaz: hay red, sin saber cuál.
  otra,

  /// Sin Wi-Fi ni datos (modo avión, sin señal).
  ninguna,
}

/// Qué tan buena es la salida a internet, medida contra el gateway.
enum CalidadRed {
  /// La prueba responde en menos de [UmbralesRed.buena].
  buena,

  /// Entre [UmbralesRed.buena] y [UmbralesRed.mala].
  regular,

  /// Más de [UmbralesRed.mala], o falló una de las dos últimas pruebas.
  mala,

  /// Sin interfaz de red, o dos pruebas seguidas fallidas.
  sinConexion,
}

/// Umbrales de calidad. Quedan como constantes para ajustarlos después de
/// probar en teléfono real (plan de HU-M05 sin conexión, §4.1).
abstract final class UmbralesRed {
  static const buena = Duration(milliseconds: 600);
  static const mala = Duration(seconds: 2);

  /// Cada cuánto se prueba el gateway mientras alguien vigila la red (dentro
  /// del reporte o con reportes por enviar). Fuera de eso no se prueba.
  static const periodo = Duration(seconds: 20);

  /// Tras la primera prueba fallida se repite pronto: dos seguidas marcan
  /// «sin conexión» sin esperar el período completo.
  static const confirmacion = Duration(seconds: 2);
}

/// Estado de la red que ve toda la app.
final class EstadoRed {
  const EstadoRed({
    required this.tipo,
    required this.calidad,
    this.simulado = false,
  });

  /// Antes de la primera señal no se afirma que falte la conexión.
  static const inicial = EstadoRed(
    tipo: TipoRed.otra,
    calidad: CalidadRed.buena,
  );

  final TipoRed tipo;
  final CalidadRed calidad;

  /// «Simular sin conexión» de la demo (solo con `API_ENV=mock`).
  final bool simulado;

  bool get conectado => calidad != CalidadRed.sinConexion;
  bool get lenta => calidad == CalidadRed.mala;

  /// Sale por datos del plan: aplica la preferencia «solo con Wi-Fi».
  bool get porDatosMoviles => conectado && tipo == TipoRed.movil;

  @override
  bool operator ==(Object other) =>
      other is EstadoRed &&
      other.tipo == tipo &&
      other.calidad == calidad &&
      other.simulado == simulado;

  @override
  int get hashCode => Object.hash(tipo, calidad, simulado);

  @override
  String toString() => 'EstadoRed($tipo, $calidad)';
}
