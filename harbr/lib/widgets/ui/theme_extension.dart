import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';

/// Custom theme extension that provides Harbr-specific design tokens
/// accessible via `Theme.of(context).extension<HarbrThemeData>()`.
class HarbrThemeData extends ThemeExtension<HarbrThemeData> {
  // Surface layers
  final Color canvas;
  final Color surface0;
  final Color surface1;
  final Color surface2;
  final Color surface3;
  final Color deepSurface;

  // Accent
  final Color accent;
  final Color accentDim;

  // Navigation active (purple)
  final Color navActive;
  final Color navActiveDim;

  // Semantic
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  // Text
  final Color onSurface;
  final Color onSurfaceDim;
  final Color onSurfaceFaint;

  // Borders
  final Color border;
  final Color borderHigh;

  const HarbrThemeData({
    required this.canvas,
    required this.surface0,
    required this.surface1,
    required this.surface2,
    required this.surface3,
    required this.deepSurface,
    required this.accent,
    required this.accentDim,
    required this.navActive,
    required this.navActiveDim,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.onSurface,
    required this.onSurfaceDim,
    required this.onSurfaceFaint,
    required this.border,
    required this.borderHigh,
  });

  /// Midnight theme (default dark)
  static const midnight = HarbrThemeData(
    canvas: HarbrColors.canvas,
    surface0: HarbrColors.surface0,
    surface1: HarbrColors.surface1,
    surface2: HarbrColors.surface2,
    surface3: HarbrColors.surface3,
    deepSurface: HarbrColors.deepSurface,
    accent: HarbrColors.accent,
    accentDim: HarbrColors.accentDim,
    navActive: HarbrColors.navActive,
    navActiveDim: HarbrColors.navActiveDim,
    success: HarbrColors.success,
    warning: HarbrColors.warning,
    danger: HarbrColors.danger,
    info: HarbrColors.info,
    onSurface: HarbrColors.onSurface,
    onSurfaceDim: HarbrColors.onSurfaceDim,
    onSurfaceFaint: HarbrColors.onSurfaceFaint,
    border: HarbrColors.border,
    borderHigh: HarbrColors.borderHigh,
  );

  /// Pure black / AMOLED theme
  static const amoled = HarbrThemeData(
    canvas: HarbrColors.amoledCanvas,
    surface0: HarbrColors.amoledSurface0,
    surface1: HarbrColors.amoledSurface1,
    surface2: HarbrColors.amoledSurface2,
    surface3: HarbrColors.amoledSurface3,
    deepSurface: HarbrColors.amoledDeepSurface,
    accent: HarbrColors.accent,
    accentDim: HarbrColors.accentDim,
    navActive: HarbrColors.navActive,
    navActiveDim: HarbrColors.navActiveDim,
    success: HarbrColors.success,
    warning: HarbrColors.warning,
    danger: HarbrColors.danger,
    info: HarbrColors.info,
    onSurface: HarbrColors.onSurface,
    onSurfaceDim: HarbrColors.onSurfaceDim,
    onSurfaceFaint: HarbrColors.onSurfaceFaint,
    border: HarbrColors.borderHigh, // more visible on pure black
    borderHigh: HarbrColors.borderHigh,
  );

  @override
  HarbrThemeData copyWith({
    Color? canvas,
    Color? surface0,
    Color? surface1,
    Color? surface2,
    Color? surface3,
    Color? deepSurface,
    Color? accent,
    Color? accentDim,
    Color? navActive,
    Color? navActiveDim,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? onSurface,
    Color? onSurfaceDim,
    Color? onSurfaceFaint,
    Color? border,
    Color? borderHigh,
  }) {
    return HarbrThemeData(
      canvas: canvas ?? this.canvas,
      surface0: surface0 ?? this.surface0,
      surface1: surface1 ?? this.surface1,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      deepSurface: deepSurface ?? this.deepSurface,
      accent: accent ?? this.accent,
      accentDim: accentDim ?? this.accentDim,
      navActive: navActive ?? this.navActive,
      navActiveDim: navActiveDim ?? this.navActiveDim,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceDim: onSurfaceDim ?? this.onSurfaceDim,
      onSurfaceFaint: onSurfaceFaint ?? this.onSurfaceFaint,
      border: border ?? this.border,
      borderHigh: borderHigh ?? this.borderHigh,
    );
  }

  @override
  HarbrThemeData lerp(HarbrThemeData? other, double t) {
    if (other == null) return this;
    return HarbrThemeData(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface0: Color.lerp(surface0, other.surface0, t)!,
      surface1: Color.lerp(surface1, other.surface1, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      deepSurface: Color.lerp(deepSurface, other.deepSurface, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navActiveDim: Color.lerp(navActiveDim, other.navActiveDim, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceDim: Color.lerp(onSurfaceDim, other.onSurfaceDim, t)!,
      onSurfaceFaint: Color.lerp(onSurfaceFaint, other.onSurfaceFaint, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderHigh: Color.lerp(borderHigh, other.borderHigh, t)!,
    );
  }
}

/// Convenience extension on BuildContext to access Harbr theme tokens.
extension HarbrThemeContext on BuildContext {
  HarbrThemeData get harbr =>
      Theme.of(this).extension<HarbrThemeData>() ?? HarbrThemeData.midnight;
}
