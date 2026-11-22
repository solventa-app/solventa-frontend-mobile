import 'dart:async';
import 'dart:typed_data';

import '../../../core/errors/falla.dart';
import '../../../core/errors/guardar_fallas.dart';
import '../../../core/log/sol_log.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/network/subida_archivo_service.dart';
import '../domain/entities/reporte_guardado.dart';
import '../domain/entities/reporte_siniestro.dart';
import '../domain/repositories/almacen_reportes.dart';
import 'datasources/reporte_siniestro_remote_datasource.dart';
import 'graphql/reporte_siniestro.graphql.dart';
import 'mappers/reporte_siniestro_mapper.dart';

/// Por qué la cola no está enviando lo que tiene pendiente.
enum EsperaCola {
  /// Nada la detiene (o no hay nada por enviar).
  ninguna,

  /// Sin salida a internet.
  sinRed,

  /// Sin sesión abierta: hay que entrar (o renovarla) para enviar.
  sinSesion,

  /// Solo hay datos móviles y el cliente pidió esperar Wi-Fi.
  wifi,
}

/// En qué va la cola: lo leen M05-04, «Mis siniestros», el banner y la
/// notificación de progreso.
final class ProgresoCola {
  const ProgresoCola({
    this.enviando,
    this.posicion = 0,
    this.total = 0,
    this.foto = 0,
    this.fotos = 0,
    this.radicando = false,
    this.fraccion = 0,
    this.fraccionReporte = 0,
    this.espera = EsperaCola.ninguna,
  });

  /// La última parte de la barra es radicar el caso (plan 4.4).
  static const reservaRadicar = 0.05;

  /// `idReporte` del que se está enviando; `null` si la cola está quieta.
  final String? enviando;

  /// «Enviando [posicion] de [total] reportes».
  final int posicion;
  final int total;

  /// «foto [foto] de [fotos]» del reporte en curso.
  final int foto;
  final int fotos;

  /// Las fotos ya subieron: se está creando el caso.
  final bool radicando;

  /// De 0 a 1, de toda la corrida (bytes de todas las fotos).
  final double fraccion;

  /// De 0 a 1, del reporte en curso.
  final double fraccionReporte;
  final EsperaCola espera;

  bool get activa => enviando != null;

  int get porcentaje => (fraccion * 100).floor().clamp(0, 100);

  int get porcentajeReporte => (fraccionReporte * 100).floor().clamp(0, 100);
}

/// Lo que la cola avisa cuando cambia algo de un reporte (para notificar).
sealed class EventoCola {
  const EventoCola();
}

final class ReporteEnviado extends EventoCola {
  const ReporteEnviado(this.reporte);
  final ReporteGuardado reporte;
}

/// La aseguradora lo rechazó: queda «Con error» hasta que el cliente lo corrija.
final class ReporteRechazado extends EventoCola {
  const ReporteRechazado(this.reporte);
  final ReporteGuardado reporte;
}

/// Falló demasiadas veces por razones técnicas: ya no se reintenta solo.
final class ReporteNecesitaAtencion extends EventoCola {
  const ReporteNecesitaAtencion(this.reporte);
  final ReporteGuardado reporte;
}

/// Se avisa una sola vez por reporte.
final class ReporteEsperaWifi extends EventoCola {
  const ReporteEsperaWifi(this.reporte);
  final ReporteGuardado reporte;
}

/// Hay pendientes y la sesión no está abierta. Una vez, hasta que vuelva.
final class SesionRequerida extends EventoCola {
  const SesionRequerida();
}

/// Terminó una corrida en la que algún reporte llegó a su final.
final class CorridaTerminada extends EventoCola {
  const CorridaTerminada({
    required this.enviados,
    required this.porCorregir,
    this.ultimoEnviado,
  });

  final int enviados;
  final int porCorregir;
  final ReporteGuardado? ultimoEnviado;
}

enum _Fin { enviado, rechazado, tecnico, sinRed, sinSesion, omitido }

final class _Rechazo implements Exception {
  const _Rechazo(this.motivo);
  final String motivo;
}

/// Código de `ultimoError` de una falla técnica (no es un mensaje al cliente).
const errorTecnicoDeEnvio = 'FALLA_TECNICA';

