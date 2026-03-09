import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationTautulliRoute extends StatefulWidget {
  const ConfigurationTautulliRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationTautulliRoute> createState() => _State();
}

class _State extends State<ConfigurationTautulliRoute>
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
      title: HarbrModule.TAUTULLI.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrModule.TAUTULLI.informationBanner(),
        _enabledToggle(),
        _connectionDetailsPage(),
        HarbrDivider(),
        _activityRefreshRate(),
        _defaultPagesPage(),
        _defaultTerminationMessage(),
        _statisticsItemCount(),
      ],
    );
  }

  Widget _enabledToggle() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.EnableModule'.tr(args: [HarbrModule.TAUTULLI.title]),
        trailing: HarbrSwitch(
          value: HarbrProfile.current.tautulliEnabled,
          onChanged: (value) {
            HarbrProfile.current.tautulliEnabled = value;
            HarbrProfile.current.save();
            context.read<TautulliState>().reset();
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
            args: [HarbrModule.TAUTULLI.title],
          ),
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_TAUTULLI_CONNECTION_DETAILS.go,
    );
  }

  Widget _defaultPagesPage() {
    return HarbrBlock(
      title: 'settings.DefaultPages'.tr(),
      body: [TextSpan(text: 'settings.DefaultPagesDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_TAUTULLI_DEFAULT_PAGES.go,
    );
  }

  Widget _defaultTerminationMessage() {
    const _db = TautulliDatabase.TERMINATION_MESSAGE;
    return _db.listenableBuilder(
      builder: (context, _) {
        String message = _db.read();
        return HarbrBlock(
          title: 'tautulli.DefaultTerminationMessage'.tr(),
          body: [
            TextSpan(text: message.isEmpty ? 'harbr.NotSet'.tr() : message),
          ],
          trailing: const HarbrIconButton(icon: Icons.videocam_off_rounded),
          onTap: () async {
            Tuple2<bool, String> result =
                await TautulliDialogs.setTerminationMessage(context);
            if (result.item1) _db.update(result.item2);
          },
        );
      },
    );
  }

  Widget _activityRefreshRate() {
    const _db = TautulliDatabase.REFRESH_RATE;
    return _db.listenableBuilder(builder: (context, _) {
      String refreshRate = _db.read() == 1
          ? 'harbr.EverySecond'.tr()
          : 'harbr.EverySeconds'.tr(args: [_db.read().toString()]);
      return HarbrBlock(
        title: 'tautulli.ActivityRefreshRate'.tr(),
        body: [TextSpan(text: refreshRate)],
        trailing: const HarbrIconButton(icon: HarbrIcons.REFRESH),
        onTap: () async {
          List<dynamic> _values = await TautulliDialogs.setRefreshRate(context);
          if (_values[0]) _db.update(_values[1]);
        },
      );
    });
  }

  Widget _statisticsItemCount() {
    const _db = TautulliDatabase.STATISTICS_STATS_COUNT;
    return _db.listenableBuilder(
      builder: (context, _) {
        String statisticsItems = _db.read() == 1
            ? 'harbr.OneItem'.tr()
            : 'harbr.Items'.tr(args: [_db.read().toString()]);
        return HarbrBlock(
          title: 'tautulli.StatisticsItemCount'.tr(),
          body: [TextSpan(text: statisticsItems)],
          trailing: const HarbrIconButton(icon: Icons.format_list_numbered),
          onTap: () async {
            List<dynamic> _values =
                await TautulliDialogs.setStatisticsItemCount(context);
            if (_values[0]) _db.update(_values[1]);
          },
        );
      },
    );
  }
}
