# Arquitectura de la app móvil

Cómo se organiza el código de `solventa_mobile` y qué reglas sigue toda pantalla o feature nueva. Es la referencia
para personas y para agentes: si vas a implementar algo en este repo, léelo antes. La integración con el backend
(ambientes, cliente GraphQL, errores, mapeo, fakes y contrato) está en [`integracion-backend.md`](integracion-backend.md).
El sistema de diseño está en [`lib/core/design_system/README.md`](../lib/core/design_system/README.md).

Base: la guía *Manual de Arquitectura Móvil 2026* (features verticales, Riverpod, repositorios y datasources,
SQLite, extensiones de tema, ARB) adaptada a lo que ya está decidido en Solventa. Donde la guía y Solventa no
coinciden, la sección [Diferencias con la guía](#diferencias-con-la-guía) dice qué se hace y por qué.

Como en `docs/ci-cd.md`, cada cosa se marca **hoy** (ya existe en el código) o **plan** (acordado, falta
implementarlo). Quien implemente algo del plan lo pasa a **hoy** en ese mismo PR.

---

## 1. Principios

1. **Una feature, una carpeta.** Cada historia o contexto de negocio (onboarding, sesión, asistencia…) vive en
   `lib/features/<feature>/` con sus tres capas. Una feature no importa archivos internos de otra; si necesita algo
   compartido, va a `lib/core/` o se expone por un provider público de la feature dueña.
2. **Las dependencias apuntan hacia adentro.** `presentation → domain ← data`. El dominio es Dart puro: no importa
   Flutter, Riverpod, `dio`, JSON ni tipos generados del contrato.
3. **El estado vive fuera del árbol de widgets.** Riverpod, estados inmutables y `switch` exhaustivo sobre ellos.
   Nada de banderas `isLoading` sueltas en un `StatefulWidget`.
4. **El contrato manda.** Las respuestas del BFF se parsean con tipos generados del esquema GraphQL y se traducen a
   entidades del dominio en la capa `data`. La UI nunca ve JSON ni un error técnico.
5. **Fiel al prototipo.** Las pantallas se arman solo con piezas de `solventa_ui.dart` y sus tokens; no se inventa
   diseño ni se quema un color, un tamaño o un texto.
6. **No sobre-construir.** Una capa, una librería o un caso de uso entra cuando una pantalla del sprint lo pide.

---

## 2. Estructura de carpetas

```
config/                       plan · dart-defines por ambiente: local.json, mock.json, dev.json, prod.json
contrato/                     plan · copia del esquema GraphQL del backend (no se edita a mano)
assets/
  fonts/Inter/                hoy
  images/                     plan · WebP o SVG, nunca PNG pesados
lib/
  main.dart                   hoy · arranque único; el ambiente sale de --dart-define-from-file
  app/
    solventa_app.dart         hoy · MaterialApp: tema, locale, router
    router.dart               plan · go_router con las rutas de todas las features
    bootstrap.dart            plan · lee AppConfig, separa datos por ambiente, crea el ProviderScope
  core/
    config/                   plan · AppConfig: FLAVOR, API_ENV, API_BASE_URL (lo crea el PR de CI/CD)
    network/                  plan · GraphqlClient sobre dio, interceptores, mapeo de errores HTTP
    errors/                   plan · Falla (sealed) y Resultado<T>
    storage/                  plan · secure storage y SQLite con prefijo por ambiente
    log/                      plan · SolLog (docs/observabilidad.md)
    l10n/                     plan · archivos .arb y código generado
    design_system/            hoy  · tokens, tema, íconos, componentes y layouts (KAN-239)
  features/
    <feature>/
      domain/
        entities/             clases inmutables del negocio (Dart puro)
        repositories/         contratos abstractos (abstract interface class)
        usecases/             solo si hay una regla o se orquestan 2+ repositorios
      data/
        graphql/              operaciones .graphql y su código generado (*.graphql.dart)
        datasources/          <x>_remote_datasource.dart, <x>_local_datasource.dart, fake_<x>_remote_datasource.dart
        mappers/              tipo generado o fila SQLite → entidad
        repositories/         <x>_repository_impl.dart
      presentation/
        providers.dart        providers de la feature (datasource, repositorio, notifiers)
        <pantalla>_notifier.dart  + <pantalla>_state.dart
        pages/                una pantalla = un archivo <id>_<nombre>_page.dart
        widgets/              piezas exclusivas de la feature
test/
  core/ · features/<feature>/{domain,data,presentation}/   mismas rutas que lib/
  fixtures/graphql/           respuestas JSON del BFF (sirven a fakes y pruebas de contrato)
  goldens/                    hoy
```

Hoy existen `lib/features/home/presentation/` y `lib/features/assistance/presentation/` solo con la pantalla, sin
`domain` ni `data`: no consumen datos todavía. Cuando lo hagan, se completan con esta estructura.

**Nombres.** Archivos en `snake_case`, clases en `PascalCase`. El código y los identificadores van en inglés
cuando son técnicos (`Repository`, `Notifier`, `DataSource`) y en español cuando son del negocio y así los nombra
el contrato (`Consentimiento`, `Oferta`, `documentoIdentidad`). La regla práctica: el nombre de una entidad o
campo es el mismo que en `schema.graphql`. Documentación, comentarios y commits en español.

---

## 3. Capas

### 3.1 Dominio (qué hace)

- **Entidades**: clases `final` e inmutables, con `==` y `hashCode` (o `record` cuando basta). Sin `fromJson`.
  Dinero como `Monto(valor: Decimal-como-String, moneda)`, nunca `double`, igual que el contrato.
- **Repositorios**: `abstract interface class` con métodos que devuelven `Future<Resultado<T>>` (o `Stream`). Es el
  único punto por el que la presentación pide datos.
- **Casos de uso**: una clase con un solo método `call`. Se crean **solo** cuando hay una regla de negocio propia
  (p. ej. «el consentimiento vence a los 30 días y hay que pedirlo de nuevo») o cuando se combinan dos o más
  repositorios. Si el notifier solo pasaría el llamado al repositorio, se llama al repositorio directo.
- **Fallas**: `sealed class Falla` en `core/errors/` (ver [integracion-backend.md §4](integracion-backend.md#4-errores)).

```dart
// lib/features/onboarding/domain/entities/verificacion_identidad.dart
enum EstadoVerificacion { verificada, enRevision, rechazada }

final class VerificacionIdentidad {
  const VerificacionIdentidad({required this.id, required this.estado});
  final String id;
  final EstadoVerificacion estado;
}

// lib/features/onboarding/domain/repositories/verificacion_repository.dart
abstract interface class VerificacionRepository {
  Future<Resultado<VerificacionIdentidad>> verificar(SolicitudVerificacion solicitud);
}
```

### 3.2 Datos (cómo se ejecuta)

- **Datasources** por tecnología: remoto (GraphQL), local (SQLite o secure storage), plataforma (cámara, biometría).
  Cada uno tiene una interfaz y una o más implementaciones. El remoto tiene siempre un **fake** con los mismos
  casos de demo que los mocks de la web.
- **Modelos**: los del BFF son los **tipos generados** de las operaciones GraphQL (no se escriben a mano). Los de
  SQLite son las clases que genere `drift`. No heredan de las entidades: se convierten con un **mapper**.
- **Mappers**: funciones puras `tipoGenerado → entidad` con su prueba unitaria. Aquí se resuelven enums
  desconocidos, nulos y formatos (fechas ISO, dinero como texto).
- **Repositorio impl**: elige datasource (remoto, caché local), mapea y convierte excepciones en `Falla`. Nunca deja
  escapar una `DioException` ni un error GraphQL.

```dart
// lib/features/onboarding/data/repositories/verificacion_repository_impl.dart
final class VerificacionRepositoryImpl implements VerificacionRepository {
  VerificacionRepositoryImpl(this._remote);
  final VerificacionRemoteDataSource _remote;

  @override
  Future<Resultado<VerificacionIdentidad>> verificar(SolicitudVerificacion s) =>
      guardarFallas(() async => verificacionDesdeGql(await _remote.verificar(s)));
}
```

`guardarFallas` (en `core/errors/`) envuelve la llamada, captura `ErrorRed`/`ErrorGraphql` del cliente y devuelve
`Exito(valor)` o `Fracaso(falla)`.

### 3.3 Presentación (UI y estado)

- **Notifier** por pantalla o flujo (`Notifier` / `AsyncNotifier` de Riverpod 3). Expone un **estado inmutable**
  `sealed` y métodos de intención (`aceptarConsentimiento()`, `capturarFrente()`).
- **Página**: `ConsumerWidget` que hace `ref.watch` del notifier y un `switch` exhaustivo sobre el estado. Usa un
  layout de `solventa_ui.dart` (`SolFlowScaffold`, `SolTransitionalScreen`, `SolResultScreen`…). Navega con
  `go_router` en respuesta al estado (`ref.listen`), no desde el notifier.
- **Widgets de la feature**: solo si una pieza se repite dentro de la feature o hace la página ilegible. Si sirve a
  más de una feature, se propone para el sistema de diseño.

```dart
// lib/features/onboarding/presentation/verificacion_state.dart
sealed class VerificacionState { const VerificacionState(); }
final class VerificacionEnCurso extends VerificacionState { const VerificacionEnCurso(); }
final class VerificacionTerminada extends VerificacionState {
  const VerificacionTerminada(this.resultado);
  final VerificacionIdentidad resultado;
}
final class VerificacionFallida extends VerificacionState {
  const VerificacionFallida(this.falla);
  final Falla falla;
}

// lib/features/onboarding/presentation/verificacion_notifier.dart
final class VerificacionNotifier extends Notifier<VerificacionState> {
  @override
  VerificacionState build() => const VerificacionEnCurso();

  Future<void> verificar(SolicitudVerificacion s) async {
    state = const VerificacionEnCurso();
    final r = await ref.read(verificacionRepositoryProvider).verificar(s);
    state = switch (r) {
      Exito(:final valor) => VerificacionTerminada(valor),
      Fracaso(:final falla) => VerificacionFallida(falla),
    };
  }
}

// lib/features/onboarding/presentation/pages/m01_06_verificando_page.dart
class M0106VerificandoPage extends ConsumerWidget {
  const M0106VerificandoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(verificacionNotifierProvider, (_, estado) {
      if (estado is VerificacionTerminada) context.go(rutaResultado(estado.resultado.estado));
    });
    return SolTransitionalScreen(
      title: context.l10n.m0106Titulo,
      message: context.l10n.m0106Verificando,
    );
  }
}
```

---

## 4. Estado con Riverpod

**Plan.** `flutter_riverpod` 3.x, sin generación de código para los providers (menos `build_runner` y más fácil de
leer para quien llega). Reglas:

| Qué | Cómo |
|---|---|
| Dependencias (cliente, datasource, repositorio) | `Provider<T>` en `presentation/providers.dart` de la feature, o en `core/` si son transversales |
| Estado de una pantalla o flujo | `NotifierProvider` / `AsyncNotifierProvider`, `autoDispose` salvo que el flujo cruce pantallas |
| Flujo de varias pantallas (onboarding) | Un notifier del flujo que guarda lo capturado; cada página lee lo que necesita con `select` |
| Datos de solo lectura | `FutureProvider` / `StreamProvider` y `AsyncValue.when` (o `switch`) en la UI |
| Leer en `build` | `ref.watch` (o `ref.watch(p.select(...))` para no repintar de más) |
| Leer en callbacks | `ref.read` |
| Efectos (navegar, snackbar) | `ref.listen` en la página |
| Fakes y pruebas | `ProviderScope(overrides: [...])`; nunca `if (kDebugMode)` dentro del repositorio |

Prohibido: `setState` para estado de negocio, `BuildContext` dentro de un notifier, singletons globales (`GetIt`,
variables estáticas mutables) y `Provider.of` del paquete `provider`.

`setState` sí se permite para estado puramente visual y local de un widget (un `AnimationController`, el foco de
un campo).

---

## 5. Navegación

**Hoy** la app usa `onGenerateRoute` con la raíz y la galería de debug. **Plan:** `go_router` cuando entre la
primera feature con más de una pantalla (HU-M01). Rutas con el id del plano como nombre (`m01-01`, `m01-02`…) para
trazarlas a Figma, y un test que verifique que cada pantalla del sprint tiene su ruta (como
`src/router/pantallas.ts` en la web). La galería sigue existiendo solo en debug.

Atrás del sistema: lo manejan los layouts (`SolFlowScaffold` con `PopScope`, `SolTransitionalScreen` bloqueado).
Ninguna página reimplementa `PopScope`.

---

## 6. Tema, íconos y responsive

**Hoy.** El sistema de diseño ya resuelve lo que la guía pide en la sección 1.4:

- Colores e íconos vía tema y extensiones de contexto: `context.colors`, `context.solColors`, `context.solText`,
  `SolIcons`. Nunca `Color(0x...)`, `Colors.*` ni `Icons.*` en una feature.
- Medidas con tokens en dp: `SolSpacing`, `SolRadius`, `SolSizes`.
- Responsive con `SolBreakpoints` (`compact` < 600 dp, `expanded` ≥ 600 dp) y `SolAdaptiveBody` (contenido centrado
  a 600 dp en plegables, tablets y horizontal). Los layouts ya lo aplican.
- Accesibilidad: texto hasta 200 % sin desbordes, áreas táctiles de 48 dp, `Semantics` en íconos sin texto,
  `liveRegion` en carga y resultados, contraste AA probado, «quitar animaciones» respetado.

**No se usa ScreenUtil** (ver [Diferencias con la guía](#diferencias-con-la-guía)).

Regla para una pantalla: se arma con un layout de `solventa_ui.dart` y componentes del sistema; si algo del Figma no
existe como componente, primero se agrega al sistema de diseño (con golden y test) y luego se usa.

---

## 7. Idiomas (i18n) con ARB

**Plan.** La app soporta **español (Colombia)** e **inglés**. Hoy los textos están en español dentro de los
widgets y `SolLocalizations` fija `es_CO`; el primer PR de HU-M01 lo migra.

- Archivos en `lib/core/l10n/arb/app_es.arb` (plantilla) y `app_en.arb`. Generación oficial con `flutter gen-l10n`
  (`l10n.yaml` con `synthetic-package: false`, salida en `lib/core/l10n/gen/`) y acceso con `context.l10n.clave`.
- Claves en `lowerCamelCase` con prefijo de pantalla o componente: `m0101Titulo`, `m0102Consentimiento`,
  `solBottomNavInicio`. Cada clave lleva `@clave` con `description` (dónde aparece) para el traductor.
- Plurales y variables con ICU (`{count, plural, =1{1 disponible} other{{count} disponibles}}`); nunca se concatenan
  frases.
- El sistema de diseño también se traduce: sus textos por defecto («Inicio», «Asistencia», «Cerrar sesión»,
  etiquetas de `Semantics`) pasan al ARB.
- Formatos (`SolFormat`) siguen el locale activo: `es-CO` → `$ 450.000`, `12 sep 2026, 11:02 a. m.`; `en` →
  `COP 450,000`, `Sep 12, 2026, 11:02 AM`. La moneda siempre es la que manda el contrato.
- Idioma: el del teléfono si es `es` o `en`; si no, español. La píldora «ES · COP» de la barra superior permite
  cambiarlo y la elección se guarda en preferencias (no es dato personal).
- Un test recorre las claves de `app_es.arb` y falla si falta alguna en `app_en.arb`; los goldens de pantalla se
  generan en los dos idiomas (el inglés suele ser más largo o más corto y destapa desbordes).

---

## 8. Persistencia local y offline

**Plan, cuando una HU lo pida.** La guía propone SQLite como fuente de verdad local; en Solventa se aplica así:

| Dato | Dónde | Por qué |
|---|---|---|
| JWT, refresh token, PIN derivado | `flutter_secure_storage` (Keystore) | Credenciales: cifradas y atadas al dispositivo |
| Preferencias (idioma, onboarding visto) | `shared_preferences` | No son datos personales |
| Datos que deben sobrevivir sin red (póliza de la billetera, evidencias de siniestro pendientes de enviar, colas de sincronización) | SQLite con `drift` | ACID, transacciones, migraciones versionadas y consultas reactivas (`Stream`) |
| Imágenes del documento y la selfie (HU-M01) | Solo en memoria y en el directorio temporal mientras se envían; se borran al terminar | Son datos biométricos y de identidad: no se guardan |

Reglas: las migraciones de `drift` se versionan y prueban (como Alembic en el backend); ningún dato personal va en
SQLite sin cifrar (si hiciera falta, SQLCipher); el archivo de base y las claves llevan el prefijo del ambiente (ver
[integracion-backend.md §1](integracion-backend.md#1-ambientes)). HU-M01 no necesita SQLite.

---

## 9. Pruebas por capa

| Capa | Qué se prueba | Herramienta |
|---|---|---|
| Dominio | Casos de uso y reglas | `test` puro |
| Datos | Mappers (tipo generado → entidad), repositorio con datasource falso (éxito y cada `Falla`), datasource remoto contra respuestas de `test/fixtures/graphql/` | `test`, `mocktail` |
| Presentación | Notifier: transiciones de estado con overrides de Riverpod. Página: cada estado (carga, éxito, vacío, error, degradado), semántica, 48 dp, texto al 200 %, atrás del sistema | `flutter_test` |
| Visual | Goldens de cada pantalla a 360 y 390 dp, texto 100 % y 200 %, en `es` y `en` | `alchemist` |
| Contrato | Operaciones válidas contra `contrato/schema.graphql` y fixtures que parsean con los tipos generados | codegen + `test` ([integracion-backend.md §6](integracion-backend.md#6-contrato-y-pruebas-de-contrato)) |
| Flujo | Recorrido completo de la HU con fakes en emulador | `integration_test` |

---

## 10. Diferencias con la guía

| Guía | En Solventa | Por qué |
|---|---|---|
| `ScreenUtil` (`50.w`, `.sp`) | **No se usa.** Tokens en dp + `SolBreakpoints` + `SolAdaptiveBody` | ScreenUtil escala todo según el ancho: en un teléfono de 360 dp los 48 dp táctiles bajan a ~44 dp (incumple accesibilidad) y en una tablet el botón crece a ~100 dp. `.sp` además pelea con el escalado de texto del sistema, que ya probamos al 200 %, y cambia los goldens según el dispositivo. Material 3 recomienda medidas fijas en dp y layouts que se adaptan por clase de ventana, que es lo que hace el sistema de diseño |
| `.env.dev` / `.env.qa` / `.env.prod` (flutter_dotenv) | `config/<ambiente>.json` con `--dart-define-from-file` | Es lo que ya acordó el plan de CI/CD. Los valores quedan tipados en compilación (`String.fromEnvironment`), no hay un asset `.env` que leer en tiempo de ejecución y el CI lo usa igual. Ningún archivo lleva secretos: todo lo que entra al APK es público |
| Ambiente QA (`main_qa.dart`, `.env.qa`) | **No hay QA.** Flavors `dev` y `prod`; QA instala el build `dev` desde Firebase App Distribution (grupo `qa`) | El backend solo tiene local y staging (ADR-07); un ambiente QA no tendría backend propio. Si aparece, es un tercer archivo `config/qa.json` y un flavor nuevo, sin tocar código |
| `main_dev.dart`, `main_qa.dart`, `main_prod.dart` | Un solo `main.dart` | El ambiente entra por `--dart-define-from-file`; tres `main` duplican el arranque |
| SQLite como única fuente de verdad, migraciones `.sql` | `drift` solo donde haga falta offline (§8) | HU-M01 y la mayoría de pantallas leen del BFF en línea. `drift` trae migraciones versionadas en Dart y consultas reactivas |
| Casos de uso siempre | Solo con regla propia u orquestación | Evita clases que solo reenvían una llamada |
| Modelos que heredan de entidades (Liskov) | Tipos generados + mapper a la entidad | Los tipos los genera el contrato; heredar acoplaría el dominio al JSON |
| Motor de formularios por JSON del backend | Fuera de alcance | Ninguna HU del curso lo pide |
| Fuente Bai Jamjuree, `AppColors`/`AppIcons` | Inter, `SolColors`/`SolIcons` vía tema | Lo define el Figma de Solventa (SG-01) |

---

## 11. Checklist para una feature nueva

1. Frames de Figma ubicados (id del plano) y criterios de aceptación a la vista.
2. ¿El contrato tiene las operaciones? Si no, se pide el cambio aditivo al backend y mientras tanto se trabaja con el
   fake y fixtures acordadas ([integracion-backend.md §6](integracion-backend.md#6-contrato-y-pruebas-de-contrato)).
3. `domain/`: entidades y repositorio abstracto.
4. `data/`: operaciones `.graphql`, codegen, mapper con prueba, datasource remoto + fake, repositorio impl con
   prueba de cada falla.
5. `presentation/`: estado sealed, notifier con prueba, páginas con layouts del sistema, textos en ARB (`es` y `en`).
6. Rutas en `app/router.dart`.
7. Goldens a 360/390 dp, 100/200 %, `es`/`en`; revisión contra Figma.
8. `dart format`, `flutter analyze` y `flutter test` en verde; probado en emulador con el flavor `dev` y `config/mock.json`.
