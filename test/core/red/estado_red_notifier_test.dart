import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/senales_red.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';

/// Sonda que contesta cuando la prueba lo decide.
final class _SondaManual implements SondaRed {
  final pendientes = <Completer<ResultadoSonda>>[];

  @override
  Future<ResultadoSonda> probar() {
    final c = Completer<ResultadoSonda>();
    pendientes.add(c);
    return c.future;
  }
}

/// Interfaz que cambia sin avisar por el stream.
final class _ConectividadMuda implements Conectividad {
  _ConectividadMuda(this.tipo);

  TipoRed tipo;

  @override
  Future<TipoRed> actual() async => tipo;

  @override
  Stream<TipoRed> get cambios => const Stream.empty();
}

const _rapida = SondaConRespuesta(Duration(milliseconds: 80));
const _sinRespuesta = SondaSinRespuesta();

void main() {
  late ConectividadFalsa conectividad;
  late SondaFalsa sonda;
  late ProviderContainer contenedor;

  ProviderContainer crear({
    SondaRed? otraSonda,
    TipoRed inicial = TipoRed.wifi,
  }) {
    conectividad = ConectividadFalsa(inicial);
    sonda = SondaFalsa();
    final c = ProviderContainer(
      overrides: [
        conectividadProvider.overrideWithValue(conectividad),
        sondaRedProvider.overrideWithValue(otraSonda ?? sonda),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await conectividad.cerrar();
    });
    return contenedor = c;
  }

  EstadoRed estado() => contenedor.read(estadoRedProvider);
  EstadoRedNotifier notifier() => contenedor.read(estadoRedProvider.notifier);

  testWidgets('al empezar lee la interfaz y prueba el gateway', (tester) async {
    crear();
    expect(estado(), EstadoRed.inicial);

    await tester.pump();

    expect(
      estado(),
      const EstadoRed(tipo: TipoRed.wifi, calidad: CalidadRed.buena),
    );
    expect(sonda.pruebas, 1);
  });

  test('la duración de la prueba decide la calidad', () {
    CalidadRed de(int ms) =>
        EstadoRedNotifier.calidadDe(Duration(milliseconds: ms));

    expect(de(80), CalidadRed.buena);
    expect(de(599), CalidadRed.buena);
    expect(de(600), CalidadRed.regular);
    expect(de(2000), CalidadRed.regular);
    expect(de(2001), CalidadRed.mala);
  });

  testWidgets('sin interfaz no hay conexión y no se prueba', (tester) async {
    crear(inicial: TipoRed.ninguna);
    estado();

    await tester.pump();

    expect(
      estado(),
      const EstadoRed(tipo: TipoRed.ninguna, calidad: CalidadRed.sinConexion),
    );
    expect(sonda.pruebas, 0);
  });

  testWidgets('modo avión avisa al instante, sin esperar la prueba', (
    tester,
  ) async {
    crear();
    estado();
    await tester.pump();

    conectividad.cambiar(TipoRed.ninguna);
    await tester.pump();

    expect(estado().conectado, isFalse);
    expect(sonda.pruebas, 1);
  });

  testWidgets(
    'un fallo baja a mala; si a los 2 s sigue, es sin conexión; al volver se '
    'recupera en la siguiente prueba',
    (tester) async {
      crear();
      final soltar = notifier().vigilar();
      await tester.pump();
      expect(estado().calidad, CalidadRed.buena);

      sonda.resultado = _sinRespuesta;
      await tester.pump(UmbralesRed.periodo);
      expect(estado().calidad, CalidadRed.mala);
      expect(estado().conectado, isTrue);

      await tester.pump(UmbralesRed.confirmacion);
      expect(estado().calidad, CalidadRed.sinConexion);
      expect(estado().tipo, TipoRed.wifi);

      sonda.resultado = _rapida;
      await tester.pump(UmbralesRed.periodo);
      expect(estado().calidad, CalidadRed.buena);
      soltar();
    },
  );

  testWidgets('un corte breve no llega a «sin conexión»', (tester) async {
    crear();
    final soltar = notifier().vigilar();
    await tester.pump();

    sonda.resultado = _sinRespuesta;
    await tester.pump(UmbralesRed.periodo);
    sonda.resultado = _rapida;
    await tester.pump(UmbralesRed.confirmacion);

    expect(estado().calidad, CalidadRed.buena);
    soltar();
  });

  testWidgets('sin pantallas mirando no hay pruebas periódicas', (
    tester,
  ) async {
    crear();
    estado();
    await tester.pump();
    final antes = sonda.pruebas;

    await tester.pump(UmbralesRed.periodo * 5);
    expect(sonda.pruebas, antes);

    final soltar = notifier().vigilar();
    await tester.pump();
    await tester.pump(UmbralesRed.periodo * 2);
    expect(sonda.pruebas, antes + 3);

    soltar();
    soltar();
    await tester.pump(UmbralesRed.periodo * 5);
    expect(sonda.pruebas, antes + 3);
  });

  testWidgets('en segundo plano se detienen las pruebas y al volver siguen', (
    tester,
  ) async {
    crear();
    final soltar = notifier().vigilar();
    await tester.pump();
    final antes = sonda.pruebas;

    notifier().alOcultarse();
    await tester.pump(UmbralesRed.periodo * 3);
    expect(sonda.pruebas, antes);

    unawaited(notifier().alVolverAlFrente());
    await tester.pump();
    expect(sonda.pruebas, antes + 1);
    await tester.pump(UmbralesRed.periodo);
    expect(sonda.pruebas, antes + 2);
    soltar();
  });

  testWidgets('al volver al frente relee la interfaz', (tester) async {
    // El teléfono cambió de red con la app oculta y el aviso se perdió.
    final muda = _ConectividadMuda(TipoRed.wifi);
    sonda = SondaFalsa();
    contenedor = ProviderContainer(
      overrides: [
        conectividadProvider.overrideWithValue(muda),
        sondaRedProvider.overrideWithValue(sonda),
      ],
    );
    addTearDown(contenedor.dispose);
    estado();
    await tester.pump();
    expect(estado().tipo, TipoRed.wifi);

    muda.tipo = TipoRed.movil;
    unawaited(notifier().alVolverAlFrente());
    await tester.pump();

    expect(estado().tipo, TipoRed.movil);
    expect(estado().porDatosMoviles, isTrue);
  });

  testWidgets('la prueba que empezó en otra interfaz ya no vale', (
    tester,
  ) async {
    final manual = _SondaManual();
    crear(otraSonda: manual);
    estado();
    await tester.pump();
    expect(manual.pendientes, hasLength(1));

    conectividad.cambiar(TipoRed.movil);
    await tester.pump();
    expect(manual.pendientes, hasLength(2));

    // La del Wi-Fi contesta tarde y mal: se ignora.
    manual.pendientes[0].complete(_sinRespuesta);
    await tester.pump();
    expect(estado().calidad, CalidadRed.buena);

    manual.pendientes[1].complete(
      const SondaConRespuesta(Duration(milliseconds: 900)),
    );
    await tester.pump();
    expect(
      estado(),
      const EstadoRed(tipo: TipoRed.movil, calidad: CalidadRed.regular),
    );
  });

  testWidgets('varias llamadas a comprobar comparten una sola prueba', (
    tester,
  ) async {
    final manual = _SondaManual();
    crear(otraSonda: manual);
    estado();
    await tester.pump();

    unawaited(notifier().comprobar());
    unawaited(notifier().comprobar());
    await tester.pump();

    expect(manual.pendientes, hasLength(1));
    manual.pendientes.single.complete(_rapida);
    await tester.pump();
  });

  testWidgets('al recuperar la interfaz sigue sin conexión hasta que la prueba '
      'conteste', (tester) async {
    final manual = _SondaManual();
    crear(otraSonda: manual, inicial: TipoRed.ninguna);
    estado();
    await tester.pump();

    conectividad.cambiar(TipoRed.wifi);
    await tester.pump();
    expect(
      estado(),
      const EstadoRed(tipo: TipoRed.wifi, calidad: CalidadRed.sinConexion),
    );

    manual.pendientes.single.complete(_rapida);
    await tester.pump();
    expect(estado().calidad, CalidadRed.buena);
  });

  group('señales de las peticiones reales', () {
    testWidgets('un corte de conexión marca sin conexión al instante', (
      tester,
    ) async {
      crear();
      estado();
      await tester.pump();

      contenedor.read(senalesRedProvider).falloDeConexion();

      expect(estado().calidad, CalidadRed.sinConexion);
    });

    testWidgets('una respuesta del servidor estando sin conexión la recupera', (
      tester,
    ) async {
      crear();
      estado();
      await tester.pump();
      final senales = contenedor.read(senalesRedProvider)..falloDeConexion();

      senales.respuesta();
      expect(estado().calidad, CalidadRed.regular);
      await tester.pump();
      expect(estado().calidad, CalidadRed.buena);
    });

    testWidgets('un tiempo agotado baja a mala', (tester) async {
      crear();
      estado();
      await tester.pump();

      contenedor.read(senalesRedProvider).tiempoAgotado();

      expect(estado().calidad, CalidadRed.mala);
      expect(estado().conectado, isTrue);
    });

    testWidgets('con la conexión buena, una respuesta no cambia nada', (
      tester,
    ) async {
      crear();
      estado();
      await tester.pump();
      final antes = sonda.pruebas;

      contenedor.read(senalesRedProvider).respuesta();
      await tester.pump();

      expect(sonda.pruebas, antes);
      expect(estado().calidad, CalidadRed.buena);
    });
  });

  group('simulación de la demo', () {
    testWidgets(
      'fuerza sin conexión y no la pisan ni la prueba ni la interfaz',
      (tester) async {
        crear();
        final soltar = notifier().vigilar();
        await tester.pump();

        notifier().simular(CalidadRed.sinConexion);
        expect(
          estado(),
          const EstadoRed(
            tipo: TipoRed.ninguna,
            calidad: CalidadRed.sinConexion,
            simulado: true,
          ),
        );

        await tester.pump(UmbralesRed.periodo);
        conectividad.cambiar(TipoRed.movil);
        contenedor.read(senalesRedProvider).respuesta();
        await tester.pump();
        expect(estado().simulado, isTrue);
        expect(estado().conectado, isFalse);
        soltar();
      },
    );

    testWidgets('conexión lenta simulada va por datos', (tester) async {
      crear();
      estado();
      await tester.pump();

      notifier().simular(CalidadRed.mala);

      expect(estado().lenta, isTrue);
      expect(estado().porDatosMoviles, isTrue);
    });

    testWidgets('al quitarla vuelve al estado real', (tester) async {
      crear();
      estado();
      await tester.pump();
      notifier().simular(CalidadRed.sinConexion);

      notifier().simular(null);
      await tester.pump();

      expect(
        estado(),
        const EstadoRed(tipo: TipoRed.wifi, calidad: CalidadRed.buena),
      );
    });
  });
}
