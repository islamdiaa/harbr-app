import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// A Material 3 top tab bar for in-module navigation.
///
/// Replaces the bottom GNav within modules, sitting in the app bar area with
/// a transparent background and an accent underline indicator.
///
/// Automatically becomes scrollable when there are more than 4 tabs.
class HarbrTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// The labels displayed on each tab.
  final List<String> tabs;

  /// The controller that synchronizes tab selection with a [TabBarView].
  final TabController controller;

  /// Optional callback invoked when a tab is tapped.
  final ValueChanged<int>? onTap;

  const HarbrTabBar({
    Key? key,
    required this.tabs,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;
    final isScrollable = tabs.length > 4;

    return TabBar(
      controller: controller,
      isScrollable: isScrollable,
      onTap: onTap,
      // Indicator
      indicatorColor: harbr.accent,
      indicatorWeight: 2.0,
      indicatorSize: TabBarIndicatorSize.label,
      // Label styling
      labelColor: harbr.onSurface,
      labelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      // Unselected label styling
      unselectedLabelColor: harbr.onSurfaceDim,
      unselectedLabelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      // Feedback
      splashFactory: InkSparkle.splashFactory,
      overlayColor: WidgetStatePropertyAll(
        harbr.accent.withOpacity(HarbrTokens.opacitySplash),
      ),
      // No divider line beneath the tab bar
      dividerHeight: 0.0,
      // Padding for scrollable mode
      tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      padding: isScrollable
          ? const EdgeInsets.symmetric(horizontal: HarbrTokens.sm)
          : EdgeInsets.zero,
      tabs: tabs.map((label) => Tab(text: label)).toList(),
    );
  }
}
