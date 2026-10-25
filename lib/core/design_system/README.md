# Sistema de diseño móvil de Solventa (KAN-239)

Base visual de la app Android de Solventa, construida sobre **Material 3** y
fiel al Figma `Solventa-movil-Final` (archivo `2ahgOpwsejNnxZl57v4o9D`):
guía de estilos `SG-01` (`2019:331`) y librería de componentes (`2018:2`).

Las features importan **solo** el barrel:

```dart
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
```

Reglas de producto que el sistema hace cumplir o facilita:

- Solo tema claro; nada de patrones iOS ni pestañas superiores.
- Un solo botón primario por pantalla.
- Pantallas intermedias con barra «Con volver»; entrada y transitorias sin flecha.
- Acción destructiva siempre con confirmación (`SolConfirmDialog`).
- Ningún estado solo por color: siempre ícono o texto.
- Áreas táctiles de 48 × 48 dp como mínimo.
- Material Symbols *outlined* como único set de íconos.
- Formato es-CO: `$ 450.000`, `12 sep 2026, 11:02 a. m.`, `****4821`.

---

## Estructura

```
lib/core/design_system/
  solventa_ui.dart      barrel (lo único que importan las features)
  tokens/               colores, tipografía, espaciado, radios, medidas, movimiento
  theme/                ThemeData M3, extensión SolventaColors, atajos de contexto
  icons/                catálogo SolIcons (Material Symbols outlined)
  l10n/                 SolFormat (es-CO) y SolLocalizations
  components/
    buttons/            SolButton, SolLinkButton
    navigation/         SolTopBar, SolBottomNav, SolLocaleChip
    lists/              SolProviderRow, SolActionTile, SolSectionHeader
    feedback/           SolStatusBadge/Banner, SolLoadingState, SolResultView,
                        SolInlineNote, SolDemoTrigger
    inputs/             SolTextField, SolConsentCheckbox
    surfaces/           SolCard, SolBottomSheet(+Panel), SolConfirmDialog(+Panel),
                        SolDivider, SolAvatar
    auth/               SolPinIndicator, SolNumericKeypad, SolCameraFrame
  layouts/              SolTopLevelScaffold, SolFlowScaffold, SolEntryScaffold,
                        SolTransitionalScreen, SolResultScreen, SolAppShell
  responsive/           SolBreakpoints, SolAdaptiveBody
  gallery/              SolGalleryPage (solo debug)
assets/fonts/Inter/     Inter 400/500/600/700 empaquetada (licencia SIL OFL 1.1)
```

---

## Tema y tokens

```dart
MaterialApp(
  theme: SolTheme.light(),
  locale: SolLocalizations.locale,                 // es_CO
  supportedLocales: SolLocalizations.supportedLocales,
  localizationsDelegates: SolLocalizations.delegates,
);
```

`SolTheme.light()` usa `ColorScheme.fromSeed(seedColor: Color(0xFF1E4680))` con
los overrides exactos del Figma:

| Rol | Valor | Uso |
|---|---|---|
| `primary` | `#1E4680` | Botón primario, destino activo, avatar |
| `secondary` | `#2B5AA3` | Wordmark, enlaces, botón «Texto» |
| `secondaryContainer` | `#EEEDF3` | Botón tonal, teclas del PIN |
| `primaryContainer` | `#EBF1FA` | Píldora de idioma y moneda |
| `surface` | `#FFFFFF` | Barras, tarjetas, hojas, campos |
| `surfaceContainer` | `#F5F5F5` | Fondo de pantalla |
| `outline` | `#D9D9D9` | Divisor 1 dp, bordes |
| `onSurface` | `#333333` | Títulos y cuerpo |
| `onSurfaceVariant` | `#6E6E6E` | Metadatos y notas |
| `error` / `errorContainer` | `#994D4D` / `#FDECEC` | Error y destructivo |

Lo que M3 no trae va en la extensión `SolventaColors` (`context.solColors`):
`success #2E7C56`, `successContainer #E8F6F1`, `warning #8D651E`,
`warningContainer #FDF1E4`, `navIndicator #D7E2FF`, `disabledContainer`,
`disabledContent`, `cameraViewport`, `sheetHandle`, `softShadow`.

