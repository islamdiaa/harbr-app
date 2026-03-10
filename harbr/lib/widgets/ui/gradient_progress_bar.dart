import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A progress bar with a gradient fill.
///
/// Similar to [HarbrProgressBar] but always uses a [LinearGradient] for the
/// filled portion rather than a flat color.
class HarbrGradientProgressBar extends StatelessWidget {
  /// The progress value, clamped between 0.0 and 1.0.
  final double progress;

  /// The gradient colors for the fill. Defaults to accent -> accent dim.
  final List<Color>? gradientColors;

  /// The height of the bar. Defaults to 6.0.
  final double height;

  /// The color of the background track. Defaults to [HarbrThemeData.canvas].
  final Color? trackColor;

  const HarbrGradientProgressBar({
    super.key,
    required this.progress,
    this.gradientColors,
    this.height = 6.0,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final colors = gradientColors ?? [harbr.accent, harbr.accent.withValues(alpha: 0.4)];

    return ClipRRect(
      borderRadius: HarbrTokens.borderRadiusPill,
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: trackColor ?? harbr.canvas),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
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
