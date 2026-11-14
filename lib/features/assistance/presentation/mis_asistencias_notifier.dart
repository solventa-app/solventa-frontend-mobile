import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../domain/cercania.dart';
import '../domain/entities/asistencia.dart';
import 'providers.dart';

/// Estado de la pestaña «Mis asistencias» (HU-M06, 4.1 a 4.4b).
final class MisAsistenciasState {
  const MisAsistenciasState({
    this.cargando = true,
    this.asistencias = const [],
    this.falla,
    required this.ahora,
    this.alejadas = const {},
    this.recienLlegadas = const [],
  });

  final bool cargando;
  final List<Asistencia> asistencias;
  final Falla? falla;

  /// El reloj de la pestaña: cambia cada segundo mientras está visible.
  final DateTime ahora;

  /// Ids de las en camino cuyo lugar de solicitud quedó a más de 500 m (4.4b).
  final Set<String> alejadas;

  /// Las que acaban de pasar a «Ya llegaron» con la pestaña abierta: la
  /// página muestra «X llegó · Ver» y luego las olvida (4.5).
  final List<Asistencia> recienLlegadas;

  /// Llegó: el backend ya la marcó o su hora pasó en el reloj del teléfono.
  bool llego(Asistencia a) =>
      a.estado == EstadoAsistencia.llego ||
      (a.estado == EstadoAsistencia.confirmada &&
          a.llegadaEstimada != null &&
          !a.llegadaEstimada!.isAfter(ahora));

  /// Confirmadas que aún no llegan (la más próxima primero) y, al final, las
  /// no confirmadas, que también van aquí con «Reintentar».
  List<Asistencia> get enCamino {
    final confirmadas =
        asistencias
            .where((a) => a.estado == EstadoAsistencia.confirmada && !llego(a))
            .toList()
          ..sort(
            (a, b) => (a.llegadaEstimada ?? a.solicitadaEn).compareTo(
              b.llegadaEstimada ?? b.solicitadaEn,
            ),
          );
    return [
      ...confirmadas,
      ...asistencias.where((a) => a.estado == EstadoAsistencia.noConfirmada),
    ];
  }

  /// Ya llegaron, de la más reciente a la más vieja. Las canceladas no van.
  List<Asistencia> get yaLlegaron => asistencias.where(llego).toList()
    ..sort(
      (a, b) => (b.llegadaEstimada ?? b.solicitadaEn).compareTo(
        a.llegadaEstimada ?? a.solicitadaEn,
      ),
    );

  MisAsistenciasState copyWith({
    bool? cargando,
    List<Asistencia>? asistencias,
    Falla? falla,
    bool limpiarFalla = false,
    DateTime? ahora,
    Set<String>? alejadas,
    List<Asistencia>? recienLlegadas,
  }) => MisAsistenciasState(
    cargando: cargando ?? this.cargando,
    asistencias: asistencias ?? this.asistencias,
    falla: limpiarFalla ? null : falla ?? this.falla,
    ahora: ahora ?? this.ahora,
    alejadas: alejadas ?? this.alejadas,
    recienLlegadas: recienLlegadas ?? this.recienLlegadas,
  );
}

