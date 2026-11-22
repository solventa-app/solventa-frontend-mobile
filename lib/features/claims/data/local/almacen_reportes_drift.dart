import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../core/almacen/base_local.dart';
import '../../../../core/ubicacion/coordenada.dart';
import '../../domain/entities/reporte_guardado.dart';
import '../../domain/repositories/almacen_reportes.dart';
import 'reporte_local_mapper.dart';

int _ms(DateTime t) => t.toUtc().millisecondsSinceEpoch;
DateTime _fecha(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

/// Reportes en la base cifrada. Las fotos van como BLOB en la misma base: un
/// solo cifrado, guardado atómico con el reporte y sin archivos sueltos.
final class AlmacenReportesDrift implements AlmacenReportes {
  AlmacenReportesDrift(this._base);

  final BaseLocal _base;
  final _cambios = StreamController<void>.broadcast();

  static const _columnasFoto =
      'id, reporte_id, orden, tamano, tipo_contenido, tomada_en, latitud, '
      'longitud, de_direccion, archivo_id';

  @override
  Stream<void> get cambios => _cambios.stream;

  void _avisar() {
    if (!_cambios.isClosed) _cambios.add(null);
  }

  FotoGuardada _foto(QueryRow f) {
    final latitud = f.readNullable<double>('latitud');
    final longitud = f.readNullable<double>('longitud');
    return FotoGuardada(
      id: f.read<int>('id'),
      orden: f.read<int>('orden'),
      tamano: f.read<int>('tamano'),
      tipoContenido: f.read<String>('tipo_contenido'),
      tomadaEn: _fecha(f.read<int>('tomada_en')),
      ubicacion: latitud != null && longitud != null
          ? Coordenada(latitud, longitud)
          : null,
      deDireccion: f.read<int>('de_direccion') == 1,
      archivoId: f.readNullable<String>('archivo_id'),
    );
  }

  ReporteGuardado _reporte(QueryRow r, List<FotoGuardada> fotos) =>
      reporteDesdeDatos(
        id: r.read<String>('id'),
        cuentaId: r.read<String>('cuenta_id'),
        estado: r.read<String>('estado'),
        creadoEn: _fecha(r.read<int>('creado_en')),
        actualizadoEn: _fecha(r.read<int>('actualizado_en')),
        datos: r.read<String>('datos'),
        fotos: fotos,
      );

  Future<List<FotoGuardada>> _fotosDe(String idReporte) async => [
    for (final f
        in await _base
            .customSelect(
              'SELECT $_columnasFoto FROM fotos_reporte '
              'WHERE reporte_id = ? ORDER BY orden, id',
              variables: [Variable<String>(idReporte)],
            )
            .get())
      _foto(f),
  ];

  @override
  Future<List<ReporteGuardado>> deCuenta(String cuentaId) async {
    final filas = await _base
        .customSelect(
          'SELECT * FROM reportes WHERE cuenta_id = ? ORDER BY creado_en, id',
          variables: [Variable<String>(cuentaId)],
        )
        .get();
    return [
      for (final r in filas) _reporte(r, await _fotosDe(r.read<String>('id'))),
    ];
  }

  @override
  Future<ReporteGuardado?> leer(String id) async {
    final fila = await _base
        .customSelect(
          'SELECT * FROM reportes WHERE id = ?',
          variables: [Variable<String>(id)],
        )
        .getSingleOrNull();
    return fila == null ? null : _reporte(fila, await _fotosDe(id));
  }

  Future<void> _escribir(ReporteGuardado r) => _base.customStatement(
    'INSERT INTO reportes '
    '(id, cuenta_id, estado, creado_en, actualizado_en, datos) '
    'VALUES (?, ?, ?, ?, ?, ?) '
    'ON CONFLICT (id) DO UPDATE SET cuenta_id = excluded.cuenta_id, '
    'estado = excluded.estado, actualizado_en = excluded.actualizado_en, '
    'datos = excluded.datos',
    [
      r.id,
      r.cuentaId,
      r.estado.codigo,
      _ms(r.creadoEn),
      _ms(r.actualizadoEn),
      datosDeReporteAJson(r),
    ],
  );

  @override
  Future<void> guardar(ReporteGuardado reporte) async {
    await _escribir(reporte);
    _avisar();
  }

  @override
  Future<ReporteGuardado?> actualizar(
    String id,
    ReporteGuardado Function(ReporteGuardado actual) cambio,
  ) async {
    final nuevo = await _base.transaction(() async {
      final actual = await leer(id);
      if (actual == null) return null;
      final cambiado = cambio(actual);
      await _escribir(cambiado);
      return cambiado;
    });
    if (nuevo != null) _avisar();
    return nuevo;
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
    final foto = await _base.transaction(() async {
      final orden = await _base
          .customSelect(
            'SELECT COALESCE(MAX(orden), -1) + 1 AS siguiente '
            'FROM fotos_reporte WHERE reporte_id = ?',
            variables: [Variable<String>(idReporte)],
          )
          .getSingle();
      final id = await _base.customInsert(
        'INSERT INTO fotos_reporte (reporte_id, orden, bytes, tamano, '
        'tipo_contenido, tomada_en, latitud, longitud, de_direccion) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        variables: [
          Variable<String>(idReporte),
          Variable<int>(orden.read<int>('siguiente')),
          Variable<Uint8List>(bytes),
          Variable<int>(bytes.length),
          Variable<String>(tipoContenido),
          Variable<int>(_ms(tomadaEn)),
          Variable<double>(ubicacion?.latitud),
          Variable<double>(ubicacion?.longitud),
          Variable<int>(deDireccion ? 1 : 0),
        ],
      );
      return FotoGuardada(
        id: id,
        orden: orden.read<int>('siguiente'),
        tamano: bytes.length,
        tipoContenido: tipoContenido,
        tomadaEn: tomadaEn.toUtc(),
        ubicacion: ubicacion,
        deDireccion: deDireccion,
      );
    });
    _avisar();
    return foto;
  }

  @override
  Future<void> quitarFoto(int idFoto) async {
    await _base.customStatement('DELETE FROM fotos_reporte WHERE id = ?', [
      idFoto,
    ]);
    _avisar();
  }

  @override
  Future<void> ubicarFotosSinGps(String idReporte, Coordenada punto) async {
    await _base.customStatement(
      'UPDATE fotos_reporte SET latitud = ?, longitud = ?, de_direccion = 1 '
      'WHERE reporte_id = ? AND (latitud IS NULL OR de_direccion = 1)',
      [punto.latitud, punto.longitud, idReporte],
    );
    _avisar();
  }

  @override
  Future<Uint8List?> bytesDeFoto(int idFoto) async {
    final fila = await _base
        .customSelect(
          'SELECT bytes FROM fotos_reporte WHERE id = ?',
          variables: [Variable<int>(idFoto)],
        )
        .getSingleOrNull();
    return fila?.readNullable<Uint8List>('bytes');
  }

  @override
  Future<void> marcarFotoSubida(int idFoto, String archivoId) async {
    await _base.customStatement(
      'UPDATE fotos_reporte SET archivo_id = ? WHERE id = ?',
      [archivoId, idFoto],
    );
    _avisar();
  }

  @override
  Future<void> olvidarSubidas(String idReporte) async {
    await _base.customStatement(
      'UPDATE fotos_reporte SET archivo_id = NULL WHERE reporte_id = ?',
      [idReporte],
    );
    _avisar();
  }

  @override
  Future<void> borrarBytesDeFotos(String idReporte) async {
    await _base.customStatement(
      'UPDATE fotos_reporte SET bytes = NULL WHERE reporte_id = ?',
      [idReporte],
    );
    _avisar();
  }

  @override
  Future<void> borrar(String id) async {
    await _base.customStatement('DELETE FROM reportes WHERE id = ?', [id]);
    _avisar();
  }

  @override
  Future<void> borrarDeCuenta(String cuentaId) async {
    await _base.customStatement('DELETE FROM reportes WHERE cuenta_id = ?', [
      cuentaId,
    ]);
    _avisar();
  }

  @override
  void cerrar() => unawaited(_cambios.close());
}
