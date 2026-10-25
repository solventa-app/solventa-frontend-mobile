import 'package:flutter/material.dart';

import '../core/design_system/solventa_ui.dart';
import '../features/assistance/presentation/assistance_placeholder_page.dart';
import '../features/home/presentation/home_page.dart';

/// Raíz de la app: tema M3 de Solventa, locale es-CO y shell de navegación.
class SolventaApp extends StatelessWidget {
  const SolventaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solventa',
      debugShowCheckedModeBanner: false,
      theme: SolTheme.light(),
      themeMode: ThemeMode.light,
      locale: SolLocalizations.locale,
      supportedLocales: SolLocalizations.supportedLocales,
      localizationsDelegates: SolLocalizations.delegates,
      home: const _RootShell(),
    );
  }
}

class _RootShell extends StatelessWidget {
  const _RootShell();

  @override
  Widget build(BuildContext context) {
    return SolAppShell(
      home: HomePage(
        userName: 'María',
        onCompleteRegistration: () {},
        onRequestAssistance: () {},
      ),
      assistance: const AssistancePlaceholderPage(),
      onLogout: () => SolConfirmDialog.show(
        context,
        title: '¿Quieres cerrar sesión?',
        message: 'Tendrás que ingresar de nuevo para usar Solventa.',
        confirmLabel: 'Sí, cerrar sesión',
        cancelLabel: 'No, seguir aquí',
      ),
    );
  }
}
