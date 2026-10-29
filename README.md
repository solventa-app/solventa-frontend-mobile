# Solventa — App móvil

App Flutter de Solventa, solo para Android (sin iOS ni PWA). El backend y el contrato viven en `solventa-backend`; la web en `solventa-frontend-web`.

| Documento | Para qué |
|---|---|
| Este README | Correr la app en local y el resumen del flujo de trabajo |
| [`docs/entorno-local.md`](docs/entorno-local.md) | Versiones de Flutter, Dart, JDK, Gradle y Android SDK; devcontainer obligatorio; emulador |
| [`docs/diagramas.md`](docs/diagramas.md) · [`docs/diagramas.html`](docs/diagramas.html) | Diagramas: correr en local, CI/CD de punta a punta y pruebas (Mermaid en GitHub, o la página para abrir en el navegador) |
| [`docs/ci-cd.md`](docs/ci-cd.md) | Qué corre en cada PR y en cada merge, linter, pruebas, granja de dispositivos, responsive, seguridad, ambientes, versionado y rollback |
| [`docs/arquitectura.md`](docs/arquitectura.md) | Arquitectura de la app: features por capas, estado, repositorios, i18n (fuente para agentes) |
| [`docs/integracion-backend.md`](docs/integracion-backend.md) | Ambientes, cliente GraphQL, errores, fakes y contrato con el backend |
| [`docs/observabilidad.md`](docs/observabilidad.md) | Logs en desarrollo, Sentry con captura y video, y cómo reproducir un error de un usuario |
| [`docs/plan-sentry.md`](docs/plan-sentry.md) | Paso a paso para implementar Sentry en web y mobile |
| [`docs/pruebas-exploratorias.md`](docs/pruebas-exploratorias.md) | Cómo hacer la sesión exploratoria de cada sprint, con checklist |
| [`docs/evidencias/`](docs/evidencias/README.md) | Evidencias de pruebas manuales y de dispositivo, con plantilla |
| [`CLAUDE.md`](CLAUDE.md) | Contexto corto para agentes (y para quien llega nuevo) |

`docs/ci-cd.md` marca cada pieza como **hoy**, **listo, falta cuenta** (el workflow existe y espera los secretos de Firebase) o **pendiente**. Quien cambie algo actualiza el documento en el mismo PR.

## Correr la app en local

### Con el devcontainer (obligatorio)

**Qué es un devcontainer:** un contenedor de Docker descrito en la carpeta `.devcontainer/` (`Dockerfile` + `devcontainer.json`, un estándar abierto). Trae Flutter 3.47.8, JDK 17 y el Android SDK ya instalados. VS Code abre el repo *dentro* de ese contenedor: la terminal, el análisis de Dart y la depuración corren ahí, y tus archivos siguen en tu disco. El CI usa la misma imagen, así que lo que pasa en tu máquina pasa en el pipeline.

Prerrequisitos (no hace falta instalar Flutter, Dart, JDK ni Android SDK):

