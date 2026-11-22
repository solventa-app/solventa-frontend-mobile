import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:solventa_mobile/core/red/senales_red.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';

void main() {
  const base = 'http://gateway.test';

  late Dio dio;
  late DioAdapter adaptador;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: base));
    adaptador = DioAdapter(dio: dio);
  });

  group('SondaGateway', () {
    SondaGateway sonda() => SondaGateway(baseUrl: base, dio: dio);

    test('el BFF contesta ok: hay salida y se mide el tiempo', () async {
      adaptador.onGet(
        SondaGateway.ruta,
        (s) => s.reply(200, {'servicio': 'bff', 'estado': 'ok'}),
      );

      expect(await sonda().probar(), isA<SondaConRespuesta>());
    });

    test(
      'un portal cautivo contesta 200 con su página: no hay salida',
      () async {
        adaptador.onGet(
          SondaGateway.ruta,
          (s) => s.reply(200, '<html>Acepta los términos del Wi-Fi</html>'),
        );

        expect(await sonda().probar(), isA<SondaSinRespuesta>());
      },
    );

    test('un 503 del gateway no cuenta como salida', () async {
      adaptador.onGet(
        SondaGateway.ruta,
        (s) => s.reply(503, {'estado': 'caido'}),
      );

      expect(await sonda().probar(), isA<SondaSinRespuesta>());
    });

    test(
      'sin red la prueba no lanza: responde que no hubo respuesta',
      () async {
        adaptador.onGet(
          SondaGateway.ruta,
          (s) => s.throws(
            0,
            DioException(
              requestOptions: RequestOptions(path: SondaGateway.ruta),
              type: DioExceptionType.connectionError,
            ),
          ),
        );

        expect(await sonda().probar(), isA<SondaSinRespuesta>());
      },
    );

    test('solo vale 200 con el cuerpo del BFF', () {
      expect(SondaGateway.respuestaValida(200, {'estado': 'ok'}), isTrue);
      expect(SondaGateway.respuestaValida(204, {'estado': 'ok'}), isFalse);
      expect(SondaGateway.respuestaValida(200, 'ok'), isFalse);
      expect(SondaGateway.respuestaValida(200, null), isFalse);
      expect(SondaGateway.respuestaValida(null, {'estado': 'ok'}), isFalse);
    });
  });

  group('InterceptorSenalesRed', () {
    late List<String> senales;

    setUp(() {
      senales = [];
      final buzon = SenalesRed()
        ..alFallarConexion = (() => senales.add('sin-conexion'))
        ..alAgotarTiempo = (() => senales.add('lenta'))
        ..alResponder = (() => senales.add('respuesta'));
      dio.interceptors.add(InterceptorSenalesRed(buzon));
    });

    DioException falla(DioExceptionType tipo) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: tipo,
    );

    test('una respuesta 2xx avisa que hay salida', () async {
      adaptador.onGet('/x', (s) => s.reply(200, {'a': 1}));

      await dio.get<Object?>('/x');

      expect(senales, ['respuesta']);
    });

    test('un 500 también es una respuesta del servidor', () async {
      adaptador.onGet('/x', (s) => s.reply(500, {'a': 1}));

      await expectLater(dio.get<Object?>('/x'), throwsA(isA<DioException>()));

      expect(senales, ['respuesta']);
    });

    test('un corte de conexión avisa al instante', () async {
      adaptador.onGet(
        '/x',
        (s) => s.throws(0, falla(DioExceptionType.connectionError)),
      );

      await expectLater(dio.get<Object?>('/x'), throwsA(isA<DioException>()));

      expect(senales, ['sin-conexion']);
    });

    test('un tiempo agotado avisa que la red está lenta', () async {
      adaptador.onGet(
        '/x',
        (s) => s.throws(0, falla(DioExceptionType.receiveTimeout)),
      );

      await expectLater(dio.get<Object?>('/x'), throwsA(isA<DioException>()));

      expect(senales, ['lenta']);
    });

    test('cancelar una petición no dice nada de la red', () async {
      adaptador.onGet('/x', (s) => s.throws(0, falla(DioExceptionType.cancel)));

      await expectLater(dio.get<Object?>('/x'), throwsA(isA<DioException>()));

      expect(senales, isEmpty);
    });

    test('sin nadie escuchando, las señales no hacen nada', () {
      SenalesRed()
        ..falloDeConexion()
        ..tiempoAgotado()
        ..respuesta();
    });
  });
}
