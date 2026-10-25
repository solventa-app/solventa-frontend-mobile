import '../../../../core/errors/resultado.dart';
import '../entities/consentimiento.dart';

abstract interface class ConsentimientoRepository {
  Future<Resultado<Consentimiento>> registrar(
    SolicitudConsentimiento solicitud,
  );
}
