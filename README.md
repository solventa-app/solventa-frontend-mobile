# Solventa — App móvil

App Flutter de Solventa, solo para Android (sin iOS ni PWA). El backend y el contrato viven en `solventa-backend`; la web en `solventa-frontend-web`.

| Documento | Para qué |
|---|---|
| Este README | Correr la app en local y el resumen del flujo de trabajo |
| [`docs/entorno-local.md`](docs/entorno-local.md) | Versiones de Flutter, Dart, JDK, Gradle y Android SDK; devcontainer obligatorio; emulador |
| [`docs/ci-cd.md`](docs/ci-cd.md) | Qué corre en cada PR y en cada merge, linter, pruebas, granja de dispositivos, responsive, seguridad, ambientes, versionado y rollback |
| [`docs/observabilidad.md`](docs/observabilidad.md) | Logs en desarrollo, Sentry con captura y video, y cómo reproducir un error de un usuario |
| [`docs/pruebas-exploratorias.md`](docs/pruebas-exploratorias.md) | Cómo hacer la sesión exploratoria de cada sprint, con checklist |
| [`docs/evidencias/`](docs/evidencias/README.md) | Evidencias de pruebas manuales y de dispositivo, con plantilla |
| [`CLAUDE.md`](CLAUDE.md) | Contexto corto para agentes (y para quien llega nuevo) |

`docs/ci-cd.md` y `docs/entorno-local.md` marcan cada cosa como **hoy** (ya está en el repo) o **plan** (acordado, falta el PR). Cuando un PR implementa algo del plan, ese mismo PR lo pasa a **hoy**.

## Correr la app en local

### Con el devcontainer (plan: obligatorio)

**Qué es un devcontainer:** un contenedor de Docker descrito en la carpeta `.devcontainer/` (`Dockerfile` + `devcontainer.json`, un estándar abierto). Trae Flutter 3.47.8, JDK 17 y el Android SDK ya instalados. VS Code abre el repo *dentro* de ese contenedor: la terminal, el análisis de Dart y la depuración corren ahí, y tus archivos siguen en tu disco. El CI usa la misma imagen, así que lo que pasa en tu máquina pasa en el pipeline.

Prerrequisitos (no hace falta instalar Flutter, Dart, JDK ni Android SDK):

