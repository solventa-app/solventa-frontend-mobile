# HU-M05 · Reporte de siniestro de punta a punta (2026-11-05)

KAN-35 (HU-M05) · KAN-278. El cliente reporta un siniestro desde la app y el caso llega `PENDIENTE` a la mesa de
siniestros de HU-W04 (KAN-27). Probado contra el **backend real en local**, no contra el fake.

## Entorno

| Pieza | Versión |
|---|---|
| Backend | `solventa-backend` rama `feat/KAN-35-reporte-siniestro` (PR #503), `docker compose --profile servicios up` (gateway `:8080`, contrato v0.35, CLAIMS migración `0004`) |
| Semillas | `crear-cliente-siniestros-demo` (cliente demo verificado), `sembrar-polizas-demo` (su póliza) y `sembrar-siniestros` (los 20 casos de la mesa) |
| App | rama `feat/KAN-35-reporte-siniestro` (PR #38), APK `dev` con `config/local.json` (`API_BASE_URL=http://10.0.2.2:8080`) |
| Dispositivo | Emulador Pixel 8a, Android 16 (API 36) con Google Play; GPS fijado con `adb emu geo fix -74.0483 4.6767` |
| Almacenamiento | `fake-gcs`; las URLs firmadas (`localhost:4443`) llegan al emulador con `adb reverse tcp:4443 tcp:4443` |

Cliente demo (datos inventados, solo local): `cliente.siniestros@demo.solventa.co` / `Cliente-local-1`.

## Recorrido y resultado

| Paso | Resultado |
|---|---|
| Iniciar sesión con el correo del cliente demo | «Hola, María Fernanda Ríos» · Identidad verificada |
| Inicio → «Reportar un siniestro» (M05-01) | Aparece su póliza real **SOL-2026-000021**, vigente hasta el 1 ene 2027 |
| Póliza y fecha → Continuar (M05-02) | Primero el permiso de ubicación y la precisión de Google; luego la cámara en vivo. «Ubicación lista: tus fotos quedan geoetiquetadas» |
| Tomar fotos → relato, lugar y ciudad (M05-03) → Enviar | «Recibimos tu reporte · Tu caso **SIN-2026-1001** quedó pendiente de revisión… a más tardar el **9 nov 2026**» (jueves + 2 días hábiles, W04-7) |

Del lado del operador, con `admin.solventa` por `/graphql/web` (la misma API de la bandeja web):

- `siniestros(estado: PENDIENTE)`: el caso nuevo es el primero (8 pendientes).
- `siniestro(id)` trae lo que la mesa necesita:
  - Asegurado María Fernanda Ríos con su documento, que el BFF toma de AUTH y no de la app.
  - Póliza SOL-2026-000021 con cobertura de 45.000.000 COP, y esa misma suma reclamada.
  - Ubicación «Cra 15 con Calle 93, Bogota» en 4.6767, -74.0483, y el relato.
  - `entidadAcreedora` «Por confirmar con el asegurado».
  - **3 evidencias `FOTO` geoetiquetadas** («4.6767, -74.0483 · tomada en la app»).
- La URL firmada de la primera foto descarga un JPEG de 640×480 de la cámara del emulador. Esa es la foto que ve el
  operador.

## El cliente ve el estado que da la mesa (M05-06 «Mis siniestros»)

Como operador, por `/graphql/web`, se **aprobó SIN-2026-1001**, con la orden de PAYMENTS por 45.000.000 COP, y se
**rechazó SIN-2026-1002** con el motivo `EVIDENCIA_INSUFICIENTE`. En la app, Inicio → «Mis siniestros» (`misSiniestros`)
muestra los 4 reportes del cliente:

| Radicado | Estado en la app | Detalle |
|---|---|---|
| SIN-2026-1004 | Pendiente | «Lo revisaremos a más tardar el 9 nov 2026» |
| SIN-2026-1003 | Pendiente | ídem |
| SIN-2026-1002 | Rechazado | «Te enviamos el motivo y cómo presentar un recurso» |
| SIN-2026-1001 | Aprobado | «Tu indemnización está en proceso de pago» |

## Hallazgos corregidos en esta sesión

En el primer intento, M05-02 pedía a la vez el permiso de cámara y el de ubicación. Android muestra uno solo, y la
solicitud de ubicación quedó colgada: el permiso seguía en `granted=false`, no aparecía ningún aviso y «Continuar» nunca
se habilitaba. Ahora la página pide primero la ubicación y abre la cámara cuando esa solicitud termina
(`VisorCamaraReporte.habilitada`). Además, mientras se espera la ubicación no se puede tomar foto.

**«Volver al inicio» abría «Cerrar sesión»** (lo reportó el usuario). Con un toque rápido, M05-05 navegaba al inicio
dentro del mismo gesto, y la barra inferior del inicio recibía ese toque: encima de «Cerrar sesión» abría el cierre de
sesión y en el centro abría «Asistencia». Con el dedo apoyado más tiempo no pasaba. Ahora la navegación ocurre en el
cuadro siguiente, con el gesto ya terminado. Verificado con el mismo toque rápido: lleva a Inicio. El mismo patrón
existe en M01-07 (`context.go('/')` dentro del toque) y queda para revisarse.

## Pendiente

- La geoetiqueta viaja como dato de cada evidencia. Leer el EXIF en el servidor es W04-14, todavía pendiente en el
  backend.
- Newman del reporte en `solventa-backend`.
- `integration_test/reporte_siniestro_test.dart` compila e instala en el emulador desde el devcontainer, pero el runner
  no alcanza el puerto de depuración de la app (`Connection refused`: el reenvío queda en el `adb` de la Mac, no en el
  contenedor). Corre en el emulador propio del CI (`emuladores.yml`).
- Al cerrar y abrir la app con `config/local.json` se pierde la sesión y vuelve a «Crea tu cuenta». No es de HU-M05;
  queda para revisarse.
