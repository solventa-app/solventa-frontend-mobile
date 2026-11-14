import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/prestador.dart';

/// Abre la ruta hacia un prestador en la app de mapas del teléfono.
abstract interface class RutaExternaService {
  /// `false` si no se pudo abrir ninguna app ni el navegador.
  Future<bool> abrirRuta(Coordenada destino, {required String nombre});
}

/// «Cómo llegar» sin selector de apps (HU-M06, M13), en este orden:
/// 1. el enlace universal de Google Maps en una app que no sea el navegador
///    (`externalNonBrowserApplication`): abre Google Maps directo;
/// 2. el intent `geo:`, si no hay Google Maps (otra app de mapas, Waze…);
/// 3. el mismo enlace en el navegador predeterminado.
/// Si nada abre, devuelve `false` y la pantalla ofrece copiar la dirección.
/// El `AndroidManifest.xml` declara los `<queries>` de `https` y `geo`.
final class UrlLauncherRutaExternaService implements RutaExternaService {
  const UrlLauncherRutaExternaService();

  @override
  Future<bool> abrirRuta(Coordenada destino, {required String nombre}) async {
    for (final (uri, modo) in intentosRuta(destino, nombre: nombre)) {
      try {
        if (await launchUrl(uri, mode: modo)) return true;
      } on Exception {
        // Sin app que atienda este intento: se prueba el siguiente.
      }
    }
    return false;
  }
}

/// Intentos en orden de preferencia (visible para pruebas).
List<(Uri, LaunchMode)> intentosRuta(
  Coordenada destino, {
  required String nombre,
}) {
  final punto = '${destino.latitud},${destino.longitud}';
  final web = Uri.https('www.google.com', '/maps/dir/', {
    'api': '1',
    'destination': punto,
    'travelmode': 'driving',
  });
  return [
    (web, LaunchMode.externalNonBrowserApplication),
    (
      Uri.parse('geo:$punto?q=$punto(${Uri.encodeComponent(nombre)})'),
      LaunchMode.externalApplication,
    ),
    (web, LaunchMode.externalApplication),
  ];
}

/// Para pruebas: registra los destinos pedidos.
final class FakeRutaExternaService implements RutaExternaService {
  final List<Coordenada> abiertas = [];
  bool resultado = true;

  @override
  Future<bool> abrirRuta(Coordenada destino, {required String nombre}) async {
    abiertas.add(destino);
    return resultado;
  }
}
