import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/solventa_ui.dart';
import '../features/assistance/presentation/assistance_placeholder_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/onboarding/presentation/onboarding_routes.dart';
import '../features/onboarding/presentation/pages/m01_01_bienvenida_page.dart';
import '../features/onboarding/presentation/pages/m01_02_autorizacion_page.dart';
import '../features/onboarding/presentation/pages/m01_03_documento_frente_page.dart';
import '../features/onboarding/presentation/pages/m01_04_documento_reverso_page.dart';
import '../features/onboarding/presentation/pages/m01_05_prueba_vida_page.dart';
import '../features/onboarding/presentation/pages/m01_06_verificando_page.dart';
import '../features/onboarding/presentation/pages/m01_07_resultado_page.dart';
import '../features/onboarding/presentation/pages/m01_08_biometria_page.dart';

const bool _openGallery = bool.fromEnvironment('SOL_GALLERY');

/// Rutas de la app. El nombre de cada ruta es el id del plano de Figma.
GoRouter crearRouter() => GoRouter(
  initialLocation: kDebugMode && _openGallery ? SolGalleryPage.routeName : '/',
  routes: [
    GoRoute(path: '/', name: 'g-03', builder: (_, _) => const _RootShell()),
    GoRoute(
      path: OnboardingRoutes.bienvenida,
      name: 'm01-01',
      builder: (_, _) => const M0101BienvenidaPage(),
    ),
    GoRoute(
      path: OnboardingRoutes.autorizacion,
      name: 'm01-02',
      builder: (_, _) => const M0102AutorizacionPage(),
    ),
    GoRoute(
      path: OnboardingRoutes.frente,
      name: 'm01-03',
      builder: (_, _) => const M0103DocumentoFrentePage(),
    ),
    GoRoute(
      path: OnboardingRoutes.reverso,
      name: 'm01-04',
      builder: (_, _) => const M0104DocumentoReversoPage(),
    ),
    GoRoute(
      path: OnboardingRoutes.pruebaVida,
      name: 'm01-05',
      builder: (_, _) => const M0105PruebaVidaPage(),
    ),
    GoRoute(
      path: OnboardingRoutes.verificando,
      name: 'm01-06',
      builder: (_, _) => const M0106VerificandoPage(),
    ),
    GoRoute(
      path: OnboardingRoutes.resultado,
      name: 'm01-07',
      builder: (_, _) => const M0107ResultadoPage(),
    ),
    GoRoute(
      path: OnboardingRoutes.biometria,
      name: 'm01-08',
      builder: (_, _) => const M0108BiometriaPage(),
    ),
    if (kDebugMode)
      GoRoute(
        path: SolGalleryPage.routeName,
        builder: (_, _) => const SolGalleryPage(),
      ),
  ],
);

class _RootShell extends StatelessWidget {
  const _RootShell();

  @override
  Widget build(BuildContext context) {
    return SolAppShell(
      home: HomePage(
        userName: 'María',
        onCompleteRegistration: () => context.push(OnboardingRoutes.bienvenida),
        onRequestAssistance: () {},
      ),
      assistance: const AssistancePlaceholderPage(),
      onWordmarkLongPress: kDebugMode
          ? () => context.push(SolGalleryPage.routeName)
          : null,
      onLogout: () => SolConfirmDialog.show(
        context,
        title: '¿Quieres cerrar sesión?',
        message: 'Tendrás que ingresar de nuevo para usar Solventa.',
        confirmLabel: 'Sí, cerrar sesión',
        cancelLabel: 'No, seguir aquí',
      ),
    );
  }
}
