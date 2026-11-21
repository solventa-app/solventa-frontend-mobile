import 'dart:ui' show Color;

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
/// El texto y el nombre del canal ya llegan traducidos al idioma de la app; al
/// cambiar de idioma se reprograman con el texto nuevo y Android renombra el
/// canal (mismo id). El payload es solo el id de la asistencia.
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
  /// [canal] es el nombre y la descripción del canal en Ajustes de Android.
  ///
  /// Con [enCamino] además muestra ya una notificación fija («en camino»):
  /// no se puede deslizar, tiene una barra animada y una cuenta regresiva
  /// hasta [llegada] que lleva Android (sigue con la app cerrada). Se quita
  /// sola al llegar la hora o con [cancelar].
  Future<void> programar({
    required String id,
    required DateTime llegada,
    required String titulo,
    required String cuerpo,
    required CanalAsistencias canal,
    EnCaminoAsistencia? enCamino,
  });

  Future<void> cancelar(String id);
}

/// Nombre y descripción del canal «Asistencias», en el idioma de la app.
typedef CanalAsistencias = ({String nombre, String descripcion});

/// Textos de la notificación fija «en camino» y de su canal silencioso.
typedef EnCaminoAsistencia = ({
  String titulo,
  String cuerpo,
  CanalAsistencias canal,
});

/// Canal propio, de importancia baja: la notificación fija no suena ni vibra.
const idCanalEnCamino = 'asistencias_en_camino';

/// Id de la notificación fija: distinto del de llegada de la misma asistencia.
int idNotificacionEnCamino(String asistenciaId) =>
    idNotificacion(asistenciaId) ^ 0x40000000;

/// Id del canal: fijo, así el cambio de idioma lo renombra en vez de crear otro.
const idCanalAsistencias = 'asistencias';

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

  @override
  Future<void> iniciar({required void Function(String id) alTocar}) async {
    try {
      tz_datos.initializeTimeZones();
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@drawable/ic_stat_solventa'),
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
    required CanalAsistencias canal,
    EnCaminoAsistencia? enCamino,
  }) async {
    if (!_listo || !llegada.isAfter(DateTime.now())) return;
    if (enCamino != null) await _mostrarEnCamino(id, llegada, enCamino);
    try {
      await _plugin.zonedSchedule(
        id: idNotificacion(id),
        title: titulo,
        body: cuerpo,
        // Un instante absoluto: no depende de la zona horaria del teléfono.
        scheduledDate: tz.TZDateTime.from(llegada.toUtc(), tz.UTC),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            idCanalAsistencias,
            canal.nombre,
            channelDescription: canal.descripcion,
            importance: Importance.high,
            priority: Priority.high,
            // Silueta blanca de la «S» sobre el azul de marca (res/drawable-*/ic_stat_solventa).
            icon: 'ic_stat_solventa',
            color: const Color(0xFF37599E),
          ),
        ),
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

  Future<void> _mostrarEnCamino(
    String id,
    DateTime llegada,
    EnCaminoAsistencia enCamino,
  ) async {
    try {
      await _plugin.show(
        id: idNotificacionEnCamino(id),
        title: enCamino.titulo,
        body: enCamino.cuerpo,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            idCanalEnCamino,
            enCamino.canal.nombre,
            channelDescription: enCamino.canal.descripcion,
            importance: Importance.low,
            priority: Priority.low,
            icon: 'ic_stat_solventa',
            color: const Color(0xFF37599E),
            category: AndroidNotificationCategory.progress,
            // Fija: no se desliza y se reemplaza sin volver a sonar.
            ongoing: true,
            autoCancel: false,
            onlyAlertOnce: true,
            // Barra animada sin tener que actualizarla desde la app.
            showProgress: true,
            indeterminate: true,
            // Cuenta regresiva hasta la llegada: la lleva el sistema.
            when: llegada.millisecondsSinceEpoch,
            usesChronometer: true,
            chronometerCountDown: true,
            // Se quita sola a la hora de llegada, cuando sale la de «llegó».
            timeoutAfter: llegada.difference(DateTime.now()).inMilliseconds,
          ),
        ),
        payload: id,
      );
    } catch (e) {
      SolLog.warning(
        'No se mostró la notificación de en camino',
        codigo: e.runtimeType.toString(),
      );
    }
  }

  @override
  Future<void> cancelar(String id) async {
    if (!_listo) return;
    try {
      await _plugin.cancel(id: idNotificacion(id));
      await _plugin.cancel(id: idNotificacionEnCamino(id));
    } catch (_) {
      // Si no estaba programada no hay nada que cancelar.
    }
  }
}

/// Para pruebas, `mock` sin plugin y Test Lab: registra lo que se pidió.
final class FakeNotificacionesAsistencia implements NotificacionesAsistencia {
  final Map<String, (DateTime, String, String)> programadas = {};
  final List<String> canceladas = [];

  /// Las notificaciones fijas «en camino» visibles, por id de asistencia.
  final Map<String, EnCaminoAsistencia> enCamino = {};
  bool permiso = true;
  int permisosPedidos = 0;

  /// El canal de la última notificación programada.
  CanalAsistencias? canal;
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
    required CanalAsistencias canal,
    EnCaminoAsistencia? enCamino,
  }) async {
    this.canal = canal;
    programadas[id] = (llegada, titulo, cuerpo);
    if (enCamino != null) this.enCamino[id] = enCamino;
  }

  @override
  Future<void> cancelar(String id) async {
    programadas.remove(id);
    enCamino.remove(id);
    canceladas.add(id);
  }
}
