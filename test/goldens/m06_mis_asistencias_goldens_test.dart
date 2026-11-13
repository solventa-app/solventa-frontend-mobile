import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

import 'golden_helpers.dart';

void _nada() {}

/// HU-M06 fase 5 (4.1 y 4.2, boceto `boceto-mis-asistencias.png`): la tarjeta
/// de «Mis asistencias» en sus tres estados, con el aviso «Te alejaste», los
/// acordeones y el badge de la barra.
void main() {
  group('Mis asistencias (4.1 y 4.2)', () {
    solGoldenMatrix(
      'mis_asistencias_tarjetas',
      () => GoldenSheet(
        cases: {
          'En camino': const SolAccordion(
            title: 'En camino (2)',
            children: [
              SolAssistanceCard(
                name: 'Clínica Norte',
                icon: SolIcons.medical,
                isPartner: true,
                subtitle: 'Médica · pedida 9:20 a. m.',
                state: SolAssistanceOnTheWay(
                  countdown: 'Llega en 4 min',
                  estimatedTime: 'Hora estimada 9:26 a. m.',
                  progress: 0.6,
                ),
                semanticLabel: 'Clínica Norte, médica, llega en 4 min',
                onTap: _nada,
              ),
              SolDivider(),
              SolAssistanceCard(
                name: 'Taller AutoAyuda',
                icon: SolIcons.mechanic,
                isPartner: true,
                subtitle: 'Mecánica · pedida 9:21 a. m.',
                state: SolAssistanceUnconfirmed(
                  warning: 'No pudimos confirmar',
                  retryLabel: 'Reintentar',
                  onRetry: _nada,
                ),
                semanticLabel:
                    'Taller AutoAyuda, mecánica, no pudimos confirmar',
                onTap: _nada,
              ),
            ],
          ),
          'Te alejaste': const SolAssistanceCard(
            name: 'Grúas 24/7',
            icon: SolIcons.towTruck,
            isPartner: false,
            subtitle: 'Grúa · pedida 9:18 a. m.',
            state: SolAssistanceOnTheWay(
              countdown: 'Llega en 15 min',
              estimatedTime: 'Hora estimada 9:37 a. m.',
              progress: 0.2,
            ),
            semanticLabel: 'Grúas 24/7, grúa, llega en 15 min',
            onTap: _nada,
            notice: SolStatusBanner(
              status: SolStatus.warning,
              title:
                  'Te alejaste del lugar donde pediste la asistencia. El '
                  'prestador va a Cl. 93 # 14-20',
            ),
          ),
          'Ya llegaron (cerrado y abierto)': const Column(
            children: [
              SolAccordion(
                title: 'Ya llegaron (1)',
                initiallyExpanded: false,
                children: [],
              ),
              SizedBox(height: 8),
              SolAccordion(
                title: 'Ya llegaron (1)',
                children: [
                  SolAssistanceCard(
                    name: 'Taller El Motor',
                    icon: SolIcons.mechanic,
                    isPartner: false,
                    subtitle: 'Mecánica · pedida 6:10 p. m.',
                    state: SolAssistanceArrived('Llegó · 6:24 p. m.'),
                    semanticLabel: 'Taller El Motor, mecánica, llegó',
                    onTap: _nada,
                  ),
                ],
              ),
            ],
          ),
        },
      ),
    );
  });

  group('Barra con el badge de en camino (4.1)', () {
    solGoldenMatrix(
      'bottom_nav_badge',
      () => SolBottomNav(
        selectedIndex: 2,
        onDestinationSelected: (_) {},
        destinations: const [
          SolNavDestination(label: 'Inicio', icon: SolIcons.home),
          SolNavDestination(label: 'Asistencia', icon: SolIcons.assistance),
          SolNavDestination(
            label: 'Mis asistencias',
            icon: SolIcons.misAsistencias,
            badgeCount: 3,
          ),
          SolNavDestination(label: 'Cerrar sesión', icon: SolIcons.logout),
        ],
      ),
    );
  });
}
