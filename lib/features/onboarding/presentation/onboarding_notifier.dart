import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../data/datasources/captura_service.dart';
import '../domain/entities/onboarding.dart';
import '../domain/entities/verificacion_identidad.dart';
import 'providers.dart';

/// Estado del flujo de onboarding (M01-01 a M01-08) y cuenta del usuario.
/// Vive en memoria y se pierde al cerrar la app: las capturas nunca se guardan
/// en disco.
final class OnboardingState {
  const OnboardingState({
    this.consentimientoMarcado = false,
    this.registrandoConsentimiento = false,
    this.onboarding,
    this.frenteCapturado = false,
    this.reversoCapturado = false,
    this.rostroCapturado = false,
    this.videoCapturado = false,
    this.ocupado = false,
    this.verificacion,
    this.consultasAgotadas = false,
    this.falla,
    this.correoPendiente,
    this.clavePendiente,
    this.codigoOnboarding,
    this.cuentaCreada = false,
    this.perfil,
    this.sesionCerrada = false,
  });

  final bool consentimientoMarcado;
  final bool registrandoConsentimiento;

  /// El recorrido tal como lo devolvió el backend la última vez.
  final Onboarding? onboarding;
  final bool frenteCapturado;
  final bool reversoCapturado;
  final bool rostroCapturado;
  final bool videoCapturado;

  /// Capturando, enviando o creando la cuenta: deshabilita el botón principal.
  final bool ocupado;
  final EstadoVerificacion? verificacion;

  /// M01-06 ya hizo sus consultas y el resultado no llegó: muestra «Actualizar».
  final bool consultasAgotadas;

  /// Última falla para mostrar con su texto del ARB; se limpia al reintentar.
  final Falla? falla;

  /// Correo y clave temporales mientras se verifica el código OTP de 6 dígitos.
  final String? correoPendiente;
  final String? clavePendiente;
  final CodigoOnboarding? codigoOnboarding;

  /// `true` cuando la cuenta ya fue creada o autenticada.
  final bool cuentaCreada;

  /// Perfil actual del usuario (`yo`).
  final PerfilUsuario? perfil;

  /// El usuario acaba de cerrar sesión: la pantalla de entrada abre en «Inicia sesión».
  final bool sesionCerrada;

  /// Intentos que quedan tras un rechazo (0: ya no se puede repetir).
  int get intentosRestantes => onboarding?.intentosRestantes ?? 0;

  /// `true` si las cuatro capturas ya están en memoria y se puede reintentar
  /// el envío sin volver a abrir la cámara.
  bool get capturasListasParaReintentar =>
      frenteCapturado && reversoCapturado && rostroCapturado && videoCapturado;

  /// `true` cuando el motivo de rechazo es únicamente del reconocimiento
  /// facial en vivo (`ROSTRO_NO_COINCIDE` o `SUPLANTACION`) y las fotos de la
  /// cédula ya están capturadas en memoria.
  bool get rechazoSoloRostro {
    final motivo = onboarding?.motivo;
    return (motivo == 'ROSTRO_NO_COINCIDE' || motivo == 'SUPLANTACION') &&
        frenteCapturado &&
        reversoCapturado;
  }

