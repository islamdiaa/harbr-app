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
  final Color? color;

  /// The color of the background track. Defaults to [HarbrThemeData.surface2].
  final Color? backgroundColor;

  /// The height of the bar. Defaults to 4.0.
  final double height;

  const HarbrProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.backgroundColor,
    this.height = 4.0,
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
                  color: color ?? harbr.accent,
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
