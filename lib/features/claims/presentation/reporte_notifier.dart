import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../../../core/ids/uuid.dart';
import '../../../core/log/sol_log.dart';
import '../../../core/ubicacion/coordenada.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../domain/entities/reporte_guardado.dart';
import '../domain/entities/reporte_siniestro.dart';
import '../domain/repositories/almacen_reportes.dart';
import 'providers.dart';

/// Desenlace del envío (M05-04 → M05-05).
sealed class EnvioReporte {
  const EnvioReporte();
}

final class SinEnviar extends EnvioReporte {
  const SinEnviar();
}

final class Enviando extends EnvioReporte {
  const Enviando();
}

final class Enviado extends EnvioReporte {
  const Enviado(this.siniestro);
  final SiniestroReportado siniestro;
}

final class EnvioFallido extends EnvioReporte {
  const EnvioFallido(this.falla);
  final Falla falla;
}

/// Por qué el teléfono no pudo guardar el reporte (M05-02 y M05-03 lo dicen).
enum AvisoGuardado {
  /// El teléfono se quedó sin espacio.
  sinEspacio,

  /// Otra falla del almacén: el reporte sigue en pantalla, pero se pierde si
  /// la app se cierra.
  noGuardado,
}

/// Estado del recorrido de HU-M05 (cruza M05-01 a M05-05). Desde la primera
/// foto, cada paso se escribe también en la base cifrada del teléfono: si la
/// app se cierra, el reporte queda como borrador para continuarlo.
final class ReporteState {
  const ReporteState({
    required this.idReporte,
    this.poliza,
    this.ocurridoEn,
    this.fotos = const [],
    this.ubicacion,
    this.ubicacionSinPermiso = false,
    this.direccionEscrita,
    this.descripcion = '',
    this.lugar = '',
    this.ciudad = '',
    this.envio = const SinEnviar(),
    this.tipoAuto,
    this.avisoGuardado,
  });

  final String idReporte;

  /// El último intento de guardar en el teléfono falló.
  final AvisoGuardado? avisoGuardado;
  final PolizaReportable? poliza;

  /// KAN-290: qué le pasó al vehículo; solo en una póliza de auto.
  final TipoSiniestroAuto? tipoAuto;

  /// En una póliza de auto falta elegir qué pasó.
  bool get faltaTipoAuto => (poliza?.esAuto ?? false) && tipoAuto == null;
  final DateTime? ocurridoEn;
  final List<FotoSiniestro> fotos;

  /// Ubicación del teléfono al tomar las fotos; la del siniestro.
  final Coordenada? ubicacion;
  final bool ubicacionSinPermiso;

  /// Sin GPS, la dirección que el cliente escribió y Places ubicó: da la
  /// [ubicacion] del siniestro y la de las fotos, marcadas como de dirección.
  final String? direccionEscrita;
  final String descripcion;
  final String lugar;
  final String ciudad;
  final EnvioReporte envio;

  bool get puedeTomarMasFotos => fotos.length < ReglasReporte.maxFotos;

  bool get listoParaEnviar =>
      poliza != null &&
      !faltaTipoAuto &&
      ocurridoEn != null &&
      fotos.length >= ReglasReporte.minFotos &&
      ubicacion != null &&
      ReglasReporte.relatoValido(descripcion) &&
      lugar.trim().isNotEmpty &&
      ciudad.trim().isNotEmpty;

  ReporteState copyWith({
    PolizaReportable? poliza,
    DateTime? ocurridoEn,
    List<FotoSiniestro>? fotos,
    Coordenada? ubicacion,
    bool? ubicacionSinPermiso,
    String? Function()? direccionEscrita,
    String? descripcion,
    String? lugar,
    String? ciudad,
    EnvioReporte? envio,
    TipoSiniestroAuto? Function()? tipoAuto,
    AvisoGuardado? Function()? avisoGuardado,
  }) => ReporteState(
    idReporte: idReporte,
    avisoGuardado: avisoGuardado != null ? avisoGuardado() : this.avisoGuardado,
    tipoAuto: tipoAuto != null ? tipoAuto() : this.tipoAuto,
    poliza: poliza ?? this.poliza,
    ocurridoEn: ocurridoEn ?? this.ocurridoEn,
    fotos: fotos ?? this.fotos,
    ubicacion: ubicacion ?? this.ubicacion,
    ubicacionSinPermiso: ubicacionSinPermiso ?? this.ubicacionSinPermiso,
    direccionEscrita: direccionEscrita != null
        ? direccionEscrita()
        : this.direccionEscrita,
    descripcion: descripcion ?? this.descripcion,
    lugar: lugar ?? this.lugar,
    ciudad: ciudad ?? this.ciudad,
    envio: envio ?? this.envio,
  );
}

