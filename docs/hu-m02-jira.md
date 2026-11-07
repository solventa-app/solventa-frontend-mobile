# HU-M02 en Jira: qué registrar y cómo

Guía para quien actualiza el tablero de **HU-M02 · Autenticación biométrica nativa (KAN-32)** en el proyecto Solventa
(`KAN`, tablero 2, sitio `uniandes-team-wq48x4h4.atlassian.net`). Corte: 2026-11-06, KAN Sprint 3 activo.

El código de HU-M02 se escribe sin ejecutar pruebas: **las valida otro compañero**. Por eso esta guía separa con cuidado
«código entregado» de «verificado». Una issue llega a **Done** solo cuando su código está en `develop` **y** está
verificado. Nunca se mueve a Done por tener el PR abierto.

## 1. Mapa de issues

| Issue | Tipo | Qué es | Pts | Dónde se entrega |
|---|---|---|---|---|
| [KAN-32](https://uniandes-team-wq48x4h4.atlassian.net/browse/KAN-32) | Historia (épica KAN-21) | HU-M02 completa | 6 | Suma de las tareas de abajo |
| KAN-225 | Tarea · Móvil | S2-M02-1: lectura biométrica (`local_auth`) y token en Keystore (M02-01) | 2 | Mobile PR 2 (llavero y sesión) + PR 3 (servicio de biometría) + PR 4 (pantalla M02-01) |
| KAN-226 | Tarea · Móvil | S2-M02-2: no reconocida, PIN del teléfono y acceso concedido | 1,5 | Mobile PR 4 |
| KAN-227 | Tarea · Backend | S2-M02-3: AUTH, renovación y revocación del token | 1,5 | Backend PR 1 + mobile PR 2 (consumo de la renovación) |
| KAN-228 | Tarea · Móvil | S2-M02-4: pruebas en dispositivo físico y Firebase Test Lab | 0,5 | Validación del compañero (no hay PR de código: el PR 5 del plan no se hace) |
| KAN-229 | Tarea · Líder técnico | S2-M02-5: documentación técnica y revisión de código | 0,5 | Docs incluidos en cada PR + esta guía + revisión de los PRs |
| KAN-134 | Subtarea de KAN-32 | Pantalla M02-01 · Prompt de biometría nativa | — | Mobile PR 4 |
| KAN-135 | Subtarea de KAN-32 | Pantalla M02-01a · Biometría no reconocida | — | Mobile PR 4 |
| KAN-136 | Subtarea de KAN-32 | Pantalla M02-02 · Ingreso alterno con PIN | — | **Cambia por la decisión D2** (sección 3) |
| KAN-174 | Subtarea de KAN-32 | Pantalla M02-02b · PIN ingresado | — | **No se construye por la decisión D2** (sección 3) |
| KAN-137 | Subtarea de KAN-32 | Pantalla M02-03 · Acceso concedido | — | Mobile PR 4 |
| KAN-115 | Historia habilitadora | HA-SEG-005: biometría y token cifrado en hardware | — | Se cumple con desviaciones documentadas (sección 4) |
| KAN-66 | Historia habilitadora | HA-SEG-004: OAuth2/JWT con scopes y antifraude ≤ 1 s | — | Fuera de HU-M02: solo la rotación del refresh (sección 4) |

Las tareas KAN-225 a KAN-229 se relacionan con KAN-32 por enlace «Relates» (no son subtareas), llevan la etiqueta
`HU-M02` y la estimación en el campo de story points (`customfield_10076`). **No se cambian los puntos**: la estimación
original se conserva aunque el alcance cambie por D2; la diferencia se explica en un comentario (sección 5).

## 2. Ramas y PRs

| PR | Repo | Rama | Título del PR | Issues que mueve |
|---|---|---|---|---|
| 1 | `solventa-backend` | `feat/KAN-227-refresh-gracia-hu-m02` | `feat(auth): KAN-227 período de gracia del refresh y Newman de la sesión de HU-M02` | KAN-227 |
| 2 | `solventa-frontend-mobile` | `feat/KAN-227-sesion-refresh-hu-m02` | `feat(mobile): KAN-227 sesión con refresh cifrado en el Keystore, renovación silenciosa y cierre que revoca` | KAN-227 (lado móvil), avance de KAN-225 |
| 3 | `solventa-frontend-mobile` | `feat/KAN-225-biometria-compartida-hu-m02` | `feat(mobile): KAN-225 …` | KAN-225 |
| 4 | `solventa-frontend-mobile` | `feat/KAN-226-pantallas-m02` | `feat(mobile): KAN-226 …` | KAN-226, KAN-134, KAN-135, KAN-136, KAN-137, KAN-174 |

Las ramas de mobile están **apiladas**: la 3 sale de la 2 y la 4 de la 3. Se fusionan en orden (2 → 3 → 4); si se
abre el PR 3 antes de fusionar el 2, su diff muestra también lo del 2. En el cuerpo de cada PR va el enlace a las issues
(`KAN-227`, etc.) para que Jira lo asocie si la integración con GitHub está activa.

## 3. Cambios de alcance que hay que registrar (decisiones del 2026-11-06)

Las tomó el equipo con el líder técnico. Detalle técnico en `docs/arquitectura.md` §8. En Jira se registran así:

| Decisión | Qué dice | Issue | Qué hacer en Jira |
|---|---|---|---|
| D1 | Si el teléfono tiene PIN pero no huella, se entra con el PIN del teléfono | KAN-32, KAN-115 | Comentario en las dos (plantilla 5.1) |
| D2 | M02-02 no es un teclado propio: «Usar PIN del teléfono» abre el diálogo del sistema. M02-02b no existe | KAN-136, KAN-174, KAN-226 | KAN-136: comentario + actualizar el criterio de aceptación (5.2). KAN-174: comentario y cierre como no aplicable (5.3). KAN-226: comentario (5.4) |
| D3 | El refresh se cifra con una llave RSA del Keystore que solo descifra 10 s después de una huella o del PIN | KAN-225, KAN-115 | Comentario (5.5) |
| D4 | Una huella nueva en el teléfono **no** cierra la sesión (deuda) | KAN-115 | Comentario de deuda (5.5) |
| D5 | Sin PIN propio de Solventa; se quitó el «PIN derivado» de la arquitectura | KAN-229 | Comentario (5.7) |
| Gracia | AUTH acepta durante 30 s un reintento con el refresh anterior (respuesta perdida en la red) | KAN-227 | Comentario (5.6) |
| 5 min | Volver del segundo plano después de 5 min pide de nuevo la huella (M02-01) | KAN-225 | Comentario (5.5) |

**Por qué KAN-136 se conserva y KAN-174 se cierra.** La necesidad de KAN-136 («entrar con el PIN de mi teléfono para no
quedarme fuera») se cumple, solo que con el diálogo del sistema: Android no deja que una app valide el PIN del teléfono
con un teclado propio. KAN-174 describe un estado de ese teclado (4 indicadores llenos), que ya no existe. El flujo del
equipo no tiene un estado «Descartada»: KAN-174 se mueve a **Done** con el comentario 5.3 y la etiqueta
`fuera-de-alcance-D2`, para que el filtro de métricas pueda excluirla. No se borra: se perdería la trazabilidad con
Figma.

## 4. Habilitadoras (KAN-115 y KAN-66)

- **KAN-115 (HA-SEG-005)** queda cumplida **con desviaciones**, que se dejan escritas en un comentario (5.5): el PIN del
  teléfono también desbloquea (D1), la llave se abre por ventana de 10 s y no en cada operación, y una huella nueva no
  invalida la sesión (D4). Pasa a **Done** cuando el PR 4 esté en `develop` y KAN-228 tenga evidencia en un teléfono
  real. Si el equipo exige el texto literal («exclusivamente con el sensor biométrico»), queda en **In Review** y se
  abre una tarea nueva para la «fase 2» (llave por operación con `BiometricPrompt` + `CryptoObject`).
- **KAN-66 (HA-SEG-004)** no se cierra con HU-M02. Solo se comenta que la rotación del refresh (con revocación por reuso
  y período de gracia) ya existe en AUTH. Los scopes validados en el gateway, ES256 para usuarios y el antifraude ≤ 1 s
  siguen pendientes y son de backend.

## 5. Plantillas de comentario (listas para pegar)

Reemplaza `<PR>` por el enlace al PR. Escritas en el tono de los comentarios que ya usa el equipo.

**5.1 · KAN-32 y KAN-115 (D1):**
> Decisión D1 (2026-11-06): si el teléfono tiene PIN o patrón pero no huella ni rostro registrados, el cliente entra con
> el PIN del teléfono a través del diálogo del sistema. Es una desviación deliberada de HA-SEG-005 («exclusivamente con
> el sensor biométrico»), anotada en `solventa-frontend-mobile/docs/arquitectura.md` §8.

**5.2 · KAN-136 (D2):**
> Decisión D2 (2026-11-06): Android no permite que una app valide el PIN del teléfono con un teclado propio; solo el
> diálogo del sistema puede hacerlo. «Usar PIN del teléfono» (M02-01 y M02-01a) abre ese diálogo. Se cumple la
> necesidad de la historia (entrar con el PIN del teléfono) sin teclado ni indicadores. Criterio actualizado: «Tocar
> Usar PIN del teléfono abre el diálogo del sistema; si el PIN es correcto, pasa a M02-03; si se cancela, vuelve a
> M02-01 sin error». PR: <PR>.

Además, edita la descripción de KAN-136 para dejar el criterio actualizado al inicio (la descripción original se
conserva debajo, tachada o bajo «Criterio original»).

**5.3 · KAN-174 (D2):**
> No aplica por la decisión D2 (ver KAN-136): no hay teclado propio de PIN, así que tampoco existe el estado «PIN
> ingresado». El ingreso con el PIN del teléfono va por el diálogo del sistema. Se cierra sin código; queda en Figma
> como referencia histórica.

Luego: etiqueta `fuera-de-alcance-D2` y transición a **Done**.

**5.4 · KAN-226:**
> Alcance ajustado por D2: se construyen M02-01a (no reconocida) y M02-03 (acceso concedido); M02-02 pasa a ser el
> diálogo del sistema y M02-02b no aplica (KAN-174). Se conservan los 1,5 pts. Estados adicionales sin diseño en Figma
> (bloqueo temporal, sin bloqueo de pantalla, sin red) se resolvieron con patrones existentes. PR: <PR>.

**5.5 · KAN-225 y KAN-115 (D3, D4, 5 min):**
> D3: el refresh se cifra con una llave RSA-2048 del Android Keystore; la pública cifra sin pedir nada (permite guardar
> el refresh rotado en segundo plano) y la privada solo descifra durante 10 s después de una huella fuerte o del PIN del
> teléfono. El JWT de acceso vive solo en memoria. Al volver del segundo plano tras 5 minutos se pide de nuevo la huella.
> Deuda conocida: (1) una huella nueva no invalida la sesión (D4); (2) la llave se abre por ventana, no por operación;
> (3) el código Kotlin no tiene pruebas instrumentadas; (4) un rostro «débil» no abre la llave y se ofrece el PIN (falta
> confirmarlo en un teléfono real, KAN-228). Detalle: `docs/arquitectura.md` §8. PR: <PR>.

**5.6 · KAN-227:**
> Backend: período de gracia de 30 s (`refresh_gracia_segundos` en `contracts/sesion.json`, `REFRESH_GRACIA_SEGUNDOS=0` lo
> apaga). Un reintento con el refresh anterior, si nadie usó el sucesor, recibe un par nuevo en vez de revocar la
> cadena: evita cerrar la sesión cuando la respuesta se pierde en la red. Fuera de la gracia, o con el sucesor usado,
> sigue revocando. Pruebas en `services/auth/tests/test_refresh_gracia.py` y colección Newman `hu-m02` (17 peticiones),
> pendientes de correr por el compañero que valida. Móvil: renovación silenciosa con candado, reintento en la gracia y
> cierre que revoca. PRs: <PR backend>, <PR móvil>.

**5.7 · KAN-229:**
> Documentación entregada en los PRs: `docs/arquitectura.md` §8 (decisiones D1–D5, deuda y sin «PIN derivado»),
> `docs/integracion-backend.md` §7 (sesión), `docs/hu-m02-jira.md` (esta guía); en el backend,
> `docs/autenticacion-usuarios.md` y `tests/newman/README.md`. La revisión de código queda registrada en cada PR.

**5.8 · KAN-228 (al terminar la validación):**
> Validado en <emulador API 34 / teléfono, modelo y versión de Android>: `tool/verificar.sh` en verde, goldens
> regenerados con `tool/goldens.sh`, `integration_test/hu_m02_test.dart` en verde, Newman `hu-m02` en verde contra el
> compose y los casos de `validar-local-auth-android.md`. Evidencia en `docs/evidencias/hu-m02/`. Hallazgos: <lista o
> «ninguno»>.

## 6. Cuándo mover cada issue

Flujo del tablero: **To Do → In Progress → In Review → Done**.

| Momento | Issues | Transición | Quién |
|---|---|---|---|
| Se crea la rama del PR | Las del PR (columna «Issues que mueve» de la sección 2) | To Do → In Progress | Quien escribe el código |
| Se abre el PR | Las del PR | In Progress → In Review + comentario con el enlace | Quien abre el PR |
| El PR se fusiona en `develop` | Ninguna todavía | Se quedan en In Review | — |
| El compañero valida (5.8) | KAN-227, KAN-225, KAN-226 y las subtareas de pantallas | In Review → Done | El compañero que valida |
| Validación en dispositivo terminada | KAN-228 | → Done con el comentario 5.8 | El compañero que valida |
| Todos los PRs revisados y la doc entregada | KAN-229 | → Done con el comentario 5.7 | Líder técnico |
| Todas las tareas en Done | KAN-32 | → Done | Líder técnico |
| Al aplicar D2 (en cualquier momento) | KAN-174 | → Done con 5.3 y la etiqueta | Quien registra la decisión |

**Estado actual (2026-11-06):** PR 1 y PR 2 con push hecho y sin PR abierto. KAN-227 y KAN-225 pasan a **In Progress**
ya, y a **In Review** cuando se abran los PRs 1 y 2. KAN-226 y las subtareas de pantallas siguen en To Do hasta crear
la rama del PR 4.

Si un hallazgo de la validación obliga a corregir, la issue vuelve de In Review a In Progress, con un comentario que
diga qué falló. La corrección va en un PR `fix/KAN-N-…`.

## 7. Comandos (`acli`, opcional)

Lo mismo se puede hacer desde la web de Jira. Con la CLI de Atlassian ya autenticada:

```bash
# Mover a In Progress
acli jira workitem transition --key "KAN-227,KAN-225" --status "In Progress" --yes

# Comentar (texto plano; para varias líneas, guardar el texto en un archivo y usar --body-file)
acli jira workitem comment create --key KAN-227 --body-file comentario-kan-227.txt

# Etiqueta de fuera de alcance y cierre de KAN-174
acli jira workitem edit --key KAN-174 --labels "fuera-de-alcance-D2" --yes
acli jira workitem transition --key KAN-174 --status "Done" --yes

# Revisar cómo quedó
acli jira workitem search --jql 'labels = HU-M02 OR parent = KAN-32 OR key in (KAN-32, KAN-115, KAN-66)' \
  --fields key,summary,status
```

Antes de comentar, revisa que el texto no tenga datos personales, tokens ni enlaces a capturas con datos de pruebas
reales.
