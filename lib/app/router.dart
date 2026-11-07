import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../core/design_system/solventa_ui.dart';
import '../core/l10n/l10n.dart';
import '../features/assistance/presentation/pages/m06_01_prestadores_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/onboarding/domain/entities/verificacion_identidad.dart';
import '../features/onboarding/presentation/onboarding_notifier.dart';
import '../features/onboarding/presentation/onboarding_routes.dart';
import '../features/onboarding/presentation/pages/m01_01_bienvenida_page.dart';
import '../features/onboarding/presentation/pages/m01_02_autorizacion_page.dart';
import '../features/onboarding/presentation/pages/m01_03_documento_frente_page.dart';
import '../features/onboarding/presentation/pages/m01_04_documento_reverso_page.dart';
import '../features/onboarding/presentation/pages/m01_05_prueba_vida_page.dart';
import '../features/onboarding/presentation/pages/m01_05b_cuenta_page.dart';
import '../features/onboarding/presentation/pages/m01_05c_codigo_page.dart';
import '../features/onboarding/presentation/pages/m01_06_verificando_page.dart';
import '../features/onboarding/presentation/pages/m01_07_resultado_page.dart';
import '../features/onboarding/presentation/pages/m01_08_biometria_page.dart';
import '../features/profile/presentation/profile_page.dart';

const bool _openGallery = bool.fromEnvironment('SOL_GALLERY');

/// Última ruta activa observada por el navegador, usada por `beforeCaptureScreenshot`
/// para no tomar capturas en pantallas de documento o cámara (`M01-03`..`M01-05`).
String? rutaActualObservada;

const Set<String> _rutasSinCaptura = {
  'm01-03',
  'm01-04',
  'm01-05',
  '/onboarding/frente',
  '/onboarding/reverso',
  '/onboarding/prueba-vida',
  OnboardingRoutes.frente,
  OnboardingRoutes.reverso,
  OnboardingRoutes.pruebaVida,
};

/// Indica si [ruta] corresponde a una pantalla de captura biométrica/documento
/// donde nunca se debe adjuntar screenshot a Sentry.
bool esRutaSinCaptura(String? ruta) {
  if (ruta == null || ruta.isEmpty) return false;
  return _rutasSinCaptura.contains(ruta) ||
      _rutasSinCaptura.any((r) => ruta.contains(r));
}

class _RutaActualObserver extends NavigatorObserver {
  void _actualizar(Route<dynamic>? route) {
    rutaActualObservada = route?.settings.name;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _actualizar(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _actualizar(previousRoute);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _actualizar(newRoute);
}

/// Rutas de la app. El nombre de cada ruta es el id del plano de Figma.
GoRouter crearRouter() => GoRouter(
  initialLocation: kDebugMode && _openGallery ? SolGalleryPage.routeName : '/',
  observers: [_RutaActualObserver(), SentryNavigatorObserver()],
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
      path: OnboardingRoutes.cuenta,
      name: 'm01-05b',
      builder: (_, _) => const M0105bCuentaPage(),
    ),
    GoRoute(
      path: OnboardingRoutes.codigoCorreo,
      name: 'm01-05c',
      builder: (_, _) => const M0105cCodigoPage(),
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
    GoRoute(
      path: OnboardingRoutes.perfil,
      name: 'g-05',
      builder: (_, _) => const ProfilePage(),
    ),
    if (kDebugMode)
      GoRoute(
        path: SolGalleryPage.routeName,
        builder: (_, _) => const SolGalleryPage(),
      ),
  ],
);

class _RootShell extends ConsumerWidget {
  const _RootShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(onboardingProvider);

    // Sin sesión o cuenta creada, la pantalla de entrada es Crea tu cuenta / Inicia sesión.
    if (!estado.cuentaCreada) {
      return M0105bCuentaPage(modoInicialLogin: estado.sesionCerrada);
    }

    final l10n = context.l10n;
    final notifier = ref.read(onboardingProvider.notifier);

    final verificado = estado.verificacion == EstadoVerificacion.verificada;
    final nombre = verificado
        ? (estado.perfil?.nombre?.trim().isNotEmpty ?? false)
              ? estado.perfil!.nombre!
              : ''
        : '';

    Future<void> confirmarCierreSesion() async {
      final confirmar = await SolConfirmDialog.show(
        context,
        title: l10n.cerrarSesionTitulo,
        message: l10n.cerrarSesionMensaje,
        confirmLabel: l10n.cerrarSesionConfirmar,
        cancelLabel: l10n.cerrarSesionCancelar,
      );
      if (confirmar && context.mounted) {
        await notifier.cerrarSesion();
        if (context.mounted) {
          context.go('/');
        }
      }
    }

    return SolAppShell(
      home: HomePage(
        userName: nombre,
        verificacion: estado.verificacion,
        onCompleteRegistration: () async {
          if (estado.verificacion == EstadoVerificacion.rechazada &&
              estado.intentosRestantes > 0) {
            if (await notifier.reintentarCaptura() && context.mounted) {
              await context.push(OnboardingRoutes.frente);
            }
            return;
          }
          await context.push(OnboardingRoutes.bienvenida);
        },
        onCheckStatus: () => context.push(OnboardingRoutes.verificando),
        onOpenProfile: verificado
            ? () => context.push(OnboardingRoutes.perfil)
            : null,
        onRequestAssistance: () {},
      ),
      // «Solicitar» abrirá M06-02 (formulario) en KAN-265.
      assistance: M0601PrestadoresPage(onSolicitar: (_) {}),
      onWordmarkLongPress: kDebugMode
          ? () => context.push(SolGalleryPage.routeName)
          : null,
      onLogout: confirmarCierreSesion,
    );
  }
}
