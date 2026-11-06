# Estado del proyecto: Solventa Frontend Mobile

Última actualización: **2026-11-06** (verificado contra `develop` en `0cb2531` + rama `feat/KAN-227-sesion-refresh-hu-m02`). Es la primera lectura de cada sesión.
Las reglas permanentes viven en [`CLAUDE.md`](CLAUDE.md), la arquitectura en [`docs/arquitectura.md`](docs/arquitectura.md),
el contrato con el BFF en [`docs/integracion-backend.md`](docs/integracion-backend.md) y el CI/CD en
[`docs/ci-cd.md`](docs/ci-cd.md). Este archivo no las repite: describe el estado actual.

## 1. Identidad

- **Proyecto:** Solventa, una aseguradora digital sobre Open Finance y Open Data (Proyecto Final MISW4501, Uniandes).
- **Este repo:** solo la app nativa **Android** (sin iOS ni PWA). La web vive en `../solventa-frontend-web` y el backend en
  `../solventa-backend`.
- **Versión:** el último tag de CD es `v1.2.0+5`. En `pubspec.yaml` queda `1.0.0+1` porque CD calcula la versión desde los
  tags (`tool/version.sh`).
- **Proceso:** Jira KAN, GitFlow (`develop` → `release/sprint-N` → `main`). Sprint 3 en curso (`release/sprint-3` está al
  día con `develop`).

## 2. Stack

Flutter 3.47.8 / Dart ^3.13 (fijado; `tool/verificar-versiones.sh` lo controla contra el devcontainer). Riverpod 3,
`go_router` 18, Dio + `gql`/`graphql_codegen` (BFF GraphQL `/graphql/app`), `camera`, `image_picker`,
`permission_handler` 12, `local_auth`, `flutter_secure_storage`, `shared_preferences`, `sentry_flutter` + `sentry_dio`,
`alchemist` (goldens). La app no tiene base de datos local; `drift` queda planeado solo para HU offline
(`docs/arquitectura.md` §8).

## 3. Arquitectura (resumen; detalle en `docs/arquitectura.md`)

- Entrada: `lib/main.dart` (Sentry + `ProviderScope`) → `lib/app/solventa_app.dart` → `lib/app/router.dart`.
- `lib/core/`: `config` (flavors), `design_system` (tokens, tema, componentes `Sol*`, layouts, galería en debug),
  `network` (cliente GraphQL), `sesion` (`sesion_store.dart`, almacenamiento seguro), `errors` (`Resultado`/`Falla`),
  `log` (`SolLog`, `limpiar`), `l10n` (ARB ES/EN generado en `gen/`), `contrato` (esquema GraphQL).
- `lib/features/<feature>/{data,domain,presentation}`: `onboarding` (completa), `home`, `profile` y `assistance`
  (placeholder).
- Ambientes: `config/{mock,local,dev,prod}.json` con `--dart-define-from-file`. `API_ENV` vale `mock` por defecto
  (fakes, sin red).

## 4. Estado de la implementación

### Completado (en `develop`)

- **Raíz `/` (`_RootShell` en `router.dart`):** sin cuenta muestra `M0105bCuentaPage`, con un selector entre «Crear
  cuenta» e «Iniciar sesión» (`modoInicialLogin` tras cerrar sesión). Con cuenta muestra `SolAppShell` (Home + Asistencia
  + cerrar sesión).
- **Registro con OTP (`M01-05b`, `M01-05c`):** correo y clave, código de 6 dígitos al correo
  (`solicitarCodigoOnboarding` / `verificarCodigoOnboarding`), reenvío con espera y creación idempotente en
  `PENDIENTE_VERIFICACION`. Inicio de sesión con `iniciarSesion`.
- **KYC `M01-01`..`M01-08`:** bienvenida, autorización, frente y reverso de la cédula y prueba de vida con cámara en vivo
  centrada (`SolCameraFrame`/`SolLiveCameraFrame`). Las capturas se guardan solo en memoria y se suben en paralelo por URL
  firmada V4. Con **Opción B**, si solo falla el rostro (`ROSTRO_NO_COINCIDE`/`SUPLANTACION`), se repite únicamente la toma
  facial. Desenlaces `M01-07a/b/c` (verificada, en revisión `EC010`, rechazada con motivo y código de soporte). `M01-08`
  usa `local_auth` real.
- **Home:** antes de la verificación muestra el estado del onboarding. Una vez `VERIFICADA` llama `actualizarSesion`,
  consulta `yo` y saluda con el nombre del OCR.
- **Perfil `G-05` (`/perfil`, solo si está verificado) y cierre de sesión `G-04`** (`SolConfirmDialog`). Datos de solo
  lectura, documento enmascarado.
