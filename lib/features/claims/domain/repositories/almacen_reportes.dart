import 'dart:typed_data';

import '../../../../core/ubicacion/coordenada.dart';
import '../entities/reporte_guardado.dart';

/// Reportes guardados en el teléfono (base cifrada). Cada paso del reporte se
/// escribe aquí antes de avanzar: si la app muere, al abrir se sabe en qué iba.
abstract interface class AlmacenReportes {
  /// Avisa cada vez que cambia algo guardado.
  Stream<void> get cambios;

  /// Los reportes de [cuentaId], del más antiguo al más nuevo, con sus fotos
  /// (sin los bytes).
  Future<List<ReporteGuardado>> deCuenta(String cuentaId);

  Future<ReporteGuardado?> leer(String id);

  /// Crea o reemplaza los datos de [reporte]. No toca sus fotos.
  Future<void> guardar(ReporteGuardado reporte);

  /// Lee, cambia y guarda en una sola transacción. Devuelve el resultado, o
  /// `null` si el reporte ya no existe.
  Future<ReporteGuardado?> actualizar(
    String id,
    ReporteGuardado Function(ReporteGuardado actual) cambio,
  );

  Future<FotoGuardada> agregarFoto(
    String idReporte, {
    required Uint8List bytes,
    required String tipoContenido,
    required DateTime tomadaEn,
    Coordenada? ubicacion,
    bool deDireccion = false,
  });

  Future<void> quitarFoto(int idFoto);

  /// Las fotos sin GPS pasan a llevar el punto de la dirección escrita.
  Future<void> ubicarFotosSinGps(String idReporte, Coordenada punto);

  Future<Uint8List?> bytesDeFoto(int idFoto);

  /// La foto ya está en el almacenamiento de la aseguradora.
  Future<void> marcarFotoSubida(int idFoto, String archivoId);

  /// Editar un reporte invalida lo subido: se sube de nuevo al enviar.
  Future<void> olvidarSubidas(String idReporte);

  /// El reporte ya tiene radicado: las fotos no hacen falta en el teléfono.
  Future<void> borrarBytesDeFotos(String idReporte);

  Future<void> borrar(String id);

  Future<void> borrarDeCuenta(String cuentaId);

  void cerrar();
}