/// UUID v4 para `idReporte` (clave de idempotencia y id del siniestro).
String nuevoIdReporte([Random? azar]) => uuidV4(azar);

final class ReporteNotifier extends Notifier<ReporteState> {
  /// Las escrituras al almacén van una tras otra, en el orden en que el
  /// cliente hizo cada cosa.
  Future<void> _escrituras = Future.value();

  /// El reporte ya tiene su fila en el almacén.
  bool _guardado = false;

  /// Id en el almacén de cada foto (por sus bytes, que no se copian).
  final Map<Uint8List, int> _idsDeFotos = Map.identity();

  /// Reporte al que le falló una escritura: la siguiente lo vuelve a guardar
  /// entero antes de seguir, para que no quede a medias en el teléfono.
  String? _porRehacer;

  @override
  ReporteState build() {
    ref.onDispose(() => _relatoPendiente?.cancel());
    return ReporteState(idReporte: nuevoIdReporte());
  }

  AlmacenReportes get _almacen => ref.read(almacenReportesProvider);

  DateTime _ahora() => ref.read(relojReporteProvider)().toUtc();

  /// El relato se escribe al dejar de teclear, no en cada letra.
  Timer? _relatoPendiente;

  static const pausaRelato = Duration(milliseconds: 600);

  /// Termina cuando todo lo pendiente quedó escrito en el teléfono.
  Future<void> get guardado {
    _escribirRelatoYa();
    return _escrituras;
  }

  void _escribirRelatoYa() {
    if (_relatoPendiente?.isActive ?? false) {
      _relatoPendiente!.cancel();
      _persistir();
    }
    _relatoPendiente = null;
  }

  /// Empieza un reporte nuevo (otro `idReporte`): al entrar desde el inicio.
  /// El anterior, si quedó a medias, sigue guardado como borrador.
  void reiniciar() {
    _escribirRelatoYa();
    _guardado = false;
    _porRehacer = null;
    _idsDeFotos.clear();
    state = ReporteState(idReporte: nuevoIdReporte());
  }

  /// Retoma un reporte guardado (borrador, por enviar o por corregir): carga
  /// sus datos y sus fotos y lo deja como borrador mientras se edita, para
  /// que la cola no lo envíe a medias. `false` si ya no existe o no se puede
  /// editar.
  Future<bool> continuar(String id) async {
    await this.guardado;
    final almacen = _almacen;
    final guardado = await almacen.leer(id);
    if (guardado == null ||
        !guardado.editable ||
        guardado.cuentaId != ref.read(cuentaReporteProvider)) {
      return false;
    }
    final fotos = <FotoSiniestro>[];
    final ids = <Uint8List, int>{};
    for (final f in guardado.fotos) {
      final bytes = await almacen.bytesDeFoto(f.id);
      if (bytes == null) continue;
      ids[bytes] = f.id;
      fotos.add(
        FotoSiniestro(
          bytes: bytes,
          tipoContenido: f.tipoContenido,
          tomadaEn: f.tomadaEn,
          ubicacion: f.ubicacion,
          deDireccion: f.deDireccion,
        ),
      );
    }
    if (guardado.estado != EstadoLocal.borrador) {
      await almacen.actualizar(
        id,
        (r) =>
            r.copyWith(estado: EstadoLocal.borrador, actualizadoEn: _ahora()),
      );
    }
    if (!ref.mounted) return false;
    _guardado = true;
    _idsDeFotos
      ..clear()
      ..addAll(ids);
    state = ReporteState(
      idReporte: guardado.id,
      poliza: guardado.poliza,
      tipoAuto: guardado.tipoAuto,
      ocurridoEn: guardado.ocurridoEn?.toLocal(),
      fotos: fotos,
      ubicacion: guardado.ubicacion,
      direccionEscrita: guardado.direccionEscrita,
      descripcion: guardado.descripcion,
      lugar: guardado.lugar,
      ciudad: guardado.ciudad,
    );
    return true;
  }

