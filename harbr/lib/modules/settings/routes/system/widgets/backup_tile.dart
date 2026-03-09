import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/database/config.dart';
import 'package:harbr/system/filesystem/filesystem.dart';

class SettingsSystemBackupRestoreBackupTile extends StatelessWidget {
  const SettingsSystemBackupRestoreBackupTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'settings.BackupToDevice'.tr(),
      body: [TextSpan(text: 'settings.BackupToDeviceDescription'.tr())],
      trailing: const HarbrIconButton(icon: Icons.upload_rounded),
      onTap: () async => _backup(context),
    );
  }

  Future<void> _backup(BuildContext context) async {
    try {
      String data = HarbrConfig().export();
      String name = DateFormat('y-MM-dd kk-mm-ss').format(DateTime.now());
      bool result = await HarbrFileSystem().save(
        context,
        '$name.harbr',
        data.codeUnits,
      );
      if (result) {
        showHarbrSuccessSnackBar(
          title: 'settings.BackupToCloudSuccess'.tr(),
          message: '$name.harbr',
        );
      }
    } catch (error, stack) {
      HarbrLogger().error('Failed to create device backup', error, stack);
      showHarbrErrorSnackBar(
        title: 'settings.BackupToCloudFailure'.tr(),
        error: error,
      );
    }
  }
}
