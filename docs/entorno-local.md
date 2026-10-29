# Entorno local y versiones

Qué versiones usa la app y cómo trabaja todo el equipo con exactamente las mismas en Windows, Mac y Linux. Diagrama en [`diagramas.md`](diagramas.md#1-correr-el-proyecto-en-local).

**Regla:** el devcontainer es el entorno obligatorio. Toda la compilación, el análisis, las pruebas, los goldens y `flutter run` se hacen dentro del contenedor, en local y en los pipelines. Fuera del contenedor solo quedan el emulador y el teléfono, por una limitación técnica explicada abajo.

## Versiones

| Pieza | Versión | Dónde se fija | Estado |
|---|---|---|---|
| Flutter | **3.47.8**, la stable más reciente (publicada el 23 de octubre de 2026), verificada con su sha256 | `ARG FLUTTER_VERSION` en `.devcontainer/Dockerfile` y `environment.flutter` en `pubspec.yaml`; `tool/verificar-versiones.sh` revisa que coincidan con la instalada | Hoy |
| Dart | 3.13.7 (viene con Flutter 3.47.8) | `environment.sdk: ^3.13.7` en `pubspec.yaml` | Hoy |
| Paquetes pub | Exactos | `pubspec.lock` (en git) | Hoy |
| JDK | 17 | Imagen del devcontainer; `compileOptions` y `jvmTarget` en `android/app/build.gradle.kts` | Hoy |
| Android SDK | platform 36, build-tools 36.0.0, NDK 28.2.13676358, cmdline-tools y platform-tools (lo que pide Flutter 3.47.8) | `ARG ANDROID_*` en `.devcontainer/Dockerfile` | Hoy |
| Gradle | 9.3.1 | `android/gradle/wrapper/gradle-wrapper.properties` (el wrapper la descarga sola) | Hoy |
| Android Gradle Plugin | 9.1.0 | `android/settings.gradle.kts` | Hoy |
| Kotlin | 2.4.0 | `android/settings.gradle.kts` | Hoy |
| `compileSdk`, `targetSdk`, `minSdk`, NDK | Los que define Flutter | `flutter.compileSdkVersion` y similares en `android/app/build.gradle.kts` | Hoy (quedan fijos al fijar Flutter) |

Por qué fijar Flutter en vez de usar siempre la última: si cada quien (y el CI) usa la stable del día, dos personas pueden obtener resultados distintos con el mismo código. Los goldens dependen del motor de render y fallan con un cambio de versión aunque nadie toque nada. Con la versión fija, subir de Flutter es un PR propio (cambiar `FLUTTER_VERSION` y `environment.flutter`, regenerar goldens) que se revisa como cualquier otro cambio.

Si alguien usa una versión **menor**, `flutter pub get` falla por `environment.flutter` (pub solo revisa el mínimo). Para cualquier otra versión, `tool/verificar-versiones.sh` falla al crear el contenedor, en `tool/verificar.sh` y en el CI, así que nadie trabaja con otra versión sin darse cuenta.

## Devcontainer (obligatorio)

`.devcontainer/` define una imagen con Flutter 3.47.8, JDK 17, el Android SDK y lefthook. Es la misma definición que usan los jobs del CI (`.github/actions/devcontainer`), publicada en el GitHub Container Registry (`ghcr.io/solventa-app/solventa-frontend-mobile-dev`), así que local y pipeline no se pueden separar.

Al crear el contenedor, `tool/post-create.sh` ajusta los permisos de las cachés, verifica las versiones, corre `flutter pub get` e instala el hook de pre-push. Las cachés de Gradle y de pub viven en volúmenes de Docker (`solventa-mobile-gradle`, `solventa-mobile-pub`), así que sobreviven a un "Rebuild Container".

### Requisitos en la máquina

| Sistema | Qué instalar |
|---|---|
| Windows | Docker Desktop con WSL2, VS Code con la extensión Dev Containers, Android Studio (solo para el emulador) |
| Mac | Docker Desktop (en chip M, con Rosetta activado), VS Code con Dev Containers, Android Studio (solo para el emulador) |
| Linux | Docker Engine, VS Code con Dev Containers, Android Studio (solo para el emulador) |

Los pasos que cambian por sistema (WSL2, Rosetta, KVM, ruta de `adb`, `host.docker.internal` en Linux) están en la tabla "Lo que cambia según tu sistema" del README.

No hace falta instalar Flutter, Dart, JDK ni el Android SDK en la máquina.

### Flujo diario

1. Abrir el repo en VS Code → "Reopen in Container". La primera vez descarga la imagen.
2. Abrir el emulador en la máquina (Android Studio → Device Manager) o conectar el teléfono.
3. En una terminal de la máquina (no del contenedor): en Mac, `adb start-server` (Docker Desktop lleva `host.docker.internal` al localhost del Mac, así que no hace falta abrir el puerto); en Windows y Linux, `adb kill-server && adb -a nodaemon server start`, y dejarla abierta. El devcontainer trae `ADB_SERVER_SOCKET=tcp:host.docker.internal:5037`, así que usa ese servidor de `adb` y ve el emulador y el teléfono por USB (`flutter devices` los lista). En Windows y Linux, `-a` abre el puerto 5037 a la red: úsalo solo en redes de confianza o con el firewall cerrando ese puerto.
4. `flutter run` desde el contenedor. El hot reload funciona igual, a través de `adb`.
5. Antes del PR: `tool/verificar.sh` en el contenedor (el hook de pre-push lo corre en cada `git push`).
6. Goldens: `tool/goldens.sh` dentro del contenedor, nunca fuera. Así salen idénticos a los que compara el CI.

### Lo que queda fuera del contenedor, y por qué

- **El emulador:** necesita virtualización por hardware (KVM). Docker no la ofrece en Mac ni de forma confiable en Windows, así que el emulador dentro de un contenedor no arranca o es inusable. Corre en la máquina y el contenedor se conecta a él por `adb`.
- **El teléfono físico:** el USB lo ve la máquina, no el contenedor (en Mac y Windows Docker no pasa dispositivos USB); el contenedor lo usa a través del servidor de `adb` de la máquina.
- **Android Studio:** es una aplicación de escritorio y no tiene buen soporte para trabajar dentro de un devcontainer. Se usa solo para administrar emuladores. El editor del equipo es VS Code dentro del contenedor (análisis de Dart, depuración y hot reload funcionan ahí).

### Costo en Mac con chip M

El Android SDK no publica binarios para Linux ARM, así que en Mac con chip M el contenedor corre en modo amd64 emulado por Rosetta. Analyze, test y goldens se sienten casi igual; compilar el APK tarda más (aprox. 2 a 3 veces). Es el precio de que todos tengan exactamente lo mismo que el CI.

El primer build del APK en Mac con chip M tarda unos 13 minutos (Gradle descarga todo bajo emulación); los siguientes son mucho más rápidos. El devcontainer trae `DART_VM_OPTIONS=--no-profiler`: sin eso, bajo Rosetta, Dart falla al copiar archivos (`file_linux.cc: Unexpected EINTR errno` en `compileFlutterBuildDevRelease`). Probado en un M1: APK compilado e instalado en el emulador desde el contenedor.

## Qué va en Docker y qué no

| Tarea | En tu máquina | En el pipeline |
|---|---|---|
| `pub get`, format, analyze, `flutter test`, goldens | Dentro del devcontainer | Dentro de la misma imagen |
| Build del APK y AAB | Dentro del devcontainer | Dentro de la misma imagen, con firmado |
| `flutter run` y hot reload | Dentro del devcontainer, hacia el dispositivo por `adb` | No aplica |
| Emulador | Fuera: en tu máquina (necesita virtualización por hardware) | Fuera de nuestra imagen: directo en el runner de GitHub (Linux con KVM), con la misma versión de Flutter |
| Teléfono físico | Fuera: conectado a tu máquina | No aplica |
| Servidor de `adb` | Fuera: en tu máquina | Dentro del job del emulador |
| Firebase Test Lab | No aplica | En la nube de Google; el job solo llama a `gcloud` |
| App Distribution | No aplica | `firebase-tools` sube el APK de dev |
| gitleaks, osv-scanner, MobSF, Trivy | Opcional, cada uno con su imagen oficial | Cada uno con su imagen oficial |
| Android Studio, VS Code, Docker Desktop | Aplicaciones de tu máquina (VS Code abre el repo dentro del contenedor) | No aplica |

## Subir de versión

En un PR propio (`chore(mobile): KAN-N Flutter X.Y.Z`):

1. `ARG FLUTTER_VERSION` y `ARG FLUTTER_SHA256` en `.devcontainer/Dockerfile` (el sha256 está en `https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json`), y los `ARG ANDROID_*` si la nueva versión pide otro SDK o NDK (`flutter.compileSdkVersion` y `flutter.ndkVersion`).
2. `environment.flutter` (y `environment.sdk`) en `pubspec.yaml`.
3. "Rebuild Container", `flutter pub get`, `tool/goldens.sh` y `tool/verificar.sh --apk`.

El CI arma la imagen nueva solo, porque su etiqueta depende del contenido de `.devcontainer/`.

## Finales de línea

`.gitattributes` fija LF para el código y marca como binarios PNG, fuentes y keystores. Sin esto, Git en Windows puede convertir a CRLF y hacer fallar `dart format` o dañar los goldens. Con el repo dentro del contenedor (Linux) el riesgo baja, pero el archivo se mantiene para quien clone fuera.

## Resumen

| Necesidad | Cómo |
|---|---|
| Misma versión de Flutter, Dart, JDK y Android SDK en todas las máquinas | Imagen del devcontainer |
| Mismas dependencias | `pubspec.lock` (hoy) |
| Mismo Gradle, AGP y Kotlin | Wrapper de Gradle y `settings.gradle.kts` (hoy) |
| Mismo resultado que el CI | El CI usa la misma imagen |
| Goldens iguales a los del CI | `tool/goldens.sh` en el contenedor |
| Emulador y teléfono | En la máquina, conectados por `adb` |
