import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/almacen/base_local.dart';
import 'package:solventa_mobile/core/almacen/llave_almacen.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

void main() {
  late Directory carpeta;

  setUp(() {
    carpeta = Directory.systemTemp.createTempSync('solventa_base_');
    addTearDown(() => carpeta.deleteSync(recursive: true));
  });

  AbridorBaseLocal abridor(LlaveAlmacen llave) => AbridorBaseLocal(
    ambiente: 'prueba',
    llave: llave,
    carpeta: () async => carpeta,
  );

  File archivo() => File('${carpeta.path}/prueba.solventa.offline.db');

  Future<void> guardarCuenta(BaseLocal base, String nombre) =>
      base.customStatement(
        'INSERT INTO cuentas (id, nombre, verificada, activa, ultima_conexion) '
        'VALUES (?, ?, 1, 1, 0)',
        ['c1', nombre],
      );

  Future<List<String>> nombres(BaseLocal base) async => [
    for (final fila
        in await base.customSelect('SELECT nombre FROM cuentas').get())
      fila.read<String>('nombre'),
  ];

  test('la llave son 32 bytes al azar en hexadecimal', () async {
    final llave = LlaveAlmacenMemoria();
    expect(await llave.leer(), isNull);

    final creada = await llave.crear();

    expect(LlaveAlmacenSegura.esValida(creada), isTrue);
    expect(await llave.leer(), creada);
    expect(LlaveAlmacenSegura.esValida('abc'), isFalse);
  });

  test('el primer uso crea la base y la llave', () async {
    final llave = LlaveAlmacenMemoria();
    final a = abridor(llave);
    final base = a.abrir();
    addTearDown(base.close);

    await guardarCuenta(base, 'Ana María');

    expect(await a.apertura, AperturaBase.nueva);
    expect(await llave.leer(), isNotNull);
    expect(await nombres(base), ['Ana María']);
  });

  test('lo guardado queda cifrado en el disco', () async {
    final llave = LlaveAlmacenMemoria();
    final base = abridor(llave).abrir();
    await guardarCuenta(base, 'Ana María Restrepo');
    await base.close();

    final crudo = latin1.decode(archivo().readAsBytesSync());
    expect(crudo, isNot(contains('Ana María Restrepo')));
    expect(crudo, isNot(contains('SQLite format 3')));
    expect(crudo, isNot(contains('cuentas')));

    // Sin la llave no es una base legible.
    final sinLlave = sql.sqlite3.open(archivo().path);
    addTearDown(sinLlave.close);
    expect(
      () => sinLlave.select('SELECT count(*) FROM sqlite_master'),
      throwsA(isA<sql.SqliteException>()),
    );
  });

  test('al volver a abrir con la misma llave todo sigue ahí', () async {
    final llave = LlaveAlmacenMemoria();
    final primera = abridor(llave).abrir();
    await guardarCuenta(primera, 'Ana');
    await primera.close();

    final a = abridor(llave);
    final segunda = a.abrir();
    addTearDown(segunda.close);

    expect(await nombres(segunda), ['Ana']);
    expect(await a.apertura, AperturaBase.normal);
  });

  test('si se perdió la llave, empieza una base vacía y lo dice', () async {
    final primera = abridor(LlaveAlmacenMemoria()).abrir();
    await guardarCuenta(primera, 'Ana');
    await primera.close();

    // Otra instalación del Keystore: la llave anterior ya no existe.
    final a = abridor(LlaveAlmacenMemoria());
    final segunda = a.abrir();
    addTearDown(segunda.close);

    expect(await nombres(segunda), isEmpty);
    expect(await a.apertura, AperturaBase.reiniciada);
  });

  test('con el archivo dañado también se reinicia', () async {
    final llave = LlaveAlmacenMemoria();
    final primera = abridor(llave).abrir();
    await guardarCuenta(primera, 'Ana');
    await primera.close();
    archivo().writeAsBytesSync(List.filled(4096, 7));

    final a = abridor(llave);
    final segunda = a.abrir();
    addTearDown(segunda.close);

    expect(await nombres(segunda), isEmpty);
    expect(await a.apertura, AperturaBase.reiniciada);
  });

  test('sin disco disponible sigue en memoria, sin persistir', () async {
    final a = AbridorBaseLocal(
      ambiente: 'prueba',
      llave: LlaveAlmacenMemoria(),
      carpeta: () async => throw const FileSystemException('sin disco'),
    );
    final base = a.abrir();
    addTearDown(base.close);

    await guardarCuenta(base, 'Ana');

    expect(await a.apertura, AperturaBase.soloMemoria);
    expect(await nombres(base), ['Ana']);
  });

  test('borrar un reporte borra sus fotos', () async {
    final base = BaseLocal.enMemoria();
    addTearDown(base.close);
    await base.customStatement(
      "INSERT INTO reportes VALUES ('r1', 'c1', 'BORRADOR', 0, 0, '{}')",
    );
    await base.customStatement(
      'INSERT INTO fotos_reporte (reporte_id, orden, bytes, tamano, '
      "tipo_contenido, tomada_en) VALUES ('r1', 0, ?, 3, 'image/jpeg', 0)",
      [
        Uint8List.fromList([1, 2, 3]),
      ],
    );

    await base.customStatement("DELETE FROM reportes WHERE id = 'r1'");

    final fotos = await base.customSelect('SELECT id FROM fotos_reporte').get();
    expect(fotos, isEmpty);
  });
}
