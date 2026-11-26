# HU-M05 · Reporte de siniestro sin conexión (KAN-35)

Estado al 2026-11-22. El plan aprobado, con el diseño de cada pieza y los bocetos, está en
[`plan-sin-conexion.md`](plan-sin-conexion.md). Este archivo dice qué quedó construido, cómo se prueba y qué falta.

El modo sin conexión es **solo para el reporte de siniestros**. Incluye lo mínimo para llegar a reportar sin red:
entrar con la sesión guardada y la huella, y tener las pólizas en el teléfono. La asistencia en sitio (HU-M06) y la
cobertura paramétrica (HU-M04) no cambian y sin red dicen «Necesita conexión».

## Qué hace

| Situación | Qué pasa |
|---|---|
| Se entra con red (iniciar sesión o abrir la app), con la cuenta verificada | El inicio baja las pólizas reportables y «Mis siniestros» y guarda su copia cifrada, sin que el cliente abra el reporte. Se repite al volver la red. También se actualizan cada vez que se abre «Reportar un siniestro» o «Mis siniestros» con red. No hay descarga en segundo plano ni con la app cerrada |
| Se cae la red mientras se llena el reporte | La franja de conexión lo dice. El botón cambia a «Guardar y enviar después» y el reporte queda cifrado en el teléfono con sus fotos, el GPS y el relato |
| Se cierra la app a mitad del reporte | Queda como «Sin terminar» en «Mis siniestros» y se puede continuar. Un borrador sin tocar se borra a los 7 días (avisa desde el día 5) |
| Vuelve la red | La cola lo envía sola, una sola vez (mismo `idReporte`), sin volver a subir las fotos ya subidas. La franja muestra el radicado; con la app en segundo plano llega una notificación |
| Se sale de la app a mitad del envío | Un servicio en primer plano de Android termina el envío, con una notificación de progreso |
| El reporte va a salir por datos móviles | La primera vez pregunta («Estás usando datos móviles»). La elección queda en Mi perfil («Enviar las fotos solo con Wi-Fi», apagado por defecto) |
| La aseguradora rechaza el reporte | Queda «Con error» con el motivo. Se corrige y se reenvía sin perder fotos ni relato |
| Falla técnica repetida (8 intentos que no son de red) | Queda «No se pudo enviar» con «Enviar ahora» |
| Se abre la app sin red, con la sesión guardada | La huella o el bloqueo del teléfono entran al modo sin conexión: inicio, reporte, «Mis siniestros» y Mi perfil. Al volver la red la sesión se renueva sola, sin pedir la huella otra vez |
| Se cierra sesión con reportes sin enviar | El diálogo dice cuántos hay. Se conservan cifrados para cuando vuelva a entrar la misma cuenta, salvo que el cliente marque «Borrar también los reportes guardados» |

## Dónde está cada pieza

| Pieza | Código |
|---|---|
| Estado y calidad de la red, franja y píldora | `lib/core/red/` (`estadoRedProvider`, `BannerConexion`, `ChipRed`) |
| Base local cifrada, cuenta local y copias de lo último que respondió el servidor | `lib/core/almacen/` |
| Copias de pólizas y «Mis siniestros», y su descarga al entrar | `lib/features/claims/data/local/copias_reporte.dart`, `cargaInicialReporteProvider` (lo observa el inicio en `lib/app/router.dart`) |
| Reportes guardados, fotos y limpieza | `lib/features/claims/data/local/`, `domain/entities/reporte_guardado.dart` |
| Cola de envío (un solo trabajador, reintentos, estados) | `lib/features/claims/data/cola_reportes.dart` |
| Vigía: despierta la cola, notificaciones, recordatorios y servicio en primer plano | `lib/features/claims/presentation/vigia_reportes.dart`, `data/notificaciones_reporte.dart` |
| Preferencia «solo con Wi-Fi» | `lib/features/claims/data/preferencias_envio.dart` |
| Pantallas | M05-01 a M05-05 (guardado automático y «Reporte guardado»), M05-06 («Por enviar»), M05-07b (detalle de un reporte por enviar), `widgets/` (franja, hoja de datos móviles, cierre de sesión, sección de Mi perfil) |
| Entrada sin red | `FaseAcceso.sinConexion` en `lib/features/acceso/presentation/acceso_notifier.dart`, `rutaPermitidaSinConexion` en `lib/app/router.dart`, `lib/features/profile/presentation/perfil_sin_conexion.dart` |

