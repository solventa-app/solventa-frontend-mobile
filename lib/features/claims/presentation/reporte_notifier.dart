import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/falla.dart';
import '../../../core/errors/resultado.dart';
import '../../../core/ubicacion/coordenada.dart';
import '../../../core/ubicacion/ubicacion_service.dart';
import '../domain/entities/reporte_siniestro.dart';
import 'providers.dart';

/// Desenlace del envío (M05-04 → M05-05).
sealed class EnvioReporte {
  const EnvioReporte();
}

final class SinEnviar extends EnvioReporte {
  const SinEnviar();
}

final class Enviando extends EnvioReporte {
  const Enviando();
}

final class Enviado extends EnvioReporte {
  const Enviado(this.siniestro);
  final SiniestroReportado siniestro;
}

final class EnvioFallido extends EnvioReporte {
  const EnvioFallido(this.falla);
  final Falla falla;
}

/// Estado del recorrido de HU-M05 (cruza M05-01 a M05-05). Las fotos viven
/// solo aquí, en memoria; se descartan al terminar o al salir.
final class ReporteState {
  const ReporteState({
    required this.idReporte,
    this.poliza,
    this.ocurridoEn,
    this.fotos = const [],
    this.ubicacion,
    this.ubicacionSinPermiso = false,
    this.descripcion = '',
    this.lugar = '',
    this.ciudad = '',
    this.envio = const SinEnviar(),
  });

  final String idReporte;
  final PolizaReportable? poliza;
  final DateTime? ocurridoEn;
  final List<FotoSiniestro> fotos;

  /// Ubicación del teléfono al tomar las fotos; la del siniestro.
  final Coordenada? ubicacion;
  final bool ubicacionSinPermiso;
  final String descripcion;
  final String lugar;
  final String ciudad;
  final EnvioReporte envio;

  bool get puedeTomarMasFotos => fotos.length < ReglasReporte.maxFotos;

  bool get listoParaEnviar =>
      poliza != null &&
      ocurridoEn != null &&
      fotos.length >= ReglasReporte.minFotos &&
      ubicacion != null &&
      ReglasReporte.relatoValido(descripcion) &&
      lugar.trim().isNotEmpty &&
      ciudad.trim().isNotEmpty;

  ReporteState copyWith({
    PolizaReportable? poliza,
    DateTime? ocurridoEn,
    List<FotoSiniestro>? fotos,
    Coordenada? ubicacion,
    bool? ubicacionSinPermiso,
    String? descripcion,
    String? lugar,
    String? ciudad,
    EnvioReporte? envio,
  }) => ReporteState(
    idReporte: idReporte,
    poliza: poliza ?? this.poliza,
    ocurridoEn: ocurridoEn ?? this.ocurridoEn,
    fotos: fotos ?? this.fotos,
    ubicacion: ubicacion ?? this.ubicacion,
    ubicacionSinPermiso: ubicacionSinPermiso ?? this.ubicacionSinPermiso,
    descripcion: descripcion ?? this.descripcion,
    lugar: lugar ?? this.lugar,
    ciudad: ciudad ?? this.ciudad,
    envio: envio ?? this.envio,
  );
}

/// UUID v4 para `idReporte` (clave de idempotencia y id del siniestro).
String nuevoIdReporte([Random? azar]) {
  final r = azar ?? Random.secure();
  final b = List<int>.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-'
      '${h.substring(16, 20)}-${h.substring(20)}';
}

final class ReporteNotifier extends Notifier<ReporteState> {
  @override
  ReporteState build() => ReporteState(idReporte: nuevoIdReporte());

  /// Empieza un reporte nuevo (otro `idReporte`): al entrar desde el inicio.
  void reiniciar() => state = ReporteState(idReporte: nuevoIdReporte());

  void elegirPoliza(PolizaReportable poliza) =>
      state = state.copyWith(poliza: poliza);

  void fijarFecha(DateTime fecha) => state = state.copyWith(ocurridoEn: fecha);

  /// M05-02 al entrar: pide el permiso y guarda dónde está el cliente. Las
  /// fotos que tome después llevan esa ubicación.
  Future<void> prepararUbicacion() async {
    final r = await ref.read(ubicacionReporteProvider).ubicacionActual();
    if (!ref.mounted) return;
    state = switch (r) {
      UbicacionObtenida(:final coordenada) => state.copyWith(
        ubicacion: coordenada,
        ubicacionSinPermiso: false,
      ),
      UbicacionSinPermiso() ||
      UbicacionNoDisponible() => state.copyWith(ubicacionSinPermiso: true),
    };
  }

  Future<void> abrirAjustesUbicacion() =>
      ref.read(ubicacionReporteProvider).abrirAjustes(deUbicacion: false);

  void agregarFoto(Uint8List bytes, {String tipoContenido = 'image/jpeg'}) {
    if (!state.puedeTomarMasFotos || bytes.isEmpty) return;
    if (bytes.length > ReglasReporte.maxBytesFoto) return;
    final foto = FotoSiniestro(
      bytes: bytes,
      tipoContenido: tipoContenido,
      tomadaEn: ref.read(relojReporteProvider)(),
      ubicacion: state.ubicacion,
    );
    state = state.copyWith(fotos: [...state.fotos, foto]);
  }

  void quitarFoto(int indice) =>
      state = state.copyWith(fotos: [...state.fotos]..removeAt(indice));

  void fijarRelato({String? descripcion, String? lugar, String? ciudad}) =>
      state = state.copyWith(
        descripcion: descripcion,
        lugar: lugar,
        ciudad: ciudad,
      );

  /// M05-04. Reintentar usa el mismo `idReporte`: no duplica el caso ni vuelve
  /// a subir las fotos que ya subieron.
  Future<void> enviar() async {
    final s = state;
    if (!s.listoParaEnviar || s.envio is Enviando) return;
    state = s.copyWith(envio: const Enviando());
    final r = await ref
        .read(reporteSiniestroRepositoryProvider)
        .reportar(
          ReporteSiniestro(
            idReporte: s.idReporte,
            poliza: s.poliza!,
            ocurridoEn: s.ocurridoEn!,
            descripcion: s.descripcion,
            lugar: s.lugar,
            ciudad: s.ciudad,
            ubicacion: s.ubicacion!,
            fotos: s.fotos,
          ),
        );
    if (!ref.mounted) return;
    state = switch (r) {
      // Enviado: las fotos ya no hacen falta en memoria.
      Exito(:final valor) => state.copyWith(
        envio: Enviado(valor),
        fotos: const [],
      ),
      Fracaso(:final falla) => state.copyWith(envio: EnvioFallido(falla)),
    };
  }
}
