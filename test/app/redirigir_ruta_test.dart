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
}
