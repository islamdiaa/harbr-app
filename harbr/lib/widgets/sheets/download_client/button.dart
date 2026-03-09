import 'package:flutter/material.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/widgets/sheets/download_client/sheet.dart';
import 'package:harbr/widgets/ui.dart';

class DownloadClientButton extends StatelessWidget {
  const DownloadClientButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_shouldShow) {
      return HarbrIconButton.appBar(
        icon: HarbrIcons.DOWNLOAD,
        onPressed: DownloadClientSheet().show,
      );
    }
    return const SizedBox();
  }

  bool get _shouldShow {
    final profile = HarbrProfile.current;
    return profile.sabnzbdEnabled || profile.nzbgetEnabled;
  }
}