- **Preferencias:** `SolPreferenciasSheet` (ES/EN y 7 monedas) persistidas en `SharedPreferences`.
- **Sentry (`uniandes-xm`):** `SolLog`, `limpiar`, `SentryMask` y bloqueo de capturas en `M01-03`..`M01-05`, y subida de
  símbolos en `cd.yml`/`rollback.yml`.
- **CI/CD y seguridad:** según `docs/ci-cd.md` (estados «hoy»). 24 archivos de prueba (unitarias, widget, contrato,
  goldens CI en `test/goldens/ci/`).

### En curso: HU-M02 (KAN-32), ingreso con biometría

Plan: `~/Downloads/hu-m02-paquete/plan-HU-M02-integracion-M01.md`. **Solo se escribe código (app y pruebas) sin ejecutar
pruebas ni goldens: otro compañero valida.** Ramas apiladas (cada una sale de la anterior), push hecho; los PRs los abre
el usuario:

| PR | Rama | Estado |
|---|---|---|
| 1 backend | `solventa-backend` `feat/KAN-227-refresh-gracia-hu-m02` | Hecho: gracia de 30 s en AUTH, pytest y Newman `hu-m02` (sin correr) |
| 2 mobile sesión | `feat/KAN-227-sesion-refresh-hu-m02` | Hecho: contrato v0.37, `lib/core/sesion/` (llavero RSA, almacén cifrado, `GestorSesion`), renovación en `GraphqlClient`, M01 guarda el refresh, cierre revoca. Codegen y `flutter analyze` en verde; pruebas sin correr |
| 3 mobile biometría | `feat/KAN-225-…` | Pendiente: `BiometriaService` en `core` con los estados de §3.6, «Ir a ajustes» nativo, M01-08, arranque con refresh |
| 4 mobile pantallas | `feat/KAN-226-…` | Pendiente: M02-01, M02-01a, M02-03 (sin M02-02/02b), bloqueo a los 5 min en segundo plano, goldens e `integration_test/hu_m02_test.dart` |
| 5 e2e | — | No se hace (decisión del usuario) |

### En curso (ramas remotas sin fusionar, de Frans, 2026-11-05)

- `feat/KAN-36-asistencia-en-sitio`: mapa de prestadores cercanos `M06-01`, con el catálogo desde el BFF (contrato
  v0.36).
- `feat/KAN-35-reporte-siniestro` (incluye KAN-36): reporte de siniestro con cámara y GPS `M05-01`..`M05-05` y «Mis
  siniestros» `M05-06`.

### Pendiente

- Integrar HU-M05 y HU-M06 en `develop` y reemplazar `AssistancePlaceholderPage`. `onRequestAssistance` en Home hoy es
  `() {}`.
- Dependencias de las próximas HU: `geolocator`, `google_maps_flutter` y `firebase_messaging` (no están en `develop`).
- Firebase App Distribution y Test Lab: listos, falta la cuenta. Google Play queda para el futuro.
- Goldens horizontales de 640 × 360 (`docs/ci-cd.md`).

## 5. Decisiones técnicas que hay que conservar

- **HU-M02 (2026-11-06):** D1 el PIN del teléfono también desbloquea; D2 sin M02-02/02b (el PIN va por el diálogo del
  sistema); D3 refresh cifrado con RSA del Keystore, privada con ventana de 10 s; D4 (huella nueva) queda como deuda;
  D5 sin PIN propio. JWT solo en memoria. Bloqueo tras 5 min en segundo plano. Detalle y deuda en
  `docs/arquitectura.md` §8; sesión en `docs/integracion-backend.md` §7.
- Solo Android, por decisión del equipo. Todo Flutter corre en el devcontainer para tener goldens y CI reproducibles.
- `API_ENV=mock` por defecto: la app nunca apunta a un backend por accidente.
- Las imágenes de identidad se guardan solo en memoria o en un temporal y se borran al terminar. No se persisten.
- Opción B: el reintento facial conserva la cédula y así evita volver a capturarla.
- Datos personales solo en `flutter_secure_storage`. Logs solo con `SolLog`/`limpiar`. Nada de `print`.
- Dependabot no propone `permission_handler` 13.x mientras el devcontainer use Android API 36 (KAN-31).

## 6. Problemas conocidos y deuda

- **HU-M02:** el contrato de mobile salta a v0.37 desde `develop`; la rama KAN-35/36 de Frans lo sincronizó a v0.36: quien
  fusione segundo resuelve el conflicto en `schema.graphql` y lo generado. La sesión vencida vuelve a «Inicia sesión»
  solo desde `/` (las rutas apiladas no se cierran todavía; llega con el PR 4).
