import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A card containing horizontal bar chart rows.
///
/// Each row shows a label, a horizontal bar with gradient fill, and a count.
/// Includes an optional "Show more" button at the bottom.
class HarbrBarChartCard extends StatefulWidget {
  final String title;
  final List<HarbrBarChartItem> items;

  /// Number of items to show before "Show more" is required. Defaults to 5.
  final int initialVisibleCount;

  /// Gradient colors for bar fills. Defaults to a purple gradient.
  final List<Color>? gradientColors;

  const HarbrBarChartCard({
    super.key,
    required this.title,
    required this.items,
    this.initialVisibleCount = 5,
    this.gradientColors,
  });

  @override
  State<HarbrBarChartCard> createState() => _HarbrBarChartCardState();
}

class _HarbrBarChartCardState extends State<HarbrBarChartCard> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final maxValue = widget.items.fold<double>(
      0,
      (max, item) => item.value > max ? item.value : max,
    );

    final visibleItems = _showAll
        ? widget.items
        : widget.items.take(widget.initialVisibleCount).toList();

    final colors = widget.gradientColors ??
        [harbr.accent, harbr.accent.withValues(alpha: 0.6)];

    return Container(
      margin: HarbrTokens.paddingCard,
      padding: HarbrTokens.paddingXl,
      decoration: BoxDecoration(
        color: harbr.surface0,
        borderRadius: HarbrTokens.borderRadius12,
        border: Border.all(color: harbr.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: HarbrTokens.md),
          ...visibleItems.map((item) => _buildRow(item, maxValue, harbr, colors)),
          if (widget.items.length > widget.initialVisibleCount && !_showAll) ...[
            const SizedBox(height: HarbrTokens.sm),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _showAll = true),
                child: Text(
                  'Show more',
                  style: TextStyle(
                    color: harbr.accent,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    HarbrBarChartItem item,
    double maxValue,
    HarbrThemeData harbr,
    List<Color> colors,
  ) {
    final fraction = maxValue > 0 ? item.value / maxValue : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: HarbrTokens.sm),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: harbr.onSurfaceDim,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: HarbrTokens.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: HarbrTokens.borderRadiusPill,
              child: SizedBox(
                height: 8,
                child: Stack(
                  children: [
                    Container(color: harbr.canvas),
                    FractionallySizedBox(
                      widthFactor: fraction.clamp(0.0, 1.0),
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
            ),
          ),
          const SizedBox(width: HarbrTokens.sm),
          SizedBox(
            width: 32,
            child: Text(
              item.value.toInt().toString(),
              textAlign: TextAlign.end,
              style: TextStyle(
                color: harbr.onSurfaceDim,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single data item for [HarbrBarChartCard].
class HarbrBarChartItem {
  final String label;
  final double value;

  const HarbrBarChartItem({required this.label, required this.value});
}
