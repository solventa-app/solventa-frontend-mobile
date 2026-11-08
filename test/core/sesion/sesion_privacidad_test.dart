import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solventa_mobile/core/log/sol_log.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/core/sesion/gestor_sesion.dart';
import 'package:solventa_mobile/core/sesion/llavero_sesion.dart';
import 'package:solventa_mobile/core/sesion/sesion_remota.dart';
import 'package:solventa_mobile/core/sesion/sesion_store.dart';

/// HU-M02 (OBJ-006, EC022): ningún token ni refresh llega a los logs (ni, por
/// lo tanto, a los breadcrumbs de Sentry) ni a `shared_preferences`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('los caminos de error de la sesión no registran secretos', () async {
    SolLog.limpiarHistorialPruebas();
    SharedPreferences.setMockInitialValues({});
    final remota = FakeSesionRemota(errorRed: const ErrorRed());
    final llavero = LlaveroSesionMemoria(conBloqueoPantalla: false);
    final gestor = GestorSesion(store: MemoriaSesionStore(), remota: remota);
    final sinBloqueo = GestorSesion(
      store: _StoreQueFalla(llavero),
      remota: remota,
    );

    await gestor.abrir(
      token: 'jwt-secreto',
      expiraEn: DateTime.utc(2026, 11, 6),
      refresh: 'refresh-secreto',
    );
    await gestor.renovar(); // sin red dos veces
    await gestor.cerrar(); // cerrarSesion falla por red
    await sinBloqueo.abrir(
      token: 'jwt-secreto-2',
      expiraEn: DateTime.utc(2026, 11, 6),
      refresh: 'refresh-secreto-2',
    );

    final todo = SolLog.historialPruebas.join('\n');
    expect(todo, isNotEmpty);
    for (final secreto in [
      'jwt-secreto',
      'refresh-secreto',
      'jwt-secreto-2',
      'refresh-secreto-2',
    ]) {
      expect(todo, isNot(contains(secreto)));
    }
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getKeys(), isEmpty);
    await gestor.dispose();
    await sinBloqueo.dispose();
  });
}

final class _StoreQueFalla implements SesionStore {
  _StoreQueFalla(this._llavero);
  final LlaveroSesion _llavero;

  @override
  Future<bool> hayRefresh() async => false;

  @override
  Future<DateTime?> refreshVenceEn() async => null;

  @override
  Future<void> guardarRefresh(String refresh, DateTime? venceEn) =>
      _llavero.crear();

  @override
  Future<String> leerRefresh() => throw const SinRefreshGuardado();

  @override
  Future<void> borrar() async {}
}
