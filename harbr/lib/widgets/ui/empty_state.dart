import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// A structured empty-state placeholder with an icon, title, optional subtitle,
/// and an optional action widget (e.g. a button).
///
/// Use this instead of plain centered text when a list or page has no content.
class HarbrEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  /// An optional action widget, such as a button, displayed below the text.
  final Widget? action;

  const HarbrEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return Center(
      child: Padding(
        padding: HarbrTokens.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: harbr.onSurfaceFaint,
            ),
            const SizedBox(height: HarbrTokens.lg),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: harbr.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: HarbrTokens.sm),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  color: harbr.onSurfaceDim,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: HarbrTokens.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
