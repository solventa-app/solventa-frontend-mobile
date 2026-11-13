import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_datos;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/log/sol_log.dart';

/// Notificación local de llegada de la asistencia (HU-M06, 4.5).
///
/// Se programa en el teléfono al confirmarse la asistencia para la hora de
/// `llegadaEstimada`: no necesita internet para mostrarse y se reprograma sola
/// tras reiniciar el teléfono (receptor de arranque del plugin). Va en su
/// propio canal «Asistencias», separado del push de FCM de HU-M04 (ajuste A2).
/// El texto ya llega traducido; el payload es solo el id de la asistencia.
abstract interface class NotificacionesAsistencia {
  /// Prepara el plugin. [alTocar] recibe el id de la asistencia tocada con la
  /// app abierta o en segundo plano.
  Future<void> iniciar({required void Function(String id) alTocar});

  /// Si la app se abrió tocando una notificación, el id de la asistencia.
  Future<String?> idDeArranque();

  /// Android 13+: el diálogo del sistema. `false` si lo niega (todo sigue
  /// funcionando, sin notificación).
  Future<bool> pedirPermiso();

  /// Programa (o reprograma: mismo id) la notificación para [llegada].
  Future<void> programar({
    required String id,
    required DateTime llegada,
    required String titulo,
    required String cuerpo,
  });

  Future<void> cancelar(String id);
}

/// Id de la notificación derivado del id de la asistencia (FNV-1a de 31 bits):
/// estable entre ejecuciones, así reprogramar reemplaza la anterior.
int idNotificacion(String asistenciaId) {
  var h = 0x811c9dc5;
  for (final c in asistenciaId.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0xffffffff;
  }
  return h & 0x7fffffff;
}

final class LocalNotificacionesAsistencia implements NotificacionesAsistencia {
  LocalNotificacionesAsistencia([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _listo = false;

  static const _canal = AndroidNotificationDetails(
    'asistencias',
    'Asistencias',
    channelDescription: 'Aviso cuando llega el prestador de una asistencia',
    importance: Importance.high,
    priority: Priority.high,
  );

  @override
  Future<void> iniciar({required void Function(String id) alTocar}) async {
    try {
      tz_datos.initializeTimeZones();
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (r) {
          final id = r.payload;
          if (id != null && id.isNotEmpty) alTocar(id);
        },
      );
      _listo = true;
    } catch (e) {
      // Sin plugin (pruebas) o sin canal: la app sigue sin notificaciones.
      SolLog.warning(
        'Notificaciones de asistencia no disponibles',
        codigo: e.runtimeType.toString(),
      );
    }
  }

  @override
  Future<String?> idDeArranque() async {
    if (!_listo) return null;
    try {
      final d = await _plugin.getNotificationAppLaunchDetails();
      return d?.didNotificationLaunchApp ?? false
          ? d?.notificationResponse?.payload
          : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> pedirPermiso() async {
    if (!_listo) return false;
    try {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> programar({
    required String id,
    required DateTime llegada,
    required String titulo,
    required String cuerpo,
  }) async {
    if (!_listo || !llegada.isAfter(DateTime.now())) return;
    try {
      await _plugin.zonedSchedule(
        id: idNotificacion(id),
        title: titulo,
        body: cuerpo,
        // Un instante absoluto: no depende de la zona horaria del teléfono.
        scheduledDate: tz.TZDateTime.from(llegada.toUtc(), tz.UTC),
        notificationDetails: const NotificationDetails(android: _canal),
        // Sin permiso de alarmas exactas: puede llegar un par de minutos
        // tarde, aceptable para un aviso de llegada.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: id,
      );
    } catch (e) {
      SolLog.warning(
        'No se programó la notificación de llegada',
        codigo: e.runtimeType.toString(),
      );
    }
  }

  @override
  Future<void> cancelar(String id) async {
    if (!_listo) return;
    try {
      await _plugin.cancel(id: idNotificacion(id));
    } catch (_) {
      // Si no estaba programada no hay nada que cancelar.
    }
  }
}

/// Para pruebas, `mock` sin plugin y Test Lab: registra lo que se pidió.
final class FakeNotificacionesAsistencia implements NotificacionesAsistencia {
  final Map<String, (DateTime, String, String)> programadas = {};
  final List<String> canceladas = [];
  bool permiso = true;
  int permisosPedidos = 0;
  void Function(String id)? alTocar;
  String? arranque;

  /// Simula que el usuario toca la notificación de [id].
  void tocar(String id) => alTocar?.call(id);

  @override
  Future<void> iniciar({required void Function(String id) alTocar}) async =>
      this.alTocar = alTocar;

  @override
  Future<String?> idDeArranque() async => arranque;

  @override
  Future<bool> pedirPermiso() async {
    permisosPedidos++;
    return permiso;
  }

  @override
  Future<void> programar({
    required String id,
    required DateTime llegada,
    required String titulo,
    required String cuerpo,
  }) async => programadas[id] = (llegada, titulo, cuerpo);

  @override
  Future<void> cancelar(String id) async {
    programadas.remove(id);
    canceladas.add(id);
  }
}
