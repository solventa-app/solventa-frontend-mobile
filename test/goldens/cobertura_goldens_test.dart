import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/parametric/data/datasources/cobertura_remote_datasource.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_02_celebracion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_03_detalle_indemnizacion_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/pages/m04_04_cobertura_page.dart';
import 'package:solventa_mobile/features/parametric/presentation/providers.dart';

/// Flecha visible como en el diseño (sin navegación todavía, M04-D2).
void _atras() {}

/// Goldens de HU-M04 contra el diseño: M04-02 (Figma 2005:301), M04-03 (Figma
/// 2005:217) y M04-04 en sus tres estados (mockups de `docs/hu-m04/diseno/`).
/// 360, 390 y 600 dp con texto al 100 %, 360 / 390 dp al 200 % en español y
/// 390 dp en inglés. La flecha se muestra como en el diseño (callback vacío).
void main() {
  const alto = 844.0;
  const id = 'IND-2026-0912';

  Widget app(Widget page, Locale locale, EscenarioCobertura escenario) {
    return ProviderScope(
      overrides: [
        coberturaRemoteDataSourceProvider.overrideWithValue(
          FakeCoberturaRemoteDataSource(
            escenario: escenario,
            latencia: Duration.zero,
          ),
        ),
      ],
      child: Builder(
        builder: (context) => Localizations.override(
          context: context,
          locale: locale,
          delegates: const [
            AppLocalizations.delegate,
            // M04-04 usa RefreshIndicator, que pide las de Material.
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          child: page,
        ),
      ),
    );
  }

  void pantalla(
    String nombre,
    Widget page, [
    EscenarioCobertura escenario = EscenarioCobertura.sinSaldo,
  ]) {
    final casos = <(double, double, Locale)>[
      (360, 1, AppLocales.es),
      (390, 1, AppLocales.es),
      (600, 1, AppLocales.es),
      (360, 2, AppLocales.es),
      (390, 2, AppLocales.es),
      (390, 1, AppLocales.en),
    ];
    for (final (ancho, escala, locale) in casos) {
      final idioma = locale.languageCode;
      goldenTest(
        '$nombre · ${ancho.toInt()} dp · texto ${(escala * 100).toInt()} % · $idioma',
        fileName: '${nombre}_${ancho.toInt()}_x${escala.toInt()}_$idioma',
        textScaleFactor: escala,
        constraints: BoxConstraints.tight(Size(ancho, alto)),
        builder: () => app(page, locale, escenario),
      );
    }
  }

  pantalla(
    'm04_02_celebracion',
    const M0402CelebracionPage(id: id, onBack: _atras),
  );
  pantalla(
    'm04_03_detalle',
    const M0403DetalleIndemnizacionPage(id: id, onBack: _atras),
  );
  pantalla('m04_04_sin_saldo', const M0404CoberturaPage(onBack: _atras));
  pantalla(
    'm04_04_saldo_favor',
    const M0404CoberturaPage(onBack: _atras),
    EscenarioCobertura.aFavor,
  );
  pantalla(
    'm04_04_saldo_contra',
    const M0404CoberturaPage(onBack: _atras),
    EscenarioCobertura.enContra,
  );
}
