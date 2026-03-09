import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationRadarrRoute extends StatefulWidget {
  const ConfigurationRadarrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationRadarrRoute> createState() => _State();
}

class _State extends State<ConfigurationRadarrRoute>
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
      title: HarbrModule.RADARR.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrModule.RADARR.informationBanner(),
        _enabledToggle(),
        _connectionDetailsPage(),
        HarbrDivider(),
        _defaultOptionsPage(),
        _defaultPagesPage(),
        _discoverUseRadarrSuggestionsToggle(),
        _queueSize(),
      ],
    );
  }

  Widget _enabledToggle() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.EnableModule'.tr(args: [HarbrModule.RADARR.title]),
        trailing: HarbrSwitch(
          value: HarbrProfile.current.radarrEnabled,
          onChanged: (value) {
            HarbrProfile.current.radarrEnabled = value;
            HarbrProfile.current.save();
            context.read<RadarrState>().reset();
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
            args: [HarbrModule.RADARR.title],
          ),
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_RADARR_CONNECTION_DETAILS.go,
    );
  }

  Widget _defaultOptionsPage() {
    return HarbrBlock(
      title: 'settings.DefaultOptions'.tr(),
      body: [TextSpan(text: 'settings.DefaultOptionsDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_RADARR_DEFAULT_OPTIONS.go,
    );
  }

  Widget _defaultPagesPage() {
    return HarbrBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_RADARR_DEFAULT_PAGES.go,
    );
  }

  Widget _discoverUseRadarrSuggestionsToggle() {
    const _db = RadarrDatabase.ADD_DISCOVER_USE_SUGGESTIONS;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'radarr.DiscoverSuggestions'.tr(),
        body: [TextSpan(text: 'radarr.DiscoverSuggestionsDescription'.tr())],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: (value) => _db.update(value),
        ),
      ),
    );
  }

  Widget _queueSize() {
    const _db = RadarrDatabase.QUEUE_PAGE_SIZE;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'radarr.QueueSize'.tr(),
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
              await RadarrDialogs().setQueuePageSize(context);
          if (result.item1) _db.update(result.item2);
        },
      ),
    );
  }
}
