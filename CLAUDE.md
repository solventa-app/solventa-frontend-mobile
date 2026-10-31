# Solventa — App móvil (contexto de trabajo)

App Flutter de Solventa (aseguradora digital sobre Open Finance y Open Data), Proyecto Final de MISW4501. Este repo construye solo la **app móvil nativa para Android** (sin iOS ni PWA; decisión del equipo). La web vive en `../solventa-frontend-web` y el backend, el contrato y la infraestructura en `../solventa-backend`.

Mapa: [`README.md`](README.md).

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
- Datos personales solo en `flutter_secure_storage`, nunca en logs, breadcrumbs, reportes de error, consola ni almacenamiento sin cifrar. Nada de `print`; logs con `SolLog` cuando exista ([`docs/plan-sentry.md`](docs/plan-sentry.md)).
- Textos de pantalla en los catálogos de localización, no quemados en los widgets.
- Cada sprint cierra con una sesión exploratoria ([`docs/pruebas-exploratorias.md`](docs/pruebas-exploratorias.md)) y su evidencia en `docs/evidencias/`. Un hallazgo que se pueda automatizar se convierte en prueba en el PR que lo corrige.
- Cada HU con un recorrido agrega su prueba en `integration_test/` (corre en emuladores y en Test Lab).

## Estado

- Hoy: devcontainer obligatorio, flavors dev/prod, CI completo en el contenedor, Sonar en PRs y develop, seguridad (gitleaks, actionlint, osv-scanner, MobSF, Trivy), emuladores, CD con versión automática, R8 y Dart ofuscado, Release y rollback.
- Listo, falta cuenta: Firebase App Distribution y Test Lab. Google Play queda para el futuro (sin tienda por ahora).
- Pendiente: Sentry ([`docs/plan-sentry.md`](docs/plan-sentry.md)).
- Las librerías de las HU móviles (`local_auth`, `flutter_secure_storage`, `camera`, `geolocator`, `google_maps_flutter`, `firebase_messaging`) todavía no están en `pubspec.yaml`.
