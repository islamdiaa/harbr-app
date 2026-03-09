import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A responsive grid that calculates its cross-axis count from the available
/// width and a [minItemWidth].
///
/// Uses [LayoutBuilder] to determine the number of columns:
///   crossAxisCount = max(1, (availableWidth / minItemWidth).floor())
class HarbrResponsiveGrid extends StatelessWidget {
  /// The widgets to lay out in the grid.
  final List<Widget> children;

  /// The minimum width each grid item should occupy. The grid will use as many
  /// columns as fit without going below this width. Defaults to 300.
  final double minItemWidth;

  /// Spacing between grid items (both main-axis and cross-axis).
  /// Defaults to [HarbrTokens.sm].
  final double spacing;

  /// Optional padding around the entire grid.
  final EdgeInsets? padding;

  /// Whether the grid should shrink-wrap its content. Defaults to false.
  final bool shrinkWrap;

  /// Optional scroll controller.
  final ScrollController? controller;

  const HarbrResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 300,
    this.spacing = HarbrTokens.sm,
    this.padding,
    this.shrinkWrap = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = math.max(1, (width / minItemWidth).floor());

        return GridView.count(
          controller: controller,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: _childAspectRatio(width, crossAxisCount),
          shrinkWrap: shrinkWrap,
          padding: padding ?? EdgeInsets.all(spacing),
          children: children,
        );
      },
    );
  }

  /// Computes a reasonable aspect ratio so cards are not too tall.
  /// Each cell width is computed from the available width minus spacing,
  /// and the height is clamped to a comfortable card height.
  double _childAspectRatio(double availableWidth, int crossAxisCount) {
    final totalSpacing = spacing * (crossAxisCount - 1);
    final cellWidth =
        (availableWidth - totalSpacing - (spacing * 2)) / crossAxisCount;
    // Target card height of ~100 logical pixels.
    const targetHeight = 100.0;
    return cellWidth / targetHeight;
  }
}
