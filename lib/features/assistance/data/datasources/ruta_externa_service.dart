import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/prestador.dart';

/// Abre la ruta hacia un prestador en la app de mapas del teléfono.
abstract interface class RutaExternaService {
  /// `false` si no se pudo abrir ninguna app ni el navegador.
  Future<bool> abrirRuta(Coordenada destino, {required String nombre});
}

/// Usa el intent `geo:` de Android: abre la app de mapas por defecto o, si hay
/// varias (Google Maps, Waze…), el selector del sistema. Si ninguna lo atiende,
/// abre la ruta de Google Maps en el navegador.
final class UrlLauncherRutaExternaService implements RutaExternaService {
  const UrlLauncherRutaExternaService();

  @override
  Future<bool> abrirRuta(Coordenada destino, {required String nombre}) async {
    for (final uri in urisRuta(destino, nombre: nombre)) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          return true;
        }
      } on Exception {
        // Sin app que atienda este esquema: se prueba el siguiente.
      }
    }
    return false;
  }
}

/// URIs en orden de preferencia (visible para pruebas).
List<Uri> urisRuta(Coordenada destino, {required String nombre}) {
  final punto = '${destino.latitud},${destino.longitud}';
  return [
    Uri.parse('geo:$punto?q=$punto(${Uri.encodeComponent(nombre)})'),
    Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': punto,
      'travelmode': 'driving',
    }),
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
