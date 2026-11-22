import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/network_providers.dart';
import 'almacen_local.dart';
import 'base_local.dart';
import 'llave_almacen.dart';

bool get _enPruebas => Platform.environment.containsKey('FLUTTER_TEST');

/// `true` si lo guardado va a la base cifrada del teléfono; `false` con
/// `API_ENV=mock` y en `flutter test`, donde todo queda en memoria.
final almacenEnDiscoProvider = Provider<bool>(
  (ref) => !_enPruebas && !ref.watch(usarFakesProvider),
);

final abridorBaseLocalProvider = Provider<AbridorBaseLocal>((ref) {
  final ambiente = ref.watch(apiEnvProvider);
  return AbridorBaseLocal(
    ambiente: ambiente,
    llave: LlaveAlmacenSegura(ambiente: ambiente),
  );
});

/// La base cifrada del ambiente. Se abre en la primera consulta.
final baseLocalProvider = Provider<BaseLocal>((ref) {
  final base = ref.watch(abridorBaseLocalProvider).abrir();
  ref.onDispose(() => unawaited(base.close()));
  return base;
});

/// Cómo abrió la base. La app avisa una vez si tuvo que empezar de cero
/// (`reiniciada`) o si no puede guardar en el teléfono (`soloMemoria`).
final aperturaBaseProvider = FutureProvider<AperturaBase>((ref) {
  if (!ref.watch(almacenEnDiscoProvider)) {
    return AperturaBase.normal;
  }
  return ref.watch(abridorBaseLocalProvider).apertura;
});

final almacenLocalProvider = Provider<AlmacenLocal>(
  (ref) => ref.watch(almacenEnDiscoProvider)
      ? AlmacenLocalDrift(ref.watch(baseLocalProvider))
      : AlmacenLocalMemoria(),
);

/// Reloj del almacén (fijo en pruebas).
final relojAlmacenProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// La cuenta dueña de lo que se guarda en el teléfono. La fija la app cuando
/// carga el perfil (con conexión) o cuando entra sin conexión con la cuenta
/// guardada; al cerrar sesión vuelve a `null` y no se guarda ni se muestra
/// nada.
final class CuentaActualNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void fijar(String? id) {
    if (state != id) state = id;
  }
}

final cuentaActualProvider = NotifierProvider<CuentaActualNotifier, String?>(
  CuentaActualNotifier.new,
);
