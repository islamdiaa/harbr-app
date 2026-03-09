import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/system/quick_actions/quick_actions.dart';

class ConfigurationQuickActionsRoute extends StatefulWidget {
  const ConfigurationQuickActionsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationQuickActionsRoute> createState() => _State();
}

class _State extends State<ConfigurationQuickActionsRoute>
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
      scrollControllers: [scrollController],
      title: 'settings.QuickActions'.tr(),
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        SettingsBanners.QUICK_ACTIONS_SUPPORT.banner(),
        _actionTile(
          HarbrModule.LIDARR.title,
          HarbrDatabase.QUICK_ACTIONS_LIDARR,
        ),
        _actionTile(
          HarbrModule.NZBGET.title,
          HarbrDatabase.QUICK_ACTIONS_NZBGET,
        ),
        if (HarbrModule.OVERSEERR.featureFlag)
          _actionTile(
            HarbrModule.OVERSEERR.title,
            HarbrDatabase.QUICK_ACTIONS_OVERSEERR,
          ),
        _actionTile(
          HarbrModule.RADARR.title,
          HarbrDatabase.QUICK_ACTIONS_RADARR,
        ),
        _actionTile(
          HarbrModule.SABNZBD.title,
          HarbrDatabase.QUICK_ACTIONS_SABNZBD,
        ),
        _actionTile(
          HarbrModule.SEARCH.title,
          HarbrDatabase.QUICK_ACTIONS_SEARCH,
        ),
        _actionTile(
          HarbrModule.SONARR.title,
          HarbrDatabase.QUICK_ACTIONS_SONARR,
        ),
        _actionTile(
          HarbrModule.TAUTULLI.title,
          HarbrDatabase.QUICK_ACTIONS_TAUTULLI,
        ),
      ],
    );
  }

  Widget _actionTile(String title, HarbrDatabase action) {
    return HarbrBlock(
      title: title,
      trailing: HarbrBox.harbr.listenableBuilder(
        selectKeys: [action.key],
        builder: (context, _) => HarbrSwitch(
          value: action.read(),
          onChanged: (value) {
            action.update(value);
            if (HarbrQuickActions.isSupported)
              HarbrQuickActions().setActionItems();
          },
        ),
      ),
    );
  }
}
