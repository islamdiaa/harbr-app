import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A row of action buttons used for filtering and sorting.
///
/// Supports an optional leading pill-shaped button and trailing circle buttons.
class HarbrFilterActionBar extends StatelessWidget {
  /// An optional leading pill button (e.g. "Add Movie" or "Activity").
  final HarbrFilterAction? leadingAction;

  /// Trailing circle icon buttons (e.g. sort, filter, view toggle).
  final List<HarbrFilterAction> trailingActions;

  const HarbrFilterActionBar({
    super.key,
    this.leadingAction,
    this.trailingActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HarbrTokens.md,
        vertical: HarbrTokens.sm,
      ),
      child: Row(
        children: [
          if (leadingAction != null)
            _PillButton(action: leadingAction!, harbr: harbr),
          const Spacer(),
          ...trailingActions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: HarbrTokens.sm),
              child: _CircleButton(action: action, harbr: harbr),
            ),
          ),
        ],
      ),
    );
  }
}

/// Describes a single action in a [HarbrFilterActionBar].
class HarbrFilterAction {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;

  const HarbrFilterAction({
    required this.icon,
    this.label,
    this.onTap,
  });
}

class _PillButton extends StatelessWidget {
  final HarbrFilterAction action;
  final HarbrThemeData harbr;

  const _PillButton({required this.action, required this.harbr});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: harbr.surface0,
      borderRadius: HarbrTokens.borderRadiusPill,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HarbrTokens.xl,
            vertical: HarbrTokens.md,
          ),
          decoration: BoxDecoration(
            borderRadius: HarbrTokens.borderRadiusPill,
            border: Border.all(color: harbr.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(action.icon, color: harbr.onSurface, size: HarbrTokens.iconMd),
              if (action.label != null) ...[
                const SizedBox(width: HarbrTokens.sm),
                Text(
                  action.label!,
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final HarbrFilterAction action;
  final HarbrThemeData harbr;

  const _CircleButton({required this.action, required this.harbr});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: harbr.surface0,
      shape: CircleBorder(
        side: BorderSide(color: harbr.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(HarbrTokens.md),
          child: Icon(
            action.icon,
            color: harbr.onSurfaceDim,
            size: HarbrTokens.iconMd,
          ),
        ),
      ),
    );
  }
}
