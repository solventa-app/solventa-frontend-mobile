import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../../../core/ids/uuid.dart';
import '../domain/entities/asistencia.dart';
import '../domain/entities/prestador.dart';
import 'mis_asistencias_notifier.dart';
import 'providers.dart';

/// Desenlace del envío (M06-03 → M06-04a / M06-04b).
sealed class EnvioSolicitud {
  const EnvioSolicitud();
}

final class SinEnviar extends EnvioSolicitud {
  const SinEnviar();
}

final class Enviando extends EnvioSolicitud {
  const Enviando();
}

/// El backend respondió una asistencia (confirmada, no confirmada o
/// cancelada).
final class Respondida extends EnvioSolicitud {
  const Respondida(this.asistencia);
  final Asistencia asistencia;
}

/// Red caída, 503 o un rechazo de negocio (`FallaNegocio` con el código).
final class EnvioFallido extends EnvioSolicitud {
  const EnvioFallido(this.falla);
  final Falla falla;
}

/// Estado del recorrido de HU-M06 desde «Solicitar» (M06-02 a M06-06).
final class SolicitudState {
  const SolicitudState({
    required this.idSolicitud,
    this.cercano,
    this.origen,
    this.direccionEscrita,
    this.tipo,
    this.descripcion = '',
    this.intentos = 0,
    this.envio = const SinEnviar(),
    this.cancelando = false,
    this.falloCancelar,
  });

  final String idSolicitud;
  final PrestadorCercano? cercano;

  /// Adónde debe llegar el prestador: el GPS o la dirección escrita ya
  /// ubicada (2.0).
  final Coordenada? origen;

  /// La dirección que escribió el cliente (origen `DIRECCION`); `null` = GPS.
  final String? direccionEscrita;
  final TipoPrestador? tipo;
  final String descripcion;

  /// Envíos ya hechos con este `idSolicitud` (M06-03b si es mayor que 0).
  final int intentos;
  final EnvioSolicitud envio;
  final bool cancelando;
  final Falla? falloCancelar;

  Prestador? get prestador => cercano?.prestador;

  /// El tipo elegido no lo atiende el prestador (CA de M06-02).
  bool get tipoNoAtendido =>
      tipo != null && prestador != null && tipo != prestador!.tipo;

  bool get listoParaEnviar =>
      prestador != null &&
      origen != null &&
      tipo != null &&
      !tipoNoAtendido &&
      descripcion.trim().length <= ReglasSolicitud.maxDescripcion;

  Asistencia? get asistencia => switch (envio) {
    Respondida(:final asistencia) => asistencia,
    _ => null,
  };

  SolicitudState copyWith({
    TipoPrestador? tipo,
    String? descripcion,
    int? intentos,
    EnvioSolicitud? envio,
    bool? cancelando,
    Falla? falloCancelar,
    bool limpiarFalloCancelar = false,
  }) => SolicitudState(
    idSolicitud: idSolicitud,
    cercano: cercano,
    origen: origen,
    direccionEscrita: direccionEscrita,
    tipo: tipo ?? this.tipo,
    descripcion: descripcion ?? this.descripcion,
    intentos: intentos ?? this.intentos,
    envio: envio ?? this.envio,
    cancelando: cancelando ?? this.cancelando,
    falloCancelar: limpiarFalloCancelar
        ? null
        : falloCancelar ?? this.falloCancelar,
  );
}

/// Tiempo mínimo en «Enviando» (M06-03): el prototipo avanza a los 1,5 s, y
/// así una respuesta instantánea no es un parpadeo. Cero en pruebas.
final duracionMinimaEnvioProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 1500),
);

final class SolicitudNotifier extends Notifier<SolicitudState> {
  /// El permiso de notificaciones se pide una vez, al enviar la primera
  /// solicitud (4.5); M06-02 explica antes para qué.
  static bool _permisoPedido = false;

  @override
  SolicitudState build() => SolicitudState(idSolicitud: uuidV4());

  /// «Solicitar» en M06-01: una solicitud nueva (otro `idSolicitud`). S3: el
  /// tipo llega prellenado con el del prestador, así el botón queda listo; el
  /// cliente lo puede cambiar. [direccionEscrita] solo sin GPS (2.0).
  void iniciar(
    PrestadorCercano cercano,
    Coordenada origen, {
    String? direccionEscrita,
  }) => state = SolicitudState(
    idSolicitud: uuidV4(),
    cercano: cercano,
    origen: origen,
    direccionEscrita: direccionEscrita,
    tipo: cercano.prestador.tipo,
  );

  void fijarTipo(TipoPrestador tipo) => state = state.copyWith(tipo: tipo);

  void fijarTextos({String? descripcion}) =>
      state = state.copyWith(descripcion: descripcion);

  /// M06-03 y M06-03b. Reenviar usa el mismo `idSolicitud`: no duplica la
  /// asistencia ni pide otra vez los datos.
  Future<void> enviar() async {
    final s = state;
    if (!s.listoParaEnviar || s.envio is Enviando) return;
    state = s.copyWith(envio: const Enviando());
    if (!_permisoPedido) {
      _permisoPedido = true;
      unawaited(ref.read(notificacionesAsistenciaProvider).pedirPermiso());
    }
    final espera = Future<void>.delayed(ref.read(duracionMinimaEnvioProvider));
    final r = await ref
        .read(asistenciaRepositoryProvider)
        .solicitar(
          SolicitudAsistencia(
            idSolicitud: s.idSolicitud,
            prestador: s.prestador!,
            tipo: s.tipo!,
            ubicacion: s.origen!,
            origen: s.direccionEscrita == null
                ? OrigenUbicacion.gps
                : OrigenUbicacion.direccion,
            descripcion: s.descripcion,
            direccion: s.direccionEscrita ?? '',
          ),
        );
    await espera;
    if (!ref.mounted) return;
    // 4.5: confirmada, se programa la notificación de llegada.
    if (r case Exito(:final valor)) unawaited(programarLlegada(ref, valor));
    state = state.copyWith(
      intentos: s.intentos + 1,
      envio: switch (r) {
        Exito(:final valor) => Respondida(valor),
        Fracaso(:final falla) => EnvioFallido(falla),
      },
    );
  }

  /// M06-05 «Sí, cancelar». `true` si quedó cancelada.
  Future<bool> cancelar() async {
    final actual = state.asistencia;
    if (actual == null || state.cancelando) return false;
    if (actual.estado == EstadoAsistencia.cancelada) return true;
    state = state.copyWith(cancelando: true, limpiarFalloCancelar: true);
    // 4.6: la notificación se cancela antes de responder; si falla, vuelve.
    await ref.read(notificacionesAsistenciaProvider).cancelar(actual.id);
    final r = await ref.read(asistenciaRepositoryProvider).cancelar(actual.id);
    if (!ref.mounted) return false;
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(cancelando: false, envio: Respondida(valor));
        return true;
      case Fracaso(:final falla):
        unawaited(programarLlegada(ref, actual));
        state = state.copyWith(cancelando: false, falloCancelar: falla);
        return false;
    }
  }
}
