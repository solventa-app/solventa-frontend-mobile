# CI/CD de la app móvil

Cómo se construye, se prueba, se versiona y se publica la app. Cada sección marca qué existe **hoy** en el repo y qué es **plan** (acordado, falta el PR). Quien implemente algo del plan actualiza este documento en el mismo PR.

Referencias: Estrategia de Pruebas v4 (granja de dispositivos, distribución OTA, SAST, evidencias) y la sección 4 del documento de arquitectura (frameworks y ambientes). Las prácticas siguen las de `solventa-frontend-web` y `solventa-backend`.

## Resumen

| Momento | Hoy | Plan |
|---|---|---|
| PR a `develop` | `Título del PR`, `Nombre de rama` y el job `mobile`: `dart format`, `flutter analyze`, `flutter test --coverage` | El job `mobile` corre dentro de la imagen del devcontainer (la misma que se usa en local). Además: build del APK `dev`, gitleaks, osv-scanner, actionlint |
| Merge a `develop` | El mismo job `mobile` | Además: APK `dev` firmado a Firebase App Distribution (grupo `qa`), MobSF sobre ese APK, Firebase Test Lab, Sonar |
| PR a `main` | Los mismos checks que hacia `develop` | Igual |
| Merge a `main` | `cd.yml`: APK + AAB firmados, artifact de 30 días y GitHub Release `v<versión>+<build>` | Build `prod` ofuscado, versión calculada sola, AAB a la pista interna de Google Play, Release con símbolos |
| Manual | Nada | `rollback` (recompila un tag anterior), Test Lab bajo demanda, CD de prueba desde otra rama sin Release |

## Flujo de ramas

**Hoy** (`.github/workflows/pr-rama.yml`):

| Origen | Destino |
|---|---|
| `feat\|fix\|chore/KAN-N-descripcion` | `develop` |
| `develop` o `fix/KAN-N-descripcion` | `main` |
| `main` | `develop` (reintegración) |

**Plan**, igual que el web: `release/sprint-N` (solo recibe `fix|chore`) o `hotfix/KAN-N-descripcion` hacia `main`; `main` hacia `develop` tras cada release o hotfix. Squash hacia `develop`, merge commit hacia `main`.

Título del PR (`pr-titulo.yml`): `tipo(alcance): KAN-N descripción`. Tipos: `feat fix refactor test docs chore ci` (plan: sumar `infra`, como el web). Alcances: `mobile contrato docs ci`. El título es el mensaje del commit al hacer squash y, en el plan, también decide la próxima versión.

## Workflows

| Archivo | Cuándo | Qué hace | Estado |
|---|---|---|---|
| `ci.yml` | Todo PR y push a `develop` | Job `mobile`: format, analyze, test con cobertura (artifact `coverage`) | Hoy |
| `pr-titulo.yml` | PR abierto o editado | Valida el título | Hoy (plan: eximir a Dependabot por `pull_request.user.login`, no por `github.actor`) |
| `pr-rama.yml` | PR abierto o editado | Valida rama y destino | Hoy |
| `cd.yml` | Push a `main` | APK + AAB firmados y GitHub Release | Hoy |
| `dependabot-auto-merge.yml` | PR de Dependabot | Aprueba y arma auto-merge de patch y minor | Hoy |
| `distribucion.yml` | Push a `develop` | APK `dev` a Firebase App Distribution | Plan |
| `emuladores.yml` | Push a `develop` | `integration_test` en emuladores de GitHub Actions: teléfono pequeño (API 28), teléfono grande (API 34) y tablet (API 34). Corre directo en el runner (necesita KVM), con la misma versión de Flutter | Plan |
| `test-lab.yml` | Manual, en cada `release/sprint-N` | Firebase Test Lab en 3 teléfonos reales: Robo test e `integration_test` | Plan |
| `seguridad.yml` (o jobs en `ci.yml`) | PR y push a `develop` | gitleaks, osv-scanner, MobSF, actionlint | Plan |
| `sonar.yml` | Push a `develop` y manual | SonarCloud con la cobertura de `flutter test` | Plan (lo monta quien lo hizo en web y backend) |
| `rollback.yml` (o entrada manual de `cd.yml`) | Manual | Recompila un tag anterior con un build nuevo | Plan |
| `imagen-devcontainer.yml` | Push a `develop` que toque `.devcontainer/` y manual | Construye la imagen del devcontainer, la revisa con Trivy (informativo) y la publica en el GitHub Container Registry (`ghcr.io/solventa-app/solventa-frontend-mobile-dev`), con etiqueta = versión de Flutter. Los demás jobs la usan con `container:` | Plan |

