import 'package:flutter/material.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/nzbget.dart';
import 'package:harbr/modules/sabnzbd/routes.dart';
import 'package:harbr/utils/dialogs.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';
import 'package:harbr/widgets/ui.dart';

class DownloadClientSheet extends HarbrBottomModalSheet {
  Future<HarbrModule?> getDownloadClient() async {
    final profile = HarbrProfile.current;
    final nzbget = profile.nzbgetEnabled;
    final sabnzbd = profile.sabnzbdEnabled;

    if (nzbget && sabnzbd) {
      return HarbrDialogs().selectDownloadClient();
    }
    if (nzbget) {
      return HarbrModule.NZBGET;
    }
    if (sabnzbd) {
      return HarbrModule.SABNZBD;
    }

    return null;
  }

  @override
  Future<dynamic> show({
    Widget Function(BuildContext context)? builder,
  }) async {
    final module = await getDownloadClient();
    if (module != null) {
      return showModal(builder: (context) {
        if (module == HarbrModule.SABNZBD) {
          return const SABnzbdRoute(showDrawer: false);
        }
        if (module == HarbrModule.NZBGET) {
          return const NZBGetRoute(showDrawer: false);
        }
        return InvalidRoutePage();
      });
    }
  }
}
