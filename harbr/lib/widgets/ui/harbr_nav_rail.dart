import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// A single navigation destination for [HarbrNavRail] and [HarbrAppShell].
class HarbrNavDestination {
  /// The icon displayed when the destination is not selected.
  final IconData icon;

  /// The icon displayed when the destination is selected.
  /// Falls back to [icon] if not provided.
  final IconData? selectedIcon;

  /// The label displayed alongside or below the icon.
  final String label;

  const HarbrNavDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
  });
}

/// A responsive navigation rail for tablet and desktop layouts.
///
/// Renders a vertical strip of destinations using Material 3's
/// [NavigationRail]. On compact screens (< 600dp) the caller should
/// hide this widget and show a bottom navigation bar instead — see
/// [HarbrAppShell] for automatic handling.
///
/// When [extended] is `true`, labels are shown next to every icon.
/// When `false`, only icons are displayed with tooltips.
class HarbrNavRail extends StatelessWidget {
  /// The currently selected destination index.
  final int selectedIndex;

  /// Called when the user taps a destination.
  final ValueChanged<int> onDestinationSelected;

  /// The list of navigation destinations to display.
  final List<HarbrNavDestination> destinations;

  /// Whether to display labels next to each icon (extended mode).
  final bool extended;

  /// Optional widget placed above the destinations (e.g. a FAB or logo).
  final Widget? leading;

  /// Optional widget placed below the destinations.
  final Widget? trailing;

  const HarbrNavRail({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.extended = false,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      backgroundColor: harbr.surface0,
      // Selection indicator
      indicatorColor: harbr.accentDim,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: HarbrTokens.borderRadiusPill,
      ),
      // Icon theming
      selectedIconTheme: IconThemeData(
        color: harbr.accent,
        size: HarbrTokens.iconLg,
      ),
      unselectedIconTheme: IconThemeData(
        color: harbr.onSurfaceDim,
        size: HarbrTokens.iconLg,
      ),
      // Label theming
      selectedLabelTextStyle: TextStyle(
        color: harbr.accent,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: harbr.onSurfaceDim,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      // Label visibility
      labelType: extended
          ? NavigationRailLabelType.none // extended mode shows inline labels
          : NavigationRailLabelType.none,
      // Use animation
      groupAlignment: -1.0, // align destinations to the top
      minWidth: 72.0,
      minExtendedWidth: 200.0,
      leading: leading,
      trailing: trailing != null
          ? Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: HarbrTokens.lg),
                  child: trailing,
                ),
              ),
            )
          : null,
      destinations: destinations.map((dest) {
        return NavigationRailDestination(
          icon: Icon(dest.icon),
          selectedIcon: Icon(dest.selectedIcon ?? dest.icon),
          label: Text(dest.label),
        );
      }).toList(),
    );
  }
}
