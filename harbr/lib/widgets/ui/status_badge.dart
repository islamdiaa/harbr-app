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
}

/// A pill-shaped status indicator badge.
///
/// Displays a small colored dot followed by a label, with a tinted background
/// and border matching the status color. The label defaults to the status name
/// but can be overridden.
class HarbrStatusBadge extends StatelessWidget {
  final StatusType type;

  /// Override the default label derived from [type].
  final String? label;

  const HarbrStatusBadge({
    super.key,
    required this.type,
    this.label,
  });

  /// Default labels for each status type.
  static const Map<StatusType, String> _defaultLabels = {
    StatusType.downloaded: 'Downloaded',
    StatusType.missing: 'Missing',
    StatusType.queued: 'Queued',
    StatusType.monitored: 'Monitored',
    StatusType.unmonitored: 'Unmonitored',
    StatusType.importing: 'Importing',
    StatusType.error: 'Error',
    StatusType.continuing: 'Continuing',
  };

  Color _statusColor(HarbrThemeData harbr) {
    switch (type) {
      case StatusType.downloaded:
        return harbr.success;
      case StatusType.missing:
        return harbr.danger;
      case StatusType.queued:
        return harbr.warning;
      case StatusType.monitored:
        return harbr.accent;
      case StatusType.unmonitored:
        return harbr.onSurfaceFaint;
      case StatusType.importing:
        return harbr.info;
      case StatusType.error:
        return harbr.danger;
      case StatusType.continuing:
        return harbr.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final color = _statusColor(harbr);
    final displayLabel = label ?? _defaultLabels[type]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: HarbrTokens.borderRadiusPill,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            displayLabel,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
