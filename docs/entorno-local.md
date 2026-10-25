# Entorno local y versiones

Qué versiones usa la app y cómo trabaja todo el equipo con exactamente las mismas en Windows, Mac y Linux. Igual que `ci-cd.md`, cada cosa está marcada como **hoy** o **plan**.

**Regla (plan):** el devcontainer es el entorno obligatorio. Toda la compilación, el análisis, las pruebas, los goldens y `flutter run` se hacen dentro del contenedor, en local y en los pipelines. Fuera del contenedor solo quedan el emulador y el teléfono, por una limitación técnica explicada abajo.

## Versiones

| Pieza | Versión | Dónde se fija | Estado |
|---|---|---|---|
| Flutter | Hoy: sin fijar (el CI usa la última `stable` del día y cada quien la que tenga). Plan: **3.47.8**, la stable más reciente (publicada el 23 de octubre de 2026) | Plan: `ARG FLUTTER_VERSION` en `.devcontainer/Dockerfile` y `environment.flutter` en `pubspec.yaml`; el CI verifica que coincidan | Hoy sin fijar |
| Dart | ≥ 3.13.5 (Flutter 3.47.8 trae Dart 3.13.7) | Viene con Flutter; mínimo en `environment.sdk` de `pubspec.yaml` | Hoy |
| Paquetes pub | Exactos | `pubspec.lock` (en git) | Hoy |
| JDK | 17 | Imagen del devcontainer (plan); `compileOptions` y `jvmTarget` en `android/app/build.gradle.kts` | Hoy en Gradle |
| Android SDK (platform, build-tools, cmdline-tools) | Los que pide Flutter 3.47.8 | Imagen del devcontainer | Plan |
| Gradle | 9.3.1 | `android/gradle/wrapper/gradle-wrapper.properties` (el wrapper la descarga sola) | Hoy |
| Android Gradle Plugin | 9.1.0 | `android/settings.gradle.kts` | Hoy |
| Kotlin | 2.4.0 | `android/settings.gradle.kts` | Hoy |
| `compileSdk`, `targetSdk`, `minSdk`, NDK | Los que define Flutter | `flutter.compileSdkVersion` y similares en `android/app/build.gradle.kts` | Hoy (quedan fijos al fijar Flutter) |

Por qué fijar Flutter en vez de usar siempre la última: si cada quien (y el CI) usa la stable del día, dos personas pueden obtener resultados distintos con el mismo código. Los goldens dependen del motor de render y fallan con un cambio de versión aunque nadie toque nada. Con la versión fija, subir de Flutter es un PR propio (cambiar `FLUTTER_VERSION` y `environment.flutter`, regenerar goldens) que se revisa como cualquier otro cambio.

Si alguien corre `flutter pub get` con otra versión, pub falla por la restricción `environment.flutter`, así que nadie trabaja con otra versión sin darse cuenta.

## Devcontainer (plan, obligatorio)

`.devcontainer/` define una imagen con Flutter 3.47.8, JDK 17 y el Android SDK. Es la misma imagen que usa el job `mobile` del CI, publicada en el GitHub Container Registry del repo, así que local y pipeline no se pueden separar.

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
3. En una terminal de la máquina (no del contenedor): `adb kill-server && adb -a nodaemon server start`, y dejarla abierta. El devcontainer trae `ADB_SERVER_SOCKET=tcp:host.docker.internal:5037`, así que usa ese servidor de `adb` y ve el emulador y el teléfono por USB (`flutter devices` los lista). `-a` abre el puerto 5037 a la red: úsalo solo en redes de confianza o con el firewall cerrando ese puerto.
4. `flutter run` desde el contenedor. El hot reload funciona igual, a través de `adb`.
5. Antes del PR: `dart format --output=none --set-exit-if-changed .`, `flutter analyze` y `flutter test`, en el contenedor.
6. Goldens: `tool/goldens.sh` dentro del contenedor, nunca fuera. Así salen idénticos a los que compara el CI.

### Lo que queda fuera del contenedor, y por qué

- **El emulador:** necesita virtualización por hardware (KVM). Docker no la ofrece en Mac ni de forma confiable en Windows, así que el emulador dentro de un contenedor no arranca o es inusable. Corre en la máquina y el contenedor se conecta a él por `adb`.
- **El teléfono físico:** el USB lo ve la máquina, no el contenedor (en Mac y Windows Docker no pasa dispositivos USB); el contenedor lo usa a través del servidor de `adb` de la máquina.
- **Android Studio:** es una aplicación de escritorio y no tiene buen soporte para trabajar dentro de un devcontainer. Se usa solo para administrar emuladores. El editor del equipo es VS Code dentro del contenedor (análisis de Dart, depuración y hot reload funcionan ahí).

### Costo en Mac con chip M

El Android SDK no publica binarios para Linux ARM, así que en Mac con chip M el contenedor corre en modo amd64 emulado por Rosetta. Analyze, test y goldens se sienten casi igual; compilar el APK tarda más (aprox. 2 a 3 veces). Es el precio de que todos tengan exactamente lo mismo que el CI.

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
| App Distribution y Google Play | No aplica | Acción de GitHub que sube el archivo |
| gitleaks, osv-scanner, MobSF, Trivy | Opcional, cada uno con su imagen oficial | Cada uno con su imagen oficial |
| Android Studio, VS Code, Docker Desktop | Aplicaciones de tu máquina (VS Code abre el repo dentro del contenedor) | No aplica |

## Finales de línea (plan)

`.gitattributes` fija LF para el código y marca como binarios PNG, fuentes y keystores. Sin esto, Git en Windows puede convertir a CRLF y hacer fallar `dart format` o dañar los goldens. Con el repo dentro del contenedor (Linux) el riesgo baja, pero el archivo se mantiene para quien clone fuera.

## Resumen

| Necesidad | Cómo |
|---|---|
| Misma versión de Flutter, Dart, JDK y Android SDK en todas las máquinas | Imagen del devcontainer (plan) |
| Mismas dependencias | `pubspec.lock` (hoy) |
| Mismo Gradle, AGP y Kotlin | Wrapper de Gradle y `settings.gradle.kts` (hoy) |
| Mismo resultado que el CI | El CI usa la misma imagen (plan) |
| Goldens iguales a los del CI | `tool/goldens.sh` en el contenedor (plan) |
| Emulador y teléfono | En la máquina, conectados por `adb` |
