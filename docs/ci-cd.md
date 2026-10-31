# CI/CD de la app móvil

Cómo se construye, se prueba, se versiona y se publica la app (solo Android). Los diagramas están en [`diagramas.md`](diagramas.md). Quien cambie un workflow actualiza este documento en el mismo PR.

Referencias: Estrategia de Pruebas v4 (granja de dispositivos, distribución OTA, SAST, evidencias) y la sección 4 del documento de arquitectura. Las prácticas siguen las de `solventa-frontend-web` y `solventa-backend`.

Estado de cada pieza:

- **Hoy**: está en el repo y corre.
- **Listo, falta cuenta**: el workflow existe y se salta solo (con un aviso) hasta que se configuren el secreto o la variable de la cuenta externa (Firebase). Ver "Pasos manuales".
- **Pendiente**: acordado y todavía sin código.

## Resumen

| Momento | Qué corre | Estado |
|---|---|---|
| PR a `develop`, `release/*` o `main` | `mobile` en el devcontainer: versiones, `dart format`, `flutter analyze`, `flutter test --coverage` y el APK de dev compilado en release (R8). `Título del PR`, `Nombre de rama`. Seguridad: gitleaks, actionlint, acciones por SHA, osv-scanner | Hoy |
| Merge a `develop` | Lo mismo, más: APK "Solventa Dev" firmado (`develop.yml`), MobSF sobre ese APK, `integration_test` en 3 emuladores (`emuladores.yml`) | Hoy |
| | APK de dev a Firebase App Distribution (grupo `qa`) | Listo, falta cuenta |
| Cierre de sprint (`release/sprint-N`) | Sesión exploratoria ([`pruebas-exploratorias.md`](pruebas-exploratorias.md)) | Hoy |
| | Firebase Test Lab manual (`test-lab.yml`): Robo test e `integration_test` en teléfonos reales | Listo, falta cuenta |
| Merge a `main` | `cd.yml`: versión calculada sola, build prod firmado con R8 y Dart ofuscado, GitHub Release `v<versión>+<build>` con APK, AAB, mapping y símbolos | Hoy |
| Manual | `rollback.yml` (recompila un tag anterior con build nuevo), `cd.yml` desde otra rama (compila sin publicar), `imagen-devcontainer.yml` | Hoy |
| | `sonar.yml`: SonarCloud con la cobertura de `flutter test`; en PRs (decora el PR y evalúa el quality gate) y en push a `develop` cuando cambia `lib/`, `test/` o `pubspec.*`. Se salta en PRs de forks y de Dependabot (sin secretos) | Hoy |
| Sentry | Reporte de errores con replay enmascarado | Pendiente: [`plan-sentry.md`](plan-sentry.md) |

## Flujo de ramas

Igual que el web (`.github/workflows/pr-rama.yml`):

| Origen | Destino |
|---|---|
| `feat\|fix\|chore/KAN-N-descripcion` | `develop` (squash) |
| `fix\|chore/KAN-N-descripcion` | `release/sprint-N` (solo correcciones durante la estabilización) |
| `release/sprint-N` | `main` (merge commit) |
| `hotfix/KAN-N-descripcion` | `main` (merge commit) |
| `main` | `develop` (reintegración tras cada release o hotfix) |

Título del PR (`pr-titulo.yml`): `tipo(alcance): KAN-N descripción`. Tipos: `feat fix refactor test docs chore ci infra`. Alcances: `mobile contrato docs ci`. El título es el mensaje del commit al hacer squash y **decide la próxima versión** (ver "Versionado"). Dependabot queda exento por el autor del PR (`pull_request.user.login`), no por `github.actor`.

## Workflows

