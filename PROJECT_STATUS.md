# Estado del proyecto: Solventa Frontend Mobile

Corte: **2026-10-31**. Resumen ejecutivo para agentes y desarrolladores al iniciar sesión. Las reglas viven en
[`CLAUDE.md`](CLAUDE.md), la arquitectura en [`docs/arquitectura.md`](docs/arquitectura.md) y la integración con el BFF en
[`docs/integracion-backend.md`](docs/integracion-backend.md).

## Propósito y stack

App móvil nativa para **Android** en Flutter 3.47.8 (Dart 3.11, Riverpod, `go_router`, `graphql_codegen`, `alchemist`,
`camera`, `local_auth`, `flutter_secure_storage`, `shared_preferences`, `sentry_flutter`). Consume el BFF GraphQL por
`/graphql/app`. Todo comando de Flutter se ejecuta dentro del devcontainer (`.devcontainer/`).

## Estado actual (HU-M01 y núcleo de experiencia móvil completos)

- **Flujo de entrada, registro con OTP y autenticación (`G-03`, `M01-05b`, `M01-05c`):**
  - `G-03` (`/acceso`, `G03AccesoPage`): pantalla inicial cuando no hay sesión activa; permite elegir entre «Crear cuenta»
    e «Iniciar sesión» manteniendo el header con el selector de idioma y moneda.
  - `M01-05b` (`/onboarding/cuenta`, `M0105bCuentaPage`): captura correo y contraseña, solicita el código OTP de 6
    dígitos (`solicitarCodigoOnboarding`) y navega a `M01-05c`.
  - `M01-05c` (`/onboarding/codigo`, `M0105cCodigoPage`): verifica el código OTP de 6 dígitos enviado al correo
    (`verificarCodigoOnboarding`), crea la cuenta en estado `PENDIENTE_VERIFICACION` de forma idempotente y abre el
    `Home` con la tarjeta «Completa tu registro».
- **Home dinámico (`HomePage`, `/`):**
  - Antes de completar la verificación KYC muestra «Bienvenido a Solventa» y el estado actual del onboarding (`Completa tu
    registro`, `Identidad en revisión` o `No pudimos verificar tu identidad`).
  - Una vez verificada la identidad (`VERIFICADA`), actualiza el JWT (`actualizarSesion`), consulta `yo` y saluda con el
    nombre real extraído del OCR de la cédula (`Hola, <Nombre>`).
- **Captura biométrica centrada y validación en vivo (`M01-01` a `M01-08`):**
  - `SolCameraFrame` y `SolLiveCameraFrame` centran horizontalmente los marcos de documento (4:3) y rostro circular (220 dp)
    en todos los breakpoints (360 dp, 390 dp, 600 dp y horizontal) y embeben el preview de cámara en vivo con fallback
    seguro en emulador/pruebas.
  - Las capturas (`ANVERSO`, `REVERSO`, `ROSTRO`, `VIDEO`) se conservan en memoria (`_capturasEnMemoria`) durante la
    sesión y se suben en paralelo en segundo plano (`Future.wait`) mediante URLs firmadas V4 a Cloud Storage
    (`{tipo}/{AAAA}/{MM}/{archivo_id}`).
  - **Opción B activa en `M01-05`:** si Didit rechaza únicamente el reconocimiento facial en vivo (`ROSTRO_NO_COINCIDE` o
    `SUPLANTACION`) y quedan intentos, se conservan en memoria las fotos del frente y reverso de la cédula y el usuario
    repite solo la toma facial en `M01-05` sin volver a fotografiar el documento.
  - **Pantallas de desenlace (`M01-07a`, `M01-07b`, `M01-07c`) y biometría (`M01-08`):**
    - `M01-07a`: identidad verificada → `M01-08` (`local_auth` real para huella/rostro) → `Home`.
    - `M01-07b`: identidad en revisión (cuando el proveedor KYC tarda o está degradado, `EC010`).
    - `M01-07c`: identidad rechazada (muestra el motivo exacto, código de soporte de Sentry con botón de copiado y
      «Reintentar» inteligente según si falló el documento o el rostro).
- **Preferencias de idioma y moneda (`SolPreferenciasSheet`):**
  - Modal bottom sheet al tocar `SolLocaleChip` en el header: permite elegir idioma (`ES` / `EN`) y cualquiera de las 7
    monedas soportadas en la plataforma (`COP`, `MXN`, `BRL`, `CLP`, `PEN`, `USD`, `EUR`), persistidas en
    `SharedPreferences`.
- **Perfil y cierre de sesión (`G-05`, `G-04`):**
  - `G-05` (`/perfil`, `G05PerfilPage`): muestra nombre (cuando ya fue verificado), correo, documento enmascarado, estado
    de verificación, acceso a idioma/moneda y botón «Cerrar sesión» que abre el modal de confirmación `G-04`
    (`mostrarConfirmacionCerrarSesion`).
- **Observabilidad y privacidad con Sentry (`uniandes-xm`):**
  - `sentry_flutter`, `sentry_dio`, `SolLog` (`lib/core/log/sol_log.dart`), `limpiar` (`lib/core/log/limpiar.dart`),
    `SentryMask` en `M01-03`..`M01-05`, bloqueo de screenshots en rutas de captura y subida de símbolos en
    `.github/workflows/cd.yml` y `rollback.yml`.
- **Catálogo visual HTML:**
  - `docs/Capturas_App_Completa.html` generado desde `test/goldens/platform/` (`SOL_PLATFORM_GOLDENS=1`) con fuente `Inter`
    e íconos reales en todos los anchos, idiomas y escalas de texto.
