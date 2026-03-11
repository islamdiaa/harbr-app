import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/harbr_colors.dart';
import 'package:harbr/widgets/ui/harbr_nav_rail.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A bottom navigation bar with pill-shaped active indicator.
///
/// Replaces the standard Material [NavigationBar] in compact mode
/// with a Figma-aligned design: the active tab shows a translucent
/// purple pill with purple icon/label, while inactive tabs show dim
/// icon + label. Background uses backdrop blur for depth.
class HarbrPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<HarbrNavDestination> destinations;

  /// Optional badge counts keyed by destination index.
  final Map<int, int>? badgeCounts;

  const HarbrPillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.badgeCounts,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          decoration: const BoxDecoration(
            color: HarbrColors.navBarBg,
            border: Border(
              top: BorderSide(
                color: HarbrColors.navBarBorder,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HarbrTokens.sm,
                vertical: HarbrTokens.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(destinations.length, (index) {
                  final dest = destinations[index];
                  final isSelected = index == selectedIndex;
                  final badgeCount = badgeCounts?[index];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDestinationSelected(index),
                      behavior: HitTestBehavior.opaque,
                      child: _NavItem(
                        icon: dest.icon,
                        selectedIcon: dest.selectedIcon ?? dest.icon,
                        label: dest.label,
                        isSelected: isSelected,
                        badgeCount: badgeCount,
                        harbr: harbr,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final int? badgeCount;
  final HarbrThemeData harbr;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.harbr,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: HarbrTokens.durationNormal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: isSelected ? harbr.navActiveDim : Colors.transparent,
            borderRadius: HarbrTokens.borderRadius12,
          ),
          child: _buildIcon(
            isSelected ? selectedIcon : icon,
            isSelected ? harbr.navActive : harbr.onSurfaceDim,
          ),
        ),
        const SizedBox(height: HarbrTokens.xs),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? harbr.navActive : harbr.onSurfaceDim,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(IconData iconData, Color color) {
    Widget iconWidget = Icon(iconData, color: color, size: HarbrTokens.iconMd);

    if (badgeCount != null && badgeCount! > 0) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: harbr.accent, // orange badge
                borderRadius: HarbrTokens.borderRadiusPill,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                badgeCount! > 99 ? '99+' : '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return iconWidget;
  }
}
