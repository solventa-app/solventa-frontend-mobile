# Integración con el backend

Cómo habla la app con el BFF de Solventa, cómo se eligen los ambientes sin mezclar datos, cómo se mapean las
respuestas y los errores, y cómo se trabaja con fakes y pruebas de contrato para que un cambio del backend no rompa la
app en silencio. Complementa [`arquitectura.md`](arquitectura.md). Sigue las mismas reglas que
`solventa-frontend-web` (cliente en `apps/web/src/graphql/cliente.ts`, mocks MSW en `apps/web/src/mocks/`, copia del
contrato en `contrato/`) para que web y móvil se comporten igual ante el mismo backend.

Todo este documento es **plan** salvo donde dice **hoy**.

**Hoy** ya existe la capa data como ACL, con el onboarding de HU-M01 completo contra el contrato v0.20 en
`lib/features/onboarding/` (`onboarding.graphql`: iniciar, consentir, subir las cuatro piezas por URL firmada,
crear la cuenta, enviar, consultar, reintentar y actualizar la sesión):

- `lib/core/contrato/schema.graphql` y `tool/contrato.sh verificar|sincronizar`.
- Codegen por operación (`graphql_codegen`, configurado en `build.yaml`).
- `lib/core/network/` (`GraphqlClient`, providers con `API_ENV` y `API_BASE_URL`) y `lib/core/errors/` (`Falla`,
  `Resultado`, `guardarFallas`).
- Entidad, mapper, datasource real y fake, fixtures, repositorio y sus pruebas, más `test/contract/fixtures_test.dart`.
- Sesión en secure storage (`lib/core/sesion/`, en memoria con `API_ENV=mock`). El token del recorrido
  (`X-Onboarding-Token`, 30 min) vive solo en memoria dentro del repositorio.
- Subida directa al bucket con el PUT firmado (`SubidaArchivoService`); el BFF nunca recibe los bytes.

**Plan**: interceptores de trazas y logs, prefijo de datos por ambiente, `bootstrap.dart`
y los pasos de CI de la tabla del §6.

### Receta: agregar una operación

```bash
# 1. Si el backend cambió el contrato
tool/contrato.sh sincronizar
# 2. Escribir la operación en lib/features/<feature>/data/graphql/<operacion>.graphql
# 3. Generar tipos (escribe <operacion>.graphql.dart al lado; se versiona)
dart run build_runner build
# 4. Fixtures (data/fixtures/), mapper, datasource real + fake, repositorio
# 5. Registrar las fixtures en test/contract/fixtures_test.dart y probar
flutter analyze && flutter test
```

Los archivos `*.graphql.dart` llevan `// ignore_for_file: type=lint` (lo pone el codegen) y ya salen formateados.

---

## 1. Ambientes

El backend es un **BFF GraphQL** (`solventa-backend/services/bff`) detrás de un API Gateway. El canal móvil es
**`POST /graphql/app`** (la web usa `/graphql/web`; mismo esquema, el canal viaja en el contexto del BFF).

| `API_ENV` | Para qué | Flavor | `API_BASE_URL` | Archivo |
|---|---|---|---|---|
| `mock` | Construir pantallas sin backend; demos; pruebas de integración en CI | `dev` | vacío (no hay red: fakes) | `config/mock.json` |
| `local` | Probar contra el backend en tu máquina (`docker compose up` en `solventa-backend`) | `dev` | `http://10.0.2.2:8080` (gateway Envoy local) | `config/local.json` |
| `dev` | Build de pruebas contra el backend desplegado en la nube (staging) | `dev` | `gateway_url` de staging | `config/dev.json` |
| `prod` | APK firmado del GitHub Release | `prod` | `gateway_url` de producción | `config/prod.json` |

```bash
flutter run --flavor dev  --dart-define-from-file=config/mock.json    # sin backend
flutter run --flavor dev  --dart-define-from-file=config/local.json   # backend local
flutter run --flavor dev  --dart-define-from-file=config/dev.json     # staging
flutter build appbundle --flavor prod --dart-define-from-file=config/prod.json
```

Notas:

- **Emulador:** `10.0.2.2` es el `localhost` de tu máquina. **Teléfono por USB:** `adb reverse tcp:8080 tcp:8080` y
  cambia la URL a `http://localhost:8080` en una copia local (no la subas).