/// La cola de envío de HU-M05 (plan 4.4): un solo trabajador que envía los
/// reportes pendientes de la cuenta, del más antiguo al más nuevo. Cada paso
/// queda guardado antes del siguiente: si la app muere, al abrir se sigue
/// desde la foto que faltaba, con el mismo `idReporte` (no duplica el caso).
final class ColaReportes {
  ColaReportes({
    required this.almacen,
    required this.remoto,
    required this.subida,
    required this.cuenta,
    required this.conectado,
    required this.porDatosMoviles,
    required this.soloWifi,
    required this.sesionAbierta,
    required this.reloj,
  });

  /// Espera antes de cada reintento; la última se repite.
  static const esperas = [
    Duration(seconds: 10),
    Duration(minutes: 1),
    Duration(minutes: 5),
    Duration(minutes: 15),
  ];

  /// Fallas técnicas seguidas (que no son de red) antes de «Necesita atención».
  static const maxIntentos = 8;

  final AlmacenReportes almacen;
  final ReporteSiniestroRemoteDataSource remoto;
  final SubidaArchivoService subida;

  /// La cuenta con sesión. Solo se envía lo suyo.
  final String? Function() cuenta;
  final bool Function() conectado;
  final bool Function() porDatosMoviles;

  /// La preferencia «Enviar las fotos solo con Wi-Fi» de Mi perfil.
  final bool Function() soloWifi;
  final bool Function() sesionAbierta;
  final DateTime Function() reloj;

  final _cambios = StreamController<ProgresoCola>.broadcast();
  final _eventos = StreamController<EventoCola>.broadcast();
  ProgresoCola _progreso = const ProgresoCola();

  Future<void>? _corrida;
  bool _otraVuelta = false;
  bool _reiniciarEsperas = false;
  bool _sesionAvisada = false;
  bool _cerrada = false;
  Timer? _reintento;
  final Set<String> _forzados = {};
  final Map<String, int> _fallasDeRed = {};
  final Map<String, List<Completer<ReporteGuardado?>>> _esperando = {};

  ProgresoCola get progreso => _progreso;
  Stream<ProgresoCola> get cambios => _cambios.stream;
  Stream<EventoCola> get eventos => _eventos.stream;

  /// Hay un envío en curso.
  bool get trabajando => _corrida != null;

  void _publicar(ProgresoCola p) {
    _progreso = p;
    if (!_cambios.isClosed) _cambios.add(p);
  }

  void _avisar(EventoCola e) {
    if (!_eventos.isClosed) _eventos.add(e);
  }

  DateTime _ahora() => reloj().toUtc();

  /// Revisa la cola y envía lo que se pueda. La llaman: la red al volver
  /// ([reiniciarEsperas]), la app al abrir o volver al frente, la sesión al
  /// renovarse y el temporizador de reintento. Dos llamadas a la vez no se
  /// pisan: la segunda pide otra vuelta al terminar la primera.
  Future<void> despertar({bool reiniciarEsperas = false}) {
    if (_cerrada) return Future.value();
    if (reiniciarEsperas) _reiniciarEsperas = true;
    final enCurso = _corrida;
    if (enCurso != null) {
      _otraVuelta = true;
      return enCurso;
    }
    return _corrida = _trabajar().whenComplete(() => _corrida = null);
  }

  /// «Enviar ahora»: salta la espera del reintento de [id]. Con [conDatos]
  /// lo deja salir por datos móviles aunque la preferencia pida Wi-Fi.
  Future<void> enviarAhora(String id, {bool conDatos = false}) async {
    if (_cerrada) return;
    final ahora = _ahora();
    await almacen.actualizar(id, (a) {
      final reintentable =
          a.estado == EstadoLocal.pendiente ||
          a.estado == EstadoLocal.necesitaAtencion;
      if (!reintentable) return a;
      return a.copyWith(
        estado: EstadoLocal.pendiente,
        actualizadoEn: ahora,
        intentos: a.estado == EstadoLocal.necesitaAtencion ? 0 : a.intentos,
        proximoIntentoEn: () => null,
        datosPermitidos: conDatos || a.datosPermitidos,
        esperaWifi: conDatos ? false : a.esperaWifi,
      );
    });
    _forzados.add(id);
    await despertar();
  }

