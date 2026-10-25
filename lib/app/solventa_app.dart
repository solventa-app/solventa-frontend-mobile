import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/solventa_ui.dart';
import '../core/l10n/l10n.dart';
import 'router.dart';

/// Raíz de la app: tema M3 de Solventa, idioma (es-CO / en) y rutas.
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
          label: l10n.localeChip,
          semanticLabel: l10n.localeChipSemantica,
          onTap: ref.read(localeProvider.notifier).alternar,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
