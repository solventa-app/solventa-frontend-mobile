# HU-M04 · Siniestro paramétrico: cobertura e indemnización (avance preliminar)

Historia KAN-38. Tareas y subtareas de app: KAN-260 (M04-01 a M04-03), KAN-139 (M04-02), KAN-146 (M04-03) y KAN-280
(M04-04, creada el 2026-11-08 porque Mi cobertura no estaba en Jira). La push M04-01 (KAN-138) y FCM (KAN-259) no
entran en este avance.

Este primer PR (`feat/KAN-260-cobertura-mock`) construye **M04-02, M04-03 y M04-04 con datos mock**, sin navegación,
sin push y sin backend. La feature vive en `lib/features/parametric/`.

## Archivos

| Archivo | Qué es |
|---|---|
| [`plan.md`](plan.md) | Plan de implementación original del paquete de HU-M04 (2026-11-08) |
| `diseno/mockup-M04-04-cobertura.png` y `.html` | M04-04 sin saldo de prima. **No existe en Figma**: es un mockup propio y el `.html` trae medidas y colores |
| `diseno/mockup-M04-04-cobertura-saldo-favor.png` y `.html` | M04-04 con saldo a favor (bloque verde) |
| `diseno/mockup-M04-04-cobertura-saldo-contra.png` y `.html` | M04-04 con saldo en contra (bloque rojo) |
| `diseno/figma-M04-02-celebracion.png` | Captura del frame de Figma `2005:301` |
| `diseno/figma-M04-03-detalle-indemnizacion.png` | Captura del frame de Figma `2005:217` |

## Decisiones de este avance

| # | Decisión | Por qué |
|---|---|---|
| M04-D1 | La cuenta destino se guarda completa (16 dígitos) y se muestra como `•••• •••• •••• 4821`: solo los últimos 4 visibles, con la lectura «cuenta terminada en 4821» | Las cuentas y tarjetas siempre tienen más de 4 dígitos. Con solo 4 en el dato, `SolFormat.maskedAccount` no enmascara. Se usa `•` como en Figma (el mockup de M04-04 usaba `*`) |
| M04-D2 | **Sin navegación.** No hay `cobertura_routes.dart` ni cambios en `router.dart`, Home o `SolventaApp`. Las filas de la lista, «Ver detalle» y «Cerrar» llaman callbacks opcionales (`onTapMovimiento`, `onVerDetalle`, `onCerrar`, `onBack`) y las pruebas verifican que se llamen | El plan pedía pantallas sueltas para mostrar avance. Corrige dos contradicciones del plan: listaba `cobertura_routes.dart` y pedía pruebas que navegaran a M04-03 o hicieran *pop* |
| M04-D3 | El datasource es siempre el fake (también en `dev` y `prod`) | No hay contrato GraphQL de cobertura ni de indemnización paramétrica en el backend (`contracts/graphql/schema.graphql`, revisado el 2026-11-08) |
| M04-D4 | El saldo de prima no entra en «usado» ni en «disponible» | Es dinero de prima entre el cliente y Solventa, no cobertura (decisión del hilo del mockup) |
| M04-D5 | M04-03 sigue el frame de Figma, aunque Jira (KAN-146) pide más | Avance preliminar: lo que falta queda en la lista de pendientes |

## Pendientes

1. **M04-03 frente a los criterios de KAN-146.** Figma y este avance muestran el evento, el monto, las fechas y la
   cuenta. Faltan la **fuente del evento** (proveedor de clima o de vuelos), el **umbral superado**, el **desglose del
   cálculo** (tabla que se lee fila por fila y pasa a lista apilada) y la **referencia del siniestro para soporte**.
   Hace falta diseño y que el backend entregue esos datos.
2. **Moneda.** Los criterios de M04-02 piden el monto «en la moneda seleccionada en la barra superior». Hoy se muestra
   en COP con `SolFormat.currency`, igual que M05. Falta la conversión (tasa del BFF) para las 7 monedas.
3. **Navegación:** rutas `m04-02`, `m04-03` y `m04-04` en `router.dart`, conectar los callbacks (push → M04-02 → «Ver
   detalle» → M04-03; M04-04 desde Home o desde el perfil).
4. **Push M04-01** (banner, Figma `2005:286`) y FCM real con registro del dispositivo (KAN-138, KAN-259; falta
   `firebase_messaging`).
5. **Contrato y backend:** consulta de cobertura e indemnizaciones paramétricas; cuando exista, crear
   `GqlCoberturaRemoteDataSource` y elegirlo con `usarFakesProvider`.
6. **Total indemnizado:** decidir si suma todas las pólizas (así lo muestra el mockup: $ 950.000) o solo la vigente.
7. **Pruebas fuera de esta máquina.** Aquí solo se corren, en la imagen del devcontainer, el análisis, las pruebas
   unitarias y de widget y los goldens. Quedan pendientes:
   - `integration_test/cobertura_test.dart` en emuladores: workflow **Emuladores** en la rama (`gh workflow run
     emuladores.yml --ref feat/KAN-260-cobertura-mock`) y su artifact `reporte-emuladores.html`.
   - Revisión visual con Inter real (`SOL_PLATFORM_GOLDENS=1`) contra los PNG de `diseno/`.
   - Exploratoria en un teléfono real (texto al 200 %, TalkBack).