Atajos en `BuildContext`:

```dart
context.colors      // ColorScheme
context.solColors   // SolventaColors
context.textStyles  // TextTheme
context.solText.title / .body / .note / .wordmark / .button / .labelStrong
```

Tipografía (Inter, sp): `headlineSmall` 24/600 · `titleLarge` (wordmark)
20/700 · `titleMedium` 16/600 · `titleSmall` 14/600 · `bodyMedium` 14/400 ·
`labelLarge` (botones) 16/600 · `labelMedium` 12/500 · `labelSmall` 11/600 ·
nota 11/400 (`context.solText.note`).

Medidas en `SolSpacing` (2, 4, 8, 12, 16, 20, 24, 32; margen de pantalla 16),
`SolRadius` (`full` 999, `card` 12, `field` 8, `checkbox` 4) y `SolSizes`
(barra superior 56, barra inferior 80, botón 48, táctil 48, avatar 32…).

Movimiento: `SolMotion.of(context, SolMotion.short)` devuelve `Duration.zero`
si el usuario activó «quitar animaciones».

---

## Íconos

```dart
Icon(SolIcons.home)              // outlined
Icon(SolIcons.home, fill: 1)     // relleno (destino activo, estados)
```

Usa siempre `SolIcons` (no `Icons` ni `Symbols` directo) para mantener un solo
set. Todo ícono sin texto al lado necesita `Semantics(label:)` o un `tooltip`.

## Formatos es-CO

```dart
SolFormat.currency(450000);                        // $ 450.000
SolFormat.dateTime(DateTime(2026, 9, 12, 11, 2));  // 12 sep 2026, 11:02 a. m.
SolFormat.maskedAccount('1234 5678 4821');         // ****4821
SolFormat.distanceKm(1.2);                         // 1,2 km
SolFormat.minutes(6);                              // 6 min
```

Entre `$` y la cifra, y dentro de «a. m.», se usa un espacio duro (U+00A0) para
que nunca se partan de línea; en pantalla se ve igual que el Figma.

---

## Componentes

### SolButton (Figma `2018:16`)
48 dp de alto, píldora completa, Inter 16/600. Ocupa todo el ancho salvo
`expand: false` (el de texto se ajusta al contenido por defecto).

```dart
SolButton.primary(label: 'Continuar', onPressed: onContinue);
SolButton.tonal(label: 'Reintentar', onPressed: retry);
SolButton.destructive(label: 'Sí, cancelar', onPressed: cancel);
SolButton.outlined(label: 'Repetir', icon: SolIcons.retry, onPressed: redo);
SolButton.text(label: 'Usar PIN en su lugar', onPressed: usePin);
SolButton.primary(label: 'Continuar', onPressed: null);          // deshabilitado
SolButton.primary(label: 'Enviar', loading: true, onPressed: send); // cargando
```

Deshabilitado = la condición aún no se cumple (p. ej. consentimiento sin
marcar). Un solo primario por pantalla.

### SolLinkButton
Enlace de acción alterna con 48 dp de área táctil.
```dart
SolLinkButton(label: 'Abrir Ajustes', onPressed: openSettings);
SolLinkButton(
  label: 'Olvidé mi PIN o patrón',
  note: '(se resuelve en Ajustes del teléfono)',
  size: SolLinkSize.small,
  onPressed: help,
);
```

### SolTopBar (Figma `2018:35`)
`PreferredSizeWidget` de 56 dp con divisor inferior.
```dart
appBar: SolTopBar.flow(title: 'Prueba de vida', onBack: ..., onProfileTap: ...)
appBar: SolTopBar.home(onLocaleTap: ...)
appBar: SolTopBar.flow(title: 'Verificación', showBack: false) // entrada/transitoria
```
Sin `onBack`, la flecha hace `Navigator.maybePop`.

### SolBottomNav (Figma `2018:76`)
3 destinos con ícono y etiqueta siempre visibles; solo en pantallas de nivel
superior. Normalmente lo usas a través de `SolAppShell`.
```dart
SolBottomNav(selectedIndex: i, onDestinationSelected: (i) => ...)
```

