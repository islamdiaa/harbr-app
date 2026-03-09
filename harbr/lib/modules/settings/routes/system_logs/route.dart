import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/router/routes/settings.dart';
import 'package:harbr/system/filesystem/filesystem.dart';
import 'package:harbr/types/log_type.dart';

class SystemLogsRoute extends StatefulWidget {
  const SystemLogsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SystemLogsRoute> createState() => _State();
}

class _State extends State<SystemLogsRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'settings.Logs'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomActionBar() {
    return HarbrBottomActionBar(
      actions: [
        _exportLogs(),
        _clearLogs(),
      ],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrBlock(
          title: 'settings.AllLogs'.tr(),
          body: [TextSpan(text: 'settings.AllLogsDescription'.tr())],
          trailing: const HarbrIconButton(icon: Icons.developer_mode_rounded),
          onTap: () async => _viewLogs(null),
        ),
        ...List.generate(
          HarbrLogType.values.length,
          (index) {
            if (HarbrLogType.values[index].enabled)
              return HarbrBlock(
                title: HarbrLogType.values[index].title,
                body: [TextSpan(text: HarbrLogType.values[index].description)],
                trailing: HarbrIconButton(icon: HarbrLogType.values[index].icon),
                onTap: () async => _viewLogs(HarbrLogType.values[index]),
              );
            return Container(height: 0.0);
          },
        ),
      ],
    );
  }

  Future<void> _viewLogs(HarbrLogType? type) async {
    SettingsRoutes.SYSTEM_LOGS_DETAILS.go(params: {
      'type': type?.key ?? 'all',
    });
  }

  Widget _clearLogs() {
    return HarbrButton.text(
      text: 'settings.Clear'.tr(),
      icon: HarbrIcons.DELETE,
      color: HarbrColours.red,
      onTap: () async {
        bool result = await SettingsDialogs().clearLogs(context);
        if (result) {
          HarbrLogger().clear();
          showHarbrSuccessSnackBar(
            title: 'settings.LogsCleared'.tr(),
            message: 'settings.LogsClearedDescription'.tr(),
          );
        }
      },
    );
  }

  Widget _exportLogs() {
    return Builder(
      builder: (context) => HarbrButton.text(
        text: 'settings.Export'.tr(),
        icon: HarbrIcons.DOWNLOAD,
        onTap: () async {
          String data = await HarbrLogger().export();
          bool result = await HarbrFileSystem()
              .save(context, 'logs.json', utf8.encode(data));
          if (result)
            showHarbrSuccessSnackBar(
                title: 'settings.ExportedLogs'.tr(),
                message: 'settings.ExportedLogsMessage'.tr());
        },
      ),
    );
  }
}
