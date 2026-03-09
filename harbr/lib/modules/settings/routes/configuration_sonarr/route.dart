import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationSonarrRoute extends StatefulWidget {
  const ConfigurationSonarrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationSonarrRoute> createState() => _State();
}

class _State extends State<ConfigurationSonarrRoute>
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
      title: HarbrModule.SONARR.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrModule.SONARR.informationBanner(),
        _enabledToggle(),
        _connectionDetailsPage(),
        HarbrDivider(),
        _defaultOptionsPage(),
        _defaultPagesPage(),
        _queueSize(),
      ],
    );
  }

  Widget _enabledToggle() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.EnableModule'.tr(args: [HarbrModule.SONARR.title]),
        trailing: HarbrSwitch(
          value: HarbrProfile.current.sonarrEnabled,
          onChanged: (value) {
            HarbrProfile.current.sonarrEnabled = value;
            HarbrProfile.current.save();
            context.read<SonarrState>().reset();
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
            args: [HarbrModule.SONARR.title],
          ),
        )
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_SONARR_CONNECTION_DETAILS.go,
    );
  }

  Widget _defaultPagesPage() {
    return HarbrBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_SONARR_DEFAULT_PAGES.go,
    );
  }

  Widget _defaultOptionsPage() {
    return HarbrBlock(
      title: 'settings.DefaultOptions'.tr(),
      body: [
        TextSpan(text: 'settings.DefaultOptionsDescription'.tr()),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_SONARR_DEFAULT_OPTIONS.go,
    );
  }

  Widget _queueSize() {
    const _db = SonarrDatabase.QUEUE_PAGE_SIZE;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'sonarr.QueueSize'.tr(),
        body: [
          TextSpan(
            text: _db.read() == 1
                ? 'harbr.OneItem'.tr()
                : 'harbr.Items'.tr(args: [_db.read().toString()]),
          ),
        ],
        trailing: const HarbrIconButton(icon: Icons.queue_play_next_rounded),
        onTap: () async {
          Tuple2<bool, int> result =
              await SonarrDialogs().setQueuePageSize(context);
          if (result.item1) _db.update(result.item2);
        },
      ),
    );
  }
}
