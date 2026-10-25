# Pruebas exploratorias (una sesión por sprint)

La automatización cubre tamaños, overflow, contraste y recorridos, pero no ve la fricción, los textos confusos ni lo que se siente raro al usarla. Para eso hay una sesión exploratoria corta en cada sprint. La pide la Estrategia de Pruebas v4 (10 % del esfuerzo, exploratorio manual) y su evidencia cuenta para la entrega.

| | |
|---|---|
| Cuándo | La última semana de cada sprint, antes de abrir `release/sprint-N`. Se agenda en la planeación del sprint para que no se pase |
| Quién | Una persona guía (rota cada sprint) y al menos otra que prueba. Idealmente alguien que no construyó las pantallas |
| Cuánto | 60 a 90 minutos, más 15 minutos para registrar hallazgos |
| Qué sale | Un archivo `docs/evidencias/EXP-sprint-N-AAAA-MM-DD.md` (plantilla en [`evidencias/plantilla-exploratoria.md`](evidencias/plantilla-exploratoria.md)) y un ticket en Jira por cada hallazgo de gravedad media o alta |

Estado: el proceso y la plantilla son **hoy**. Cada merge a `develop` deja el APK "Solventa Dev" como artifact `apk-dev` (Actions → Develop → la última ejecución), y App Distribution lo enviará solo cuando exista la cuenta de Firebase. `device_preview` en el flavor dev está **pendiente**.

## 1. Preparar (15 min, antes de la sesión)

1. Elegir el **foco** (charter) de la sesión: las HU que entraron en el sprint y sus pantallas. Ejemplo: "Explorar el reporte de siniestro sin conexión para encontrar pérdidas de datos o mensajes confusos".
2. Copiar la plantilla a `docs/evidencias/EXP-sprint-N-AAAA-MM-DD.md` y llenar el encabezado.
3. Instalar la app en los dispositivos:
   - **Con App Distribution (cuando exista la cuenta):** abrir la invitación en el teléfono e instalar "Solventa Dev" del último build de `develop`.
   - **Hoy:** descargar el artifact `apk-dev` de la última ejecución de Develop y, con el teléfono conectado (README, "Emulador o teléfono por USB"), `adb install -r solventa-dev-*.apk`. O desde el contenedor, con `develop` actualizado: `flutter install -d <id>` (flavor dev por defecto).
4. Reunir los dispositivos: los teléfonos del equipo (anotar marca, modelo y versión de Android de cada uno) y un emulador de tablet.
5. Instalar **Accessibility Scanner** (Google, gratis en Play Store) en al menos un teléfono.

## 2. Recorrer (45 a 60 min)

Recorrer las pantallas del foco como lo haría un usuario real, y repetir pasando por cada fila de la checklist. Anotar cada hallazgo en el momento, con captura.

### Checklist de adaptabilidad

| # | Qué cambiar | Cómo | Qué buscar |
|---|---|---|---|
| 1 | Tamaño de pantalla | **Pendiente:** `device_preview` (solo en dev): botón flotante → elegir teléfono pequeño (360 dp), mediano, grande y tablet. **Hoy:** emulador de tablet y los teléfonos del equipo | Desbordes (franjas amarillas y negras), botones fuera de la pantalla, contenido que no se centra en tablet |
| 2 | Orientación | Girar el teléfono (o `device_preview` → horizontal) | Formularios que pierden datos al girar, teclado que tapa el botón principal |
| 3 | Texto grande | Ajustes → Pantalla → Tamaño de fuente al máximo (o `device_preview` → text scale 2.0) | Textos cortados o encimados, palabras partidas, botones que crecen fuera de lugar |
| 4 | Tamaño de pantalla del sistema | Ajustes → Pantalla → Tamaño de visualización al máximo | Lo mismo que el punto 3, con menos espacio |
| 5 | Idioma y formato regional | Ajustes → Sistema → Idioma (si la app ya tiene más de uno) | Textos sin traducir, montos y fechas en formato que no corresponde a `es-CO` |
| 6 | Modo oscuro | Ajustes → Pantalla → Tema oscuro (si la app lo soporta; si no, que se vea bien igual) | Texto negro sobre fondo negro, íconos invisibles |
| 7 | Accesibilidad | Activar Accessibility Scanner y pasarlo por cada pantalla; probar TalkBack en una pantalla clave | Áreas táctiles pequeñas, contraste bajo, botones sin etiqueta que TalkBack lea como "botón" |
| 8 | Red | Modo avión a mitad de un flujo; datos lentos (Opciones de desarrollador o un punto de acceso débil) | Pérdida de datos, carga infinita, errores técnicos mostrados al usuario |
| 9 | Interrupciones | Bloquear y desbloquear, ir a otra app y volver, recibir una llamada | Pantalla en blanco al volver, pasos que se reinician |
| 10 | Gestos y navegación | Botón y gesto de atrás del sistema en cada paso | Salir de la app sin aviso en un flujo a medias, volver a una pantalla que ya no aplica |

## 3. Registrar (15 min)

1. Por cada hallazgo, una fila en la tabla de la plantilla: pantalla, dispositivo, pasos, resultado esperado y obtenido, gravedad y captura.
2. Gravedad:
   - **Alta:** bloquea un flujo, pierde datos, muestra datos personales o un error técnico.
   - **Media:** el flujo se completa pero con fricción clara, o falla una guía de accesibilidad.
   - **Baja:** detalle visual o de texto.
3. Crear el ticket en Jira para las de gravedad media y alta, y poner su clave (`KAN-N`) en la fila.
4. Guardar las capturas en `docs/evidencias/capturas/EXP-sprint-N/` y enlazarlas.
5. Abrir un PR con el archivo de evidencia (`docs(docs): KAN-N evidencia exploratoria sprint N`).

## 4. Cerrar

- Lo de gravedad alta se corrige dentro del `release/sprint-N` o el release se aplaza.
- Si un hallazgo se puede automatizar (por ejemplo, un overflow en un tamaño que no estaba en los goldens), se agrega ese tamaño o esa prueba en el PR que lo corrige, para que no vuelva.
- El resultado de Test Lab (Robo test) del mismo release se anota en el mismo archivo de evidencia.
