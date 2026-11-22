import 'package:drift/drift.dart';

import 'base_local.dart';

/// La cuenta que entró en este teléfono: lo mínimo para saludar y saber si
/// puede reportar cuando no hay conexión. Sin correo ni documento.
final class CuentaLocal {
  const CuentaLocal({
    required this.id,
    required this.nombre,
    required this.verificada,
    required this.ultimaConexion,
  });

  final String id;

  /// Nombre para el saludo; vacío si la cuenta aún no lo tiene.
  final String nombre;

  /// Solo una cuenta verificada puede reportar un siniestro.
  final bool verificada;

  /// Última vez que la app habló con el servidor con esta cuenta.
  final DateTime ultimaConexion;
}

/// Copia de lo último que respondió el servidor, con la hora en que se guardó.
final class Copia {
  const Copia({required this.json, required this.guardadaEn});

  final String json;
  final DateTime guardadaEn;
}

/// Cuenta y copias del modo sin conexión (base cifrada).
abstract interface class AlmacenLocal {
  /// La cuenta con sesión guardada en este teléfono, si hay.
  Future<CuentaLocal?> cuentaActiva();

  /// Guarda [cuenta] como la activa; las demás dejan de serlo.
  Future<void> guardarCuenta(CuentaLocal cuenta);

  /// Cierre de sesión: ninguna cuenta queda activa y se borran el nombre y
  /// las copias. Los ids se conservan para saber de quién es cada reporte.
  Future<void> cerrarCuenta();

  /// Ids de las cuentas que no entran desde antes de [limite].
  Future<List<String>> cuentasSinEntrarDesde(DateTime limite);

  /// Olvida del todo la cuenta [id].
  Future<void> olvidarCuenta(String id);

  Future<Copia?> leerCopia(String cuentaId, String clave);

  Future<void> guardarCopia(
    String cuentaId,
    String clave,
    String json,
    DateTime guardadaEn,
  );
}

int _ms(DateTime t) => t.toUtc().millisecondsSinceEpoch;
DateTime _fecha(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

final class AlmacenLocalDrift implements AlmacenLocal {
  AlmacenLocalDrift(this._base);

  final BaseLocal _base;

  @override
  Future<CuentaLocal?> cuentaActiva() async {
    final fila = await _base
        .customSelect('SELECT * FROM cuentas WHERE activa = 1 LIMIT 1')
        .getSingleOrNull();
    if (fila == null) return null;
    return CuentaLocal(
      id: fila.read<String>('id'),
      nombre: fila.read<String>('nombre'),
      verificada: fila.read<int>('verificada') == 1,
      ultimaConexion: _fecha(fila.read<int>('ultima_conexion')),
    );
  }

  @override
  Future<void> guardarCuenta(CuentaLocal cuenta) => _base.transaction(() async {
    await _base.customStatement('UPDATE cuentas SET activa = 0');
    await _base.customStatement(
      'INSERT OR REPLACE INTO cuentas '
      '(id, nombre, verificada, activa, ultima_conexion) '
      'VALUES (?, ?, ?, 1, ?)',
      [
        cuenta.id,
        cuenta.nombre,
        cuenta.verificada ? 1 : 0,
        _ms(cuenta.ultimaConexion),
      ],
    );
  });

  @override
  Future<void> cerrarCuenta() => _base.transaction(() async {
    await _base.customStatement(
      "UPDATE cuentas SET activa = 0, nombre = '', verificada = 0",
    );
    await _base.customStatement('DELETE FROM copias');
  });

  @override
  Future<List<String>> cuentasSinEntrarDesde(DateTime limite) async => [
    for (final fila
        in await _base
            .customSelect(
              'SELECT id FROM cuentas '
              'WHERE activa = 0 AND ultima_conexion < ?',
              variables: [Variable<int>(_ms(limite))],
            )
            .get())
      fila.read<String>('id'),
  ];

  @override
  Future<void> olvidarCuenta(String id) => _base.transaction(() async {
    await _base.customStatement('DELETE FROM copias WHERE cuenta_id = ?', [id]);
    await _base.customStatement('DELETE FROM cuentas WHERE id = ?', [id]);
  });

  @override
  Future<Copia?> leerCopia(String cuentaId, String clave) async {
    final fila = await _base
        .customSelect(
          'SELECT json, guardada_en FROM copias '
          'WHERE cuenta_id = ? AND clave = ?',
          variables: [Variable<String>(cuentaId), Variable<String>(clave)],
        )
        .getSingleOrNull();
    if (fila == null) return null;
    return Copia(
      json: fila.read<String>('json'),
      guardadaEn: _fecha(fila.read<int>('guardada_en')),
    );
  }

  @override
  Future<void> guardarCopia(
    String cuentaId,
    String clave,
    String json,
    DateTime guardadaEn,
  ) => _base.customStatement(
    'INSERT OR REPLACE INTO copias (cuenta_id, clave, json, guardada_en) '
    'VALUES (?, ?, ?, ?)',
    [cuentaId, clave, json, _ms(guardadaEn)],
  );
}

/// En memoria: `API_ENV=mock` y pruebas. Se pierde al cerrar la app.
final class AlmacenLocalMemoria implements AlmacenLocal {
  final Map<String, CuentaLocal> _cuentas = {};
  final Map<(String, String), Copia> _copias = {};
  String? _activa;

  @override
  Future<CuentaLocal?> cuentaActiva() async => _cuentas[_activa];

  @override
  Future<void> guardarCuenta(CuentaLocal cuenta) async {
    _cuentas[cuenta.id] = cuenta;
    _activa = cuenta.id;
  }

  @override
  Future<void> cerrarCuenta() async {
    _activa = null;
    _cuentas.updateAll(
      (_, c) => CuentaLocal(
        id: c.id,
        nombre: '',
        verificada: false,
        ultimaConexion: c.ultimaConexion,
      ),
    );
    _copias.clear();
  }

  @override
  Future<List<String>> cuentasSinEntrarDesde(DateTime limite) async => [
    for (final c in _cuentas.values)
      if (c.id != _activa && c.ultimaConexion.isBefore(limite)) c.id,
  ];

  @override
  Future<void> olvidarCuenta(String id) async {
    _cuentas.remove(id);
    _copias.removeWhere((clave, _) => clave.$1 == id);
    if (_activa == id) _activa = null;
  }

  @override
  Future<Copia?> leerCopia(String cuentaId, String clave) async =>
      _copias[(cuentaId, clave)];

  @override
  Future<void> guardarCopia(
    String cuentaId,
    String clave,
    String json,
    DateTime guardadaEn,
  ) async {
    _copias[(cuentaId, clave)] = Copia(json: json, guardadaEn: guardadaEn);
  }
}
