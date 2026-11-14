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

  /// Token **público** de Mapbox (`pk.…`) para el mapa de M06-01 (HU-M06,
  /// M0). No va en `config/<flavor>.json` ni en el repositorio: llega por
  /// `--dart-define=MAPBOX_ACCESS_TOKEN` desde el secreto
  /// `MAPBOX_PUBLIC_TOKEN` (CI) o desde la consola de cada desarrollador.
  /// Vacío = sin Mapbox: con `API_ENV=mock` se usa el mapa falso y, si no, la
  /// lista sin mapa (como cuando el mapa falla, CA-M06-04).
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
  );

  static bool get isDev => flavor == 'dev';
  static bool get isProd => flavor == 'prod';
}
