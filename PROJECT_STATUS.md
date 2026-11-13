# Estado del proyecto: Solventa Frontend Mobile

Última actualización: **2026-11-08** (verificado contra `develop` en `5ada135` + rama `feat/KAN-260-cobertura-mock`). Es la primera lectura de cada sesión.
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
`flutter_map` (OpenStreetMap), `geolocator`, `url_launcher`,
`alchemist` (goldens). La app no tiene base de datos local; `drift` queda planeado solo para HU offline
(`docs/arquitectura.md` §8).

## 3. Arquitectura (resumen; detalle en `docs/arquitectura.md`)

- Entrada: `lib/main.dart` (Sentry + `ProviderScope`) → `lib/app/solventa_app.dart` → `lib/app/router.dart`.
- `lib/core/`: `config` (flavors), `design_system` (tokens, tema, componentes `Sol*`, layouts, galería en debug),
  `network` (cliente GraphQL), `sesion` (`sesion_store.dart`, almacenamiento seguro), `errors` (`Resultado`/`Falla`),
  `log` (`SolLog`, `limpiar`), `l10n` (ARB ES/EN generado en `gen/`), `contrato` (esquema GraphQL).
- `lib/features/<feature>/{data,domain,presentation}`: `onboarding` (HU-M01), `acceso` (HU-M02, solo
  `presentation`), `claims` (HU-M05), `assistance` (HU-M06), `parametric` (HU-M04, en curso), `home` y `profile`.
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

