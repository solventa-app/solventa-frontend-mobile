import '../../../../core/errors/resultado.dart';
import '../../domain/entities/verificacion_identidad.dart';
import '../../domain/repositories/verificacion_repository.dart';

/// Fake de la verificación KYC/AML. El desenlace lo eligen los disparadores
/// de demo de M01-05 (solo debug); por defecto la identidad queda verificada.
final class FakeVerificacionRepository implements VerificacionRepository {
  FakeVerificacionRepository({
    this.latencia = const Duration(milliseconds: 1500),
  });

  final Duration latencia;

  /// Desenlace de la próxima verificación.
  EstadoVerificacion escenario = EstadoVerificacion.verificada;

  @override
  Future<Resultado<EstadoVerificacion>> verificar() async {
    await Future<void>.delayed(latencia);
    return Exito(escenario);
  }
}