| Sistema | Instalar |
|---|---|
| Windows 10/11 | [Docker Desktop](https://www.docker.com/products/docker-desktop/) con WSL2, [VS Code](https://code.visualstudio.com/) + extensión **Dev Containers**, Android Studio (solo para el emulador y `adb`) |
| Mac | Docker Desktop (chip M: activar "Use Rosetta" en Settings → General), VS Code + Dev Containers, Android Studio |
| Linux | Docker Engine, VS Code + Dev Containers, Android Studio |

Primera vez:

1. Clonar el repo y abrirlo en VS Code.
2. `Ctrl/Cmd+Shift+P` → **Dev Containers: Reopen in Container**. La primera vez arma la imagen (unos minutos si ya está publicada en GHCR, hasta 20 si se compila desde cero); después abre en segundos. Al crearse, el contenedor verifica la versión de Flutter, corre `flutter pub get` e instala el hook de pre-push.
   En Docker Desktop, dale al menos 8 GB de memoria (Settings → Resources): Gradle la necesita para compilar el APK.
3. En Android Studio → Device Manager, crear un emulador (API 34 o más) y arrancarlo.

Cada día:

1. Arrancar el emulador (o conectar el teléfono por USB con depuración activada).
2. En una terminal **de tu máquina**: en Mac basta con `adb start-server` (Docker Desktop lleva `host.docker.internal` al localhost del Mac); en Windows y Linux, `adb kill-server && adb -a nodaemon server start` y dejarla abierta (solo en redes de confianza: abre el puerto 5037). Así el contenedor ve el emulador y el teléfono.
3. En VS Code (ya dentro del contenedor): `flutter devices` debe listar el emulador.
4. `flutter run` (o F5). La app aparece en el emulador; `r` recarga en caliente.
5. Antes del PR, en la misma terminal: `tool/verificar.sh` (formato, análisis y pruebas; con `--apk` también compila el APK de dev, como el CI). El hook corre lo mismo en cada `git push` desde el contenedor.

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
| Comando del paso 2 de "Cada día" | En PowerShell: `adb kill-server; adb -a nodaemon server start` (aceptar el aviso del firewall solo para redes privadas) | `adb start-server` (sin `-a`, no abre el puerto a la red) | Igual que Mac Intel | `adb kill-server && adb -a nodaemon server start` |
| Cómo llega el contenedor al `adb` | `host.docker.internal` (Docker Desktop lo trae) | Igual | Igual | El `devcontainer.json` agrega `--add-host=host.docker.internal:host-gateway`, porque Docker Engine no lo define solo |
| Velocidad | Normal | Normal | Analyze, test y goldens normales; el build del APK 2 a 3 veces más lento (el Android SDK no tiene binarios para Linux ARM, el contenedor corre emulado) | Normal |

Sin VS Code se puede usar la CLI oficial (`npm i -g @devcontainers/cli`, luego `devcontainer up --workspace-folder .` y `devcontainer exec --workspace-folder . flutter test`). Detalle, versiones y por qué el emulador queda fuera del contenedor: [`docs/entorno-local.md`](docs/entorno-local.md#devcontainer-obligatorio).

### Sin el devcontainer

No se usa: `tool/verificar-versiones.sh` falla si la versión de Flutter no es 3.47.8, y los goldens solo coinciden con los del CI dentro del contenedor. Si una emergencia obliga a trabajar fuera, instala exactamente Flutter 3.47.8 y JDK 17 y corre `tool/verificar.sh` antes de subir.

### Linter y formato

- VS Code dentro del contenedor formatea y corrige al guardar (lo configura `devcontainer.json`).
- `analysis_options.yaml` usa `flutter_lints` con análisis estricto y reglas extra de async y recursos.
- El hook de pre-push y el job `mobile` del CI corren `dart format --set-exit-if-changed` y `flutter analyze` (falla incluso con hallazgos de nivel info). Para corregir el formato: `dart format .`.

Detalle en [`docs/ci-cd.md`](docs/ci-cd.md#linter-y-formato).

### Firmado

En tu máquina el build de release se firma con la llave de debug. El firmado de verdad pasa solo en el CI (`tool/firma.sh` escribe la llave de cada ambiente desde los secretos). Nunca subas un keystore, `key.properties` ni `key-dev.properties` al repo.

### Ambientes

Dos apps que conviven en el teléfono, cada una con sus propios datos (paquete distinto):

```bash
flutter run                                                          # "Solventa Dev" (dev es el flavor por defecto)
flutter run --flavor prod --dart-define-from-file=config/prod.json   # "Solventa"
```

Detalle en [`docs/ci-cd.md`](docs/ci-cd.md#ambientes-dev-y-prod).

## Trazabilidad y reporte de errores (Sentry)

Decisión del equipo (2026-10-25), igual en la app y en la web; falta implementarla con [`docs/plan-sentry.md`](docs/plan-sentry.md):

- **Sentry** recibe cada error y cierre de la app de los usuarios, con breadcrumbs, captura de pantalla y un **video (Session Replay) de lo que pasó antes**, grabado solo cuando hay un error y con todo el texto y las imágenes enmascarados. Las pantallas de pago, documento, cámara y billetera quedan fuera.
- Cada petición al BFF lleva un encabezado **`traceparent`**; el backend escribe ese id en Cloud Logging y Cloud Trace, así un error se sigue de la pantalla al servicio que falló.
- La pantalla de error muestra un **código de soporte** (los primeros 8 caracteres del id): con él se encuentra el reporte en Sentry y la traza del backend.
- Sin datos personales en logs, reportes, capturas ni videos. En desarrollo, logs con `package:logging` (nunca `print`).

Detalle: [`docs/observabilidad.md`](docs/observabilidad.md).

## Flujo de ramas

| Origen | Destino | Uso |
|---|---|---|
| `feat\|fix\|chore/KAN-N-descripcion` | `develop` | Trabajo diario (squash) |
| `fix\|chore/KAN-N-descripcion` | `release/sprint-N` | Correcciones durante la estabilización |
| `release/sprint-N` | `main` | Liberación de fin de sprint |
| `hotfix/KAN-N-descripcion` | `main` | Corrección urgente |
| `main` | `develop` | Reintegración tras cada release o hotfix |

Título del PR: `tipo(alcance): KAN-N descripción`, por ejemplo `feat(mobile): KAN-24 login biométrico`. Decide la próxima versión: `feat` sube la menor, `fix` el parche.

`main` y `develop` están protegidas por ruleset (`.github/rulesets/`): PR obligatorio, 1 aprobación y los checks `mobile`, `Título del PR`, `Nombre de rama`, `Secretos (gitleaks)` y `Workflows (actionlint)` en verde.

## CI y CD en pocas líneas

- **Cada PR:** formato, análisis, pruebas y APK de dev dentro del devcontainer, más gitleaks, actionlint y osv-scanner.
- **Cada merge a `develop`:** APK "Solventa Dev" firmado, MobSF, pruebas en 3 emuladores y, cuando exista Firebase, App Distribution.
- **Cada merge a `main`:** versión calculada sola, APK y AAB de prod firmados y ofuscados, GitHub Release con el APK para instalar (sin tienda por ahora).
- **Manual:** rollback de una versión y Test Lab en teléfonos reales.

Todo el detalle está en [`docs/ci-cd.md`](docs/ci-cd.md) y los diagramas en [`docs/diagramas.md`](docs/diagramas.md).
