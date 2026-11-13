import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/ubicacion/ubicacion_service.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/asistencia_remote_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/datasources/catalogo_local_datasource.dart';
import 'package:solventa_mobile/features/assistance/data/fixtures/asistencia_fixtures.dart';
import 'package:solventa_mobile/features/assistance/data/mappers/prestador_mapper.dart';
import 'package:solventa_mobile/features/assistance/domain/cercania.dart';
import 'package:solventa_mobile/features/assistance/domain/entities/prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/pages/m06_01_prestadores_page.dart';
import 'package:solventa_mobile/features/assistance/presentation/providers.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/detalle_prestador.dart';
import 'package:solventa_mobile/features/assistance/presentation/widgets/mapa/mapa_datos.dart';

import 'golden_helpers.dart';

void _nada() {}
void _nadaCon(PrestadorCercano c, Coordenada o) {}
void _nadaP(Prestador p) {}

/// HU-M06 fase 2 (plan de pendientes): pines del mapa (M1, M3, M4), M06-01 con
/// el mapa falso (la vista nativa de Mapbox no se pinta en `flutter test`) y
/// el detalle del prestador (2.2). Mismos anchos y escalas que los demás.
void main() {
  group('Pines del mapa (M1, M3, M4)', () {
    solGoldenMatrix(
      'map_pins',
      () => const GoldenSheet(
        cases: {
          'Destacados: aliado, no aliado y seleccionado': Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SolMapPin(
                style: SolMapPinStyle(
                  type: SolProviderType.medico,
                  isPartner: true,
                  featured: true,
                  label: '6 min',
                ),
              ),
              SolMapPin(
                style: SolMapPinStyle(
                  type: SolProviderType.mecanico,
                  isPartner: false,
                  featured: true,
                  label: '9 min',
                ),
              ),
              SolMapPin(
                style: SolMapPinStyle(
                  type: SolProviderType.grua,
                  isPartner: true,
                  featured: true,
                  selected: true,
                  label: '12 min',
                ),
              ),
            ],
          ),
          'Resto de la ciudad y el cliente': Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SolMapPin(
                style: SolMapPinStyle(
                  type: SolProviderType.medico,
                  isPartner: false,
                ),
              ),
              SolMapPin(
                style: SolMapPinStyle(
                  type: SolProviderType.grua,
                  isPartner: true,
                ),
              ),
              SolMapUserPin(),
            ],
          ),
        },
      ),
    );
  });

  Widget conL10n(Widget hijo, Locale locale) => Builder(
    builder: (context) => Localizations.override(
      context: context,
      locale: locale,
      delegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      child: hijo,
    ),
  );

  final casos = <(double, double, Locale)>[
    (360, 1, AppLocales.es),
    (390, 1, AppLocales.es),
    (390, 2, AppLocales.es),
    (390, 1, AppLocales.en),
  ];

  for (final (ancho, escala, locale) in casos) {
    final sufijo = '${ancho.toInt()}_x${escala.toInt()}_${locale.languageCode}';
    goldenTest(
      'M06-01 con el mapa · $sufijo',
      fileName: 'm06_01_mapa_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tight(Size(ancho, 760)),
      builder: () => ProviderScope(
        overrides: [
          asistenciaRemoteDataSourceProvider.overrideWithValue(
            FakeAsistenciaRemoteDataSource(latencia: Duration.zero),
          ),
          catalogoLocalDataSourceProvider.overrideWithValue(
            MemoriaCatalogoLocalDataSource(),
          ),
          ubicacionServiceProvider.overrideWithValue(FakeUbicacionService()),
          motorMapaProvider.overrideWithValue(MotorMapa.falso),
        ],
        child: conL10n(
          const Scaffold(
            body: M0601PrestadoresPage(
              onSolicitar: _nadaCon,
              onSolicitarConDireccion: _nadaP,
            ),
          ),
          locale,
        ),
      ),
    );

    final catalogo = catalogoDesdeMapa(AsistenciaFixtures.catalogo);
    final cercano = Cercania.masCercanos(
      const Coordenada(4.6767, -74.0483),
      catalogo.prestadores,
    ).first;
    goldenTest(
      'Detalle del prestador (2.2) · $sufijo',
      fileName: 'm06_detalle_prestador_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tightFor(width: ancho),
      builder: () => conL10n(
        Builder(
          builder: (context) => ColoredBox(
            color: context.colors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DetallePrestador(
                cercano: cercano,
                destacado: true,
                tipo: context.l10n.m0601TipoMedico,
                onSolicitar: _nada,
                onComoLlegar: _nada,
              ),
            ),
          ),
        ),
        locale,
      ),
    );
  }
}