Ningún check filtra por rutas: los checks obligatorios deben reportar en todos los PR.

## Linter y formato

**Hoy:**

- Reglas: `analysis_options.yaml` incluye `package:flutter_lints/flutter.yaml` (el conjunto recomendado oficial de Flutter, nivel medio) sin reglas propias, y excluye `build/`, `android/` e `ios/`.
- CI: el job `mobile` corre `dart format --output=none --set-exit-if-changed .` y `flutter analyze`. `flutter analyze` falla con cualquier hallazgo, incluidos los de nivel info. Como `mobile` es check obligatorio, un PR con formato o hallazgos no se puede integrar.
- Local: no hay hook de git ni configuración de editor en el repo; cada quien corre los comandos a mano.

Comparado con el web: ESLint ↔ `flutter analyze`, Prettier ↔ `dart format`, `vue-tsc` ↔ el analizador de Dart (los tipos se revisan en el mismo `flutter analyze`). El web tampoco tiene hooks de git.

**Plan:**

| Qué | Cómo | Por qué |
|---|---|---|
| Analizador estricto | En `analysis_options.yaml`: `strict-casts`, `strict-inference` y `strict-raw-types` | Lo mismo que hace el modo estricto de TypeScript en el web: evita `dynamic` escondidos |
| Reglas extra sobre `flutter_lints` | `unawaited_futures`, `avoid_dynamic_calls`, `cancel_subscriptions`, `close_sinks`, `prefer_final_locals`, `prefer_single_quotes`, `directives_ordering`, `always_declare_return_types` | Errores típicos de async y de recursos que el conjunto recomendado no marca. No se usa `very_good_analysis` completo: es muy estricto para el tiempo del proyecto |
| Formato y correcciones al guardar | `devcontainer.json` configura VS Code: `editor.formatOnSave`, `source.fixAll` y `source.organizeImports` al guardar, ancho de línea 80 | Que nadie llegue al CI con formato roto |
| Hook antes del push (opcional) | `lefthook.yml` con `dart format --set-exit-if-changed` y `flutter analyze` en `pre-push`; corre dentro del contenedor porque git se usa desde ahí | Falla en tu máquina antes de esperar el CI |

Las reglas nuevas se activan en un PR propio que también corrige lo que marquen.

## Protección de ramas y revisión

| Pieza | Qué hace | Estado |
|---|---|---|
| Rulesets (`.github/rulesets/`) | `main` y `develop`: PR obligatorio, 1 aprobación, aprobaciones viejas se descartan con cada push, hilos resueltos, sin borrado ni force-push, checks `mobile`, `Título del PR` y `Nombre de rama`. `main` solo merge commit; `develop` squash o merge. Tags `sprint-*` inmutables | Hoy (los JSON son referencia: el ruleset real se edita en Settings → Rules) |
| Plantilla de PR | Definición de hecho de cada PR | Hoy |
| CODEOWNERS | Revisores automáticos por carpeta | Hoy comentado, falta poner los usuarios |
| Auto-merge de Dependabot | Patch y minor se aprueban e integran solos cuando los checks pasan | Hoy (requiere permitir que Actions apruebe PRs en Settings) |

## Pruebas

