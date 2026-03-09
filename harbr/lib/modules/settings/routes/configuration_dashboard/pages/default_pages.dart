import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/tables/dashboard.dart';

import 'package:harbr/modules/dashboard/core/dialogs.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

class ConfigurationDashboardDefaultPagesRoute extends StatefulWidget {
  const ConfigurationDashboardDefaultPagesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationDashboardDefaultPagesRoute> createState() => _State();
}

class _State extends State<ConfigurationDashboardDefaultPagesRoute>
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
      title: 'settings.DefaultPages'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        _homePage(),
      ],
    );
  }

  Widget _homePage() {
    const _db = DashboardDatabase.NAVIGATION_INDEX;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'harbr.Home'.tr(),
        body: [TextSpan(text: HomeNavigationBar.titles[_db.read()])],
        trailing: HarbrIconButton(icon: HomeNavigationBar.icons[_db.read()]),
        onTap: () async {
          final values = await DashboardDialogs().defaultPage(context);
          if (values.item1) _db.update(values.item2);
        },
      ),
    );
  }
}
