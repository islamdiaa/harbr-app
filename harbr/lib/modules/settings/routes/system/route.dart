import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/database/database.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/modules/settings/routes/system/widgets/backup_tile.dart';
import 'package:harbr/modules/settings/routes/system/widgets/restore_tile.dart';
import 'package:harbr/router/routes/settings.dart';
import 'package:harbr/system/cache/image/image_cache.dart';

class SystemRoute extends StatefulWidget {
  const SystemRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SystemRoute> createState() => _State();
}

class _State extends State<SystemRoute> with HarbrScrollControllerMixin {
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
      title: 'settings.System'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: <Widget>[
        const SettingsSystemBackupRestoreBackupTile(),
        const SettingsSystemBackupRestoreRestoreTile(),
        HarbrDivider(),
        _logs(),
        _clearImageCache(),
        _clearConfiguration(),
      ],
    );
  }

  Widget _logs() {
    return HarbrBlock(
      title: 'settings.Logs'.tr(),
      body: [TextSpan(text: 'settings.LogsDescription'.tr())],
      trailing: const HarbrIconButton(icon: Icons.developer_mode_rounded),
      onTap: SettingsRoutes.SYSTEM_LOGS.go,
    );
  }

  Widget _clearImageCache() {
    return HarbrBlock(
      title: 'settings.ClearImageCache'.tr(),
      body: [TextSpan(text: 'settings.ClearImageCacheDescription'.tr())],
      trailing: const HarbrIconButton(icon: Icons.image_not_supported_rounded),
      onTap: () async {
        bool result = await SettingsDialogs().clearImageCache(context);
        if (result) {
          result = await HarbrImageCache().clear();
          if (result) {
            showHarbrSuccessSnackBar(
              title: 'settings.ImageCacheCleared'.tr(),
              message: 'settings.ImageCacheClearedDescription'.tr(),
            );
          } else {
            showHarbrErrorSnackBar(
              title: 'settings.FailedToClearImageCache'.tr(),
              message: 'settings.FailedToClearImageCacheDescription'.tr(),
            );
          }
        }
      },
    );
  }

  Widget _clearConfiguration() {
    return HarbrBlock(
      title: 'settings.ClearConfiguration'.tr(),
      body: [TextSpan(text: 'settings.CleanSlate'.tr())],
      trailing: const HarbrIconButton(icon: Icons.delete_sweep_rounded),
      onTap: () async {
        bool result = await SettingsDialogs().clearConfiguration(context);
        if (result) {
          HarbrDB().bootstrap();
          HarbrState.reset(context);
          showHarbrSuccessSnackBar(
            title: 'settings.ConfigurationCleared'.tr(),
            message: 'settings.ConfigurationClearedDescription'.tr(),
          );
        }
      },
    );
  }
}