  /// Como [enviarAhora], y termina cuando se sabe en qué quedó ese reporte:
  /// enviado, con error, o de vuelta en la cola (sin red, sin sesión o
  /// esperando Wi-Fi).
  Future<ReporteGuardado?> enviarYEsperar(String id, {bool conDatos = false}) {
    if (_cerrada) return almacen.leer(id);
    final espera = Completer<ReporteGuardado?>();
    _esperando.putIfAbsent(id, () => []).add(espera);
    unawaited(enviarAhora(id, conDatos: conDatos));
    return espera.future;
  }

  /// Al abrir la app o entrar a la cuenta: lo que quedó «Enviando» cuando la
  /// app se cerró vuelve a «Pendiente» para seguir desde donde iba.
  Future<void> recuperar() async {
    final cuenta = this.cuenta();
    if (cuenta == null || trabajando || _cerrada) return;
    final ahora = _ahora();
    for (final r in await almacen.deCuenta(cuenta)) {
      if (r.estado != EstadoLocal.enviando) continue;
      await almacen.actualizar(
        r.id,
        (a) => a.estado == EstadoLocal.enviando
            ? a.copyWith(estado: EstadoLocal.pendiente, actualizadoEn: ahora)
            : a,
      );
    }
  }

  void cerrar() {
    _cerrada = true;
    _reintento?.cancel();
    for (final lista in _esperando.values) {
      for (final espera in lista) {
        if (!espera.isCompleted) espera.complete(null);
      }
    }
    _esperando.clear();
    unawaited(_cambios.close());
    unawaited(_eventos.close());
  }

  Future<void> _trabajar() async {
    var espera = EsperaCola.ninguna;
    try {
      do {
        _otraVuelta = false;
        espera = await _vuelta();
      } while (_otraVuelta && !_cerrada);
    } on Object catch (e, st) {
      // El almacén falló: nada se pierde, la próxima llamada reintenta.
      SolLog.severe(
        'La cola de reportes se detuvo',
        error: e.runtimeType.toString(),
        stackTrace: st,
        codigo: 'COLA_REPORTES',
      );
    } finally {
      _publicar(ProgresoCola(espera: espera));
      await _resolverEsperas();
    }
  }

  Future<void> _resolver(String id) async {
    final lista = _esperando.remove(id);
    if (lista == null) return;
    ReporteGuardado? reporte;
    try {
      reporte = await almacen.leer(id);
    } on Object {
      reporte = null;
    }
    for (final espera in lista) {
      if (!espera.isCompleted) espera.complete(reporte);
    }
  }

  Future<void> _resolverEsperas() async {
    for (final id in _esperando.keys.toList()) {
      await _resolver(id);
    }
  }

