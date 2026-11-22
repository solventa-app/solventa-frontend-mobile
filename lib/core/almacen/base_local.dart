import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import '../log/sol_log.dart';
import 'llave_almacen.dart';

/// Base local cifrada del modo sin conexión (HU-M05, `docs/arquitectura.md`
/// §8): reportes por enviar con sus fotos, la cuenta que entró y las copias de
/// lo último que respondió el servidor.
///
/// SQLite cifrado (SQLite3 Multiple Ciphers, ChaCha20) con una llave del
/// Keystore. Ningún dato personal queda en disco sin cifrar. El esquema se
/// escribe a mano en SQL: son cinco tablas y así no hay código generado.
final class BaseLocal extends GeneratedDatabase {
  BaseLocal(super.executor, {this.exigirCifrado = true});

  /// En memoria y sin llave, para pruebas.
  BaseLocal.enMemoria()
    : exigirCifrado = false,
      super(NativeDatabase.memory(setup: _ajustes));

  /// Si la librería nativa no cifra, la base no se usa.
  final bool exigirCifrado;

  static const version = 1;

  @override
  int get schemaVersion => version;

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (_) async {
      for (final sentencia in _esquemaV1) {
        await customStatement(sentencia);
      }
    },
    onUpgrade: (_, desde, hasta) async {
      // Cada versión nueva agrega aquí su paso (`if (desde < 2) …`).
    },
    beforeOpen: (_) async {
      if (!exigirCifrado) return;
      final filas = await customSelect('PRAGMA cipher').get();
      if (filas.isEmpty) {
        throw StateError('La base local no está cifrada');
      }
    },
  );

  static const _esquemaV1 = [
    '''
    CREATE TABLE cuentas (
      id TEXT NOT NULL PRIMARY KEY,
      nombre TEXT NOT NULL,
      verificada INTEGER NOT NULL,
      activa INTEGER NOT NULL,
      ultima_conexion INTEGER NOT NULL
    )''',
    '''
    CREATE TABLE copias (
      cuenta_id TEXT NOT NULL,
      clave TEXT NOT NULL,
      json TEXT NOT NULL,
      guardada_en INTEGER NOT NULL,
      PRIMARY KEY (cuenta_id, clave)
    )''',
    '''
    CREATE TABLE reportes (
      id TEXT NOT NULL PRIMARY KEY,
      cuenta_id TEXT NOT NULL,
      estado TEXT NOT NULL,
      creado_en INTEGER NOT NULL,
      actualizado_en INTEGER NOT NULL,
      datos TEXT NOT NULL
    )''',
    'CREATE INDEX reportes_por_cuenta ON reportes (cuenta_id, creado_en)',
    '''
    CREATE TABLE fotos_reporte (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      reporte_id TEXT NOT NULL REFERENCES reportes (id) ON DELETE CASCADE,
      orden INTEGER NOT NULL,
      bytes BLOB,
      tamano INTEGER NOT NULL,
      tipo_contenido TEXT NOT NULL,
      tomada_en INTEGER NOT NULL,
      latitud REAL,
      longitud REAL,
      de_direccion INTEGER NOT NULL DEFAULT 0,
      archivo_id TEXT
    )''',
    'CREATE INDEX fotos_por_reporte ON fotos_reporte (reporte_id, orden)',
  ];

  static void _ajustes(sql.Database base) {
    base.execute('PRAGMA foreign_keys = ON');
  }

  /// Abre el archivo [ruta] con [llave] (64 hexadecimales) en un isolate
  /// aparte: guardar una foto de varios MB no traba la pantalla.
  static QueryExecutor ejecutorCifrado(File archivo, String llave) =>
      NativeDatabase.createInBackground(
        archivo,
        setup: (base) => _conLlave(base, llave),
      );

  static void _conLlave(sql.Database base, String llave) {
    // Llave cruda: ya son 32 bytes al azar, no hace falta derivarla.
    base.execute("PRAGMA key = 'raw:$llave'");
    _ajustes(base);
  }

  /// `true` si [archivo] se puede leer con [llave]. Corre en otro isolate.
  static Future<bool> sePuedeAbrir(File archivo, String llave) {
    final ruta = archivo.path;
    return Isolate.run(() {
      sql.Database? base;
      try {
        base = sql.sqlite3.open(ruta);
        base.execute("PRAGMA key = 'raw:$llave'");
        base.select('SELECT count(*) FROM sqlite_master');
        return true;
      } on Object {
        return false;
      } finally {
        base?.close();
      }
    });
  }
}

/// Qué pasó al abrir la base local.
enum AperturaBase {
  /// Se abrió la base de siempre.
  normal,

  /// No existía: es el primer uso en este teléfono.
  nueva,

  /// La anterior no se pudo leer (llave perdida o archivo dañado) y se empezó
  /// una vacía. Lo que estaba guardado sin enviar se perdió: se avisa una vez.
  reiniciada,

  /// No se pudo usar el disco: lo guardado dura solo hasta cerrar la app.
  soloMemoria,
}

/// Abre la base cifrada del ambiente y decide qué hacer si no se puede leer.
final class AbridorBaseLocal {
  AbridorBaseLocal({
    required this.ambiente,
    required this.llave,
    Future<Directory> Function()? carpeta,
  }) : _carpeta = carpeta ?? getApplicationSupportDirectory;

  final String ambiente;
  final LlaveAlmacen llave;
  final Future<Directory> Function() _carpeta;

  final _apertura = Completer<AperturaBase>();

  /// Cómo terminó la apertura (se completa al primer uso de la base).
  Future<AperturaBase> get apertura => _apertura.future;

  String get nombreArchivo => '$ambiente.solventa.offline.db';

  /// La base se abre de verdad en la primera consulta.
  BaseLocal abrir() => BaseLocal(LazyDatabase(_ejecutor));

  Future<QueryExecutor> _ejecutor() async {
    try {
      final carpeta = await _carpeta();
      final archivo = File(p.join(carpeta.path, nombreArchivo));
      var llave = await this.llave.leer();
      var resultado = AperturaBase.normal;

      if (!archivo.existsSync()) {
        llave ??= await this.llave.crear();
        resultado = AperturaBase.nueva;
      } else if (llave == null ||
          !await BaseLocal.sePuedeAbrir(archivo, llave)) {
        // Sin la llave del Keystore (o con el archivo dañado) lo guardado ya
        // no se puede leer: se empieza de cero y se avisa.
        SolLog.severe('Base local ilegible: se reinicia', codigo: 'BASE_LOCAL');
        _borrar(archivo);
        llave = await this.llave.crear();
        resultado = AperturaBase.reiniciada;
      }
      _apertura.complete(resultado);
      return BaseLocal.ejecutorCifrado(archivo, llave);
    } on Object catch (e) {
      // Keystore o disco no disponibles: la app sigue, sin persistir.
      SolLog.severe(
        'Base local no disponible: solo memoria',
        codigo: e.runtimeType.toString(),
      );
      if (!_apertura.isCompleted) _apertura.complete(AperturaBase.soloMemoria);
      return NativeDatabase.memory(
        setup: (base) => base.execute('PRAGMA foreign_keys = ON'),
      );
    }
  }

  static void _borrar(File archivo) {
    for (final sufijo in const ['', '-wal', '-shm', '-journal']) {
      final f = File('${archivo.path}$sufijo');
      if (f.existsSync()) f.deleteSync();
    }
  }
}
