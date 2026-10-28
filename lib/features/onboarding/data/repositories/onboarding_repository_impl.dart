import '../../../../core/contrato/schema.graphql.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/errors/guardar_fallas.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/sesion/sesion_store.dart';
import '../../domain/entities/onboarding.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_datasource.dart';
import '../datasources/subida_archivo_service.dart';
import '../graphql/onboarding.graphql.dart';
import '../mappers/onboarding_mapper.dart';

/// `ErrorOnboarding` del contrato, convertido en `FallaNegocio` con su código.
final class _Rechazo implements Exception {
  const _Rechazo(this.codigo);
  final String codigo;
}

/// Códigos de `ErrorOnboarding` que tiene sentido reintentar tal cual.
const _reintentables = {'NO_DISPONIBLE', 'OBJETO_NO_SUBIDO'};

final class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(
    this._remoto,
    this._subidas,
    this._sesion, {
    this.tipoDocumento = Enum$TipoDocumentoOnboarding.CC,
  });

  final OnboardingRemoteDataSource _remoto;
  final SubidaArchivoService _subidas;
  final SesionStore _sesion;

  /// Hoy solo cédula de ciudadanía (CO); CE queda en el contrato para después.
  final Enum$TipoDocumentoOnboarding tipoDocumento;

  // Solo en memoria: el token del recorrido no se persiste.
  String? _id;
  String? _token;

  Future<Resultado<T>> _guardar<T>(Future<T> Function() op) async {
    final r = await guardarFallas(op);
    if (r case Fracaso(falla: Inesperada(causa: _Rechazo(:final codigo)))) {
      return Fracaso(
        FallaNegocio(codigo, reintentable: _reintentables.contains(codigo)),
      );
    }
    return r;
  }

  Onboarding _resultado(Object r) => switch (r) {
    Fragment$OnboardingCampos() => onboardingDesdeGql(r),
    Fragment$ErrorOnboardingCampos(:final codigo) => throw _Rechazo(codigo),
    _ => throw const _Rechazo('RESPUESTA_DESCONOCIDA'),
  };

  ({String id, String token}) get _recorrido {
    final id = _id, token = _token;
    if (id == null || token == null) throw const _Rechazo('TOKEN_INVALIDO');
    return (id: id, token: token);
  }

  @override
  Future<Resultado<Onboarding>> iniciarConConsentimiento({
    required String versionTexto,
  }) => _guardar(() async {
    if (_id == null) {
      final inicio = await _remoto.iniciar(tipoDocumento);
      switch (inicio) {
        case Mutation$IniciarOnboarding$iniciarOnboarding$$InicioOnboarding():
          _id = inicio.onboarding.id;
          _token = inicio.token;
        case Fragment$ErrorOnboardingCampos(:final codigo):
          throw _Rechazo(codigo);
        default:
          throw const _Rechazo('RESPUESTA_DESCONOCIDA');
      }
    }
    final r = _recorrido;
    return _resultado(
      await _remoto.registrarConsentimiento(r.token, r.id, versionTexto),
    );
  });

  @override
  Future<Resultado<Onboarding>> subir(
    PasoOnboarding paso,
    Captura captura,
  ) => _guardar(() async {
    final r = _recorrido;
    final subida = await _remoto.solicitarSubida(
      r.token,
      r.id,
      pasoAGql(paso),
      captura.tipoContenido,
      captura.bytes.length,
    );
    final destino = switch (subida) {
      Mutation$SolicitarSubidaOnboarding$solicitarSubidaOnboarding$$SubidaArchivo() =>
        subida,
      Fragment$ErrorOnboardingCampos(:final codigo) => throw _Rechazo(codigo),
      _ => throw const _Rechazo('RESPUESTA_DESCONOCIDA'),
    };
    await _subidas.subir(
      url: destino.url,
      metodo: destino.metodo,
      encabezados: {for (final e in destino.encabezados) e.nombre: e.valor},
      bytes: captura.bytes,
    );
    return _resultado(
      await _remoto.confirmarSubida(r.token, r.id, destino.archivo.id),
    );
  });

  @override
  Future<Resultado<Onboarding>> enviarVerificacion() => _guardar(() async {
    final r = _recorrido;
    return _resultado(await _remoto.enviarVerificacion(r.token, r.id));
  });

  @override
  Future<Resultado<Onboarding>> crearCuenta({
    required String correo,
    required String clave,
  }) => _guardar(() async {
    final r = _recorrido;
    final cuenta = await _remoto.crearCuenta(r.token, r.id, correo, clave);
    switch (cuenta) {
      case Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding():
        await _sesion.guardar(cuenta.sesion.token);
        return onboardingDesdeGql(cuenta.onboarding);
      case Fragment$ErrorOnboardingCampos(:final codigo):
        throw _Rechazo(codigo);
      default:
        throw const _Rechazo('RESPUESTA_DESCONOCIDA');
    }
  });

  @override
  Future<Resultado<Onboarding>> consultar() => _guardar(() async {
    final id = _id, token = _token;
    // Con el token del recorrido mientras sirva; si no (venció a los 30 min o
    // la app se reabrió), con la sesión de la cuenta.
    final g = id != null && token != null
        ? await _remoto.consultar(token, id) ?? await _remoto.miVerificacion()
        : await _remoto.miVerificacion();
    if (g == null) throw const _Rechazo('SIN_ONBOARDING');
    return onboardingDesdeGql(g);
  });

  @override
  Future<Resultado<void>> actualizarSesion() => _guardar(() async {
    final r = await _remoto.actualizarSesion();
    switch (r) {
      case Mutation$ActualizarSesion$actualizarSesion$$Sesion(:final token):
        await _sesion.guardar(token);
      case Mutation$ActualizarSesion$actualizarSesion$$ErrorAutenticacion(
        :final codigo,
      ):
        throw _Rechazo(codigo ?? 'SESION_INVALIDA');
      default:
        throw const _Rechazo('RESPUESTA_DESCONOCIDA');
    }
  });

  @override
  Future<Resultado<Onboarding>> reintentar() => _guardar(() async {
    final r = _recorrido;
    return _resultado(await _remoto.reintentar(r.token, r.id));
  });
}
