@Tags(['golden'])
library;

import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';
import 'package:solventa_mobile/features/onboarding/domain/repositories/verificacion_repository.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_01_bienvenida_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_02_autorizacion_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_03_documento_frente_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_04_documento_reverso_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_05_prueba_vida_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_06_verificando_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_07_resultado_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/pages/m01_08_biometria_page.dart';
import 'package:solventa_mobile/features/onboarding/presentation/providers.dart';

import 'golden_helpers.dart';

/// Verificación que nunca termina: M01-06 queda cargando sin timers pendientes.
class _NuncaTermina implements VerificacionRepository {
  @override
  Future<Resultado<EstadoVerificacion>> verificar() =>
      Completer<Resultado<EstadoVerificacion>>().future;
}

class _EstadoFijo extends OnboardingNotifier {
  _EstadoFijo(this._estado);
  final OnboardingState _estado;

  @override
  OnboardingState build() => _estado;
}

/// Goldens de las pantallas de HU-M01 contra Figma: 360, 390 y 600 dp con
/// texto al 100 %, y 360 / 390 dp con texto al 200 %, en español. En inglés,
/// 390 dp al 100 %.
void main() {
  const alto = 844.0;

  Widget app(Widget page, Locale locale, [OnboardingState? estado]) {
    return ProviderScope(
      overrides: [
        verificacionRepositoryProvider.overrideWithValue(_NuncaTermina()),
        if (estado != null)
          onboardingProvider.overrideWith(() => _EstadoFijo(estado)),
      ],
      child: Builder(
        builder: (context) => Localizations.override(
          context: context,
          locale: locale,
          delegates: const [AppLocalizations.delegate],
          child: page,
        ),
      ),
    );
  }

  void pantalla(String id, Widget page, {OnboardingState? estado}) {
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
        '$id · ${ancho.toInt()} dp · texto ${(escala * 100).toInt()} % · $idioma',
        fileName: '${id}_${ancho.toInt()}_x${escala.toInt()}_$idioma',
        textScaleFactor: escala,
        constraints: BoxConstraints.tight(Size(ancho, alto)),
        pumpBeforeTest: pumpSpinner,
        builder: () => app(page, locale, estado),
      );
    }
  }

  pantalla('m01_01_bienvenida', const M0101BienvenidaPage());
  pantalla('m01_02_autorizacion', const M0102AutorizacionPage());
  pantalla(
    'm01_02b_consentimiento_marcado',
    const M0102AutorizacionPage(),
    estado: const OnboardingState(consentimientoMarcado: true),
  );
  pantalla('m01_03_documento_frente', const M0103DocumentoFrentePage());
  pantalla('m01_04_documento_reverso', const M0104DocumentoReversoPage());
  pantalla('m01_05_prueba_vida', const M0105PruebaVidaPage());
  pantalla('m01_06_verificando', const M0106VerificandoPage());
  pantalla(
    'm01_07a_verificada',
    const M0107ResultadoPage(),
    estado: const OnboardingState(verificacion: EstadoVerificacion.verificada),
  );
  pantalla(
    'm01_07b_en_revision',
    const M0107ResultadoPage(),
    estado: const OnboardingState(verificacion: EstadoVerificacion.enRevision),
  );
  pantalla(
    'm01_07c_rechazada',
    const M0107ResultadoPage(),
    estado: const OnboardingState(verificacion: EstadoVerificacion.rechazada),
  );
  pantalla('m01_08_biometria', const M0108BiometriaPage());
}
