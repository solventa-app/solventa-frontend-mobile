import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../core/design_system/solventa_ui.dart';
import '../core/l10n/l10n.dart';
import '../features/acceso/presentation/acceso_notifier.dart';
import '../features/acceso/presentation/acceso_routes.dart';
import '../features/acceso/presentation/pages/m02_01_desbloqueo_page.dart';
import '../features/acceso/presentation/pages/m02_03_acceso_concedido_page.dart';
import '../features/assistance/presentation/asistencia_routes.dart';
import '../features/assistance/presentation/pages/m06_01_prestadores_page.dart';
import '../features/assistance/presentation/pages/m06_02_solicitud_page.dart';
import '../features/assistance/presentation/pages/m06_03_enviando_page.dart';
import '../features/assistance/presentation/pages/m06_04_resultado_page.dart';
import '../features/assistance/presentation/pages/m06_06_cancelada_page.dart';
import '../features/assistance/presentation/providers.dart';
import '../features/claims/presentation/pages/m05_01_poliza_page.dart';
import '../features/claims/presentation/pages/m05_02_fotos_page.dart';
import '../features/claims/presentation/pages/m05_03_relato_page.dart';
import '../features/claims/presentation/pages/m05_04_enviando_page.dart';
import '../features/claims/presentation/pages/m05_05_resultado_page.dart';
import '../features/claims/presentation/pages/m05_06_mis_siniestros_page.dart';
import '../features/claims/presentation/providers.dart';
import '../features/claims/presentation/reporte_routes.dart';
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
/// para no tomar capturas en pantallas de documento o cámara (`M01-03`..`M01-05`)
/// ni en las de acceso a la cuenta (`M02-01`, `M02-03`).
String? rutaActualObservada;