  OnboardingState copyWith({
    bool? consentimientoMarcado,
    bool? registrandoConsentimiento,
    Onboarding? onboarding,
    bool? frenteCapturado,
    bool? reversoCapturado,
    bool? rostroCapturado,
    bool? videoCapturado,
    bool? ocupado,
    EstadoVerificacion? verificacion,
    bool? consultasAgotadas,
    Falla? falla,
    String? correoPendiente,
    String? clavePendiente,
    CodigoOnboarding? codigoOnboarding,
    bool? cuentaCreada,
    PerfilUsuario? perfil,
    bool? sesionCerrada,
    bool limpiarFalla = false,
    bool limpiarVerificacion = false,
    bool limpiarCredencialesPendientes = false,
    bool limpiarPerfil = false,
  }) => OnboardingState(
    consentimientoMarcado: consentimientoMarcado ?? this.consentimientoMarcado,
    registrandoConsentimiento:
        registrandoConsentimiento ?? this.registrandoConsentimiento,
    onboarding: onboarding ?? this.onboarding,
    frenteCapturado: frenteCapturado ?? this.frenteCapturado,
    reversoCapturado: reversoCapturado ?? this.reversoCapturado,
    rostroCapturado: rostroCapturado ?? this.rostroCapturado,
    videoCapturado: videoCapturado ?? this.videoCapturado,
    ocupado: ocupado ?? this.ocupado,
    verificacion: limpiarVerificacion
        ? null
        : verificacion ?? this.verificacion,
    consultasAgotadas: consultasAgotadas ?? this.consultasAgotadas,
    falla: limpiarFalla ? null : falla ?? this.falla,
    correoPendiente: limpiarCredencialesPendientes
        ? null
        : correoPendiente ?? this.correoPendiente,
    clavePendiente: limpiarCredencialesPendientes
        ? null
        : clavePendiente ?? this.clavePendiente,
    codigoOnboarding: limpiarCredencialesPendientes
        ? null
        : codigoOnboarding ?? this.codigoOnboarding,
    cuentaCreada: cuentaCreada ?? this.cuentaCreada,
    perfil: limpiarPerfil ? null : perfil ?? this.perfil,
    sesionCerrada: sesionCerrada ?? this.sesionCerrada,
  );
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  /// Versión del texto legal de M01-02 (se registra con el consentimiento
  /// `onboarding-biometrico`).
  static const versionTexto = 'v1';

  /// Capturas en memoria para poder reintentar una subida fallida sin obligar
  /// al usuario a tomar las fotos o el video de nuevo.
  final _capturasEnMemoria = <PasoOnboarding, Captura>{};

  /// Subidas en curso o completadas.
  final _subidas = <PasoOnboarding, Future<Resultado<Onboarding>>>{};

  /// Sube al cerrar sesión: una consulta que vuelve después no revive la cuenta.
  int _epocaSesion = 0;

  @override
  OnboardingState build() => const OnboardingState();

  void limpiarFalla() => state = state.copyWith(limpiarFalla: true);

  void marcarConsentimiento(bool valor) =>
      state = state.copyWith(consentimientoMarcado: valor, limpiarFalla: true);

