import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/solventa_ui.dart';
import '../core/l10n/l10n.dart';
import '../features/profile/presentation/sol_preferencias_sheet.dart';
import 'router.dart';

/// Raíz de la app: tema M3 de Solventa, idioma (`es-CO` / `en`), moneda
/// (`COP`, `MXN`, `BRL`, `CLP`, `PEN`, `USD`, `EUR`) y rutas.
class SolventaApp extends ConsumerStatefulWidget {
  const SolventaApp({super.key});

  @override
  ConsumerState<SolventaApp> createState() => _SolventaAppState();
}

class _SolventaAppState extends ConsumerState<SolventaApp> {
  late final GoRouter _router = crearRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final moneda = ref.watch(monedaProvider);
    final codigoIdioma = locale.languageCode.toUpperCase();
    final etiquetaChip = '$codigoIdioma · $moneda';

    return MaterialApp.router(
      title: 'Solventa',
      debugShowCheckedModeBanner: false,
      theme: SolTheme.light(),
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...SolLocalizations.delegates,
      ],
      routerConfig: _router,
      builder: (context, child) {
        final l10n = context.l10n;
        return SolLocaleScope(
          label: etiquetaChip,
          semanticLabel: l10n.localeChipSemantica,
          onTap: () {
            ref.read(localeProvider.notifier).alternar();
            final navContext =
                _router.routerDelegate.navigatorKey.currentContext;
            if (navContext != null) {
              SolPreferenciasSheet.show(navContext);
            }
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
