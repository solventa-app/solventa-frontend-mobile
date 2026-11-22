import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/app/router.dart';
import 'package:solventa_mobile/features/acceso/presentation/acceso_notifier.dart';

void main() {
  group('redirigirRuta (push de HU-M04)', () {
    test('sin sesión abierta guarda la ruta del push y vuelve al inicio', () {
      String? pendiente;
      final destino = redirigirRuta(
        '/m04-02/abc',
        fase: () => FaseAcceso.normal,
        sesionAbierta: () => false,
        guardarPendiente: (r) => pendiente = r,
      );
      expect(destino, '/');
      expect(pendiente, '/m04-02/abc');
    });

    test(
      'con la sesión guardada pero bloqueada guarda la ruta y desbloquea',
      () {
        String? pendiente;
        final destino = redirigirRuta(
          '/m04-02/abc',
          fase: () => FaseAcceso.bloqueada,
          sesionAbierta: () => true,
          guardarPendiente: (r) => pendiente = r,
        );
        expect(destino, isNot('/m04-02/abc'));
        expect(pendiente, '/m04-02/abc');
      },
    );

    test('con sesión abierta y desbloqueada entra directo', () {
      String? pendiente;
      final destino = redirigirRuta(
        '/m04-02/abc',
        fase: () => FaseAcceso.normal,
        sesionAbierta: () => true,
        guardarPendiente: (r) => pendiente = r,
      );
      expect(destino, isNull);
      expect(pendiente, isNull);
    });

    test('una ruta que no es del push no se guarda', () {
      String? pendiente;
      redirigirRuta(
        '/perfil',
        fase: () => FaseAcceso.bloqueada,
        sesionAbierta: () => true,
        guardarPendiente: (r) => pendiente = r,
      );
      expect(pendiente, isNull);
    });
  });

  group('redirigirRuta sin conexión (HU-M05)', () {
    String? ir(String ruta, {void Function(String)? guardar}) => redirigirRuta(
      ruta,
      fase: () => FaseAcceso.sinConexion,
      sesionAbierta: () => true,
      guardarPendiente: guardar,
    );

    test('deja pasar el inicio, el reporte, «Mis siniestros» y Mi perfil', () {
      for (final ruta in [
        '/',
        '/perfil',
        '/siniestro',
        '/siniestro/fotos',
        '/siniestros',
        '/siniestros/local/r1',
      ]) {
        expect(ir(ruta), isNull, reason: ruta);
      }
    });

    test('lo que necesita al servidor vuelve al inicio', () {
      for (final ruta in [
        '/asistencia',
        '/m04-04',
        '/m04-02/abc',
        '/onboarding/frente',
        '/siniestrosx',
      ]) {
        expect(ir(ruta), '/', reason: ruta);
      }
    });

    test('la ruta de un push se guarda para cuando vuelva la sesión', () {
      String? pendiente;
      expect(ir('/m04-02/abc', guardar: (r) => pendiente = r), '/');
      expect(pendiente, '/m04-02/abc');
    });

    test('rutaPermitidaSinConexion no acepta prefijos parecidos', () {
      expect(rutaPermitidaSinConexion('/siniestro'), isTrue);
      expect(rutaPermitidaSinConexion('/siniestro/relato'), isTrue);
      expect(rutaPermitidaSinConexion('/siniestros/abc'), isTrue);
      expect(rutaPermitidaSinConexion('/perfil/editar'), isFalse);
      expect(rutaPermitidaSinConexion('/siniestralidad'), isFalse);
    });
  });
}
