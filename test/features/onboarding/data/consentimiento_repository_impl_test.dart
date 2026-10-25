import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solventa_mobile/core/errors/falla.dart';
import 'package:solventa_mobile/core/errors/resultado.dart';
import 'package:solventa_mobile/core/network/network_exceptions.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/consentimiento_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/datasources/fake_consentimiento_remote_datasource.dart';
import 'package:solventa_mobile/features/onboarding/data/repositories/consentimiento_repository_impl.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/consentimiento.dart';

class _RemotoMock extends Mock implements ConsentimientoRemoteDataSource {}

const _solicitud = SolicitudConsentimiento(
  finalidad: 'verificacion-identidad',
  versionTexto: 'v1',
);

void main() {
  setUpAll(() => registerFallbackValue(_solicitud));

  test('con el fake devuelve un consentimiento vigente', () async {
    final repo = ConsentimientoRepositoryImpl(
      const FakeConsentimientoRemoteDataSource(latencia: Duration.zero),
    );

    final r = await repo.registrar(_solicitud);

    expect(
      r,
      isA<Exito<Consentimiento>>().having(
        (e) => e.valor.vigente,
        'vigente',
        true,
      ),
    );
  });

  test('un 503 del gateway llega como ServicioNoDisponible', () async {
    final remoto = _RemotoMock();
    when(() => remoto.registrar(any())).thenThrow(const ErrorHttp(503));

    final r = await ConsentimientoRepositoryImpl(remoto).registrar(_solicitud);

    expect(
      r,
      isA<Fracaso<Consentimiento>>().having(
        (f) => f.falla,
        'falla',
        isA<ServicioNoDisponible>(),
      ),
    );
  });
}
