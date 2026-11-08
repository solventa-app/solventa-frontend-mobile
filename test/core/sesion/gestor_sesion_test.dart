import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/log/sol_log.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';

/// Remota programable: cada llamada a `renovar` toma la siguiente respuesta
/// (una [Renovacion] o una excepción para lanzar).
final class _Remota implements SesionRemota {
  final respuestas = <Object>[];
  final usados = <String>[];
  final cerrados = <String>[];
  Object? errorAlCerrar;
  Completer<void>? pausa;

  @override
  Future<Renovacion> renovar(String refresh) async {
    usados.add(refresh);
    await pausa?.future;
    final r = respuestas.removeAt(0);
    if (r is Renovacion) return r;
    throw r;
  }

  @override
  Future<void> cerrar(String refresh) async {
    cerrados.add(refresh);
    final e = errorAlCerrar;
    if (e != null) throw e;
  }
}

RenovacionExitosa _par(int n) => RenovacionExitosa(
  token: 'jwt-$n',
  expiraEn: DateTime.utc(2026, 11, 6, 12),
  refresh: 'refresh-$n',
  refreshVenceEn: DateTime.utc(2026, 11, 14),
);

/// HU-M02 (F5, F7 y mitigación del riesgo 5): el gestor de la sesión.
void main() {
  late MemoriaSesionStore store;
  late _Remota remota;
  late GestorSesion gestor;
  late List<EventoSesion> eventos;

  setUp(() {
    store = MemoriaSesionStore();
    remota = _Remota();
    gestor = GestorSesion(
      store: store,
      remota: remota,
      reloj: () => DateTime.utc(2026, 11, 6),
    );
    eventos = [];
    gestor.eventos.listen(eventos.add);
  });

  tearDown(() => gestor.dispose());

  Future<void> abrir() => gestor.abrir(
    token: 'jwt-0',
    expiraEn: DateTime.utc(2026, 11, 6, 1),
    refresh: 'refresh-0',
    refreshVenceEn: DateTime.utc(2026, 11, 14),
  );

  test('abrir deja el JWT en memoria y guarda solo el refresh', () async {
    await abrir();

    expect(gestor.token, 'jwt-0');
    expect(gestor.abierta, isTrue);
    expect(gestor.refreshPersistido, isTrue);
    expect(await store.leerRefresh(), 'refresh-0');
  });

  test('renovar rota y guarda el refresh nuevo', () async {
    await abrir();
    remota.respuestas.add(_par(1));

    expect(await gestor.renovar(), ResultadoRenovar.renovada);
    expect(gestor.token, 'jwt-1');
    expect(await store.leerRefresh(), 'refresh-1');
    expect(remota.usados, ['refresh-0']);
  });

  test('dos renovaciones a la vez hacen una sola llamada', () async {
    await abrir();
    remota
      ..pausa = Completer<void>()
      ..respuestas.add(_par(1));

    final a = gestor.renovar();
    final b = gestor.renovar();
    remota.pausa!.complete();

    expect(await Future.wait([a, b]), [
      ResultadoRenovar.renovada,
      ResultadoRenovar.renovada,
    ]);
    expect(remota.usados, ['refresh-0']);
  });

  test(
    'con falla de red reintenta una vez con el mismo refresh (gracia)',
    () async {
      await abrir();
      remota.respuestas.addAll([const ErrorRed(), _par(1)]);

      expect(await gestor.renovar(), ResultadoRenovar.renovada);
      expect(remota.usados, ['refresh-0', 'refresh-0']);
      expect(await store.leerRefresh(), 'refresh-1');
    },
  );

  test('sin red tras el reintento conserva todo y no avisa', () async {
    await abrir();
    remota.respuestas.addAll([
      const ErrorTiempoRespuesta(),
      const ErrorHttp(503),
    ]);

    expect(await gestor.renovar(), ResultadoRenovar.sinRed);
    expect(gestor.token, 'jwt-0');
    expect(await store.leerRefresh(), 'refresh-0');
    expect(eventos, isEmpty);
  });

  test('SESION_VENCIDA borra todo y avisa', () async {
    await abrir();
    remota.respuestas.add(const RenovacionRechazada());

    expect(await gestor.renovar(), ResultadoRenovar.vencida);
    await pumpEventQueue();
    expect(gestor.token, isNull);
    expect(await store.hayRefresh(), isFalse);
    expect(eventos.single, isA<SesionVencidaEvento>());
  });

  test('sin refresh en memoria no llama al backend', () async {
    expect(await gestor.renovar(), ResultadoRenovar.sinSesion);
    expect(remota.usados, isEmpty);
  });

  test('actualizarToken cambia el JWT y conserva el refresh', () async {
    await abrir();

    gestor.actualizarToken('jwt-verificado', DateTime.utc(2026, 11, 6, 2));

    expect(gestor.token, 'jwt-verificado');
    expect(await store.leerRefresh(), 'refresh-0');
  });

  group('desbloquear', () {
    test('descifra el refresh guardado y renueva', () async {
      await store.guardarRefresh('refresh-0', null);
      remota.respuestas.add(_par(1));

      expect(await gestor.desbloquear(), isA<Desbloqueada>());
      expect(gestor.token, 'jwt-1');
      expect(remota.usados, ['refresh-0']);
    });

    test('sin autenticación válida pide otra (PIN del teléfono)', () async {
      final llavero = LlaveroSesionMemoria(exigeAutenticacion: true);
      final segura = _StoreConLlavero(llavero);
      final g = GestorSesion(store: segura, remota: remota);
      await segura.guardarRefresh('refresh-0', null);

      expect(await g.desbloquear(), isA<FaltaAutenticacion>());
      expect(remota.usados, isEmpty);
    });

    test('llave invalidada: sesión vencida y se borra lo guardado', () async {
      final llavero = LlaveroSesionMemoria();
      final segura = _StoreConLlavero(llavero);
      final g = GestorSesion(store: segura, remota: remota);
      await segura.guardarRefresh('refresh-0', null);
      llavero.invalidar();

      expect(await g.desbloquear(), isA<DesbloqueoVencido>());
      expect(await segura.hayRefresh(), isFalse);
    });

    test('sin red: conserva el refresh guardado', () async {
      await store.guardarRefresh('refresh-0', null);
      remota.respuestas.addAll([const ErrorRed(), const ErrorRed()]);

      expect(await gestor.desbloquear(), isA<DesbloqueoSinRed>());
      expect(await store.leerRefresh(), 'refresh-0');
    });

    test('sin nada guardado: vencido', () async {
      expect(await gestor.desbloquear(), isA<DesbloqueoVencido>());
    });
  });

  test('hayRefreshVigente descarta un refresh vencido', () async {
    await store.guardarRefresh('refresh-0', DateTime.utc(2026, 11, 5));

    expect(await gestor.hayRefreshVigente(), isFalse);
    expect(await store.hayRefresh(), isFalse);
  });

  test('hayRefreshVigente con refresh por vencer', () async {
    await store.guardarRefresh('refresh-0', DateTime.utc(2026, 11, 14));

    expect(await gestor.hayRefreshVigente(), isTrue);
  });

  test('cerrar revoca en el backend y borra aunque la red falle', () async {
    await abrir();
    remota.errorAlCerrar = const ErrorRed();

    await gestor.cerrar();

    expect(remota.cerrados, ['refresh-0']);
    expect(gestor.token, isNull);
    expect(await store.hayRefresh(), isFalse);
  });

  test('cerrar y vencer olvidan el código de soporte de Sentry', () async {
    await abrir();
    SolLog.obtenerCodigoSoporte();
    expect(SolLog.codigoSoporteActual, isNotNull);
    await gestor.cerrar();
    expect(SolLog.codigoSoporteActual, isNull);

    await abrir();
    SolLog.obtenerCodigoSoporte();
    remota.respuestas.add(const RenovacionRechazada());
    expect(await gestor.renovar(), ResultadoRenovar.vencida);
    expect(SolLog.codigoSoporteActual, isNull);
  });

  test('bloquear olvida lo de memoria y conserva lo guardado', () async {
    await abrir();

    gestor.bloquear();

    expect(gestor.token, isNull);
    expect(gestor.abierta, isFalse);
    expect(await store.leerRefresh(), 'refresh-0');
  });

  test('sin bloqueo de pantalla la sesión queda solo en memoria', () async {
    final llavero = LlaveroSesionMemoria(conBloqueoPantalla: false);
    final segura = _StoreConLlavero(llavero);
    final g = GestorSesion(store: segura, remota: remota);

    await g.abrir(
      token: 'jwt-0',
      expiraEn: DateTime.utc(2026, 11, 6, 1),
      refresh: 'refresh-0',
    );

    expect(g.token, 'jwt-0');
    expect(g.refreshPersistido, isFalse);
    expect(await segura.hayRefresh(), isFalse);
    // Activó el bloqueo de pantalla (M01-08): se guarda al reintentar.
    llavero.conBloqueoPantalla = true;
    expect(await g.asegurarPersistencia(), isTrue);
    expect(await segura.hayRefresh(), isTrue);
  });
}

/// Almacén en memoria que cifra con un [LlaveroSesion], para probar el
/// gestor con las fallas del llavero sin `flutter_secure_storage`.
final class _StoreConLlavero implements SesionStore {
  _StoreConLlavero(this._llavero);

  final LlaveroSesion _llavero;
  String? _cifrado;

  @override
  Future<bool> hayRefresh() async => _cifrado != null;

  @override
  Future<DateTime?> refreshVenceEn() async => null;

  @override
  Future<void> guardarRefresh(String refresh, DateTime? venceEn) async {
    if (!await _llavero.existe()) await _llavero.crear();
    _cifrado = await _llavero.cifrar(refresh);
  }

  @override
  Future<String> leerRefresh() async {
    final c = _cifrado;
    if (c == null) throw const SinRefreshGuardado();
    return _llavero.descifrar(c);
  }

  @override
  Future<void> borrar() async {
    _cifrado = null;
    await _llavero.borrar();
  }
}
