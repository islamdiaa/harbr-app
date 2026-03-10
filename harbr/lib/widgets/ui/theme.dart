import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:harbr/core.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

class HarbrTheme {
  /// Initialize the theme by setting the system navigation and system colours.
  void initialize() {
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  }

  /// Returns the active [ThemeData] by checking the theme database value.
  ThemeData activeTheme() {
    return isAMOLEDTheme ? _pureBlackTheme() : _midnightTheme();
  }

  static bool get isAMOLEDTheme => HarbrDatabase.THEME_AMOLED.read();
  static bool get useBorders => HarbrDatabase.THEME_AMOLED_BORDER.read();

  /// Midnight theme (Default)
  ThemeData _midnightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: HarbrColors.canvas,
        primary: HarbrColors.accent,
        secondary: HarbrColors.accent,
        error: HarbrColors.danger,
        onSurface: HarbrColors.onSurface,
        onPrimary: HarbrColors.canvas,
        surfaceContainerLowest: HarbrColors.canvas,
        surfaceContainerLow: HarbrColors.surface0,
        surfaceContainer: HarbrColors.surface1,
        surfaceContainerHigh: HarbrColors.surface2,
        surfaceContainerHighest: HarbrColors.surface3,
        outline: HarbrColors.border,
        outlineVariant: HarbrColors.borderHigh,
      ),
      scaffoldBackgroundColor: HarbrColors.canvas,
      canvasColor: HarbrColors.canvas,
      primaryColor: HarbrColors.surface1,
      cardColor: HarbrColors.surface1,
      dialogTheme: const DialogThemeData(
        backgroundColor: HarbrColors.deepSurface,
        shape: RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusLg,
        ),
      ),
      iconTheme: const IconThemeData(
        color: HarbrColors.onSurface,
        size: HarbrTokens.iconLg,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: HarbrColors.surface2,
          borderRadius: HarbrTokens.borderRadiusMd,
        ),
        textStyle: const TextStyle(
          color: HarbrColors.onSurfaceDim,
          fontSize: HarbrUI.FONT_SIZE_SUBHEADER,
        ),
        preferBelow: true,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: HarbrColors.surface0,
        foregroundColor: HarbrColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: HarbrColors.surface0,
      ),
      cardTheme: CardThemeData(
        color: HarbrColors.surface1,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusMd,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: HarbrColors.surface2,
        contentTextStyle: const TextStyle(color: HarbrColors.onSurface),
        shape: const RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: HarbrColors.surface2,
        labelStyle: const TextStyle(
          color: HarbrColors.onSurfaceDim,
          fontSize: 12,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusSm,
        ),
        side: BorderSide.none,
      ),
      dividerTheme: const DividerThemeData(
        color: HarbrColors.border,
        thickness: 1,
        space: 0,
      ),
      textTheme: _sharedTextTheme,
      textButtonTheme: _sharedTextButtonThemeData,
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(HarbrColors.accent),
          foregroundColor: WidgetStateProperty.all(HarbrColors.canvas),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: HarbrTokens.borderRadiusMd,
            ),
          ),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: const [HarbrThemeData.midnight],
    );
  }

  /// AMOLED/Pure black theme
  ThemeData _pureBlackTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: HarbrColors.amoledCanvas,
        primary: HarbrColors.accent,
        secondary: HarbrColors.accent,
        error: HarbrColors.danger,
        onSurface: HarbrColors.onSurface,
        onPrimary: HarbrColors.amoledCanvas,
        surfaceContainerLowest: HarbrColors.amoledCanvas,
        surfaceContainerLow: HarbrColors.amoledSurface0,
        surfaceContainer: HarbrColors.amoledSurface1,
        surfaceContainerHigh: HarbrColors.amoledSurface2,
        surfaceContainerHighest: HarbrColors.amoledSurface3,
        outline: HarbrColors.borderHigh,
        outlineVariant: HarbrColors.borderHigh,
      ),
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      primaryColor: Colors.black,
      cardColor: Colors.black,
      dialogTheme: DialogThemeData(
        backgroundColor: HarbrColors.amoledDeepSurface,
        shape: RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusLg,
          side: useBorders
              ? const BorderSide(color: HarbrColors.borderHigh)
              : BorderSide.none,
        ),
      ),
      iconTheme: const IconThemeData(
        color: HarbrColors.onSurface,
        size: HarbrTokens.iconLg,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: HarbrColors.amoledSurface2,
          borderRadius: HarbrTokens.borderRadiusMd,
          border: useBorders
              ? Border.all(color: HarbrColors.borderHigh)
              : null,
        ),
        textStyle: const TextStyle(
          color: HarbrColors.onSurfaceDim,
          fontSize: HarbrUI.FONT_SIZE_SUBHEADER,
        ),
        preferBelow: true,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: HarbrColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        color: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusMd,
          side: useBorders
              ? const BorderSide(color: HarbrColors.borderHigh)
              : BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: HarbrColors.amoledSurface2,
        contentTextStyle: const TextStyle(color: HarbrColors.onSurface),
        shape: const RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: HarbrColors.amoledSurface1,
        labelStyle: const TextStyle(
          color: HarbrColors.onSurfaceDim,
          fontSize: 12,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: HarbrTokens.borderRadiusSm,
        ),
        side: useBorders
            ? const BorderSide(color: HarbrColors.borderHigh)
            : BorderSide.none,
      ),
      dividerTheme: const DividerThemeData(
        color: HarbrColors.borderHigh,
        thickness: 1,
        space: 0,
      ),
      textTheme: _sharedTextTheme,
      textButtonTheme: _sharedTextButtonThemeData,
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(HarbrColors.accent),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: HarbrTokens.borderRadiusMd,
            ),
          ),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: const [HarbrThemeData.amoled],
    );
  }

  SystemUiOverlayStyle get overlayStyle {
    return SystemUiOverlayStyle(
      systemNavigationBarColor:
          isAMOLEDTheme ? Colors.black : HarbrColors.surface0,
      systemNavigationBarDividerColor:
          isAMOLEDTheme ? Colors.black : HarbrColors.surface0,
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
  }

  TextTheme get _sharedTextTheme {
    const style = TextStyle(color: HarbrColors.onSurface);
    return const TextTheme(
      displaySmall: style,
      displayMedium: style,
      displayLarge: style,
      headlineSmall: style,
      headlineMedium: style,
      headlineLarge: style,
      bodySmall: style,
      bodyMedium: style,
      bodyLarge: style,
      titleSmall: style,
      titleMedium: style,
      titleLarge: style,
      labelSmall: style,
      labelMedium: style,
      labelLarge: style,
    );
  }

  TextButtonThemeData get _sharedTextButtonThemeData {
    return TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(
          HarbrColors.accent.withValues(alpha: HarbrTokens.opacitySplash),
        ),
      ),
    );
  }
}