### SolLocaleChip (Figma `2018:3`)
Píldora «ES · COP». Ya viene dentro de `SolTopBar`.

### SolProviderRow (Figma `2018:103`)
```dart
SolProviderRow(
  name: 'Clínica Norte',
  type: SolProviderType.medico,   // o .mecanico
  distance: '1.2 km',
  eta: '6 min',
  onRequest: () => request(provider),
);
```
Con texto ≥ 150 % el botón «Solicitar» baja a su propia línea.

### SolDemoTrigger (Figma `2018:17`)
Andamiaje de demo en color de anotación. **Solo se ve en debug**
(`kDebugMode`); en release no ocupa espacio.
```dart
SolDemoTrigger(label: 'Simular que no reconoce la biometría', onTap: ...)
```

### SolStatusBadge / SolStatusBanner
Estados `success`, `warning`, `error`, `info`, siempre con ícono + texto.
```dart
SolStatusBadge(status: SolStatus.success, label: 'Identidad verificada');
SolStatusBanner(
  status: SolStatus.error,
  title: 'Sin permiso de cámara',
  message: 'Actívalo para capturar tu documento.',
  action: SolLinkButton(label: 'Abrir Ajustes', onPressed: open),
);
```
El banner se anuncia a TalkBack al aparecer (`liveRegion`).

### SolConsentCheckbox
Toda la fila es táctil (≥ 48 dp) y se anuncia como casilla.
```dart
SolConsentCheckbox(
  value: accepted,
  onChanged: (v) => setState(() => accepted = v),
  label: 'Autorizo el tratamiento de mis datos personales',
);
```

### SolPinIndicator + SolNumericKeypad
```dart
SolPinIndicator(filled: pin.length);           // 4 puntos por defecto
SolNumericKeypad(onDigit: addDigit, onBackspace: removeDigit);
```

### SolCard y SolActionTile
```dart
SolCard(child: ...);                  // borde outline (guía SG-01)
SolCard.elevated(child: ...);         // sombra suave (G-03, M01-07, M06-02)
SolCard(onTap: ..., semanticLabel: '...', child: ...);
SolActionTile(icon: SolIcons.assistanceActive,
              title: 'Solicitar asistencia en sitio', onTap: ...);
```

### SolTextField
Etiqueta dentro del campo, borde 1 dp (2 dp con foco o error), radio 8 dp.
```dart
SolTextField(label: 'Correo', helperText: '...', onChanged: ...);
SolTextField(label: 'Cédula', errorText: 'La cédula debe tener entre 6 y 10 dígitos.');
SolTextField(label: 'Describe qué pasó', hint: 'Ej. dolor en el pecho...', maxLines: 5);
SolTextField.select(label: 'Tipo de asistencia', value: 'Médica', onTap: pick);
```

### SolBottomSheet y SolConfirmDialog
```dart
SolBottomSheet.show(context, builder: (_) => ...);   // modal
SolBottomSheetPanel(child: ...);                     // fija (M06-01)

final ok = await SolConfirmDialog.show(
  context,
  title: '¿Seguro que quieres cancelar?',
  message: 'Clínica Norte ya está en camino...',
  confirmLabel: 'Sí, cancelar',
  cancelLabel: 'No, mantener solicitud',
);
if (ok) cancelRequest();
```
`SolConfirmPanel` es el mismo contenido para mostrarlo dentro de una pantalla.

### SolLoadingState y SolResultView
```dart
SolLoadingState(message: 'Validando con el proveedor KYC/AML...');
SolResultView(status: SolStatus.success,
              message: '¡Identidad verificada! Bienvenido a Solventa.');
```
Ambos se anuncian a TalkBack. Con «quitar animaciones» el indicador queda fijo.

### SolCameraFrame
```dart
SolCameraFrame(
  label: 'Cédula de ciudadanía',
  labelIcon: SolIcons.idCard,
  instruction: 'Ubica el FRENTE del documento dentro del marco',
  preview: CameraPreview(controller),        // opcional
);
SolCameraFrame(shape: SolCameraFrameShape.face, instruction: '...');
```

