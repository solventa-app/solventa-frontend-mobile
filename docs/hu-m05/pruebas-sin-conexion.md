# HU-M05 · Pruebas en teléfono del reporte sin conexión (KAN-35)

Lo que `flutter test` no puede comprobar: la librería nativa de la base cifrada, el modo avión de verdad, la huella
sin red, las notificaciones y el servicio en primer plano. Se corre en un teléfono o emulador Android con el backend
de `dev` (con `API_ENV=mock` la entrada sin red no se puede ensayar). Estado: **pendiente**.

Antes de empezar, dentro del devcontainer:

```bash
tool/verificar.sh --apk        # formato, análisis, pruebas y APK de dev
tool/goldens.sh test/goldens   # si el CI rechazó algún golden generado fuera del contenedor
```

Cuenta de prueba: verificada, con al menos una póliza de auto vigente, y el teléfono con bloqueo de pantalla y huella.

## 1. Se cae la red mientras se reporta

| # | Paso | Se espera |
|---|---|---|
| 1.1 | Con Wi-Fi, abrir «Reportar un siniestro» y llegar al relato. Activar modo avión | La franja «Sin conexión» aparece en pocos segundos. El botón dice «Guardar y enviar después» |
| 1.2 | Tocar «Guardar y enviar después» | «Reporte guardado», sin radicado, con la hora y el aviso de que se pierde si se desinstala |
| 1.3 | «Ver mis siniestros» | El reporte está en «Por enviar» como «Pendiente de envío». La franja dice «1 reporte por enviar» |
| 1.4 | Quitar el modo avión, con la app abierta | La franja pasa a «Enviando 1 reporte…» y luego a «Reporte enviado» con el radicado. En la mesa de siniestros (web) hay **un solo** caso |
| 1.5 | Repetir 1.1 a 1.3, cerrar la app desde recientes, quitar el modo avión y abrirla | Se envía sola al abrir. Un solo caso |
| 1.6 | Repetir 1.1 a 1.3, dejar la app en segundo plano y quitar el modo avión | Llega la notificación «Reporte enviado» con el radicado; al tocarla abre el caso |

## 2. Borradores

| # | Paso | Se espera |
|---|---|---|
| 2.1 | Empezar un reporte, tomar 2 fotos, escribir medio relato y cerrar la app desde recientes | Al abrir, «Mis siniestros» lo muestra como «Sin terminar» con sus 2 fotos |
| 2.2 | «Continuar reporte» | Vuelve al paso donde iba, con las fotos y el texto |
| 2.3 | «Descartar reporte» y confirmar | Desaparece de la lista |
| 2.4 | Tener 5 reportes sin enviar y empezar otro | La app no deja crear el sexto y dice por qué |

## 3. Datos móviles

| # | Paso | Se espera |
|---|---|---|
| 3.1 | Sin Wi-Fi, con datos, enviar un reporte por primera vez | Hoja «Estás usando datos móviles» con el peso aproximado de las fotos |
| 3.2 | «Esperar Wi-Fi» | «Reporte guardado»; en la lista, «Esperando Wi-Fi». En Mi perfil el interruptor queda encendido |
| 3.3 | Conectar el Wi-Fi | Se envía solo |
| 3.4 | Con el interruptor apagado en Mi perfil, enviar con datos | Sale de una vez, sin preguntar |

## 4. Envío al salir de la app (servicio en primer plano)

| # | Paso | Se espera |
|---|---|---|
| 4.1 | Con 3 fotos grandes y una red lenta, tocar «Enviar reporte» y salir al inicio del teléfono | Notificación fija «Enviando tu reporte · N %» con barra de progreso. El envío termina sin volver a abrir la app |
| 4.2 | Durante 4.1, activar modo avión | La notificación pasa a «Envío en pausa · N %». Al volver la red, retoma |
| 4.3 | Durante 4.1, quitar la app de recientes | El servicio se detiene con la app. Al abrirla, la cola retoma desde la foto que faltaba, sin duplicar el caso |
| 4.4 | Android 14 o superior: repetir 4.1 | No hay cierre de la app ni error de permiso del tipo de servicio (`dataSync`) |

