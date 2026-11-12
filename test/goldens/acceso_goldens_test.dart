import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solventa_mobile/core/biometria/biometria_providers.dart';
import 'package:solventa_mobile/core/biometria/biometria_service.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';
import 'package:solventa_mobile/features/acceso/presentation/pages/m02_01_desbloqueo_page.dart';
import 'package:solventa_mobile/features/acceso/presentation/pages/m02_03_acceso_concedido_page.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/onboarding.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';

class _AccesoFijo extends AccesoNotifier {
  _AccesoFijo(this._estado);
  final AccesoState _estado;

  @override
  AccesoState build() => _estado;
}

class _OnboardingFijo extends OnboardingNotifier {
  @override
  OnboardingState build() => const OnboardingState(
    cuentaCreada: true,
    perfil: PerfilUsuario(
      id: 'u-1',
      usuario: 'maria@ejemplo.co',
      nombre: 'María',
      rol: 'CLIENTE',
      estado: 'ACTIVO',
      documentoEnmascarado: '••••••4050',
      creadoEn: '2026-10-28T15:00:00Z',
      idioma: 'ES',
      moneda: 'COP',
    ),
  );
}

/// Goldens de HU-M02 contra Figma (2005:565 M02-01, 2005:472 M02-01a,
/// 2005:499 M02-03) y los avisos sin diseño propio (§3.6 del plan): 360,
/// 390 y 600 dp con texto al 100 %, 360 / 390 dp al 200 % en español y
/// 390 dp en inglés. Sin M02-02 ni M02-02b (decisión D2).
void main() {
  const alto = 844.0;

  Widget app(
    Widget page,
    Locale locale,
    AccesoState estado, {
    TipoBiometria tipo = TipoBiometria.huella,
  }) {
    return ProviderScope(
      overrides: [
        tipoBiometriaProvider.overrideWith((ref) async => tipo),
        accesoProvider.overrideWith(() => _AccesoFijo(estado)),
        onboardingProvider.overrideWith(_OnboardingFijo.new),
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

  void pantalla(
    String id,
    Widget page,
    AccesoState estado, {
    TipoBiometria tipo = TipoBiometria.huella,
  }) {
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
        builder: () => app(page, locale, estado, tipo: tipo),
      );
    }
  }

  const desbloqueo = M0201DesbloqueoPage(autoIniciar: false);
  const bloqueada = AccesoState(fase: FaseAcceso.bloqueada);

  pantalla('m02_01_desbloqueo', desbloqueo, bloqueada);
  // Un ícono y un texto por método: el rostro, el candado (solo bloqueo del teléfono) y el escudo (no se sabe cuál).
  pantalla(
    'm02_01_desbloqueo_rostro',
    desbloqueo,
    bloqueada,
    tipo: TipoBiometria.rostro,
  );
  pantalla(
    'm02_01_desbloqueo_bloqueo',
    desbloqueo,
    bloqueada,
    tipo: TipoBiometria.ninguna,
  );
  pantalla(
    'm02_01_desbloqueo_escudo',
    desbloqueo,
    bloqueada,
    tipo: TipoBiometria.generica,
  );
  pantalla(
    'm02_01a_no_reconocida',
    desbloqueo,
    const AccesoState(fase: FaseAcceso.bloqueada, noReconocida: true),
  );
  pantalla(
    'm02_01_bloqueo_temporal',
    desbloqueo,
    const AccesoState(
      fase: FaseAcceso.bloqueada,
      aviso: AvisoAcceso.bloqueoTemporal,
    ),
  );
  pantalla(
    'm02_01_sin_red',
    desbloqueo,
    const AccesoState(fase: FaseAcceso.bloqueada, aviso: AvisoAcceso.sinRed),
  );
  pantalla(
    'm02_01_sin_bloqueo',
    desbloqueo,
    const AccesoState(
      fase: FaseAcceso.bloqueada,
      aviso: AvisoAcceso.sinBloqueoPantalla,
    ),
  );
  pantalla(
    'm02_03_acceso_concedido',
    const M0203AccesoConcedidoPage(autoAvanzar: false),
    const AccesoState(fase: FaseAcceso.concedida),
  );
}