  /// Una pasada por la cola. Devuelve qué la dejó esperando.
  Future<EsperaCola> _vuelta() async {
    final reiniciar = _reiniciarEsperas;
    _reiniciarEsperas = false;
    final forzados = {..._forzados};
    _forzados.clear();
    _reintento?.cancel();
    _reintento = null;

    final cuenta = this.cuenta();
    if (cuenta == null) return EsperaCola.ninguna;

    final enCola =
        (await almacen.deCuenta(cuenta))
            .where((r) => r.estado == EstadoLocal.pendiente && r.completo)
            .toList()
          ..sort(
            (a, b) => (a.guardadoEn ?? a.creadoEn).compareTo(
              b.guardadoEn ?? b.creadoEn,
            ),
          );
    if (enCola.isEmpty) return EsperaCola.ninguna;
    if (!conectado()) return EsperaCola.sinRed;
    if (!sesionAbierta()) {
      if (!_sesionAvisada) {
        _sesionAvisada = true;
        _avisar(const SesionRequerida());
      }
      return EsperaCola.sinSesion;
    }
    _sesionAvisada = false;

    final ahora = _ahora();
    final datos = porDatosMoviles();
    final preferencia = soloWifi();
    final listos = <ReporteGuardado>[];
    var esperanWifi = 0;
    for (final r in enCola) {
      if (datos && r.esperaWifiCon(soloWifi: preferencia)) {
        esperanWifi++;
        if (!r.avisoWifiDado) {
          final avisado = await almacen.actualizar(
            r.id,
            (a) => a.copyWith(avisoWifiDado: true),
          );
          if (avisado != null) _avisar(ReporteEsperaWifi(avisado));
        }
        continue;
      }
      final hasta = r.proximoIntentoEn;
      final enEspera = hasta != null && hasta.isAfter(ahora);
      if (enEspera && !reiniciar && !forzados.contains(r.id)) continue;
      listos.add(r);
    }

    final bytesTotales = listos.fold(0, (suma, r) => suma + r.bytesFotos);
    var bytesAntes = 0;
    var radicados = 0;
    var enviados = 0;
    var porCorregir = 0;
    ReporteGuardado? ultimo;
    var espera = EsperaCola.ninguna;
    for (final (i, r) in listos.indexed) {
      if (_cerrada) break;
      final fin = await _enviar(
        r,
        posicion: i + 1,
        total: listos.length,
        bytesAntes: bytesAntes,
        bytesTotales: bytesTotales,
        radicados: radicados,
      );
      bytesAntes += r.bytesFotos;
      await _resolver(r.id);
      switch (fin) {
        case _Fin.enviado:
          enviados++;
          radicados++;
          ultimo = await almacen.leer(r.id);
        case _Fin.rechazado:
          porCorregir++;
        case _Fin.sinRed:
          espera = EsperaCola.sinRed;
        case _Fin.sinSesion:
          espera = EsperaCola.sinSesion;
        case _Fin.tecnico || _Fin.omitido:
          break;
      }
      if (espera != EsperaCola.ninguna) break;
    }
    if (enviados + porCorregir > 0) {
      _avisar(
        CorridaTerminada(
          enviados: enviados,
          porCorregir: porCorregir,
          ultimoEnviado: ultimo,
        ),
      );
    }
    await _programarReintento(cuenta);
    if (espera == EsperaCola.ninguna && esperanWifi > 0) {
      return EsperaCola.wifi;
    }
    return espera;
  }

  /// Un temporizador para el reintento más próximo. En reposo Android lo
  /// pausa: por eso la cola también se revisa al volver la app al frente.
  Future<void> _programarReintento(String cuenta) async {
    if (_cerrada) return;
    DateTime? proximo;
    for (final r in await almacen.deCuenta(cuenta)) {
      final hasta = r.proximoIntentoEn;
      if (r.estado != EstadoLocal.pendiente || hasta == null) continue;
      if (proximo == null || hasta.isBefore(proximo)) proximo = hasta;
    }
    if (proximo == null) return;
    final falta = proximo.difference(_ahora());
    _reintento?.cancel();
    _reintento = Timer(
      falta < const Duration(seconds: 1) ? const Duration(seconds: 1) : falta,
      () => unawaited(despertar()),
    );
  }

