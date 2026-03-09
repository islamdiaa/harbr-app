import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/poster.dart';
import 'package:harbr/widgets/ui/surface.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A composable list-item row designed for media content.
///
/// Combines an optional [HarbrPoster], title/subtitle text, status
/// and metadata widgets, and an optional trailing widget inside a
/// themed [HarbrSurface]. Intended as the successor to [HarbrBlock]
/// for new screens.
class HarbrMediaRow extends StatelessWidget {
  /// Optional poster displayed at the leading edge of the row.
  final HarbrPoster? poster;

  /// Primary text — rendered bold and single-line with ellipsis overflow.
  final String title;

  /// Secondary text — rendered dimmed and single-line with ellipsis overflow.
  final String? subtitle;

  /// A widget (typically a status badge) shown below the subtitle.
  final Widget? status;

  /// A list of small informational widgets (e.g., meta chips) displayed
  /// in a wrapping row after the [status] widget.
  final List<Widget>? metadata;

  /// Widget placed at the trailing edge of the row (e.g., an icon or
  /// chevron).
  final Widget? trailing;

  /// Called when the row is tapped.
  final VoidCallback? onTap;

  /// Called when the row is long-pressed.
  final VoidCallback? onLongPress;

  /// When `true`, the row's content is rendered at reduced opacity to
  /// indicate a non-interactive or unavailable state.
  final bool disabled;

  const HarbrMediaRow({
    super.key,
    required this.title,
    this.poster,
    this.subtitle,
    this.status,
    this.metadata,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    Widget content = Row(
      children: [
        if (poster != null) poster!,
        if (poster != null) const SizedBox(width: HarbrTokens.sm),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: harbr.onSurface,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Subtitle
              if (subtitle != null) ...[
                const SizedBox(height: 2.0),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: harbr.onSurfaceDim,
                    fontSize: 13.0,
                  ),
                ),
              ],
              // Status + metadata chips
              if (status != null || (metadata?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 4.0),
                Wrap(
                  spacing: HarbrTokens.xs,
                  runSpacing: HarbrTokens.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (status != null) status!,
                    if (metadata != null) ...metadata!,
                  ],
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: HarbrTokens.sm),
          trailing!,
        ],
      ],
    );

    if (disabled) {
      content = Opacity(
        opacity: HarbrTokens.opacityDisabled,
        child: content,
      );
    }

    return HarbrSurface(
      level: SurfaceLevel.base,
      margin: HarbrTokens.paddingCard,
      padding: HarbrTokens.paddingMd,
      onTap: disabled ? null : onTap,
      onLongPress: disabled ? null : onLongPress,
      child: content,
    );
  }
}
