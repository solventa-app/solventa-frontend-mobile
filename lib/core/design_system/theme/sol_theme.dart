import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/sol_colors.dart';
import '../tokens/sol_radius.dart';
import '../tokens/sol_sizes.dart';
import '../tokens/sol_typography.dart';
import 'sol_colors_extension.dart';

/// Tema Material 3 de Solventa. Solo tema claro.
abstract final class SolTheme {
  /// Esquema `fromSeed(#1E4680)` con los overrides exactos del Figma.
  static final ColorScheme colorScheme =
      ColorScheme.fromSeed(
        seedColor: SolColors.seed,
        brightness: Brightness.light,
      ).copyWith(
        primary: SolColors.primary,
        onPrimary: SolColors.onPrimary,
        primaryContainer: SolColors.primaryContainer,
        onPrimaryContainer: SolColors.onPrimaryContainer,
        secondary: SolColors.secondary,
        onSecondary: SolColors.onSecondary,
        secondaryContainer: SolColors.secondaryContainer,
        onSecondaryContainer: SolColors.onSecondaryContainer,
        surface: SolColors.surface,
        onSurface: SolColors.onSurface,
        onSurfaceVariant: SolColors.onSurfaceVariant,
        surfaceContainerLowest: SolColors.surface,
        surfaceContainerLow: SolColors.surface,
        surfaceContainer: SolColors.surfaceContainer,
        surfaceContainerHigh: SolColors.surfaceContainer,
        surfaceContainerHighest: SolColors.surfaceContainer,
        surfaceTint: Colors.transparent,
        outline: SolColors.outline,
        outlineVariant: SolColors.outline,
        error: SolColors.error,
        onError: SolColors.onError,
        errorContainer: SolColors.errorContainer,
        onErrorContainer: SolColors.error,
      );

  /// Escala M3 en Inter.
  static final TextTheme textTheme = TextTheme(
    headlineSmall: SolTypography.headlineSmall,
    titleLarge: SolTypography.wordmark,
    titleMedium: SolTypography.titleMedium,
    titleSmall: SolTypography.titleSmall,
    bodyLarge: SolTypography.bodyLarge,
    bodyMedium: SolTypography.bodyMedium,
    bodySmall: SolTypography.bodySmall,
    labelLarge: SolTypography.labelLarge,
    labelMedium: SolTypography.labelMedium,
    labelSmall: SolTypography.labelSmall,
  ).apply(bodyColor: SolColors.onSurface, displayColor: SolColors.onSurface);

  static ThemeData light() {
    final scheme = colorScheme;
    const solColors = SolventaColors.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      fontFamily: SolTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surfaceContainer,
      canvasColor: scheme.surfaceContainer,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      extensions: const [solColors],
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: SolSizes.divider,
        space: SolSizes.divider,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: SolSizes.topBarHeight,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: SolRadius.cardAll,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        modalBackgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: solColors.sheetHandle,
        dragHandleSize: const Size(40, 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(SolRadius.card),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: SolRadius.cardAll),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        circularTrackColor: scheme.outline,
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: scheme.onSurfaceVariant, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SolRadius.checkbox)),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionHandleColor: scheme.primary,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
    );
  }
}