| Archivo | Cuándo | Qué hace |
|---|---|---|
| `ci.yml` | Todo PR, push a `develop`, manual | Job `mobile` dentro del devcontainer: `tool/verificar.sh --apk`. Artifact `coverage` |
| `seguridad.yml` | Todo PR, push a `develop`, cada lunes, manual | Jobs `Secretos (gitleaks)`, `Dependencias (osv-scanner)` (informativo), `Workflows (actionlint)` con revisión de acciones por SHA |
| `pr-titulo.yml`, `pr-rama.yml` | PR abierto o editado | Título y rama |
| `develop.yml` | Push a `develop`, manual | `apk-dev` (firmado con la llave de dev, versión `X.Y.Z-dev.N`, artifact 14 días), `App Distribution`, `MobSF` (informativo, reporte como artifact `mobsf`) |
| `emuladores.yml` | Push a `develop`, manual | `integration_test` en emuladores: teléfono pequeño API 28 (Nexus 5, 360 dp, el mínimo soportado), teléfono grande API 34, tablet API 34. Corre en el runner (necesita KVM) con la versión de Flutter de `pubspec.yaml` |
| `test-lab.yml` | Manual (cada `release/sprint-N`) | Robo test e `integration_test` en teléfonos reales de Firebase Test Lab |
| `cd.yml` | Push a `main`, manual | Build prod y GitHub Release con APK, AAB, mapping y símbolos. Desde otra rama compila sin tag ni Release |
| `rollback.yml` | Manual | Vuelve a publicar un tag anterior con un build nuevo |
| `imagen-devcontainer.yml` | Push a `develop` que toque `.devcontainer/`, manual | Publica la imagen como `latest` y `3.47.8` en GHCR y la revisa con Trivy (informativo) |
| `dependabot-auto-merge.yml` | PR de Dependabot | Aprueba y arma auto-merge de patch y minor |

Ningún check obligatorio filtra por rutas: deben reportar en todos los PR.

`.github/actions/devcontainer/` es la acción compartida que construye la imagen de `.devcontainer/` y corre un comando dentro. La imagen se publica en `ghcr.io/solventa-app/solventa-frontend-mobile-dev` con una etiqueta por contenido (`3.47.8-<huella>`): cuando cambia el Dockerfile se construye una vez y el resto de las veces solo se descarga. El primer PR que la crea tarda más (unos 15 minutos).

## Linter y formato

| Dónde | Qué |
|---|---|
| Reglas | `analysis_options.yaml`: `flutter_lints` + análisis estricto (`strict-casts`, `strict-inference`, `strict-raw-types`, como el modo estricto de TypeScript en el web) + `always_declare_return_types`, `avoid_dynamic_calls`, `cancel_subscriptions`, `close_sinks`, `directives_ordering`, `prefer_final_locals`, `prefer_single_quotes`, `unawaited_futures` |
| Editor | `devcontainer.json` configura VS Code: formato al guardar y al escribir, `fixAll` y orden de imports al guardar, ancho 80, LF |
| Antes del push | `lefthook.yml`: `pre-push` corre format, analyze y test dentro del contenedor (`tool/post-create.sh` lo instala). Saltarlo una vez: `LEFTHOOK=0 git push` |
| CI | El job `mobile` corre `dart format --set-exit-if-changed` y `flutter analyze`, que falla con cualquier hallazgo, incluidos los de nivel info. Es check obligatorio |

Comparado con el web: ESLint ↔ `flutter analyze`, Prettier ↔ `dart format`, `vue-tsc` ↔ el analizador de Dart.

## Protección de ramas y revisión

| Pieza | Qué hace |
|---|---|
| Rulesets (`.github/rulesets/`) | `main` y `develop`: PR obligatorio, 1 aprobación, aprobaciones viejas se descartan con cada push, hilos resueltos, sin borrado ni force-push. Checks obligatorios: `mobile`, `Título del PR`, `Nombre de rama`, `Secretos (gitleaks)`, `Workflows (actionlint)`. `main` solo merge commit; `develop` squash o merge. Tags `sprint-*` y `v*` sin borrado ni cambio. **Los JSON son referencia**: el ruleset real se edita en Settings → Rules |
| Plantilla de PR | Definición de hecho de cada PR |
| CODEOWNERS | Comentado, falta poner los usuarios |
| Auto-merge de Dependabot | Patch y minor se integran solos cuando los checks pasan. Dependabot también sube las acciones fijadas por SHA y la imagen base del devcontainer |

