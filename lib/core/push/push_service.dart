import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../../features/onboarding/presentation/providers.dart';
import '../log/sol_log.dart';
import '../network/network_providers.dart';
import 'instalacion_id.dart';

/// Recepción de push (HU-M04 Fase 6, KAN-259): token de FCM (`getToken`/
/// `onTokenRefresh`, `firebase_messaging` 17.x) y navegación al tocar la
/// notificación. Solo Android (decisión del equipo, sin iOS).
///
/// **`getToken` y `onTokenRefresh` están marcados `@Deprecated` desde la 17.0**
/// (su reemplazo, `register()`/`onRegistered`, entrega el Firebase Installation
/// ID, no el token de FCM) y aquí se siguen usando a propósito: el backend
/// guarda y envía a un token de FCM (`registrarTokenPush(tokenFcm)`; la función
/// `enviar-push` reacciona a `UNREGISTERED`/`INVALID_ARGUMENT`). Pasar al FID
/// cambia el contrato y el envío, no es solo una actualización de la
/// dependencia: se decide aparte, con el backend. Hasta entonces los dos `ignore`
/// de abajo evitan que `flutter analyze` (que falla con cualquier hallazgo)
/// falle por estos avisos.
///
/// **Sin `google-services.json` real** (paso manual pendiente del usuario,
/// nunca se sube al repo — regla del CLAUDE.md del repo): `Firebase.
/// initializeApp()` no tiene con qué inicializar de verdad en este entorno
/// ni hasta que ese archivo exista. [init] lo envuelve en `try/catch` para
/// que ese fallo deje el push apagado en vez de tumbar el arranque de la
/// app; se registra con [SolLog], nunca `print` (regla del repo).
class PushService {
  PushService(this._ref);

  final Ref _ref;
  bool _firebaseListo = false;

  /// Llamar una vez al arrancar la app (`SolventaApp`). Nunca lanza.
  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      _firebaseListo = true;
    } catch (e) {
      SolLog.info(
        'Firebase no inicializó (probablemente falta google-services.json real)',
        codigo: e.runtimeType.toString(),
      );
      return;
    }

    try {
      await FirebaseMessaging.instance.requestPermission();
    } catch (e) {
      SolLog.info(
        'No se pudo pedir el permiso de notificaciones',
        codigo: e.runtimeType.toString(),
      );
    }

    // `onTokenRefresh` puede disparar en cualquier momento de la vida de la
    // app, con o sin sesión activa; `_registrar` se queda calladamente sin
    // hacer nada si no hay sesión.
    // ignore: deprecated_member_use
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (String token) => unawaited(_registrar(token)),
    );

    // Tap con la app en segundo plano (no cerrada).
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage m) => _irA(m.data['ruta'] as Object?),
    );

    // Tap con la app cerrada (terminated): el mensaje que la abrió.
    final inicial = await FirebaseMessaging.instance.getInitialMessage();
    if (inicial != null) _irA(inicial.data['ruta'] as Object?);

    await registrarTokenActual();
  }

  /// Pide el token actual y lo liga a la instalación si hay sesión.
  /// `_RootShell` lo llama también justo después de que la sesión queda
  /// abierta, para no esperar a que `onTokenRefresh` lo dispare solo.
  Future<void> registrarTokenActual() async {
    if (!_firebaseListo) return;
    try {
      // ignore: deprecated_member_use
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _registrar(token);
    } catch (e) {
      SolLog.info(
        'No se pudo obtener el token de FCM',
        codigo: e.runtimeType.toString(),
      );
    }
  }

  Future<void> _registrar(String tokenFcm) async {
    if (!_ref.read(gestorSesionProvider).abierta) return;
    final instalacionId = await _ref.read(instalacionIdStoreProvider).obtener();
    await _ref
        .read(onboardingRepositoryProvider)
        .registrarTokenPush(instalacionId: instalacionId, tokenFcm: tokenFcm);
  }

  /// Navega con el `GoRouter` activo (`router.dart`): pasa por el guard de
  /// las rutas de M04, así que sin sesión pide login primero y continúa
  /// sola hacia aquí.
  void _irA(Object? ruta) {
    if (ruta is! String || ruta.isEmpty) return;
    enrutadorActivo?.go(ruta);
  }
}

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));
