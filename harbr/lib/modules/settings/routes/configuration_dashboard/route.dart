import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationDashboardRoute extends StatefulWidget {
  const ConfigurationDashboardRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationDashboardRoute> createState() => _State();
}

class _State extends State<ConfigurationDashboardRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'Dashboard',
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        _calendarSettingsPage(),
        _defaultPagesPage(),
      ],
    );
  }

  Widget _defaultPagesPage() {
    return HarbrBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_DASHBOARD_DEFAULT_PAGES.go,
    );
  }

  Widget _calendarSettingsPage() {
    return HarbrBlock(
      title: 'settings.CalendarSettings'.tr(),
      body: [TextSpan(text: 'settings.CalendarSettingsDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_DASHBOARD_CALENDAR.go,
    );
  }
}