## Pruebas

| Tipo | Herramienta | Dónde corre | Estado |
|---|---|---|---|
| Unitarias y de widget | `flutter_test` | Devcontainer, en cada PR | Hoy |
| Goldens de componentes | alchemist | Devcontainer, en cada PR | Llega con el PR del sistema de diseño (KAN-239): 360 y 390 dp, texto al 100 % y 200 % |
| Goldens de pantallas | alchemist | Devcontainer, en cada PR | Hoy (HU-M01): 360 y 390 dp con texto al 100 % y 200 % en español, 390 dp en inglés y 600 dp. Pendiente: variante horizontal de 640 × 360. Se regeneran con `tool/goldens.sh` |
| Accesibilidad (contraste, tap targets) | `meetsGuideline` | Cada PR | Llega con KAN-239 |
| Integración en emuladores | `integration_test` | `emuladores.yml`, cada merge a `develop` | Hoy (prueba de humo; cada HU con recorrido agrega la suya en `integration_test/`) |
| Integración y exploración en teléfonos reales | `integration_test` y Robo test | `test-lab.yml`, cada release | Listo, falta cuenta |
| Exploratoria manual | Guía y plantilla | Una sesión por sprint | Hoy |
| Resiliencia sin conexión, biometría, cámara, GPS, push, Wallet | Dobles de los plugins en `flutter_test`; dispositivo real en Test Lab | Con cada HU |

Tamaños: 360 dp es el mínimo soportado (la base de Figma es 390 y desde 600 dp el contenido se centra con ancho máximo de 600). Por eso los goldens cubren 360, 390 y 600: por debajo de 360 no se soporta y por encima de 600 la pantalla se ve igual. Otros anchos reales (412, tablets grandes) se revisan en los emuladores, en Test Lab y en la exploratoria, no en goldens.

La evidencia de cada prueba manual o de dispositivo va en [`docs/evidencias/`](evidencias/README.md).

## Granja de dispositivos

Tres niveles, todos sin costo. Ninguno corre dentro de la imagen del devcontainer: los dispositivos necesitan hardware o viven en la nube.

| Nivel | Qué es | Cuándo | Costo |
|---|---|---|---|
| Emuladores en GitHub Actions | `reactivecircus/android-emulator-runner` en el runner de Linux con KVM, matriz de tamaños y versiones | Cada merge a `develop` | Gratis (repo público) |
| Firebase Test Lab, Robo test | Un robot recorre la app sin pruebas escritas: toca, llena campos, toma capturas y video, reporta cierres y ANR. En Flutter se guía por el árbol de semántica | Manual, en cada `release/sprint-N` | Plan Spark gratis (a la fecha, unas 10 pruebas al día en virtuales y 5 en físicos; verificar en la consola) |
| Firebase Test Lab, `integration_test` | Nuestras pruebas en teléfonos reales, a través de `android/app/src/androidTest/.../MainActivityTest.java` | Junto al Robo | La misma cuota |

Dispositivos por defecto de `test-lab.yml`: Pixel 6 (API 33) y Pixel 5 (API 30). Se cambian en la entrada del workflow; conviene sumar un Samsung de la lista vigente (`gcloud firebase test android models list --filter=form=PHYSICAL`).

## Seguridad

