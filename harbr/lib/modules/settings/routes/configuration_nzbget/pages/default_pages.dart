import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/tables/nzbget.dart';
import 'package:harbr/modules/nzbget.dart';

class ConfigurationNZBGetDefaultPagesRoute extends StatefulWidget {
  const ConfigurationNZBGetDefaultPagesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationNZBGetDefaultPagesRoute> createState() => _State();
}

class _State extends State<ConfigurationNZBGetDefaultPagesRoute>
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
    const _db = NZBGetDatabase.NAVIGATION_INDEX;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'harbr.Home'.tr(),
        body: [TextSpan(text: NZBGetNavigationBar.titles[_db.read()])],
        trailing: HarbrIconButton(
          icon: NZBGetNavigationBar.icons[_db.read()],
        ),
        onTap: () async {
          List values = await NZBGetDialogs.defaultPage(context);
          if (values[0]) _db.update(values[1]);
        },
      ),
    );
  }
}