| Sistema | Instalar |
|---|---|
| Windows 10/11 | [Docker Desktop](https://www.docker.com/products/docker-desktop/) con WSL2, [VS Code](https://code.visualstudio.com/) + extensión **Dev Containers**, Android Studio (solo para el emulador y `adb`) |
| Mac | Docker Desktop (chip M: activar "Use Rosetta" en Settings → General), VS Code + Dev Containers, Android Studio |
| Linux | Docker Engine, VS Code + Dev Containers, Android Studio |

Primera vez:

1. Clonar el repo y abrirlo en VS Code.
2. `Ctrl/Cmd+Shift+P` → **Dev Containers: Reopen in Container**. La primera vez descarga la imagen (unos minutos); después abre en segundos.
3. En Android Studio → Device Manager, crear un emulador (API 34 o más) y arrancarlo.

Cada día:

1. Arrancar el emulador (o conectar el teléfono por USB con depuración activada).
2. En una terminal **de tu máquina**: `adb kill-server && adb -a nodaemon server start`, y dejarla abierta. Así el contenedor ve el emulador y el teléfono (solo en redes de confianza: abre el puerto 5037).
3. En VS Code (ya dentro del contenedor): `flutter devices` debe listar el emulador.
4. `flutter run` (o F5). La app aparece en el emulador; `r` recarga en caliente.
5. Antes del PR, en la misma terminal: `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test`.

#### ¿Necesito el Android SDK en mi máquina?

Solo tres piezas, y las instala Android Studio solo con crear un emulador: el **emulador**, **platform-tools** (`adb`) y una **system image** (la "ROM" del teléfono virtual). Compilar no las usa: Flutter, Gradle, el JDK y el SDK de compilación están en el contenedor. Si no quieres Android Studio, basta con las command-line tools de Android y `sdkmanager "emulator" "platform-tools" "system-images;android-34;google_apis;<arquitectura>"`.

#### Emulador o teléfono por USB

Las dos opciones funcionan igual en los tres sistemas. En ambas, el `adb` de tu máquina ve el dispositivo y el contenedor lo usa a través de ese `adb` (paso 2 de "Cada día"), así que dentro del contenedor solo cambia qué eliges en `flutter devices`.

**Opción A, emulador**

1. Android Studio → Device Manager → Create device → un Pixel con API 34 o más y la system image de tu sistema (tabla de abajo).
2. Arrancarlo con ▶.
3. En tu máquina, `adb devices` lo muestra como `emulator-5554  device`.

**Opción B, teléfono por USB**

1. En el teléfono: Ajustes → Acerca del teléfono → tocar 7 veces "Número de compilación" para activar las Opciones de desarrollador.
2. Ajustes → Sistema → Opciones de desarrollador → activar **Depuración por USB**.
3. Conectar el cable (de datos, no solo de carga) y, si lo pregunta, elegir el modo "Transferencia de archivos".
4. En el teléfono aparece "¿Permitir depuración por USB?" con la huella del equipo: marcar "Permitir siempre desde este equipo" y aceptar.
5. En tu máquina, `adb devices` lo muestra como `<serial>  device`. Si dice `unauthorized`, falta el paso 4; si no aparece, revisa el cable y lo de tu sistema en la tabla.

Después, en ambos casos: paso 2 de "Cada día" en tu máquina, y `flutter devices` y `flutter run -d <id>` dentro del contenedor. Sin cable también se puede: Opciones de desarrollador → Depuración inalámbrica → `adb pair <ip>:<puerto>` en tu máquina (Android 11 o más).

Si conectas el teléfono **después** de levantar el servidor de `adb`, no hace falta reiniciarlo: lo detecta solo.

#### Lo que cambia según tu sistema

El resultado es el mismo en los tres: misma imagen, mismo Flutter, mismas pruebas, mismos goldens y el mismo APK. Solo cambia cómo se prepara la máquina y la velocidad.

| | Windows 10/11 | Mac Intel | Mac con chip M | Linux |
|---|---|---|---|---|
| Docker | Docker Desktop con backend WSL2 (`wsl --install` antes) | Docker Desktop | Docker Desktop con "Use Rosetta for x86/amd64 emulation" activado | Docker Engine; tu usuario en el grupo `docker` |
| Dónde clonar el repo | **Dentro de WSL** (p. ej. `\\wsl$\Ubuntu\home\<usuario>\`), no en `C:\`: desde `C:\` el contenedor va muy lento | Donde quieras | Donde quieras | Donde quieras |
| Emulador: aceleración | Activar "Plataforma del hipervisor de Windows" (Características de Windows) | Viene con macOS | Viene con macOS | KVM: `sudo apt install qemu-kvm` y tu usuario en el grupo `kvm` |
| Emulador: system image | `x86_64` | `x86_64` | `arm64-v8a` | `x86_64` |
| Teléfono USB: driver | Pixel: Android Studio → SDK Manager → SDK Tools → **Google USB Driver**. Otras marcas: el driver USB del fabricante (Samsung, Xiaomi, Motorola…) | No hace falta | No hace falta | Reglas udev: `sudo apt install android-sdk-platform-tools-common` y tu usuario en el grupo `plugdev`; desconectar y volver a conectar |
| Teléfono USB: dónde se conecta | Al puerto de Windows (no a WSL; el `adb` que se usa es el de Windows) | Al Mac | Al Mac | A la máquina |
| `adb` en la máquina | `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe` (agregarlo al PATH) | `~/Library/Android/sdk/platform-tools/adb` | Igual que Mac Intel | `~/Android/Sdk/platform-tools/adb` |
| Comando del paso 2 de "Cada día" | En PowerShell: `adb kill-server; adb -a nodaemon server start` (aceptar el aviso del firewall solo para redes privadas) | `adb kill-server && adb -a nodaemon server start` | Igual | Igual |
| Cómo llega el contenedor al `adb` | `host.docker.internal` (Docker Desktop lo trae) | Igual | Igual | El `devcontainer.json` agrega `--add-host=host.docker.internal:host-gateway`, porque Docker Engine no lo define solo |
| Velocidad | Normal | Normal | Analyze, test y goldens normales; el build del APK 2 a 3 veces más lento (el Android SDK no tiene binarios para Linux ARM, el contenedor corre emulado) | Normal |

Sin VS Code se puede usar la CLI oficial (`npm i -g @devcontainers/cli`, luego `devcontainer up --workspace-folder .` y `devcontainer exec --workspace-folder . flutter test`). Detalle, versiones y por qué el emulador queda fuera del contenedor: [`docs/entorno-local.md`](docs/entorno-local.md#devcontainer-plan-obligatorio).

### Hoy, mientras no exista el devcontainer

| Herramienta | Versión | Nota |
|---|---|---|
| Flutter | Stable con Dart ≥ 3.13.5 (el plan fija 3.47.8) | Ver [`docs/entorno-local.md`](docs/entorno-local.md) |
| JDK | 17 | El que trae Android Studio sirve |
| Android Studio | Estable reciente | Con Android SDK, un emulador (API 34 o más) y el plugin de Flutter |
| Git | Cualquiera reciente | En Windows, con `core.autocrlf=false` para no convertir a CRLF |

Comprueba todo con `flutter doctor`.

```bash
git clone https://github.com/solventa-app/solventa-frontend-mobile.git
cd solventa-frontend-mobile
flutter pub get
flutter run            # con un emulador abierto o un teléfono conectado por USB
```

Antes de abrir un PR, lo mismo que corre el CI:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Para corregir el formato: `dart format .`.

### Linter y formato

El CI (job `mobile`, obligatorio) bloquea el PR si falla cualquiera de estos; córrelos antes de subir, en el devcontainer o en tu máquina:

```bash
dart format .          # formatea; el CI usa --output=none --set-exit-if-changed
flutter analyze        # reglas de flutter_lints (analysis_options.yaml); falla incluso con hallazgos de nivel info
```

Plan: reglas más estrictas, formateo y correcciones al guardar en VS Code dentro del devcontainer y un hook `pre-push` opcional. Detalle en [`docs/ci-cd.md`](docs/ci-cd.md#linter-y-formato).

### Firmado

`flutter run --release` firma con la llave debug salvo que exista `android/key.properties` (ignorado por git). El firmado de verdad solo pasa en el CD. Nunca subas un keystore ni `key.properties` al repo.

### Ambientes (plan)

Cuando entren los flavors habrá dos apps que conviven en el teléfono, cada una con sus propios datos:

```bash
flutter run --flavor dev  --dart-define-from-file=config/dev.json    # "Solventa Dev"
flutter run --flavor prod --dart-define-from-file=config/prod.json   # "Solventa"
```

Detalle en [`docs/ci-cd.md`](docs/ci-cd.md#ambientes-dev-y-prod).

## Trazabilidad y reporte de errores (Sentry)

Decisión del equipo (2026-10-25), igual en la app y en la web; falta implementarla:

- **Sentry** recibe cada error y cierre de la app de los usuarios, con breadcrumbs, captura de pantalla y un **video (Session Replay) de lo que pasó antes**, grabado solo cuando hay un error y con todo el texto y las imágenes enmascarados. Las pantallas de pago, documento, cámara y billetera quedan fuera.
- Cada petición al BFF lleva un encabezado **`traceparent`**; el backend escribe ese id en Cloud Logging y Cloud Trace, así un error se sigue de la pantalla al servicio que falló.
- La pantalla de error muestra un **código de soporte** (los primeros 8 caracteres del id): con él se encuentra el reporte en Sentry y la traza del backend.
- Sin datos personales en logs, reportes, capturas ni videos. En desarrollo, logs con `package:logging` (nunca `print`).

Detalle: [`docs/observabilidad.md`](docs/observabilidad.md).

## Flujo de ramas

| Origen | Destino | Uso |
|---|---|---|
| `feat\|fix\|chore/KAN-N-descripcion` | `develop` | Trabajo diario (squash o merge) |
| `develop` | `main` | Liberación |
| `fix/KAN-N-descripcion` | `main` | Corrección urgente |
| `main` | `develop` | Reintegración tras un fix directo |

Plan: igualarlo al web (`release/sprint-N` y `hotfix/KAN-N-...` hacia `main`). Ver [`docs/ci-cd.md`](docs/ci-cd.md#flujo-de-ramas).

Título del PR: `tipo(alcance): KAN-N descripción`, por ejemplo `feat(mobile): KAN-24 login biométrico`. Alcances: `mobile`, `contrato`, `docs`, `ci`.

`main` y `develop` están protegidas por ruleset (`.github/rulesets/`): PR obligatorio, 1 aprobación y checks `mobile`, `Título del PR` y `Nombre de rama` en verde.

## CI y CD en una línea

- **CI** (`ci.yml`): `dart format`, `flutter analyze` y `flutter test` en cada PR.
- **CD** (`cd.yml`): cada merge a `main` compila el APK y el AAB firmados y crea un GitHub Release.

Todo lo demás (qué corre en cada caso, secretos, seguridad, versionado y rollback) está en [`docs/ci-cd.md`](docs/ci-cd.md).
