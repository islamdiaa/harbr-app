import 'package:flutter/material.dart';

/// A colored circle containing an icon, used for status summaries and settings.
///
/// The circle uses [color] at 20% opacity as background, with the icon
/// rendered at full [color].
class HarbrIconCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  /// The size of the circle container. Defaults to 32.
  final double size;

  const HarbrIconCircle({
    super.key,
    required this.icon,
    required this.color,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: size * 0.5,
        ),
      ),
    );
  }
}
