import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// A compact inline metadata chip showing an optional icon and a label.
///
/// Used for small metadata annotations such as runtime, codec, or year.
/// Renders without any background or border — just the icon and text inline.
class HarbrMetaChip extends StatelessWidget {
  final IconData? icon;
  final String label;

  /// Override the default color (which is [HarbrThemeData.onSurfaceDim]).
  final Color? color;

  const HarbrMetaChip({
    super.key,
    this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final effectiveColor = color ?? harbr.onSurfaceDim;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: effectiveColor),
          const SizedBox(width: 3),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: effectiveColor,
          ),
        ),
      ],
    );
  }
}
