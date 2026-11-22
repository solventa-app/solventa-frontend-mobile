import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/solventa_ui.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/red/estado_red_notifier.dart';
import '../data/cola_reportes.dart';
import '../data/notificaciones_reporte.dart';
import '../domain/entities/reporte_guardado.dart';
import 'providers.dart';
import 'reporte_routes.dart';

/// Lo último que la cola terminó, para la franja «Reporte enviado» dentro de
/// la app. Se oculta sola a los pocos segundos.
final class AvisoEnvio {
  const AvisoEnvio({
    required this.enviados,
    required this.porCorregir,
    this.radicado,
    this.ruta = ReporteRoutes.misSiniestros,
  });

  final int enviados;
  final int porCorregir;

  /// El radicado, cuando fue un solo reporte.
  final String? radicado;

  /// A dónde lleva «Ver».
  final String ruta;
}

final class AvisoEnvioNotifier extends Notifier<AvisoEnvio?> {
  static const duracion = Duration(seconds: 8);

  Timer? _ocultar;

  @override
  AvisoEnvio? build() {
    ref.onDispose(() => _ocultar?.cancel());
    return null;
  }

  void mostrar(AvisoEnvio aviso) {
    _ocultar?.cancel();
    state = aviso;
    _ocultar = Timer(duracion, ocultar);
  }

  void ocultar() {
    _ocultar?.cancel();
    _ocultar = null;
    if (ref.mounted) state = null;
  }
}

final avisoEnvioProvider = NotifierProvider<AvisoEnvioNotifier, AvisoEnvio?>(
  AvisoEnvioNotifier.new,
);

/// Horario de silencio de los recordatorios: de 10 p. m. a 7 a. m., con la
/// hora del teléfono.
const silencioDesde = 22;
const silencioHasta = 7;

/// Si [local] cae en el horario de silencio, las 7 a. m. siguientes.
DateTime fueraDeSilencio(DateTime local) {
  if (local.hour >= silencioDesde) {
    return DateTime(local.year, local.month, local.day + 1, silencioHasta);
  }
  if (local.hour < silencioHasta) {
    return DateTime(local.year, local.month, local.day, silencioHasta);
  }
  return local;
}

/// Cuándo recordar un reporte que quedó pendiente en [desde]: a los 30 min,
/// 3 h y 24 h, corridos fuera del horario de silencio y solo los que faltan.
List<DateTime> horasDeRecordatorio(DateTime desde, DateTime ahora) {
  const esperas = [
    Duration(minutes: 30),
    Duration(hours: 3),
    Duration(hours: 24),
  ];
  final horas = <DateTime>[];
  for (final espera in esperas) {
    final cuando = fueraDeSilencio(desde.toLocal().add(espera));
    if (cuando.isAfter(ahora) && !horas.contains(cuando)) horas.add(cuando);
  }
  return horas;
}

/// Mantiene viva la cola de reportes y avisa lo que pasa con ella (plan 4.4).
///
/// - La despierta al volver la red, al entrar a la cuenta y al volver la app
///   al frente.
/// - Con la app al frente no notifica: lo mismo se ve adentro (franja, chips,
///   pantalla de resultado). En segundo plano muestra el progreso, el
///   resultado y lo que requiera al cliente.
/// - Programa los recordatorios de lo pendiente y los cancela al enviarse.
///
/// Ningún texto lleva datos personales: solo el estado y el radicado.
final class VigiaReportes {
  VigiaReportes(this._ref) {
    final cola = _ref.read(colaReportesProvider);
    _eventos = cola.eventos.listen(_alEvento);
    _progreso = cola.cambios.listen(_alProgreso);
    _ref
      ..listen(estadoRedProvider, (antes, ahora) {
        if (antes == null || !ahora.conectado) return;
        // Vuelve la red, o cambia de datos a Wi-Fi: las esperas se reinician.
        if (!antes.conectado || antes.tipo != ahora.tipo) {
          unawaited(_cola.despertar(reiniciarEsperas: true));
        }
      })
      ..listen(cuentaReporteProvider, (antes, ahora) {
        if (ahora != null) {
          unawaited(_alEntrar());
        } else if (antes != null) {
          // Sin sesión no se notifica nada: el teléfono puede estar en otras
          // manos. Los reportes siguen guardados.
          _recordatorios = null;
          unawaited(_avisos.cancelarTodo());
        }
      }, fireImmediately: true)
      ..listen(
        reportesGuardadosProvider,
        (_, _) => unawaited(_reprogramarRecordatorios()),
      )
      ..listen(localeProvider, (_, _) {
        _recordatorios = null;
        unawaited(_reprogramarRecordatorios());
      })
      ..listen(
        preferenciasEnvioProvider.select((p) => p.soloWifi),
        (_, _) => unawaited(_cola.despertar()),
      );
  }

