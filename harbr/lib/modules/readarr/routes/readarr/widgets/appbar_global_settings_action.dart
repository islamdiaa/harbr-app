import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrAppBarGlobalSettingsAction extends StatelessWidget {
  const ReadarrAppBarGlobalSettingsAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async {
        await _showSettingsMenu(context);
      },
    );
  }

  Future<void> _showSettingsMenu(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(HarbrUI.BORDER_RADIUS),
          topRight: Radius.circular(HarbrUI.BORDER_RADIUS),
        ),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HarbrBlock(
            title: 'readarr.UpdateLibrary'.tr(),
            onTap: () {
              Navigator.of(context).pop();
              ReadarrAPIController().updateLibrary(context: context);
            },
            trailing: const HarbrIconButton(
              icon: Icons.autorenew_rounded,
            ),
          ),
          HarbrBlock(
            title: 'readarr.RunRSSSync'.tr(),
            onTap: () {
              Navigator.of(context).pop();
              ReadarrAPIController().runRSSSync(context: context);
            },
            trailing: const HarbrIconButton(
              icon: Icons.rss_feed_rounded,
            ),
          ),
          HarbrBlock(
            title: 'readarr.BackupDatabase'.tr(),
            onTap: () {
              Navigator.of(context).pop();
              ReadarrAPIController().backupDatabase(context: context);
            },
            trailing: const HarbrIconButton(
              icon: Icons.save_rounded,
            ),
          ),
          HarbrBlock(
            title: 'readarr.RescanFolders'.tr(),
            onTap: () {
              Navigator.of(context).pop();
              ReadarrAPIController().rescanFolders(context: context);
            },
            trailing: const HarbrIconButton(
              icon: Icons.find_in_page_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