- **Doc desactualizada:** `docs/ci-cd.md` §«Logs y errores en producción» todavía dice que Sentry está «Pendiente», aunque
  ya está implementado (ver `docs/plan-sentry.md`).
- **Textos quemados (incumplen la regla de l10n):** `assistance_placeholder_page.dart:15`, `home_page.dart:91` y el
  `localizedReason` en `biometria_service.dart:28`.
- **`integration_test/app_test.dart`** solo prueba que la app arranque. Falta el recorrido de HU-M01 que exige la regla.
- **`docs/evidencias/`** solo tiene la plantilla. Faltan las sesiones exploratorias de los sprints cerrados.
- `network_exceptions.dart`: `extensions.codigo` depende de que el BFF lo envíe (pendiente en el backend).

## 7. Prioridades actuales

1. HU-M02: PR 3 (biometría compartida, M01-08 y arranque) y PR 4 (pantallas M02).
2. Revisar y fusionar KAN-36 y KAN-35 (Frans).
3. Deuda de reglas: textos a l10n, `integration_test` de HU-M01, evidencia exploratoria, `docs/ci-cd.md` (Sentry «hoy»).

## 8. Próximos pasos

1. Crear `feat/KAN-225-biometria-compartida-hu-m02` desde la rama del PR 2 y hacer F4 y F8–F10 del plan.
2. Luego `feat/KAN-226-pantallas-m02` (leer cada frame de Figma: archivo `2ahgOpwsejNnxZl57v4o9D`, nodos 2005:565,
   2005:472, 2005:499; M01-08 2001:673).
3. Codegen, `dart format` y `flutter analyze` en la imagen `ghcr.io/solventa-app/solventa-frontend-mobile-dev` (Docker
   guarda todo en el disco grande; ver sección 10). No correr pruebas ni goldens.

## 9. Archivos de referencia

| Archivo | Responsabilidad |
|---|---|
| `lib/app/router.dart` | Rutas (`OnboardingRoutes`), `_RootShell`, rutas sin captura de pantalla |
| `lib/features/onboarding/presentation/onboarding_notifier.dart` | Estado y lógica de todo el onboarding, sesión y reintentos |
| `lib/features/onboarding/data/datasources/onboarding_remote_datasource.dart` | Llamadas GraphQL. `fake_…` es la versión mock |
| `lib/features/onboarding/data/repositories/onboarding_repository_impl.dart` | Mapeo de respuestas a `Resultado` |
| `lib/core/sesion/gestor_sesion.dart` | Dueño de la sesión: JWT en memoria, renovación con candado y gracia, desbloqueo, cierre |
| `lib/core/sesion/sesion_store.dart`, `llavero_sesion.dart` | Refresh cifrado con prefijo de ambiente; canal del llavero RSA |
| `android/.../LlaveroSesion.kt` | Par RSA del Keystore con ventana de autenticación de 10 s |
| `lib/core/config/app_config.dart` | Lectura de `FLAVOR`, `API_ENV`, `API_BASE_URL` y `SENTRY_DSN` |
| `lib/core/design_system/solventa_ui.dart` | Barrel del design system |
| `lib/core/l10n/` + `l10n.yaml` | Catálogos ES/EN |
| `tool/verificar.sh`, `tool/goldens.sh` | Verificación previa al PR y regeneración de goldens |

## 10. Handoff de sesión

- **Estado:** PR 1 (backend) y PR 2 (mobile, sesión) con push hecho; falta que el usuario abra los PRs. Nada se ejecutó
  salvo codegen, formato y análisis.
- **Última tarea:** PR 2 de HU-M02 (`feat/KAN-227-sesion-refresh-hu-m02`).
- **Sin terminar:** PR 3 y PR 4. Pendiente del usuario: anotar en Jira que M02-02/02b (KAN-136, KAN-174) salen por D2.
- **Siguiente acción exacta:** PR 3, rama desde la del PR 2.
- **Entorno:** `/` estuvo lleno; Docker usa `overlay2` con `data-root` en
  `/media/darthefe/323c09a9-d3ed-40c6-890f-c4da812cb27b/tmp/docker` (containerd-snapshotter apagado). Comando base:
  `docker run --rm --platform linux/amd64 -v "$PWD":/w -w /w -v solventa-mobile-pub:/home/dev/.pub-cache --entrypoint bash ghcr.io/solventa-app/solventa-frontend-mobile-dev:latest -lc '…'`.
- **Archivos para la próxima sesión:** este archivo, el plan del paquete, `lib/core/sesion/`, `lib/app/router.dart`,
  `lib/features/onboarding/presentation/pages/m01_08_biometria_page.dart`.
