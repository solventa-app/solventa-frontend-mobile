import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../core/design_system/solventa_ui.dart';
import '../core/l10n/l10n.dart';
import '../core/network/network_providers.dart';
import '../core/push/pending_destination.dart';
import '../core/push/push_service.dart';
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
import '../features/onboarding/presentation/pages/m02_04_recuperar_clave_page.dart';
import '../features/parametric/presentation/pages/m04_02_celebracion_page.dart';
import '../features/parametric/presentation/pages/m04_03_detalle_indemnizacion_page.dart';
import '../features/parametric/presentation/pages/m04_04_cobertura_page.dart';
import '../features/parametric/presentation/parametric_routes.dart';
import '../features/profile/presentation/profile_page.dart';

const bool _openGallery = bool.fromEnvironment('SOL_GALLERY');

/// Última ruta activa observada por el navegador, usada por `beforeCaptureScreenshot`
/// para no tomar capturas en pantallas de documento o cámara (`M01-03`..`M01-05`)
/// ni en las de acceso a la cuenta (`M02-01`, `M02-03`).
String? rutaActualObservada;

/// El `GoRouter` de `SolventaApp` mientras vive, para navegar desde fuera del
/// árbol de widgets (HU-M04 Fase 6, KAN-259: el push abre una ruta sin pasar
/// por un `BuildContext`). `null` sin app montada (p. ej. en pruebas).
GoRouter? enrutadorActivo;

/// `true` si [ubicacion] es una de las rutas de HU-M04 que el push puede
/// abrir directamente ([ParametricRoutes.celebracion] y `.detalle`).
bool _esRutaM04(String ubicacion) =>
    ubicacion.startsWith('${ParametricRoutes.celebracion}/') ||
    ubicacion.startsWith('${ParametricRoutes.detalle}/') ||
    ubicacion == ParametricRoutes.cobertura;

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

/// Oculta la pista del Home para activar la huella o el rostro (se cierra con
/// la X o al quedar activada). Dura lo que la sesión de la app.
final pistaBiometriaCerradaProvider =
    NotifierProvider<PistaBiometriaCerrada, bool>(PistaBiometriaCerrada.new);

class PistaBiometriaCerrada extends Notifier<bool> {
  @override
  bool build() => false;