### Varios
`SolDivider()`, `SolAvatar(onTap: ...)`, `SolSectionHeader(title: ..., count:
'3 disponibles')`, `SolInlineNote(icon: ..., text: ..., center: true)`.

---

## Layouts

| Layout | Cuándo | Barra |
|---|---|---|
| `SolAppShell` | Navegación de nivel superior | «Inicio» + barra inferior |
| `SolTopLevelScaffold` | Pantalla de nivel superior suelta | «Inicio» + barra inferior |
| `SolFlowScaffold` | Toda pantalla intermedia | «Con volver» |
| `SolEntryScaffold` | Bienvenida, prompt biométrico | Sin flecha |
| `SolTransitionalScreen` | Verificando, enviando | Sin flecha, atrás bloqueado |
| `SolResultScreen` | Éxito / en revisión / error | «Con volver» |

```dart
SolFlowScaffold(
  title: 'Autorización de datos',
  onBack: () => context.pop(),          // flecha y atrás del sistema (PopScope)
  anchorActions: false,                 // CTA al final del contenido (M01-02)
  body: Column(children: [...]),
  actions: [SolButton.primary(label: 'Continuar', onPressed: ...)],
);

SolResultScreen(
  title: 'Verificación',
  status: SolStatus.warning,
  message: 'Estamos revisando tu identidad, te avisamos.',
  actionLabel: 'Entendido',
  onAction: goHome,
);

SolAppShell(
  home: const HomePage(...),
  assistance: const AssistancePage(),
  onLogout: confirmLogout,
);
```

`anchorActions: true` (por defecto) deja el CTA fijo abajo, sobre el teclado y
la barra de gestos. Todo el contenido hace scroll; nada queda debajo de la
barra inferior.

## Responsive y accesibilidad

- Base 390 dp, válido desde 360 dp. Desde 600 dp (`context.isExpandedWindow`)
  el contenido se centra con ancho máximo de 600 dp (`SolAdaptiveBody`); la
  barra inferior se mantiene.
- Texto hasta 200 % sin desbordes: los componentes crecen en alto, el botón de
  la fila de prestador baja de línea, las etiquetas de la barra inferior usan
  2 líneas y los títulos de la barra superior se recortan con «…» (TalkBack lee
  el título completo).
- Edge-to-edge (Android 15): `main.dart` activa `SystemUiMode.edgeToEdge`; las
  barras aplican `SafeArea`.
- `Semantics` en íconos sin texto, encabezados marcados como `header`, carga y
  resultados con `liveRegion`.

---

## Galería interna (solo debug)

- Toque largo en el wordmark «Solventa» de Home, o
- `flutter run --dart-define=SOL_GALLERY=true`.

La ruta `/galeria` no existe en builds de release.

## Tests y goldens

```bash
flutter test                         # todo (incluye goldens CI)
flutter test --exclude-tags golden   # sin goldens
```

- **Goldens CI** (`test/goldens/ci/`, versionados): alchemist pinta el texto
  como bloques (fuente Ahem) y sin sombras, así que dan igual en macOS, Linux o
  Windows. Son los que corren en CI.
- **Goldens legibles** (`test/goldens/platform/`, ignorados por git): usan Inter
  real y sirven para revisión visual. Solo se generan a pedido.

Cada componente y layout tiene goldens a **360 y 390 dp**, con texto al
**100 % y 200 %**: `<nombre>_<ancho>_x<escala>.png`.

Regenerar después de un cambio visual intencional:

```bash
flutter test --update-goldens --tags golden                        # CI
SOL_PLATFORM_GOLDENS=1 flutter test --update-goldens --tags golden # + legibles
```

Exportar PNG de 390 dp para revisión del diseñador UX:

```bash
tool/export_review_pngs.sh ../review
```

Además hay tests de widget por componente (estados, semántica, 48 dp), un test
de contraste AA de los pares de color del tema y tests de layouts
(atrás del sistema, CTA anclado, responsive, texto al 200 %).
