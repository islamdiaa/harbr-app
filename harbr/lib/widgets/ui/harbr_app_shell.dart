import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/harbr_nav_rail.dart';

/// A responsive application shell that automatically adapts between a bottom
/// navigation bar (compact / phone) and a navigation rail (expanded / tablet
/// and desktop).
///
/// Layout rules:
///   - Width < 600dp  -> [Scaffold] with a Material 3 [NavigationBar] at the
///     bottom and [body] as the scaffold body.
///   - Width >= 600dp -> [Row] containing [HarbrNavRail], a [VerticalDivider],
///     and the [body] in an [Expanded] widget.
class HarbrAppShell extends StatelessWidget {
  /// The currently selected destination index.
  final int selectedIndex;

  /// Called when the user selects a destination.
  final ValueChanged<int> onDestinationSelected;

  /// The navigation destinations shared between the bottom bar and rail.
  final List<HarbrNavDestination> destinations;

  /// The primary content widget.
  final Widget body;

  /// Whether the navigation rail should show extended labels
  /// (only applies on widths >= 600dp).
  final bool extendedRail;

  /// Optional widget placed above destinations in the rail (e.g. a FAB).
  final Widget? railLeading;

  /// Optional widget placed below destinations in the rail.
  final Widget? railTrailing;

  const HarbrAppShell({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.extendedRail = false,
    this.railLeading,
    this.railTrailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < HarbrTokens.breakpointCompact) {
          return _buildCompact(context);
        }
        return _buildExpanded(context);
      },
    );
  }

  /// Compact layout: scaffold with a Material 3 NavigationBar at the bottom.
  Widget _buildCompact(BuildContext context) {
    final harbr = context.harbr;

    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: harbr.surface0,
        indicatorColor: harbr.accentDim,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        animationDuration: HarbrTokens.durationNormal,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: destinations.map((dest) {
          return NavigationDestination(
            icon: Icon(dest.icon, color: harbr.onSurfaceDim),
            selectedIcon: Icon(
              dest.selectedIcon ?? dest.icon,
              color: harbr.accent,
            ),
            label: dest.label,
          );
        }).toList(),
      ),
    );
  }

  /// Expanded layout: navigation rail on the left, divider, content area.
  Widget _buildExpanded(BuildContext context) {
    final harbr = context.harbr;

    return Scaffold(
      body: Row(
        children: [
          HarbrNavRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
            extended: extendedRail,
            leading: railLeading,
            trailing: railTrailing,
          ),
          VerticalDivider(
            thickness: 1.0,
            width: 1.0,
            color: harbr.border,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
