import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// Semantic surface elevation level.
///
/// Each level maps to a progressively lighter surface color from
/// [HarbrThemeData], giving a clear visual hierarchy without relying
/// on drop shadows.
enum SurfaceLevel {
  /// Page background — the darkest surface.
  canvas,

  /// Default card / container background.
  base,

  /// Elevated content (e.g., a selected card, nested surface).
  raised,

  /// Top-most layer (e.g., dialogs, popovers).
  overlay,
}

/// A composable container whose background color is driven by
/// [SurfaceLevel].
///
/// Replaces [HarbrCard] for new screens and supports tap/long-press
/// interaction via an [InkWell] ripple.
class HarbrSurface extends StatelessWidget {
  /// The surface elevation level that determines the background color.
  final SurfaceLevel level;

  /// Corner radius applied to clipping and optional border.
  final BorderRadius? borderRadius;

  /// Inner padding around [child].
  final EdgeInsets? padding;

  /// Outer margin around the surface.
  final EdgeInsets? margin;

  /// The widget rendered inside the surface.
  final Widget? child;

  /// Called when the surface is tapped.
  final VoidCallback? onTap;

  /// Called when the surface is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether to draw a 1px border using the theme's border color.
  final bool showBorder;

  const HarbrSurface({
    super.key,
    this.level = SurfaceLevel.base,
    this.borderRadius,
    this.padding,
    this.margin,
    this.child,
    this.onTap,
    this.onLongPress,
    this.showBorder = false,
  });

  BorderRadius get _borderRadius =>
      borderRadius ?? HarbrTokens.borderRadiusMd;

  EdgeInsets get _margin => margin ?? HarbrTokens.paddingCard;

  /// Resolves the background [Color] for the given [SurfaceLevel] using the
  /// current theme's [HarbrThemeData].
  Color _colorForLevel(HarbrThemeData harbr) {
    switch (level) {
      case SurfaceLevel.canvas:
        return harbr.canvas;
      case SurfaceLevel.base:
        return harbr.surface0;
      case SurfaceLevel.raised:
        return harbr.surface1;
      case SurfaceLevel.overlay:
        return harbr.surface2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final color = _colorForLevel(harbr);
    final effectiveBorderRadius = _borderRadius;

    Widget content = Material(
      color: color,
      borderRadius: effectiveBorderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: effectiveBorderRadius,
        splashColor: harbr.accent.withValues(alpha: HarbrTokens.opacitySplash),
        highlightColor:
            harbr.accent.withValues(alpha: HarbrTokens.opacityHover),
        mouseCursor: onTap != null || onLongPress != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );

    if (showBorder) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          border: Border.all(color: harbr.border),
        ),
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: content,
        ),
      );
    }

    return Padding(
      padding: _margin,
      child: content,
    );
  }
}
