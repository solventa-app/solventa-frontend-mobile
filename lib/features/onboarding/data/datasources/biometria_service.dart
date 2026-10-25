/// Estado de la biometría del teléfono (M01-08). La implementación real con
/// `local_auth` y la apertura de Ajustes llegan con HU-M02.
abstract interface class BiometriaService {
  Future<bool> disponible();
  Future<void> abrirAjustes();
}

/// Fake: el teléfono tiene huella o rostro activado.
final class FakeBiometriaService implements BiometriaService {
  FakeBiometriaService({this.activada = true});

  bool activada;

  @override
  Future<bool> disponible() async => activada;

  @override
  Future<void> abrirAjustes() async {}
}