| Tipo | Herramienta | Dónde corre | Estado |
|---|---|---|---|
| Unitarias y de widget | `flutter_test` | Local y CI, en cada PR | Hoy |
| Goldens (comparación visual) | `flutter_test` + alchemist | Local y CI | Llega con el PR del sistema de diseño (KAN-239) |
| Accesibilidad (contraste, tap targets) | `meetsGuideline` de `flutter_test` | Local y CI | Llega con KAN-239 |
| Goldens en varios tamaños | alchemist | Cada PR, en el contenedor | KAN-239 trae 360 y 390 dp con texto al 100 % y 200 %; plan: sumar 320, 412, 600 y 840 dp y horizontal |
| Overflow por tamaño | `tester.view.physicalSize` y `textScaler` en `flutter_test` | Cada PR | KAN-239 lo hace en algunos componentes; plan: en cada pantalla nueva |
| Integración en emuladores | `integration_test` | GitHub Actions, push a `develop` | Plan |
| Integración y exploración en dispositivos reales | `integration_test` y Robo test | Firebase Test Lab, cada release | Plan |
| Exploratoria manual | Guía y plantilla | Una sesión por sprint | Hoy el proceso ([`pruebas-exploratorias.md`](pruebas-exploratorias.md)); plan: `device_preview` y APK por App Distribution |
| Resiliencia sin conexión (OFFLINE_STORE) | `flutter_test` con dobles del cliente HTTP; modo avión en Test Lab | CI y Test Lab | Plan, con las HU de billetera y siniestros |
| Biometría, cámara, GPS, push, Wallet | Dobles de los plugins en `flutter_test`; dispositivo real en Test Lab | CI y Test Lab | Plan, con cada HU |

La evidencia de cada prueba manual o de dispositivo va en [`docs/evidencias/`](evidencias/README.md), con nombre, fecha, escenario, dispositivo y vínculo a la HU, igual que en el web.

## Granja de dispositivos

Tres niveles, todos sin costo. Ninguno corre dentro de la imagen del devcontainer: los dispositivos necesitan hardware o viven en la nube.

| Nivel | Qué es | Cuándo | Costo | Estado |
|---|---|---|---|---|
| Emuladores en GitHub Actions (`reactivecircus/android-emulator-runner`) | Emuladores Android en el runner de Linux, con una matriz de tamaños y versiones | Cada push a `develop` | Gratis (repo público) | Plan |
| Firebase Test Lab, Robo test | Un robot recorre la app sin pruebas escritas: toca, llena campos, toma capturas y video, reporta cierres y ANR. En Flutter se guía por el árbol de semántica, así que explora mejor si los widgets tienen `Semantics` | Manual, en cada `release/sprint-N`, en 3 teléfonos reales de marcas y tamaños distintos | Plan Spark gratis (a la fecha, unas 10 pruebas al día en virtuales y 5 en físicos; verificar en la consola de Firebase) | Plan |
| Firebase Test Lab, `integration_test` | Nuestras pruebas de recorrido en teléfonos reales | Junto al Robo, en cada release | La misma cuota | Plan |

BrowserStack y AWS Device Farm quedan descartados: duplican Test Lab y son de pago. El resultado de cada corrida de Test Lab (enlace a la consola, capturas de fallos) se anota en `docs/evidencias/`.

## Responsive y adaptabilidad

| Capa | Herramienta | Cuándo |
|---|---|---|
| Goldens en varios tamaños y escalas de texto | alchemist | Cada PR |
| Sin overflow ni texto cortado por tamaño | `flutter_test` con `physicalSize` y `textScaler` | Cada PR |
| Accesibilidad (tap targets, contraste, etiquetas) | `meetsGuideline` | Cada PR |
| Comportamiento real (teclado, rotación, barras del sistema) | `integration_test` en emuladores de varios tamaños | Push a `develop` |
| Marcas, densidades y versiones de Android reales | Test Lab | Cada release |
| Lo que la automatización no ve (fricción, textos, flujo) | Sesión exploratoria con `device_preview`, Accessibility Scanner y los teléfonos del equipo | Una vez por sprint ([`pruebas-exploratorias.md`](pruebas-exploratorias.md)) |

