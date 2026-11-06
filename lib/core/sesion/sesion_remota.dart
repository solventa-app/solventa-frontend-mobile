import '../network/graphql_client.dart';
import 'graphql/sesion.graphql.dart';

/// Respuesta de `renovarSesion`.
sealed class Renovacion {
  const Renovacion();
}

/// El BFF entregó un par nuevo; el refresh anterior ya no sirve (rotación).
final class RenovacionExitosa extends Renovacion {
  const RenovacionExitosa({
    required this.token,
    required this.expiraEn,
    required this.refresh,
    this.refreshVenceEn,
  });

  final String token;
  final DateTime expiraEn;
  final String refresh;
  final DateTime? refreshVenceEn;
}

/// `SESION_VENCIDA`: refresh vencido, revocado, reusado o de una cuenta que ya
/// no puede renovar. Hay que volver a pedir correo y clave.
final class RenovacionRechazada extends Renovacion {
  const RenovacionRechazada();
}

/// `renovarSesion` y `cerrarSesion` del BFF (T22). Lanzan `ErrorCliente` ante
/// fallas de red o del servidor.
abstract interface class SesionRemota {
  Future<Renovacion> renovar(String refresh);
  Future<void> cerrar(String refresh);
}

/// Implementación GraphQL. Usa un [GraphqlClient] **sin** renovación
/// automática: si esta llamada falla por sesión, no se intenta renovar otra vez.
final class GqlSesionRemota implements SesionRemota {
  GqlSesionRemota(this._cliente);

  final GraphqlClient _cliente;

  @override
  Future<Renovacion> renovar(String refresh) async {
    final data = await _cliente.ejecutar(
      documentNodeMutationRenovarSesion,
      variables: Variables$Mutation$RenovarSesion(refreshToken: refresh)
          .toJson(),
    );
    final r = Mutation$RenovarSesion.fromJson(data).renovarSesion;
    return switch (r) {
      Mutation$RenovarSesion$renovarSesion$$Sesion(
        :final token,
        :final expiraEn,
        :final refreshToken?,
        :final refreshExpiraEn,
      ) =>
        RenovacionExitosa(
          token: token,
          expiraEn: expiraEn,
          refresh: refreshToken,
          refreshVenceEn: refreshExpiraEn,
        ),
      // Una Sesion sin refresh en el canal app no cumple el contrato.
      _ => const RenovacionRechazada(),
    };
  }

  @override
  Future<void> cerrar(String refresh) async {
    await _cliente.ejecutar(
      documentNodeMutationCerrarSesion,
      variables: Variables$Mutation$CerrarSesion(refreshToken: refresh)
          .toJson(),
    );
  }
}

/// Para `API_ENV=mock`: rota con tokens de demostración. [rechazar] simula
/// `SESION_VENCIDA` y [errorRed] una falla de red.
final class FakeSesionRemota implements SesionRemota {
  FakeSesionRemota({this.rechazar = false, this.errorRed});

  bool rechazar;

  /// Si no es `null`, cada llamada lanza esta excepción.
  Object? errorRed;

  int renovaciones = 0;
  final cerrados = <String>[];

  @override
  Future<Renovacion> renovar(String refresh) async {
    final error = errorRed;
    if (error != null) throw error;
    if (rechazar) return const RenovacionRechazada();
    renovaciones++;
    final ahora = DateTime.now().toUtc();
    return RenovacionExitosa(
      token: 'jwt-demo-renovado-$renovaciones',
      expiraEn: ahora.add(const Duration(minutes: 60)),
      refresh: 'refresh-demo-$renovaciones',
      refreshVenceEn: ahora.add(const Duration(days: 8)),
    );
  }

  @override
  Future<void> cerrar(String refresh) async {
    final error = errorRed;
    if (error != null) throw error;
    cerrados.add(refresh);
  }
}
