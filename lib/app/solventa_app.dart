import 'package:flutter/foundation.dart';
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
      // Galería interna: solo en debug (toque largo en el wordmark o
      // --dart-define=SOL_GALLERY=true).
      initialRoute: kDebugMode && _openGallery
          ? SolGalleryPage.routeName
          : Navigator.defaultRouteName,
      onGenerateRoute: (settings) {
        if (settings.name == Navigator.defaultRouteName) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const _RootShell(),
          );
        }
        return SolGalleryPage.route(settings);
      },
    );
  }
}

const bool _openGallery = bool.fromEnvironment('SOL_GALLERY');

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
      onWordmarkLongPress: kDebugMode
          ? () => Navigator.pushNamed(context, SolGalleryPage.routeName)
          : null,
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
