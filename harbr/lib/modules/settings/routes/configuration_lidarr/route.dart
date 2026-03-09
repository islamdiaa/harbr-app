import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationLidarrRoute extends StatefulWidget {
  const ConfigurationLidarrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationLidarrRoute> createState() => _State();
}

class _State extends State<ConfigurationLidarrRoute>
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
      title: HarbrModule.LIDARR.title,
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrModule.LIDARR.informationBanner(),
        _enabledToggle(),
        _connectionDetailsPage(),
        HarbrDivider(),
        _defaultPagesPage(),
        //_defaultPagesPage(),
      ],
    );
  }

  Widget _enabledToggle() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.EnableModule'.tr(args: [HarbrModule.LIDARR.title]),
        trailing: HarbrSwitch(
          value: HarbrProfile.current.lidarrEnabled,
          onChanged: (value) {
            HarbrProfile.current.lidarrEnabled = value;
            HarbrProfile.current.save();
            context.read<LidarrState>().reset();
          },
        ),
      ),
    );
  }

  Widget _connectionDetailsPage() {
    return HarbrBlock(
      title: 'settings.ConnectionDetails'.tr(),
      body: [
        TextSpan(
          text: 'settings.ConnectionDetailsDescription'.tr(
            args: [HarbrModule.LIDARR.title],
          ),
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_LIDARR_CONNECTION_DETAILS.go,
    );
  }

  Widget _defaultPagesPage() {
    return HarbrBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_LIDARR_DEFAULT_PAGES.go,
    );
  }
}