  /// M01-02: inicia el recorrido y registra el consentimiento. `true` si quedó.
  Future<bool> registrarConsentimiento() async {
    if (!state.consentimientoMarcado || state.registrandoConsentimiento) {
      return false;
    }
    state = state.copyWith(registrandoConsentimiento: true, limpiarFalla: true);
    final r = await ref
        .read(onboardingRepositoryProvider)
        .iniciarConConsentimiento(versionTexto: versionTexto);
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(
          registrandoConsentimiento: false,
          onboarding: valor,
        );
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(registrandoConsentimiento: false, falla: falla);
        return false;
    }
  }

  /// Toma la foto y deja la subida corriendo. `false` si se canceló la cámara.
  Future<bool> _capturar(
    PasoOnboarding paso,
    Future<Captura?> Function() tomar,
  ) async {
    if (state.ocupado) return false;
    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final captura = await tomar();
    if (captura == null) {
      // Sin cámara o sin permiso (fuera de mock/local): se avisa en vez de
      // subir una captura vacía.
      state = state.copyWith(
        ocupado: false,
        falla: const FallaNegocio('CAMARA_NO_DISPONIBLE', reintentable: true),
      );
      return false;
    }
    state = state.copyWith(ocupado: false);
    _capturasEnMemoria[paso] = captura;
    _subidas[paso] = ref
        .read(onboardingRepositoryProvider)
        .subir(paso, captura);
    return true;
  }

  Future<bool> capturarFrente() async {
    final ok = await _capturar(
      PasoOnboarding.anverso,
      ref.read(capturaServiceProvider).documento,
    );
    if (ok) state = state.copyWith(frenteCapturado: true);
    return ok;
  }

  Future<bool> capturarReverso() async {
    final ok = await _capturar(
      PasoOnboarding.reverso,
      ref.read(capturaServiceProvider).documento,
    );
    if (ok) state = state.copyWith(reversoCapturado: true);
    return ok;
  }

  /// Repetir descarta la captura del lado indicado.
  void repetirFrente() {
    _capturasEnMemoria.clear();
    _subidas.clear();
    state = state.copyWith(
      frenteCapturado: false,
      reversoCapturado: false,
      rostroCapturado: false,
      videoCapturado: false,
      limpiarFalla: true,
    );
  }

  void repetirReverso() {
    _capturasEnMemoria.remove(PasoOnboarding.reverso);
    _subidas.remove(PasoOnboarding.reverso);
    state = state.copyWith(
      reversoCapturado: false,
      rostroCapturado: false,
      videoCapturado: false,
      limpiarFalla: true,
    );
  }

  /// M01-05: selfie y video, espera las cuatro subidas y envía la verificación.
  /// Si las 4 capturas ya estaban en memoria tras un error de red, reintenta
  /// únicamente las subidas que fallaron sin volver a pedir cámara.
  Future<bool> completarPruebaDeVida() async {
    if (state.ocupado) return false;
    final captura = ref.read(capturaServiceProvider);
    if (!_capturasEnMemoria.containsKey(PasoOnboarding.rostro)) {
      if (!await _capturar(PasoOnboarding.rostro, captura.rostro)) return false;
      state = state.copyWith(rostroCapturado: true);
    }
    if (!_capturasEnMemoria.containsKey(PasoOnboarding.video)) {
      if (!await _capturar(PasoOnboarding.video, captura.video)) return false;
      state = state.copyWith(videoCapturado: true);
    }

    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final repo = ref.read(onboardingRepositoryProvider);

    for (final paso in PasoOnboarding.values) {
      final enMemoria = _capturasEnMemoria[paso];
      if (_subidas[paso] == null && enMemoria != null) {
        _subidas[paso] = repo.subir(paso, enMemoria);
      }
      if (_subidas[paso] == null) {
        state = state.copyWith(
          ocupado: false,
          falla: const FallaNegocio('PIEZAS_INCOMPLETAS', reintentable: true),
        );
        return false;
      }
    }

    // Ejecuta las 4 subidas en paralelo en segundo plano.
    final resultados = await Future.wait(
      PasoOnboarding.values.map((paso) async => (paso, await _subidas[paso]!)),
    );
    for (final (paso, resInicial) in resultados) {
      var res = resInicial;
      final enMemoria = _capturasEnMemoria[paso];
      if (res is Fracaso<Onboarding> && enMemoria != null) {
        final reintento = repo.subir(paso, enMemoria);
        _subidas[paso] = reintento;
        res = await reintento;
      }
      if (res case Fracaso(:final falla)) {
        unawaited(_subidas.remove(paso));
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
      }
    }

    final r = await repo.enviarVerificacion();
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(onboarding: valor);
        if (state.cuentaCreada) {
          // Validación en vivo en M01-05 cuando la cuenta ya existe: si Didit
          // rechaza el rostro en vivo y aún quedan intentos, permite repetir
          // ahí mismo en M01-05 conservando las fotos de la cédula en memoria.
          final resuelto = await _consultar();
          if (resuelto &&
              state.verificacion == EstadoVerificacion.rechazada &&
              state.rechazoSoloRostro &&
              state.intentosRestantes > 0) {
            final motivo = state.onboarding?.motivo ?? 'ROSTRO_NO_COINCIDE';
            await reintentarCaptura();
            state = state.copyWith(
              ocupado: false,
              falla: FallaNegocio(motivo, reintentable: true),
            );
            return false;
          }
        }
        state = state.copyWith(ocupado: false);
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
    }
  }

  /// Paso 1 de registro con validación real de correo: envía el código de 6
  /// dígitos al correo del usuario y guarda correo/clave en memoria.
  Future<bool> solicitarCodigoCorreo({
    required String correo,
    required String clave,
  }) async {
    if (state.ocupado) return false;
    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final r = await ref
        .read(onboardingRepositoryProvider)
        .enviarCodigo(correo: correo);
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(
          ocupado: false,
          correoPendiente: correo,
          clavePendiente: clave,
          codigoOnboarding: valor,
        );
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
    }
  }

  /// Reenvía un nuevo código de 6 dígitos al correo pendiente.
  Future<bool> reenviarCodigoCorreo() async {
    final correo = state.correoPendiente;
    final clave = state.clavePendiente;
    if (correo == null || clave == null) return false;
    return solicitarCodigoCorreo(correo: correo, clave: clave);
  }

  /// Valida el código de 6 dígitos y registra la cuenta del usuario en
  /// `PENDIENTE_VERIFICACION`.
  Future<bool> verificarCodigoYCrearCuenta(String codigo) async {
    final correo = state.correoPendiente;
    final clave = state.clavePendiente;
    if (correo == null || clave == null || state.ocupado) return false;
    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final repo = ref.read(onboardingRepositoryProvider);
    final rCuenta = await repo.registrarCuenta(
      correo: correo,
      clave: clave,
      codigo: codigo,
    );
    switch (rCuenta) {
      case Exito(:final valor):
        state = state.copyWith(
          ocupado: false,
          cuentaCreada: true,
          perfil: valor,
          limpiarCredencialesPendientes: true,
        );
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
    }
  }

  /// M01-05b: crea la cuenta directamente (o si ya se creó al inicio del flujo,
  /// continúa sin volver a pedirla).
  Future<bool> crearCuenta({
    required String correo,
    required String clave,
  }) async {
    if (state.ocupado) return false;
    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final repo = ref.read(onboardingRepositoryProvider);
    final r = await repo.crearCuenta(correo: correo, clave: clave);
    switch (r) {
      case Exito(:final valor):
        final rPerfil = await repo.consultarPerfil();
        final perfil = switch (rPerfil) {
          Exito(:final valor) => valor,
          _ => null,
        };
        state = state.copyWith(
          ocupado: false,
          onboarding: valor,
          cuentaCreada: true,
          perfil: perfil,
        );
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
    }
  }

  /// Inicia sesión con usuario/correo y clave existentes.
  Future<bool> iniciarSesion({
    required String correo,
    required String clave,
  }) async {
    if (state.ocupado) return false;
    state = state.copyWith(ocupado: true, limpiarFalla: true);
    final repo = ref.read(onboardingRepositoryProvider);
    final r = await repo.iniciarSesion(usuario: correo, clave: clave);
    switch (r) {
      case Exito(:final valor):
        final rVerif = await repo.consultar();
        final onb = switch (rVerif) {
          Exito(:final valor) => valor,
          _ => state.onboarding,
        };
        final verif = switch (onb?.estado) {
          EstadoOnboarding.verificada => EstadoVerificacion.verificada,
          EstadoOnboarding.rechazada => EstadoVerificacion.rechazada,
          EstadoOnboarding.enRevision => EstadoVerificacion.enRevision,
          _ =>
            valor.verificado
                ? EstadoVerificacion.verificada
                : state.verificacion,
        };
        state = state.copyWith(
          ocupado: false,
          cuentaCreada: true,
          perfil: valor,
          onboarding: onb,
          verificacion: verif,
        );
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(ocupado: false, falla: falla);
        return false;
    }
  }

  /// Refresca el perfil (`yo`) y el estado de `miVerificacion`.
  Future<void> cargarPerfilYEstado() async {
    final repo = ref.read(onboardingRepositoryProvider);
    final epoca = _epocaSesion;
    final rPerfil = await repo.consultarPerfil();
    if (epoca != _epocaSesion) return;
    if (rPerfil case Exito(:final valor) when valor != null) {
      state = state.copyWith(perfil: valor, cuentaCreada: true);
    }
    final rOnb = await repo.consultar();
    if (epoca != _epocaSesion) return;
    if (rOnb case Exito(:final valor)) {
      state = state.copyWith(
        onboarding: valor,
        verificacion: switch (valor.estado) {
          EstadoOnboarding.verificada => EstadoVerificacion.verificada,
          EstadoOnboarding.rechazada => EstadoVerificacion.rechazada,
          EstadoOnboarding.enRevision => EstadoVerificacion.enRevision,
          _ => state.verificacion,
        },
      );
    }
  }

  /// Cierra la sesión actual y reinicia el estado en memoria.
  Future<void> cerrarSesion() async {
    _capturasEnMemoria.clear();
    _subidas.clear();
    unawaited(limpiarCacheCapturas());
    _epocaSesion++;
    await ref.read(onboardingRepositoryProvider).cerrarSesion();
    state = const OnboardingState(sesionCerrada: true);
  }

  /// M01-06: consulta a los 3, 8 y 20 s y para. Si no llegó, `consultasAgotadas`.
  Future<void> verificar() async {
    state = state.copyWith(
      limpiarVerificacion: true,
      limpiarFalla: true,
      consultasAgotadas: false,
    );
    for (final espera in ref.read(esperasVerificacionProvider)) {
      await Future<void>.delayed(espera);
      if (!ref.mounted) return;
      if (await _consultar()) return;
    }
    state = state.copyWith(consultasAgotadas: true);
  }

  /// «Actualizar» en M01-06: una consulta más.
  Future<void> actualizar() async {
    state = state.copyWith(consultasAgotadas: false, limpiarFalla: true);
    if (!await _consultar()) state = state.copyWith(consultasAgotadas: true);
  }

  /// `true` si ya hay un resultado (o una falla que mostrar).
  Future<bool> _consultar() async {
    final repo = ref.read(onboardingRepositoryProvider);
    final r = await repo.consultar();
    switch (r) {
      case Fracaso(:final falla):
        state = state.copyWith(falla: falla);
        return true;
      case Exito(:final valor) when valor.pendiente:
        state = state.copyWith(onboarding: valor);
        return false;
      case Exito(:final valor):
        // Con resultado ya no hace falta ningún archivo de captura en disco.
        unawaited(limpiarCacheCapturas());
        PerfilUsuario? nuevoPerfil = state.perfil;
        if (valor.estado == EstadoOnboarding.verificada) {
          // Onboarding terminado: tampoco se guardan en memoria.
          _capturasEnMemoria.clear();
          _subidas.clear();
          // Sin esto el token sigue siendo `verificacion-pendiente`. Si falla,
          // la app lo vuelve a pedir al abrir; no bloquea el resultado.
          await repo.actualizarSesion();
          final rp = await repo.consultarPerfil();
          if (rp case Exito(valor: final p?)) {
            nuevoPerfil = p;
          }
        }
        state = state.copyWith(
          onboarding: valor,
          perfil: nuevoPerfil,
          verificacion: switch (valor.estado) {
            EstadoOnboarding.verificada => EstadoVerificacion.verificada,
            EstadoOnboarding.rechazada => EstadoVerificacion.rechazada,
            _ => EstadoVerificacion.enRevision,
          },
        );
        return true;
    }
  }

  /// M01-07c «Intentar de nuevo»: el backend vuelve a INICIADO. Si el rechazo
  /// fue solo por reconocimiento facial (`ROSTRO_NO_COINCIDE` o `SUPLANTACION`),
  /// conserva las fotos del documento en memoria y las vuelve a subir en
  /// segundo plano para que el usuario solo repita la prueba de vida en M01-05.
  Future<bool> reintentarCaptura() async {
    final soloRostro = state.rechazoSoloRostro;
    final repo = ref.read(onboardingRepositoryProvider);
    final r = await repo.reintentar();
    switch (r) {
      case Exito(:final valor):
        final anverso = _capturasEnMemoria[PasoOnboarding.anverso];
        final reverso = _capturasEnMemoria[PasoOnboarding.reverso];
        if (soloRostro && anverso != null && reverso != null) {
          _capturasEnMemoria.remove(PasoOnboarding.rostro);
          _capturasEnMemoria.remove(PasoOnboarding.video);
          _subidas
            ..clear()
            ..[PasoOnboarding.anverso] = repo.subir(
              PasoOnboarding.anverso,
              anverso,
            )
            ..[PasoOnboarding.reverso] = repo.subir(
              PasoOnboarding.reverso,
              reverso,
            );
          state = state.copyWith(
            onboarding: valor,
            frenteCapturado: true,
            reversoCapturado: true,
            rostroCapturado: false,
            videoCapturado: false,
            limpiarVerificacion: true,
            limpiarFalla: true,
          );
        } else {
          repetirFrente();
          state = state.copyWith(onboarding: valor, limpiarVerificacion: true);
        }
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(falla: falla);
        return false;
    }
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
