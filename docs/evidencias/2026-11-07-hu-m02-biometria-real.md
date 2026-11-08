# HU-M02 · Biometría real en emulador (2026-11-07)

KAN-32 (HU-M02) · KAN-228 · KAN-135. Prueba de M01-08 (activar biometría) y M02 (desbloqueo) con el `local_auth` real
y el gateway de staging, no con el fake de `config/mock.json`. Casos del plan de validación de `local_auth` en Android de HU-M02.

## Entorno

| Pieza | Valor |
|---|---|
| App | `fix/KAN-226-prueba-integracion-m02` (`ebb70d8`, igual a `develop` tras el PR #51), APK `dev` debug con `config/dev.json` (gateway de staging) |
| Flutter | 3.47.8 |
| Dispositivo | Emulador Pixel 3a, Android 16 (API 36), imagen Google Play arm64 |
| Bloqueo y huella | `adb shell locksettings set-pin`, huella registrada en Ajustes con `adb -e emu finger touch 1` |
| Huella | Dedo 1 registrado; dedo 2 sin registrar (`adb -e emu finger touch 2`) |
| Cuenta | CLIENTE nueva creada con el registro de la app (código OTP al correo); identidad sin verificar |
| M01-08 | Se abrió con un acceso temporal en modo debug (no se subió): la pantalla solo se alcanza al final del registro |

Capturas: [`capturas/2026-11-07-hu-m02-biometria-real/`](capturas/2026-11-07-hu-m02-biometria-real/). El diálogo del
sistema es una ventana segura: `adb exec-out screencap` sale negro y se capturó con `adb emu screenrecord screenshot`.

## M01-08 · Activa tu biometría

| # | Caso | Esperado | Resultado | Captura |
|---|---|---|---|---|
| 1 | PIN + huella, dedo 1 | Pasa | Pasa y avanza | `m0108-01-inicial`, `m0108-c1-c4-dialogo` |
| 2 | Dedo 2, 5 veces | Falla y bloqueo temporal | **Distinto:** 4 veces «Not recognized» en el diálogo; al quinto Android 16 bloquea el teléfono («Device locked · Failed authentication»). Al desbloquear con el PIN, la app recibe «cancelado» y queda en M01-08 sin aviso | `m0108-c2-tras5` |
| 3 | Cancelar el diálogo | Se queda | Se queda en M01-08 sin aviso (así lo trata el código) | — |
| 4 | ¿«Usar PIN» en el diálogo? | Sí | Sí, «Use PIN»; el PIN del teléfono pasa | `m0108-c1-c4-dialogo` |
| 5 | Solo PIN, sin huella | ¿PIN o falla? | Aviso «no tiene huella ni rostro… puedes continuar con el PIN»; pide el PIN y avanza | `m0108-c5-solo-pin-pantalla` |
| 6 | Sin bloqueo de pantalla | Aviso | «Tu teléfono no tiene bloqueo de pantalla…»; «Ya lo activé» no avanza | `m0108-c6-sin-bloqueo` |
| 7 | «Ir a configuración del teléfono» | Abre Ajustes | **Falla con PIN puesto** (con o sin huella): Ajustes abre y se cierra solo. Sin bloqueo de pantalla sí abre «Choose a screen lock» | `m0108-c7-ajustes-sin-bloqueo` |

## M02 · Desbloqueo

| # | Caso | Esperado | Resultado | Captura |
|---|---|---|---|---|
| 1 | Sesión abierta → cerrar la app → reabrir | M02-01 con diálogo automático; dedo 1 → M02-03 → Home | Pasa, entrando por el registro y por login con correo y clave | `m02-c1-m0201-desbloquea`, `m02-c1-m0203-concedido` |
| 2 | Dedo 2 | M02-01a con «Reintentar» y «Usar PIN del teléfono» | **Distinto (D6):** el diálogo sigue abierto con «Not recognized»; tras 5 intentos, M02-01 muestra «Hiciste demasiados intentos…» con «Usar PIN del teléfono». El PIN desbloquea → Home | `m02-c2-dedo2-tras5` |
| 3 | M02-01a por el disparador de demo | «Reintentar» abre el diálogo | Pasa; dedo 1 → Home | `m02-c2-m0201a-demo` |
| 4 | Cancelar el diálogo de M02-01 | Se queda | Se queda en M02-01 | — |
| 5 | Cerrar sesión (G-04) y reabrir | No sale M02-01 | Pasa: «Inicia sesión». Desde Mi perfil no se probó: solo se abre con identidad verificada | `m02-c4-confirmar-cierre`, `m02-c4-sin-sesion` |
| 6 | 5 min en segundo plano | Vuelve a M02-01 | Pasa en el segundo intento (log «Sesión bloqueada tras 5 min en segundo plano»). En el primero se vio el Home unos segundos antes de pedir la huella: intermitente, 1 de 2 | — |
| 7 | Reiniciar el emulador | Sesión guardada | Pasa: tras el arranque sale M02-01 y la huella entra | — |

## Hallazgos

1. **«Ir a configuración del teléfono» no abre nada si el teléfono ya tiene PIN** (M01-08 y avisos de M02).
   `AjustesSeguridad.kt` abre `Settings.ACTION_BIOMETRIC_ENROLL` con `BIOMETRIC_STRONG | DEVICE_CREDENTIAL`; con PIN
   puesto el requisito ya se cumple y `BiometricEnrollActivity` termina sin mostrar nada. `startActivity` no falla, así
   que nunca se prueba `ACTION_SECURITY_SETTINGS`. Logcat:

   ```text
   D BiometricEnrollActivity: Authenticators: Unknown authenticator type: 32783
   E BiometricEnrollActivity: Unexpected result (has enrollments): 0
   ```

2. **M02-01a no aparece con huella real (decisión D6).** Se acepta: el aviso lo da el diálogo del sistema y, tras 5
   intentos, M02-01 ofrece el PIN. M02-01a queda de respaldo. Ver `docs/hu-m02-jira.md` §3 y §5.9 y
   `docs/arquitectura.md` §8.
3. **Android 16 bloquea el teléfono a los 5 fallos en M01-08**, y la app no muestra su aviso de bloqueo temporal (le
   llega «cancelado»). En M02 (solo biometría) sí llegó el bloqueo temporal. Falta repetirlo en API 34 o 35.
4. **El título del diálogo del sistema sale en inglés** («Authentication required», «Verify identity»); solo el motivo
   viene del catálogo de idiomas.
5. **Errores sin detalle tras desbloquear:** `[SEVERE] Falla inesperada de cliente (ErrorGraphql)` y `Falla inesperada al
   procesar respuesta (_Rechazo)` en el log de la app, con la cuenta sin verificar. Revisar en Sentry.
6. **Bloqueo tras 5 min intermitente** (1 de 2), ver M02 caso 6.
