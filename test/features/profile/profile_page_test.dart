import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';
import 'package:solventa_mobile/core/l10n/l10n.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/onboarding.dart';
import 'package:solventa_mobile/features/onboarding/domain/entities/verificacion_identidad.dart';
import 'package:solventa_mobile/features/onboarding/presentation/onboarding_notifier.dart';
import 'package:solventa_mobile/features/profile/presentation/profile_page.dart';

class _EstadoFijo extends OnboardingNotifier {
  _EstadoFijo(this._estado);
  final OnboardingState _estado;

  @override
  OnboardingState build() => _estado;

  @override
  Future<void> cargarPerfilYEstado() async {}
}

/// T24: nombre, documento enmascarado y correo del perfil, solo lectura.
void main() {
  Future<void> abrir(WidgetTester tester, PerfilUsuario perfil) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final estado = OnboardingState(
      verificacion: EstadoVerificacion.verificada,
      perfil: perfil,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingProvider.overrideWith(() => _EstadoFijo(estado))],
        child: MaterialApp(
          theme: SolTheme.light(),
          locale: AppLocales.es,
          supportedLocales: AppLocales.supported,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...SolLocalizations.delegates,
          ],
          home: const ProfilePage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  const completo = PerfilUsuario(
    id: 'u-1',
    usuario: 'alias-opaco-7f3a',
    correo: 'maria@ejemplo.co',
    nombre: 'María Pérez',
    rol: 'CLIENTE',
    estado: 'ACTIVO',
    documentoEnmascarado: '10••••3040',
    creadoEn: '2026-10-28T15:00:00Z',
    idioma: 'ES',
    moneda: 'COP',
  );

  testWidgets('muestra nombre, documento enmascarado y correo del backend', (
    tester,
  ) async {
    await abrir(tester, completo);

    expect(find.text('María Pérez'), findsWidgets);
    expect(find.text('10••••3040'), findsOneWidget);
    expect(find.text('maria@ejemplo.co'), findsOneWidget);
    // El alias de acceso es opaco: nunca se muestra como si fuera el correo.
    expect(find.text('alias-opaco-7f3a'), findsNothing);
  });

  testWidgets('los datos están bloqueados: sin campos de texto y con candado', (
    tester,
  ) async {
    await abrir(tester, completo);

    expect(find.byType(TextField), findsNothing);
    expect(find.byType(EditableText), findsNothing);
    // Nombre, documento, correo y rol llevan candado.
    expect(find.byIcon(SolIcons.lock), findsAtLeastNWidgets(4));
  });

  testWidgets('el lector de pantalla anuncia el dato como solo lectura', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await abrir(tester, completo);

    expect(
      find.bySemanticsLabel('Correo, maria@ejemplo.co, Solo lectura'),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('sin correo ni documento se ve «—», no el alias', (tester) async {
    const sinDatos = PerfilUsuario(
      id: 'u-2',
      usuario: 'alias-opaco-9c1b',
      nombre: 'María Pérez',
      rol: 'CLIENTE',
      estado: 'ACTIVO',
      creadoEn: '2026-10-28T15:00:00Z',
      idioma: 'ES',
      moneda: 'COP',
    );

    await abrir(tester, sinDatos);

    expect(find.text('—'), findsNWidgets(2));
    expect(find.text('alias-opaco-9c1b'), findsNothing);
  });
}
