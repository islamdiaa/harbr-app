import 'package:flutter/material.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/database/tables/dashboard.dart';
import 'package:harbr/database/tables/harbr.dart';
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

class _State extends State<DashboardRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrPageController? _pageController;

  @override
  void initState() {
    super.initState();

    int page = DashboardDatabase.NAVIGATION_INDEX.read();
    _pageController = HarbrPageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.DASHBOARD,
      body: _body(),
      appBar: _appBar(),
      drawer: HarbrDrawer(page: HarbrModule.DASHBOARD.key),
      bottomNavigationBar: HomeNavigationBar(pageController: _pageController),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'Harbr',
      useDrawer: true,
      scrollControllers: HomeNavigationBar.scrollControllers,
      pageController: _pageController,
      actions: [SwitchViewAction(pageController: _pageController)],
    );
  }

  Widget _body() {
    return HarbrDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => HarbrPageView(
        controller: _pageController,
        children: [
          ModulesPage(key: ValueKey(HarbrDatabase.ENABLED_PROFILE.read())),
          CalendarPage(key: ValueKey(HarbrDatabase.ENABLED_PROFILE.read())),
        ],
      ),
    );
  }
}
