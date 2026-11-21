import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/mapa/mapa_datos.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/mapa/mapa_mapbox.dart';

/// HU-M06 M14: qué errores de carga de Mapbox se avisan a la página. La vista
/// nativa no corre en `flutter test`, así que se prueba la decisión sola.
void main() {
  group('avisarErrorDeCarga', () {
    test('una sola vez por estilo: Mapbox manda un error por cada tesela', () {
      expect(
        avisarErrorDeCarga(
          estilo: EstiloMapa.satelite,
          yaAvisado: null,
          fuente: fuenteSateliteMapbox,
          tipo: MapLoadErrorType.STYLE,
        ),
        isTrue,
      );
      expect(
        avisarErrorDeCarga(
          estilo: EstiloMapa.satelite,
          yaAvisado: EstiloMapa.satelite,
          fuente: fuenteSateliteMapbox,
          tipo: MapLoadErrorType.STYLE,
        ),
        isFalse,
      );
    });

    test('ya en calles, las teselas del satélite que llegan tarde no cuentan', () {
      // Sin esto, volver a calles tras la falla del satélite escondería un mapa
      // de calles que sí carga.
      expect(
        avisarErrorDeCarga(
          estilo: EstiloMapa.calles,
          yaAvisado: null,
          fuente: fuenteSateliteMapbox,
          tipo: MapLoadErrorType.STYLE,
        ),
        isFalse,
      );
    });

    test('un error propio de las calles se avisa, también una sola vez', () {
      for (final fuente in <String?>['composite', null]) {
        expect(
          avisarErrorDeCarga(
            estilo: EstiloMapa.calles,
            yaAvisado: null,
            fuente: fuente,
            tipo: MapLoadErrorType.STYLE,
          ),
          isTrue,
          reason: 'fuente: $fuente',
        );
        expect(
          avisarErrorDeCarga(
            estilo: EstiloMapa.calles,
            yaAvisado: EstiloMapa.calles,
            fuente: fuente,
            tipo: MapLoadErrorType.STYLE,
          ),
          isFalse,
          reason: 'fuente: $fuente',
        );
      }
    });

    test('con otro estilo las fallas vuelven a contar', () {
      // Se avisó del satélite; al volver a probarlo tras pasar por calles, su
      // falla se avisa de nuevo (la página reinicia `yaAvisado`).
      expect(
        avisarErrorDeCarga(
          estilo: EstiloMapa.satelite,
          yaAvisado: EstiloMapa.calles,
          fuente: fuenteSateliteMapbox,
          tipo: MapLoadErrorType.STYLE,
        ),
        isTrue,
      );
    });

    test(
      'una tesela suelta, un sprite o una tipografía no esconden el mapa',
      () {
        for (final tipo in [
          MapLoadErrorType.TILE,
          MapLoadErrorType.SPRITE,
          MapLoadErrorType.GLYPHS,
        ]) {
          expect(
            avisarErrorDeCarga(
              estilo: EstiloMapa.calles,
              yaAvisado: null,
              fuente: 'composite',
              tipo: tipo,
              teselasFallidas: 1,
            ),
            isFalse,
            reason: tipo.name,
          );
        }
      },
    );

    test('el estilo o una fuente entera sí lo esconden', () {
      for (final tipo in [MapLoadErrorType.STYLE, MapLoadErrorType.SOURCE]) {
        expect(
          avisarErrorDeCarga(
            estilo: EstiloMapa.calles,
            yaAvisado: null,
            fuente: null,
            tipo: tipo,
          ),
          isTrue,
          reason: tipo.name,
        );
      }
    });

    test('muchas teselas del satélite seguidas cuentan como caído', () {
      // La cuenta sin el producto de satélite: fallan todas las teselas.
      expect(
        avisarErrorDeCarga(
          estilo: EstiloMapa.satelite,
          yaAvisado: null,
          fuente: fuenteSateliteMapbox,
          tipo: MapLoadErrorType.TILE,
          teselasFallidas: teselasParaRendirse - 1,
        ),
        isFalse,
      );
      expect(
        avisarErrorDeCarga(
          estilo: EstiloMapa.satelite,
          yaAvisado: null,
          fuente: fuenteSateliteMapbox,
          tipo: MapLoadErrorType.TILE,
          teselasFallidas: teselasParaRendirse,
        ),
        isTrue,
      );
    });
  });
}
