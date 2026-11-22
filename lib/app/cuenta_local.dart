import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/almacen/almacen_local.dart';
import '../core/almacen/almacen_providers.dart';
import '../core/log/sol_log.dart';
import '../features/claims/data/local/limpieza_reportes.dart';
import '../features/claims/presentation/providers.dart';
import '../features/onboarding/domain/entities/verificacion_identidad.dart';
import '../features/onboarding/presentation/onboarding_notifier.dart';

/// Lo que la base local necesita saber de la sesión (HU-M05, sin conexión).
typedef _Cuenta = ({
  bool abierta,
  String? id,
  String? nombre,
  EstadoVerificacion? verificacion,
});

/// Mantiene al día de quién es lo que se guarda en el teléfono: cada vez que
/// carga el perfil con conexión, anota la cuenta (id, nombre para el saludo y
/// si está verificada) y limpia lo vencido. Al cerrarse la sesión, nadie es
/// dueño: no se guarda ni se muestra nada.
void seguirCuentaLocal(WidgetRef ref) {
  ref.listenManual<_Cuenta>(
    onboardingProvider.select(
      (s) => (
        abierta: s.cuentaCreada,
        id: s.perfil?.id,
        nombre: s.perfil?.nombre,
        verificacion: s.verificacion,
      ),
    ),
    (antes, ahora) {
      final id = ahora.id;
      if (!ahora.abierta || id == null) {
        if (antes?.abierta ?? false) {
          ref.read(cuentaActualProvider.notifier).fijar(null);
        }
        return;
      }
      ref.read(cuentaActualProvider.notifier).fijar(id);
      unawaited(_anotar(ref, id, ahora, limpiar: antes?.id != id));
    },
    fireImmediately: true,
  );
}

Future<void> _anotar(
  WidgetRef ref,
  String id,
  _Cuenta cuenta, {
  required bool limpiar,
}) async {
  final local = ref.read(almacenLocalProvider);
  final ahora = ref.read(relojAlmacenProvider)().toUtc();
  try {
    await local.guardarCuenta(
      CuentaLocal(
        id: id,
        nombre: cuenta.nombre?.trim() ?? '',
        verificada: cuenta.verificacion == EstadoVerificacion.verificada,
        ultimaConexion: ahora,
      ),
    );
  } on Object catch (e) {
    SolLog.warning(
      'No se pudo anotar la cuenta en el teléfono',
      codigo: e.runtimeType.toString(),
    );
  }
  if (!limpiar) return;
  await limpiarReportes(
    almacen: ref.read(almacenReportesProvider),
    local: local,
    cuentaId: id,
    ahora: ahora,
  );
}

/// Cierre de sesión (plan 4.6): la cuenta deja de estar activa en el teléfono
/// y se borran su nombre y las copias de lo que respondió el servidor. Los
/// reportes sin enviar se conservan cifrados a nombre de la cuenta, salvo que
/// el cliente pida borrarlos ([borrarReportes]).
Future<void> cerrarCuentaLocal(
  WidgetRef ref, {
  required bool borrarReportes,
}) async {
  final cuenta = ref.read(cuentaActualProvider);
  try {
    if (borrarReportes && cuenta != null) {
      await ref.read(almacenReportesProvider).borrarDeCuenta(cuenta);
    }
    await ref.read(almacenLocalProvider).cerrarCuenta();
  } on Object catch (e) {
    SolLog.warning(
      'No se pudo cerrar la cuenta en el teléfono',
      codigo: e.runtimeType.toString(),
    );
  }
}