  /// Encola una escritura. Si falla, el reporte sigue en pantalla y se avisa.
  void _escribir(Future<void> Function(AlmacenReportes almacen) operacion) {
    final almacen = _almacen;
    final id = state.idReporte;
    _escrituras = _escrituras.then((_) async {
      try {
        await _rehacer(almacen);
        await operacion(almacen);
        if (ref.mounted && state.avisoGuardado != null) {
          state = state.copyWith(avisoGuardado: () => null);
        }
      } on Object catch (e) {
        // Sin datos del reporte: solo el tipo de error.
        SolLog.severe(
          'No se pudo guardar el reporte en el teléfono',
          codigo: e.runtimeType.toString(),
        );
        if (ref.mounted) {
          _porRehacer = id;
          state = state.copyWith(
            avisoGuardado: () => '$e'.contains('full')
                ? AvisoGuardado.sinEspacio
                : AvisoGuardado.noGuardado,
          );
        }
      }
    });
  }

  /// Tras una escritura fallida, guarda otra vez el reporte en pantalla: sus
  /// datos y las fotos que no alcanzaron a quedar.
  Future<void> _rehacer(AlmacenReportes almacen) async {
    final id = _porRehacer;
    if (id == null || !ref.mounted) return;
    final s = state;
    final cuenta = ref.read(cuentaReporteProvider);
    if (s.idReporte != id || !_guardado || cuenta == null) {
      _porRehacer = null;
      return;
    }
    await _guardarDatos(almacen, s, cuenta);
    for (final foto in s.fotos) {
      await _guardarFoto(almacen, id, foto);
    }
    _porRehacer = null;
  }

  Future<void> _guardarFoto(
    AlmacenReportes almacen,
    String id,
    FotoSiniestro foto,
  ) async {
    if (_idsDeFotos.containsKey(foto.bytes)) return;
    final guardada = await almacen.agregarFoto(
      id,
      bytes: foto.bytes,
      tipoContenido: foto.tipoContenido,
      tomadaEn: foto.tomadaEn,
      ubicacion: foto.ubicacion,
      deDireccion: foto.deDireccion,
    );
    _idsDeFotos[foto.bytes] = guardada.id;
  }

  /// Escribe los datos del reporte (no las fotos). Hasta la primera foto no
  /// hay nada que valga la pena guardar.
  void _persistir() {
    final cuenta = ref.read(cuentaReporteProvider);
    if (cuenta == null) return;
    final s = state;
    if (!_guardado && s.fotos.isEmpty) return;
    _guardado = true;
    _escribir((almacen) => _guardarDatos(almacen, s, cuenta));
  }

  Future<void> _guardarDatos(
    AlmacenReportes almacen,
    ReporteState s,
    String cuenta,
  ) async {
    final ahora = _ahora();
    ReporteGuardado conDatos(ReporteGuardado r) => r.copyWith(
      actualizadoEn: ahora,
      poliza: () => s.poliza,
      tipoAuto: () => s.tipoAuto,
      ocurridoEn: () => s.ocurridoEn?.toUtc(),
      descripcion: s.descripcion,
      lugar: s.lugar,
      ciudad: s.ciudad,
      ubicacion: () => s.ubicacion,
      direccionEscrita: () => s.direccionEscrita,
    );
    final actualizado = await almacen.actualizar(s.idReporte, conDatos);
    if (actualizado == null) {
      await almacen.guardar(
        conDatos(
          ReporteGuardado(
            id: s.idReporte,
            cuentaId: cuenta,
            estado: EstadoLocal.borrador,
            creadoEn: ahora,
            actualizadoEn: ahora,
          ),
        ),
      );
    }
  }

  /// Cambiar de póliza olvida el tipo elegido: puede que la nueva no sea de auto.
  void elegirPoliza(PolizaReportable poliza) {
    state = state.copyWith(poliza: poliza, tipoAuto: () => null);
    _persistir();
  }

  void elegirTipoAuto(TipoSiniestroAuto tipo) {
    state = state.copyWith(tipoAuto: () => tipo);
    _persistir();
  }

  void fijarFecha(DateTime fecha) {
    state = state.copyWith(ocurridoEn: fecha);
    _persistir();
  }

  /// M05-02 al entrar: pide el permiso y guarda dónde está el cliente. Las
  /// fotos que tome después llevan esa ubicación.
  Future<void> prepararUbicacion() async {
    final r = await ref.read(ubicacionReporteProvider).ubicacionActual();
    if (!ref.mounted) return;
    state = switch (r) {
      UbicacionObtenida(:final coordenada) => state.copyWith(
        ubicacion: coordenada,
        ubicacionSinPermiso: false,
        direccionEscrita: () => null,
      ),
      UbicacionSinPermiso() ||
      UbicacionNoDisponible() => state.copyWith(ubicacionSinPermiso: true),
    };
    _persistir();
  }