  final Ref _ref;
  late final StreamSubscription<EventoCola> _eventos;
  late final StreamSubscription<ProgresoCola> _progreso;
  bool _alFrente = true;
  bool _habiaEnvio = false;
  int _ultimoPorcentaje = 0;
  bool _cerrado = false;

  /// Firma de los recordatorios programados, para no reprogramar lo mismo.
  String? _recordatorios;

  ColaReportes get _cola => _ref.read(colaReportesProvider);
  NotificacionesReporte get _avisos => _ref.read(notificacionesReporteProvider);
  AppLocalizations get _l10n =>
      lookupAppLocalizations(_ref.read(localeProvider));

  CanalReportes get _canal => (
    nombre: _l10n.avisoReporteCanal,
    descripcion: _l10n.avisoReporteCanalDescripcion,
  );

  CanalReportes get _canalProgreso => (
    nombre: _l10n.avisoReporteProgresoCanal,
    descripcion: _l10n.avisoReporteProgresoCanalDescripcion,
  );

  void cerrar() {
    _cerrado = true;
    unawaited(_eventos.cancel());
    unawaited(_progreso.cancel());
  }

  Future<void> _alEntrar() async {
    await _cola.recuperar();
    if (_cerrado) return;
    await _cola.despertar();
    if (_cerrado) return;
    await _reprogramarRecordatorios();
  }

  /// La sesión se abrió o se renovó, o el cliente tocó algo que amerita
  /// revisar la cola.
  Future<void> despertar() => _cola.despertar();

  /// La app pasó a segundo plano: si hay un envío, se sigue viendo en la
  /// notificación de progreso.
  void alOcultarse() {
    _alFrente = false;
    final p = _cola.progreso;
    if (p.activa) unawaited(_mostrarProgreso(p));
  }

  /// La app volvió: el progreso se ve adentro, y los temporizadores que
  /// Android pausó se recuperan revisando la cola.
  void alVolverAlFrente() {
    _alFrente = true;
    unawaited(_avisos.quitarProgreso());
    unawaited(_cola.despertar());
  }

  Future<void> _mostrarProgreso(ProgresoCola p) {
    final l10n = _l10n;
    return _avisos.progreso(
      titulo: p.total > 1
          ? l10n.avisoReporteEnviandoVarios(p.posicion, p.total, p.porcentaje)
          : l10n.avisoReporteEnviando(p.porcentaje),
      cuerpo: p.radicando
          ? l10n.avisoReporteRadicando
          : l10n.avisoReporteFoto(p.foto.clamp(1, p.fotos), p.fotos),
      porcentaje: p.porcentaje,
      canal: _canalProgreso,
      ruta: ReporteRoutes.misSiniestros,
    );
  }

  void _alProgreso(ProgresoCola p) {
    if (p.activa) {
      _habiaEnvio = true;
      _ultimoPorcentaje = p.porcentaje;
      if (!_alFrente) unawaited(_mostrarProgreso(p));
      return;
    }
    if (!_habiaEnvio) return;
    _habiaEnvio = false;
    if (_alFrente) return;
    if (p.espera == EsperaCola.sinRed) {
      final l10n = _l10n;
      unawaited(
        _avisos.progreso(
          titulo: l10n.avisoReportePausa(_ultimoPorcentaje),
          cuerpo: l10n.avisoReportePausaCuerpo,
          porcentaje: _ultimoPorcentaje,
          canal: _canalProgreso,
          ruta: ReporteRoutes.misSiniestros,
        ),
      );
    } else {
      unawaited(_avisos.quitarProgreso());
    }
  }