| Control | Qué es | Cómo se usa aquí | Estado |
|---|---|---|---|
| gitleaks | Busca secretos en **todo el historial** de git | Job `Secretos (gitleaks)`, bloquea. Importa por keystores, `key.properties` y `google-services.json` | Hoy |
| actionlint | Valida sintaxis, expresiones y scripts de los workflows | Job `Workflows (actionlint)`, bloquea | Hoy |
| Acciones fijadas por SHA | `uses: accion@<sha> # vX`, para que nadie cambie una acción por debajo | El mismo job falla si una acción no tiene SHA | Hoy |
| osv-scanner | Revisa `pubspec.lock` contra la base OSV de Google | Job `Dependencias (osv-scanner)`, informativo hasta confirmar cero hallazgos | Hoy |
| MobSF | Análisis estático del APK: permisos, manifest, cifrado, llaves embebidas, librerías inseguras | `develop.yml`, sobre el APK de dev. Puntaje en el resumen del job, reporte PDF y JSON como artifact. Informativo | Hoy |
| Trivy | Vulnerabilidades de la imagen del devcontainer | `imagen-devcontainer.yml`, informativo | Hoy |
| Dependabot | PRs con versiones nuevas o vulnerables de pub, acciones e imagen base | `.github/dependabot.yml`, hacia `develop` | Hoy |
| Endurecimiento del APK | R8, Dart ofuscado en prod, sin copia de seguridad (`allowBackup="false"` y `data_extraction_rules.xml`), sin tráfico en claro en prod | Ver la sección siguiente | Hoy |
| SonarCloud | Calidad y SAST | `sonar.yml`, proyecto `global-spark_solventa-frontend-mobile` | Hoy |
| Secret scanning y push protection | Funciones de GitHub | Settings → Code security | Configuración pendiente |

Regla: nada secreto en el código ni en `config/*.json`. Todo lo que entra con `--dart-define` queda dentro del APK.

## R8, ofuscación y símbolos

**Qué es.** El APK de release pasa por dos procesos distintos:

| | R8 | Ofuscación de Dart |
|---|---|---|
| Sobre qué | El código Java/Kotlin (el de Android, Flutter y los plugins) y los recursos | El código Dart de la app (casi toda la lógica) |
| Qué hace | **Encoge** (quita clases y recursos sin uso), **ofusca** (renombra clases y métodos a `a`, `b`, `c`) y **optimiza** | Renombra clases y funciones en el binario compilado |
| Cómo se activa | `isMinifyEnabled` e `isShrinkResources` en `android/app/build.gradle.kts`, con `proguard-rules.pro` | `--obfuscate --split-debug-info=build-symbols` en `tool/build-prod.sh` |
| En qué builds | Todo build de release (dev y prod), así un problema de R8 aparece en dev antes que en prod | Solo prod |
| Archivo para leer errores | `mapping.txt` | Carpeta `build-symbols/` (un `.symbols` por arquitectura) |

**Por qué.** APK más pequeño, y quien descompile la app no lee los nombres de nuestras clases ni la lógica con facilidad. No reemplaza la regla de no guardar secretos en la app.

**Dónde quedan los archivos.** Cada GitHub Release de prod (y de rollback) adjunta, además del APK y el AAB:

- `solventa-<versión>+<build>-mapping.txt`: el mapeo de R8;
- `solventa-<versión>+<build>-simbolos-dart.zip`: los símbolos de Dart.

Cuando entre Sentry, el CD sube ambos ([`plan-sentry.md`](plan-sentry.md)). Los símbolos no van en git (`build-symbols/` está en `.gitignore`).

**Cómo leer un error ofuscado.**

1. Descargar del Release de esa versión el zip de símbolos (y el mapping si el error es de Java/Kotlin).
2. Dart:

   ```bash
   unzip solventa-1.3.0+57-simbolos-dart.zip -d simbolos
   flutter symbolize -i error.txt -d simbolos/app.android-arm64.symbols
   ```

   Usar el `.symbols` de la arquitectura del teléfono (casi siempre `arm64`).
3. Java/Kotlin: `retrace` del Android SDK (`$ANDROID_HOME/cmdline-tools/latest/bin/retrace mapping.txt error.txt`).

**Si R8 rompe algo.** Síntoma típico: funciona en debug y en release falla con `ClassNotFoundException` o un plugin que no responde. Se agrega la regla `-keep` que pida el plugin en `android/app/proguard-rules.pro` y se prueba con `tool/verificar.sh --apk` y en el emulador con `flutter run --release`.

