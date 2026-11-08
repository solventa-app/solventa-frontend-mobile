# HU-M02 · Prueba con biometría real (2026-11-08)

Emulador Pixel 3a, API 36 (Android 16, imagen Google Play), con PIN y una huella registrada; app `dev` contra el
gateway de staging, en `develop` + #51 (`ebb70d8`). Huella con `adb -e emu finger touch 1` (registrada) y `2` (no
registrada). Las capturas quedaron fuera del repo, en el equipo de quien probó.

## M01-08 (casos de `validar-local-auth-android.md`)

| # | Caso | Resultado |
|---|---|---|
| 1 | PIN + huella, dedo 1 | Pasa: avanza |
| 2 | Dedo 2, cinco veces | Android 16 bloquea el teléfono entero («Device locked»); la app recibe «cancelado» y no muestra el aviso de bloqueo temporal. Comportamiento del sistema |
| 3 | Cancelar el diálogo | Se queda en M01-08 sin aviso (a propósito) |
| 4 | «Usar PIN» en el diálogo | Pasa: aparece y el PIN entra |
| 5 | Solo PIN, sin huella | Pasa: avisa que sigue con el PIN y lo pide |
| 6 | Sin bloqueo de pantalla | Pasa: aviso de «no tiene bloqueo de pantalla» |
| 7 | «Ir a configuración» | Falla con PIN (con o sin huella): Ajustes se cierra solo. Corregido en #55 (falta repetirlo) |

## M02

| Caso | Resultado |
|---|---|
| Login → cerrar la app → reabrir → M02-01 → huella → M02-03 → Home | Pasa (también tras reiniciar el emulador) |
| Dedo 2 en M02-01 | El diálogo muestra «Not recognized»; al 5.º intento, aviso de demasiados intentos y «Usar PIN del teléfono», que desbloquea. Ver decisión abajo |
| Reintentar en M02-01a (con el disparador de demo) | Pasa |
| Cancelar el diálogo en M02-01 | Pasa: se queda en M02-01 |
| Cerrar sesión (G-04) → reabrir | Pasa: «Inicia sesión», sin M02-01 |
| 5 min en segundo plano | Pasa en 1 de 2 intentos; en el otro se vio el Home unos segundos antes de M02-01. Intermitente, sin causa encontrada |

## Decisión: M02-01a con huella real

En Android, `BiometricPrompt` no devuelve el fallo de una huella que no coincide: muestra «Not recognized» dentro del
diálogo y deja intentar de nuevo; al 5.º fallo cierra con bloqueo temporal y la app muestra su aviso con «Usar PIN del
teléfono». Por eso M02-01a «No te reconocimos» casi no aparece en el uso normal: solo si `local_auth` devuelve `false`.

Se acepta así (2026-11-08): es el comportamiento estándar de Android y la persona sí recibe aviso y salida por PIN.
M02-01a se queda como estado de respaldo, con sus pruebas, y en pruebas manuales se ve con el disparador de demo. Quien
compare contra Figma no debe marcarlo como fallo. Se descartó mostrar M02-01a al cancelar: la app no sabe cuántos
intentos fallaron dentro del diálogo y la mostraría también a quien solo cerró el diálogo.

## Pendiente

- Título y subtítulo del diálogo del sistema en inglés («Authentication required»): falta pasar `AndroidAuthMessages`.
- Errores `ErrorGraphql` y `_Rechazo` en el log tras desbloquear: revisar en Sentry.
- Repetir el caso 7 con #55 y probar en API 34 o 35.
