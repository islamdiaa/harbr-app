import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/log.dart';
import 'package:harbr/modules/settings/routes/system_logs/widgets/log_tile.dart';
import 'package:harbr/types/log_type.dart';

class SystemLogsDetailsRoute extends StatefulWidget {
  final HarbrLogType? type;

  const SystemLogsDetailsRoute({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<SystemLogsDetailsRoute> createState() => _State();
}

class _State extends State<SystemLogsDetailsRoute>
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
      title: 'settings.Logs'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrBox.logs.listenableBuilder(builder: (context, _) {
      List<HarbrLog> logs = filter();
      if (logs.isEmpty) {
        return HarbrMessage.goBack(
          context: context,
          text: 'settings.NoLogsFound'.tr(),
        );
      }
      return HarbrListViewBuilder(
        controller: scrollController,
        itemCount: logs.length,
        itemBuilder: (context, index) => SettingsSystemLogTile(
          log: logs[index],
        ),
      );
    });
  }

  List<HarbrLog> filter() {
    List<HarbrLog> logs;
    const box = HarbrBox.logs;

    switch (widget.type) {
      case HarbrLogType.WARNING:
        logs =
            box.data.where((log) => log.type == HarbrLogType.WARNING).toList();
        break;
      case HarbrLogType.ERROR:
        logs = box.data.where((log) => log.type == HarbrLogType.ERROR).toList();
        break;
      case HarbrLogType.CRITICAL:
        logs =
            box.data.where((log) => log.type == HarbrLogType.CRITICAL).toList();
        break;
      case HarbrLogType.DEBUG:
        logs = box.data.where((log) => log.type == HarbrLogType.DEBUG).toList();
        break;
      default:
        logs = box.data.where((log) => log.type.enabled).toList();
        break;
    }
    logs.sort((a, b) => (b.timestamp).compareTo(a.timestamp));
    return logs;
  }
}