  void cerrar() => state = true;
}

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
///
/// [sesionAbierta] (HU-M04 Fase 6, KAN-259) deja pasar las rutas de M04 solo
/// con sesión abierta; sin ella, [guardarPendiente] guarda a dónde se quería
/// ir y el router vuelve a `/` («el push como puerta de entrada»): el login
/// normal sigue su curso y `_RootShell` reanuda la navegación con
/// [pendingDestinationProvider] en cuanto la sesión abre.
GoRouter crearRouter({
  FaseAcceso Function()? fase,
  Listenable? refrescar,
  bool Function()? sesionAbierta,
  void Function(String ruta)? guardarPendiente,
}) => GoRouter(
  initialLocation: kDebugMode && _openGallery ? SolGalleryPage.routeName : '/',
  observers: [_RutaActualObserver(), SentryNavigatorObserver()],
  refreshListenable: refrescar,
  redirect: (_, state) {
    final ubicacion = state.matchedLocation;
    if (ubicacion == SolGalleryPage.routeName) return null;
    if (sesionAbierta != null && _esRutaM04(ubicacion) && !sesionAbierta()) {
      guardarPendiente?.call(ubicacion);
      return '/';
    }
    return fase == null ? null : redirigirAcceso(fase(), ubicacion);
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
      path: OnboardingRoutes.recuperarClave,
      name: 'm02-04',
      builder: (_, _) => const M0204RecuperarClavePage(),
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
      path: '${ParametricRoutes.celebracion}/:id',
      name: 'm04-02',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return M0402CelebracionPage(
          id: id,
          // Llega también por push con la app recién abierta, sin pila
          // previa: `/` vuelve al inicio en vez de intentar un pop vacío.
          onBack: () => context.go('/'),
          onVerDetalle: () => context.push(ParametricRoutes.detalleCon(id)),
        );
      },
    ),
    GoRoute(
      path: '${ParametricRoutes.detalle}/:id',
      name: 'm04-03',
      builder: (context, state) => M0403DetalleIndemnizacionPage(
        id: state.pathParameters['id']!,
        // Puede ser el destino pendiente de un push (sin pila previa).
        onCerrar: () => context.canPop() ? context.pop() : context.go('/'),
      ),
    ),
    GoRoute(
      path: ParametricRoutes.cobertura,
      name: 'm04-04',
      builder: (context, state) => M0404CoberturaPage(
        onTapMovimiento: (id) => context.push(ParametricRoutes.detalleCon(id)),
      ),
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
        onIrAlMapa: () => _volverAPestana(context, SolAppShell.assistanceIndex),
        onIrAlInicio: () => _volverAPestana(context, SolAppShell.homeIndex),
      ),
    ),
    GoRoute(
      path: AsistenciaRoutes.cancelada,
      name: 'm06-06',
      builder: (context, _) => M0606CanceladaPage(
        onIrAlMapa: () => _volverAPestana(context, SolAppShell.assistanceIndex),
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

    // HU-M04 Fase 6 (KAN-259): la sesión recién se abrió (login, no solo el
    // desbloqueo biométrico): registra el push y, si el push llevó aquí sin
    // sesión, continúa hacia esa ruta pendiente.
    ref.listen(onboardingProvider.select((s) => s.cuentaCreada), (
      antes,
      ahora,
    ) {
      if (ahora && antes != true) {
        unawaited(ref.read(pushServiceProvider).registrarTokenActual());
        final pendiente = ref.read(pendingDestinationProvider);
        if (pendiente != null) {
          ref.read(pendingDestinationProvider.notifier).limpiar();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go(pendiente);
          });
        }
      }
    });

    // HU-M02 (F6): mientras se mira si hay sesión guardada, solo el fondo;
    // así no se ve G-03 un instante antes de M02-01.
    if (ref.watch(accesoProvider.select((s) => s.fase)) ==
        FaseAcceso.comprobando) {
      return const Scaffold(body: SizedBox.expand());
    }

    // Sin sesión, la entrada abre siempre en «Inicia sesión» y debajo ofrece
    // «Crear cuenta» (QA 2026-11-10).
    if (!estado.cuentaCreada) {
      return const M0105bCuentaPage(modoInicialLogin: true);
    }

    final l10n = context.l10n;
    final notifier = ref.read(onboardingProvider.notifier);

    // Tras abrir una sesión guardada (huella) todavía no se sabe si la cuenta
    // está verificada ni cómo se llama: se espera en vez de pintarla como
    // «pendiente» y sin nombre; si no llegó tras los reintentos, se ofrece
    // «Reintentar» (HU-M02).
    if (estado.verificacion == null && estado.perfil == null) {
      if (estado.cargandoPerfil) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final fallaPerfil = estado.fallaPerfil;
      if (fallaPerfil != null) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(SolSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SolInlineNote(text: l10n.falla(fallaPerfil), center: true),
                  SolButton.text(
                    label: l10n.m05Reintentar,
                    onPressed: () => unawaited(notifier.reintentarPerfil()),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    final verificado = estado.verificacion == EstadoVerificacion.verificada;
    final cerrada = ref.watch(pistaBiometriaCerradaProvider);
    final pistaCerrada = ref.read(pistaBiometriaCerradaProvider.notifier);
    final biometriaActiva = ref.read(gestorSesionProvider).refreshPersistido;
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
        // M01-08 es opcional: mientras no esté activa, el Home la sugiere.
        onActivarBiometria: verificado && !cerrada && !biometriaActiva
            ? () async {
                await context.push(OnboardingRoutes.biometria);
                if (!context.mounted) return;
                if (ref.read(gestorSesionProvider).refreshPersistido) {
                  pistaCerrada.cerrar();
                }
              }
            : null,
        onCerrarPistaBiometria: pistaCerrada.cerrar,
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
