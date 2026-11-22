import 'package:dio/dio.dart';

/// Resultado de una prueba al gateway.
sealed class ResultadoSonda {
  const ResultadoSonda();
}

/// El gateway respondió lo esperado en [duracion].
final class SondaConRespuesta extends ResultadoSonda {
  const SondaConRespuesta(this.duracion);
  final Duration duracion;
}

/// No hubo respuesta, o respondió otra cosa (p. ej. el portal cautivo de un
/// Wi-Fi público).
final class SondaSinRespuesta extends ResultadoSonda {
  const SondaSinRespuesta();
}

/// Prueba de salida real a internet: `GET {API_BASE_URL}/health`. Tener Wi-Fi
/// no es tener internet; esta prueba decide.
abstract interface class SondaRed {
  Future<ResultadoSonda> probar();
}

final class SondaGateway implements SondaRed {
  SondaGateway({
    required String baseUrl,
    Dio? dio,
    Stopwatch Function()? cronometro,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: tiempoMaximo,
               receiveTimeout: tiempoMaximo,
               responseType: ResponseType.json,
             ),
           ),
       _cronometro = cronometro ?? Stopwatch.new;

  /// Más de esto ya es «mala» de sobra; no se espera más.
  static const tiempoMaximo = Duration(seconds: 4);

  static const ruta = '/health';

  final Dio _dio;
  final Stopwatch Function() _cronometro;

  @override
  Future<ResultadoSonda> probar() async {
    final reloj = _cronometro()..start();
    try {
      final r = await _dio.get<Object?>(
        ruta,
        options: Options(validateStatus: (_) => true),
      );
      reloj.stop();
      return respuestaValida(r.statusCode, r.data)
          ? SondaConRespuesta(reloj.elapsed)
          : const SondaSinRespuesta();
    } on DioException {
      return const SondaSinRespuesta();
    }
  }

  /// Un portal cautivo contesta 200 con su propia página: solo vale el
  /// cuerpo del BFF (`{"servicio": "bff", "estado": "ok"}`).
  static bool respuestaValida(int? status, Object? cuerpo) =>
      status == 200 && cuerpo is Map && cuerpo['estado'] == 'ok';

  void cerrar() => _dio.close();
}

/// Para pruebas y `API_ENV=mock`: responde lo que se le diga.
final class SondaFalsa implements SondaRed {
  SondaFalsa([
    this.resultado = const SondaConRespuesta(Duration(milliseconds: 80)),
  ]);

  ResultadoSonda resultado;

  /// Cuántas veces se probó.
  int pruebas = 0;

  @override
  Future<ResultadoSonda> probar() async {
    pruebas++;
    return resultado;
  }
}