- Para depurar directo contra el BFF sin gateway, el puerto es `8000` (igual que en la web).
- El flavor `dev` permite tráfico sin TLS (lo configura el PR de CI/CD con `manifestPlaceholders`); `prod` no.
- El backend hoy solo tiene **local** y **staging** (ADR-07). Mientras no exista producción, `config/prod.json`
  queda con `API_BASE_URL` vacío y la app de prod no arranca contra ningún backend; si el equipo decide que la
  entrega del curso apunte a staging, se escribe aquí y en `docs/ci-cd.md`.
- **No hay ambiente QA**: QA instala el build `dev` desde Firebase App Distribution (grupo `qa`).

### Claves de `config/*.json`

```json
{ "FLAVOR": "dev", "API_ENV": "local", "API_BASE_URL": "http://10.0.2.2:8080" }
```

| Clave | Valores | Dueño |
|---|---|---|
| `FLAVOR` | `dev`, `prod` | PR de CI/CD |
| `API_BASE_URL` | URL sin `/` final; vacío en `mock` | PR de CI/CD |
| `API_ENV` | `mock`, `local`, `dev`, `prod` | Este documento (se agrega a los cuatro archivos) |

Se leen en `lib/core/config/app_config.dart` (`AppConfig.flavor`, `AppConfig.apiBaseUrl`, `isDev`, `isProd`, y
`AppConfig.apiEnv` que agrega HU-M01). **Nada secreto** en estos archivos: todo lo que entra por `--dart-define`
queda dentro del APK.

Validaciones al arrancar (`bootstrap.dart`), para que un error de configuración falle en el acto y no a mitad de un
flujo:

- `FLAVOR=prod` exige `API_ENV=prod` y URL `https://`.
- `API_ENV` distinto de `mock` exige `API_BASE_URL`.
- Sin `--dart-define-from-file` la app arranca en `mock` (nunca contra un backend por accidente).

### Datos separados por ambiente

- **dev y prod** son apps distintas (`com.solventa.solventa_mobile.dev` y `com.solventa.solventa_mobile`): Android
  les da almacenamiento, SQLite, secure storage, caché y sesión propios. Se pueden instalar las dos a la vez.
- **mock, local y dev** comparten la app `dev`, así que todo lo que se guarda lleva el prefijo de `API_ENV`:
  - secure storage: `"$apiEnv.token"`, `"$apiEnv.refresh"`;
  - SQLite: archivo `solventa_$apiEnv.sqlite`;
  - preferencias: `"$apiEnv.<clave>"`.
- Además se guarda `ultimo_api_env`. Si al arrancar no coincide con el actual, se borra la sesión del ambiente
  anterior: un token de local nunca viaja a staging ni al revés.
- Fuera de `prod` la app muestra una cinta discreta con el ambiente (`MOCK`, `LOCAL`, `DEV`) en la esquina para que
  nadie confunda una captura o un hallazgo. Sentry y los logs llevan `environment = API_ENV`.

---

## 2. Cliente GraphQL

Un cliente propio y delgado sobre **`dio`**, igual de mínimo que el de la web (`ejecutar(consulta, variables)`),
sin `graphql_flutter` ni `ferry`: con pocas operaciones no hace falta su caché normalizada y así los fakes y los
interceptores quedan bajo nuestro control.

```
lib/core/network/
  graphql_client.dart        ejecutar(DocumentNode, variables) → Map<String, Object?> (data)
  dio_factory.dart           baseUrl = AppConfig.apiBaseUrl + '/graphql/app', timeouts, interceptores
  interceptors/
    auth_interceptor.dart    Authorization: Bearer <token del secure storage>
    trace_interceptor.dart   traceparent y X-Request-ID (docs/observabilidad.md)
    log_interceptor.dart     solo con FLAVOR=dev: método, operación, estado y duración; nunca cuerpos ni cabeceras
  network_exceptions.dart    ErrorRed, ErrorHttp(status), ErrorGraphql(errores)
```

Reglas del cliente:

