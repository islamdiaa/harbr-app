import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// A simple linear progress bar for queue items and download tracking.
///
/// Displays a rounded track with a filled portion sized by [progress] (0.0-1.0).
/// Colors default to the Harbr accent and surface2 but can be overridden.
class HarbrProgressBar extends StatelessWidget {
  /// The progress value, clamped between 0.0 and 1.0.
  final double progress;

  /// The color of the filled portion. Defaults to [HarbrThemeData.accent].
  /// Ignored when [gradientColors] is provided.
  final Color? color;

  /// The color of the background track. Defaults to [HarbrThemeData.surface2].
  final Color? backgroundColor;

  /// The height of the bar. Defaults to 6.0.
  final double height;

  /// Optional gradient colors for the filled portion. When provided, [color]
  /// is ignored and a horizontal linear gradient is used instead.
  final List<Color>? gradientColors;

  const HarbrProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.backgroundColor,
    this.height = 6.0,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return ClipRRect(
      borderRadius: HarbrTokens.borderRadiusPill,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            // Track
            Positioned.fill(
              child: ColoredBox(
                color: backgroundColor ?? harbr.surface2,
              ),
            ),
            // Fill
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: gradientColors == null ? (color ?? harbr.accent) : null,
                  gradient: gradientColors != null
                      ? LinearGradient(colors: gradientColors!)
                      : null,
                  borderRadius: HarbrTokens.borderRadiusPill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