## Seguridad

Todo lo nuevo arranca **informativo** (no bloquea el check) y pasa a obligatorio cuando no queden hallazgos, como hicieron web y backend.

| Control | Qué es | Cómo se usa aquí | Estado |
|---|---|---|---|
| Dependabot | Abre PRs cuando hay versiones nuevas o vulnerables de paquetes pub y de GitHub Actions | `.github/dependabot.yml`, hacia `develop`. Patch y minor se integran solos | Hoy |
| osv-scanner | Revisa `pubspec.lock` contra la base de vulnerabilidades OSV de Google | Job en cada PR; falla si hay una vulnerabilidad conocida en una dependencia (al principio solo avisa) | Plan |
| gitleaks | Busca secretos (llaves, contraseñas, tokens) en **todo el historial** de git | Mismo job que el backend. Importa por `key.properties`, keystores y `google-services.json` | Plan |
| MobSF | Análisis estático del APK compilado: permisos, manifest, cifrado, llaves embebidas, librerías inseguras | Corre en Docker sobre el APK `dev` de cada push a `develop`; el reporte queda como artifact | Plan |
| actionlint | Valida la sintaxis y las expresiones de los workflows | Job en cada PR que toque `.github/` | Plan |
| Acciones fijadas por SHA | `uses: accion@<sha> # vX` en vez de `@vX`, para que nadie cambie la acción por debajo | Dependabot las sigue actualizando | Plan |
| SonarCloud | Calidad, deuda técnica y SAST; analiza Dart | Ver tabla de workflows | Plan |
| Secret scanning y push protection | Funciones de GitHub que bloquean un push con un secreto conocido | Se activan en Settings → Code security | Plan (configuración, no código) |
| Endurecimiento del build de prod | R8 (`isMinifyEnabled`, `isShrinkResources`), `--obfuscate --split-debug-info`, `android:allowBackup="false"`, sin tráfico en claro | `android/app/build.gradle.kts` y manifest de `prod` | Plan |

DAST (OWASP ZAP) corre en el backend contra el API Gateway; el plan es que también cubra el BFF móvil.

Regla: nada secreto en el código ni en `config/*.json`. Todo lo que entra con `--dart-define` queda dentro del APK.

## Ambientes dev y prod

**Hoy** hay una sola app (`com.solventa.solventa_mobile`) y un solo juego de secretos de firmado.

**Plan** (flavors de Android + `--dart-define-from-file`):

| | dev | prod |
|---|---|---|
| Paquete Android | `com.solventa.solventa_mobile.dev` | `com.solventa.solventa_mobile` |
| Nombre en el teléfono | Solventa Dev | Solventa |
| Versión visible | `1.3.0-dev.214` | `1.3.0` |
| Configuración | `config/dev.json` (URL del backend de pruebas, `FLAVOR=dev`) | `config/prod.json` |
| Firmado | Keystore de dev, environment `dev` | Keystore de subida, environment `production` |
| Se entrega por | Firebase App Distribution | GitHub Release + Google Play |
| Ofuscado | No | Sí |

Como el paquete es distinto, Android le da a cada app su propio espacio: almacenamiento local, SQLite, `flutter_secure_storage`, caché y sesión nunca se mezclan, y las dos se pueden instalar a la vez. El paquete de Dart (`solventa_mobile`, el de los `import`) no cambia. `flutter run` sin `--flavor` usa dev. FCM (`google-services.json`) y Google Maps (llave restringida por paquete) se configuran por flavor.

## Secretos y variables

