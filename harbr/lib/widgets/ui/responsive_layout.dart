import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// Picks the correct body widget based on the available width.
///
/// - [compactBody]  is used when width < [HarbrTokens.breakpointCompact] (600dp).
/// - [mediumBody]   is used when width is 600-839dp (falls back to [compactBody]).
/// - [expandedBody] is used when width >= [HarbrTokens.breakpointMedium] (840dp)
///   (falls back to [mediumBody], then [compactBody]).
class HarbrResponsiveLayout extends StatelessWidget {
  /// Widget displayed when the available width is below 600dp.
  final Widget compactBody;

  /// Widget displayed when the available width is 600-839dp.
  /// Falls back to [compactBody] when null.
  final Widget? mediumBody;

  /// Widget displayed when the available width is 840dp or wider.
  /// Falls back to [mediumBody] (then [compactBody]) when null.
  final Widget? expandedBody;

  const HarbrResponsiveLayout({
    super.key,
    required this.compactBody,
    this.mediumBody,
    this.expandedBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= HarbrTokens.breakpointMedium) {
          return expandedBody ?? mediumBody ?? compactBody;
        }
        if (width >= HarbrTokens.breakpointCompact) {
          return mediumBody ?? compactBody;
        }
        return compactBody;
      },
    );
  }
}
