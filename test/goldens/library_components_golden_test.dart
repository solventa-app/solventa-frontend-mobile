@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import 'golden_helpers.dart';

/// Componentes de la librería de Figma (2018:2).
void main() {
  void noop() {}

  group('Botón (2018:16)', () {
    solGoldenMatrix(
      'button_variants',
      () => GoldenSheet(
        cases: {
          'Primario': SolButton.primary(label: 'Continuar', onPressed: noop),
          'Tonal': SolButton.tonal(label: 'Reintentar', onPressed: noop),
          'Destructivo': SolButton.destructive(
            label: 'Sí, cancelar',
            onPressed: noop,
          ),
          'Deshabilitado': const SolButton.primary(
            label: 'Continuar',
            onPressed: null,
          ),
          'Texto': Center(
            child: SolButton.text(
              label: 'Usar PIN en su lugar',
              onPressed: noop,
            ),
          ),
          'Delineado con ícono (M01-03)': SolButton.outlined(
            label: 'Repetir',
            icon: SolIcons.retry,
            onPressed: noop,
          ),
          'Primario con ícono (M01-03)': SolButton.primary(
            label: 'Capturar',
            icon: SolIcons.camera,
            onPressed: noop,
          ),
          'Primario cargando': SolButton.primary(
            label: 'Enviar solicitud',
            loading: true,
            onPressed: noop,
          ),
          'Ancho del contenido': Center(
            child: SolButton.primary(
              label: 'Continuar',
              expand: false,
              onPressed: noop,
            ),
          ),
        },
      ),
      pumpBeforeTest: pumpSpinner,
    );
  });

  group('Barra superior (2018:35)', () {
    solGoldenMatrix(
      'top_bar',
      () => GoldenSheet(
        padding: 0,
        cases: {
          'Con volver': SolTopBar.flow(
            title: 'Título de pantalla',
            onBack: noop,
          ),
          'Con volver · título largo': SolTopBar.flow(
            title: 'Autorización de datos personales',
            onBack: noop,
          ),
          'Inicio': const SolTopBar.home(),
          'Sin flecha (entrada / transitoria)': const SolTopBar.flow(
            title: 'Verificación',
            showBack: false,
          ),
        },
      ),
    );
  });

  group('Barra de navegación inferior (2018:76)', () {
    solGoldenMatrix(
      'bottom_nav',
      () => GoldenSheet(
        padding: 0,
        cases: {
          'Inicio activo': SolBottomNav(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
          ),
          'Asistencia activo': SolBottomNav(
            selectedIndex: 1,
            onDestinationSelected: (_) {},
          ),
        },
      ),
    );
  });

  group('Idioma y moneda (2018:3)', () {
    solGoldenMatrix(
      'locale_chip',
      () => GoldenSheet(
        cases: {
          'ES · COP': Align(
            alignment: Alignment.centerLeft,
            child: SolLocaleChip(onTap: noop),
          ),
          'EN · COP': const Align(
            alignment: Alignment.centerLeft,
            child: SolLocaleChip(label: 'EN · COP'),
          ),
        },
      ),
    );
  });

  group('Fila de prestador (2018:103)', () {
    solGoldenMatrix(
      'provider_row',
      () => GoldenSheet(
        cases: {
          'Médico': SolProviderRow(
            name: 'Clínica Norte',
            type: SolProviderType.medico,
            distance: SolFormat.distanceKm(1.2),
            eta: SolFormat.minutes(6),
            onRequest: noop,
          ),
          'Mecánico': SolProviderRow(
            name: 'Taller AutoAyuda',
            type: SolProviderType.mecanico,
            distance: SolFormat.distanceKm(2),
            eta: SolFormat.minutes(9),
            onRequest: noop,
          ),
        },
      ),
    );
  });

  group('Disparador de demo (2018:17)', () {
    solGoldenMatrix(
      'demo_trigger',
      () => GoldenSheet(
        cases: {
          'Disparador de demo': SolDemoTrigger(
            label: 'Simular que no reconoce la biometría',
            onTap: noop,
          ),
        },
      ),
    );
  });

  group('Avatar', () {
    solGoldenMatrix(
      'avatar',
      () => GoldenSheet(
        cases: {
          'Mi perfil (32 dp)': Align(
            alignment: Alignment.centerLeft,
            child: SolAvatar(onTap: noop),
          ),
          'Iniciales': const Align(
            alignment: Alignment.centerLeft,
            child: SolAvatar(initials: 'MR', size: 40),
          ),
        },
      ),
    );
  });
}
