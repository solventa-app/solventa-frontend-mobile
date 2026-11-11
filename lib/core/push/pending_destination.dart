import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ruta a la que la app debe continuar en cuanto haya sesión abierta.
///
/// La llena el guard de las rutas de M04 (HU-M04 Fase 6, KAN-259) cuando
/// alguien sin sesión toca el push de una indemnización («el push como
/// puerta de entrada»): se pide login primero y, ya autenticado, la app
/// continúa aquí sin perder el id.
class PendingDestinationNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void fijar(String ruta) => state = ruta;

  void limpiar() => state = null;
}

final pendingDestinationProvider =
    NotifierProvider<PendingDestinationNotifier, String?>(
      PendingDestinationNotifier.new,
    );