  Future<_Fin> _enviar(
    ReporteGuardado reporte, {
    required int posicion,
    required int total,
    required int bytesAntes,
    required int bytesTotales,
    required int radicados,
  }) async {
    final id = reporte.id;
    // Si el cliente lo abrió para editar entre tanto, ya no es de la cola.
    final tomado = await almacen.actualizar(
      id,
      (a) => a.estado == EstadoLocal.pendiente && a.completo
          ? a.copyWith(
              estado: EstadoLocal.enviando,
              actualizadoEn: _ahora(),
              proximoIntentoEn: () => null,
            )
          : a,
    );
    if (tomado == null || tomado.estado != EstadoLocal.enviando) {
      return _Fin.omitido;
    }

    final fotos = [...tomado.fotos]..sort((a, b) => a.orden.compareTo(b.orden));
    final bytesReporte = tomado.bytesFotos;
    var subidos = fotos
        .where((f) => f.subida)
        .fold(0, (suma, f) => suma + f.tamano);
    var radicando = false;
    var ultimoPorcentaje = -1;

    void publicar({required int foto, int enCurso = 0, bool forzar = false}) {
      final hechos = subidos + enCurso;
      const parte = 1 - ProgresoCola.reservaRadicar;
      final delReporte = bytesReporte == 0
          ? 0.0
          : parte * hechos / bytesReporte;
      final deTodos = bytesTotales == 0
          ? 0.0
          : parte * (bytesAntes + hechos) / bytesTotales;
      final fraccion =
          deTodos + ProgresoCola.reservaRadicar * radicados / total;
      // onSendProgress llega muchas veces por segundo: se publica al cambiar
      // el porcentaje.
      final porcentaje = (fraccion * 1000).floor();
      if (!forzar && porcentaje == ultimoPorcentaje) return;
      ultimoPorcentaje = porcentaje;
      _publicar(
        ProgresoCola(
          enviando: id,
          posicion: posicion,
          total: total,
          foto: foto,
          fotos: fotos.length,
          radicando: radicando,
          fraccion: fraccion.clamp(0, 1),
          fraccionReporte: delReporte.clamp(0, 1),
        ),
      );
    }

    publicar(foto: fotos.where((f) => f.subida).length, forzar: true);
    try {
      final archivos = <String>[];
      for (final (i, foto) in fotos.indexed) {
        final ya = foto.archivoId;
        if (ya != null) {
          archivos.add(ya);
          continue;
        }
        publicar(foto: i + 1, forzar: true);
        archivos.add(
          await _subirFoto(
            id,
            foto,
            alAvanzar: (enviados) => publicar(foto: i + 1, enCurso: enviados),
          ),
        );
        subidos += foto.tamano;
        publicar(foto: i + 1, forzar: true);
      }

      radicando = true;
      publicar(foto: fotos.length, forzar: true);
      final respuesta = await remoto.reportar(
        entradaReporte(_paraEnviar(tomado, fotos), archivos),
      );
      final caso = switch (respuesta) {
        Mutation$ReportarSiniestro$reportarSiniestro$$SiniestroReportado() =>
          siniestroDesdeGql(respuesta),
        Mutation$ReportarSiniestro$reportarSiniestro$$ErrorSiniestro(
          :final mensaje,
        ) =>
          throw _Rechazo(mensaje),
        _ => throw const FormatException('reportarSiniestro desconocido'),
      };

      final ahora = _ahora();
      await almacen.actualizar(
        id,
        (a) => a.copyWith(
          estado: EstadoLocal.enviado,
          actualizadoEn: ahora,
          resultado: () => caso,
          enviadoEn: () => ahora,
          intentos: 0,
          proximoIntentoEn: () => null,
          ultimoError: () => null,
          radicacionIncierta: false,
        ),
      );
      // Ya está en la aseguradora: las fotos no hacen falta en el teléfono.
      await almacen.borrarBytesDeFotos(id);
      _fallasDeRed.remove(id);
      final enviado = await almacen.leer(id);
      if (enviado != null) _avisar(ReporteEnviado(enviado));
      return _Fin.enviado;
    } on _Rechazo catch (e) {
      final rechazado = await almacen.actualizar(
        id,
        (a) => a.copyWith(
          estado: EstadoLocal.conError,
          actualizadoEn: _ahora(),
          ultimoError: () => e.motivo,
          proximoIntentoEn: () => null,
          radicacionIncierta: false,
        ),
      );
      _fallasDeRed.remove(id);
      if (rechazado != null) _avisar(ReporteRechazado(rechazado));
      return _Fin.rechazado;
    } on ErrorCliente catch (e) {
      return _alFallar(id, fallaDesdeErrorCliente(e), radicando: radicando);
    } on Object catch (e) {
      return _alFallar(id, Inesperada(e), radicando: radicando);
    }
  }

  /// Pide la URL firmada justo antes de subir (dura 10 minutos), sube,
  /// confirma y guarda el id del archivo. Devuelve ese id.
  Future<String> _subirFoto(
    String idReporte,
    FotoGuardada foto, {
    required void Function(int enviados) alAvanzar,
  }) async {
    final Uint8List? bytes = await almacen.bytesDeFoto(foto.id);
    if (bytes == null || bytes.isEmpty) {
      // La foto ya no está en el teléfono: hay que tomarla de nuevo.
      throw const _Rechazo(motivoFotoNoConfirmada);
    }
    final subida = await remoto.solicitarSubida(
      idReporte,
      foto.tipoContenido,
      bytes.length,
    );
    if (subida
        is! Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$SubidaArchivo) {
      throw _Rechazo(
        subida is Mutation$SolicitarSubidaEvidenciaSiniestro$solicitarSubidaEvidenciaSiniestro$$ErrorArchivo
            ? subida.codigo
            : motivoFotoNoConfirmada,
      );
    }
    await this.subida.subir(
      url: subida.url,
      metodo: subida.metodo,
      encabezados: {for (final e in subida.encabezados) e.nombre: e.valor},
      bytes: bytes,
      alAvanzar: alAvanzar,
    );
    final confirmada = await remoto.confirmar(subida.archivo.id);
    if (confirmada
        is! Mutation$ConfirmarSubidaEvidencia$confirmarSubidaArchivo$$Archivo) {
      // La subida terminó pero el almacenamiento no la confirma: esa foto se
      // vuelve a subir en el siguiente intento; las demás no.
      throw const FormatException('subida sin confirmar');
    }
    await almacen.marcarFotoSubida(foto.id, subida.archivo.id);
    return subida.archivo.id;
  }

