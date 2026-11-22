import 'dart:async';

import '../contrato/schema.graphql.dart';
import '../network/graphql_client.dart';
import 'graphql/convertir_montos.graphql.dart';

/// Moneda en que el backend entrega los montos que ve el cliente (primas,
/// topes e indemnizaciones). Lo cobrado y lo indemnizado siempre queda en ella.
const monedaOrigenMontos = 'COP';

/// Cuántos montos acepta `convertirMontos` en una sola llamada.
const maximoMontosPorLlamada = 50;

/// Pasa montos en COP a la moneda elegida en la barra superior (KAN-209).
///
/// Solo para mostrar: la app no hace aritmética con dinero, la conversión la
/// hace el BFF con `Decimal` y las tasas del ACL Worker, igual que en la web.
abstract interface class ConversorMontos {
  /// Los [valores] (decimales como texto, en COP) expresados en [moneda], en
  /// el mismo orden. Lanza si el BFF no responde o rechaza la conversión.
  Future<List<String>> convertir(List<String> valores, String moneda);
}

/// `convertirMontos` del BFF.
final class GqlConversorMontos implements ConversorMontos {
  const GqlConversorMontos(this._cliente);

  final GraphqlClient _cliente;

  @override
  Future<List<String>> convertir(List<String> valores, String moneda) async {
    final data = await _cliente.ejecutar(
      documentNodeQueryConvertirMontos,
      variables: Variables$Query$ConvertirMontos(
        montos: [
          for (final v in valores)
            Input$MontoInput(valor: v, moneda: monedaOrigenMontos),
        ],
        moneda: moneda,
      ).toJson(),
    );
    final montos = Query$ConvertirMontos.fromJson(data).convertirMontos;
    if (montos.length != valores.length) {
      throw StateError('convertirMontos devolvió otra cantidad de montos');
    }
    return [for (final m in montos) m.valor];
  }
}

/// Con `API_ENV=mock`: la misma tabla de referencia fija del ACL Worker
/// (`services/acl-worker/app/tasas_cambio.json`, COP por unidad) y los
/// decimales ISO 4217 del BFF (`services/bff/app/monedas.py`).
final class FakeConversorMontos implements ConversorMontos {
  FakeConversorMontos({this.latencia = Duration.zero, this.fallar = false});

  final Duration latencia;
  bool fallar;

  static const copPorUnidad = <String, num>{
    'COP': 1,
    'USD': 4100,
    'EUR': 4450,
    'MXN': 225,
    'BRL': 760,
    'CLP': 4.35,
    'PEN': 1090,
  };

  static const _decimales = <String, int>{'CLP': 0};

  @override
  Future<List<String>> convertir(List<String> valores, String moneda) async {
    if (latencia > Duration.zero) await Future<void>.delayed(latencia);
    final tasa = copPorUnidad[moneda];
    if (fallar || tasa == null) throw StateError('Moneda no soportada');
    final decimales = _decimales[moneda] ?? 2;
    return [
      for (final v in valores) (num.parse(v) / tasa).toStringAsFixed(decimales),
    ];
  }
}

/// Junta en una sola llamada los montos que piden los widgets de un mismo
/// cuadro y recuerda el resultado: al volver a una moneda ya usada el cambio
/// es inmediato. Un fallo no se recuerda, para reintentar en la próxima
/// pantalla.
class LoteConversion {
  LoteConversion(this._conversor);

  final ConversorMontos _conversor;
  final Map<(String, String), Future<String?>> _cache = {};
  final Map<String, Map<String, Completer<String?>>> _pendientes = {};
  bool _programado = false;

  /// [valor] (en COP) en [moneda], o `null` si no se pudo convertir.
  Future<String?> convertir(String valor, String moneda) {
    if (moneda == monedaOrigenMontos) return Future.value(valor);
    return _cache.putIfAbsent((valor, moneda), () {
      final completer = Completer<String?>();
      (_pendientes[moneda] ??= {})[valor] = completer;
      _programar();
      return completer.future;
    });
  }

  void _programar() {
    if (_programado) return;
    _programado = true;
    // Una microtarea corre al terminar el código síncrono en curso: todo el
    // cuadro ya se construyó y pidió sus montos.
    scheduleMicrotask(() => unawaited(_enviar()));
  }

  Future<void> _enviar() async {
    _programado = false;
    final lote = Map.of(_pendientes);
    _pendientes.clear();
    for (final MapEntry(key: moneda, value: porValor) in lote.entries) {
      final valores = porValor.keys.toList();
      for (var i = 0; i < valores.length; i += maximoMontosPorLlamada) {
        final tramo = valores.sublist(
          i,
          (i + maximoMontosPorLlamada).clamp(0, valores.length),
        );
        try {
          final convertidos = await _conversor.convertir(tramo, moneda);
          for (var j = 0; j < tramo.length; j++) {
            porValor[tramo[j]]!.complete(convertidos[j]);
          }
        } catch (_) {
          for (final v in tramo) {
            _cache.remove((v, moneda))?.ignore();
            porValor[v]!.complete(null);
          }
        }
      }
    }
  }
}
