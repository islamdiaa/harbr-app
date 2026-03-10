import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// The type of status a [HarbrStatusBadge] represents.
enum StatusType {
  downloaded,
  missing,
  queued,
  monitored,
  unmonitored,
  importing,
  error,
  continuing,
  upcoming,
}

/// A pill-shaped status indicator badge.
///
/// Displays an icon followed by a label, with a tinted background
/// and border matching the status color. The label defaults to the status name
/// but can be overridden.
class HarbrStatusBadge extends StatelessWidget {
  final StatusType type;

  /// Override the default label derived from [type].
  final String? label;

  /// Use medium size (larger padding/font) — matches Figma `size="md"`.
  final bool medium;

  const HarbrStatusBadge({
    super.key,
    required this.type,
    this.label,
    this.medium = false,
  });

  /// Default labels for each status type.
  static const Map<StatusType, String> _defaultLabels = {
    StatusType.downloaded: 'Complete',
    StatusType.missing: 'Missing',
    StatusType.queued: 'Queued',
    StatusType.monitored: 'Monitored',
    StatusType.unmonitored: 'Unmonitored',
    StatusType.importing: 'Importing',
    StatusType.error: 'Error',
    StatusType.continuing: 'Continuing',
    StatusType.upcoming: 'Upcoming',
  };

  /// Icons for each status type.
  static const Map<StatusType, IconData> _statusIcons = {
    StatusType.downloaded: Icons.check_circle_outline_rounded,
    StatusType.missing: Icons.error_outline_rounded,
    StatusType.queued: Icons.schedule_rounded,
    StatusType.monitored: Icons.visibility_rounded,
    StatusType.unmonitored: Icons.visibility_off_rounded,
    StatusType.importing: Icons.sync_rounded,
    StatusType.error: Icons.error_outline_rounded,
    StatusType.continuing: Icons.play_circle_outline_rounded,
    StatusType.upcoming: Icons.schedule_rounded,
  };

  Color _statusColor(HarbrThemeData harbr) {
    switch (type) {
      case StatusType.downloaded:
        return harbr.success;
      case StatusType.missing:
        return harbr.accent; // orange for missing (Figma)
      case StatusType.queued:
        return harbr.warning;
      case StatusType.monitored:
        return harbr.navActive; // purple
      case StatusType.unmonitored:
        return harbr.onSurfaceFaint;
      case StatusType.importing:
        return harbr.info;
      case StatusType.error:
        return harbr.danger;
      case StatusType.continuing:
        return harbr.navActive;
      case StatusType.upcoming:
        return harbr.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final color = _statusColor(harbr);
    final displayLabel = label ?? _defaultLabels[type]!;
    final statusIcon = _statusIcons[type]!;

    final hPad = medium ? 12.0 : 8.0;
    final vPad = medium ? 4.0 : 2.0;
    final fontSize = medium ? 13.0 : 11.0;
    final iconSize = medium ? 14.0 : 12.0;
    final gap = medium ? 6.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.20),
        borderRadius: HarbrTokens.borderRadiusPill,
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: color, size: iconSize),
          SizedBox(width: gap),
          Text(
            displayLabel,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