| Nombre | Dónde | Para qué | Estado |
|---|---|---|---|
| `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | Hoy en el repo; plan: environment `production` | Firmar prod | Hoy |
| `ANDROID_DEV_KEYSTORE_BASE64`, `ANDROID_DEV_KEYSTORE_PASSWORD`, `ANDROID_DEV_KEY_ALIAS`, `ANDROID_DEV_KEY_PASSWORD` | Environment `dev` | Firmar dev con una llave compartida, para que cualquier build de dev actualice al anterior | Plan |
| `FIREBASE_SERVICE_ACCOUNT` (secreto), `FIREBASE_PROJECT_ID`, `FIREBASE_APP_ID_DEV` (variables) | Repo | App Distribution y Test Lab | Plan |
| `PLAY_SERVICE_ACCOUNT` | Environment `production` | Subir el AAB a Play | Plan |
| `SONAR_TOKEN` | Repo | SonarCloud | Plan |

Los jobs que necesitan un secreto que todavía no existe se saltan solos, así el código puede integrarse antes de configurar las cuentas.

## Versionado

**Hoy:** la versión sale de `version:` en `pubspec.yaml` (se cambia a mano) y el build es el número de ejecución de `cd.yml`. Tag y Release: `v<versión>+<build>`.

**Plan:**

- La **versión** se calcula sola en cada merge a `main` desde los títulos de los PR desde el último tag `v*`: un `feat` sube la menor, solo `fix` sube el parche, un `!` sube la mayor. Lo hace `git-cliff --bumped-version`, que también escribe las notas del Release.
- El **build** (`versionCode`) es el número de ejecución del workflow de CD, que siempre crece.
- La versión vive en el tag (`v1.3.0+57`) y en el Release, no en un commit: el ruleset de `main` no permite pushes de bots. Se pasa al build con `--build-name` y `--build-number`.
- Dev usa `<próxima versión>-dev.<ejecución>`.
- El tag `sprint-N` se pone a mano al cerrar el sprint, igual que en web y backend.

## Rollback

Android no deja instalar un build con `versionCode` menor al instalado, así que "volver atrás" es publicar el código viejo con un build nuevo.

| Situación | Qué se hace | Estado |
|---|---|---|
| Error en un build de prod que va en despliegue gradual | Play Console → "Detener lanzamiento"; nadie más lo recibe | Plan (requiere Play) |
| Volver a la versión anterior para todos | Workflow manual `rollback` con el tag a restaurar (p. ej. `v1.2.0`): checkout del tag, build con número nuevo, subida a Play y Release marcado "rollback" | Plan |
| QA necesita un build de dev anterior | App Distribution guarda todos los builds | Plan |
| Hace falta un APK o AAB específico | Cada GitHub Release guarda los archivos (hoy el artifact dura 30 días; el Release no vence) | Hoy |

Prod sale primero a la pista interna de Play y se promueve a producción con despliegue gradual (por ejemplo 20 %).

## Logs y errores en producción

Plan: `package:logging` en desarrollo y Sentry en producción (mobile y web), con captura y video enmascarados, `traceparent` hacia el backend y código de soporte en la pantalla de error. Detalle en [`observabilidad.md`](observabilidad.md). El CD sube los símbolos de ofuscación a Sentry.

## Fuera de este plan

- **iOS y PWA:** fuera de alcance; la app es solo Android.

## Pasos manuales (fuera del repo)

- Rulesets: confirmar en Settings → Rules que los de `main`, `develop` y `sprint-*` están activos y son iguales a `.github/rulesets/` (el JSON del repo no se aplica solo).
- CODEOWNERS: reemplazar los roles por los usuarios reales y descomentar.
- Settings → Actions → General: "Allow GitHub Actions to create and approve pull requests" (organización y repo), para el auto-merge de Dependabot.
- Organización de Sentry con los proyectos `solventa-mobile` y `solventa-web`, y `SENTRY_AUTH_TOKEN` como secreto.

- Firebase: proyecto, apps `com.solventa.solventa_mobile` y `.dev`, App Distribution con el grupo `qa`, cuenta de servicio con permisos de App Distribution y Test Lab.
- Google Play Console: cuenta de desarrollador, app creada y primer AAB subido a mano.
- Environments `dev` y `production` en GitHub, con sus secretos.
- Secret scanning y push protection.
- Llaves de Google Maps por flavor cuando llegue la HU de mapas.
