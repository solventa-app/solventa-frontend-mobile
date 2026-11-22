import 'dart:ui' show Color;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/log/sol_log.dart';

/// Nombre y descripción de un canal en Ajustes de Android, en el idioma de la app.
typedef CanalReportes = ({String nombre, String descripcion});

/// Un recordatorio de «tienes reportes por enviar».
typedef RecordatorioReporte = ({DateTime cuando, String titulo, String cuerpo});

/// Notificaciones locales del reporte de siniestro (HU-M05, plan 4.4). No
/// dependen del servidor ni del interruptor de push del perfil. Van en su
/// canal «Reportes de siniestro» y el progreso en uno silencioso aparte, igual
/// que HU-M06 con sus asistencias: una nunca pisa a la otra.
///
/// Los textos llegan traducidos y **sin datos personales**: solo el estado y,
/// al enviarse, el radicado. El payload es la ruta que abre el toque (empieza
/// por `/`); con la app bloqueada, el guard pide primero la huella.
abstract interface class NotificacionesReporte {
  /// Android 13+: el diálogo del sistema. `false` si lo niega.
  Future<bool> pedirPermiso();

  /// El permiso está concedido y el canal de reportes no está apagado.
  Future<bool> permitidas();

  /// La notificación fija de progreso (una sola, se actualiza sin sonar).
  Future<void> progreso({
    required String titulo,
    required String cuerpo,
    required int porcentaje,
    required CanalReportes canal,
    required String ruta,
  });

  Future<void> quitarProgreso();

  /// Arranca el servicio en primer plano de Android (tipo `dataSync`) con la
  /// notificación de progreso, o la actualiza si ya corre: mientras exista,
  /// el sistema no cierra la app aunque el cliente cambie de aplicación.
  /// `false` si Android no lo dejó arrancar (p. ej. desde segundo plano): el
  /// envío sigue igual y, si la app se cierra, retoma al abrirla.
  Future<bool> servicio({
    required String titulo,
    required String cuerpo,
    required int porcentaje,
    required CanalReportes canal,
    required String ruta,
  });

  /// Detiene el servicio y quita su notificación. Sin servicio no hace nada.
  Future<void> detenerServicio();

  /// El resultado o un aviso de un reporte. Uno solo: el nuevo reemplaza al
  /// anterior.
  Future<void> aviso({
    required String titulo,
    required String cuerpo,
    required CanalReportes canal,
    required String ruta,
    bool suena = true,
  });

  /// Reemplaza los recordatorios programados (máximo 3).
  Future<void> programarRecordatorios(
    List<RecordatorioReporte> recordatorios, {
    required CanalReportes canal,
    required String ruta,
  });

  Future<void> cancelarRecordatorios();

  /// Al cerrar sesión: nada de esta cuenta sigue notificando.
  Future<void> cancelarTodo();
}

/// Canal de resultados y recordatorios: suena.
const idCanalReportes = 'reportes_siniestro';

/// Canal del progreso, de importancia baja: no suena ni vibra.
const idCanalProgresoReportes = 'reportes_siniestro_progreso';

/// Ids fijos: una sola notificación de cada clase, que se va reemplazando.
const idNotificacionProgresoReporte = 0x52500001;
const idNotificacionAvisoReporte = 0x52500002;
const idsRecordatoriosReporte = [0x52500010, 0x52500011, 0x52500012];

const _icono = 'ic_stat_solventa';
const _color = Color(0xFF37599E);