## 5. Abrir la app sin red

| # | Paso | Se espera |
|---|---|---|
| 5.0 | Iniciar sesión con red en un teléfono recién instalado y **no** abrir «Reportar un siniestro» ni «Mis siniestros». Cerrar la app, modo avión, abrirla con la huella y tocar «Reportar un siniestro» | Las pólizas aparecen («Pólizas guardadas en este teléfono el…»): se bajaron al entrar. No sale «Conéctate una vez para descargar tus pólizas» |
| 5.1 | Con sesión iniciada y huella activa, cerrar la app. Modo avión. Abrirla y poner la huella | Entra al inicio: «Solicitar asistencia» y «Mi cobertura» dicen «Necesita conexión»; «Reportar un siniestro» y «Mis siniestros» funcionan |
| 5.2 | Reportar de principio a fin | Las pólizas salen de lo guardado («Pólizas guardadas en este teléfono el…»). El GPS es obligatorio. Termina en «Reporte guardado» |
| 5.3 | Abrir Mi perfil | Nombre y «Cuenta activa»; correo y documento piden conexión; «Envío de reportes» funciona; la huella dice «Activada · con ella entraste sin conexión» |
| 5.4 | Quitar el modo avión | Sin pedir la huella otra vez, el inicio se activa completo y el reporte de 5.2 se envía |
| 5.5 | En modo sin conexión, dejar la app 15 min en segundo plano y volver | Pide la huella de nuevo y vuelve a entrar sin red |
| 5.6 | Teléfono sin sesión guardada, en modo avión | «Inicia sesión» explica que para entrar sin internet hay que haber iniciado sesión antes en ese teléfono |
| 5.7 | Sesión guardada de una cuenta **sin verificar**, en modo avión | Se queda en el desbloqueo con «No hay conexión» y «Reintentar» |
| 5.8 | En modo sin conexión, «Cerrar sesión» con un reporte guardado | El diálogo dice cuántos hay. Sin marcar la casilla, al volver a entrar con la misma cuenta el reporte sigue ahí |

## 6. Rechazo y recordatorios

| # | Paso | Se espera |
|---|---|---|
| 6.1 | Guardar sin red un reporte con una fecha fuera de la vigencia de la póliza y volver la red | Queda «Con error» con el motivo de la aseguradora. «Corregir y enviar» abre el reporte con todo |
| 6.2 | Dejar un reporte pendiente sin red | Recordatorios a los 30 min, 3 h y 24 h, nunca entre 10 p. m. y 7 a. m. Se cancelan al enviarse |
| 6.3 | Ajustes del teléfono, notificaciones de Solventa | Hay un canal «Reportes de siniestro» y otro silencioso, «Envío de reportes», separados de los de asistencia |

## 7. Seguridad y accesibilidad

| # | Paso | Se espera |
|---|---|---|
| 7.1 | Con un reporte guardado y un APK de depuración, copiar `files/dev.solventa.offline.db` con `adb shell run-as com.solventa.solventa_mobile.dev` y abrirlo con `sqlite3` | El archivo no se puede leer sin la llave («file is not a database») |
| 7.2 | `adb logcat` durante todo el recorrido | Ningún dato personal, relato, coordenada ni radicado en los registros |
| 7.3 | TalkBack en la franja, la lista «Por enviar» y la hoja de datos | Cada estado se anuncia con texto, no solo con color |
| 7.4 | Texto del sistema al 200 % en un teléfono de 360 dp | Sin textos cortados ni botones fuera de la pantalla |

## Evidencia

Capturas y resultado en `docs/evidencias/AAAA-MM-DD-hu-m05-sin-conexion.md`, con el modelo de teléfono, la versión de
Android y el commit probado.
