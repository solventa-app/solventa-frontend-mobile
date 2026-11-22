import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/solventa_ui.dart';
import '../l10n/l10n.dart';
import '../network/network_providers.dart';
import 'conversor_montos.dart';

export 'conversor_montos.dart' show monedaOrigenMontos;

/// Con `API_ENV=mock` la tabla fija del ACL; si no, `convertirMontos` del BFF.
final conversorMontosProvider = Provider<ConversorMontos>(
  (ref) => ref.watch(usarFakesProvider)
      ? FakeConversorMontos()
      : GqlConversorMontos(ref.watch(graphqlClientProvider)),
);

final loteConversionProvider = Provider<LoteConversion>(
  (ref) => LoteConversion(ref.watch(conversorMontosProvider)),
);

/// Un monto en COP (`$1`) expresado en otra moneda (`$2`); `null` si el BFF no
/// pudo convertirlo.
final montoConvertidoProvider = FutureProvider.autoDispose
    .family<String?, (String, String)>(
      (ref, k) => ref.watch(loteConversionProvider).convertir(k.$1, k.$2),
    );

/// Texto decimal de un monto de la app, tal como lo pide `MontoInput`.
String _valorDecimal(num v) =>
    v is int || v == v.roundToDouble() ? v.round().toString() : v.toString();

extension MontoEnMonedaX on WidgetRef {
  /// [valorCop] con la moneda de la barra superior y el formato del idioma
  /// activo. Se vuelve a pintar solo al cambiar el idioma o la moneda.
  ///
  /// Mientras llega la conversión, o si falla, se muestra en COP: nunca un
  /// monto vacío ni uno mal convertido.
  String monto(BuildContext context, num valorCop) {
    final locale = Localizations.localeOf(context);
    final moneda = watch(monedaProvider);
    if (moneda != monedaOrigenMontos) {
      final convertido = watch(
        montoConvertidoProvider((_valorDecimal(valorCop), moneda)),
      ).value;
      if (convertido != null) {
        return SolFormat.currencyIn(convertido, moneda, locale);
      }
    }
    return SolFormat.currencyIn(valorCop, monedaOrigenMontos, locale);
  }
}

/// Nota bajo los montos cuando la moneda elegida no es COP: son valores de
/// referencia y lo que se paga sigue en pesos colombianos (como en la web).
class NotaMontosDeReferencia extends ConsumerWidget {
  const NotaMontosDeReferencia({
    super.key,
    this.center = false,
    this.padding = const EdgeInsets.only(top: SolSpacing.md),
  });

  final bool center;

  /// Espacio alrededor de la nota; en COP no ocupa nada.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moneda = ref.watch(monedaProvider);
    if (moneda == monedaOrigenMontos) return const SizedBox.shrink();
    return Padding(
      padding: padding,
      child: SolInlineNote(
        icon: SolIcons.info,
        text: context.l10n.montosDeReferencia(moneda),
        center: center,
      ),
    );
  }
}
