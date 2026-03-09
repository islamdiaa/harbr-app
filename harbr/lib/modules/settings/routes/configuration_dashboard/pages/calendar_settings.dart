import 'package:flutter/material.dart';
import 'package:harbr/database/tables/dashboard.dart';
import 'package:harbr/vendor.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_day.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_size.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_type.dart';
import 'package:harbr/modules/dashboard/core/dialogs.dart';
import 'package:harbr/modules/settings/core/dialogs.dart';

class ConfigurationDashboardCalendarRoute extends StatefulWidget {
  const ConfigurationDashboardCalendarRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationDashboardCalendarRoute> createState() => _State();
}

class _State extends State<ConfigurationDashboardCalendarRoute>
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
      title: 'settings.CalendarSettings'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        _futureDays(),
        _pastDays(),
        HarbrDivider(),
        _startingDay(),
        _startingSize(),
        _startingView(),
        HarbrDivider(),
        _modulesLidarr(),
        _modulesRadarr(),
        _modulesSonarr(),
      ],
    );
  }

  Widget _pastDays() {
    const _db = DashboardDatabase.CALENDAR_DAYS_PAST;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.PastDays'.tr(),
        body: [
          TextSpan(
            text: _db.read() == 1
                ? 'settings.DaysOne'.tr()
                : 'settings.DaysCount'.tr(args: [_db.read().toString()]),
          ),
        ],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, int> result =
              await DashboardDialogs().setPastDays(context);
          if (result.item1) _db.update(result.item2);
        },
      ),
    );
  }

  Widget _futureDays() {
    const _db = DashboardDatabase.CALENDAR_DAYS_FUTURE;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.FutureDays'.tr(),
        body: [
          TextSpan(
            text: _db.read() == 1
                ? 'settings.DaysOne'.tr()
                : 'settings.DaysCount'.tr(args: [_db.read().toString()]),
          ),
        ],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, int> result =
              await DashboardDialogs().setFutureDays(context);
          if (result.item1) _db.update(result.item2);
        },
      ),
    );
  }

  Widget _modulesLidarr() {
    const _db = DashboardDatabase.CALENDAR_ENABLE_LIDARR;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: HarbrModule.LIDARR.title,
        body: [
          TextSpan(
            text: 'settings.ShowCalendarEntries'.tr(
              args: [HarbrModule.LIDARR.title],
            ),
          )
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }

  Widget _modulesRadarr() {
    const _db = DashboardDatabase.CALENDAR_ENABLE_RADARR;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: HarbrModule.RADARR.title,
        body: [
          TextSpan(
            text: 'settings.ShowCalendarEntries'.tr(
              args: [HarbrModule.RADARR.title],
            ),
          )
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }

  Widget _modulesSonarr() {
    const _db = DashboardDatabase.CALENDAR_ENABLE_SONARR;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: HarbrModule.SONARR.title,
        body: [
          TextSpan(
            text: 'settings.ShowCalendarEntries'.tr(
              args: [HarbrModule.SONARR.title],
            ),
          )
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }

  Widget _startingView() {
    const _db = DashboardDatabase.CALENDAR_STARTING_TYPE;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.StartingView'.tr(),
        body: [
          TextSpan(text: _db.read().name),
        ],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, CalendarStartingType?> _values =
              await SettingsDialogs().editCalendarStartingView(context);
          if (_values.item1) _db.update(_values.item2!);
        },
      ),
    );
  }

  Widget _startingDay() {
    const _db = DashboardDatabase.CALENDAR_STARTING_DAY;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.StartingDay'.tr(),
        body: [
          TextSpan(text: _db.read().name),
        ],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, CalendarStartingDay?> results =
              await SettingsDialogs().editCalendarStartingDay(context);
          if (results.item1) _db.update(results.item2!);
        },
      ),
    );
  }

  Widget _startingSize() {
    const _db = DashboardDatabase.CALENDAR_STARTING_SIZE;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.StartingSize'.tr(),
        body: [
          TextSpan(text: _db.read().name),
        ],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, CalendarStartingSize?> _values =
              await SettingsDialogs().editCalendarStartingSize(context);
          if (_values.item1) _db.update(_values.item2!);
        },
      ),
    );
  }
}
