import 'dart:async';
import 'dart:typed_data';

import '../../../../core/ubicacion/coordenada.dart';
import '../../domain/entities/reporte_guardado.dart';
import '../../domain/repositories/almacen_reportes.dart';

/// Reportes en memoria: `API_ENV=mock` y pruebas. Se comporta igual que la
/// base cifrada, pero se pierde al cerrar la app.
final class AlmacenReportesMemoria implements AlmacenReportes {
  final Map<String, ReporteGuardado> _reportes = {};
  final Map<int, Uint8List?> _bytes = {};
  final _cambios = StreamController<void>.broadcast();
  int _siguienteFoto = 1;

  /// Para pruebas: mientras esté puesta, toda escritura falla (disco lleno,
  /// base dañada).
  Object? fallaAlEscribir;

  @override
  Stream<void> get cambios => _cambios.stream;

  void _avisar() {
    if (!_cambios.isClosed) _cambios.add(null);
  }

  void _revisarFalla() {
    final falla = fallaAlEscribir;
    if (falla != null) throw falla;
  }

  @override
  Future<List<ReporteGuardado>> deCuenta(String cuentaId) async =>
      _reportes.values.where((r) => r.cuentaId == cuentaId).toList()
        ..sort((a, b) => a.creadoEn.compareTo(b.creadoEn));

  @override
  Future<ReporteGuardado?> leer(String id) async => _reportes[id];

  @override
  Future<void> guardar(ReporteGuardado reporte) async {
    _revisarFalla();
    // Las fotos tienen su propia vida: se conservan las ya guardadas.
    _reportes[reporte.id] = reporte.copyWith(
      fotos: _reportes[reporte.id]?.fotos ?? const [],
    );
    _avisar();
  }

  @override
  Future<ReporteGuardado?> actualizar(
    String id,
    ReporteGuardado Function(ReporteGuardado actual) cambio,
  ) async {
    _revisarFalla();
    final actual = _reportes[id];
    if (actual == null) return null;
    final nuevo = cambio(actual).copyWith(fotos: actual.fotos);
    _reportes[id] = nuevo;
    _avisar();
    return nuevo;
  }

  void _cambiarFotos(
    String idReporte,
    List<FotoGuardada> Function(List<FotoGuardada>) cambio,
  ) {
    final r = _reportes[idReporte];
    if (r == null) return;
    _reportes[idReporte] = r.copyWith(fotos: cambio(r.fotos));
  }

  @override
  Future<FotoGuardada> agregarFoto(
    String idReporte, {
    required Uint8List bytes,
    required String tipoContenido,
    required DateTime tomadaEn,
    Coordenada? ubicacion,
    bool deDireccion = false,
  }) async {
    _revisarFalla();
    final actuales = _reportes[idReporte]?.fotos ?? const <FotoGuardada>[];
    final foto = FotoGuardada(
      id: _siguienteFoto++,
      orden: actuales.isEmpty ? 0 : actuales.last.orden + 1,
      tamano: bytes.length,
      tipoContenido: tipoContenido,
      tomadaEn: tomadaEn.toUtc(),
      ubicacion: ubicacion,
      deDireccion: deDireccion,
    );
    _bytes[foto.id] = bytes;
    _cambiarFotos(idReporte, (f) => [...f, foto]);
    _avisar();
    return foto;
  }

  @override
  Future<void> quitarFoto(int idFoto) async {
    _bytes.remove(idFoto);
    for (final id in _reportes.keys.toList()) {
      _cambiarFotos(id, (f) => f.where((x) => x.id != idFoto).toList());
    }
    _avisar();
  }

  @override
  Future<void> ubicarFotosSinGps(String idReporte, Coordenada punto) async {
    _cambiarFotos(
      idReporte,
      (fotos) => [
        for (final f in fotos)
          f.ubicacion == null || f.deDireccion
              ? f.copyWith(ubicacion: punto, deDireccion: true)
              : f,
      ],
    );
    _avisar();
  }

  @override
  Future<Uint8List?> bytesDeFoto(int idFoto) async => _bytes[idFoto];

  @override
  Future<void> marcarFotoSubida(int idFoto, String archivoId) async {
    _revisarFalla();
    for (final id in _reportes.keys.toList()) {
      _cambiarFotos(
        id,
        (fotos) => [
          for (final f in fotos)
            f.id == idFoto ? f.copyWith(archivoId: () => archivoId) : f,
        ],
      );
    }
    _avisar();
  }

  @override
  Future<void> olvidarSubidas(String idReporte) async {
    _cambiarFotos(
      idReporte,
      (fotos) => [for (final f in fotos) f.copyWith(archivoId: () => null)],
    );
    _avisar();
  }

  @override
  Future<void> borrarBytesDeFotos(String idReporte) async {
    for (final f in _reportes[idReporte]?.fotos ?? const <FotoGuardada>[]) {
      _bytes[f.id] = null;
    }
    _avisar();
  }

  @override
  Future<void> borrar(String id) async {
    final r = _reportes.remove(id);
    for (final f in r?.fotos ?? const <FotoGuardada>[]) {
      _bytes.remove(f.id);
    }
    _avisar();
  }

  @override
  Future<void> borrarDeCuenta(String cuentaId) async {
    final ids = [
      for (final r in _reportes.values)
        if (r.cuentaId == cuentaId) r.id,
    ];
    for (final id in ids) {
      await borrar(id);
    }
  }

  @override
  void cerrar() => unawaited(_cambios.close());
}
