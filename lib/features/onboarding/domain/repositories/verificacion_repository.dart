import '../../../../core/errors/resultado.dart';
import '../entities/verificacion_identidad.dart';

/// Verificación de identidad con el proveedor KYC/AML a través del BFF.
///
/// El contrato todavía no tiene la operación (docs/integracion-backend.md §6,
/// regla 5): mientras tanto solo existe el fake.
abstract interface class VerificacionRepository {
  Future<Resultado<EstadoVerificacion>> verificar();
}
