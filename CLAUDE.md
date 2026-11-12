# Solventa — App móvil (contexto de trabajo)

App Flutter de Solventa (aseguradora digital sobre Open Finance y Open Data), Proyecto Final de MISW4501. Este repo construye solo la **app móvil nativa para Android** (sin iOS ni PWA; decisión del equipo). La web vive en `../solventa-frontend-web` y el backend, el contrato y la infraestructura en `../solventa-backend`.

Mapa: [`README.md`](README.md) · Estado actual y contexto rápido: [`PROJECT_STATUS.md`](PROJECT_STATUS.md).

- Arquitectura de la app (fuente para agentes): [`docs/arquitectura.md`](docs/arquitectura.md) y [`docs/integracion-backend.md`](docs/integracion-backend.md).
- CI/CD, seguridad, ambientes, versionado y rollback: [`docs/ci-cd.md`](docs/ci-cd.md); diagramas en [`docs/diagramas.md`](docs/diagramas.md).
- Versiones y entorno local: [`docs/entorno-local.md`](docs/entorno-local.md).

## Reglas

- Todo comando de Flutter (pub, analyze, test, goldens, build, run) se corre **dentro del devcontainer** (`.devcontainer/`, Flutter 3.47.8). No regeneres goldens fuera de él (`tool/goldens.sh`).
- Antes de proponer un PR: `tool/verificar.sh` en verde (formato, análisis estricto y pruebas). El análisis es estricto (`strict-casts`, `strict-inference`, `strict-raw-types`): nada de `dynamic` implícito.
- Ramas `feat|fix|chore/KAN-N-descripcion` hacia `develop`; `release/sprint-N` y `hotfix/KAN-N-…` hacia `main`. Título del PR: `tipo(mobile): KAN-N descripción`; decide la versión (`feat` sube la menor, `fix` el parche).
- `docs/ci-cd.md` marca cada pieza como hoy, listo-falta-cuenta o pendiente. No describas algo pendiente como si existiera; si lo implementas, actualízalo en el mismo PR.
- Configuración por ambiente en `config/<flavor>.json` (claves `FLAVOR`, `API_BASE_URL`), leída en `lib/core/config/app_config.dart`. Nada secreto ahí: queda dentro del APK.
- Nunca un secreto en el repo: ni keystores, ni `key*.properties`, ni `google-services.json`.
- Datos personales solo en `flutter_secure_storage`, nunca en logs, breadcrumbs, reportes de error, consola ni almacenamiento sin cifrar. Nada de `print`; logs con `SolLog` (`lib/core/log/sol_log.dart`, [`docs/plan-sentry.md`](docs/plan-sentry.md)).
- Textos de pantalla en los catálogos de localización, no quemados en los widgets.
- Cada sprint cierra con una sesión exploratoria ([`docs/pruebas-exploratorias.md`](docs/pruebas-exploratorias.md)) y su evidencia en `docs/evidencias/`. Un hallazgo que se pueda automatizar se convierte en prueba en el PR que lo corrige.
- Cada HU con un recorrido agrega su prueba en `integration_test/` (corre en emuladores y en Test Lab).

## Estado

- Hoy: devcontainer obligatorio, flavors dev/prod, CI completo en el contenedor, Sonar en PRs y develop, seguridad (gitleaks, actionlint, osv-scanner, MobSF, Trivy), emuladores, CD con versión automática, R8 y Dart ofuscado, Release y rollback.
- Listo, falta cuenta: Firebase App Distribution y Test Lab. Google Play queda para el futuro (sin tienda por ahora).
- Hoy: Sentry (`sentry_flutter`, `SolLog`, `limpiar`, `SentryMask` en capturas y subida de símbolos en CD; organización `uniandes-xm`, [`docs/plan-sentry.md`](docs/plan-sentry.md)).
- `local_auth`, `flutter_secure_storage`, `camera`, `shared_preferences`, `sentry_flutter`, `mapbox_maps_flutter`, `geolocator`, `url_launcher`, `firebase_core` y `firebase_messaging` ya están en `pubspec.yaml` (KAN-259); el `google-services.json` nunca se sube al repo: el CI lo escribe desde el secreto `GOOGLE_SERVICES_JSON_BASE64` y el plugin de Gradle solo se aplica si existe; sin él el push de HU-M04 queda apagado (`lib/core/push/push_service.dart`). HU-M06 usa **Mapbox** (`mapbox_maps_flutter`, token público por `--dart-define=MAPBOX_ACCESS_TOKEN` desde el secreto `MAPBOX_PUBLIC_TOKEN`, nunca en el repo); reemplaza a `flutter_map` y OpenStreetMap (decisión D-M06, cambiada el 2026-11-10). Sin token: mapa falso en `mock` y lista sin mapa en el resto.
- HU-M06 (asistencia en sitio, `lib/features/assistance/`): mapa con los 3 prestadores más cercanos (M06-01, catálogo maestro v0.36) y, desde «Solicitar», formulario, envío idempotente por `idSolicitud`, reenvío, confirmada, no confirmada, cancelar y cancelada (M06-02 a M06-06, contrato v0.40). Desde la v0.49 el catálogo trae grúas y el detalle del prestador (aliado, especialidad, dirección, horario, foto) y el desenlace lo simula `stubs/prestadores` detrás del ACL. **Lo que falta (Mapbox, rutas, dirección ubicada, «Mis asistencias») y los ajustes al plan: [`docs/hu-m06/plan-pendientes.md`](docs/hu-m06/plan-pendientes.md)**, en curso por fases.
- HU-M05 (reporte de siniestro, `lib/features/claims/`): fotos con cámara en vivo y GPS, relato y envío idempotente por `idReporte` a `reportarSiniestro` (contrato v0.35); el caso llega PENDIENTE a la mesa de siniestros de HU-W04. Sin frames en Figma: pantallas M05-01 a M05-05 con el sistema de diseño. La ubicación (`lib/core/ubicacion/`) y la subida firmada (`lib/core/network/subida_archivo_service.dart`) son compartidas.
- Hoy: Flujo completo de acceso (`G-03`), registro con código OTP de 6 dígitos al correo (`M01-05b`, `M01-05c`), captura con vista previa de cámara en vivo centrada (`M01-03`..`M01-05`), validación facial en vivo con reintento en memoria sin perder las fotos de la cédula (`Opción B`), biometría del teléfono (`M01-08` con `local_auth`), selector de idioma (`ES`/`EN`) y 7 monedas (`COP`, `MXN`, `BRL`, `CLP`, `PEN`, `USD`, `EUR`), pantalla `Mi perfil` (`G-05`) y confirmación de cierre de sesión (`G-04`).
- Para generar capturas visuales legibles con fuente `Inter` (para revisión humana o `docs/Capturas_App_Completa.html`), correr dentro del devcontainer: `SOL_PLATFORM_GOLDENS=1 flutter test --update-goldens test/goldens/onboarding_goldens_test.dart test/goldens/layouts_golden_test.dart`. Los goldens deterministas de CI viven en `test/goldens/ci/`.