## Ambientes dev y prod

Flavors de Android + `--dart-define-from-file`:

| | dev | prod |
|---|---|---|
| Paquete Android | `com.solventa.solventa_mobile.dev` | `com.solventa.solventa_mobile` |
| Nombre en el teléfono | Solventa Dev | Solventa |
| Versión visible | `1.3.0-dev.214` | `1.3.0` |
| Configuración de Dart | `config/dev.json` | `config/prod.json` |
| Firmado | Llave de dev (environment `dev`) | Llave de subida (environment `production`) |
| Tráfico `http` | Permitido (backend local) | Bloqueado |
| Dart ofuscado | No | Sí |
| Se entrega por | Artifact `apk-dev` y App Distribution (testers del grupo `qa`) | APK firmado en el GitHub Release (sin tienda por ahora) |

- Como el paquete es distinto, Android le da a cada app su propio espacio: almacenamiento local, SQLite, almacenamiento seguro, caché y sesión nunca se mezclan, y las dos se instalan a la vez.
- `flutter run` sin `--flavor` usa dev (`default-flavor: dev` en `pubspec.yaml`). Prod en local: `flutter run --flavor prod --dart-define-from-file=config/prod.json`.
- Claves de `config/*.json`: `FLAVOR`, `API_ENV` (`mock`, `local`, `dev`, `prod`) y `API_BASE_URL`, leídas en `lib/core/config/app_config.dart`. Archivos: `mock.json` (fakes, sin red), `local.json` (backend en tu máquina), `dev.json` (staging) y `prod.json`; detalle en [`integracion-backend.md`](integracion-backend.md). `dev.json` y `prod.json` apuntan al gateway de staging (`gateway_url` del backend), y los APKs de dev (App Distribution) y prod (GitHub Releases) hablan con ese backend. Las pruebas del CI, los emuladores y Test Lab siguen con `config/mock.json`, sin red, para no depender de staging encendido.
- En tu máquina no hay llaves: el build de release se firma con la de debug. En el CI, `tool/firma.sh` escribe `android/key.properties` (prod) o `android/key-dev.properties` (dev) desde los secretos.
- FCM (`google-services.json`) y Google Maps (llave restringida por paquete) se configurarán por flavor con sus HU.

## Secretos y variables

