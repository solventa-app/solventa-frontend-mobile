import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/solventa_ui.dart';
import '../core/l10n/l10n.dart';
import '../core/network/network_providers.dart';
import '../core/push/pending_destination.dart';
import '../core/push/push_service.dart';
import '../core/sesion/gestor_sesion.dart';
import '../features/acceso/presentation/acceso_notifier.dart';
import '../features/assistance/presentation/asistencia_routes.dart';
import '../features/assistance/presentation/providers.dart';
import '../features/onboarding/presentation/preferencias_de_la_cuenta.dart';
import '../features/profile/presentation/sol_preferencias_sheet.dart';
import 'router.dart';

/// Raíz de la app: tema M3 de Solventa, idioma (`es-CO` / `en`), moneda
/// (`COP`, `MXN`, `BRL`, `CLP`, `PEN`, `USD`, `EUR`) y rutas.
class SolventaApp extends ConsumerStatefulWidget {
  const SolventaApp({super.key});

  @override
  ConsumerState<SolventaApp> createState() => _SolventaAppState();
}

class _SolventaAppState extends ConsumerState<SolventaApp> {
  /// Avisa al router cuando cambia la fase de acceso (HU-M02).
  final _cambioFase = _Aviso();
  late final GoRouter _router = crearRouter(
    fase: () => ref.read(accesoProvider).fase,
    refrescar: _cambioFase,
    sesionAbierta: () => ref.read(gestorSesionProvider).abierta,
    guardarPendiente: (ruta) =>
        ref.read(pendingDestinationProvider.notifier).fijar(ruta),
  );
  late final AppLifecycleListener _ciclo;
  StreamSubscription<EventoSesion>? _eventos;

  @override
  void initState() {
    super.initState();
    enrutadorActivo = _router;
    ref.listenManual(
      accesoProvider.select((s) => s.fase),
      (_, _) => _cambioFase.avisar(),
    );
    // Sesión vencida con pantallas apiladas (perfil, verificación…): `go`
    // las descarta y deja solo `/`, que muestra «Inicia sesión».
    _eventos = ref.read(gestorSesionProvider).eventos.listen((evento) {
      if (evento is SesionVencidaEvento) _router.go('/');
    });
    // Bloqueo tras 15 min en segundo plano (HU-M02).
    _ciclo = AppLifecycleListener(
      onHide: () => ref.read(accesoProvider.notifier).alPasarASegundoPlano(),
      onShow: () => ref.read(accesoProvider.notifier).alVolverAPrimerPlano(),
    );
    // HU-M04 Fase 6 (KAN-259): nunca lanza, aun sin `google-services.json`.
    unawaited(ref.read(pushServiceProvider).init());
    // HU-M06 (4.5): tocar la notificación de llegada abre el detalle; sin
    // sesión, el guard la guarda como destino pendiente hasta el login.
    unawaited(_iniciarNotificacionesAsistencia());
  }

  Future<void> _iniciarNotificacionesAsistencia() async {
    final avisos = ref.read(notificacionesAsistenciaProvider);
    await avisos.iniciar(
      alTocar: (id) => _router.go(AsistenciaRoutes.detalleCon(id)),
    );
    final arranque = await avisos.idDeArranque();
    if (arranque != null && mounted) {
      _router.go(AsistenciaRoutes.detalleCon(arranque));
    }
  }

  @override
  void dispose() {
    if (identical(enrutadorActivo, _router)) enrutadorActivo = null;
    _ciclo.dispose();
    unawaited(_eventos?.cancel());
    _router.dispose();
    _cambioFase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final moneda = ref.watch(monedaProvider);
    // Lo guardado en la cuenta manda al abrir la sesión (HU-M02): idioma y moneda del perfil pasan a la app.
    ref.watch(preferenciasDeLaCuentaProvider);
    final codigoIdioma = locale.languageCode.toUpperCase();
    final etiquetaChip = '$codigoIdioma · $moneda';

    return MaterialApp.router(
      title: 'Solventa',
      debugShowCheckedModeBanner: false,
      theme: SolTheme.light(),
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...SolLocalizations.delegates,
      ],
      routerConfig: _router,
      builder: (context, child) {
        final l10n = context.l10n;
        return SolLocaleScope(
          label: etiquetaChip,
          semanticLabel: l10n.localeChipSemantica,
          onTap: () {
            ref.read(localeProvider.notifier).alternar();
            final navContext =
                _router.routerDelegate.navigatorKey.currentContext;
            if (navContext != null) {
              SolPreferenciasSheet.show(navContext);
            }
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class _Aviso extends ChangeNotifier {
  void avisar() => notifyListeners();
}