- **HU-M02 (KAN-32), ingreso con biometría:** PRs #41, #43, #44, #51 y #55 en `develop`; validada con biometría real
  en emulador (#57, `docs/evidencias/2026-11-07-hu-m02-biometria-real.md`). Backend #511 (gracia del refresh).
- **HU-M05 (KAN-35) reporte de siniestro** (#38) y **HU-M06 (KAN-36) asistencia en sitio** (#37, #52): ver `CLAUDE.md`
  §Estado. Reporte HTML de Emuladores con capturas (#56: `integration_test/soporte/capturas.dart`,
  `tool/reporte-emuladores.py`).

### En curso: HU-M04 (KAN-38), siniestro paramétrico — contrato real y push (Fase 6, KAN-259)

Rama `feat/KAN-259-movil-indemnizacion-parametrica`, sobre lo ya hecho en `feat/KAN-260-cobertura-mock` (KAN-260 y
KAN-280). Plan, diseños, decisiones (M04-D1 a D5) y pendientes en [`docs/hu-m04/README.md`](docs/hu-m04/README.md).

- Hecho (datos mock, base): `lib/features/parametric/` con M04-02 (celebración), M04-03 (detalle) y M04-04 (Mi
  cobertura: sin saldo, a favor y en contra), textos ES/EN, íconos y formatos (`SolFormat.monthYear`, `monthName`,
  `maskedAccountFull`), pruebas, 30 goldens e `integration_test/cobertura_test.dart` con capturas.
- Hecho (Fase 6, KAN-259, sobre el contrato v0.48 del backend): `GqlCoberturaRemoteDataSource` real
  (`indemnizacion`/`miCoberturaParametrica`) con su mapper y query GraphQL; `cuentaDestino` pasó a
  `metodoTransferencia` (nunca un número de cuenta real, regla #6 del backend) en `Indemnizacion` y desapareció de
  `ResumenCobertura` (sin dato equivalente del backend); rutas `/m04-02/:id`, `/m04-03/:id` y `/m04-04` en
  `router.dart`, con un guardia nuevo que, sin sesión abierta, guarda el destino (`lib/core/push/
  pending_destination.dart`) y lo reanuda tras el login («el push como puerta de entrada»); `lib/core/push/
  push_service.dart` (`firebase_messaging` 16.x, `getToken`/`onTokenRefresh`) e `instalacion_id.dart`;
  `registrarTokenPush`/`actualizarPreferenciaPush` en AUTH vía el onboarding repository, con su interruptor en «Mi
  perfil»; entrada «Mi cobertura» nueva en el Home.
- **Sin `google-services.json` real** (regla del repo: nunca un secreto en el repo): `Firebase.initializeApp()`
  queda en `try/catch` y el push no se puede probar de punta a punta hasta que el usuario agregue ese archivo fuera
  del control de versiones; tampoco se aplicó el plugin `com.google.gms.google-services` en Gradle por la misma
  razón. El flujo de login → push-tap → M04-02 no tiene una prueba de integración de extremo a extremo todavía.
- Verificado en este entorno (Flutter 3.47.8 standalone, no el devcontainer — ver nota abajo): `flutter analyze`,
  `flutter test` (818 pruebas) y `tool/contrato.sh verificar`, todos en verde. Los 8 goldens que cambiaron por el
  nuevo texto de método de pago se regeneraron aquí mismo; conviene confirmarlos en la imagen del devcontainer antes
  de fusionar, por la fuente `Inter` (`docs/entorno-local.md`).
- Jira: KAN-280 (M04-04 · Mi cobertura) bajo KAN-38 (2026-11-08).

### En curso: pendientes de HU-M06 (KAN-36), por fases

Plan, bocetos, decisiones y ajustes (A1 a A12) en [`docs/hu-m06/plan-pendientes.md`](docs/hu-m06/plan-pendientes.md).
Las cinco fases quedaron en PR el 2026-11-12, cada una apilada sobre la anterior (integrar en orden):

| Fase | Mobile | Backend | Contrato |
|---|---|---|---|
| 1 · Grúa, detalle del prestador y color por aliado | #83 | #590 | v0.49 |
| 2 · Mapbox, pines, detalle, hoja arrastrable | #84 | — | — |
| 3 · Ubicación al entrar y dirección escrita ubicada | #85 | #591 | v0.50 |
| 4 · Rutas tipo semáforo y auditoría | #86 | #614 | v0.51 |
| 5 · «Mis asistencias», detalle, «Te alejaste» y notificación local | #89 | #615 | v0.52 |

Las versiones v0.46 a v0.48 las reserva el backend #589 (KAN-259). Pasos manuales: secreto `MAPBOX_PUBLIC_TOKEN` en
GitHub y `mapbox-token` en GCP (plan, Anexo B). Pendiente fuera de esta máquina: Emuladores, Mapbox real, teléfono
real, staging y el aviso de privacidad (A6).

### Pendiente

- HU-M04: confirmar los goldens regenerados en el devcontainer; `google-services.json` real (paso del usuario);
  prueba de integración del flujo push→login→detalle; moneda seleccionada y los datos de M04-03 que pide KAN-146
  (fuente, umbral, desglose, referencia). Lista completa en `docs/hu-m04/README.md`.
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

- **HU-M02:** las diferencias de M02 con Figma están en `docs/hu-m02-jira.md` (plantilla 5.4) y la decisión D6 sobre
  M02-01a en la evidencia del 2026-11-07.
- **Doc desactualizada:** `docs/ci-cd.md` §«Logs y errores en producción» todavía dice que Sentry está «Pendiente», aunque
  ya está implementado (ver `docs/plan-sentry.md`).
- **Textos quemados (incumplen la regla de l10n):** `assistance_placeholder_page.dart:15`, `home_page.dart:91` (el
  `localizedReason` de la biometría ya sale del catálogo desde el PR 3).
- **`integration_test/app_test.dart`** solo prueba que la app arranque. Falta el recorrido de HU-M01 que exige la regla.
- **`docs/evidencias/`** solo tiene la plantilla. Faltan las sesiones exploratorias de los sprints cerrados.
- `network_exceptions.dart`: `extensions.codigo` depende de que el BFF lo envíe (pendiente en el backend).

## 7. Prioridades actuales

1. HU-M04: PR de `feat/KAN-260-cobertura-mock` y reporte de Emuladores con las capturas de M04.
2. PR #58 abierto (KAN-31, reintento de verificación y cámara).
3. Deuda de reglas: textos a l10n, `integration_test` de HU-M01, evidencia exploratoria, `docs/ci-cd.md` (Sentry «hoy»).

## 8. Próximos pasos

1. Abrir el PR de HU-M04 hacia `develop` y lanzar Emuladores en la rama
   (`gh workflow run emuladores.yml --ref feat/KAN-260-cobertura-mock`), luego descargar `reporte-emuladores`.
2. En esta máquina solo se corre lo que cabe en la imagen del devcontainer (análisis, pruebas unitarias y de widget,
   goldens). Emuladores y teléfono real quedan para el CI o para el equipo.

## 9. Archivos de referencia

| Archivo | Responsabilidad |
|---|---|
| `lib/app/router.dart` | Rutas (`OnboardingRoutes`), `_RootShell`, rutas sin captura de pantalla |
| `lib/features/onboarding/presentation/onboarding_notifier.dart` | Estado y lógica de todo el onboarding, sesión y reintentos |
| `lib/features/onboarding/data/datasources/onboarding_remote_datasource.dart` | Llamadas GraphQL. `fake_…` es la versión mock |
| `lib/features/onboarding/data/repositories/onboarding_repository_impl.dart` | Mapeo de respuestas a `Resultado` |
| `lib/features/acceso/presentation/acceso_notifier.dart` | Fases de acceso (HU-M02), desbloqueo, bloqueo a los 5 min y `redirigirAcceso` |
| `lib/features/parametric/` y `docs/hu-m04/` | HU-M04 con datos mock: pantallas M04-02/03/04, cálculo del cupo, decisiones y pendientes |
| `lib/core/sesion/gestor_sesion.dart` | Dueño de la sesión: JWT en memoria, renovación con candado y gracia, desbloqueo, cierre |
| `lib/core/sesion/sesion_store.dart`, `llavero_sesion.dart` | Refresh cifrado con prefijo de ambiente; canal del llavero RSA |
| `android/.../LlaveroSesion.kt` | Par RSA del Keystore con ventana de autenticación de 10 s |
| `lib/core/config/app_config.dart` | Lectura de `FLAVOR`, `API_ENV`, `API_BASE_URL` y `SENTRY_DSN` |
| `lib/core/design_system/solventa_ui.dart` | Barrel del design system |
| `lib/core/l10n/` + `l10n.yaml` | Catálogos ES/EN |
| `docs/hu-m02-jira.md` | Qué y cómo registrar HU-M02 en Jira (mapa de issues, decisiones, plantillas, transiciones) |
| `tool/verificar.sh`, `tool/goldens.sh` | Verificación previa al PR y regeneración de goldens |

## 10. Handoff de sesión

- **Estado:** HU-M04 con datos mock en `feat/KAN-260-cobertura-mock` (commits a nombre de Uniandes, sin atribución a
  IA). En esta máquina se corrieron análisis, pruebas unitarias y de widget de HU-M04 y goldens en la imagen del
  devcontainer; no emuladores.
- **Última tarea:** pantallas M04-02, M04-03 y M04-04, pruebas, goldens e `integration_test` de HU-M04.
- **Sin terminar:** PR de HU-M04 y el reporte de Emuladores; los pendientes de producto están en
  `docs/hu-m04/README.md`.
- **Siguiente acción exacta:** push de la rama, PR a `develop` y lanzar Emuladores en la rama.
- **Entorno:** `/` estuvo lleno; Docker usa `overlay2` con `data-root` en
  `/media/darthefe/323c09a9-d3ed-40c6-890f-c4da812cb27b/tmp/docker` (containerd-snapshotter apagado). Comando base:
  `docker run --rm --platform linux/amd64 -v "$PWD":/w -w /w -v solventa-mobile-pub:/home/dev/.pub-cache --entrypoint bash ghcr.io/solventa-app/solventa-frontend-mobile-dev:latest -lc '…'`.
- **Archivos para la próxima sesión:** este archivo, `docs/hu-m04/README.md`, `lib/features/parametric/`.
