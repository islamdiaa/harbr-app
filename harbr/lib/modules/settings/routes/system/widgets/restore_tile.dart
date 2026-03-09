import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/database/config.dart';
import 'package:harbr/system/filesystem/file.dart';
import 'package:harbr/system/filesystem/filesystem.dart';

class SettingsSystemBackupRestoreRestoreTile extends StatelessWidget {
  const SettingsSystemBackupRestoreRestoreTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'settings.RestoreFromDevice'.tr(),
      body: [TextSpan(text: 'settings.RestoreFromDeviceDescription'.tr())],
      trailing: const HarbrIconButton(icon: Icons.download_rounded),
      onTap: () async => _restore(context),
    );
  }

  Future<void> _restore(BuildContext context) async {
    try {
      HarbrFile? file = await HarbrFileSystem().read(context, ['harbr']);
      if (file != null) await _decryptBackup(context, file);
    } catch (error, stack) {
      HarbrLogger().error('Failed to restore device backup', error, stack);
      showHarbrErrorSnackBar(
        title: 'settings.RestoreFromCloudFailure'.tr(),
        error: error,
      );
    }
  }

  Future<void> _decryptBackup(
    BuildContext context,
    HarbrFile file,
  ) async {
    String encrypted = String.fromCharCodes(file.data);
    try {
      await HarbrConfig().import(context, encrypted);
      showHarbrSuccessSnackBar(
        title: 'settings.RestoreFromCloudSuccess'.tr(),
        message: 'settings.RestoreFromCloudSuccessMessage'.tr(),
      );
    } catch (_) {
      showHarbrErrorSnackBar(
        title: 'settings.RestoreFromCloudFailure'.tr(),
        message: 'harbr.IncorrectEncryptionKey'.tr(),
        showButton: true,
        buttonText: 'harbr.Retry'.tr(),
        buttonOnPressed: () async => _decryptBackup(context, file),
      );
    }
  }
}
