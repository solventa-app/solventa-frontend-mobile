import '../../../../core/contrato/schema.graphql.dart';
import '../../../../core/errors/falla.dart';
import '../../../../core/errors/guardar_fallas.dart';
import '../../../../core/errors/resultado.dart';
import '../../../../core/network/subida_archivo_service.dart';
import '../../../../core/sesion/gestor_sesion.dart';
import '../../domain/entities/onboarding.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_datasource.dart';
import '../graphql/onboarding.graphql.dart';
import '../mappers/onboarding_mapper.dart';

/// `ErrorOnboarding` del contrato, convertido en `FallaNegocio` con su código.
final class _Rechazo implements Exception {
  const _Rechazo(this.codigo, {this.segundosRestantes});
  final String codigo;

  /// Solo con `ESPERA_REQUERIDA` (v0.31).
  final int? segundosRestantes;
}

/// Códigos de `ErrorOnboarding` que tiene sentido reintentar tal cual.
const _reintentables = {
  'NO_DISPONIBLE',
  'ALMACENAMIENTO_NO_DISPONIBLE',
  'OBJETO_NO_SUBIDO',
  'PROVEEDOR_NO_DISPONIBLE',
};

final class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(
    this._remoto,
    this._subidas,
    this._sesion, {
    this.tipoDocumento = Enum$TipoDocumentoOnboarding.CC,
  });

  final OnboardingRemoteDataSource _remoto;
  final SubidaArchivoService _subidas;
  final GestorSesion _sesion;

  /// Hoy solo cédula de ciudadanía (CO); CE queda en el contrato para después.
  final Enum$TipoDocumentoOnboarding tipoDocumento;

  // Solo en memoria: el token del recorrido no se persiste.
  String? _id;
  String? _token;

  Future<Resultado<T>> _guardar<T>(Future<T> Function() op) async {
    final r = await guardarFallas(op);
    if (r case Fracaso(falla: Inesperada(causa: final _Rechazo rechazo))) {
      return Fracaso(
        FallaNegocio(
          rechazo.codigo,
          reintentable: _reintentables.contains(rechazo.codigo),
          segundosRestantes: rechazo.segundosRestantes,
        ),
      );
    }
    return r;
  }

  Onboarding _resultado(Object r) => switch (r) {
    Fragment$OnboardingCampos() => onboardingDesdeGql(r),
    Fragment$ErrorOnboardingCampos(:final codigo) => throw _Rechazo(codigo),
    _ => throw const _Rechazo('RESPUESTA_DESCONOCIDA'),
  };

  /// El error del código OTP conserva `segundosRestantes` (ESPERA_REQUERIDA).
  Never _rechazar(Fragment$ErrorOnboardingCampos e) =>
      throw _Rechazo(e.codigo, segundosRestantes: e.segundosRestantes);

  CodigoOnboarding _resultadoCodigo(Object r) => switch (r) {
    Fragment$CodigoOnboardingCampos() => codigoOnboardingDesdeGql(r),
    Fragment$ErrorOnboardingCampos() => _rechazar(r),
    _ => throw const _Rechazo('RESPUESTA_DESCONOCIDA'),
  };

  ({String id, String token}) get _recorrido {
    final id = _id, token = _token;
    if (id == null || token == null) throw const _Rechazo('TOKEN_INVALIDO');
    return (id: id, token: token);
  }

  Future<void> _asegurarRecorrido() async {
    if (_id != null && _token != null) return;
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

  @override
  Future<Resultado<Onboarding>> iniciarConConsentimiento({
    required String versionTexto,
  }) => _guardar(() async {
    await _asegurarRecorrido();
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
  Future<Resultado<CodigoOnboarding>> enviarCodigo({required String correo}) =>
      _guardar(() async {
        final token = _token ?? '';
        return _resultadoCodigo(await _remoto.enviarCodigo(token, correo));
      });

  @override
  Future<Resultado<CodigoOnboarding>> verificarCodigo({
    required String correo,
    required String codigo,
  }) => _guardar(() async {
    final token = _token ?? '';
    return _resultadoCodigo(
      await _remoto.verificarCodigo(token, correo, codigo),
    );
  });

  @override
  Future<Resultado<PerfilUsuario>> registrarCuenta({
    required String correo,
    required String clave,
    required String codigo,
  }) => _guardar(() async {
    final r = await _remoto.registrarCuenta(correo, clave, codigo);
    switch (r) {
      case Mutation$RegistrarCuenta$registrarCuenta$$Sesion(
        :final token,
        :final expiraEn,
        :final refreshToken,
        :final refreshExpiraEn,
        :final usuario,
      ):
        await _sesion.abrir(
          token: token,
          expiraEn: expiraEn,
          refresh: refreshToken,
          refreshVenceEn: refreshExpiraEn,
        );
        return perfilUsuarioDesdeGql(usuario);
      case Mutation$RegistrarCuenta$registrarCuenta$$ErrorAutenticacion(
        :final codigo,
      ):
        throw _Rechazo(codigo ?? 'DATO_INVALIDO');
      default:
        throw const _Rechazo('DATO_INVALIDO');
    }
  });

  @override
  Future<Resultado<Onboarding>> crearCuenta({
    required String correo,
    required String clave,
  }) => _guardar(() async {
    if (_id != null && _token != null) {
      final r = _recorrido;
      final cuenta = await _remoto.crearCuenta(r.token, r.id, correo, clave);
      switch (cuenta) {
        case Mutation$CrearCuentaOnboarding$crearCuentaOnboarding$$CuentaOnboarding():
          final sesion = cuenta.sesion;
          await _sesion.abrir(
            token: sesion.token,
            expiraEn: sesion.expiraEn,
            refresh: sesion.refreshToken,
            refreshVenceEn: sesion.refreshExpiraEn,
          );
          return onboardingDesdeGql(cuenta.onboarding);
        case Fragment$ErrorOnboardingCampos(:final codigo):
          throw _Rechazo(codigo);
        default:
          throw const _Rechazo('RESPUESTA_DESCONOCIDA');
      }
    }
    // Sin recorrido de onboarding no hay cuenta que crear aquí: el registro
    // con correo pasa siempre por el código real (registrarCuenta).
    throw const _Rechazo('TOKEN_INVALIDO');
  });

  @override
  Future<Resultado<PerfilUsuario>> iniciarSesion({
    required String usuario,
    required String clave,
  }) => _guardar(() async {
    final r = await _remoto.iniciarSesion(usuario, clave);
    switch (r) {
      case Mutation$IniciarSesion$iniciarSesion$$Sesion(
        :final token,
        :final expiraEn,
        :final refreshToken,
        :final refreshExpiraEn,
        :final usuario,
      ):
        // La app es solo del cliente (el backend ya lo exige, v0.29). Si
        // llegara otro rol no se abre sesión y se responde como con una clave
        // errada: el rol de la cuenta no se revela.
        if (usuario.rol != Enum$RolUsuario.CLIENTE) {
          throw const _Rechazo('CREDENCIALES_INVALIDAS');
        }
        await _sesion.abrir(
          token: token,
          expiraEn: expiraEn,
          refresh: refreshToken,
          refreshVenceEn: refreshExpiraEn,
        );
        return perfilUsuarioDesdeGql(usuario);
      case Mutation$IniciarSesion$iniciarSesion$$ErrorAutenticacion(
        :final codigo,
      ):
        throw _Rechazo(codigo ?? 'CREDENCIALES_INVALIDAS');
      default:
        throw const _Rechazo('CREDENCIALES_INVALIDAS');
    }
  });

  @override
  Future<Resultado<PerfilUsuario?>> consultarPerfil() => _guardar(() async {
    final u = await _remoto.yo();
    return u == null ? null : perfilUsuarioDesdeGql(u);
  });

  @override
  Future<Resultado<PerfilUsuario>> actualizarPreferencias({
    required String idioma,
    required String moneda,
  }) => _guardar(() async {
    final codigoIdioma = idioma.toUpperCase() == 'EN' ? 'EN' : 'ES';
    final r = await _remoto.actualizarPreferencias(codigoIdioma, moneda);
    if (r is Fragment$UsuarioCampos) {
      return perfilUsuarioDesdeGql(r as Fragment$UsuarioCampos);
    }
    throw const _Rechazo('PREFERENCIAS_INVALIDAS');
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
      case Mutation$ActualizarSesion$actualizarSesion$$Sesion(
        :final token,
        :final expiraEn,
      ):
        // El refresh no cambia: renovarSesion revalida el estado verificado.
        _sesion.actualizarToken(token, expiraEn);
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

  @override
  void descartarRecorrido() {
    _id = null;
    _token = null;
  }

  @override
  Future<void> cerrarSesion() async {
    _id = null;
    _token = null;
    // Revoca el refresh en el backend (si falla la red, igual borra local).
    await _sesion.cerrar();
  }
}