const Set<String> _rutasSinCaptura = {
  'm01-03',
  'm01-04',
  'm01-05',
  'm02-01',
  'm02-03',
  '/onboarding/frente',
  '/onboarding/reverso',
  '/onboarding/prueba-vida',
  OnboardingRoutes.frente,
  OnboardingRoutes.reverso,
  OnboardingRoutes.pruebaVida,
  AccesoRoutes.desbloqueo,
  AccesoRoutes.concedido,
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

/// Pestaña activa del inicio (G-03): los recorridos de HU-M06 vuelven a
/// Asistencia o a Inicio al terminar.
final pestanaInicioProvider = Provider<ValueNotifier<int>>((ref) {
  final pestana = ValueNotifier<int>(SolAppShell.homeIndex);
  ref.onDispose(pestana.dispose);
  return pestana;
});

/// Cierra el recorrido de HU-M06 y deja el inicio en la pestaña [indice].
void _volverAPestana(BuildContext context, int indice) {
  ProviderScope.containerOf(context).read(pestanaInicioProvider).value = indice;
  context.go('/');
}

/// Rutas de la app. El nombre de cada ruta es el id del plano de Figma.
///
/// Con [fase] (HU-M02) el router redirige según la fase de acceso:
/// arrancando solo `/`, con sesión guardada solo M02-01, recién desbloqueada
/// solo M02-03 ([redirigirAcceso]). [refrescar] avisa cuando cambia.
GoRouter crearRouter({FaseAcceso Function()? fase, Listenable? refrescar}) =>
    GoRouter(
      initialLocation: kDebugMode && _openGallery
          ? SolGalleryPage.routeName
          : '/',
      observers: [_RutaActualObserver(), SentryNavigatorObserver()],
      refreshListenable: refrescar,
      redirect: fase == null
          ? null
          : (_, state) {
              final ubicacion = state.matchedLocation;
              if (ubicacion == SolGalleryPage.routeName) return null;
              return redirigirAcceso(fase(), ubicacion);
            },
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
          path: AccesoRoutes.desbloqueo,
          name: 'm02-01',
          builder: (_, _) => const M0201DesbloqueoPage(),
        ),
        GoRoute(
          path: AccesoRoutes.concedido,
          name: 'm02-03',
          builder: (_, _) => const M0203AccesoConcedidoPage(),
        ),
        GoRoute(
          path: OnboardingRoutes.perfil,
          name: 'g-05',
          builder: (_, _) => const ProfilePage(),
        ),
        GoRoute(
          path: ReporteRoutes.poliza,
          name: 'm05-01',
          builder: (_, _) => const M0501PolizaPage(),
        ),
        GoRoute(
          path: ReporteRoutes.fotos,
          name: 'm05-02',
          builder: (_, _) => const M0502FotosPage(),
        ),
        GoRoute(
          path: ReporteRoutes.relato,
          name: 'm05-03',
          builder: (_, _) => const M0503RelatoPage(),
        ),
        GoRoute(
          path: ReporteRoutes.enviando,
          name: 'm05-04',
          builder: (_, _) => const M0504EnviandoPage(),
        ),
        GoRoute(
          path: ReporteRoutes.resultado,
          name: 'm05-05',
          builder: (_, _) => const M0505ResultadoPage(),
        ),
        GoRoute(
          path: ReporteRoutes.misSiniestros,
          name: 'm05-06',
          builder: (_, _) => const M0506MisSiniestrosPage(),
        ),
        GoRoute(
          path: AsistenciaRoutes.solicitud,
          name: 'm06-02',
          builder: (_, _) => const M0602SolicitudPage(),
        ),
        GoRoute(
          path: AsistenciaRoutes.enviando,
          name: 'm06-03',
          builder: (_, _) => const M0603EnviandoPage(),
        ),
        GoRoute(
          path: AsistenciaRoutes.resultado,
          name: 'm06-04',
          builder: (context, _) => M0604ResultadoPage(
            onIrAlMapa: () =>
                _volverAPestana(context, SolAppShell.assistanceIndex),
            onIrAlInicio: () => _volverAPestana(context, SolAppShell.homeIndex),
          ),
        ),
        GoRoute(
          path: AsistenciaRoutes.cancelada,
          name: 'm06-06',
          builder: (context, _) => M0606CanceladaPage(
            onIrAlMapa: () =>
                _volverAPestana(context, SolAppShell.assistanceIndex),
            onIrAlInicio: () => _volverAPestana(context, SolAppShell.homeIndex),
          ),
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

    // HU-M02 (F6): mientras se mira si hay sesión guardada, solo el fondo;
    // así no se ve G-03 un instante antes de M02-01.
    if (ref.watch(accesoProvider.select((s) => s.fase)) ==
        FaseAcceso.comprobando) {
      return const Scaffold(body: SizedBox.expand());
    }

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
            if (await notifier.reintentarCaptura()) {
              if (context.mounted) await context.push(OnboardingRoutes.frente);
              return;
            }
            // El recorrido en memoria no se pudo reintentar (la app se
            // reabrió o el token de 30 min venció): se empieza uno nuevo
            // desde la bienvenida en vez de quedarse con el error.
            notifier.limpiarFalla();
          }
          if (context.mounted) {
            await context.push(OnboardingRoutes.bienvenida);
          }
        },
        onCheckStatus: () => context.push(OnboardingRoutes.verificando),
        onOpenProfile: verificado
            ? () => context.push(OnboardingRoutes.perfil)
            : null,
        onRequestAssistance: () =>
            ref.read(pestanaInicioProvider).value = SolAppShell.assistanceIndex,
        // HU-M05: solo con la identidad verificada (el BFF lo exige igual).
        onReportClaim: verificado
            ? () {
                ref.read(reporteProvider.notifier).reiniciar();
                context.push(ReporteRoutes.poliza);
              }
            : null,
        onMyClaims: verificado
            ? () => context.push(ReporteRoutes.misSiniestros)
            : null,
      ),
      // «Solicitar» abre M06-02 con el prestador elegido (KAN-265).
      assistance: M0601PrestadoresPage(
        onSolicitar: (cercano, origen) {
          ref.read(solicitudProvider.notifier).iniciar(cercano, origen);
          context.push(AsistenciaRoutes.solicitud);
        },
        onSolicitarConDireccion: (prestador) {
          ref.read(solicitudProvider.notifier).iniciarConDireccion(prestador);
          context.push(AsistenciaRoutes.solicitud);
        },
      ),
      pestana: ref.watch(pestanaInicioProvider),
      onWordmarkLongPress: kDebugMode
          ? () => context.push(SolGalleryPage.routeName)
          : null,
      onLogout: confirmarCierreSesion,
    );
  }
}
