# Plan de implementación · HU-M04 «Mi cobertura» y detalle de la indemnización (solo front, datos mock)

Repo: `solventa-frontend-mobile` · base: `develop` (último merge revisado: `b678f1d`, PR #55, 7 nov 2026)
Para: otra IA o un compañero que lo ejecute sin contexto previo. Este documento es autocontenido.

> **Autoría:** los commits y el PR van solo a nombre de felipe. **No** agregar `Co-Authored-By`, `Claude-Session`, «Generated with Claude Code» ni ninguna atribución a una IA en commits ni en la descripción del PR.

---

## 1. Qué se construye y qué no

**Se construye (esta semana, para mostrar avance):**

| Id | Pantalla | Fuente del diseño | Archivo de referencia |
|---|---|---|---|
| M04-04 | **Mi cobertura**, con tres estados: sin saldo, **saldo a favor** y **saldo en contra** | Mockups propios (no existen en Figma) | `hu-m04/mockup-M04-04-cobertura*.png` y `.html` |
| M04-02 | **Celebración** (monto depositado) | Figma `2005:301` | `hu-m04/figma-M04-02-celebracion.png` |
| M04-03 | **Detalle de la indemnización**  | Figma `2005:217` | `hu-m04/figma-M04-03-detalle-indemnizacion.png` |

Los **tres mocks PNG** que generamos (no están en Figma) son la base de M04-04:
1. `mockup-M04-04-cobertura.png`: la lista (cupo, total indemnizado y movimientos), sin saldo.
2. `mockup-M04-04-cobertura-saldo-favor.png`: igual, con el bloque verde de saldo a favor.
3. `mockup-M04-04-cobertura-saldo-contra.png`: igual, con el bloque rojo de saldo en contra.

Cada uno tiene su `.html` con las medidas y colores exactos. Se implementan como **una sola página con tres estados**, porque solo cambia el bloque de saldo. M04-03 (detalle del evento) sí está en el prototipo de Figma y se copia de ahí.

**Por ahora sin navegación ni push:** las pantallas (M04-02, M04-03 y M04-04) se construyen sueltas y se muestran en goldens y en el reporte de emuladores. No se tocan `router.dart`, `HomePage` ni `SolventaApp`. Las filas de la lista y los botones «Ver detalle» y «Cerrar» quedan con callbacks (`onTapMovimiento`, `onVerDetalle`, `onCerrar`) que por ahora no hacen nada; la ruta y la push (M04-01) llegan en otro PR.

**Fuera de alcance:** navegación y rutas, push M04-01 (banner y FCM, KAN-259), backend, contrato GraphQL, conversión de moneda. Todo con datos fijos (fixtures) detrás de la misma capa que usan M05 y M06, para que conectar el BFF después solo cambie el datasource.

Jira: historia KAN-38 (HU-M04); tarea de app KAN-260 (S3-M04-6). Rama sugerida: `feat/KAN-260-cobertura-mock`. Título del PR: `feat(mobile): KAN-260 pantallas de cobertura e indemnización con datos mock`.

---

## 2. Reglas del repo que hay que respetar (resumen de `CLAUDE.md`)

- Todo comando de Flutter (pub, gen-l10n, analyze, test, goldens) **dentro del devcontainer** (`.devcontainer/`, Flutter 3.47.8). Goldens solo con `tool/goldens.sh`.
- Antes del PR: `tool/verificar.sh` en verde. Análisis estricto (`strict-casts`, `strict-inference`, `strict-raw-types`): nada de `dynamic` implícito.
- Las features importan **solo** el barrel `core/design_system/solventa_ui.dart`. Nada de colores, tamaños ni fuentes quemados: tokens (`SolSpacing`, `SolRadius`, `SolSizes`, `context.colors`, `context.solColors`, `context.solText`).
- **Textos en los ARB** (`lib/core/l10n/arb/app_es.arb` y `app_en.arb`), nunca en el widget. Los archivos de `lib/core/l10n/gen/` se regeneran y se versionan.
- Nada de `print`; logs con `SolLog`. Montos y cuentas no van a logs.
- Ningún estado solo por color (siempre ícono + texto). Áreas táctiles ≥ 48 dp. Íconos solo Material Symbols outlined vía `SolIcons`.
- Cada HU con recorrido agrega su prueba en `integration_test/`.

---

## 3. Arquitectura: dónde va cada cosa

Se sigue el mismo patrón por capas de `features/claims` (HU-M05): `domain` (entidades + interfaz del repositorio) → `data` (datasource remoto con su Fake, fixtures, repositorio) → `presentation` (providers Riverpod, rutas, páginas). La selección fake/real la hace `usarFakesProvider` (`API_ENV=mock` en `config/mock.json`).

```
lib/features/parametric/                     ← feature nueva (HU-M04)
  domain/
    entities/cobertura.dart                  ResumenCobertura, SaldoPrima, Indemnizacion, TipoEventoParametrico, EstadoPago
    calculo_cobertura.dart                   usado / disponible / porcentaje (funciones puras)
    repositories/cobertura_repository.dart   interfaz
  data/
    fixtures/cobertura_fixtures.dart         los datos de los mockups (3 escenarios)
    datasources/cobertura_remote_datasource.dart
                                             interfaz + FakeCoberturaRemoteDataSource (lee fixtures)
                                             (la Gql… llega cuando exista el contrato; NO crearla ahora)
    repositories/cobertura_repository_impl.dart   envuelve en Resultado/Falla con guardarFallas
  presentation/
    cobertura_routes.dart                    rutas
    providers.dart                           datasource, repositorio, escenario, resumen, detalle
    pages/m04_04_cobertura_page.dart
    pages/m04_03_detalle_indemnizacion_page.dart
    widgets/cobertura_widgets.dart           _TarjetaCupo, _TarjetaTotal, _BloqueSaldo, _FilaMovimiento, _FilaDato

```

> Si se prefiere no crear feature nueva, `features/claims` también sirve, pero HU-M04 es otro dominio (paramétrico, sin formulario) y separarlo evita tocar el código de M05.

### 3.1 Dominio

```dart
enum TipoEventoParametrico { retrasoVuelo, cancelacionVuelo, lluvia }
enum EstadoPago { pagado, enProceso }

final class Indemnizacion {
  const Indemnizacion({required this.id, required this.tipo, required this.referenciaEvento,
    required this.detalleEvento, required this.fechaEvento, required this.pagadoEn,
    required this.monto, required this.estado, required this.cuentaDestino,
    required this.polizaAnterior});
  final String id;                 // 'IND-2026-0912'
  final TipoEventoParametrico tipo;
  final String referenciaEvento;   // 'AV204', 'Bogotá'
  final String detalleEvento;      // '+3h40', '62 mm'
  final DateTime fechaEvento;
  final DateTime pagadoEn;
  final int monto;                 // pesos, entero
  final EstadoPago estado;
  final String cuentaDestino;      // '4821' (solo últimos 4; se enmascara con SolFormat.maskedAccount)
  final bool polizaAnterior;       // true = no descuenta del cupo actual
}

final class SaldoPrima {
  const SaldoPrima({required this.monto, required this.periodo});
  final int monto;                 // > 0 a favor, < 0 en contra
  final DateTime periodo;          // mes del ajuste (oct 2026)
  bool get aFavor => monto > 0;
}

final class ResumenCobertura {
  // producto, numeroPoliza, vigente, vigenteHasta, tope, cuentaDestino,
  // saldo (SaldoPrima?), movimientos (List<Indemnizacion>, del más reciente al más antiguo)
}
```

`calculo_cobertura.dart` (puro, con prueba unitaria):

- `usado = suma(monto de movimientos con polizaAnterior == false)`
- `disponible = max(0, tope - usado)`
- `porcentajeUsado = (usado / tope * 100).round()` (630.000 / 2.000.000 = 31,5 → **32 %**); la barra usa el valor exacto `usado / tope` (0,315).
- `totalIndemnizado = suma(todos los movimientos)` (950.000) y `desde = fecha del más antiguo`.
- **El saldo de prima NO entra en usado ni disponible** (decisión tomada en el hilo del mockup: el saldo es dinero de prima entre cliente y Solventa, no cobertura).

Interfaz del repositorio:

```dart
abstract interface class CoberturaRepository {
  Future<Resultado<ResumenCobertura>> resumen();
  Future<Resultado<Indemnizacion>> indemnizacion(String id);
}
```

### 3.2 Datos mock (fixtures, idénticos a los mockups)

Póliza `SOL-PV-2026-00381` · «Viaje paramétrico» · vigente hasta 30 nov 2026 · tope **$ 2.000.000** · cuenta `4821`.

| id | Evento | Fecha | Detalle | Monto | Póliza anterior |
|---|---|---|---|---|---|
| IND-2026-0912 | Retraso de vuelo AV204 | 12 sep 2026 (pagado 12 sep 2026, 11:02 a. m.) | +3h40 | 450.000 | no |
| IND-2026-0828 | Lluvia sobre el umbral | 28 ago 2026 | Bogotá, 62 mm | 180.000 | no |
| IND-2026-0703 | Cancelación de vuelo LA4012 | 3 jul 2026 | póliza anterior | 320.000 | sí |

Resultado: usado 630.000 (32 %), disponible **$ 1.370.000**, total indemnizado **$ 950.000**, 3 pagos desde jul 2026.

Tres escenarios (`enum EscenarioCobertura { sinSaldo, aFavor, enContra }`):

- `sinSaldo` → `saldo: null` (mockup base)
- `aFavor` → `SaldoPrima(monto: 38500, periodo: oct 2026)`
- `enContra` → `SaldoPrima(monto: -38500, periodo: oct 2026)`

`FakeCoberturaRemoteDataSource({EscenarioCobertura escenario = EscenarioCobertura.aFavor, Duration latencia = const Duration(milliseconds: 400), bool fallar = false})`. Con `fallar: true` lanza la excepción de red que ya usa el repo (`network_exceptions.dart`) para probar el estado de error. Como no hay tipos generados de GraphQL todavía, el fake devuelve directamente las entidades (o un DTO simple); dejar un comentario `// TODO(KAN-259/BFF): reemplazar por Gql… cuando exista la query en el contrato`.

### 3.3 Providers (`presentation/providers.dart`)

```dart
final coberturaRemoteDataSourceProvider = Provider<CoberturaRemoteDataSource>((ref) =>
    FakeCoberturaRemoteDataSource(escenario: ref.watch(escenarioCoberturaProvider)));
// Mientras no exista el contrato, siempre el fake (también en dev). Documentarlo.

final escenarioCoberturaProvider = NotifierProvider<EscenarioNotifier, EscenarioCobertura>(…); // default aFavor
final coberturaRepositoryProvider = Provider<CoberturaRepository>(…);
final resumenCoberturaProvider = FutureProvider.autoDispose<Resultado<ResumenCobertura>>(…);
final indemnizacionProvider = FutureProvider.autoDispose.family<Resultado<Indemnizacion>, String>(…);
```

## 4. Pantallas (fidelidad visual)

Todas con `SolFlowScaffold` (barra «Con volver» de 56 dp con título, píldora `ES · COP` y avatar; fondo `surfaceContainer #F5F5F5`; margen 16; `SolAdaptiveBody` limita a 600 dp en tablet, ya lo hace `SolScreenFrame`). Tarjetas con `SolCard` (blanco, radio 12, padding 16). Gap entre bloques 12 (`SolSpacing.md`).

### 4.1 M04-04 · Mi cobertura (`m04_04_cobertura_page.dart`)

Título de la barra: «Mi cobertura». `onBack` como parámetro opcional de la página (sin navegación por ahora).

De arriba a abajo (ver `mockup-M04-04-cobertura-saldo-favor.png`):

1. **Tarjeta «Cupo de cobertura»**
   - Fila: círculo 36 dp `navIndicator #D7E2FF` con ícono avión en `primary`; a la derecha «Viaje paramétrico · Vigente» (14/500) y «Póliza SOL-PV-2026-00381 · hasta 30 nov 2026» (12, `onSurfaceVariant`).
   - `SolDivider` (margen vertical 14).
   - «Tope de cobertura» (12, variante) y `$ 2.000.000` (`headlineSmall` 24/600).
   - Barra de progreso 8 dp, radio full, fondo `surfaceContainer` con borde `outline`, relleno `primary` al 31,5 %. Usar `LinearProgressIndicator` dentro de `ClipRRect` o un `FractionallySizedBox`. `Semantics(label: '32 % del tope usado', value: '32 %')`.
   - Fila: «32 % del tope usado» a la izquierda; a la derecha «Disponible» y debajo `$ 1.370.000` (14/600, `onSurface`).
2. **Tarjeta «Total indemnizado»**
   - Fila: «Total indemnizado» (12) + `$ 950.000` (24/600, color `solColors.success #2E7C56`); a la derecha círculo 36 dp `successContainer` con ícono `payments` en `success`.
   - «Suma de los 3 pagos que has recibido desde jul 2026, en todas tus pólizas.» (12, variante, alto de línea 1,45).
   - Píldora «✓ Depositado en ••••4821»: reutilizar `SolStatusBadge(status: SolStatus.success, label: …)`.
   - **Bloque de saldo** (solo si `saldo != null`), margen superior 14, radio 8 (`SolRadius.field`), padding 10×12:
     - A favor: fondo `successContainer`, texto `success`, ícono `check_circle`; «+ $ 38.500 a tu favor» (14/600) y «Ajuste de prima de octubre. Se descuenta de tu próximo cobro.» (12).
     - En contra: fondo `colors.errorContainer #FDECEC`, texto `colors.error #994D4D`, ícono `error`; «− $ 38.500 pendiente» y «Diferencia de prima de octubre. Se suma a tu próximo cobro.»
     - `Semantics(liveRegion: false, container: true)` y el signo **siempre** en el texto (no solo color).
     - Implementación recomendada: un widget privado `_BloqueSaldo` en la feature. Si se quiere reutilizar, `SolStatusBanner(status: success|error, title, message)` está cerca, pero revisar que coincida con el mockup (radio y padding); si no coincide, widget propio con tokens.
3. **Encabezado de sección**: «Movimientos indemnizados» (14/600) y a la derecha «3 pagos» (12, variante). `SolSectionHeader(title:, count:)` existe pero es 16/600 con píldora; el mockup usa 14/600 con texto simple → usar un `Row` propio con tokens, o pasar el contador si el diseñador acepta la píldora. Preferir fidelidad al mockup.
4. **Lista** en una tarjeta blanca radio 12, filas separadas por divisor 1 dp, cada fila `min-height 72`, `InkWell` (48 dp táctil cumplido):
   - Círculo 36 dp con ícono por tipo (avión para vuelo, `thunderstorm` para lluvia).
   - Título (14/500) «Retraso de vuelo AV204» y meta (12, variante) «12 sep 2026 · +3h40».
   - A la derecha monto (14/600) y debajo «✓ Pagado» (11/600, `success`, ícono 14).
   - Chevron (`SolIcons.chevronRight`, variante).
   - `onTap: () => onTapMovimiento?.call(m.id)` (callback de la página; sin navegación por ahora). `MergeSemantics` + `Semantics(button: true)`.
5. **Nota** (11, variante): «El tope se reinicia con cada renovación. Los pagos de pólizas anteriores no descuentan del cupo actual.»

Estados (switch sobre `AsyncValue<Resultado<…>>`, igual que `M0506MisSiniestrosPage`):
- cargando → `SolLoadingState(message: 'Consultando tu cobertura…')`
- `Fracaso` → `SolInlineNote(text: l10n.falla(falla))` + `SolButton.text('Reintentar')` que hace `ref.invalidate(resumenCoberturaProvider)`
- sin movimientos → nota «Aún no tienes pagos indemnizados.» y se ocultan total y lista
- `RefreshIndicator` para tirar y recargar.

Montos con `SolFormat.currency(...)` (es-CO, espacio duro). Signo del saldo: `'+ ${SolFormat.currency(m)}'` / `'− ${SolFormat.currency(m.abs())}'` (U+2212 para el menos, como el mockup). Fechas con `SolFormat.date`; «jul 2026» con un formateador de mes/año (agregar `SolFormat.monthYear` en `sol_formatters.dart` con su prueba, o componerlo en el ARB).

### 4.2 M04-03 · Detalle de la indemnización (`m04_03_detalle_indemnizacion_page.dart`)

Copiar Figma `2005:217` (`figma-M04-03-detalle-indemnizacion.png`):

- Barra «Con volver», título «Detalle de la indemnización».
- Una `SolCard`:
  - Cabecera: círculo 36 dp con avión + «Evento detectado: retraso de vuelo AV204 (+3h40)» (14/500, hasta 2 líneas).
  - Filas etiqueta (14, variante) / valor (14/600 alineado a la derecha) separadas por divisor:
    - Indemnización → `$ 450.000` (este valor 16/600)
    - Fecha del evento → `12 sep 2026`
    - Fecha de pago → `12 sep 2026, 11:02 a. m.` (`SolFormat.dateTime`)
    - Cuenta destino → ícono banco (`account_balance`, agregar a `SolIcons`) + `••••4821` con `Semantics(label: SolFormat.maskedAccountSemantics('4821'))`.
- Debajo de la tarjeta, centrada: `SolStatusBadge(success, 'Pago procesado automáticamente')`.
- Botón primario anclado abajo: `SolButton.primary('Cerrar')` con `anchorActions: true`; llama `onCerrar?.call()` (sin navegación por ahora).
- Adaptativo (CA de KAN-146): si el ancho no alcanza (texto al 200 %), cada fila pasa a etiqueta arriba y valor abajo. Implementar con `LayoutBuilder` o `Wrap` en `_FilaDato`; lo validan los goldens al 200 %.
- Los textos del evento salen del tipo (`retrasoVuelo` → «retraso de vuelo»), no quemados.

### 4.3 M04-02 · Celebración (`m04_02_celebracion_page.dart`)

Copiar Figma `2005:301` (`figma-M04-02-celebracion.png`):

- Barra «Con volver», título «Indemnización».
- Contenido centrado vertical y horizontalmente (`SolScreenFrame` con `centerBody`, o el layout `SolResultScreen` si encaja con el frame):
  - Círculo de ~96 dp en `successContainer` con el ícono `celebration` (agregar `Symbols.celebration` a `SolIcons`) en `success`, y dos puntos decorativos (verde suave y azul suave). Todo con `ExcludeSemantics` (CA: el ícono no entra al foco).
  - «¡Tu indemnización ya está en camino!» (`titleSmall`/16, `onSurface`, centrado).
  - «$ 450.000 depositados» (24/600, `success`), con `Semantics(label: …)` para que se lea como cifra completa. Debe crecer en alto si la cifra es larga (sin `maxLines`).
  - Cuenta destino enmascarada (CA de KAN-139): «En tu cuenta ••••4821» (12, variante) bajo el monto, con `maskedAccountSemantics`. En el Figma no se ve; si el diseñador no la quiere, se omite.
- `SolButton.primary('Ver detalle')` debajo del bloque (no anclado), llama `onVerDetalle?.call()`.
- Datos: la indemnización `IND-2026-0912` del fixture, vía `indemnizacionProvider(id)`; con cargando y error como en M04-04.

## 6. Textos (ARB)

Agregar en `app_es.arb` y `app_en.arb`, con `@clave` y `description`, prefijo por pantalla como el resto (`m0506…`). Lista mínima:

```
m0402Titulo "Indemnización" · m0402Mensaje "¡Tu indemnización ya está en camino!" · m0402Monto "{monto} depositados" · m0402Cuenta "En tu cuenta {cuenta}" · m0402VerDetalle "Ver detalle"
m0404Titulo "Mi cobertura" · m0404Cargando "Consultando tu cobertura…"
m0404Producto "{producto} · {estado}" · m0404Vigente "Vigente"
m0404Poliza "Póliza {numero} · hasta {fecha}"
m0404Tope "Tope de cobertura" · m0404PorcentajeUsado "{porcentaje} % del tope usado" · m0404Disponible "Disponible"
m0404TotalIndemnizado "Total indemnizado"
m0404TotalDetalle "Suma de {pagos, plural, =1{el pago} other{los {pagos} pagos}} que has recibido desde {mes}, en todas tus pólizas."
m0404Depositado "Depositado en {cuenta}"
m0404SaldoFavor "+ {monto} a tu favor" · m0404SaldoFavorDetalle "Ajuste de prima de {mes}. Se descuenta de tu próximo cobro."
m0404SaldoContra "− {monto} pendiente" · m0404SaldoContraDetalle "Diferencia de prima de {mes}. Se suma a tu próximo cobro."
m0404Movimientos "Movimientos indemnizados" · m0404Pagos "{n, plural, =1{1 pago} other{{n} pagos}}"
m0404Pagado "Pagado" · m0404PolizaAnterior "póliza anterior"
m0404Nota "El tope se reinicia con cada renovación. Los pagos de pólizas anteriores no descuentan del cupo actual."
m0404Vacio "Aún no tienes pagos indemnizados." · m0404Reintentar "Reintentar"
m04EventoRetrasoVuelo "Retraso de vuelo {ref}" · m04EventoCancelacionVuelo "Cancelación de vuelo {ref}" · m04EventoLluvia "Lluvia sobre el umbral"
m0403Titulo "Detalle de la indemnización" · m0403Evento "Evento detectado: {evento}"
m0403Indemnizacion "Indemnización" · m0403FechaEvento "Fecha del evento" · m0403FechaPago "Fecha de pago"
m0403Cuenta "Cuenta destino" · m0403Automatico "Pago procesado automáticamente" · m0403Cerrar "Cerrar"
```

Luego `flutter gen-l10n` (o el `flutter pub get` que lo dispara por `l10n.yaml`) dentro del devcontainer y versionar `lib/core/l10n/gen/*`.

Íconos nuevos en `SolIcons` (de `material_symbols_icons`, outlined): `flight = Symbols.flight`, `thunderstorm = Symbols.thunderstorm`, `payments = Symbols.payments`, `bank = Symbols.account_balance`, `notifications = Symbols.notifications_active`. La prueba `test/core/design_system/icons/sol_icons_test.dart` ya valida que sean outlined: correrla.

---

## 7. Pruebas

| Tipo | Archivo | Qué verifica |
|---|---|---|
| Unitaria | `test/features/parametric/domain/calculo_cobertura_test.dart` | usado 630.000, disponible 1.370.000, 32 %, total 950.000; el saldo no altera usado/disponible; tope 0 no divide por cero |
| Unitaria | `test/features/parametric/data/cobertura_repository_test.dart` | fake con los 3 escenarios; `fallar: true` → `Fracaso` |
| Widget | `test/features/parametric/m04_04_cobertura_page_test.dart` | sin saldo no muestra bloque; a favor muestra «+ $ 38.500 a tu favor» con ícono; en contra «− $ 38.500 pendiente»; error → Reintentar recarga; tocar fila navega a M04-03 |
| Widget | `test/features/parametric/m04_03_detalle_page_test.dart` | datos de la fila, cuenta enmascarada con semántica, «Cerrar» hace pop |
| Widget | `test/features/parametric/m04_02_celebracion_page_test.dart` | monto «$ 450.000 depositados», cuenta enmascarada, ícono excluido de semántica, «Ver detalle» llama el callback |
| Goldens | `test/goldens/cobertura_goldens_test.dart` | Copiar el patrón de `acceso_goldens_test.dart`: casos 360/390/600 dp al 100 %, 360/390 al 200 % en es y 390 en en; alto 844. Pantallas: `m04_02_celebracion`, `m04_04_sin_saldo`, `m04_04_saldo_favor`, `m04_04_saldo_contra`, `m04_03_detalle`. Override de `coberturaRemoteDataSourceProvider` con el fake en `latencia: Duration.zero`. Generar con `tool/goldens.sh test/goldens/cobertura_goldens_test.dart` dentro del devcontainer; se versionan en `test/goldens/ci/` |
| Integración (emuladores) | `integration_test/cobertura_test.dart` | ver §8 |

Para revisión humana con Inter real (opcional): `SOL_PLATFORM_GOLDENS=1 flutter test --update-goldens test/goldens/cobertura_goldens_test.dart` (quedan en `test/goldens/platform/`, ignorados por git).

---

## 8. Reporte HTML «responsive» del pipeline (para mostrar avance)

### 8.1 Dónde está hoy

El reporte lo genera el workflow **Emuladores** (`.github/workflows/emuladores.yml`): corre `integration_test/` en 3 emuladores (teléfono pequeño API 28 Nexus 5 de 360 dp, teléfono grande API 34 Pixel 7 Pro y tablet API 34 Pixel Tablet) y el job **Reporte** arma un solo HTML con cada prueba en los tres tamaños, el error si falla y **capturas de pantalla**. El artifact se llama `reporte-emuladores` (`dist/reporte-emuladores.html`, 14 días).

Según el equipo, esto **ya está en `develop`**: el PR #56 (pruebas de M05/M06 y reporte de Emuladores) se mergeó el 7 nov y la corrida de develop https://github.com/solventa-app/solventa-frontend-mobile/actions/runs/42448161828 publicó el artifact HTML. Lo que trae:
- `tool/reporte-emuladores.py`
- `integration_test/soporte/capturas.dart` → función `capturar(tester, 'M05-03 · relato')`
- `integration_test/flutter_test_config.dart` → captura automática cuando una prueba falla
- el job `Reporte` y `--dart-define=CAPTURAS=true` en `emuladores.yml`

Paso 0: `git fetch origin && git checkout -b feat/KAN-260-cobertura-mock origin/develop` y confirmar que existe `integration_test/soporte/capturas.dart`. (Si no existiera, traer la rama `chore/KAN-0-reporte-emuladores` con un merge y avisarlo en el PR.)

### 8.2 Prueba de integración con capturas (sin push ni navegación)

`integration_test/cobertura_test.dart`. Cada prueba monta **directamente** la página (sin router de la app, sin push), igual que `reporte_siniestro_test.dart` monta sus páginas: `UncontrolledProviderScope` con overrides + `MaterialApp` con `SolTheme.light()`, `AppLocales.es` y los delegates de `AppLocalizations`.

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> montar(WidgetTester tester, Widget pagina, EscenarioCobertura e) async {
    final c = ProviderContainer(overrides: [
      escenarioCoberturaProvider.overrideWith(() => EscenarioFijo(e)),
      coberturaRemoteDataSourceProvider.overrideWithValue(
          FakeCoberturaRemoteDataSource(escenario: e, latencia: Duration.zero)),
    ]);
    addTearDown(c.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: c,
      child: MaterialApp(theme: SolTheme.light(), locale: AppLocales.es,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: pagina)));
    await tester.pumpAndSettle();
  }

  const casos = {
    EscenarioCobertura.sinSaldo: 'M04-04 · lista de movimientos',
    EscenarioCobertura.aFavor: 'M04-04 · saldo a favor',
    EscenarioCobertura.enContra: 'M04-04 · saldo en contra',
  };
  for (final MapEntry(key: e, value: nombre) in casos.entries) {
    testWidgets(nombre, (tester) async {
      await montar(tester, const M0404CoberturaPage(), e);
      expect(find.text('Mi cobertura'), findsOneWidget);
      await capturar(tester, nombre);
      await tester.scrollUntilVisible(find.text('Cancelación de vuelo LA4012'), 200);
      await tester.pumpAndSettle();
      await capturar(tester, '$nombre (final de la lista)');
    });
  }

  testWidgets('M04-02 · celebración', (tester) async {
    await montar(tester, const M0402CelebracionPage(id: 'IND-2026-0912'),
        EscenarioCobertura.sinSaldo);
    expect(find.textContaining('depositados'), findsOneWidget);
    await capturar(tester, 'M04-02 · celebración');
  });

  testWidgets('M04-03 · detalle de la indemnización', (tester) async {
    await montar(tester, const M0403DetalleIndemnizacionPage(id: 'IND-2026-0912'),
        EscenarioCobertura.sinSaldo);
    expect(find.text('Detalle de la indemnización'), findsOneWidget);
    await capturar(tester, 'M04-03 · detalle');
  });
}
```

Resultado: el HTML trae **6 pruebas × 3 emuladores** con las capturas de M04-02, M04-03 y M04-04 en sus 3 variantes en teléfono pequeño, grande y tablet.

### 8.3 Obtener el HTML

Tres caminos, del más rápido al oficial:

1. **Antes del merge, en la rama del PR** (recomendado para mostrar esta semana): `emuladores.yml` tiene `workflow_dispatch`.
   ```bash
   gh workflow run emuladores.yml --ref feat/KAN-260-cobertura-mock
   gh run watch                                   # ~20-40 min
   gh run download <run-id> -n reporte-emuladores # deja reporte-emuladores.html
   ```
   (o en GitHub: Actions → Emuladores → Run workflow → elegir la rama → al terminar, artifact `reporte-emuladores`).
2. **Después del merge a `develop`**: corre solo con cada merge. Descargar el artifact `reporte-emuladores` de esa corrida.
3. **Local con un emulador** (si Actions tarda):
   ```bash
   mkdir -p build/reporte/local
   flutter test integration_test/cobertura_test.dart --flavor dev \
     --dart-define-from-file=config/mock.json --dart-define=CAPTURAS=true \
     --file-reporter json:build/reporte/local/resultados.json
   echo "Emulador local" > build/reporte/local/dispositivo.txt
   python3 tool/reporte-emuladores.py build/reporte reporte-emuladores.html
   ```
   (el emulador necesita KVM/aceleración: correrlo en la máquina, fuera del devcontainer, con la misma versión de Flutter de `pubspec.yaml`).

El HTML queda autocontenido (capturas en base64): se puede abrir en el navegador, adjuntar o subir como evidencia. Guardar una copia en `docs/evidencias/` solo si el equipo lo quiere en el repo (pesa ~100 KB por captura).

---

## 9. Orden de trabajo sugerido (commits pequeños, cada uno compila)

1. Rama desde `origin/develop` actualizado (§8.1, el reporte ya viene incluido).
2. `docs(mobile): KAN-260 referencias de diseño de HU-M04`: copiar al repo, en `docs/hu-m04/`, la carpeta `diseno/` del zip (3 PNG + 3 HTML de M04-04 y las capturas de Figma de M04-02 y M04-03) y este plan como `docs/hu-m04/plan.md`, con un `docs/hu-m04/README.md` corto que diga qué es cada archivo y que M04-04 sale de los mocks (no está en Figma).
3. Íconos nuevos en `SolIcons` + `SolFormat.monthYear`, con pruebas.
4. Dominio + cálculo + prueba unitaria.
5. Fixtures, fake datasource y repositorio + prueba.
6. ARB (es/en) + `gen-l10n`.
7. M04-04 con sus estados + prueba de widget.
8. M04-02 y M04-03 + pruebas de widget.
9. Goldens de las pantallas (`tool/goldens.sh`), revisados contra los PNG de `docs/hu-m04/`.
10. `integration_test/cobertura_test.dart` con `capturar()` (§8.2).
11. `docs`: `PROJECT_STATUS.md` (HU-M04: pantallas con mocks, sin push ni navegación todavía).
12. `tool/verificar.sh` en verde → PR a `develop` con la plantilla. Sin atribución a IA.
13. Correr Emuladores en la rama (§8.3.1) y compartir `reporte-emuladores.html`.

Mensajes de commit en español, formato del repo: `feat(mobile): KAN-260 …`, `test(mobile): KAN-260 …`, `docs(mobile): KAN-260 …`.

---

## 10. Definición de hecho (para revisar el PR)

- [ ] M04-04 igual a los 3 mocks (lista sin saldo, saldo a favor en verde, saldo en contra en rojo), con signo e ícono además del color.
- [ ] Disponible y porcentaje sin incluir el saldo; los números cuadran con §3.2.
- [ ] M04-02 igual al Figma `2005:301` y M04-03 igual al Figma `2005:217`.
- [ ] Estados de cargando, error con reintento y vacío cubiertos.
- [ ] Ningún texto quemado; es y en completos; texto al 200 % sin cortes (goldens).
- [ ] Goldens en `test/goldens/ci/`, prueba de integración con capturas y `tool/verificar.sh` en verde.
- [ ] `reporte-emuladores.html` con las capturas de M04-02, M04-03 y M04-04 (3 variantes) en los 3 emuladores.
- [ ] Diseños y plan en `docs/hu-m04/`.
- [ ] Commits y PR solo a nombre de felipe, sin atribución a IA.


## 11. Pendientes que este plan deja anotados (no bloquean el demo)

- Contrato GraphQL de cobertura e indemnizaciones (no existe en `schema.graphql`): cuando llegue, crear `GqlCoberturaRemoteDataSource` y elegirlo con `usarFakesProvider`.
- Push M04-01 (banner, Figma `2005:286`) y FCM real (KAN-259).
- Navegación: rutas `m04-02`, `m04-03`, `m04-04` en `router.dart` y conectar los callbacks (push → M04-02 → «Ver detalle» → M04-03; M04-04 desde Home o perfil).
- Montos en la moneda elegida en la píldora (hoy `SolFormat.currency` es solo COP, igual que M05).
- Decidir si «Total indemnizado» suma todas las pólizas (así está el mockup: $ 950.000) o solo la vigente.
