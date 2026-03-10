import 'package:flutter/material.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/database/tables/dashboard.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/widgets/ui/harbr_nav_rail.dart';
import 'package:harbr/widgets/ui/pill_nav_bar.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/pages/home.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/pages/library.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/pages/calendar.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/pages/modules.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/pages/activities.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/switch_view_action.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

class DashboardRoute extends StatefulWidget {
  const DashboardRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardRoute> createState() => _State();
}

class _State extends State<DashboardRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  static const _destinations = [
    HarbrNavDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    HarbrNavDestination(
      icon: Icons.video_library_outlined,
      selectedIcon: Icons.video_library_rounded,
      label: 'Library',
    ),
    HarbrNavDestination(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today_rounded,
      label: 'Calendar',
    ),
    HarbrNavDestination(
      icon: Icons.download_outlined,
      selectedIcon: Icons.download_rounded,
      label: 'Activities',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final saved = DashboardDatabase.NAVIGATION_INDEX.read();
    _selectedIndex = saved.clamp(0, 3);
  }

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    DashboardDatabase.NAVIGATION_INDEX.update(index);
  }

  @override
  Widget build(BuildContext context) {
    return HarbrDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final isCompact =
              constraints.maxWidth < HarbrTokens.breakpointCompact;
          return isCompact
              ? _buildCompact(context)
              : _buildExpanded(context);
        },
      ),
    );
  }

  /// Compact layout: single Scaffold with drawer, app bar at the top,
  /// pill nav bar at the bottom, and indexed pages in the body.
  Widget _buildCompact(BuildContext context) {
    final profileKey = ValueKey(HarbrDatabase.ENABLED_PROFILE.read());

    return Scaffold(
      key: _scaffoldKey,
      drawer: HarbrDrawer(page: HarbrModule.DASHBOARD.key),
      appBar: _appBar(),
      bottomNavigationBar: HarbrPillNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(key: profileKey),
          LibraryPage(key: profileKey),
          CalendarPage(key: profileKey),
          const ActivitiesPage(),
        ],
      ),
    );
  }

  /// Expanded layout: Scaffold with drawer, app bar, nav rail on the left,
  /// and indexed pages on the right.
  Widget _buildExpanded(BuildContext context) {
    final harbr = context.harbr;
    final profileKey = ValueKey(HarbrDatabase.ENABLED_PROFILE.read());

    return Scaffold(
      key: _scaffoldKey,
      drawer: HarbrDrawer(page: HarbrModule.DASHBOARD.key),
      appBar: _appBar(),
      body: Row(
        children: [
          HarbrNavRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: _destinations,
          ),
          VerticalDivider(
            thickness: 1.0,
            width: 1.0,
            color: harbr.border,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                HomePage(key: profileKey),
                ModulesPage(key: profileKey),
                CalendarPage(key: profileKey),
                const ActivitiesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'Harbr',
      useDrawer: true,
      scrollControllers: HomeNavigationBar.scrollControllers,
      actions: [SwitchViewAction(selectedIndex: _selectedIndex)],
    );
  }
}
