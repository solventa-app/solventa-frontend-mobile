import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';

void main() {
  group('tipoRedDe', () {
    test('sin interfaces o solo «none» es ninguna', () {
      expect(tipoRedDe(const []), TipoRed.ninguna);
      expect(tipoRedDe(const [ConnectivityResult.none]), TipoRed.ninguna);
    });

    test('con Wi-Fi y datos a la vez gana el Wi-Fi', () {
      expect(
        tipoRedDe(const [ConnectivityResult.mobile, ConnectivityResult.wifi]),
        TipoRed.wifi,
      );
    });

    test('datos del plan, aunque haya VPN encima', () {
      expect(
        tipoRedDe(const [ConnectivityResult.vpn, ConnectivityResult.mobile]),
        TipoRed.movil,
      );
    });

    test('ethernet, VPN o satélite cuentan como otra', () {
      expect(tipoRedDe(const [ConnectivityResult.ethernet]), TipoRed.otra);
      expect(tipoRedDe(const [ConnectivityResult.vpn]), TipoRed.otra);
      expect(tipoRedDe(const [ConnectivityResult.satellite]), TipoRed.otra);
    });
  });

  test('la conectividad falsa avisa cada cambio', () async {
    final falsa = ConectividadFalsa();
    addTearDown(falsa.cerrar);
    final vistos = <TipoRed>[];
    final sub = falsa.cambios.listen(vistos.add);
    addTearDown(sub.cancel);

    expect(await falsa.actual(), TipoRed.wifi);
    falsa.cambiar(TipoRed.ninguna);
    falsa.cambiar(TipoRed.movil);
    await Future<void>.delayed(Duration.zero);

    expect(vistos, [TipoRed.ninguna, TipoRed.movil]);
    expect(await falsa.actual(), TipoRed.movil);
  });

  test('EstadoRed resume conexión, lentitud y datos móviles', () {
    const lenta = EstadoRed(tipo: TipoRed.movil, calidad: CalidadRed.mala);
    const sin = EstadoRed(tipo: TipoRed.wifi, calidad: CalidadRed.sinConexion);

    expect(lenta.conectado, isTrue);
    expect(lenta.lenta, isTrue);
    expect(lenta.porDatosMoviles, isTrue);
    expect(sin.conectado, isFalse);
    expect(sin.porDatosMoviles, isFalse);
    expect(
      lenta,
      const EstadoRed(tipo: TipoRed.movil, calidad: CalidadRed.mala),
    );
  });
}
