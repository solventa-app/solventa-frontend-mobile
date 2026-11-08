# HU-M06 · Lo que la app móvil necesita del backend

> **Estado (2026-11-05):** implementado por el backend en el contrato **v0.36** (PR #502, KAN-263): `catalogoPrestadores`
> servido por CLAIMS desde la réplica, con el catálogo en `services/claims/migrations/datos/prestadores.json` (idéntico a
> `docs/hu-m06/prestadores-semilla.json`). La app ya lo consume fuera de `mock`.
>
> **Estado (2026-11-07):** la sección 6 quedó en el contrato **v0.40** (KAN-265 y KAN-266, rama
> `feat/KAN-265-solicitar-asistencia` del backend): `solicitarAsistencia` y `cancelarAsistencia` devuelven la union
> `ResultadoAsistencia` (`Asistencia | ErrorAsistencia` con `codigo`). CLAIMS guarda la asistencia en la colección
> `asistencias` (migración `0006`) con la ubicación y la descripción cifradas, y simula el desenlace
> (`ASISTENCIA_SIMULACION=primero_falla`: el primer intento queda NO_CONFIRMADA y el reintento se confirma). La app lo
> consume en M06-02 a M06-06 (`lib/features/assistance/presentation/pages/`).

Para el equipo y los agentes de `solventa-backend`. Historia **KAN-36** (HU-M06, Journey 3); tarea de backend **KAN-263**
(`S3-M06-1`). Escrito desde la app móvil el 2026-11-04, con la app ya construida contra un fake con estos mismos datos
(rama `feat/KAN-36-asistencia-en-sitio` de `solventa-frontend-mobile`).

## 1. Decisión: los prestadores son un **dato maestro**

Los prestadores (clínicas y talleres) se cargan una vez y **casi no cambian**: no tiene sentido pedirlos ni recalcularlos
en el backend cada vez que alguien abre el mapa. Por eso:

| Qué | Dónde | Por qué |
|---|---|---|
| Catálogo de prestadores (id, nombre, tipo, coordenadas, ciudad, activo) | **Backend**: colección maestra sembrada | Fuente única y versionada |
| Versión del catálogo | **Backend** | La app solo descarga cuando cambia |
| Copia del catálogo | **App**, en el teléfono, se revisa cada 7 días | El mapa abre sin red y sin carga en el backend |
| Los 3 más cercanos, distancia y tiempo estimado | **App** (Haversine; 20 km/h + 2 min; radio de 50 km) | Depende de la ubicación del cliente, que **no sale del teléfono** |

Consecuencias para el plan:

- **KAN-263 se simplifica**: ya no es «API que calcula los 3 más cercanos» sino «catálogo maestro sembrado + consulta
  versionada». No hace falta el proveedor de mapas en el ACL ni su circuit breaker (decisión D-M06: la app dibuja el mapa
  con `flutter_map` y OpenStreetMap, sin clave).
- **Privacidad**: la ubicación del cliente no viaja al backend para listar prestadores (Ley 1581, minimización). Solo
  viajará cuando el cliente **solicite** la asistencia (sección 6).
- **EC011/EC012** (p95 ≤ 150 ms, p99 ≤ 300 ms) aplican a `catalogoPrestadores`, que es una lectura de una colección
  pequeña sobre la réplica; con la respuesta `vigente` casi siempre viaja vacía.

## 2. Semilla

Archivo fuente: [`docs/hu-m06/prestadores-semilla.json`](hu-m06/prestadores-semilla.json) (12 prestadores ficticios:
6 en Bogotá, 2 en Medellín, 2 en Cali, 2 en Barranquilla). Nombres y coordenadas inventados; no son negocios reales.
Los 3 de Bogotá alrededor del Parque de la 93 son los del prototipo de Figma (M06-01).

```json
{
  "version": "2026-11-04.1",
  "prestadores": [
    { "id": "prs-bog-001", "nombre": "Clínica Norte", "tipo": "MEDICO", "ciudad": "Bogotá",
      "latitud": 4.6859, "longitud": -74.0524, "activo": true }
  ]
}
```

Qué hacer:

1. **Copiar** el archivo al servicio dueño (p. ej. `services/<servicio>/semilla/prestadores.json`), igual que
   `services/claims/semilla/`. La app tiene una prueba (`test/contract/prestadores_semilla_test.dart`) que compara su
   fake con el archivo de `docs/hu-m06/`; si el backend cambia la semilla, avisar para actualizar ese archivo.
2. **Sembrado idempotente**: upsert por `id`, nunca borra. Un job `sembrar-prestadores` en el perfil `semilla` del
   `docker-compose.yml` (como `sembrar-siniestros`) y el mismo comando en staging. Correrlo dos veces deja lo mismo.
3. **Dar de baja** un prestador es `activo: false`, no borrarlo (la app lo descarta al leer).
4. **Versión**: la cambia quien edita el catálogo (`AAAA-MM-DD.n`). Si los datos no cambian, la versión tampoco: es lo
   que permite que la app no vuelva a descargar.

Dueño sugerido: **`claims`** (ya es el dominio de siniestros y asistencias, ya tiene Mongo con lectura en la secundaria y
ya tiene carpeta `semilla/`). Si el equipo prefiere otro servicio, la app no cambia: solo ve el BFF.

Modelo sugerido (colección `prestadores`):

| Campo | Tipo | Nota |
|---|---|---|
| `_id` / `id` | string | `prs-<ciudad>-NNN`, estable |
| `nombre` | string | |
| `tipo` | enum `MEDICO` \| `MECANICO` | La app descarta tipos que no conoce, así que agregar uno no la rompe |
| `ciudad` | string | |
| `latitud`, `longitud` | number (WGS84) | Índice `2dsphere` opcional; la app no lo necesita |
| `activo` | bool | |

Y un documento de control con la `version` vigente del catálogo (o la versión dentro de cada documento y la máxima como
vigente; a criterio del backend).

## 3. Contrato (BFF, canal `app`)

Cambio **aditivo** en `contracts/graphql/schema.graphql`:

```graphql
enum TipoPrestador { MEDICO MECANICO }

type Prestador {
  id: ID!
  nombre: String!
  tipo: TipoPrestador!
  ciudad: String!
  latitud: Float!
  longitud: Float!
  activo: Boolean!
}

type CatalogoPrestadores {
  "Versión vigente del catálogo en el backend."
  version: String!
  "true si versionLocal ya es la vigente: entonces prestadores viene vacía."
  vigente: Boolean!
  prestadores: [Prestador!]!
}

extend type Query {
  "Catálogo maestro de prestadores para la asistencia en sitio (HU-M06). Requiere sesión de CLIENTE."
  catalogoPrestadores(versionLocal: String): CatalogoPrestadores!
}
```

Reglas:

- `versionLocal` nulo o distinto de la vigente → `vigente: false` y la lista completa (solo `activo: true` basta, pero
  incluir los inactivos tampoco rompe la app).
- `versionLocal` igual a la vigente → `vigente: true`, `prestadores: []`.
- Errores: los mismos de siempre (`SIN_SESION`, 503 del gateway…). Si falla, la app sigue con su copia.
- Sin datos personales en la respuesta ni en los logs.

## 4. Cómo lo usa la app (para entender la carga esperada)

1. Al abrir la pestaña Asistencia, si su copia tiene **menos de 7 días** desde la última revisión, **no llama** al backend.
2. Si venció, llama con `versionLocal`: casi siempre recibe `vigente: true` (respuesta mínima) y renueva la fecha.
3. Si no hay red o el backend falla, usa la copia vencida. Solo sin copia muestra un error con «Reintentar».
4. Con la ubicación del teléfono calcula los 3 más cercanos dentro de 50 km. Si no hay ninguno, la hoja dice «No hay
   prestadores disponibles cerca de ti».

Carga resultante: en el peor caso, **una consulta por cliente por semana**.

## 5. Criterios de aceptación del backend (KAN-263)

- [ ] Colección `prestadores` sembrada desde la semilla, con el job idempotente en local y staging.
- [ ] `catalogoPrestadores` en el contrato (versión del contrato subida y `CHANGELOG.md`) y expuesto por el BFF en `/graphql/app`.
- [ ] `versionLocal` vigente → `vigente: true` y lista vacía; distinta o nula → lista completa.
- [ ] Newman con los tres casos (sin versión, versión vigente, versión vieja) y sin sesión → `SIN_SESION`.
- [ ] k6 de EC011/EC012 sobre `catalogoPrestadores` (lectura en la secundaria).
- [ ] Avisar a la app la versión del contrato para regenerar `lib/core/contrato/` y cambiar el fake por el datasource
      GraphQL (`asistenciaRemoteDataSourceProvider` en `lib/features/assistance/presentation/providers.dart`).

## 6. Lo que viene después (KAN-265 y KAN-266): esto **no** es maestro

Solicitar y cancelar una asistencia es **transaccional**: va al backend en cada caso. Propuesta inicial, para refinar
cuando se tomen esas tareas:

```graphql
enum EstadoAsistencia { CONFIRMADA NO_CONFIRMADA CANCELADA }

input SolicitudAsistenciaInput {
  "Clave de idempotencia generada por la app; reenviar (M06-03b) usa la misma."
  idSolicitud: ID!
  prestadorId: ID!
  tipoAsistencia: TipoPrestador!
  descripcion: String
  latitud: Float!
  longitud: Float!
}

type Asistencia {
  id: ID!
  estado: EstadoAsistencia!
  prestador: Prestador!
  minutosEstimados: Int
}

extend type Mutation {
  solicitarAsistencia(input: SolicitudAsistenciaInput!): Asistencia!
  cancelarAsistencia(id: ID!): Asistencia!
}
```

- Aquí sí viaja la ubicación del cliente (es el lugar donde debe llegar el prestador): se guarda con la asistencia y
  nunca va a logs.
- `idSolicitud` repetido devuelve la misma asistencia (el reintento de M06-03b no crea dos).
- Mientras no haya prestadores reales, el backend puede simular el desenlace (CONFIRMADA / NO_CONFIRMADA).
