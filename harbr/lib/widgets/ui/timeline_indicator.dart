import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:intl/intl.dart';

/// A vertical timeline indicator with date labels.
///
/// Displays a vertical accent-colored line on the left with a date label
/// (day-of-week, month + day, year), and renders [child] to the right.
/// "Today" dates receive a highlight marker.
class HarbrTimelineIndicator extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final Widget child;

  static final _dowFormat = DateFormat('E'); // Mon, Tue, ...
  static final _monthDayFormat = DateFormat('MMM d'); // Dec 15
  static final _yearFormat = DateFormat('yyyy');

  const HarbrTimelineIndicator({
    super.key,
    required this.date,
    required this.child,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final accentColor = isToday ? harbr.accent : harbr.onSurfaceDim;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date label column + timeline line
          SizedBox(
            width: 56,
            child: Column(
              children: [
                // Date label block
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HarbrTokens.xs,
                    vertical: HarbrTokens.sm,
                  ),
                  decoration: isToday
                      ? BoxDecoration(
                          color: harbr.accent.withValues(alpha: 0.2),
                          borderRadius: HarbrTokens.borderRadiusSm,
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Day of week
                      Text(
                        _dowFormat.format(date),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Month + day
                      Text(
                        _monthDayFormat.format(date),
                        style: TextStyle(
                          color: isToday ? harbr.accent : harbr.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      // Year
                      Text(
                        _yearFormat.format(date),
                        style: TextStyle(
                          color: harbr.onSurfaceFaint,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: HarbrTokens.xs),
                // Vertical timeline line
                Expanded(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      color: harbr.accent.withValues(alpha: 0.3),
                      borderRadius: HarbrTokens.borderRadiusPill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: HarbrTokens.sm),
          // Content area
          Expanded(child: child),
        ],
      ),
    );
  }
}