/// Usa el plugin que ya inicializa HU-M06 al arrancar la app (el mismo
/// singleton): aquí no se vuelve a llamar `initialize`, para no pisar el
/// manejador de toques.
final class LocalNotificacionesReporte implements NotificacionesReporte {
  LocalNotificacionesReporte([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<void> _intentar(String que, Future<void> Function() accion) async {
    try {
      await accion();
    } catch (e) {
      // Sin plugin o sin permiso: la app sigue y el estado se ve adentro.
      SolLog.warning(
        'Notificación de reporte no mostrada ($que)',
        codigo: e.runtimeType.toString(),
      );
    }
  }

  @override
  Future<bool> pedirPermiso() async {
    try {
      return await _android?.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> permitidas() async {
    try {
      final android = _android;
      if (android == null) return false;
      if (!(await android.areNotificationsEnabled() ?? false)) return false;
      // Apagar solo el canal de reportes cuenta como negarlo.
      final canales = await android.getNotificationChannels() ?? const [];
      return !canales.any(
        (c) => c.id == idCanalReportes && c.importance == Importance.none,
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> progreso({
    required String titulo,
    required String cuerpo,
    required int porcentaje,
    required CanalReportes canal,
    required String ruta,
  }) => _intentar(
    'progreso',
    () => _plugin.show(
      id: idNotificacionProgresoReporte,
      title: titulo,
      body: cuerpo,
      notificationDetails: NotificationDetails(
        android: _detallesProgreso(canal, porcentaje),
      ),
      payload: ruta,
    ),
  );

  AndroidNotificationDetails _detallesProgreso(
    CanalReportes canal,
    int porcentaje,
  ) => AndroidNotificationDetails(
    idCanalProgresoReportes,
    canal.nombre,
    channelDescription: canal.descripcion,
    importance: Importance.low,
    priority: Priority.low,
    icon: _icono,
    color: _color,
    category: AndroidNotificationCategory.progress,
    visibility: NotificationVisibility.private,
    // Fija: no se desliza y se actualiza sin volver a sonar.
    ongoing: true,
    autoCancel: false,
    onlyAlertOnce: true,
    showProgress: true,
    maxProgress: 100,
    progress: porcentaje.clamp(0, 100),
  );

  @override
  Future<bool> servicio({
    required String titulo,
    required String cuerpo,
    required int porcentaje,
    required CanalReportes canal,
    required String ruta,
  }) async {
    final android = _android;
    if (android == null) return false;
    try {
      // Llamarlo de nuevo con el servicio andando solo actualiza su
      // notificación. Si Android mata el proceso no lo revive (`notSticky`):
      // sin la app no hay quien envíe, y la cola retoma al abrirla.
      await android.startForegroundService(
        id: idNotificacionProgresoReporte,
        title: titulo,
        body: cuerpo,
        notificationDetails: _detallesProgreso(canal, porcentaje),
        payload: ruta,
        startType: AndroidServiceStartType.startNotSticky,
        foregroundServiceTypes: const {
          AndroidServiceForegroundType.foregroundServiceTypeDataSync,
        },
      );
      return true;
    } catch (e) {
      // Android 12+ no deja arrancarlo desde segundo plano; tampoco arranca
      // si el sistema agotó el tiempo diario de `dataSync` (Android 15).
      SolLog.info(
        'Servicio de envío no arrancó',
        codigo: e.runtimeType.toString(),
      );
      return false;
    }
  }

  @override
  Future<void> detenerServicio() => _intentar(
    'detener servicio',
    () async => _android?.stopForegroundService(),
  );

  @override
  Future<void> quitarProgreso() => _intentar(
    'quitar progreso',
    () => _plugin.cancel(id: idNotificacionProgresoReporte),
  );

  NotificationDetails _detalles(CanalReportes canal, {bool suena = true}) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          suena ? idCanalReportes : idCanalProgresoReportes,
          canal.nombre,
          channelDescription: canal.descripcion,
          importance: suena ? Importance.high : Importance.low,
          priority: suena ? Priority.high : Priority.low,
          icon: _icono,
          color: _color,
          // En la pantalla de bloqueo, Android oculta el contenido si el
          // cliente pidió ocultar lo sensible.
          visibility: NotificationVisibility.private,
        ),
      );

  @override
  Future<void> aviso({
    required String titulo,
    required String cuerpo,
    required CanalReportes canal,
    required String ruta,
    bool suena = true,
  }) => _intentar(
    'aviso',
    () => _plugin.show(
      id: idNotificacionAvisoReporte,
      title: titulo,
      body: cuerpo,
      notificationDetails: _detalles(canal, suena: suena),
      payload: ruta,
    ),
  );

  @override
  Future<void> programarRecordatorios(
    List<RecordatorioReporte> recordatorios, {
    required CanalReportes canal,
    required String ruta,
  }) async {
    await cancelarRecordatorios();
    final ahora = DateTime.now();
    final futuros = recordatorios
        .where((r) => r.cuando.isAfter(ahora))
        .take(idsRecordatoriosReporte.length);
    for (final (i, r) in futuros.indexed) {
      await _intentar(
        'recordatorio',
        () => _plugin.zonedSchedule(
          id: idsRecordatoriosReporte[i],
          title: r.titulo,
          body: r.cuerpo,
          // Un instante absoluto: la hora local ya se resolvió al calcularlo.
          scheduledDate: tz.TZDateTime.from(r.cuando.toUtc(), tz.UTC),
          notificationDetails: _detalles(canal),
          // Sin alarma exacta: no hace falta ese permiso.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: ruta,
        ),
      );
    }
  }

  @override
  Future<void> cancelarRecordatorios() async {
    for (final id in idsRecordatoriosReporte) {
      await _intentar('cancelar recordatorio', () => _plugin.cancel(id: id));
    }
  }

  @override
  Future<void> cancelarTodo() async {
    await cancelarRecordatorios();
    await detenerServicio();
    await quitarProgreso();
    await _intentar(
      'cancelar aviso',
      () => _plugin.cancel(id: idNotificacionAvisoReporte),
    );
  }
}

/// Para pruebas y `API_ENV=mock` sin plugin: registra lo que se pidió.
final class FakeNotificacionesReporte implements NotificacionesReporte {
  bool permiso = true;
  int permisosPedidos = 0;

  /// La notificación fija de progreso visible: (título, cuerpo, porcentaje).
  (String, String, int)? progresoVisible;

  /// Todos los avisos mostrados: (título, cuerpo, ruta, suena).
  final List<(String, String, String, bool)> avisos = [];
  List<RecordatorioReporte> recordatorios = const [];
  int cancelaciones = 0;

  @override
  Future<bool> pedirPermiso() async {
    permisosPedidos++;
    return permiso;
  }

  @override
  Future<bool> permitidas() async => permiso;

  @override
  Future<void> progreso({
    required String titulo,
    required String cuerpo,
    required int porcentaje,
    required CanalReportes canal,
    required String ruta,
  }) async => progresoVisible = (titulo, cuerpo, porcentaje);

  @override
  Future<void> quitarProgreso() async => progresoVisible = null;

  /// Android deja arrancar el servicio (desde segundo plano no lo permite).
  bool servicioPermitido = true;

  /// La notificación del servicio mientras corre: (título, cuerpo, porcentaje).
  (String, String, int)? servicioActivo;
  int arranquesServicio = 0;
  int detencionesServicio = 0;

  @override
  Future<bool> servicio({
    required String titulo,
    required String cuerpo,
    required int porcentaje,
    required CanalReportes canal,
    required String ruta,
  }) async {
    if (!servicioPermitido) return false;
    if (servicioActivo == null) arranquesServicio++;
    servicioActivo = (titulo, cuerpo, porcentaje);
    return true;
  }

  @override
  Future<void> detenerServicio() async {
    if (servicioActivo != null) detencionesServicio++;
    servicioActivo = null;
  }

  @override
  Future<void> aviso({
    required String titulo,
    required String cuerpo,
    required CanalReportes canal,
    required String ruta,
    bool suena = true,
  }) async => avisos.add((titulo, cuerpo, ruta, suena));

  @override
  Future<void> programarRecordatorios(
    List<RecordatorioReporte> recordatorios, {
    required CanalReportes canal,
    required String ruta,
  }) async => this.recordatorios = recordatorios;

  @override
  Future<void> cancelarRecordatorios() async => recordatorios = const [];

  @override
  Future<void> cancelarTodo() async {
    cancelaciones++;
    recordatorios = const [];
    progresoVisible = null;
    await detenerServicio();
  }
}
