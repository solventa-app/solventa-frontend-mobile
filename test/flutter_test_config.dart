import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solventa_mobile/core/design_system/solventa_ui.dart';

/// Configuración global de tests y goldens (alchemist).
///
/// - Goldens «ci» (siempre): texto en bloques (fuente Ahem) y sin sombras,
///   iguales en cualquier sistema operativo. Se versionan en
///   `test/goldens/ci/`.
/// - Goldens «platform» (legibles, con Inter real): solo locales, se activan
///   con `SOL_PLATFORM_GOLDENS=1` y quedan en `test/goldens/platform/`
///   (ignorados por git). Ver README del sistema de diseño.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Los tests de widget miden con Inter real, no con la fuente de pruebas.
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadInter();
  final platformGoldens = Platform.environment['SOL_PLATFORM_GOLDENS'] == '1';
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      theme: SolTheme.light(),
      goldenTestTheme: GoldenTestTheme(
        backgroundColor: SolColors.surfaceContainer,
        borderColor: SolColors.outline,
        nameTextStyle: SolTypography.note,
      ),
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: platformGoldens,
        filePathResolver: (fileName, _) => 'platform/$fileName.png',
      ),
      ciGoldensConfig: CiGoldensConfig(
        filePathResolver: (fileName, _) => 'ci/$fileName.png',
      ),
    ),
    run: testMain,
  );
}

Future<void> _loadInter() async {
  final loader = FontLoader(SolTypography.fontFamily);
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(rootBundle.load('assets/fonts/Inter/Inter-$weight.ttf'));
  }
  await loader.load();
}