- Timeouts: conexión 5 s, respuesta 15 s (el gateway corta a 700 ms por servicio; si el BFF degrada, responde
  rápido con una oferta preliminar o un error de negocio, no se queda colgado).
- **No reintenta solo** las mutaciones (pueden no ser idempotentes): el reintento lo decide el usuario con el
  botón «Reintentar», como en la web. Las consultas pueden reintentar una vez ante `ErrorRed`.
- Si el cuerpo trae `errors`, lanza `ErrorGraphql` aunque el HTTP sea 200; si no trae `data`, también.
- Nunca imprime con `print`; usa `SolLog`.

---

## 3. Modelos generados y mapeo de respuestas

**Generación.** Igual que la web genera tipos con `graphql-codegen`, el móvil usa
[`graphql_codegen`](https://pub.dev/packages/graphql_codegen) con `build_runner`:

- Esquema: `lib/core/contrato/schema.graphql` (copia del backend, §6).
- Operaciones: `lib/features/<feature>/data/graphql/<operacion>.graphql`, una por archivo, con nombre
  (`mutation RegistrarConsentimiento(...)`). Se piden **solo** los campos que la pantalla usa.
- Salida: `<operacion>.graphql.dart` junto al `.graphql`, con `Variables$...`, `Mutation$...`/`Query$...` y su
  `fromJson`. Se versiona (el CI verifica que esté al día con `dart run build_runner build` sin diferencias).
- `addTypenames: true` para que las uniones (`ResultadoOferta = Oferta | ErrorOferta`) se distingan por `__typename`.

Si el backend renombra o quita un campo que usamos, **el codegen falla o el código no compila**: es la primera
barrera para que el contrato no se rompa en silencio.

**Mapeo.** El datasource remoto devuelve el tipo generado; el **mapper** (capa `data`) lo convierte en entidad. El
dominio y la UI nunca ven un tipo generado.

```dart
// lib/features/onboarding/data/mappers/onboarding_mapper.dart
EstadoOnboarding estadoOnboardingDesdeGql(Enum$EstadoOnboarding e) => switch (e) {
  Enum$EstadoOnboarding.INICIADO => EstadoOnboarding.iniciado,
  Enum$EstadoOnboarding.EN_VERIFICACION => EstadoOnboarding.enVerificacion,
  Enum$EstadoOnboarding.VERIFICADA => EstadoOnboarding.verificada,
  Enum$EstadoOnboarding.RECHAZADA => EstadoOnboarding.rechazada,
  Enum$EstadoOnboarding.EN_REVISION => EstadoOnboarding.enRevision,
  Enum$EstadoOnboarding.$unknown => EstadoOnboarding.enRevision, // valor nuevo del backend: el más seguro
};
```

Reglas de mapeo:

- **Enums:** todo enum tiene rama `$unknown` con un valor seguro; un enum nuevo del backend (cambio aditivo) no
  tumba la app.
- **Dinero:** `Monto.valor` llega como texto decimal; se conserva como texto o `Decimal`, nunca `double`. Se
  formatea con `SolFormat` según el locale.
- **Fechas:** el scalar `DateTime` se mapea a `DateTime` en `build.yaml` (ISO 8601, UTC) y se muestra en hora local.
- **Uniones de error** (`ErrorOferta`, `ErrorAutenticacion`, `ErrorCobro`, `ErrorUsuario`): no son excepciones,
  son respuestas válidas. El mapper las convierte en un `Fracaso(FallaNegocio(motivo))` o en una variante de la
  entidad (p. ej. oferta preliminar), según lo que la pantalla deba mostrar.
- **Nulos:** si un campo opcional del contrato llega nulo, la entidad lo modela como opcional; no se inventan
  valores por defecto que la UI muestre como reales.

### 3.1 La capa `data` es la ACL de la app (comparación con la web)

En el backend, la ACL (`services/acl-worker`) protege al dominio de los proveedores externos (Open Finance, KYC,
pasarela). En la app, el «proveedor externo» es el BFF: la capa `data` (tipos generados + mappers + repositorio)
cumple ese papel, y fuera de ella nadie conoce la forma del JSON.

| Pieza | Web (`solventa-frontend-web`, hoy) | Móvil (plan) |
|---|---|---|
| Tipos del contrato | `graphql-codegen` con el plugin `typescript`: genera los **tipos del esquema** en `src/graphql/tipos.ts` | `graphql_codegen`: genera tipos **por operación** (solo los campos pedidos) con `fromJson` |
| Operaciones | Strings dentro de los composables (`useCotizacion.ts`), sin validar contra el esquema | Archivos `.graphql` validados por el codegen al compilar |
| Validación en tiempo de ejecución | No hay (ni zod ni similar): se confía en el tipo | `fromJson` generado: si falta un campo requerido, falla en el datasource y se convierte en `Inesperada` |
| Mapeo a modelo propio | No hay: las pantallas usan los tipos del contrato directo; uniones con guardas (`esErrorOferta`) y nombres legibles en `utils/nombres.ts` | Mapper tipo generado → entidad del dominio; la UI solo ve entidades |
| Mocks | MSW en `src/mocks/handlers.ts`, tipados con los tipos generados | Fakes de datasource que parsean fixtures JSON con los tipos generados |
| Verificar copia del contrato | `npm run contrato:verificar` en CI | `tool/contrato.sh verificar` en CI |

Por qué el móvil va un paso más allá: la web misma documenta que «una omisión solo se nota contra el BFF» (los mocks
devuelven el objeto completo aunque la consulta no pida un campo). Con tipos por operación y fixtures que parsean
con ellos, ese error aparece en `flutter analyze` o `flutter test`, no en el teléfono. Y como una app publicada no
se actualiza al instante como una web, el mapper con valores seguros para enums desconocidos evita que un cambio
aditivo del backend tumbe versiones viejas.

---

## 4. Errores

Una sola jerarquía en `lib/core/errors/falla.dart`; el repositorio la produce y la UI solo la traduce a un texto del
ARB. **Nunca** se muestra un código HTTP, un mensaje del servidor ni un stack trace.

```dart
sealed class Falla { const Falla(); }
final class SinConexion extends Falla {}            // sin red o timeout de conexión
final class ServicioNoDisponible extends Falla {}   // 502, 503, 504 del gateway o timeout de respuesta
final class SesionVencida extends Falla {}          // token inválido o vencido
final class SinPermiso extends Falla {}             // rol sin acceso
final class FallaNegocio extends Falla { const FallaNegocio(this.motivo); final String motivo; }
final class Inesperada extends Falla {}             // cualquier otra cosa (se reporta a Sentry)

sealed class Resultado<T> { const Resultado(); }
final class Exito<T> extends Resultado<T> { const Exito(this.valor); final T valor; }
final class Fracaso<T> extends Resultado<T> { const Fracaso(this.falla); final Falla falla; }
```

| Origen | Falla | Qué ve el usuario | Reintentable |
|---|---|---|---|
| Sin red, DNS, timeout de conexión | `SinConexion` | «No tienes conexión. Revisa tu internet e intenta de nuevo.» | Sí |
| HTTP 502, 503, 504 o timeout de respuesta | `ServicioNoDisponible` | «El servicio tardó más de lo esperado. Intenta nuevamente.» (mismo texto que la web) | Sí |
| Error GraphQL de token inválido o vencido | `SesionVencida` | Se borra la sesión y se vuelve al ingreso | No |
| Error GraphQL de rol no permitido | `SinPermiso` | Mensaje de acceso no permitido | No |
| Unión `Error*` del contrato | `FallaNegocio(motivo)` | El estado diseñado para ese motivo (p. ej. M01-07c) | Según el motivo |
| HTTP 4xx/5xx restante, `errors` inesperado, JSON que no parsea | `Inesperada` | Mensaje genérico con «Reintentar» y código de soporte | Sí |

**Dependencia con el backend.** Hoy el BFF señala la sesión y los permisos con un error GraphQL cuyo único dato es
el texto (`ErrorPublico` en `services/bff/app/esquema.py`), con HTTP 200. Para no depender de un texto, se pedirá al
backend un cambio **aditivo**: `extensions.codigo` (`SIN_SESION`, `TOKEN_INVALIDO`, `SIN_PERMISO`) en esos errores.
Mientras llega, `graphql_client.dart` compara contra las constantes de mensaje del BFF en un solo lugar.

---

## 5. Fakes y mocks

Mismo principio que la web: **se trabaja con fakes hasta que el BFF tenga la operación desplegada**, y los fakes
siguen el contrato.

- Cada datasource remoto tiene `Fake<X>RemoteDataSource` en `data/datasources/`, que implementa la misma interfaz y
  devuelve **tipos generados** construidos desde las fixtures de `lib/features/<feature>/data/fixtures/<operacion>_fixtures.dart`.
  Si el contrato cambia y la fixture ya no parsea, la prueba falla.
- Se activan con `API_ENV=mock`: el provider del datasource elige el fake. No hay `if (kDebugMode)` dentro de
  repositorios ni pantallas.
- Simulan latencia (300–1500 ms) para que se vean los estados de carga, y se pueden configurar para devolver cada
  caso.
- **Convenciones de demo** (como `999` / `000` en la web; **no** son del backend real) se documentan en una tabla en
  la carpeta de fixtures de cada feature. En HU-M01 los disparadores de M01-05 fijan el desenlace del fake
  (`FakeOnboardingRemoteDataSource.resultado`): verificada, en revisión o rechazada por ILEGIBLE.

- Los `SolDemoTrigger` del Figma (p. ej. «Simular que no reconoce la biometría») se conectan al fake en debug; en
  release no existen.
- En pruebas de widget y de notifier se usa `ProviderScope(overrides: [...])` con el fake o con `mocktail`; para
  probar el cliente HTTP en sí, `http_mock_adapter` sobre `dio`.

---

## 6. Contrato y pruebas de contrato

Reglas (ADR-06, las mismas que la web):

1. `lib/core/contrato/schema.graphql` es una **copia** de `solventa-backend/contracts/graphql/schema.graphql`. No se edita a
   mano.
2. `tool/contrato.sh sincronizar` trae la versión del backend (repo hermano `../solventa-backend`,
   `BACKEND_SCHEMA_PATH` o `BACKEND_SCHEMA_URL`, como `scripts/contrato.mjs` en la web) y `tool/contrato.sh verificar`
   falla si difieren. El CI corre `verificar`.
3. El backend solo hace cambios **aditivos**; retirar algo es deprecar un sprint antes.
4. Un cambio de contrato son **dos PRs enlazados**: el del backend y el gemelo aquí (sincronizar, codegen, fixtures,
   fakes y pantallas). La plantilla de PR ya lo pide.
5. Si una HU necesita una operación que no existe (como pasó con HU-M01 hasta el contrato v0.20), el móvil propone
   el cambio al backend con la forma exacta de la operación, construye contra fixtures con esa forma y sincroniza
   cuando el PR del backend se fusiona.

Qué impide que se rompa:

| Barrera | Qué detecta | Dónde corre |
|---|---|---|
| `contrato.sh verificar` | La copia del esquema no es la del backend | CI de este repo (plan: paso en `ci.yml`, necesita leer `solventa-backend`) |
| Codegen + `flutter analyze` | Una operación pide un campo o argumento que ya no existe, o cambió de tipo | CI de este repo (plan: `dart run build_runner build` y `git diff --exit-code`) |
| Prueba de fixtures (`test/contract/fixtures_test.dart`) | Toda fixture parsea con su tipo generado y pasa por su mapper | `flutter test` |
| Pruebas de mappers | Enum desconocido, nulos, uniones de error | `flutter test` |
| Colección Newman del backend (`tests/newman/`) | El BFF real responde lo que el contrato promete en el canal `app` | CI del backend (ya cubre el canal móvil en la oferta) |
| `integration_test` con `API_ENV=local` | Recorrido real contra el `docker compose` del backend | A mano antes de cerrar una HU |

---

## 7. Sesión y autenticación

- El JWT del BFF vive solo en `flutter_secure_storage` (con prefijo de ambiente) y en memoria; nunca en logs,
  preferencias ni SQLite. El interceptor lo pone en `Authorization: Bearer`.
- `SesionVencida` borra el token y lleva al ingreso.
- Biometría y refresh token (HU-M02) siguen el diseño de `solventa-backend/docs/autenticacion-usuarios.md` §7: la
  biometría nunca llega al servidor, solo desbloquea el refresh token guardado en el Keystore.
