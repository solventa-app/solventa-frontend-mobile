# Solventa — App móvil (contexto de trabajo)

App Flutter de Solventa (aseguradora digital sobre Open Finance y Open Data), Proyecto Final de MISW4501. Este repo construye solo la **app móvil nativa para Android** (sin iOS ni PWA; decisión del equipo). La web vive en `../solventa-frontend-web` y el backend, el contrato y la infraestructura en `../solventa-backend`.

Mapa: [`README.md`](README.md). CI/CD, seguridad, ambientes, versionado y rollback: [`docs/ci-cd.md`](docs/ci-cd.md). Versiones y entorno local: [`docs/entorno-local.md`](docs/entorno-local.md).

## Reglas

- `docs/ci-cd.md` y `docs/entorno-local.md` separan **hoy** de **plan**. No describas algo del plan como si ya existiera. Si implementas algo del plan, pásalo a **hoy** en el mismo PR.
- Ramas `feat|fix|chore/KAN-N-descripcion` hacia `develop`. Título del PR: `tipo(mobile): KAN-N descripción`. Los checks `mobile`, `Título del PR` y `Nombre de rama` son obligatorios.
- Cuando exista `.devcontainer/`, todo comando de Flutter (pub, analyze, test, goldens, build, run) se corre dentro del contenedor. No regeneres goldens fuera de él.
- Antes de proponer un PR: `dart format --output=none --set-exit-if-changed .`, `flutter analyze` y `flutter test` en verde.
- Nunca un secreto en el repo: ni keystores, ni `key.properties`, ni contraseñas en `config/*.json` (todo lo que va en `--dart-define` queda dentro del APK).
- Datos personales solo en `flutter_secure_storage`, nunca en logs, breadcrumbs, reportes de error, consola ni almacenamiento sin cifrar. Nada de `print`; logs con `SolLog` cuando exista ([`docs/observabilidad.md`](docs/observabilidad.md)).
- Textos de pantalla en los catálogos de localización, no quemados en los widgets.

- Cada sprint cierra con una sesión exploratoria ([`docs/pruebas-exploratorias.md`](docs/pruebas-exploratorias.md)) y su evidencia en `docs/evidencias/`. Un hallazgo que se pueda automatizar se convierte en prueba en el PR que lo corrige.

## Estado

- CI: format, analyze y test con cobertura en cada PR. CD: APK + AAB firmados y GitHub Release en cada merge a `main`.
- Plan de CI/CD acordado (flavors dev/prod, Flutter 3.47.8 fijo, devcontainer obligatorio en local y CI, App Distribution, Test Lab, seguridad, versionado automático y rollback): ver `docs/ci-cd.md`. Sonar lo monta quien lo hizo en web y backend.
- Las librerías de las HU móviles (`local_auth`, `flutter_secure_storage`, `camera`, `geolocator`, `google_maps_flutter`, `firebase_messaging`) todavía no están en `pubspec.yaml`.
