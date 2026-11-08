import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../../../core/ids/uuid.dart';
import '../domain/entities/asistencia.dart';
import '../domain/entities/prestador.dart';
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
    this.tipo,
    this.descripcion = '',
    this.direccion = '',
    this.intentos = 0,
    this.envio = const SinEnviar(),
    this.cancelando = false,
    this.falloCancelar,
  });

  final String idSolicitud;
  final PrestadorCercano? cercano;

  /// Ubicación del cliente al abrir el mapa: adónde debe llegar el prestador.
  final Coordenada? origen;
  final TipoPrestador? tipo;
  final String descripcion;
  final String direccion;

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
      cercano != null &&
      origen != null &&
      tipo != null &&
      !tipoNoAtendido &&
      descripcion.trim().length <= ReglasSolicitud.maxDescripcion &&
      direccion.trim().length <= ReglasSolicitud.maxDireccion;

  Asistencia? get asistencia => switch (envio) {
    Respondida(:final asistencia) => asistencia,
    _ => null,
  };

  SolicitudState copyWith({
    TipoPrestador? tipo,
    String? descripcion,
    String? direccion,
    int? intentos,
    EnvioSolicitud? envio,
    bool? cancelando,
    Falla? falloCancelar,
    bool limpiarFalloCancelar = false,
  }) => SolicitudState(
    idSolicitud: idSolicitud,
    cercano: cercano,
    origen: origen,
    tipo: tipo ?? this.tipo,
    descripcion: descripcion ?? this.descripcion,
    direccion: direccion ?? this.direccion,
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
  @override
  SolicitudState build() => SolicitudState(idSolicitud: uuidV4());

  /// «Solicitar» en M06-01: una solicitud nueva (otro `idSolicitud`). El tipo
  /// arranca vacío: el cliente dice qué le pasa.
  void iniciar(PrestadorCercano cercano, Coordenada origen) => state =
      SolicitudState(idSolicitud: uuidV4(), cercano: cercano, origen: origen);

  void fijarTipo(TipoPrestador tipo) => state = state.copyWith(tipo: tipo);

  void fijarTextos({String? descripcion, String? direccion}) =>
      state = state.copyWith(descripcion: descripcion, direccion: direccion);

  /// M06-03 y M06-03b. Reenviar usa el mismo `idSolicitud`: no duplica la
  /// asistencia ni pide otra vez los datos.
  Future<void> enviar() async {
    final s = state;
    if (!s.listoParaEnviar || s.envio is Enviando) return;
    state = s.copyWith(envio: const Enviando());
    final espera = Future<void>.delayed(ref.read(duracionMinimaEnvioProvider));
    final r = await ref
        .read(asistenciaRepositoryProvider)
        .solicitar(
          SolicitudAsistencia(
            idSolicitud: s.idSolicitud,
            prestador: s.prestador!,
            tipo: s.tipo!,
            ubicacion: s.origen!,
            descripcion: s.descripcion,
            direccion: s.direccion,
          ),
        );
    await espera;
    if (!ref.mounted) return;
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
    final r = await ref.read(asistenciaRepositoryProvider).cancelar(actual.id);
    if (!ref.mounted) return false;
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(cancelando: false, envio: Respondida(valor));
        return true;
      case Fracaso(:final falla):
        state = state.copyWith(cancelando: false, falloCancelar: falla);
        return false;
    }
  }
}