Las decisiones de almacenamiento y de sesión están en [`../arquitectura.md` §8](../arquitectura.md#8-persistencia-local-y-offline).

## Ramas

Locales y apiladas, sin PR, desde `develop` (`06c740a`). Un commit por fase.

| Fase | Rama |
|---|---|
| 1 | `feat/KAN-35-sin-conexion-1-indicador` |
| 2 | `feat/KAN-35-sin-conexion-2-almacen` |
| 3 | `feat/KAN-35-sin-conexion-3-cola` |
| 3b | `feat/KAN-35-sin-conexion-3b-servicio` |
| 4 | `feat/KAN-35-sin-conexion-4-acceso` |
| 5 | `feat/KAN-35-sin-conexion-5-pruebas` |

La última contiene todo. Para un solo PR basta esa rama hacia `develop`.

## Pruebas

- Unitarias y de widget: `test/core/red/`, `test/core/almacen/`, `test/features/claims/local/`,
  `test/features/acceso/acceso_sin_conexion_test.dart` y `test/app/` (rutas y la app entera entrando sin red).
- Goldens: `test/goldens/red_goldens_test.dart` y `test/goldens/m05_sin_conexion_goldens_test.dart`.
- Integración: `integration_test/reporte_sin_conexion_test.dart` (guardar sin señal y envío al volver; datos móviles),
  con capturas para el reporte de Emuladores.
- En teléfono: [`pruebas-sin-conexion.md`](pruebas-sin-conexion.md). **Pendiente.**

## Pendiente antes de dar la historia por cerrada

1. **Compilar y correr en Android.** Todo lo anterior se verificó con `flutter analyze` y `flutter test`, no en un
   dispositivo. Faltan `tool/verificar.sh --apk` en el devcontainer y la lista de
   [`pruebas-sin-conexion.md`](pruebas-sin-conexion.md): la base cifrada usa una librería nativa (`sqlite3mc` por los
   *hooks* de compilación de `sqlite3`), `connectivity_plus` agrega su parte de Gradle, y el servicio en primer plano
   y sus permisos solo existen en el manifiesto.
2. **Regenerar los goldens con `tool/goldens.sh`.** Los PNG nuevos de `test/goldens/ci/` (y los `g05_mi_perfil_*`
   que cambiaron con la sección «Envío de reportes») se generaron fuera del devcontainer. Si el CI los rechaza, se
   regeneran dentro y se revisa el diff.
3. **MobSF.** El manifiesto tiene dos permisos nuevos (`FOREGROUND_SERVICE` y `FOREGROUND_SERVICE_DATA_SYNC`) y
   declara el servicio del plugin de notificaciones: revisar el reporte del siguiente CI.
4. **Sesión exploratoria** con su evidencia en `docs/evidencias/` (regla del sprint).

## Huecos conocidos

- La notificación «esperando Wi-Fi» no trae el botón «Enviar ahora con datos»: al tocarla abre el detalle del
  reporte, que sí lo tiene.
- El listado de siniestros del servidor no devuelve el `idReporte`, así que «Mis siniestros» no puede emparejar un
  reporte recién enviado con su caso. El enviado se ve arriba con su radicado y se quita del teléfono a las 24 horas.
- Sin red se exige el GPS. Si el teléfono solo tiene la última posición conocida, se usa sin decir de cuándo es.
- «Usar correo y contraseña» en el desbloqueo (M02-01) cierra la sesión guardada pero no cierra la cuenta local: sus
  reportes siguen cifrados en el teléfono y vuelven a aparecer cuando esa cuenta entra de nuevo.
- La entrada sin red no se puede ensayar con `API_ENV=mock` (el servidor falso nunca falla al renovar la sesión). Se
  prueba con modo avión contra un backend real.
- Los umbrales de calidad de red (0,6 s y 2 s) están sin ajustar con un teléfono real.
- El código Kotlin del manifiesto y del servicio (del plugin `flutter_local_notifications`) no tiene pruebas
  instrumentadas propias.
