import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/harbr_nav_rail.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A bottom navigation bar with pill-shaped active indicator.
///
/// Replaces the standard Material [NavigationBar] in compact mode
/// with a Helmarr-inspired design: the active tab shows an accent-colored
/// pill containing the icon, while inactive tabs show dim icon + label.
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

    return Container(
      decoration: BoxDecoration(
        color: harbr.surface0,
        border: Border(
          top: BorderSide(color: harbr.border, width: 1),
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
    // Figma Root.tsx: ALL tabs show icon + label.
    // Active tab has accent-colored pill behind icon.
    // Inactive tab has transparent background.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: HarbrTokens.durationNormal,
          padding: const EdgeInsets.all(HarbrTokens.sm),
          decoration: BoxDecoration(
            color: isSelected ? harbr.accent : Colors.transparent,
            borderRadius: HarbrTokens.borderRadius12,
          ),
          child: _buildIcon(
            isSelected ? selectedIcon : icon,
            isSelected ? Colors.white : harbr.onSurfaceDim,
          ),
        ),
        const SizedBox(height: HarbrTokens.xs),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? harbr.onSurface : harbr.onSurfaceDim,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(IconData iconData, Color color) {
    Widget iconWidget = Icon(iconData, color: color, size: HarbrTokens.iconLg);

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
                color: harbr.danger,
                borderRadius: HarbrTokens.borderRadiusPill,
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                badgeCount! > 99 ? '99+' : '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
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
