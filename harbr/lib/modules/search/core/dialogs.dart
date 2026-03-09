import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/search.dart';
import 'package:harbr/utils/profile_tools.dart';

class SearchDialogs {
  Future<Tuple2<bool, SearchDownloadType?>> downloadResult(
      BuildContext context) async {
    bool _flag = false;
    SearchDownloadType? _type;

    void _setValues(bool flag, SearchDownloadType type) {
      _flag = flag;
      _type = type;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'search.Download'.tr(),
      customContent: HarbrDatabase.ENABLED_PROFILE.listenableBuilder(
        builder: (context, _) => HarbrDialog.content(
          children: [
            Padding(
              child: HarbrPopupMenuButton<String>(
                tooltip: 'harbr.ChangeProfiles'.tr(),
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          HarbrDatabase.ENABLED_PROFILE.read(),
                          style: const TextStyle(
                            fontSize: HarbrUI.FONT_SIZE_H3,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: HarbrColours.accent,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(bottom: 2.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: HarbrColours.accent,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                onSelected: (result) {
                  HapticFeedback.selectionClick();
                  HarbrProfileTools().changeTo(result);
                },
                itemBuilder: (context) {
                  return <PopupMenuEntry<String>>[
                    for (final profile in HarbrBox.profiles.keys.cast<String>())
                      PopupMenuItem<String>(
                        value: profile,
                        child: Text(
                          profile,
                          style: TextStyle(
                            fontSize: HarbrUI.FONT_SIZE_H3,
                            color: HarbrDatabase.ENABLED_PROFILE.read() ==
                                    profile
                                ? HarbrColours.accent
                                : Colors.white,
                          ),
                        ),
                      )
                  ];
                },
              ),
              padding: HarbrDialog.tileContentPadding()
                  .add(const EdgeInsets.only(bottom: 16.0)),
            ),
            if (HarbrProfile.current.sabnzbdEnabled)
              HarbrDialog.tile(
                icon: SearchDownloadType.SABNZBD.icon,
                iconColor: HarbrColours().byListIndex(0),
                text: SearchDownloadType.SABNZBD.name,
                onTap: () => _setValues(true, SearchDownloadType.SABNZBD),
              ),
            if (HarbrProfile.current.nzbgetEnabled)
              HarbrDialog.tile(
                icon: SearchDownloadType.NZBGET.icon,
                iconColor: HarbrColours().byListIndex(1),
                text: SearchDownloadType.NZBGET.name,
                onTap: () => _setValues(true, SearchDownloadType.NZBGET),
              ),
            HarbrDialog.tile(
              icon: SearchDownloadType.FILESYSTEM.icon,
              iconColor: HarbrColours().byListIndex(2),
              text: SearchDownloadType.FILESYSTEM.name,
              onTap: () => _setValues(true, SearchDownloadType.FILESYSTEM),
            ),
          ],
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _type);
  }
}
