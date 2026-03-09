import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sabnzbd.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationSABnzbdRoute extends StatefulWidget {
  const ConfigurationSABnzbdRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationSABnzbdRoute> createState() => _State();
}

class _State extends State<ConfigurationSABnzbdRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: HarbrModule.SABNZBD.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrModule.SABNZBD.informationBanner(),
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
        title: 'settings.EnableModule'.tr(args: [HarbrModule.SABNZBD.title]),
        trailing: HarbrSwitch(
          value: HarbrProfile.current.sabnzbdEnabled,
          onChanged: (value) {
            HarbrProfile.current.sabnzbdEnabled = value;
            HarbrProfile.current.save();
            context.read<SABnzbdState>().reset();
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
            args: [HarbrModule.SABNZBD.title],
          ),
        )
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_SABNZBD_CONNECTION_DETAILS.go,
    );
  }

  Widget _defaultPagesPage() {
    return HarbrBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_SABNZBD_DEFAULT_PAGES.go,
    );
  }
}