  /// El reporte tal como lo espera el contrato. Los bytes no viajan aquí: las
  /// fotos van por su id de archivo.
  ReporteSiniestro _paraEnviar(ReporteGuardado r, List<FotoGuardada> fotos) =>
      ReporteSiniestro(
        idReporte: r.id,
        poliza: r.poliza!,
        tipoAuto: r.tipoAuto,
        ocurridoEn: r.ocurridoEn!,
        descripcion: r.descripcion,
        lugar: r.lugar,
        ciudad: r.ciudad,
        ubicacion: r.ubicacion!,
        fotos: [
          for (final f in fotos)
            FotoSiniestro(
              bytes: Uint8List(0),
              tipoContenido: f.tipoContenido,
              tomadaEn: f.tomadaEn,
              ubicacion: f.ubicacion,
              deDireccion: f.deDireccion,
            ),
        ],
      );

  Duration _esperaTras(int fallas) =>
      esperas[(fallas - 1).clamp(0, esperas.length - 1)];

  Future<_Fin> _alFallar(
    String id,
    Falla falla, {
    required bool radicando,
  }) async {
    final ahora = _ahora();
    switch (falla) {
      // Red caída, tiempo agotado, 502/503: vuelve a la cola y reintenta
      // sola. Si se cortó al radicar, puede que el caso ya exista.
      case SinConexion() || ServicioNoDisponible():
        final fallas = _fallasDeRed.update(id, (n) => n + 1, ifAbsent: () => 1);
        await almacen.actualizar(
          id,
          (a) => a.copyWith(
            estado: EstadoLocal.pendiente,
            actualizadoEn: ahora,
            proximoIntentoEn: () => ahora.add(_esperaTras(fallas)),
            radicacionIncierta: a.radicacionIncierta || radicando,
          ),
        );
        return falla is SinConexion ? _Fin.sinRed : _Fin.tecnico;
      // La sesión venció a mitad: se detiene sin perder lo subido.
      case SesionVencida() || SeguridadTelefonoCambio():
        await almacen.actualizar(
          id,
          (a) => a.copyWith(
            estado: EstadoLocal.pendiente,
            actualizadoEn: ahora,
            radicacionIncierta: a.radicacionIncierta || radicando,
          ),
        );
        if (!_sesionAvisada) {
          _sesionAvisada = true;
          _avisar(const SesionRequerida());
        }
        return _Fin.sinSesion;
      case SinPermiso() || FallaNegocio() || Inesperada():
        SolLog.warning(
          'Falla técnica al enviar un reporte',
          codigo: falla.runtimeType.toString(),
        );
        final fallado = await almacen.actualizar(id, (a) {
          final intentos = a.intentos + 1;
          final agotado = intentos >= maxIntentos;
          return a.copyWith(
            estado: agotado
                ? EstadoLocal.necesitaAtencion
                : EstadoLocal.pendiente,
            actualizadoEn: ahora,
            intentos: intentos,
            proximoIntentoEn: () =>
                agotado ? null : ahora.add(_esperaTras(intentos)),
            ultimoError: () => errorTecnicoDeEnvio,
            radicacionIncierta: a.radicacionIncierta || radicando,
          );
        });
        if (fallado != null && fallado.estado == EstadoLocal.necesitaAtencion) {
          _avisar(ReporteNecesitaAtencion(fallado));
        }
        return _Fin.tecnico;
    }
  }
}