| Nombre | Dónde | Para qué | Estado |
|---|---|---|---|
| `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | Hoy en el repo; moverlos al environment `production` | Firmar prod | Hoy |
| `ANDROID_DEV_KEYSTORE_BASE64`, `ANDROID_DEV_KEYSTORE_PASSWORD`, `ANDROID_DEV_KEY_ALIAS`, `ANDROID_DEV_KEY_PASSWORD` | Environment `dev` | Firmar dev con una llave compartida, para que cada build de dev se instale encima del anterior. Sin ellos se firma con la de debug | Falta crearlos |
| `FIREBASE_SERVICE_ACCOUNT` (secreto), `FIREBASE_APP_ID_DEV`, `FIREBASE_PROJECT_ID` (variables) | Environment `dev` | App Distribution y Test Lab | Falta cuenta |
| `SONAR_TOKEN` | Repo | SonarCloud | Hoy |
| `SENTRY_AUTH_TOKEN` | Environment `production` | Subir símbolos a Sentry | Pendiente |

## Versionado

- La **versión** se calcula sola en cada merge a `main` con `git-cliff --bumped-version` (`cliff.toml`), desde los títulos de PR desde el último tag `v*`: un `feat` sube la menor, el resto sube el parche y un `!` o `BREAKING CHANGE` sube la mayor. git-cliff también escribe las notas del Release, agrupadas.
- El **build** (`versionCode`) es el mayor build de todos los tags (`v*+N` y `rollback-*+N`) más 1, así siempre crece, también después de un rollback.
- La versión vive en el tag (`v1.3.0+57`) y en el Release, **no en un commit**: el ruleset de `main` no deja pushear a bots. Se pasa al build con `--build-name` y `--build-number`. `version:` de `pubspec.yaml` ya no se toca.
- Dev usa `<próxima versión>-dev.<ejecución de develop.yml>`; como es otro paquete, su build no choca con el de prod.
- Todo lo calcula `tool/version.sh`.
- El tag `sprint-N` se pone a mano al cerrar el sprint, igual que en web y backend.

## Rollback

Android no instala un build con `versionCode` menor al instalado, así que "volver atrás" es publicar el código viejo con un build nuevo.

| Situación | Qué se hace | Estado |
|---|---|---|
| Volver a la versión anterior | Actions → Rollback → tag a restaurar (p. ej. `v1.2.0+45`). Compila ese código con un build nuevo, crea el tag `rollback-1.2.0+58` y un Release marcado "rollback" con el APK | Hoy. Solo con tags creados desde este CD |
| QA necesita un build de dev anterior | App Distribution guarda todos los builds; los artifacts `apk-dev` duran 14 días | Falta cuenta |
| Hace falta un APK o AAB específico | Cada GitHub Release guarda los archivos y no vence | Hoy |

Sin tienda, cada quien instala el APK del Release. Para volver atrás se corre Rollback y se instala el APK del Release `rollback-…` encima de la versión mala: el build es mayor, así que Android lo acepta y conserva los datos. El APK del Release anterior no sirve tal cual, porque su build es menor y Android lo rechaza encima de uno mayor.

## Google Play (futuro)

Desactivado: por ahora no hay tienda. El CD ya genera el AAB firmado y el mapping, así que activarlo es agregar al final de `cd.yml` y `rollback.yml` un paso con `r0adkll/upload-google-play` (pista `internal`, `mappingFile` del Release) condicionado a un secreto `PLAY_SERVICE_ACCOUNT` en el environment `production`. Antes: cuenta de desarrollador, app creada en Play Console, primer AAB subido a mano y cuenta de servicio con permiso de publicar. Con Play, el rollback rápido pasa a ser "Detener lanzamiento" del despliegue gradual.

## Logs y errores en producción

Pendiente: Sentry en mobile y web, con captura y video enmascarados, `traceparent` hacia el backend y código de soporte en la pantalla de error. Decisión en [`observabilidad.md`](observabilidad.md); paso a paso en [`plan-sentry.md`](plan-sentry.md).

## Fuera de alcance

- **iOS y PWA:** la app es solo Android.

## Pasos manuales (fuera del repo)

- Rulesets: en Settings → Rules, dejar `main`, `develop` y tags iguales a `.github/rulesets/` (sumar los checks `Secretos (gitleaks)` y `Workflows (actionlint)` y el patrón de tags `v*`).
- Paquete de GHCR `solventa-frontend-mobile-dev`: después del primer push a `develop`, en Packages → Package settings, ponerlo **público** (el repo es público), para que el devcontainer descargue la imagen sin iniciar sesión.
- Environments `dev` y `production` en Settings → Environments; mover los secretos de firmado de prod a `production` y crear los de dev (llave nueva con `keytool -genkeypair -v -keystore dev.jks -alias dev -keyalg RSA -keysize 2048 -validity 10000`, en base64 con `base64 -i dev.jks`).
- CODEOWNERS: reemplazar los roles por los usuarios reales y descomentar.
- Settings → Actions → General: "Allow GitHub Actions to create and approve pull requests" (organización y repo), para el auto-merge de Dependabot.
- Firebase: proyecto, apps `com.solventa.solventa_mobile` y `com.solventa.solventa_mobile.dev`, App Distribution con el grupo `qa`, cuenta de servicio con los roles "Firebase App Distribution Admin" y "Firebase Test Lab Admin"; guardar su JSON en `FIREBASE_SERVICE_ACCOUNT` y las variables `FIREBASE_APP_ID_DEV` y `FIREBASE_PROJECT_ID`.
- Secret scanning y push protection en Settings → Code security.
- Sentry: ver [`plan-sentry.md`](plan-sentry.md).
