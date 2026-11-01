import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/guardar_fallas.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';

void main() {
  group('fallaDesdeErrorCliente (docs/integracion-backend.md §4)', () {
    final casos = <ErrorCliente, Type>{
      const ErrorRed(): SinConexion,
      const ErrorTiempoRespuesta(): ServicioNoDisponible,
      const ErrorHttp(502): ServicioNoDisponible,
      const ErrorHttp(503): ServicioNoDisponible,
      const ErrorHttp(504): ServicioNoDisponible,
      const ErrorHttp(401): SesionVencida,
      const ErrorHttp(403): SinPermiso,
      const ErrorHttp(500): Inesperada,
      const ErrorGraphql([], codigo: 'SIN_SESION'): SesionVencida,
      const ErrorGraphql([], codigo: 'TOKEN_INVALIDO'): SesionVencida,
      const ErrorGraphql([], codigo: 'SIN_PERMISO'): SinPermiso,
      const ErrorGraphql(['Debes iniciar sesión.']): SesionVencida,
      const ErrorGraphql([
        'Tu sesión no es válida o venció. Inicia sesión de nuevo.',
      ]): SesionVencida,
      const ErrorGraphql(['No tienes permiso para esta operación.']):
          SinPermiso,
      const ErrorGraphql(['Unexpected error.']): Inesperada,
    };
    casos.forEach((error, esperado) {
      test('$error → $esperado', () {
        expect(fallaDesdeErrorCliente(error).runtimeType, esperado);
      });
    });
  });

  test('guardarFallas devuelve Exito con el valor', () async {
    final r = await guardarFallas(() async => 42);
    expect(r, isA<Exito<int>>().having((e) => e.valor, 'valor', 42));
  });

  test('guardarFallas convierte ErrorCliente en Fracaso', () async {
    final r = await guardarFallas<int>(() async => throw const ErrorRed());
    expect(
      r,
      isA<Fracaso<int>>().having((f) => f.falla, 'falla', isA<SinConexion>()),
    );
  });

  test('una respuesta que no cumple el contrato es Inesperada', () async {
    final r = await guardarFallas<int>(() async => throw TypeError());
    expect(
      r,
      isA<Fracaso<int>>().having((f) => f.falla, 'falla', isA<Inesperada>()),
    );
  });
}