  void _alEvento(EventoCola evento) {
    final l10n = _l10n;
    switch (evento) {
      case CorridaTerminada(
        :final enviados,
        :final porCorregir,
        :final ultimoEnviado,
      ):
        final caso = enviados == 1 && porCorregir == 0
            ? ultimoEnviado?.resultado
            : null;
        final ruta = caso != null
            ? ReporteRoutes.detalleDe(caso.id)
            : ReporteRoutes.misSiniestros;
        _ref
            .read(avisoEnvioProvider.notifier)
            .mostrar(
              AvisoEnvio(
                enviados: enviados,
                porCorregir: porCorregir,
                radicado: caso?.radicado,
                ruta: ruta,
              ),
            );
        if (_alFrente) return;
        final (titulo, cuerpo) = switch ((enviados, porCorregir)) {
          (1, 0) when caso != null => (
            l10n.avisoReporteEnviado,
            l10n.avisoReporteEnviadoCuerpo(
              caso.radicado,
              SolFormat.date(caso.venceDictamenEn.toLocal()),
            ),
          ),
          (_, 0) => (
            l10n.avisoReportesEnviados(enviados),
            l10n.avisoReportesVer,
          ),
          (0, _) => (
            l10n.avisoReporteRechazado,
            l10n.avisoReporteRechazadoCuerpo,
          ),
          _ => (
            l10n.avisoReportesMixto(enviados, porCorregir),
            l10n.avisoReportesVer,
          ),
        };
        unawaited(
          _avisos.aviso(
            titulo: titulo,
            cuerpo: cuerpo,
            canal: _canal,
            ruta: ruta,
          ),
        );
      case ReporteNecesitaAtencion(:final reporte):
        if (_alFrente) return;
        unawaited(
          _avisos.aviso(
            titulo: l10n.avisoReporteRechazado,
            cuerpo: l10n.avisoReporteAtencionCuerpo,
            canal: _canal,
            ruta: ReporteRoutes.pendienteDe(reporte.id),
          ),
        );
      case ReporteEsperaWifi(:final reporte):
        if (_alFrente) return;
        unawaited(
          _avisos.aviso(
            titulo: l10n.avisoReporteEsperaWifi,
            cuerpo: l10n.avisoReporteEsperaWifiCuerpo,
            canal: _canalProgreso,
            ruta: ReporteRoutes.pendienteDe(reporte.id),
            suena: false,
          ),
        );
      case SesionRequerida():
        // Un único aviso para iniciar sesión, y los recordatorios se detienen.
        _recordatorios = null;
        unawaited(_avisos.cancelarRecordatorios());
        if (_alFrente) return;
        unawaited(
          _avisos.aviso(
            titulo: l10n.avisoReporteSesion,
            cuerpo: l10n.avisoReporteSesionCuerpo,
            canal: _canal,
            ruta: ReporteRoutes.misSiniestros,
          ),
        );
      case ReporteEnviado() || ReporteRechazado():
        // El resumen llega con `CorridaTerminada`: un solo aviso por corrida.
        break;
    }
  }

  /// Un solo grupo de recordatorios para todo lo pendiente, contado desde el
  /// último que quedó guardado.
  Future<void> _reprogramarRecordatorios() async {
    if (_cerrado) return;
    final cuenta = _ref.read(cuentaReporteProvider);
    final guardados =
        _ref.read(reportesGuardadosProvider).value ?? const <ReporteGuardado>[];
    final pendientes = [
      for (final r in guardados)
        if (r.enCola) r,
    ];
    if (cuenta == null || pendientes.isEmpty) {
      if (_recordatorios != '') {
        _recordatorios = '';
        await _avisos.cancelarRecordatorios();
      }
      return;
    }
    final desde = pendientes
        .map((r) => r.guardadoEn ?? r.actualizadoEn)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final l10n = _l10n;
    final firma =
        '${pendientes.length}|${desde.toIso8601String()}|${l10n.localeName}';
    if (firma == _recordatorios) return;
    _recordatorios = firma;
    final ahora = _ref.read(relojReporteProvider)().toLocal();
    await _avisos.programarRecordatorios(
      [
        for (final cuando in horasDeRecordatorio(desde, ahora))
          (
            cuando: cuando,
            titulo: l10n.avisoReporteRecordatorio(pendientes.length),
            cuerpo: l10n.avisoReporteRecordatorioCuerpo,
          ),
      ],
      canal: _canal,
      ruta: ReporteRoutes.misSiniestros,
    );
  }
}

/// Uno por app. Se crea al arrancar (`SolventaApp`).
final vigiaReportesProvider = Provider<VigiaReportes>((ref) {
  // Si cambia la cola (otra base, otro ambiente), el vigía se rehace con ella.
  ref.watch(colaReportesProvider);
  final vigia = VigiaReportes(ref);
  ref.onDispose(vigia.cerrar);
  return vigia;
});
