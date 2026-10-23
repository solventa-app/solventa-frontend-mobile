# Solventa — App móvil

App Flutter (Android primero) de Solventa. El backend y el contrato viven en `solventa-backend`; la web en `solventa-frontend-web`.

## Flujo de ramas

| Origen | Destino | Uso |
|---|---|---|
| `feat\|fix\|chore/KAN-N-descripcion` | `develop` | Trabajo diario (squash o merge) |
| `develop` | `main` | Liberación |
| `fix/KAN-N-descripcion` | `main` | Corrección urgente |
| `main` | `develop` | Reintegración tras un fix directo |

Título del PR: `tipo(alcance): KAN-N descripción`, por ejemplo `feat(mobile): KAN-24 login biométrico`. Alcances: `mobile`, `contrato`, `docs`, `ci`.

`main` y `develop` están protegidas por ruleset (`.github/rulesets/`): PR obligatorio, 1 aprobación y checks `mobile`, `Título del PR` y `Nombre de rama` en verde.

## CI y CD

- **CI** (`ci.yml`): `dart format`, `flutter analyze` y `flutter test` en cada PR.
- **CD** (`cd.yml`): cada merge a `main` compila `solventa-<versión>-<build>.apk` y `.aab` firmados, los sube como artifact y crea un GitHub Release `v<versión>+<build>`. El `.aab` es el que se sube a Google Play.

### Secrets requeridos

`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`.

El firmado local usa `android/key.properties` si existe (ignorado por git); sin él, la llave debug.

## Desarrollo

```
flutter pub get
flutter run
flutter test
```
