/// Configuración del ambiente, fijada al compilar con
/// `--dart-define-from-file=config/<flavor>.json`.
///
/// Nada de lo que entra aquí es secreto: queda dentro del APK.
/// Ver docs/ci-cd.md, "Ambientes dev y prod".
abstract final class AppConfig {
  /// `dev` o `prod`. Sin `--dart-define-from-file` (p. ej. en
  /// `flutter test`) vale `dev`.
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  /// Backend al que habla la app: `mock` (fakes, sin red), `local`, `dev` o
  /// `prod` (docs/integracion-backend.md). Sin `--dart-define-from-file`
  /// vale `mock`: la app nunca apunta a un backend por accidente.
  static const String apiEnv = String.fromEnvironment(
    'API_ENV',
    defaultValue: 'mock',
  );

  /// URL del API Gateway del ambiente. Vacía hasta que exista el gateway
  /// desplegado; para el backend en tu máquina se usa
  /// `config/local.json` (`10.0.2.2` es tu máquina vista desde el
  /// emulador).
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// DSN de `solventa-mobile` en Sentry (`uniandes-xm`). Vacío = Sentry no
  /// envía nada (pruebas, mock, local).
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// Plantilla de teselas del mapa de M06-01 (`flutter_map`, decisión D-M06).
  /// Por defecto, OpenStreetMap; para cambiar de proveedor (MapTiler,
  /// Stadia…) basta con otra URL en `config/<flavor>.json`. No es secreta.
  static const String mapTileUrl = String.fromEnvironment(
    'MAP_TILE_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  static bool get isDev => flavor == 'dev';
  static bool get isProd => flavor == 'prod';
}
