# Diagramas

Cómo fluye el código de tu máquina a los teléfonos, y cómo se corre el proyecto en local. El detalle de cada pieza está en [`ci-cd.md`](ci-cd.md), [`entorno-local.md`](entorno-local.md) y [`pruebas-exploratorias.md`](pruebas-exploratorias.md). GitHub dibuja los bloques Mermaid solo.

## 1. Correr el proyecto en local

```mermaid
flowchart LR
  subgraph Maquina["Tu máquina (Windows, Mac o Linux)"]
    VS["VS Code + Dev Containers"]
    EMU["Emulador<br/>(Android Studio → Device Manager)"]
    TEL["Teléfono por USB<br/>(depuración USB activa)"]
    ADB["Servidor adb<br/>Mac: adb start-server<br/>Windows/Linux: adb -a nodaemon server start"]
    EMU --- ADB
    TEL --- ADB
  end
  subgraph Contenedor["Devcontainer (misma imagen que el CI)"]
    SDK["Flutter 3.47.8 · Dart 3.13.7<br/>JDK 17 · Android SDK 36 · NDK"]
    RUN["flutter run<br/>(flavor dev por defecto)"]
    CHK["tool/verificar.sh<br/>formato · análisis · pruebas"]
    HOOK["lefthook pre-push<br/>(lo mismo, antes de cada push)"]
  end
  VS -- "Reopen in Container" --> Contenedor
  RUN -- "ADB_SERVER_SOCKET<br/>host.docker.internal:5037" --> ADB
  CHK --> HOOK
  HOOK -- "git push" --> GH["GitHub: abrir PR"]
```

Pasos de cada día:

1. VS Code → "Reopen in Container" (la primera vez descarga la imagen).
2. Abrir el emulador o conectar el teléfono, y en una terminal de tu máquina: en Mac `adb start-server`; en Windows y Linux `adb kill-server && adb -a nodaemon server start`.
3. En la terminal del contenedor: `flutter devices` y `flutter run`.
4. Antes del PR: `tool/verificar.sh` (el hook de pre-push lo corre solo).

## 2. CI/CD de punta a punta

```mermaid
flowchart TD
  DEV["Rama feat|fix|chore/KAN-N-…"] -->|PR| PRD{{"PR a develop"}}
  subgraph ChecksPR["Checks de cada PR (develop o main)"]
    C1["mobile (en el devcontainer)<br/>versiones · format · analyze<br/>unit + widget + goldens · cobertura<br/>APK dev en release (R8)"]
    C2["Título del PR · Nombre de rama"]
    C3["Seguridad: gitleaks · actionlint · SHA<br/>osv-scanner (informativo)"]
  end
  PRD --> ChecksPR
  ChecksPR -->|"1 aprobación + squash"| D[("develop")]

  subgraph Develop["Cada merge a develop"]
    D1["APK Solventa Dev firmado<br/>versión 1.3.0-dev.N"]
    D2["App Distribution → grupo qa"]
    D3["MobSF sobre el APK<br/>(reporte PDF/JSON)"]
    D4["Emuladores: integration_test<br/>teléfono pequeño API 28<br/>teléfono grande API 34 · tablet API 34"]
    D1 --> D2
    D1 --> D3
  end
  D --> Develop

  D -->|"fin de sprint"| REL["release/sprint-N<br/>(solo fix|chore)"]
  REL --> EXP["Sesión exploratoria<br/>docs/evidencias/EXP-sprint-N.md"]
  REL --> TL["Test Lab (manual)<br/>Robo test + integration_test<br/>en teléfonos reales"]
  REL -->|"PR + merge commit"| M[("main")]
  HOT["hotfix/KAN-N-…"] -->|PR| M

  subgraph CD["Cada merge a main (cd.yml)"]
    P1["Versión desde los títulos de PR<br/>git-cliff: feat → menor, fix → parche"]
    P2["Build prod en el devcontainer<br/>firmado · R8 · --obfuscate<br/>--split-debug-info"]
    P3["GitHub Release v1.3.0+57<br/>APK · AAB · mapping · símbolos"]
    P4["Instalar el APK del Release<br/>(sin tienda por ahora)"]
    P1 --> P2 --> P3 --> P4
  end
  M --> CD
  M -->|"reintegración"| D

  RB["rollback.yml (manual)<br/>tag viejo → build nuevo<br/>rollback-1.2.0+58"] --> P4
```

Lo que todavía necesita cuentas (Firebase) ya está en los workflows y se salta solo mientras faltan los secretos ([`ci-cd.md`](ci-cd.md), "Pasos manuales").

## 3. Pruebas: qué corre y dónde

```mermaid
flowchart LR
  subgraph CadaPR["Cada PR · en el devcontainer"]
    U["Unitarias y de widget"]
    G["Goldens en varios tamaños<br/>y escalas de texto"]
    A["Accesibilidad<br/>meetsGuideline"]
  end
  subgraph CadaDevelop["Cada merge a develop · runner con KVM"]
    E["integration_test<br/>3 emuladores"]
  end
  subgraph CadaRelease["Cada release/sprint-N"]
    T["Test Lab<br/>Robo + integration_test<br/>teléfonos reales"]
    X["Exploratoria manual<br/>checklist de 10 puntos"]
  end
  CadaPR --> CadaDevelop --> CadaRelease
  CadaRelease --> EV["docs/evidencias/<br/>hallazgos → Jira"]
```
