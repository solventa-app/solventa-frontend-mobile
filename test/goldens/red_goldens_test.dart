@Tags(['golden'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/core/network/network_providers.dart';
import 'package:solventa_mobile/core/red/conectividad.dart';
import 'package:solventa_mobile/core/red/estado_red.dart';
import 'package:solventa_mobile/core/red/estado_red_notifier.dart';
import 'package:solventa_mobile/core/red/presentation/banner_conexion.dart';
import 'package:solventa_mobile/core/red/sonda_red.dart';

import 'golden_helpers.dart';

/// HU-M05 (KAN-35, sin conexión): la franja de red y la píldora de calidad,
/// sueltas y dentro de una pantalla en español e inglés.
void main() {
  void noop() {}

  solGoldenMatrix(
    'connection_banner_chips',
    () => GoldenSheet(
      padding: 0,
      cases: {
        'Sin conexión': const SolConnectionBanner(
          tone: SolConnectionTone.offline,
          title: 'Sin conexión',
          message:
              'Puedes reportar un siniestro. Se envía cuando vuelva la señal.',
        ),
        'Sin conexión con pendiente': SolConnectionBanner(
          tone: SolConnectionTone.offline,
          title: 'Sin conexión · 1 reporte por enviar',
          actionLabel: 'Ver',
          onAction: noop,
        ),
        'Conexión lenta': const SolConnectionBanner(
          tone: SolConnectionTone.slow,
          title: 'Conexión lenta',
          message:
              'Estás con datos móviles y poca señal. El envío puede tardar.',
        ),
        'Enviando': const SolConnectionBanner(
          tone: SolConnectionTone.syncing,
          title: 'Conexión restablecida',
          message: 'Enviando 1 reporte…',
        ),
        'Enviado': SolConnectionBanner(
          tone: SolConnectionTone.done,
          title: 'Reporte enviado',
          message: 'Radicado SIN-2026-000123',
          actionLabel: 'Ver',
          onAction: noop,
        ),
        'Con el teclado abierto': const SolBannerScope(
          compact: true,
          child: SolConnectionBanner(
            tone: SolConnectionTone.offline,
            title: 'Sin conexión',
            message: 'No se muestra con el teclado abierto.',
          ),
        ),
        'Píldoras': const Padding(
          padding: EdgeInsets.symmetric(horizontal: SolSpacing.screen),
          child: Wrap(
            spacing: SolSpacing.sm,
            runSpacing: SolSpacing.sm,
            children: [
              SolNetworkChip(
                quality: SolNetworkQuality.good,
                link: SolNetworkLink.wifi,
                label: 'Wi-Fi · buena',
              ),
              SolNetworkChip(
                quality: SolNetworkQuality.good,
                link: SolNetworkLink.mobile,
                label: 'Datos · buena',
              ),
              SolNetworkChip(
                quality: SolNetworkQuality.fair,
                link: SolNetworkLink.wifi,
                label: 'Wi-Fi · regular',
              ),
              SolNetworkChip(
                quality: SolNetworkQuality.fair,
                link: SolNetworkLink.mobile,
                label: 'Datos · regular',
              ),
              SolNetworkChip(
                quality: SolNetworkQuality.poor,
                link: SolNetworkLink.mobile,
                label: 'Datos · mala',
              ),
              SolNetworkChip(
                quality: SolNetworkQuality.offline,
                label: 'Sin conexión',
              ),
            ],
          ),
        ),
      },
    ),
  );

  Widget pantalla(Locale locale, TipoRed tipo, ResultadoSonda sonda) =>
      ProviderScope(
        overrides: [
          usarFakesProvider.overrideWithValue(true),
          conectividadProvider.overrideWithValue(ConectividadFalsa(tipo)),
          sondaRedProvider.overrideWithValue(SondaFalsa(sonda)),
        ],
        child: Builder(
          builder: (context) => Localizations.override(
            context: context,
            locale: locale,
            delegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            child: Builder(
              builder: (context) => SolFlowScaffold(
                title: context.l10n.m05Titulo,
                onBack: noop,
                banner: const BannerConexion(),
                body: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ChipRed(),
                ),
              ),
            ),
          ),
        ),
      );

  final casos = <(double, double, Locale)>[
    (360, 1, AppLocales.es),
    (390, 2, AppLocales.es),
    (390, 1, AppLocales.en),
    (600, 1, AppLocales.es),
  ];

  for (final (ancho, escala, locale) in casos) {
    final sufijo = '${ancho.toInt()}_x${escala.toInt()}_${locale.languageCode}';
    goldenTest(
      'Franja sin conexión en pantalla · $sufijo',
      fileName: 'red_sin_conexion_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tight(Size(ancho, 320)),
      builder: () =>
          pantalla(locale, TipoRed.ninguna, const SondaSinRespuesta()),
    );
    goldenTest(
      'Franja conexión lenta en pantalla · $sufijo',
      fileName: 'red_lenta_$sufijo',
      textScaleFactor: escala,
      constraints: BoxConstraints.tight(Size(ancho, 320)),
      builder: () => pantalla(
        locale,
        TipoRed.movil,
        const SondaConRespuesta(Duration(seconds: 3)),
      ),
    );
  }
}
