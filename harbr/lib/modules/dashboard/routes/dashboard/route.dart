import 'package:flutter/material.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/database/tables/dashboard.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/pages/calendar.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/pages/modules.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/switch_view_action.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

class DashboardRoute extends StatefulWidget {
  const DashboardRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardRoute> createState() => _State();
}

class _State extends State<DashboardRoute> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TabController _tabController;

  // Keep a PageController around for the SwitchViewAction widget which
  // still expects one to know when the calendar tab is visible.
  HarbrPageController? _pageController;

  @override
  void initState() {
    super.initState();
    int page = DashboardDatabase.NAVIGATION_INDEX.read();
    _tabController = TabController(
      length: 2,
      initialIndex: page,
      vsync: this,
    );
    _pageController = HarbrPageController(initialPage: page);

    // Keep the legacy page controller in sync with the tab controller so
    // widgets like SwitchViewAction continue to work.
    _tabController.addListener(_syncPageController);
  }

  void _syncPageController() {
    if (_tabController.indexIsChanging) return;
    final idx = _tabController.index;
    if (_pageController?.page?.round() != idx) {
      _pageController?.jumpToPage(idx);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_syncPageController);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.DASHBOARD,
      body: _body(),
      appBar: _appBar(),
      drawer: HarbrDrawer(page: HarbrModule.DASHBOARD.key),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'Harbr',
      useDrawer: true,
      scrollControllers: HomeNavigationBar.scrollControllers,
      pageController: _pageController,
      actions: [SwitchViewAction(pageController: _pageController)],
      bottom: HarbrTabBar(
        tabs: HomeNavigationBar.titles,
        controller: _tabController,
      ),
    );
  }

  Widget _body() {
    return HarbrDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ModulesPage(key: ValueKey(HarbrDatabase.ENABLED_PROFILE.read())),
          CalendarPage(key: ValueKey(HarbrDatabase.ENABLED_PROFILE.read())),
        ],
      ),
    );
  }
}