/// Reloj de la app (falso en pruebas).
final relojProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final class MisAsistenciasNotifier extends Notifier<MisAsistenciasState> {
  Timer? _tic;
  int _generacion = 0;

  @override
  MisAsistenciasState build() {
    ref.onDispose(() => _tic?.cancel());
    return MisAsistenciasState(ahora: ref.read(relojProvider)());
  }

  /// Al entrar a la pestaña o volver a primer plano: el backend manda sobre
  /// el reloj del teléfono (4.3). Gana la última recarga (4.6).
  Future<void> cargar() async {
    final generacion = ++_generacion;
    final r = await ref.read(asistenciaRepositoryProvider).misAsistencias();
    if (!ref.mounted || generacion != _generacion) return;
    switch (r) {
      case Exito(:final valor):
        state = state.copyWith(
          cargando: false,
          asistencias: valor,
          limpiarFalla: true,
          ahora: ref.read(relojProvider)(),
        );
        await sincronizarNotificaciones(ref, valor);
        await _revisarDistancia();
      case Fracaso(:final falla):
        state = state.copyWith(cargando: false, falla: falla);
    }
  }

  /// Un solo reloj de 1 s, solo con la pestaña visible y la app en primer
  /// plano (4.3).
  void activar() {
    _tic ??= Timer.periodic(const Duration(seconds: 1), (_) => _avanzar());
  }

  void pausar() {
    _tic?.cancel();
    _tic = null;
  }

  void _avanzar() {
    final antes = state;
    final ahora = ref.read(relojProvider)();
    final siguiente = antes.copyWith(ahora: ahora);
    // Idempotente por id: la notificación y el reloj pueden marcar la misma.
    final nuevas = [
      for (final a in antes.enCamino)
        if (siguiente.llego(a)) a,
    ];
    state = siguiente.copyWith(
      recienLlegadas: [...antes.recienLlegadas, ...nuevas],
    );
    // Con la pestaña abierta no hace falta la del sistema: la página avisa.
    for (final a in nuevas) {
      unawaited(ref.read(notificacionesAsistenciaProvider).cancelar(a.id));
    }
  }

  /// La página ya mostró el aviso de estas.
  void olvidarRecienLlegadas() =>
      state = state.copyWith(recienLlegadas: const []);

  /// «Reintentar» (4.1 y 4.4): el reenvío de M06-03b con el mismo id.
  Future<Resultado<Asistencia>> reintentar(Asistencia a) async {
    final u = a.ubicacion;
    final coordenada = u?.coordenada;
    if (coordenada == null) {
      return const Fracaso(FallaNegocio(CodigosAsistencia.datosInvalidos));
    }
    final r = await ref
        .read(asistenciaRepositoryProvider)
        .solicitar(
          SolicitudAsistencia(
            idSolicitud: a.id,
            prestador: a.prestador,
            tipo: a.tipo,
            ubicacion: coordenada,
            origen: u!.origen,
            descripcion: a.descripcion ?? '',
            direccion: u.direccion ?? '',
          ),
        );
    if (r case Exito(:final valor)) {
      await programarLlegada(ref, valor);
      if (ref.mounted) await cargar();
    }
    return r;
  }

  /// Cancelar (M06-05) desde el detalle o «Cancelar y pedir otra»: la
  /// notificación se cancela antes de responder; si falla, se reprograma.
  Future<bool> cancelar(Asistencia a) async {
    final avisos = ref.read(notificacionesAsistenciaProvider);
    await avisos.cancelar(a.id);
    final r = await ref.read(asistenciaRepositoryProvider).cancelar(a.id);
    if (!ref.mounted) return false;
    switch (r) {
      case Exito():
        await cargar();
        return true;
      case Fracaso():
        await programarLlegada(ref, a);
        return false;
    }
  }

  /// 4.4b: con la pestaña o el detalle abiertos (nunca en segundo plano), si
  /// el cliente está a más de 500 m de donde pidió una asistencia en camino.
  /// Solo con GPS: con la dirección escrita no hay con qué comparar.
  Future<void> _revisarDistancia() async {
    final porRevisar = state.enCamino.where(
      (a) =>
          a.estado == EstadoAsistencia.confirmada &&
          a.ubicacion?.origen == OrigenUbicacion.gps &&
          a.ubicacion?.coordenada != null,
    );
    if (porRevisar.isEmpty) {
      if (state.alejadas.isNotEmpty) state = state.copyWith(alejadas: const {});
      return;
    }
    final gps = ref.read(ubicacionServiceProvider);
    if (await gps.estado() != EstadoUbicacion.concedido) return;
    final r = await gps.ubicacionActual();
    if (!ref.mounted || r is! UbicacionObtenida) return;
    state = state.copyWith(
      alejadas: {
        for (final a in porRevisar)
          if (Cercania.seMovio(a.ubicacion!.coordenada!, r.coordenada)) a.id,
      },
    );
  }
}

/// Programa la notificación de llegada de una asistencia confirmada (4.5),
/// con el texto en el idioma de la app. Si no está en camino, la cancela.
Future<void> programarLlegada(Ref ref, Asistencia a) async {
  final avisos = ref.read(notificacionesAsistenciaProvider);
  final llegada = a.llegadaEstimada;
  if (a.estado != EstadoAsistencia.confirmada || llegada == null) {
    await avisos.cancelar(a.id);
    return;
  }
  final l10n = lookupAppLocalizations(ref.read(localeProvider));
  await avisos.programar(
    id: a.id,
    llegada: llegada,
    titulo: l10n.asistenciaNotifTitulo,
    cuerpo: l10n.asistenciaNotifCuerpo(a.prestador.nombre),
  );
}

/// Al recargar «Mis asistencias»: se reprograma la que cambió de hora y se
/// cancela la que ya no está en camino (4.5).
Future<void> sincronizarNotificaciones(Ref ref, List<Asistencia> lista) async {
  for (final a in lista) {
    await programarLlegada(ref, a);
  }
}
