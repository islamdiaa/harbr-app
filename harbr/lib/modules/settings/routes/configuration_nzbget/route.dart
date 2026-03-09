import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/nzbget.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationNZBGetRoute extends StatefulWidget {
  const ConfigurationNZBGetRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationNZBGetRoute> createState() => _State();
}

class _State extends State<ConfigurationNZBGetRoute>
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
      title: HarbrModule.NZBGET.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrModule.NZBGET.informationBanner(),
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
        title: 'settings.EnableModule'.tr(args: [HarbrModule.NZBGET.title]),
        trailing: HarbrSwitch(
          value: HarbrProfile.current.nzbgetEnabled,
          onChanged: (value) {
            HarbrProfile.current.nzbgetEnabled = value;
            HarbrProfile.current.save();
            context.read<NZBGetState>().reset();
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
          text: 'settings.ConnectionDetailsDescription'
              .tr(args: [HarbrModule.NZBGET.title]),
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_NZBGET_CONNECTION_DETAILS.go,
    );
  }

  Widget _defaultPagesPage() {
    return HarbrBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_NZBGET_DEFAULT_PAGES.go,
    );
  }
}