  /// Sin GPS: la dirección escrita y ubicada con Places (la misma hoja de
  /// HU-M06) da el punto del siniestro y, si aún no hay lugar, lo llena. Las
  /// fotos sin GPS (las de antes y las de después) llevan ese punto (v0.66).
  void usarDireccion(Coordenada coordenada, String direccion) {
    state = state.copyWith(
      ubicacion: coordenada,
      ubicacionSinPermiso: false,
      direccionEscrita: () => direccion,
      lugar: state.lugar.trim().isEmpty ? direccion : null,
      fotos: [
        for (final foto in state.fotos)
          foto.ubicacion == null || foto.deDireccion
              ? foto.conDireccion(coordenada)
              : foto,
      ],
    );
    _persistir();
    if (_guardado) {
      final id = state.idReporte;
      _escribir((almacen) => almacen.ubicarFotosSinGps(id, coordenada));
    }
  }

  Future<void> abrirAjustesUbicacion() =>
      ref.read(ubicacionReporteProvider).abrirAjustes(deUbicacion: false);

  void agregarFoto(Uint8List bytes, {String tipoContenido = 'image/jpeg'}) {
    if (!state.puedeTomarMasFotos || bytes.isEmpty) return;
    if (bytes.length > ReglasReporte.maxBytesFoto) return;
    final foto = FotoSiniestro(
      bytes: bytes,
      tipoContenido: tipoContenido,
      tomadaEn: ref.read(relojReporteProvider)(),
      // Sin GPS, el punto de la dirección escrita (marcado como tal).
      ubicacion: state.ubicacion,
      deDireccion: state.direccionEscrita != null,
    );
    state = state.copyWith(fotos: [...state.fotos, foto]);
    // La fila del reporte primero; después la foto, cifrada con él.
    _persistir();
    if (!_guardado) return;
    final id = state.idReporte;
    _escribir((almacen) => _guardarFoto(almacen, id, foto));
  }

  void quitarFoto(int indice) {
    final foto = state.fotos[indice];
    state = state.copyWith(fotos: [...state.fotos]..removeAt(indice));
    if (!_guardado) return;
    _escribir((almacen) async {
      // El id se conoce cuando termina la escritura de esa foto (va antes).
      final id = _idsDeFotos.remove(foto.bytes);
      if (id != null) await almacen.quitarFoto(id);
    });
  }

  void fijarRelato({String? descripcion, String? lugar, String? ciudad}) {
    state = state.copyWith(
      descripcion: descripcion,
      lugar: lugar,
      ciudad: ciudad,
    );
    if (ref.read(cuentaReporteProvider) == null || !_guardado) return;
    _relatoPendiente?.cancel();
    _relatoPendiente = Timer(pausaRelato, _persistir);
  }

  /// Descarta el reporte en curso: lo borra del teléfono con sus fotos.
  Future<void> descartar() async {
    _relatoPendiente?.cancel();
    _relatoPendiente = null;
    final id = state.idReporte;
    if (_guardado) _escribir((almacen) => almacen.borrar(id));
    await _escrituras;
    if (ref.mounted) reiniciar();
  }

  /// M05-04. Reintentar usa el mismo `idReporte`: no duplica el caso ni vuelve
  /// a subir las fotos que ya subieron.
  Future<void> enviar() async {
    final s = state;
    if (!s.listoParaEnviar || s.envio is Enviando) return;
    _escribirRelatoYa();
    state = s.copyWith(envio: const Enviando());
    final r = await ref
        .read(reporteSiniestroRepositoryProvider)
        .reportar(
          ReporteSiniestro(
            idReporte: s.idReporte,
            poliza: s.poliza!,
            ocurridoEn: s.ocurridoEn!,
            descripcion: s.descripcion,
            lugar: s.lugar,
            ciudad: s.ciudad,
            ubicacion: s.ubicacion!,
            fotos: s.fotos,
            tipoAuto: s.tipoAuto,
          ),
        );
    if (!ref.mounted) return;
    switch (r) {
      // Enviado: las fotos ya no hacen falta, ni en memoria ni en el teléfono.
      case Exito(:final valor):
        state = state.copyWith(envio: Enviado(valor), fotos: const []);
        if (_guardado) {
          _guardado = false;
          _idsDeFotos.clear();
          _escribir((almacen) => almacen.borrar(s.idReporte));
        }
      case Fracaso(:final falla):
        state = state.copyWith(envio: EnvioFallido(falla));
    }
  }
}
